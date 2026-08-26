# Matrice de couverture — PMD_SKY_EXPLORERS

| Dimension | Couverture | Statut | Source |
|---|---|---|---|
| extraction_grounds | 460/460 (100.0%) | **PASS** | MANIFEST.totals.grounds |
| render_visual | 459/460 (99.8%) | **PARTIAL** | AUDIT.coverage.render_pct |
| frames_animation | 459/460 (99.8%) | **PARTIAL** | AUDIT.frame_status |
| rom_scripts_ssb | 3760/3760 (100.0%) | **PASS** | Cinematics/ROM_SCRIPTS_INDEX.json (ExplorerScript + dialogues 5 langues) |
| rom_scripts_ssa | 1884/1884 (100.0%) | **PASS** | idem (placements acteurs/objets/events/triggers) |
| cinematic_linked_grounds | 336/460 (73.0%) | **PARTIAL** | MANIFEST.totals.with_cinematic (LEVEL_MAP_LINKS level→MAP_BG) |
| progression_graph | — | **PASS** | Docs/PROGRESSION_GRAPH.json (SSB décompilés ROM) |
| playable_progression | 244/245 (99.6%) | **PASS** | Docs/PLAYABLE_PROGRESSION.json (état→scène→ground→dialogues) |
| cinematic_integrability | 2763/3760 (73.5%) | **PARTIAL** | Docs/CINEMATIC_INTEGRABILITY.json (table curatée ssb_coverage, 0 opcode inconnu) |
| runtime_pmdo_grounds | 9/460 (2.0%) | **PARTIAL** | dev/docs/canonical/sky/hub_grounds_runtime_proof.jsonl (sky_hub_zone + mode sky: du ground_gameplay_validator) |
| cinematic_runtime | 1/3760 (0.0%) | **PARTIAL** | dev/docs/canonical/sky/cinematic_m01a0204_runtime_proof.jsonl (SkyCanonScenes.lua, mode skyscene:) |
| gameplay_tables_extraction | 178/180 (98.9%) | **PASS** | Tables/DUNGEON_TABLES_INDEX.json (mappa_s.bin EU : 1795 étages, spawns/pièges/items bruts) |
| pmdo_mapping_species | 484/484 (100.0%) | **PASS** | Tables/PMDO_MAPPING.json |
| pmdo_mapping_items | 205/290 (70.7%) | **PARTIAL** | Tables/PMDO_MAPPING.json |
| dungeon_zones_vs_rom | 43/43 (100.0%) | **PASS** | Tables/ZONE_VS_ROM_COMPARISON.json (comparaison structurelle par étage) |
| dungeon_runtime_pmdo | 43/180 (23.9%) | **PARTIAL** | dev/docs/canonical_dungeon_runtime/matrix.json + mapgen_*.jsonl (PMDO 0.8.12 réel) |
| story_chains_end_to_end | 9/9 (100.0%) | **PASS** | dev/docs/canonical/sky/story_chains_runtime_proof.jsonl (red_story_route_validator, chaînes sky) |
| audit_verdict | — | **AUDIT_PASS** | AUDIT.json (8 familles A-H) |
