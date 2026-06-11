# 🛡️ FIFASAFE - CrowdGuard
### AI-Powered Crowd Safety Agent for FIFA World Cup 2026

> **Google Cloud Rapid Agent Hackathon 2026 — Elastic Partner Track**
> Built by Dinah David | Nigeria 🇳🇬

---

## 🎯 What Problem Does CrowdGuard Solve?

Imagine 80,000 fans rushing into a stadium at the same time.

Some gates get too packed. People push. It gets dangerous. And the people in charge only find out when someone gets hurt because they're watching with human eyes and radios, not smart technology.

**That's the problem CrowdGuard fixes.**

World Cup 2026 will bring **5 million fans** to 16 cities across the USA. Current safety systems wait for humans to notice a problem. CrowdGuard uses AI to notice problems **before they become emergencies** — automatically, across every venue, every minute.

Real disasters that had warning signs nobody caught in time:
- **Seoul Halloween Crush 2022** — 158 people died
- **Hillsborough 1989** — 97 people died
- **Ellis Park 2001** — 43 people died

CrowdGuard exists so these never happen again.

---

## 🤖 How CrowdGuard Works — Simply Explained

Think of CrowdGuard like a very smart security guard who:
1. **Watches every gate and zone** at every stadium at the same time
2. **Notices when a zone gets too crowded** before it becomes dangerous
3. **Calls for help automatically** — sends medical teams, security, crowd controllers
4. **Tells fans where to go** in their own language so they don't panic
5. **Writes a report** of everything it did so humans can review it later

It does all of this by itself, in under 60 seconds, without waiting for a human to press a button.

---

## Live Demo

Send one command → CrowdGuard detects a crisis, dispatches resources, generates a multilingual advisory:

```bash
curl -X POST https://us-central1-gen-lang-client-0198283110.cloudfunctions.net/crowdGuardAgent \
  -H "Content-Type: application/json" \
  -d '{"mission": "crowd_monitoring"}'
```

**Real response from CrowdGuard:**
```
🔴 CRITICAL | MetLife Stadium | Gate C

Situation: Crowd density at Gate C is 2.8 ppm, 40% over the 2.0 ppm 
safe threshold. The trend is rising fast.

Actions Taken:
1. Crisis Level Escalated: Severity classified as CRITICAL
2. Crowd Control Unit 1 dispatched to Gate C
3. Gate Management Team C dispatched to Gate C  
4. Medical Team Alpha dispatched to Gate C

Advisory Issued: Multilingual advisory generated and pending broadcast.

NEXT STEP: Awaiting confirmation of advisory broadcast.
```

---

## The 4 Agent Missions

CrowdGuard runs 4 missions automatically, one after another, like a chain:

```
TRIGGER (every 5 minutes or manual)
    ↓
Mission 1: CROWD MONITORING
    Read crowd density data from Elasticsearch
    Find any zones above safe threshold
    ↓
Mission 2: CRISIS ASSESSMENT  
    Look up venue layout and exit information
    Classify danger level: WATCH / WARNING / CRITICAL / EMERGENCY
    ↓
Mission 3: RESOURCE DISPATCH
    Find available medical teams, security, crowd controllers
    Send them to the dangerous zone
    Update their status in Elasticsearch
    ↓
Mission 4: ADVISORY GENERATION
    Write a safety message in multiple languages
    Save it to Elasticsearch ready for broadcast
    Human approves before it goes out to fans
```

---

## Architecture

```
                    ┌─────────────────────┐
                    │   Cloud Scheduler    │
                    │  (every 5 minutes)   │
                    └──────────┬──────────┘
                               │ triggers
                               ▼
                    ┌─────────────────────┐
                    │   Google Cloud       │
                    │   Functions          │
                    │  (crowdGuardAgent)   │
                    └──────────┬──────────┘
                               │ calls
                               ▼
                    ┌─────────────────────┐
                    │   Vertex AI          │
                    │   Gemini 2.0 Pro     │
                    │   (the AI brain)     │
                    └──────────┬──────────┘
                               │ reads & writes via tools
                               ▼
                    ┌─────────────────────┐
                    │   Elastic Cloud      │
                    │   Elasticsearch      │
                    │   (the database)     │
                    └──────────┬──────────┘
                               │ data flows to
                               ▼
                    ┌─────────────────────┐
                    │   Safety Dashboard   │
                    │   (Cloud Run)        │
                    │   Live incidents +   │
                    │   advisory approval  │
                    └─────────────────────┘
```

### What each part does:

| Part | What it is | What it does for CrowdGuard |
|------|-----------|---------------------------|
| **Google Cloud Functions** | Serverless code runner | Runs the agent when triggered |
| **Vertex AI Gemini 2.5 Pro** | Google's AI model | Reads the data and decides what to do |
| **Elastic Cloud (Elasticsearch)** | Search database | Stores all venue, crowd, incident, and resource data |
| **Cloud Scheduler** | Automatic timer | Triggers CrowdGuard every 5 minutes |
| **Cloud Run** | Website hosting | Shows the safety dashboard |

