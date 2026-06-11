ENDPOINT="https://3f9290dca6bd4708b5d5aac529c9ab90.us-central1.gcp.cloud.es.io:443"
API_KEY="UjhmLW01NEJTSGowNk43QWR1em06UEJSQzlzU0ZvZnp0dVdZQWsyUURRZw=="

# Create indexes
for INDEX in venues crowd_density_readings incidents emergency_resources advisories agent_logs lost_persons; do
  curl -X PUT "$ENDPOINT/$INDEX" \
    -H "Authorization: ApiKey $API_KEY" #!/bin/bash
# CrowdGuard — Elasticsearch Seed Script
# Creates all indexes and loads seed data for the CrowdGuard AI Safety Agent
# Run: bash elastic.sh

ENDPOINT="https://3f9290dca6bd4708b5d5aac529c9ab90.us-central1.gcp.cloud.es.io:443"
API_KEY="UjhmLW01NEJTSGowNk43QWR1em06UEJSQzlzU0ZvZnp0dVdZQWsyUURRZw=="

echo "=== CrowdGuard Elasticsearch Setup ==="
echo "Creating indexes and loading seed data..."
echo ""

# Delete old indexes to clear bad mappings
echo "Clearing old indexes..."
curl -s -X DELETE "$ENDPOINT/venues,crowd_density_readings,incidents,emergency_resources,advisories,agent_logs,lost_persons" \
  -H "Authorization: ApiKey $API_KEY" > /dev/null
echo "Done."
echo ""

# Create indexes
echo "Creating indexes..."
for INDEX in venues crowd_density_readings incidents emergency_resources advisories agent_logs lost_persons; do
  RESULT=$(curl -s -X PUT "$ENDPOINT/$INDEX" \
    -H "Authorization: ApiKey $API_KEY" \
    -H "Content-Type: application/json" \
    -d '{"settings":{"number_of_replicas":0}}')
  echo "  $INDEX: $RESULT"
done
echo ""

# ── VENUES ────────────────────────────────────────────────────────────────────
echo "Loading venues (16 official FIFA World Cup 2026 host venues)..."

curl -s -X POST "$ENDPOINT/venues/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "venue_id":"venue_metlife","name":"MetLife Stadium",
    "city":"East Rutherford","state":"NJ","country":"US",
    "capacity":82500,"status":"active","special":"World Cup Final Host",
    "emergency_contacts":{"medical":"+12015550911","security":"+12015550112","fifa_officer":"+12015550200"},
    "zones":[
      {"zone_id":"gate_a","name":"Gate A North Entry","max_safe_density":2.5,"area_sqm":1200,"exits":4},
      {"zone_id":"gate_b","name":"Gate B South Entry","max_safe_density":2.5,"area_sqm":1400,"exits":6},
      {"zone_id":"gate_c","name":"Gate C East Concourse","max_safe_density":2.0,"area_sqm":800,"exits":2},
      {"zone_id":"lower_bowl","name":"Lower Bowl Seating","max_safe_density":1.8,"area_sqm":18000,"exits":16},
      {"zone_id":"concourse_main","name":"Main Concourse","max_safe_density":3.0,"area_sqm":5000,"exits":20}
    ]
  }' > /dev/null

curl -s -X POST "$ENDPOINT/venues/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"venue_id":"venue_sofi","name":"SoFi Stadium","city":"Inglewood","state":"CA","country":"US","capacity":70240,"status":"active"}' > /dev/null

curl -s -X POST "$ENDPOINT/venues/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"venue_id":"venue_att","name":"AT&T Stadium","city":"Arlington","state":"TX","country":"US","capacity":80000,"status":"active"}' > /dev/null

curl -s -X POST "$ENDPOINT/venues/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"venue_id":"venue_hardrock","name":"Hard Rock Stadium","city":"Miami Gardens","state":"FL","country":"US","capacity":65326,"status":"active"}' > /dev/null

curl -s -X POST "$ENDPOINT/venues/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"venue_id":"venue_mercedesbenz","name":"Mercedes-Benz Stadium","city":"Atlanta","state":"GA","country":"US","capacity":71000,"status":"active"}' > /dev/null

curl -s -X POST "$ENDPOINT/venues/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"venue_id":"venue_nrg","name":"NRG Stadium","city":"Houston","state":"TX","country":"US","capacity":72220,"status":"active"}' > /dev/null

