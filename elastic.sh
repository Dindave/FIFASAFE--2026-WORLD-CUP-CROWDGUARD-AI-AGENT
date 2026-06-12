ENDPOINT="https://3f9290dca6bd4708b5d5aac529c9ab90.us-central1.gcp.cloud.es.io:443"
API_KEY="UjhmLW01NEJTSGowNk43QWR1em06UEJSQzlzU0ZvZnp0dVdZQWsyUURRZw=="

echo "=== CrowdGuard — Full Elasticsearch Setup ==="
echo "Loading all 16 FIFA World Cup 2026 venues..."
echo ""

# Clear old indexes
echo "Clearing old indexes..."
curl -s -X DELETE "$ENDPOINT/venues,crowd_density_readings,incidents,emergency_resources,advisories,agent_logs,lost_persons" \
  -H "Authorization: ApiKey $API_KEY" > /dev/null
sleep 2

# Create indexes
for INDEX in venues crowd_density_readings incidents emergency_resources advisories agent_logs lost_persons; do
  curl -s -X PUT "$ENDPOINT/$INDEX" \
    -H "Authorization: ApiKey $API_KEY" \
    -H "Content-Type: application/json" \
    -d '{"settings":{"number_of_replicas":0}}' > /dev/null
done
echo "7 indexes created."
echo ""

# ── VENUES (all 16) ────────────────────────────────────────────────────────────
echo "Loading 16 official venues..."

load_venue() {
  curl -s -X POST "$ENDPOINT/venues/_doc" \
    -H "Authorization: ApiKey $API_KEY" \
    -H "Content-Type: application/json" \
    -d "$1" > /dev/null
}

