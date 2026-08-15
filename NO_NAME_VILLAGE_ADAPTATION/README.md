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

## Adaptation PMDO structurée et validation réelle

L'adaptation jouable de `rmvillage` est matérialisée en quatre Grounds natifs :
`no_name_village_spring`, `summer`, `autumn` et `winter`. Les quatre conservent
les 78×78 cellules source, le rapport d'échelle 64→24 px, les chemins issus de
`grass0`, les masks/colliders officiels, les maisons et les coordonnées de
portes. Le relief bloqué est rendu par une lisière PMD cohérente plutôt que par
des murs invisibles.

La sélection saisonnière ne dépend pas du calendrier de Metano :
`VillageState.SeasonFromSourceStage()` transpose littéralement les intervalles
VM source (`<2`, `<3`, `<4`, `<8`). Les variantes PMD des arbres, forêts et
bâtiments sont distinctes. Les VFX PMDO sont `sakura_drift`,
`autumn_leaves` et `winter_snow`. Les quatre valeurs numériques source de
`global.timeofday` restent 0–3, sans leur inventer de libellé, et pilotent
l'éclairage MapStatus ainsi que les substitutions audio saisonnières.

La flore ne repose plus sur une décoration générique : les 185 instances source de `objspplant*` sont matérialisées au printemps, en été et en automne, et les 94 instances dont la VM prouve une correspondance hivernale le sont en hiver. Les lignées absentes en hiver restent absentes. Chaque paquet floral PMD conserve 3 ou 4 frames animées selon la variante source.

Les quatre intérieurs font 720×480 px, dimensions normalisées des rooms source
1920×1280. Ils n'ont aucun humain ni lit humain, utilisent du mobilier Pokémon,
et reviennent aux quatre coordonnées exactes décompilées. Les quatre frontières
sont désormais résolues par le GML officiel vers `rm54`, `rm65`, `rm45` et
`rm56`; elles restent volontairement verrouillées tant que ces rooms voisines
ne sont pas reconstruites et validées.

Les huit Grounds, leurs scripts Lua réels, les déplacements et les collisions
bloquantes ont été chargés dans PMDO **0.8.12** exact par la méthode headless
d'Agent A. Les quatre états temporels ont également produit quatre captures
runtime distinctes. Voir `reports/runtime-validation.json`, `reports/runtime/`
et `reports/runtime-time/`.