curl -s -X POST "$ENDPOINT/venues/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"venue_id":"venue_levis","name":"Levis Stadium","city":"Santa Clara","state":"CA","country":"US","capacity":68500,"status":"active"}' > /dev/null

curl -s -X POST "$ENDPOINT/venues/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"venue_id":"venue_lincoln","name":"Lincoln Financial Field","city":"Philadelphia","state":"PA","country":"US","capacity":69796,"status":"active"}' > /dev/null

curl -s -X POST "$ENDPOINT/venues/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"venue_id":"venue_gillette","name":"Gillette Stadium","city":"Foxborough","state":"MA","country":"US","capacity":65878,"status":"active"}' > /dev/null

curl -s -X POST "$ENDPOINT/venues/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"venue_id":"venue_lumen","name":"Lumen Field","city":"Seattle","state":"WA","country":"US","capacity":68740,"status":"active"}' > /dev/null

curl -s -X POST "$ENDPOINT/venues/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"venue_id":"venue_arrowhead","name":"Arrowhead Stadium","city":"Kansas City","state":"MO","country":"US","capacity":76416,"status":"active"}' > /dev/null

curl -s -X POST "$ENDPOINT/venues/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"venue_id":"venue_bcplace","name":"BC Place","city":"Vancouver","state":"BC","country":"Canada","capacity":54500,"status":"active"}' > /dev/null

curl -s -X POST "$ENDPOINT/venues/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"venue_id":"venue_bmo","name":"BMO Field","city":"Toronto","state":"ON","country":"Canada","capacity":45000,"status":"active"}' > /dev/null

curl -s -X POST "$ENDPOINT/venues/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"venue_id":"venue_azteca","name":"Estadio Azteca","city":"Mexico City","state":"CDMX","country":"Mexico","capacity":87523,"status":"active"}' > /dev/null

curl -s -X POST "$ENDPOINT/venues/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"venue_id":"venue_akron","name":"Estadio Akron","city":"Guadalajara","state":"Jalisco","country":"Mexico","capacity":49850,"status":"active"}' > /dev/null

curl -s -X POST "$ENDPOINT/venues/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"venue_id":"venue_bbva","name":"Estadio BBVA","city":"Monterrey","state":"Nuevo Leon","country":"Mexico","capacity":53500,"status":"active"}' > /dev/null

echo "  16 venues loaded."
echo ""

# ── CROWD DENSITY READINGS ────────────────────────────────────────────────────
echo "Loading crowd density readings..."

curl -s -X POST "$ENDPOINT/crowd_density_readings/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "reading_id":"read_metlife_gatec_001","venue_id":"venue_metlife",
    "zone_id":"gate_c","zone_name":"Gate C East Concourse",
    "timestamp":"2026-06-15T21:45:00Z","people_count":1920,"area_sqm":800,
    "density_ppm":2.4,"safe_threshold":2.0,"density_level":"elevated",
    "trend":"rising","match_id":"match_wc2026_037","match_phase":"pre_match"
  }' > /dev/null

curl -s -X POST "$ENDPOINT/crowd_density_readings/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "reading_id":"read_metlife_gatec_002","venue_id":"venue_metlife",
    "zone_id":"gate_c","zone_name":"Gate C East Concourse",
    "timestamp":"2026-06-15T21:50:00Z","people_count":2240,"area_sqm":800,
    "density_ppm":2.8,"safe_threshold":2.0,"density_level":"critical",
    "trend":"rising_fast","match_id":"match_wc2026_037","match_phase":"pre_match"
  }' > /dev/null

curl -s -X POST "$ENDPOINT/crowd_density_readings/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "reading_id":"read_metlife_lower_001","venue_id":"venue_metlife",
    "zone_id":"lower_bowl","zone_name":"Lower Bowl Seating",
    "timestamp":"2026-06-15T21:50:00Z","people_count":28000,"area_sqm":18000,
    "density_ppm":1.56,"safe_threshold":1.8,"density_level":"normal",
    "trend":"stable","match_id":"match_wc2026_037","match_phase":"pre_match"
  }' > /dev/null

curl -s -X POST "$ENDPOINT/crowd_density_readings/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "reading_id":"read_sofi_normal_001","venue_id":"venue_sofi",
    "zone_id":"north_plaza","zone_name":"North Plaza",
    "timestamp":"2026-06-15T21:50:00Z","people_count":3200,"area_sqm":3000,
    "density_ppm":1.07,"safe_threshold":2.5,"density_level":"normal",
    "trend":"stable","match_id":"match_wc2026_019","match_phase":"pre_match"
  }' > /dev/null