load_venue '{"venue_id":"venue_metlife","name":"MetLife Stadium","city":"East Rutherford","state":"NJ","country":"US","capacity":82500,"status":"active","special":"World Cup Final Host","emergency_contacts":{"medical":"+12015550911","security":"+12015550112","fifa_officer":"+12015550200"},"zones":[{"zone_id":"gate_a","name":"Gate A North Entry","max_safe_density":2.5,"area_sqm":1200,"exits":4},{"zone_id":"gate_b","name":"Gate B South Entry","max_safe_density":2.5,"area_sqm":1400,"exits":6},{"zone_id":"gate_c","name":"Gate C East Concourse","max_safe_density":2.0,"area_sqm":800,"exits":2},{"zone_id":"lower_bowl","name":"Lower Bowl Seating","max_safe_density":1.8,"area_sqm":18000,"exits":16},{"zone_id":"concourse_main","name":"Main Concourse","max_safe_density":3.0,"area_sqm":5000,"exits":20}]}'
load_venue '{"venue_id":"venue_sofi","name":"SoFi Stadium","city":"Inglewood","state":"CA","country":"US","capacity":70240,"status":"active","zones":[{"zone_id":"north_plaza","name":"North Plaza","max_safe_density":2.5,"area_sqm":3000,"exits":8},{"zone_id":"south_plaza","name":"South Plaza","max_safe_density":2.5,"area_sqm":3200,"exits":8},{"zone_id":"field_level","name":"Field Level Concourse","max_safe_density":2.0,"area_sqm":6000,"exits":12}]}'
load_venue '{"venue_id":"venue_att","name":"AT&T Stadium","city":"Arlington","state":"TX","country":"US","capacity":80000,"status":"active","zones":[{"zone_id":"main_entry","name":"Main Entry Plaza","max_safe_density":2.5,"area_sqm":4000,"exits":10},{"zone_id":"upper_concourse","name":"Upper Concourse","max_safe_density":2.0,"area_sqm":8000,"exits":14}]}'
load_venue '{"venue_id":"venue_hardrock","name":"Hard Rock Stadium","city":"Miami Gardens","state":"FL","country":"US","capacity":65326,"status":"active","zones":[{"zone_id":"gate_1","name":"Gate 1 South Entry","max_safe_density":2.5,"area_sqm":2000,"exits":6},{"zone_id":"concourse_a","name":"Concourse A","max_safe_density":2.0,"area_sqm":5000,"exits":10}]}'
load_venue '{"venue_id":"venue_mercedesbenz","name":"Mercedes-Benz Stadium","city":"Atlanta","state":"GA","country":"US","capacity":71000,"status":"active","zones":[{"zone_id":"atrium","name":"Main Atrium","max_safe_density":3.0,"area_sqm":6000,"exits":16},{"zone_id":"upper_ring","name":"Upper Ring Concourse","max_safe_density":2.0,"area_sqm":7000,"exits":12}]}'
load_venue '{"venue_id":"venue_nrg","name":"NRG Stadium","city":"Houston","state":"TX","country":"US","capacity":72220,"status":"active","zones":[{"zone_id":"main_gate","name":"Main Gate Plaza","max_safe_density":2.5,"area_sqm":3500,"exits":8},{"zone_id":"club_level","name":"Club Level","max_safe_density":2.0,"area_sqm":4000,"exits":8}]}'
load_venue '{"venue_id":"venue_levis","name":"Levis Stadium","city":"Santa Clara","state":"CA","country":"US","capacity":68500,"status":"active","zones":[{"zone_id":"east_plaza","name":"East Plaza","max_safe_density":2.5,"area_sqm":3000,"exits":8},{"zone_id":"west_plaza","name":"West Plaza","max_safe_density":2.5,"area_sqm":2800,"exits":6}]}'
load_venue '{"venue_id":"venue_lincoln","name":"Lincoln Financial Field","city":"Philadelphia","state":"PA","country":"US","capacity":69796,"status":"active","zones":[{"zone_id":"broad_street_gate","name":"Broad Street Gate","max_safe_density":2.5,"area_sqm":2500,"exits":6},{"zone_id":"main_concourse","name":"Main Concourse","max_safe_density":2.0,"area_sqm":6000,"exits":12}]}'
load_venue '{"venue_id":"venue_gillette","name":"Gillette Stadium","city":"Foxborough","state":"MA","country":"US","capacity":65878,"status":"active","zones":[{"zone_id":"patriot_place","name":"Patriot Place Entry","max_safe_density":2.5,"area_sqm":5000,"exits":10},{"zone_id":"lower_concourse","name":"Lower Concourse","max_safe_density":2.0,"area_sqm":5500,"exits":10}]}'
load_venue '{"venue_id":"venue_lumen","name":"Lumen Field","city":"Seattle","state":"WA","country":"US","capacity":68740,"status":"active","zones":[{"zone_id":"north_gate","name":"North Gate Plaza","max_safe_density":2.5,"area_sqm":2800,"exits":6},{"zone_id":"south_gate","name":"South Gate Plaza","max_safe_density":2.5,"area_sqm":2600,"exits":6}]}'
load_venue '{"venue_id":"venue_arrowhead","name":"Arrowhead Stadium","city":"Kansas City","state":"MO","country":"US","capacity":76416,"status":"active","zones":[{"zone_id":"red_lot_gate","name":"Red Lot Gate","max_safe_density":2.5,"area_sqm":3000,"exits":8},{"zone_id":"main_concourse","name":"Main Concourse","max_safe_density":2.0,"area_sqm":6500,"exits":12}]}'
load_venue '{"venue_id":"venue_bcplace","name":"BC Place","city":"Vancouver","state":"BC","country":"Canada","capacity":54500,"status":"active","zones":[{"zone_id":"north_entrance","name":"North Entrance","max_safe_density":2.5,"area_sqm":2000,"exits":6},{"zone_id":"main_concourse","name":"Main Concourse","max_safe_density":2.0,"area_sqm":4500,"exits":10}]}'
load_venue '{"venue_id":"venue_bmo","name":"BMO Field","city":"Toronto","state":"ON","country":"Canada","capacity":45000,"status":"active","zones":[{"zone_id":"main_gate","name":"Main Gate","max_safe_density":2.5,"area_sqm":1800,"exits":4},{"zone_id":"east_stand","name":"East Stand Concourse","max_safe_density":2.0,"area_sqm":3000,"exits":6}]}'
load_venue '{"venue_id":"venue_azteca","name":"Estadio Azteca","city":"Mexico City","state":"CDMX","country":"Mexico","capacity":87523,"status":"active","zones":[{"zone_id":"puerta_1","name":"Puerta 1 Norte","max_safe_density":2.5,"area_sqm":4000,"exits":8},{"zone_id":"puerta_5","name":"Puerta 5 Sur","max_safe_density":2.5,"area_sqm":4000,"exits":8},{"zone_id":"concourse_general","name":"Concourse General","max_safe_density":3.0,"area_sqm":10000,"exits":20}]}'
load_venue '{"venue_id":"venue_akron","name":"Estadio Akron","city":"Guadalajara","state":"Jalisco","country":"Mexico","capacity":49850,"status":"active","zones":[{"zone_id":"acceso_norte","name":"Acceso Norte","max_safe_density":2.5,"area_sqm":2000,"exits":6},{"zone_id":"concourse_principal","name":"Concourse Principal","max_safe_density":2.0,"area_sqm":4000,"exits":8}]}'
load_venue '{"venue_id":"venue_bbva","name":"Estadio BBVA","city":"Monterrey","state":"Nuevo Leon","country":"Mexico","capacity":53500,"status":"active","zones":[{"zone_id":"acceso_principal","name":"Acceso Principal","max_safe_density":2.5,"area_sqm":2200,"exits":6},{"zone_id":"tribuna_de_honor","name":"Tribuna de Honor","max_safe_density":2.0,"area_sqm":3500,"exits":8}]}'

