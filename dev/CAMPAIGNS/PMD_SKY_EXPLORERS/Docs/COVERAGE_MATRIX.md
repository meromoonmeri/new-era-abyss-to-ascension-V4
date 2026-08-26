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
| runtime_pmdo | 0/460 (0.0%) | **NOT_TESTED** | — |
| gameplay_tables_extraction | 178/180 (98.9%) | **PASS** | Tables/DUNGEON_TABLES_INDEX.json (mappa_s.bin EU : 1795 étages, spawns/pièges/items bruts) |
| gameplay_tables_mapping_pmdo | — | **NOT_TESTED** | — |
| audit_verdict | — | **AUDIT_PASS** | AUDIT.json (8 familles A-H) |
