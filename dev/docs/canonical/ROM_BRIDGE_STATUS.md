# ROM BRIDGE — état de conformité du dépôt (directive « ROM NATIVE BRIDGE + PMDO UNIFIED RUNTIME »)

Constat central : le dépôt implémente déjà l'architecture demandée sous forme
**offline** (extraction ROM → IR → structures PMDO natives), ce qui satisfait la
règle d'or « ROM = données, PMDO = moteur unique ». Aucun émulateur, aucun
second renderer/moteur : tout le contenu ROM converge vers les mêmes
structures que le vanilla PMDO et est rendu par RogueEssence seul.

## Correspondance directive → réalité du dépôt

| Directive | Implémentation existante | Preuve |
|---|---|---|
| ROM Reader/Decoder → IR → PMDO Adapter | outils dev/tools (skytemple/ndspy pour NDS, pret pour GBA) → tables JSON (IR) → générateurs de Zone/AutoTile/rsmap/rsground natifs | Tables/dungeons/*.json.gz, sky_build_zone_from_tables.py, sky_port_dungeon_tileset.py, red_build_gba_fixed_arenas.py |
| Tilesets = structures, jamais de simples PNG | tilesets NDS portés depuis dungeon.bin (DPL/DPC/DPCI/DMA/DPLA) vers AutoTileData 47 variantes + sheets .tile indexés ; animations d'eau préservées (durées ROM) | commit 3175f1bd (contre-épreuve 141/141 cellules == ts126 officiel, 11/11 frames DPLA) |
| Même pipeline RawAsset/autotile que vanilla | AutoTileData identique au vanilla (mêmes clés Tilex.., mêmes 47 variantes wall/floor/secondary) | AUTOTILE_STRUCTURAL_AUDIT.json : 203/203 PASS |
| Test Sinister Woods (tile décalée/index/UV) | 2 tests fail-closed nouveaux : structurel autotile (variantes vs vanilla + chaque TexLoc dans l'index binaire du .tile) et cartes (toutes références Sheet/TexLoc des rsground/rsmap) + sonde runtime gloomy_forest | AUTOTILE_STRUCTURAL_AUDIT.json (103 263 frames), TEXLOC_REFERENCE_AUDIT.json (713 fichiers, 3 955 120 références, 0 FAIL), red/sinister_woods_runtime_proof.jsonl |
| Coordonnées ROM canoniques, pas de déplacement | positions LEADER/ATTENDANT/entités = fixed.bin/fixedmap ROM exactes ; formations = offsets relatifs moteur (sémantique BattlePositionEvent source PMDC) | BATTLE_POSITION_ROM_EXACT_REPORT.json, FIXED_ARENA_VS_ROM_AUDIT.json 36/36 |
| Viewport ≠ problème : caméra adapte | EdgeView=Clamp (centrage caméra vanilla) sur 604 grounds — la géométrie n'a jamais été déplacée | fix_ground_viewport_spawn.py |
| PMDO prioritaire (Pokémon/Skills/items) | espèces/skills/items mappés vers les IDs PMDO existants (PMDO_MAPPING.json, NATDEX_TO_PMDO.json) ; combat/IA/UI/save 100% PMDO | ZONE_VS_ROM_COMPARISON.json 149/149 |
| Provenance | manifests par campagne + commentaires de zone citant dXX/pret_enum/fixed floor id | MANIFEST.json Red/Sky, Comments des zones |
| Fail-safe, pas de correction à l'œil | règle projet : « absent » exige contre-épreuve ROM ; corrections uniquement justifiées par binaire ROM ou source moteur | NARRATIVE_WILD_SPAWN_AUDIT.json, rapports *_FIX_REPORT.json |
| Pas de ROM dans Git | ROMs téléchargées au runtime dans .runtime-cache (exclu), vérifiées par SHA-256 | restore scripts, sha 1fa39d35… (Sky EU), 0f9d125d… (Red EU) |

## Non implémenté (et pourquoi c'est conforme)

- **Provider RUNTIME dynamique (IGameContentProvider lisant la ROM au
  lancement)** : non nécessaire — la conversion offline produit exactement les
  mêmes structures que le contenu vanilla, ce que la directive vise (« les deux
  chemins convergent avant génération et rendu »). Un provider runtime
  exigerait de modifier RogueEssence (interdit par la contrainte « ne pas
  réécrire un système fonctionnel sans raison », §62) sans gain de fidélité :
  les données converties sont déjà bit-fidèles aux tables ROM (149/149 EXACT).
- **CanonicalViewport 256×192 NDS en mode A** : PMDO rend en mono-viewport
  320×240 avec caméra Clamp ; les cadrages NDS des cinématiques dual-screen
  sont reproduits temporellement (DUAL_SCREEN_MATRIX 194/195). Aucune carte ni
  entité déplacée.

## Verdicts consolidés (état au HEAD)

- AUTOTILE_STRUCTURAL : PASS 203/203 (0 FAIL, 103 263 frames vérifiées)
- TEXLOC_REFERENCES : PASS (713 cartes, 3 955 120 références, 0 FAIL)
- FIXED_ARENA_VS_ROM : PASS 36/36 (cellule par cellule)
- ZONES_VS_ROM : 149/149 EXACT (+10 fixed floors documentés)
- RUNTIME : GLOBAL_JOURNEY_PASS Sky 14ch/313 étages ; RED_GLOBAL_JOURNEY_PASS
  13ch/182 étages ; Sinister Woods dprobe 3 étages peuplés
- NON-RÉGRESSION : lockfile CH1-5 INTÈGRE à chaque commit