echo "  16 venues loaded."
echo ""

# ── CROWD DENSITY READINGS (all 16 venues) ────────────────────────────────────
echo "Loading crowd density readings for all 16 venues..."

load_reading() {
  curl -s -X POST "$ENDPOINT/crowd_density_readings/_doc" \
    -H "Authorization: ApiKey $API_KEY" \
    -H "Content-Type: application/json" \
    -d "$1" > /dev/null
}

# MetLife — CRITICAL (main demo scenario)
load_reading '{"reading_id":"read_metlife_gatec_001","venue_id":"venue_metlife","zone_id":"gate_c","zone_name":"Gate C East Concourse","timestamp":"2026-06-15T21:45:00Z","people_count":1920,"area_sqm":800,"density_ppm":2.4,"safe_threshold":2.0,"density_level":"elevated","trend":"rising","match_id":"match_wc2026_037","match_phase":"pre_match","match_name":"USA vs Mexico"}'
load_reading '{"reading_id":"read_metlife_gatec_002","venue_id":"venue_metlife","zone_id":"gate_c","zone_name":"Gate C East Concourse","timestamp":"2026-06-15T21:50:00Z","people_count":2240,"area_sqm":800,"density_ppm":2.8,"safe_threshold":2.0,"density_level":"critical","trend":"rising_fast","match_id":"match_wc2026_037","match_phase":"pre_match","match_name":"USA vs Mexico"}'
load_reading '{"reading_id":"read_metlife_lower_001","venue_id":"venue_metlife","zone_id":"lower_bowl","zone_name":"Lower Bowl Seating","timestamp":"2026-06-15T21:50:00Z","people_count":28000,"area_sqm":18000,"density_ppm":1.56,"safe_threshold":1.8,"density_level":"normal","trend":"stable","match_id":"match_wc2026_037","match_phase":"pre_match","match_name":"USA vs Mexico"}'

# Hard Rock Stadium — ELEVATED (pre-match crowd building)
load_reading '{"reading_id":"read_hardrock_gate1_001","venue_id":"venue_hardrock","zone_id":"gate_1","zone_name":"Gate 1 South Entry","timestamp":"2026-06-15T21:50:00Z","people_count":1600,"area_sqm":2000,"density_ppm":2.6,"safe_threshold":2.5,"density_level":"elevated","trend":"rising","match_id":"match_wc2026_018","match_phase":"pre_match","match_name":"Brazil vs Argentina"}'
load_reading '{"reading_id":"read_hardrock_concourse_001","venue_id":"venue_hardrock","zone_id":"concourse_a","zone_name":"Concourse A","timestamp":"2026-06-15T21:50:00Z","people_count":7500,"area_sqm":5000,"density_ppm":1.5,"safe_threshold":2.0,"density_level":"normal","trend":"stable","match_id":"match_wc2026_018","match_phase":"pre_match","match_name":"Brazil vs Argentina"}'

# Estadio Azteca — ELEVATED (massive capacity, Mexican fans)
load_reading '{"reading_id":"read_azteca_puerta1_001","venue_id":"venue_azteca","zone_id":"puerta_1","zone_name":"Puerta 1 Norte","timestamp":"2026-06-15T21:50:00Z","people_count":4200,"area_sqm":4000,"density_ppm":2.63,"safe_threshold":2.5,"density_level":"elevated","trend":"rising","match_id":"match_wc2026_042","match_phase":"pre_match","match_name":"Mexico vs Canada"}'
load_reading '{"reading_id":"read_azteca_general_001","venue_id":"venue_azteca","zone_id":"concourse_general","zone_name":"Concourse General","timestamp":"2026-06-15T21:50:00Z","people_count":22000,"area_sqm":10000,"density_ppm":2.2,"safe_threshold":3.0,"density_level":"normal","trend":"stable","match_id":"match_wc2026_042","match_phase":"pre_match","match_name":"Mexico vs Canada"}'

