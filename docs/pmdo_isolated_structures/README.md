# Structures PMDO isolées compatibles NNV

Autorité : `audinowho/DumpAsset` au commit `9d864d1425f002b051e7a54fffc639988d8ef9c9`.

## Règle

Seuls les objets autonomes de `Content/Object/` sont admis. Aucun morceau de
Ground, de Map ou de tileset n'est extrait. Les pixels, dimensions, palettes,
transparences et frames restent strictement identiques. Sur NNV, les structures
devront être des `GroundObject` séparés au-dessus des layers source.

## Structures qualifiées

| Asset | Dimensions | Frames | Usage possible |
|---|---:|---:|---|
| `House_Normal.dir` | 112×112 | 1 | Maison végétale |
| `Tent.dir` | 80×80 | 1 | Tente décorée |
| `Tent_Plain.dir` | 96×96 | 1 | Tente simple |

## Éléments inspectés mais exclus

- `Assembly.dir` et `Assembly_Snow.dir` : petites animations florales, pas des bâtiments.
- `Storage.dir` : coffre, pas une structure habitable.

## Statut

`NOT_PLACED / NOT_RUN`. Cet inventaire n'autorise encore aucun placement : les
positions, emprises de collision et interactions doivent être validées sans
modifier un seul pixel de `rmvillage`.
