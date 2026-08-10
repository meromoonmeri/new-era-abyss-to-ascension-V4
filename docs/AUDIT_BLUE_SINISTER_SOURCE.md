# Audit source NDS réel — Sinister Woods (Blue)

**ROM** `POKEMON-ROM/...Blue...nds` 32 MiB, `dungeon.sbin` 2 083 216 o, 256 entrées `bXX` (16 o/entry)

**Identification** : `message_e.bin` 5184 strings, ordre `Thunderwave Cave 0, Mt. Steel 1, Sinister Woods 2…` → **Sinister Woods ID 10** (`b10canm` 1152→1088 SIR0, `b10fon` 10 177, `b10cel` 2 054, `b10pal` 768, `b10cex` 848→816 SIR0)

## Décodage NDS (état actuel, honnête)

| Fichier | ROM offset | Compression | Structure | Champ → Valeur → Fonction | Statut |
|---|---|---|---|---|---|
| `b10canm` | 154544 | SIR0 `53495230 d003…` → 1088 o `0c00 0d00 53ff…` | **Mappa NDS** (grille) | `0c00` = 12, `0d00` = 13 → **12×13 ?** (header `0c00 0d00` = 12×13, `0c00 0c00` =12×12 pour b10canm décompressé `0c00 0d00` =12×13 ? Actuel `0c00 0d00` =12×13, `0c00 0c00` pour b06) | **NOT DECODED** (handler Sky `MappaBin` échoue `This is not valid Sir0` car NDS Mappa ≠ Sky Mappa) |
| `b10fon` | 158608 | raw `41543450 58c1…` (ATCP) | **Floor** (génération) | `0b…` (13 floors) | **NOT DECODED** |
| `b10cel` | 155696 | raw `41543450 5806…` (AT4P) | **Monster** (tables) | `06 08 0e…` | **NOT DECODED** |
| `b10pal` | 168800 | raw 768 o `00b7df80…` | **Palette** | 768 o | **DOCUMENTED** |
| `b10cex` | 157760 | SIR0 `53495230 1000…` → 816 o `41543450 5827…` | **?** (peut-être extra) | `02 04 05…` | **NOT DECODED** |

**Conclusion** : `b10` décompressé, mais **Mappa NDS non décodé** (handler manquant). `pmd-red` est utilisé comme **cross-reference uniquement**, pas comme source.

## Cross-reference Red (pmd-red/data/dungeon/SinisterWoods)

| Élément | Red | Blue (NDS) | Concordance |
|---|---|---|---|
| Étages | 13 (floor_id.json MainData 17-29) | `b10` 13 (déduit, non décodé) | **À vérifier** (Blue b10canm 1088 o vs Red 13) |
| Pokémon | 13 tables (ex. F1 `oddish 7 1579, sudowoodo 7 4210, swinub 8 4211` …) | `b10cel` 2054 o (AT4P) **NOT DECODED** | **UNKNOWN** |
| Objets | `dungeon_item_data.json` Sinister 1F-3F / 4F-13F | `b10` **NOT DECODED** | **UNKNOWN** |
| Géométrie | `main_data.inc` 13 lignes `0x0b…` (cell 10×10 wall3 etc.) | `b10fon` 10177 o (ATCP) **NOT DECODED** | **UNKNOWN** |

## Mapping vers PMDO (à ne faire qu'après décodage)

| Blue comportement | PMDO équivalent | Adaptation | Limitation |
|---|---|---|---|
| Grille 12×13, cell 10×10 wall3 | `InitGridPlanStep CellWidth 10 CellHeight 10 CellWall 3` | `UNKNOWN` (Blue non décodé) | `UNKNOWN` |
| Salles 4-8, couloirs 1-2, Branch 35-61, Room 75-86, Connect 55% | `RoomGenRound`, `PermissiveRoomGen`, `GridPathBranch` | `UNKNOWN` | `UNKNOWN` |
| Étages 13, Pokémon, items, traps, stairs, terrain, musique | `TeamSpawn`, `ItemData`, `TrapData`, `EffectTile`, `Content/Music` | `UNKNOWN` | `UNKNOWN` |

## Prochaine étape (ordre imposé)

1. Décoder NDS Mappa (analyser `0c00 0d00` header, suivre pointeurs SIR0, documenter chaque champ `Blue b10/... → valeur`)
2. Ne plus utiliser `pmd-red` comme source de vérité (uniquement `Blue b10 → X` / `Red → X` → `cohérence`)
3. Produire table **F1→F13** avec `SOURCE_NDS` / `CROSS_REFERENCE_RED` / `DERIVED_MAPPING` / `PMDO_VALUE` pour chaque donnée (ne pas recopier `pmd-red` comme Blue)
4. Ensuite seulement : mapping, génération, intégration, Team Meanies→Dazzling, musique, clairière, boss, tests, matrice de provenance

**Aucune modification de `gloomy_forest.json`/`index.idx` ne sera poussée avant cet audit.**