# SoFi Stadium — NORMAL
load_reading '{"reading_id":"read_sofi_north_001","venue_id":"venue_sofi","zone_id":"north_plaza","zone_name":"North Plaza","timestamp":"2026-06-15T21:50:00Z","people_count":3200,"area_sqm":3000,"density_ppm":1.07,"safe_threshold":2.5,"density_level":"normal","trend":"stable","match_id":"match_wc2026_019","match_phase":"pre_match","match_name":"Portugal vs Germany"}'
load_reading '{"reading_id":"read_sofi_field_001","venue_id":"venue_sofi","zone_id":"field_level","zone_name":"Field Level Concourse","timestamp":"2026-06-15T21:50:00Z","people_count":8000,"area_sqm":6000,"density_ppm":1.33,"safe_threshold":2.0,"density_level":"normal","trend":"stable","match_id":"match_wc2026_019","match_phase":"pre_match","match_name":"Portugal vs Germany"}'

# AT&T Stadium — NORMAL
load_reading '{"reading_id":"read_att_main_001","venue_id":"venue_att","zone_id":"main_entry","zone_name":"Main Entry Plaza","timestamp":"2026-06-15T21:50:00Z","people_count":5000,"area_sqm":4000,"density_ppm":1.25,"safe_threshold":2.5,"density_level":"normal","trend":"stable","match_id":"match_wc2026_021","match_phase":"pre_match","match_name":"England vs France"}'

# Mercedes-Benz Stadium — NORMAL
load_reading '{"reading_id":"read_mercedesbenz_atrium_001","venue_id":"venue_mercedesbenz","zone_id":"atrium","zone_name":"Main Atrium","timestamp":"2026-06-15T21:50:00Z","people_count":9000,"area_sqm":6000,"density_ppm":1.5,"safe_threshold":3.0,"density_level":"normal","trend":"stable","match_id":"match_wc2026_023","match_phase":"pre_match","match_name":"Spain vs Italy"}'

# NRG Stadium — NORMAL
load_reading '{"reading_id":"read_nrg_main_001","venue_id":"venue_nrg","zone_id":"main_gate","zone_name":"Main Gate Plaza","timestamp":"2026-06-15T21:50:00Z","people_count":4200,"area_sqm":3500,"density_ppm":1.2,"safe_threshold":2.5,"density_level":"normal","trend":"stable","match_id":"match_wc2026_025","match_phase":"pre_match","match_name":"Netherlands vs Belgium"}'

# Levis Stadium — NORMAL
load_reading '{"reading_id":"read_levis_east_001","venue_id":"venue_levis","zone_id":"east_plaza","zone_name":"East Plaza","timestamp":"2026-06-15T21:50:00Z","people_count":3600,"area_sqm":3000,"density_ppm":1.2,"safe_threshold":2.5,"density_level":"normal","trend":"stable","match_id":"match_wc2026_027","match_phase":"pre_match","match_name":"Japan vs South Korea"}'

# Lincoln Financial Field — NORMAL
load_reading '{"reading_id":"read_lincoln_broad_001","venue_id":"venue_lincoln","zone_id":"broad_street_gate","zone_name":"Broad Street Gate","timestamp":"2026-06-15T21:50:00Z","people_count":3000,"area_sqm":2500,"density_ppm":1.2,"safe_threshold":2.5,"density_level":"normal","trend":"stable","match_id":"match_wc2026_029","match_phase":"pre_match","match_name":"Australia vs Nigeria"}'

# Gillette Stadium — NORMAL
load_reading '{"reading_id":"read_gillette_patriot_001","venue_id":"venue_gillette","zone_id":"patriot_place","zone_name":"Patriot Place Entry","timestamp":"2026-06-15T21:50:00Z","people_count":6000,"area_sqm":5000,"density_ppm":1.2,"safe_threshold":2.5,"density_level":"normal","trend":"stable","match_id":"match_wc2026_031","match_phase":"pre_match","match_name":"USA vs Iran"}'

