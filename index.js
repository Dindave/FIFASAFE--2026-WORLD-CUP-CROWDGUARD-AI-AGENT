const functions = require('@google-cloud/functions-framework');
const { Client } = require('@elastic/elasticsearch');
const { VertexAI } = require('@google-cloud/vertexai');

// ── CONFIG ────────────────────────────────────────────────────────────────────
const PROJECT_ID = process.env.GOOGLE_CLOUD_PROJECT_ID;
const LOCATION = 'us-central1';
const MODEL = 'gemini-2.5-pro';
const ELASTIC_ENDPOINT = process.env.ELASTIC_ENDPOINT;
const ELASTIC_API_KEY = process.env.ELASTIC_API_KEY;

// ── ELASTICSEARCH CLIENT ──────────────────────────────────────────────────────
let esClient;
function getClient() {
  if (!esClient) {
    esClient = new Client({
      node: ELASTIC_ENDPOINT,
      auth: { apiKey: ELASTIC_API_KEY }
    });
  }
  return esClient;
}

// ── ELASTICSEARCH TOOL EXECUTORS ──────────────────────────────────────────────

// Find documents in an index
async function esFind(index, query = {}, limit = 20) {
  const client = getClient();
  const result = await client.search({
    index,
    size: limit,
    query: Object.keys(query).length > 0 ? {
      bool: {
        must: Object.entries(query).map(([key, val]) => ({ match: { [key]: val } }))
      }
    } : { match_all: {} }
  });
  return result.hits.hits.map(hit => ({ _id: hit._id, ...hit._source }));
}

// Insert a document — safely flattens objects to strings to prevent mapping conflicts
async function esInsert(index, document) {
  const client = getClient();
  const cleanDoc = {};
  for (const [key, val] of Object.entries(document)) {
    if (val === null || val === undefined) {
      cleanDoc[key] = null;
    } else if (typeof val === 'object') {
      cleanDoc[key] = JSON.stringify(val); // Stringify objects/arrays
    } else {
      cleanDoc[key] = val; // Keep strings, numbers, booleans as-is
    }
  }
  cleanDoc.created_at = new Date().toISOString();
  cleanDoc.updated_at = new Date().toISOString();
  const result = await client.index({ index, document: cleanDoc, refresh: true });
  return { id: result._id, success: true };
}

// Update a document by finding it first then updating
async function esUpdate(index, filter, update) {
  const client = getClient();
  const filterKey = Object.keys(filter)[0];
  const filterVal = filter[filterKey];
  const search = await client.search({
    index,
    size: 1,
    query: { match: { [filterKey]: filterVal } }
  });
  if (search.hits.hits.length === 0) return { success: false, error: 'Document not found' };
  const docId = search.hits.hits[0]._id;
  await client.update({
    index,
    id: docId,
    doc: { ...update, updated_at: new Date().toISOString() },
    refresh: true
  });
  return { success: true, updated_id: docId };
}

// Full text search
async function esSearch(index, queryText, limit = 20) {
  const client = getClient();
  const result = await client.search({
    index,
    size: limit,
    query: { multi_match: { query: queryText, fields: ['*'] } }
  });
  return result.hits.hits.map(hit => ({ _id: hit._id, ...hit._source }));
}

// ── TOOL EXECUTOR ─────────────────────────────────────────────────────────────
async function executeTool(toolName, params) {
  try {
    switch (toolName) {
      case 'es_find':
        return JSON.stringify(await esFind(params.index, params.filter || {}, params.limit || 20));
      case 'es_insert':
        return JSON.stringify(await esInsert(params.index, params.document));
      case 'es_update':
        return JSON.stringify(await esUpdate(params.index, params.filter, params.update));
      case 'es_search':
        return JSON.stringify(await esSearch(params.index, params.query, params.limit || 20));
      default:
        return JSON.stringify({ error: `Unknown tool: ${toolName}` });
    }
  } catch (err) {
    // Return error as string so agent can continue rather than crashing
    return JSON.stringify({ error: err.message, tool: toolName });
  }
}