echo "  4 density readings loaded (2 critical at Gate C, 2 normal)."
echo ""

# ── EMERGENCY RESOURCES ───────────────────────────────────────────────────────
echo "Loading emergency resources..."

curl -s -X POST "$ENDPOINT/emergency_resources/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "resource_id":"res_med_001","venue_id":"venue_metlife",
    "type":"medical_team","name":"Medical Team Alpha",
    "personnel_count":4,"current_zone":"gate_a","status":"available",
    "contact_radio":"Channel 3","contact_phone":"+12015550301","response_time_minutes":2
  }' > /dev/null

curl -s -X POST "$ENDPOINT/emergency_resources/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "resource_id":"res_med_002","venue_id":"venue_metlife",
    "type":"medical_team","name":"Medical Team Bravo",
    "personnel_count":4,"current_zone":"lower_bowl","status":"available",
    "contact_radio":"Channel 3","contact_phone":"+12015550302","response_time_minutes":5
  }' > /dev/null

curl -s -X POST "$ENDPOINT/emergency_resources/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "resource_id":"res_sec_001","venue_id":"venue_metlife",
    "type":"crowd_control","name":"Crowd Control Unit 1",
    "personnel_count":8,"current_zone":"gate_b","status":"available",
    "contact_radio":"Channel 2","contact_phone":"+12015550202","response_time_minutes":3
  }' > /dev/null

curl -s -X POST "$ENDPOINT/emergency_resources/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "resource_id":"res_sec_002","venue_id":"venue_metlife",
    "type":"gate_management","name":"Gate Management Team C",
    "personnel_count":3,"current_zone":"gate_c","status":"available",
    "contact_radio":"Channel 4","contact_phone":"+12015550403","response_time_minutes":1
  }' > /dev/null

curl -s -X POST "$ENDPOINT/emergency_resources/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "resource_id":"res_sec_003","venue_id":"venue_metlife",
    "type":"security_unit","name":"Security Unit North",
    "personnel_count":6,"current_zone":"concourse_main","status":"available",
    "contact_radio":"Channel 1","contact_phone":"+12015550101","response_time_minutes":3
  }' > /dev/null

echo "  5 emergency resources loaded (all available at MetLife)."
echo ""

# ── INITIAL AGENT LOG ─────────────────────────────────────────────────────────
echo "Loading initial agent log..."

curl -s -X POST "$ENDPOINT/agent_logs/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "log_id":"log_init_001","session_id":"sess_init",
    "mission":"system","step":1,"action":"system_initialized",
    "output":"CrowdGuard online. Elasticsearch connected. 16 venues registered. All resources available.",
    "status":"success","created_at":"2026-06-11T00:00:00Z"
  }' > /dev/null

echo "  Initial log entry created."
echo ""

# ── LOST PERSONS (demo case) ──────────────────────────────────────────────────
echo "Loading demo lost person case..."

curl -s -X POST "$ENDPOINT/lost_persons/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "case_id":"lost_metlife_001","venue_id":"venue_metlife",
    "match_id":"match_wc2026_037","reported_at":"2026-06-15T20:30:00Z",
    "reporter_name":"Rosa Hernandez","reporter_phone":"+521234567890",
    "reporter_language":"Spanish","missing_name":"Miguel","missing_age":9,
    "description":"Boy age 9 green Mexico jersey black shorts red cap",
    "last_seen_zone":"concourse_main","last_seen_at":"2026-06-15T20:15:00Z",
    "status":"searching","assigned_to":"res_sec_003"
  }' > /dev/null

echo "  Demo lost child case loaded."
echo ""

echo "============================================"
echo "CrowdGuard Elasticsearch setup complete!"
echo ""
echo "Indexes created: 7"
echo "Venues loaded: 16 (all official FIFA World Cup 2026)"
echo "Density readings: 4 (2 CRITICAL at Gate C MetLife)"
echo "Emergency resources: 5 (all available)"
echo "Agent logs: 1"
echo "Lost persons: 1 (demo case)"
echo ""
echo "Run the agent now:"
echo 'curl -X POST https://us-central1-gen-lang-client-0198283110.cloudfunctions.net/crowdGuardAgent -H "Content-Type: application/json" -d '"'"'{"mission":"crowd_monitoring"}'"'"''
echo "============================================"\
    -H "Content-Type: application/json" \
    -d '{"settings": {"number_of_replicas": 0}}'
  echo "Created index: $INDEX"
