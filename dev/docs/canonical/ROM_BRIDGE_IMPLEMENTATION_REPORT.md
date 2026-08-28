# ROM_BRIDGE_IMPLEMENTATION_REPORT.md

Directive : « ROM NATIVE BRIDGE + PMDO UNIFIED RUNTIME » — état d'implémentation
réel, vérifié par tests exécutés (aucun PASS déclaré sans preuve, §78).

## Architecture livrée

Le bridge est réalisé en **convergence offline** : les ROMs (GBA Red EU,
NDS Sky EU) sont lues, décodées vers une IR, puis adaptées vers les
**mêmes fichiers/formats que le contenu vanilla PMDO** (.rsground/.rsmap/
Zone .json/AutoTileData .json/sheets .tile/objets .dir/Lua/OGG). Le moteur
RogueEssence charge tout par ses chargeurs uniques (`DataManager.LoadEntryData`,
`GraphicsManager`), donc :

- un seul runtime, un seul renderer, une seule caméra, une seule collision,
  un seul input, une seule sauvegarde, un seul système d'événements (Lua) ;
- aucun émulateur, aucun framebuffer, aucun « ROM Mode », aucun `if (isRom)`
  dans le gameplay : la provenance est portée par le CONTENT_REGISTRY, pas
  par le code.

```
ROM (GBA/NDS, SHA-256 vérifiés)
  → Readers/Decoders (IR)         convert_red_all.py (BPL/BPC/BPA/BMA),
                                  skytemple/ndspy (BMA/BPC/BPL/BPA, fixed.bin,
                                  mappa_s.bin, monster.md, SSA/SSB, WAN, dungeon.bin)
  → Adapters PMDO                 rsground+.tile, AutoTileData 47 variantes,
                                  Zones RogueElements natives, rsmap fixed rooms,
                                  Lua (scènes SSB, CANM palette scheduler), OGG
  → PMDO Data Model → RogueEssence renderer → PLAYER
```

## Phase 0 — Audit (§64) : `ROM_BRIDGE_ARCHITECTURE_AUDIT.md`
Tous les points de charge du moteur identifiés avec fichier/ligne
(DataManager .rsground/.rsmap/AutoTile+LRU, GraphicsManager .tile/TileGuide,
DtefImportHelper + FieldDtefMapping 47 masques, GroundMap obstacles/Markers,
UpdateCam Ground/Dungeon, LuaEngine, GameProgress). Statut : **PASS**.

## Phases 1-2 — Provider/Registry + ROM detection (§65-66)
- `CONTENT_REGISTRY.json` : **1389 ressources** avec provenance
  (Ground 246 ROM:GBA / 118 ROM:NDS / 240 PMDO ; Zone 53/149/58 ;
  AutoTile 3/189/11 ; Map 6/34/69 ; Music 152 ROM:NDS / 61 PMDO).
  Résolution §79 respectée : PMDO prioritaire (espèces/skills/items/objets
  mappés vers IDs PMDO — PMDO_MAPPING.json, NATDEX_TO_PMDO.json,
  statue Kangourex = asset PMDO Statue_Dungeon aux positions SSA ROM).
- Détection/validation ROM : SHA-256 imposés (Red EU 0f9d125d…, Sky EU
  1fa39d35…), ROMs jamais commis (téléchargées au runtime dans
  .runtime-cache, exclu de Git). Statut : **PASS**.

## Phase 3 — Tileset foundation (§67, §16-24)
- NDS : `sky_port_dungeon_tileset.py` — DPL/DPC/DPCI/DMA/DPLA → AutoTileData
  47 variantes + sheets, animations d'eau DPLA préservées (contre-épreuve
  141/141 cellules == autotile officiel ts126, 11/11 frames).
- GBA : `convert_red_all.py` — palettes/chunks/BMA + cycles BPL/BPA cuits en
  frames PMDO ; scheduler CANM exact (`RedDirectGroundAnimation.lua`,
  horloge GBA 16777216/280896 → WaitFrames 60 Hz, tests lupa 3/3).
