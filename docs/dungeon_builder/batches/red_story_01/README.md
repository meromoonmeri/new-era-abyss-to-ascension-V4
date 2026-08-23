# Lot Red Story 01 — Tiny Woods + Thunderwave Cave

## Statut

| Donjon | Floors | Mapgen PMDO | Route PMDO | Promotion | Blocker restant |
|---|---:|---:|---:|---:|---|
| Tiny Woods | 3 | 30/30, invalid 0 | PASS | non | `CANONICAL_MUSIC_ASSET_MISSING` |
| Thunderwave Cave | 5 | 50/50, invalid 0 | PASS | non | `CANONICAL_MUSIC_ASSET_MISSING` |

Les deux routes chargent l’entrée canonique, chaque floor, le Ground final D01P02/D02P02, puis reviennent au Ground d’entrée après `EndGame` natif. Les seeds et escaliers sont journalisés.

## Règles réconciliées

- shops désactivés : `kecleonShopChance=0` ;
- Monster Houses désactivées : `monsterHouseChance=0` ;
- météo claire conservée ;
- Tiny Woods : `trapDensity=0` ;
- Thunderwave Cave : Wonder Tiles et densité 3 ;
- espèces, probabilités, objets et floors issus des manifests ROM ;
- objets limités à leurs floors source ;
- niveaux New Era séparés comme `SUPPLEMENTAL` ;
- profils RogueElements explicitement `INFERRED` et sélectionnés par `ChanceFloorGen`.

## Assets et décision de non-promotion

Les DTEF `tiny_woods` et `thunderwave_cave` existent dans PMDO. En revanche, les pistes PMD Red `Tiny Woods.ogg` et `Thunderwave Cave.ogg` n’existent ni dans `Content/Music` du mod ni dans le catalogue PMDO base. Le mapgen accepte le champ texte sans charger l’audio ; ce n’est donc pas une preuve d’asset.

La tentative de promotion a été annulée après le préflight. Les `Data/Zone` actives ont été restaurées. Aucune musique de remplacement n’est utilisée.

## Preuves

- `batch_report.json` ;
- `native_mapgen_report.md` ;
- `runtime/native_mapgen.jsonl` ;
- `runtime/routes/tiny_woods.jsonl` et `.log` ;
- `runtime/routes/thunderwave_cave.jsonl` et `.log`.
