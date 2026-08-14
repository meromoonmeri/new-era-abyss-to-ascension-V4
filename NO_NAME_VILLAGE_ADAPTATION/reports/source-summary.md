# No Name Village — audit source GameMaker

- **État :** `SOURCE_STRUCTURALLY_EXTRACTED`
- **Rooms :** 98
- **Room principale :** `rmvillage`, 4992×4992 px, 18 layers, 886 instances
- **Objets :** 727
- **Sprites :** 2775 (1593 animés)
- **Tilesets :** 30 (3 animés)
- **Sons :** 388
- **Colliders solides placés :** 10737
- **Transitions/portes placées :** 319

## Saisons

Le système quatre saisons est réel : variable `season`, scripts `scrseasonmap`/compteurs saisonniers, familles complètes d’objets et sprites, contrôleurs hiver/neige et substitutions d’arbres/plantes. Les quatre variantes de `rmvillage` sont reconstruites depuis les layers, tilesets et instances — pas depuis une capture.

La logique VM exacte de post-traitement hiver reste `UNVERIFIED`; aucune conversion PMDO ne sera certifiée avant sa résolution.

## Village

- Layers : invisible, EndVillage, Above, plants, instances, trees, sHouseBelow, HouseBelow, EndVillage2, cliff, endwater, shadows, vegetation, Below, grass1, grass0, groundtex, ground
- Portes/transitions : 8
- Spawn points : 6
- Maisons : 4
- Colliders solides : 259

## Frontière PMDO

Aucun `.rsground` n’est encore produit. Le prochain gate doit résoudre les destinations de chaque RoomCC, la logique saisonnière VM, les effets neige/jour-nuit et le rendu exhaustif des 98 rooms avant adaptation des bâtiments PMU.