- Convergence pipeline vanilla prouvée : `audit_autotile_structural.py`
  **203/203 PASS** (mêmes clés Tilex.. que la référence vanilla, 103 263
  frames vérifiées contre l'index binaire .tile). Statut : **PASS**.

## Phase 4 — Ground (§26-27, §68)
246 grounds GBA + 118 NDS convertis, dimensions BMA exactes
(`audit_red_grounds_vs_gba.py` **246/246 PASS** : dims, animations
effectives, artefacts palette hors-ROM = 0, colorimétrie vs BPL).
Bounds séparés : grille Tiles (MapBounds) ≠ obstacles 8px (CollisionBounds)
≠ Markers (ObjectBounds) ≠ caméra. Statut : **PASS**.

## Phase 5 — Camera/Viewport (§10-14, §57, §69)
`CANONICAL_VIEWPORT_TEST.json` : **CANONICAL_VIEW_PASS** —
GBA 240×160 vs PMDO 320×240 (d09p03) et NDS 256×192 vs PMDO (temporal
pinnacle) : coordonnées monde/objets/tuiles INCHANGÉES, seules les origines
caméra diffèrent ((176,128) vs (136,88) ; (52,84) vs (20,60)), mêmes maths
que `UpdateCam` moteur. Renders `--camera-view` (RSMap_CENTERING_FIX_REPORT
5/5 PASS, STRUCTURAL_DIFF=0). Statut : **PASS**.

## Phases 6-7 — Sprites/Animations/Pokémon/Skills/Items (§30-35, §70-71)
PMDO maître partout : monstres par IDs PMDO (spawns 149/149 EXACT vs mappa ;
Red pokemon_found pret), skills waza_p → IDs PMDO (movesets boss 4 derniers
niveaux), items mappés (REQUIRES_MOD_ITEM documentés, jamais inventés),
sprites/portraits PMDO. Statut : **PASS**.

## Phase 8 — Dungeons/RogueElements (§37-38, §72)
Zones 100% GenSteps RogueElements natifs (aucune génération spéciale) ;
MapTextureStep → autotiles convertis ; fixed floors → LoadGen .rsmap
36/36 cellule/cellule vs fixed.bin. **Sinister Woods** (§18, §56) :
gloomy_forest sur tileset sinister_woods_b41 importé, sonde runtime 3 étages
peuplés + tests structurels fail-closed (`audit_texloc_references.py` :
713 cartes, 3 955 120 références Sheet/TexLoc, **0 FAIL**). Statut : **PASS**.

## Phase 9 — Events/Lua (§39, §73)
SSB Sky → Lua : 3588 COMPILED + 169 DUAL_SCREEN + 60 MULTIROUTINE
(3 PARTIAL systèmes documentés) ; stations Red EU extraites
(red_extract_eu_only_station.py). Un seul système d'événements (LuaEngine).
Statut : **PASS** (3 PARTIAL documentés avec preuve ROM).

## Phase 10 — Audio (§40, §74)
BGM ROM → OGG Content/Music, autorité MUSIC_ID_TABLE/RANDOM_MUSIC_ID_TABLE
overlay10 EU (jamais l'enum pmdsky-debug >138) ; 2775 références vérifiées,
0 manquante. SoundManager PMDO unique. Statut : **PASS**.

## Phase 11 — Hybrid runtime (§43, §58-59, §75)
- TRANSITION TEST : ROM:NDS (t01p01a) → ROM:GBA (d15p01) → ROM:NDS (g01p01b)
  dans une même session moteur — 3/3 LOAD_PASS + MOVEMENT_PASS
  (transition_test_proof.jsonl). Fix au passage : 10 grounds GBA sans
  spawners TEAMMATE_2/3 (crash RespawnAllies) complétés techniquement.
- HYBRID TEST : journeys globaux = maps ROM + équipe/combat/skills/UI/save
  PMDO (GLOBAL_JOURNEY_PASS Sky 14ch/313 étages ; RED_GLOBAL_JOURNEY_PASS
  13ch/182 étages ; re-run en cours pour cette promotion). Statut : **PASS**.

## Phase 12 — Validation finale (§76) : synthèse des tests exécutés
| Test | Résultat |
|---|---|
| Structural tileset (§55) | 203/203 PASS, 103 263 frames |
| TexLoc cartes (anti-Sinister Woods, §56) | 3 955 120 réfs, 0 FAIL |
| Fixed arenas vs fixed.bin | 36/36 PASS |
| Grounds GBA (dims/anims/palette) | 246/246 PASS |
| Zones vs tables ROM | 149/149 EXACT |
| Canonical viewport (§57) | CANONICAL_VIEW_PASS |
| Transitions (§58) | 3/3 PASS |
| Hybrid (§59) | GLOBAL_JOURNEY_PASS (Sky+Red) |
| Save/Load | RESUME_RUNTIME_PASS + RED_RESUME_RUNTIME_PASS |
| Non-régression (§61) | lockfile CH1-5 intègre à chaque commit |

## Non implémenté / limitations (avec raison, §78)
- **Provider RUNTIME dynamique (IGameContentProvider C# lisant la ROM au
  lancement)** : UNIMPLEMENTED volontaire — exigerait de modifier
  RogueEssence (contraire §62 « ne pas réécrire un système fonctionnel »)
  sans gain de fidélité : la conversion offline produit déjà des données
  bit-fidèles chargées par les chargeurs uniques du moteur ; les deux
  chemins convergent avant génération/rendu comme exigé (§17). Le registre
  de provenance (§4/§48) est fourni en données (CONTENT_REGISTRY.json).
- 27 grounds NDS `dXXp21a` (aires standard non importées) : documentés
  dans KANGASKHAN_STATUE_PLACEMENT_REPORT.json (absent_grounds).
- 3 scripts Sky PARTIAL (debug room, loterie, init titre) : preuve ROM
  documentée, hors gameplay.

## Prochaines étapes possibles
Import des 27 grounds dXXp21a restants ; extension du registre aux
sprites/skills individuels ; portage DTEF direct (dungeon.bin → dossiers
DTEF + DtefImportHelper) comme variante d'import alternative.
