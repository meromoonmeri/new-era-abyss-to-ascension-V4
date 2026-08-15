# No Name Village → PMDO/PMU

Pipeline séparée pour auditer `No.Name.Village.zip`, conserver son système réel
(layout, intérieurs, événements, saisons et états temporels), puis reconstruire
une adaptation native PMDO. L’archive est une entrée en lecture seule ; aucun
PNG de capture ne peut devenir une map ou un layer.

L’archive publique est stockée par Git LFS. Le lecteur vérifie obligatoirement
son SHA-256 LFS avant audit. Les sources brutes et l’archive restent hors Git ;
seuls les rapports structurés compacts et les futurs candidats PMDO sont suivis.

## État source actuel

`data.win` a été réassemblé et vérifié (`2f33b595…`, 301 037 316 octets).
L’extraction structurale identifie 98 rooms, 727 objets, 2 775 sprites,
30 tilesets, 96 pages de texture et 388 sons. `rmvillage` mesure exactement
4 992×4 992 px et conserve 18 layers, quatre portes, quatre transitions de
bord, six spawn points, quatre maisons et 259 colliders solides.

Le système printemps/été/automne/hiver est source-prouvé par la variable
`season`, les scripts saisonniers, 131 objets, 37 sprites et les contrôleurs de
neige/hiver. Les rapports et rendus de contrôle sont sous `reports/`.

## Extraction officielle exhaustive

Le second audit exécute désormais UndertaleModLib lui-même sous .NET/WASM. Les
inventaires complets, le VM brut, les 2188 entrées GML, les bytes de masks et de
textures sont sous `extracted/official/`. Les 388 fichiers audio restent hors
Git à cause de leur volume, mais leur manifeste SHA-256 exhaustif est suivi et
le runner les régénère depuis le `data.win` vérifié.

Les outils `build_utmt_wasm_bundle.py`, `NoNameVillageExtractor.cs`,
`decode_official_textures.py` et `extract_all_frames.py` rendent le pipeline
reproductible sans modifier la source. `season-vm-evidence.json` et
`time-system.json` remplacent les anciennes conclusions `UNVERIFIED` sur la VM.

## Frontière environnementale PMDO

Avant toute composition, l'inventaire PMDO-scopé est régénéré depuis le modèle
officiel suivi :

```bash
python3 NO_NAME_VILLAGE_ADAPTATION/tools/build_environment_inventory.py
python3 NO_NAME_VILLAGE_ADAPTATION/tests.py
python3 NO_NAME_VILLAGE_ADAPTATION/test_environment_inventory.py
```

Il couvre les 98 rooms, conserve les hashes et placements environnementaux,
exclut les 13 rooms système et sépare explicitement décor, fonctions spatiales,
rôles sociaux et éléments ambigus. Les sprites/codes humains ne sont jamais
importés, mais une fonction sociale prouvée reste `ROLE_ADAPTATION_REQUIRED` :
elle devra être reconstruite avec un Pokémon natif et les systèmes existants
`LivingWorld`, `TownLife`, `TownPlace`, `Seasons`, `Weather` et l'AI PMDO. Sa
sortie compressée est `reports/environment-inventory.json.gz`. Ce gate n'émet
aucun Ground et ne peut attribuer `CONVERTED`, `CERTIFIED` ou `PROMOTED` : les
éléments ambigus restent bloqués en `REVIEW_REQUIRED`.
