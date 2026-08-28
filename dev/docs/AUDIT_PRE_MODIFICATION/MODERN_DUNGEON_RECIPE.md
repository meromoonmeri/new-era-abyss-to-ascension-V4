# MODERN DUNGEON RECIPE — RECETTE CIBLE « DONJON MYSTÈRE » POUR CE PROJET

Fusion : règles ROM (ROM_GENERATION_RULES.md R1–R14) + patterns DoubleTrio (DOUBLETRIO_DUNGEON_RECIPE.md) + capacités RogueElements/PMDC (ROGUEELEMENTS_CAPABILITY_MATRIX.md) + acquis du projet (PMDO_DUNGEON_ARCHITECTURE.md). **Moderniser ≠ simplifier** : rien n'est retiré ; on ajoute variété, fidélité, plafonds canoniques.

## 0. Principes non négociables
- Zones CH1–CH5 verrouillées : EXCLUES de toute application automatique.
- Zéro générateur par-donjon ; uniquement primitives génériques + data.
- Chaque changement de data est justifié par une règle Rn ou un champ mappa_s/FloorProperties (traçabilité binaire), jamais « à l'œil ».
- Non-régression : dprobe + journeys + audits existants re-exécutés après chaque lot.

## 1. Architecture cible (mapping sur l'existant — pas de nouveaux namespaces fantaisistes)
La « PMDXxxGenerator family » demandée existe déjà sous forme de primitives RogueElements/PMDC ; la modernisation est une COUCHE DE COMPOSITION DATA + 4 petites primitives nouvelles :
```
PMDDungeonGenerator      = Zone JSON (Segments Layered/Singular/RangeDict)
PMDFloorGenerator        = GridFloorGen / RoomFloorGen + GenSteps priorisés
PMDRoomGenerator         = SpawnList<RoomGen> par étage (mix Square/Round/Cave/Cross/
                           Blocked/Bump/Diamond/Triangle/Plus + NOUVEAU RoomGenMaze,
                           NOUVEAU RoomGenImperfect)
PMDCorridorGenerator     = AngledHall + ConnectGridBranchStep(%) + dead-ends
PMDSpawnGenerator        = PlaceRandomMobsStep + MobSpawnSettingsStep (déjà ROM-exact)
PMDItemGenerator         = Item/Money/Terminal/Due/TerrainSpawnStep (déjà en place)
PMDTrapGenerator         = TileSpawnZoneStep + RandomSpawnStep<EffectTile> (déjà)
PMDShopGenerator         = ShopStep branché sur kecleon_shop_chance ROM
PMDMonsterHouseGenerator = SpreadHouseZoneStep + NOUVEAU scaling ∝ salle
PMDSpecialFloorGenerator = SpreadRoomZoneStep (Evo/LoadMap) + RangeDictSegment
PMDMysteryFloorGenerator = NOUVEAU hidden stairs (EffectTile + segment trésor)
PMDRNG                   = ReRandom seedé (natif, PASS)
PMDFloorRules            = MapDataStep (sight/time/musique/météo)
PMDEffect/Particle/Event = MapStatus/MapEffectStep/ScriptZoneStep (natifs)
```

## 2. Lots de modernisation (ordonnés par valeur canonique)

### LOT A — Fidélité structurelle Sky (R6) : mapping `structure` → path exact
Pour chacune des 149 zones Sky : lire `layout.structure` de chaque étage dans nos tables mappa et forcer le path correspondant :
`MEDIUM/MEDIUM_LARGE/SMALL → GridPathBranch (dims R2)` · `RING → GridPathCircle` · `CROSSROADS/CROSS → GridPathCross` · `BETTLE → GridPathBeetle` · `LINE → InitGridPlan 1 rangée` · `SMALL_MEDIUM → dims réduites`.
+ `extra_hallway_density>0` (1623 ét.) → ConnectPercent calibré ; `dead_ends` (726 ét.) → tolérance impasses.
Impact : 74 étages exotiques retrouvent leur silhouette ROM ; le reste inchangé (déjà branch).

### LOT B — Monster Houses canoniques (R4)
1. Nouvelle primitive générique `MobThemeRoomScaled` (dérivée MobTheme) : Amount = clamp(RandRange(70 %,80 % · tuilesSalle), 1, capData) ; capData=18 (GBA), 30 (Sky), 3–4 si empty MH.
   Alternative immédiate 100 % data (phase 1) : relever Amount à Min 10/Max 18 sur les zones GBA, garder plage Sky selon mappa.