done

# Load venues
curl -X POST "$ENDPOINT/venues/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "venue_id": "venue_metlife",
    "name": "MetLife Stadium",
    "city": "East Rutherford",
    "state": "NJ",
    "country": "US",
    "capacity": 82500,
    "nearest_venue": "MetLife Stadium",
    "zones": [
      {"zone_id": "gate_a", "name": "Gate A North Entry", "max_safe_density": 2.5, "area_sqm": 1200, "exits": 4},
      {"zone_id": "gate_b", "name": "Gate B South Entry", "max_safe_density": 2.5, "area_sqm": 1400, "exits": 6},
      {"zone_id": "gate_c", "name": "Gate C East Concourse", "max_safe_density": 2.0, "area_sqm": 800, "exits": 2},
      {"zone_id": "lower_bowl", "name": "Lower Bowl Seating", "max_safe_density": 1.8, "area_sqm": 18000, "exits": 16},
      {"zone_id": "concourse_main", "name": "Main Concourse", "max_safe_density": 3.0, "area_sqm": 5000, "exits": 20}
    ],
    "emergency_contacts": {
      "medical_coordinator": "+12015550911",
      "security_chief": "+12015550112",
      "fifa_safety_officer": "+12015550200"
    },
    "status": "active"
  }'

# Load crowd density readings
curl -X POST "$ENDPOINT/crowd_density_readings/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "reading_id": "read_metlife_gatec_001",
    "venue_id": "venue_metlife",
    "zone_id": "gate_c",
    "zone_name": "Gate C East Concourse",
    "timestamp": "2026-06-15T21:45:00Z",
    "people_count": 1920,
    "area_sqm": 800,
    "density_ppm": 2.4,
    "safe_threshold": 2.0,
    "density_level": "elevated",
    "trend": "rising",
    "match_id": "match_wc2026_037",
    "match_phase": "pre_match"
  }'

curl -X POST "$ENDPOINT/crowd_density_readings/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "reading_id": "read_metlife_gatec_002",
    "venue_id": "venue_metlife",
    "zone_id": "gate_c",
    "zone_name": "Gate C East Concourse",
    "timestamp": "2026-06-15T21:50:00Z",
    "people_count": 2240,
    "area_sqm": 800,
    "density_ppm": 2.8,
    "safe_threshold": 2.0,
    "density_level": "critical",
    "trend": "rising_fast",
    "match_id": "match_wc2026_037",
    "match_phase": "pre_match"
  }'

# Load emergency resources
curl -X POST "$ENDPOINT/emergency_resources/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "resource_id": "res_med_001",
    "venue_id": "venue_metlife",
    "type": "medical_team",
    "name": "Medical Team Alpha",
    "personnel_count": 4,
    "current_zone": "gate_a",
    "status": "available",
    "contact_radio": "Channel 3",
    "contact_phone": "+12015550301",
    "response_time_minutes": 2
  }'

curl -X POST "$ENDPOINT/emergency_resources/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "resource_id": "res_sec_001",
    "venue_id": "venue_metlife",
    "type": "crowd_control",
    "name": "Crowd Control Unit 1",
    "personnel_count": 8,
    "current_zone": "gate_b",
    "status": "available",
    "contact_radio": "Channel 2",
    "contact_phone": "+12015550202",
    "response_time_minutes": 3
  }'

curl -X POST "$ENDPOINT/emergency_resources/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "resource_id": "res_sec_002",
    "venue_id": "venue_metlife",
    "type": "gate_management",
    "name": "Gate Management Team C",
    "personnel_count": 3,
    "current_zone": "gate_c",
    "status": "available",
    "contact_radio": "Channel 4",
    "contact_phone": "+12015550403",
    "response_time_minutes": 1
  }'

# Load initial agent log
curl -X POST "$ENDPOINT/agent_logs/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "log_id": "log_init_001",
    "session_id": "sess_init",
    "mission": "system",
    "step": 1,
    "action": "system_initialized",
    "output": "CrowdGuard Elasticsearch connection verified. All indexes ready.",
    "status": "success",
    "created_at": "2026-06-06T00:00:00Z"
  }'

echo ""
echo "All indexes created and seed data loaded!"