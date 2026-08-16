# Résolution : les structures PMU sont-elles autonomes ?

Ce rapport clôt la question ouverte du projet : **les maisons/bâtiments PMU
existent-ils comme structures autonomes, ou uniquement comme compositions de
maps ?** La réponse est établie par re-dérivation depuis la source, jamais par
un crop PNG ni par une impression visuelle.

## Réponse courte

Les deux à la fois, et c'est la distinction qui débloque la mission :

- **Les maps PMU ne contiennent aucune structure.** Le modèle de données est une
  grille plate `Tile[,]`. Il n'existe dans tout le client **aucune** classe
  `Structure`, `Building`, `Prefab`, `Group` ou `Stamp`. Une maison peinte dans
  `s737` n'est qu'un ensemble de cellules voisines ; rien dans la donnée ne dit
  où elle commence ni où elle finit. **Extraire une maison depuis une map est
  donc impossible sans deviner un périmètre** — c'est exactement l'erreur des
  premiers essais.
- **Les archives de tuiles PMU, elles, contiennent de vraies structures
  autonomes.** Les composants bâtiment y sont stockés comme art complet sur fond
  transparent, indépendamment de toute map.

Autrement dit : **la source exploitable est l'archive `.tile`, pas la map.**

## Preuves

Modèle de données (autorité : `PMU-Client/Client/Maps/Tile.cs`, commit épinglé
`c25c01f9879369647cd5a19731b2e4e5acd33e67`) — une cellule ne porte que des
index graphiques par couche (`Ground`, `Mask`, `Mask2`, `Fringe`, `Fringe2`,
leurs variantes `Anim` et leurs `Set`), un `Type`, `Data1..3` et `String1..3`.
Aucun champ ne relie une cellule à un objet parent. Il n'y a **aucun identifiant
de structure**, donc aucun périmètre prouvable à l'intérieur d'une map.

Format d'archive (autorité : `Client/Graphics/Tileset.cs`) : int32 LE
`width`/`height`, puis par tuile un offset int64 et une taille int32, puis les
enregistrements PNG 32×32. L'outil
`tools/audit_pmu_structure_autonomy.py` reconstruit l'atlas natif et
re-dérive chaque candidat depuis sa bbox déclarée.

Résultat sur les 143 candidats suivis :

| Classification | Nombre |
|---|---:|
| `AUTONOMOUS_CONFIRMED` | 48 |
| `REVIEW_REQUIRED` | 95 |
| `MAP_FRAGMENT_ONLY` | 0 |
| `BLOCKED` | 0 |

Pour les 48 confirmés : **0 pixel de divergence RGB** sur 622 268 px de bbox
re-dérivés, et 2 122 px voisins réellement retirés par le masque alpha. Cela
prouve simultanément qu'aucun recolor/rééchantillonnage n'a eu lieu et que le
masque isole bien la composante connexe au lieu de livrer un rectangle.

Les 95 autres restent `REVIEW_REQUIRED` : ils viennent de `Tiles8.tile`, dont le
SHA-256 **diffère** entre le manifeste `PMU.zip`
(`25ac58ccd8caef66…`) et le client public épinglé (`e63a982d86279f3d…`).
Leur autonomie n'est pas re-dérivable depuis une source publique ; ils ne sont
donc pas promus. Fail-closed.

## Ce qui reste bloqué côté source

`PMU.zip` (184 181 972 octets, SHA-256 `6262927e…`) n'a **pas** pu être
téléchargé. Le pointeur LFS est correct et l'API batch LFS répond avec une URL
signée valide, mais tous les hôtes de contenu
(`media.githubusercontent.com`, `objects.githubusercontent.com`,
`github-cloud.githubusercontent.com`) coupent la poignée de main TLS depuis ce
sandbox ; seuls `github.com` et `api.github.com` passent. Conformément à la
consigne, cette partie est **arrêtée et signalée** plutôt que traitée sur une
donnée partielle. La provenance a été rétablie par une voie publique
équivalente et vérifiable (`codeload.github.com`, client PMU épinglé), ce qui
valide 2 archives sur 3.

Pour lever ce blocage il faut un accès réseau aux hôtes LFS, ou un dépôt de
`PMU.zip` accessible via `github.com`/`api.github.com`.

## Conséquence pour le remplacement des structures NNV

`nnv-structure-compatibility.json` mesure les quatre maisons source de
`rmvillage` contre le pool des 48 structures PMU confirmées :

| Maison NNV | Ancre source | Emprise visible | Statut |
|---|---|---:|---|
| `objplayerhouse` | (-64, 2816) | 1200×984 px | `ADAPTATION_REQUIRED` |
| `objloggerhouse` | (704, 1344) | 948×840 px | `ADAPTATION_REQUIRED` |
| `objhunterhouse` | (3712, 1472) | 948×856 px | `ADAPTATION_REQUIRED` |
| `objcarpenterhouse` | (1216, -128) | 1192×728 px | `ADAPTATION_REQUIRED` |

La plus grande structure PMU confirmée (`tiles9_0554`) mesure 196×230 px. Les
maisons NNV sont donc **4,8× à 6,1× plus larges** et **3,2× à 4,3× plus hautes**.

Le blocage n'est pas un asset manquant, c'est une **incompatibilité d'échelle
prouvée** : NNV est mappé 1:1 en cellules visuelles de 64 px, PMU est de l'art
32 px. Agrandir l'art PMU inventerait des pixels ; rétrécir l'emplacement NNV
laisserait PMU dicter la topologie de NNV. Les deux sont interdits. Le statut
reste donc `ADAPTATION_REQUIRED` au lieu d'un faux `CERTIFIED`.

Les voies de déblocage légitimes, par ordre de rigueur :

1. lever le blocage `Tiles8.tile` pour auditer les 95 candidats restants ;
2. chercher, dans les archives PMU, des structures réellement grandes plutôt que
   d'étirer une petite ;
3. cibler d'abord des éléments PMU à l'échelle compatible (mobilier, décor
   ponctuel) plutôt que les quatre maisons principales ;
4. composer explicitement une structure à partir de composants documentés, avec
   preuve par composant — jamais un assemblage arbitraire de tileset.

## Reproduire

```bash
python3 PMU_ADAPTATION/tools/audit_pmu_structure_autonomy.py \
  --tiles <PMU-Client>/resources/GFX/Tiles \
  --out PMU_ADAPTATION/reports/structure-autonomy
python3 PMU_ADAPTATION/tools/audit_nnv_structure_compatibility.py
python3 PMU_ADAPTATION/test_structure_autonomy.py
```

## Statut

- autonomie des structures PMU : **RÉSOLU** (48 confirmés, 95 `REVIEW_REQUIRED`) ;
- audit direct de `PMU.zip` : `BLOCKED` (réseau LFS) ;
- remplacement de structures NNV : `ADAPTATION_REQUIRED`, aucun remplacement
  effectué, aucun pixel de `rmvillage` modifié ;
- runtime PMDO : `NOT_RUN` pour ce périmètre — les PASS saisonniers existants
  sont conservés intacts.
