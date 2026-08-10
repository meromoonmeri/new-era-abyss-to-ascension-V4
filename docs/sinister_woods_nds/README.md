# Sinister Woods — dossier de reconstruction NDS

## Sources
- **SOURCE_NDS** : ROM Blue Rescue Team Europe `APHP`  
  `POKEMON-ROM/Pokemon Mystery Dungeon - Blue Rescue Team (Europe) (En,Fr,De,Es,It).nds`
- **CROSS_REFERENCE_RED** : `pret/pmd-red` (noms de champs `FloorProperties`, enums monstre, concordance)
- **PMDO_VALUE** : état actuel New Era (`gloomy_forest.json`) — **jamais** une preuve NDS

## Outils
| Outil | Rôle |
|---|---|
| `tools/audit_blue_sinister.py` | Audit / extraction SOURCE_NDS |
| `tools/convert_blue_sinister.py` | Conversion (bloquée tant que UNKNOWN restent) |
| `tools/verify_sinister_fidelity.py` | A=source fidelity, B=PMDO validation |

## Ordre imposé
1. Extraire ROM → `dungeon.sbin` → `mapparam` + blobs `bXX*`
2. `python3 tools/audit_blue_sinister.py`
3. Lire `AUDIT_SOURCE_NDS.md`
4. `python3 tools/verify_sinister_fidelity.py`
5. Conversion **uniquement** si A=PASS (aujourd’hui **NON**)
6. **Ne pas** modifier `gloomy_forest.json` avant validation

## Résultat actuel (résumé)
- 13 floors FloorProperties + floor_id : **SOURCE_NDS**
- Concordance bytes avec Red main_data/floor_id : **oui** (cross-check, pas une preuve circulaire)
- tileset id floors = **41** → blobs `b41*` (pas `b10*` pour le tileset procédural)
- `b10*` / `B10P01*` : présents NDS ; rôles distincts (graphics set vs grounds cutscene)
- Items/traps/music SEQ/géométrie générateur complète : **UNKNOWN**
- **SOURCE FIDELITY port : NOT PASS** — ne pas dire « Sinister Woods est porté »
