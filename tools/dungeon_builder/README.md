# Dungeon Builder

Outil de création de donjons **au-dessus de RogueElements**, piloté par des
définitions externes (`DungeonDefs/canonical/*.json`). Il ne remplace pas le
moteur : il compose des `GenSteps` RogueElements / RogueEssence / PMDC natifs,
que le jeu exécute avec son propre RNG à chaque entrée dans le donjon.

Lire d'abord : `docs/dungeon_builder/AUDIT_ROGUEELEMENTS.md` (capacités
réellement vérifiées dans le code source) et
`docs/dungeon_builder/PROTOTYPE_METRICS.md` (preuves chiffrées).

## Commandes

```bash
python3 tools/dungeon_builder.py audit                       # profils, tilesets, définitions, partages interdits
python3 tools/dungeon_builder.py verify sinister_woods --report   # parité profils/steps + conformité de l'export
python3 tools/dungeon_builder.py ground sinister_woods --role midpoint --sheet SinisterWoodsB41 --preview
python3 tools/dungeon_builder.py prototype --per-profile 6 --report
python3 tools/dungeon_builder.py preview sinister_woods --floor 7 --count 10 --ascii
python3 tools/dungeon_builder.py validate sinister_woods --count 10
python3 tools/dungeon_builder.py generate sinister_woods     # écrit Data/Zone/<id>.json + rapport
python3 tools/dungeon_builder.py generate-all --chapters 6-32
```

`--seed` existe partout : **debug uniquement**, pour rejouer un cas litigieux.
Aucune seed n'est écrite dans les données de production.

## Architecture

| Module | Rôle |
|---|---|
| `definitions.py` | `DungeonDefinition` / `Segment` : chargement, validation, cascade donjon → segment → étage |
| `profiles.py` | `ArchitectureProfile` : `branching`, `looping`, `dense`, `large_rooms`, `mixed`, `ring`, `lattice`, `twosides`, `crossroads` (+ overrides par donjon) |
| `re_sim/` | Simulateur hors-ligne : portage fidèle de `GridPlan`, `GridPath*`, `RoomGen*`, `ConnectGridBranchStep`, `SetGridDefaultsStep`, `CombineGridRoomStep`, `FloorStairsStep` — **validation et preview uniquement** |
| `steps.py` | Adaptateur RogueElements : fabrique les `$type` JSON natifs (vocabulaire vérifié contre les zones existantes) |
| `templates/` | Gabarits natifs extraits du dépôt (boutique Kecleon, monster house) réutilisés tels quels |
| `dtef.py` | Résolution/vérification des auto-tilesets DTEF (`Data/AutoTile` + `Content/Tile`) |
| `grounds.py` | Scènes fixes : entrée / midpoint / Ground de fin, arbitrage boss `canonical_ground` vs `dedicated_arena` |
| `rng.py` | Politique de seeds (entropie OS, jamais de seed figée, traçabilité debug) |
| `validation.py` | Fairplay, traversabilité, signature structurelle, rejet + régénération des doublons |
| `zone_export.py` | Écriture de `Data/Zone/<id>.json` et de `index.idx` |
| `conformance.py` | Parité profil ↔ simulateur ↔ export, et conformité des `$type`/champs émis aux zones livrées |
| `ground_pipeline.py` | Grounds fixes : clone du template validé + retexture tuile à tuile sur la planche du donjon, index, preview PNG |
| `report.py` | Rapport automatique JSON + Markdown (`docs/dungeon_builder/reports/`) |
| `prototype.py` | Prototype isolé de démonstration des capacités |

## Écrire une définition

Voir `DungeonDefs/canonical/sinister_woods.json`. Champs principaux :
`id`, `name`, `chapter`, `route`, `source`, `floors`, `biome`, `dtef`,
`variation.direction` (`fond`/`sommet`), `stairs`, `profiles`, `pokemon`,
`items`, `features` (`shop`, `monster_house`, `treasure_room`, `key_room`,
`weather`, `mystery`, `traps`), `segments[]` (avec héritage/surcharge des
tables), `minibosses`, `midpoint`, `boss`, `fixed_grounds`.

Règles appliquées automatiquement :

* les segments doivent couvrir **exactement** 1..`floors`, sans trou ni
  chevauchement ;
* un tileset DTEF non importé fait **échouer** la génération ;
* un étage fixe (`fixed_floors`) est exporté en `LoadGen` + `MappedRoomStep` ;
* si le donjon possède un Ground de fin exploitable, le boss s'y déroule
  (`boss.mode = "canonical_ground"`) ; sinon `arena_rsmap` exige un `.rsmap`
  existant avant conversion. Le Builder **scanne** `Data/Ground` (id + `aliases`)
  et refuse `arena_rsmap` dès qu'une scène finale canonique existe — voir
  `docs/dungeon_builder/GROUNDS_AND_BOSS_RULES.md` ;
* deux donjons ne peuvent pas partager le même triplet de tileset sans
  `dtef.justification`.