---

## 🗄️ Data Structure (Elasticsearch Indexes)

CrowdGuard stores 7 types of data in Elasticsearch:

| Index | What it stores |
|-------|---------------|
| `venues` | Stadium names, zones, exits, emergency contacts |
| `crowd_density_readings` | Real-time sensor data — how many people per zone |
| `incidents` | Every safety incident detected with full agent reasoning |
| `emergency_resources` | Medical teams, security units, their location and status |
| `advisories` | Multilingual fan safety messages waiting for approval |
| `agent_logs` | Every step the agent took — full audit trail |
| `lost_persons` | Lost fan reports, especially children |

---

## Tech Stack

- **AI Model:** Gemini 2.5 Pro via Google Cloud Vertex AI
- **Agent Runtime:** Google Cloud Functions (Node.js 22)
- **Database:** Elastic Cloud — Elasticsearch 8.x
- **Scheduler:** Google Cloud Scheduler
- **Hosting:** Google Cloud Run
- **Language:** JavaScript (Node.js)

---

##  How This Runs 

### What you need before starting:
- A Google Cloud account (free trial works — get $300 credits at cloud.google.com)
- An Elastic Cloud account (free 14-day trial at cloud.elastic.co)
- Node.js 22 installed on your computer

### Step 1 — Clone this repository
```bash
git clone https://github.com/YOUR_USERNAME/crowdguard-wc2026.git
cd crowdguard-wc2026
```

### Step 2 — Set up Elastic Cloud
1. Go to cloud.elastic.co → create a free deployment
2. Choose Google Cloud, region us-central1
3. Save your endpoint URL and API key

### Step 3 — Load the data into Elasticsearch
```bash
# Edit elastic.sh first — add your own endpoint and API key
bash elastic.sh
```

### Step 4 — Set up Google Cloud
```bash
# Install Google Cloud CLI, then:
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

### Step 5 — Deploy the agent
```bash
npm install

gcloud functions deploy crowdGuardAgent \
  --runtime nodejs22 \
  --trigger-http \
  --allow-unauthenticated \
  --region us-central1 \
  --source . \
  --timeout 300 \
  --set-env-vars ELASTIC_ENDPOINT="YOUR_ELASTIC_ENDPOINT",ELASTIC_API_KEY="YOUR_API_KEY",GOOGLE_CLOUD_PROJECT_ID="YOUR_PROJECT_ID"
```

### Step 6 — Test it
```bash
curl -X POST YOUR_CLOUD_FUNCTION_URL \
  -H "Content-Type: application/json" \
  -d '{"mission": "crowd_monitoring"}'
```

---

## 📁 Files in This Repository

```
crowdguard-wc2026/
│
├── index.js              ← The AI agent (main code)
├── package.json          ← Dependencies list
├── elastic.sh            ← Sets up Elasticsearch with data
├── README.md             ← This file
└── .env.example          ← Example environment variables
```

### What each file does:

**index.js** — This is the brain of CrowdGuard. It contains:
- The Elasticsearch connection code
- The 4 tool functions (find, insert, update, search)
- The instructions for Gemini (system prompt)
- The agent loop that keeps running until the mission is done

**package.json** — Tells Node.js which libraries to install:
- `@elastic/elasticsearch` — connects to Elastic Cloud
- `@google-cloud/vertexai` — calls Gemini AI
- `@google-cloud/functions-framework` — runs as a Cloud Function

**elastic.sh** — A setup script that:
- Creates all 7 Elasticsearch indexes
- Loads sample World Cup data (venues, crowd readings, resources)
- Ready to run in one command

---

## 🔐 Environment Variables

Copy `.env.example` to `.env` and fill in your values:

```
ELASTIC_ENDPOINT=https://your-cluster.us-central1.gcp.cloud.es.io:443
ELASTIC_API_KEY=your-api-key-here
GOOGLE_CLOUD_PROJECT_ID=your-project-id
```

**Never put real credentials in your code or push them to GitHub.**

---

## 📊 Severity Levels

| Level | What it means | Density above safe limit |
|-------|--------------|------------------------|
| ✅ Normal | Everything is fine | Below threshold |
| 🟡 WATCH | Getting busy — keep an eye on it | 10–25% above |
| 🟠 WARNING | Action needed soon | 25–50% above |
| 🔴 CRITICAL | Dispatch resources now | 50%+ above |
| 🚨 EMERGENCY | All hands on deck | 100%+ above |

---

## 👩‍💻 Built By

**Dinah David (Dee)**
AI Strategist
- LinkedIn: [linkedin.com/in/dinahdavid](https://linkedin.com/in/dinahdavid)

## 📄 License

MIT License — free to use, modify, and share.

---

*Built for the Google Cloud Rapid Agent Hackathon 2026 · Elastic Partner Track 