// ── TOOL DEFINITIONS FOR GEMINI ───────────────────────────────────────────────
const TOOLS = [{
  functionDeclarations: [
    {
      name: 'es_find',
      description: 'Find documents in a CrowdGuard Elasticsearch index. Use for reading venues, crowd_density_readings, incidents, emergency_resources, advisories, agent_logs, lost_persons.',
      parameters: {
        type: 'OBJECT',
        properties: {
          index: { type: 'STRING', description: 'Index name: venues | crowd_density_readings | incidents | emergency_resources | advisories | agent_logs | lost_persons' },
          filter: { type: 'OBJECT', description: 'Key-value filter e.g. {"density_level": "critical"} or {"venue_id": "venue_metlife"}' },
          limit: { type: 'NUMBER', description: 'Max results to return. Default 20.' }
        },
        required: ['index']
      }
    },
    {
      name: 'es_insert',
      description: 'Insert a new document into a CrowdGuard index. Use for creating incidents, advisories, or agent log entries.',
      parameters: {
        type: 'OBJECT',
        properties: {
          index: { type: 'STRING', description: 'Target index name' },
          document: { type: 'OBJECT', description: 'The complete document to insert' }
        },
        required: ['index', 'document']
      }
    },
    {
      name: 'es_update',
      description: 'Update an existing document. Use for dispatching resources, resolving incidents, approving advisories.',
      parameters: {
        type: 'OBJECT',
        properties: {
          index: { type: 'STRING', description: 'Target index name' },
          filter: { type: 'OBJECT', description: 'Single key-value to find document e.g. {"resource_id": "res_med_001"}' },
          update: { type: 'OBJECT', description: 'Fields to update e.g. {"status": "dispatched"}' }
        },
        required: ['index', 'filter', 'update']
      }
    },
    {
      name: 'es_search',
      description: 'Full text search across a CrowdGuard index.',
      parameters: {
        type: 'OBJECT',
        properties: {
          index: { type: 'STRING', description: 'Target index name' },
          query: { type: 'STRING', description: 'Search text e.g. "crowd crush Gate C"' },
          limit: { type: 'NUMBER', description: 'Max results' }
        },
        required: ['index', 'query']
      }
    }
  ]
}];

// ── SYSTEM PROMPT ─────────────────────────────────────────────────────────────
const SYSTEM_PROMPT = `You are CrowdGuard, an AI crowd safety intelligence agent for the 2026 FIFA World Cup. You protect fans across all 16 host city venues by detecting crowd safety risks before they become emergencies.

YOUR TOOLS: Use es_find, es_insert, es_update, es_search to read and write Elasticsearch data.

YOUR INDEXES: venues, crowd_density_readings, incidents, emergency_resources, advisories, agent_logs, lost_persons.

YOUR MISSIONS (execute automatically in sequence):
1. CROWD MONITORING: Use es_find on crowd_density_readings. Find docs where density_level is critical or elevated.
2. CRISIS ASSESSMENT: Use es_find on venues to get zone details. Classify severity: WATCH / WARNING / CRITICAL / EMERGENCY.
3. RESOURCE DISPATCH: Use es_find on emergency_resources where status is available. Use es_update to set dispatched resources status to dispatched.
4. ADVISORY GENERATION: Use es_insert to write a multilingual advisory to advisories index with status pending_broadcast.

IMPORTANT RULES:
- Log every action to agent_logs using es_insert with simple string fields only
- Keep agent_log documents simple: {session_id, mission, step, action, output, status}
- Never broadcast advisory without status pending_broadcast
- Keep 30% of resources available at all times
- Use 🔴 CRITICAL | 🟠 WARNING | 🟡 WATCH | ✅ Normal
- End with clear NEXT STEP

STYLE: Direct and specific. "Gate C at 2.8 ppm — 40% above 2.0 threshold" not "Gate C is crowded."`;

// ── MAIN AGENT LOOP ───────────────────────────────────────────────────────────
async function runAgent(payload) {
  const vertexAI = new VertexAI({ project: PROJECT_ID, location: LOCATION });
  const model = vertexAI.getGenerativeModel({
    model: MODEL,
    systemInstruction: SYSTEM_PROMPT,
    tools: TOOLS
  });

  const sessionId = `sess_${Date.now()}`;
  const messages = [{
    role: 'user',
    parts: [{ text: `Session: ${sessionId}. Mission: ${payload.mission || 'crowd_monitoring'}. Begin now. Check all venues for crowd safety issues and execute all necessary missions.` }]
  }];

  let step = 0;
  let finalResponse = '';

  while (step < 25) {
    const result = await model.generateContent({ contents: messages });
    const candidate = result.response.candidates[0];
    const parts = candidate.content.parts;
    messages.push({ role: 'model', parts });

    const toolCalls = parts.filter(p => p.functionCall);
    if (toolCalls.length === 0) {
      finalResponse = parts.find(p => p.text)?.text || 'Mission complete.';
      break;
    }

    const toolResults = [];
    for (const part of toolCalls) {
      step++;
      console.log(`Step ${step}: ${part.functionCall.name}`, JSON.stringify(part.functionCall.args));
      const toolResult = await executeTool(part.functionCall.name, part.functionCall.args);
      toolResults.push({
        functionResponse: {
          name: part.functionCall.name,
          response: { content: toolResult }
        }
      });
    }
    messages.push({ role: 'user', parts: toolResults });
  }

  return { sessionId, response: finalResponse, steps: step };
}

// ── CLOUD FUNCTION ENTRY POINT ────────────────────────────────────────────────
functions.http('crowdGuardAgent', async (req, res) => {
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type');
  if (req.method === 'OPTIONS') { res.status(204).send(''); return; }

  try {
    const result = await runAgent(req.body || {});
    res.json({ success: true, ...result });
  } catch (error) {
    console.error('CrowdGuard error:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});