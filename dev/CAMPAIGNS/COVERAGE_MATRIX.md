# Matrice de couverture — campagnes PMD Red EU & Sky EU

Dimensions SÉPARÉES (règle §49) : aucun pourcentage global fusionné n'existe ni ne doit être calculé.


## PMD_RED_RESCUE_TEAM

| Dimension | Couverture | Statut | Source |
|---|---|---|---|
| extraction_grounds | 254/254 (100.0%) | **PASS** | MANIFEST.totals.grounds |
| render_visual | 254/254 (100.0%) | **PASS** | AUDIT.coverage.render_pct |
| frames_animation | 254/254 (100.0%) | **PASS** | AUDIT.frame_status (période minimale réelle par tuile) |
| runtime_pmdo | 219/254 (86.2%) | **PARTIAL** | MANIFEST.totals.runtime_validated (campagne 219 : mismatched_pixel_count=0 dans PMDO 0.8.12 réel) |
| cinematic_sequences | 132/254 (52.0%) | **PARTIAL** | MANIFEST.totals.with_cinematic (cif.json ROM) |
| dialogues_5_langues | 69/133 (51.9%) | **PARTIAL** | Cinematics/DIALOGUES_INDEX.json (69 stations graphe EU exact, 3073 blocs) |
| canonical_cast | 27/27 (100.0%) | **PASS** | eu_scene_cast.json (gGroundLivesTypeData 0x27BEEC) + preuve runtime 3 scènes |
| event_chain_rom_decoded | 399/407 (98.0%) | **PASS** | Cinematics/EVENT_SCRIPTS_INDEX.json (gFunctionScriptTable EU @0x08294450, décodage octet par octet) |
| playable_progression | 121/121 (100.0%) | **PASS** | Docs/PLAYABLE_PROGRESSION.json (EVENT→stations→dialogues) |
| dungeons_procedural_runtime | 89/89 (100.0%) | **PARTIAL** | dev/docs/canonical_dungeon_runtime/matrix.json (89/89 CANONICAL_RUNTIME_PASS, 1848 étages) |
| audit_verdict | — | **AUDIT_PASS** | AUDIT.json (8 familles A-H) |

## PMD_SKY_EXPLORERS

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
| dungeon_runtime_pmdo | 48/180 (26.7%) | **PARTIAL** | dev/docs/canonical_dungeon_runtime/matrix.json + mapgen_*.jsonl (PMDO 0.8.12 réel) |
| audit_verdict | — | **AUDIT_PASS** | AUDIT.json (8 familles A-H) |
