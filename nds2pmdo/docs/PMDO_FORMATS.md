# Formats cibles PMDO 0.8.12 — ce que le convertisseur doit produire

PMDO 0.8.12 (RogueEssence) charge les mods depuis `Mod.xml` + `Data/` + `Content/`.
Les formats ci-dessous sont ceux observés dans le mod New Era (référence PMDO_VALUE,
jamais une preuve NDS).

## 1. Zones de donjon — `Data/Zone/<id>.json`

```json
{ "Version": "0.8.9.0", "Object": {
    "$type": "RogueEssence.Data.ZoneData, RogueEssence",
    "Name": {"DefaultText": "Sinister Woods", "LocalTexts": {"fr": "…"}},
    "Released": true, "Segments": [ … ] } }
```

- `Segments[]` = tranches d'étages ; chaque segment contient `Floors.nodes[]` avec
  un `$type` de générateur (`RogueEssence.LevelGen.GridFloorGen, RogueEssence` …)
  et des `GenSteps` (musique, terrain, spawns, items, pièges, maisons de monstres…).
- Les paramètres NDS (`layout`, `roomDensity`, `enemyDensity`, `monsterHouseChance`,
  `kecleonShopChance`, `trapDensity`, `itemDensity`, `buriedItemDensity`, …) se
  traduisent dans les étapes de génération PMDO correspondantes
  (`MapDataStep`, spawn steps, terrain steps…). C'est la stratégie
  `ADAPTATION_REQUIRED` : les champs sont SOURCE_NDS, la traduction vers les
  valeurs PMDO est un mapping documenté (pas une preuve NDS).

## 2. Grounds — `Data/Ground/<id>.rsground`

```json
{ "Version": "0.8.9.0", "Object": {
    "$type": "RogueEssence.Ground.GroundMap, RogueEssence",
    "TexSize": 1, "Name": {"DefaultText": "…"},
    "obstacles": [ {"Bounds": {"X":0,"Y":0,"Width":8,"Height":8}, "Tags": 1}, … ],
    "tiles": [ … ], "entities": [ … ] } }
```

- Ground = scène 2D (ville, cinématique) : tuiles, obstacles, entités (PNJ),
  scripts de ground (`Data/Script/halcyon/…`), musique (`Music`), weather.
- Les blobs `B10P01A/B/C` de `ground.sbin` sont les packages de cinématique
  Sinister Woods : leur décodage complet (tilemaps, sprites, scripts) est `UNKNOWN`.

## 3. Maps — `Data/Map/<id>.rsmap`

Cartes de combat/arènes : `RogueEssence.Dungeon.Map` (équipes, positions,
`serializationLoc`, `serializationDir`…).

## 4. Tiles — `Data/Tile/*.json` et `Content/Tile/*.png`

- Tiles dynamiques (escaliers, lave, eau animée) : `Data/Tile/*.json` (ex.
  `stairs_go_up.json`, `flowing_lava.json`) + `Data/Tile/index.idx`.
- Tilesets de donjon : `Content/Tile/<tileset>.png` (feuille de tiles) + `Data/Tile/index.idx`.
- `RESERVE/red_tiles/*.tile` et `RESERVE/sky_tiles/*.tile` = tilesets importés des
  autres jeux (CROSS_REFERENCE — jamais présentés comme extraits de la ROM APHP).

## 5. Scripts — `Data/Script/<namespace>/…` (Lua/C#)

Les scripts de scènes et cinématiques du mod sont en Lua (`Data/Script/halcyon/`) ;
les événements de donjon passent par les `GenSteps` JSON. Le convertisseur devra
émettre les deux formes (voir `NDS_TO_PMDO_CORRESPONDENCE.md`).

## 6. Audio — `Content/Music/*.ogg` + boucles

PMDO utilise des fichiers OGG avec boucle (ex. `Content/Music/`). Les musiques NDS
(SSEQ dans le SDAT) devront être converties en OGG **avec conservation des points
de boucle** — extraction des boucles SSEQ = UNKNOWN pour l'instant.

## 7. Contenu graphique — `Content/`

BG (fonds de cinématique), Chara (sprites de personnages), Item (objets),
Portrait, Particle (particules/VFX), UI… — les formats de texture PMDO sont des
PNG (feuilles) + fichiers `.dir`/`.mdir` (descripteurs). Les sprites NDS (monster.sbin)
ne sont pas encore décodés (UNKNOWN).

## Règle d'or

Un fichier PMDO qui « charge » ne prouve pas la fidélité. Chaque élément généré
doit être accompagné de son manifest de provenance et validé par comparaison
source → rendu (étape `validation/` du pipeline).