# Lumen Field — NORMAL
load_reading '{"reading_id":"read_lumen_north_001","venue_id":"venue_lumen","zone_id":"north_gate","zone_name":"North Gate Plaza","timestamp":"2026-06-15T21:50:00Z","people_count":3360,"area_sqm":2800,"density_ppm":1.2,"safe_threshold":2.5,"density_level":"normal","trend":"stable","match_id":"match_wc2026_033","match_phase":"pre_match","match_name":"Canada vs Morocco"}'

# Arrowhead Stadium — NORMAL
load_reading '{"reading_id":"read_arrowhead_red_001","venue_id":"venue_arrowhead","zone_id":"red_lot_gate","zone_name":"Red Lot Gate","timestamp":"2026-06-15T21:50:00Z","people_count":3600,"area_sqm":3000,"density_ppm":1.2,"safe_threshold":2.5,"density_level":"normal","trend":"stable","match_id":"match_wc2026_035","match_phase":"pre_match","match_name":"Colombia vs Ecuador"}'

# BC Place — NORMAL
load_reading '{"reading_id":"read_bcplace_north_001","venue_id":"venue_bcplace","zone_id":"north_entrance","zone_name":"North Entrance","timestamp":"2026-06-15T21:50:00Z","people_count":2400,"area_sqm":2000,"density_ppm":1.2,"safe_threshold":2.5,"density_level":"normal","trend":"stable","match_id":"match_wc2026_011","match_phase":"pre_match","match_name":"France vs Belgium"}'

# BMO Field — NORMAL
load_reading '{"reading_id":"read_bmo_main_001","venue_id":"venue_bmo","zone_id":"main_gate","zone_name":"Main Gate","timestamp":"2026-06-15T21:50:00Z","people_count":2160,"area_sqm":1800,"density_ppm":1.2,"safe_threshold":2.5,"density_level":"normal","trend":"stable","match_id":"match_wc2026_013","match_phase":"pre_match","match_name":"England vs Senegal"}'

# Estadio Akron — NORMAL
load_reading '{"reading_id":"read_akron_norte_001","venue_id":"venue_akron","zone_id":"acceso_norte","zone_name":"Acceso Norte","timestamp":"2026-06-15T21:50:00Z","people_count":2400,"area_sqm":2000,"density_ppm":1.2,"safe_threshold":2.5,"density_level":"normal","trend":"stable","match_id":"match_wc2026_044","match_phase":"pre_match","match_name":"Germany vs Portugal"}'

# Estadio BBVA — NORMAL
load_reading '{"reading_id":"read_bbva_principal_001","venue_id":"venue_bbva","zone_id":"acceso_principal","zone_name":"Acceso Principal","timestamp":"2026-06-15T21:50:00Z","people_count":2640,"area_sqm":2200,"density_ppm":1.2,"safe_threshold":2.5,"density_level":"normal","trend":"stable","match_id":"match_wc2026_046","match_phase":"pre_match","match_name":"Argentina vs Chile"}'

echo "  22 crowd density readings loaded across all 16 venues."
echo "  Status summary:"
echo "    🔴 CRITICAL : MetLife Stadium Gate C (2.8 ppm)"
echo "    🟠 ELEVATED : Hard Rock Stadium Gate 1 (2.6 ppm)"
echo "    🟠 ELEVATED : Estadio Azteca Puerta 1 (2.63 ppm)"
echo "    ✅ NORMAL   : 13 other venues — all clear"
echo ""

# ── EMERGENCY RESOURCES ────────────────────────────────────────────────────────
echo "Loading emergency resources..."

load_resource() {
  curl -s -X POST "$ENDPOINT/emergency_resources/_doc" \
    -H "Authorization: ApiKey $API_KEY" \
    -H "Content-Type: application/json" \
    -d "$1" > /dev/null
}

# MetLife resources
load_resource '{"resource_id":"res_med_001","venue_id":"venue_metlife","type":"medical_team","name":"Medical Team Alpha","personnel_count":4,"current_zone":"gate_a","status":"available","contact_radio":"Channel 3","contact_phone":"+12015550301","response_time_minutes":2}'
load_resource '{"resource_id":"res_med_002","venue_id":"venue_metlife","type":"medical_team","name":"Medical Team Bravo","personnel_count":4,"current_zone":"lower_bowl","status":"available","contact_radio":"Channel 3","contact_phone":"+12015550302","response_time_minutes":5}'
load_resource '{"resource_id":"res_sec_001","venue_id":"venue_metlife","type":"crowd_control","name":"Crowd Control Unit 1","personnel_count":8,"current_zone":"gate_b","status":"available","contact_radio":"Channel 2","contact_phone":"+12015550202","response_time_minutes":3}'
load_resource '{"resource_id":"res_sec_002","venue_id":"venue_metlife","type":"gate_management","name":"Gate Management Team C","personnel_count":3,"current_zone":"gate_c","status":"available","contact_radio":"Channel 4","contact_phone":"+12015550403","response_time_minutes":1}'
load_resource '{"resource_id":"res_sec_003","venue_id":"venue_metlife","type":"security_unit","name":"Security Unit North","personnel_count":6,"current_zone":"concourse_main","status":"available","contact_radio":"Channel 1","contact_phone":"+12015550101","response_time_minutes":3}'