2. Ajouter items+pièges 50/50 dans les HouseStepSpawns (R4.5 : min 6, max 7 GBA).
3. `empty_monster_house_chance` (18 ét. Sky) : variante MH à 3-4 mobs sans items.
4. Tests §37 : générer MH et vérifier runtime 10+/15+ mobs (pathfinding/AI/perf).

### LOT C — Mystery Floors Sky (R11) : hidden stairs
1. Nouveau `Data/Tile/stairs_hidden.json` (EffectTile invisible-jusqu'à-révélation, résultat = segment trésor).
2. `SpreadStepZoneStep` par zone Sky avec `hidden_stairs_spawn_chance` mappa par plage d'étages (435 étages).
3. Segment « treasure floor » générique (LayeredSegment 1 étage, tileset dédié, items rares) — data partagée, pas par-donjon.

### LOT D — Sticky items (R12) : injecter `Cursed=true` avec proba `sticky_item_chance` dans les ItemSpawnZoneStep des 907 étages Sky concernés (transformation purement data, script d'application + rapport AVANT/APRÈS).

### LOT E — Kecleon (R5) : brancher `kecleon_shop_chance` mappa (973 ét.) via SpreadStepRangeZoneStep<ShopStep> par plages contiguës (même technique que MONSTER_HOUSE_CHANCE_FIX). Garde-fous ROM : exclusivité MH, salle ≥5×4.

### LOT F — Formes de salles (R7/R8/R10)
1. `RoomGenMaze` : primitive générique (algo GenerateMazeLine ROM : murs en serpentin, variante eau).
2. `RoomGenImperfect` (ou post-proc `ImperfectRoomStep`) : grignotage de coins ROM (60 %, (w+h)/4 itérations).
3. Structures secondaires : PatternTerrainStep (PMDC) pour DIVIDER/CHECKERBOARD/POOL ; composition `IslandRoomStep` (douve+île+warp+items+piège R8-ISLAND).
4. Enrichir les SpawnList<RoomGen> des zones non verrouillées : +Diamond/Triangle/Plus/Cave à faible poids (variété DoubleTrio) — jamais sur les 31 zones locked.

### LOT G — Rythme DoubleTrio (rejouabilité)
1. Variation topologique par plage : SpreadStepRangeZoneStep<AddConnectedRoomsStep> en profondeur (densification), à la DT -2.2.
2. Étages RoomFloorGen intercalés pour les moments spéciaux (déjà nos boss ; étendre aux étages « respiro » type Sky rest floors).
3. Vaults/coffres (Detours+Seals+ChestStep) là où fixed_floor_id ROM l'indique.

### LOT H — Représentation & outillage (§16 ASCII)
Étendre `dprobe` d'un dump ASCII par étage (murs/sol/couloirs/salles/escaliers/pièges/spawns/shop/MH — RogueElements sait déjà rendre ; GenContextDebug existe) → outil `dev/tools/dungeon_ascii_probe.py` + stats de dissimilarité (graph hash de salles, positions, spawns) pour §17/§19-20.

## 3. Plan de tests (avant→après chaque lot)
1. **Statistiques** (§36) : ≥100 générations/donjon échantillonnés (outil runtime dprobe multi-seed) : rooms, tailles, couloirs, topologie (hash), mobs/items/pièges par étage, taux MH/Kecleon/hidden, doublons/near-duplicates.
2. **Runtime** (§39) : journeys complets Sky+Red (déjà harnachés) + tests MH haute densité.
3. **Non-régression** (§41) : lockfile CH1–CH5, audits autotile/TexLoc/arènes/zones EXACT, renders.
4. Comparaison ROM : densités attendues = formules R3 sur FloorProperties/mappa (exactitude distributionnelle, pas séquence RNG).

## 4. Critères PASS (§44-45)
Un lot n'est PASS que si : règle Rn citée, données ROM re-vérifiées, primitive native utilisée/créée générique, stats 100 gén. conformes aux formules ROM, runtime OK, non-régression OK, rapport AVANT/APRÈS chiffré.
