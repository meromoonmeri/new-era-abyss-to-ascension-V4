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