# Hard Rock resources
load_resource '{"resource_id":"res_hardrock_med_001","venue_id":"venue_hardrock","type":"medical_team","name":"Medical Team Charlie","personnel_count":4,"current_zone":"gate_1","status":"available","contact_radio":"Channel 3","contact_phone":"+13055550301","response_time_minutes":2}'
load_resource '{"resource_id":"res_hardrock_sec_001","venue_id":"venue_hardrock","type":"crowd_control","name":"Crowd Control Miami 1","personnel_count":8,"current_zone":"concourse_a","status":"available","contact_radio":"Channel 2","contact_phone":"+13055550202","response_time_minutes":3}'

# Azteca resources
load_resource '{"resource_id":"res_azteca_med_001","venue_id":"venue_azteca","type":"medical_team","name":"Equipo Medico Alfa","personnel_count":4,"current_zone":"puerta_1","status":"available","contact_radio":"Canal 3","contact_phone":"+525515550301","response_time_minutes":2}'
load_resource '{"resource_id":"res_azteca_sec_001","venue_id":"venue_azteca","type":"crowd_control","name":"Control de Multitudes 1","personnel_count":10,"current_zone":"concourse_general","status":"available","contact_radio":"Canal 2","contact_phone":"+525515550202","response_time_minutes":4}'

echo "  9 emergency resources loaded (5 at MetLife, 2 at Hard Rock, 2 at Azteca)."
echo ""

# ── INITIAL AGENT LOG ──────────────────────────────────────────────────────────
echo "Loading initial agent log..."
curl -s -X POST "$ENDPOINT/agent_logs/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"log_id":"log_init_001","session_id":"sess_init","mission":"system","step":1,"action":"system_initialized","output":"CrowdGuard online. All 16 World Cup 2026 venues registered. Elasticsearch connected. Emergency resources loaded. Ready to monitor.","status":"success","created_at":"2026-06-11T00:00:00Z"}' > /dev/null

# ── LOST PERSON (demo case) ────────────────────────────────────────────────────
echo "Loading demo lost person case..."
curl -s -X POST "$ENDPOINT/lost_persons/_doc" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"case_id":"lost_metlife_001","venue_id":"venue_metlife","match_id":"match_wc2026_037","reported_at":"2026-06-15T20:30:00Z","reporter_name":"Rosa Hernandez","reporter_phone":"+521234567890","reporter_language":"Spanish","missing_name":"Miguel","missing_age":9,"description":"Boy age 9 green Mexico jersey black shorts red cap","last_seen_zone":"concourse_main","last_seen_at":"2026-06-15T20:15:00Z","status":"searching","assigned_to":"res_sec_003"}' > /dev/null

echo ""
echo "============================================"
echo "CrowdGuard setup complete!"
echo ""
echo "  Indexes:            7"
echo "  Venues:             16 (all official FIFA World Cup 2026)"
echo "  Density readings:   22 across all 16 venues"
echo "  Emergency resources: 9"
echo "  Agent logs:         1"
echo "  Lost persons:       1 (demo)"
echo ""
echo "Venue status loaded:"
echo "  🔴 CRITICAL  MetLife Stadium (NJ) — Gate C 2.8 ppm"
echo "  🟠 ELEVATED  Hard Rock Stadium (FL) — Gate 1 2.6 ppm"
echo "  🟠 ELEVATED  Estadio Azteca (MX) — Puerta 1 2.63 ppm"
echo "  ✅ NORMAL    13 other venues"
echo ""
echo "Test the agent:"
echo 'curl -X POST https://us-central1-gen-lang-client-0198283110.cloudfunctions.net/crowdGuardAgent -H "Content-Type: application/json" -d '"'"'{"mission":"crowd_monitoring"}'"'"''
echo "============================================"