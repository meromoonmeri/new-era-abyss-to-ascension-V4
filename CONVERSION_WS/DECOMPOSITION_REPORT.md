# RAPPORT DE DÉCOMPOSITION — MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp

> **Phase 1 à 4** du protocole. Livrable : analyse complète de la source.
> **Aucune reconstruction n'a été commencée** tant que la nature réelle de la
> source n'est pas établie et validée — c'est l'exigence centrale du protocole
> (fidélité > complétude ; ne jamais dénaturer ; ne jamais « compléter » avec de l'IA).

---

## 0. CONCLUSION EXÉCUTIVE — LECTURE OBLIGATOIRE

**La source `MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp` n'est PAS une map
cohérente. C'est un MONTAGE / collage de travail, assemblé dans une
application d'édition (PixelLab), composé de plusieurs fragments de maps
PMD distincts, à des échelles incohérentes, séparés par de coutures nettes,
avec des blocs de remplissage (placeholder) bruts et du contenu dupliqué.**

C'est la découverte structurale la plus importante du projet. Elle conditionne
toute la suite :

| Constat | Preuve | Conséquence |
|---|---|---|
| Montage multi-fragments (≥6 scènes distinctes) | Coutures nettes verticales/horizontales mesurées ; fragments de style, échelle et biome différents | On ne peut PAS reconstruire « la map » comme un seul objet |
| **Placeholders bruts** (aplats de couleur unie) | Slab vert unie (1012,340)-(1082,659) ; bande verte partielle (580,219)-(1082,285) ; barres noires (0,30)-(3,599) et (360,862)-(539,875) | Zones de la source qui sont du **contenu POST-IT / de remplissage**, pas de la pixel-art exploitable |
| Échelles incohérentes | Les canopées d'arbres mesurent ~14-72 px sur TL/ML mais ~132-166 px sur MR ; le fragment BR (rivière/pont) est en zoom ~2× par rapport aux fragments ville | Impossible d'appliquer un unique facteur d'échelle source→PMDO sans dénaturation |
| **Contenu dupliqué / recoupé** | TL et ML contiennent la même place de ville (mêmes maisons, l'enseigne Kecleon, la tour à fusée rouge) à deux décalages verticaux ; plusieurs coins sont des répétitions | Un simple découpage en grille produirait des doublons |
| Fragments largement issus du **tileset Metano Town canonique** | Palette, arbres, maisons (poste rouge, enseigne), falaises de briques, rivière animée, pont en bois | Les assets PMDO correspondants **existent déjà** dans le dépôt (voir §6) |

**Position du rapport vis-à-vis du protocole** : le protocole dit
« NE PAS dénaturer », « NE PAS inventer », « NE PAS remplacer silencieusement »,
« 90 % terminé / 100 % fidèle plutôt que 100 % terminé / dénaturé »,
« Si une partie ne peut pas être convertie fidèlement, arrêter cette partie et
la signaler ».

Or une source qui est un montage avec des blocs de remplissage **bruts** ne
peut pas être convertie « pixel-perfect » en une seule map sans dénaturation :
soit on découpe sur les coutures (ce qui produit N maps), soit on convertit
chaque fragment pour lui-même.

**Ce rapport documente donc la décomposition exhaustive de chaque fragment,
puis identifie formellement ce qui est convertissable fidèlement et ce qui est
`MISSING / NON-CONVERTISSABLE` (placeholders).** La reconstruction n'a de sens
qu'après validation de cette lecture par l'utilisateur (voir §9 — DÉCISION REQUISE).

---

## 1. IDENTIFICATION DE LA SOURCE

| Propriété | Valeur | Méthode |
|---|---|---|
| Fichier | `MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp` | `git show FETCH_HEAD:<fichier>` depuis `origin/arena/01a05323-new-era-abyss-to-ascension-v4` |
| Dimensions | **1083 × 876 px** | `identify` |
| Ratio | 1.236 (≠ 4:3 = 1.333, ≠ 3:2) | ratio W/H |
| Mode | RGB, 8-bit | `identify` |
| Couleurs dominantes | (255,223,159) sable/chemin 28 090 px ; (55,102,31) vert arbre ; (226,232,106) vert clair ; (135,111,95) brun | comptage exact |
| Nature | Montage de travail (collage) | coutures + placeholders + dupliques |

**Fichiers liés retrouvés sur la branche source** (contexte de travail existant) :

```
Content/Tile/mapacomplete_metano_Base.tile
Data/Ground/mapacomplete_metano.rsground        (stub 8 Mo — voir §7)
MAPACOMPLETEVIAPIXELLAB.webp                    (source intermédiaire)
MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp          (source fournie)
MAPACOMPLETEVIAPIXELLAB_METANO_SCALE.webp        (upscale 1.5× — 1624×1314)
data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/
images/MAPACOMPLETEVIAPIXELLAB_*.png
```

---

## 2. ANATOMIE DU MONTAGE — COUTURES ET FRAGMENTS

### 2.1 Coutures (seams) mesurées

Détection par gradient de couleur entre colonnes/lignes ±3 px, seuil >70, sur
la hauteur/largeur totale.

| Type | Coordonnée | Intensité (px concernés) | Lecture |
|---|---|---|---|
| Verticale | `x ≈ 580` | 531 px | Couture principale, sépare la zone ville (gauche) de la zone falaise/forêt (droite) |
| Verticale | `x ≈ 1009-1015` | 422 px | Bord droit de la zone « forest edge » / début du bloc vert |
| Verticale gauche | `x ≈ 0-6` | 664 px | Bord de l'image (barre noire) |
| Horizontale | `y ≈ 352` | 548 px | Sépare TL/TR (haut) de ML/MR (bas) |
| Horizontale | `y ≈ 724-728` | 568 px | Sépare la zone ville de la zone rivière/plage (bas) |
| Horizontale bas | `y ≈ 861-863` | 560 px | Barre noire du bas |

**Le quadrillage logique du montage** est donc :

```
        x=0         x=580         x≈1010      x=1083
       ┌──────────────┬──────────────┬───────────┐
 y=0   │  TL          │  TR          │  (bloc    │
       │  TOWN PLAZA  │  CLIFF       │   vert    │
       │              │  MEADOW      │   TR)     │
       ├──────────────┼──────────────┤           │
 y=352 │  ML          │  MR          │  (slab    │
       │  TOWN MARKET │  FOREST EDGE │   vert     │
       ├──────────────┼──────────────┤  1012-    │
 y=724 │  BL          │  BR          │   1082)   │
       │  MEADOW      │  RIVER / PIER│           │
       ├──────────────┴──────────────┴───────────┤
 y=876 │  (barre noire bas : 360,862-539,875)     │
       └──────────────────────────────────────────┘
```

### 2.2 Inventaire des fragments

Toutes les mesures de boîte sont en pixels source.

| # | Nom | Boîte source | Taille | Biome dominant | Contenu clé |
|---|---|---|---|---|---|
| F1 | **TL — TOWN PLAZA** | (0,0)-(580,352) | 580×352 | Ville / place | Place, maison-poste rouge, tour à fusée, enseigne verte à l'étoile, maisons à baldaquin jaune/rouge, arbres feuillus, chemins de sable, échoppe Kecleon (roof magenta), ailes bleues de statue |
| F2 | **TR — CLIFF MEADOW** | (580,0)-(1083,352) | 503×352 | Falaise / prairie | Ligne d'arbres dense en haut, prairie verte claire à taches, **mur d'enceinte en briques violettes** (crénelé) courant horizontalement, prairie en contrebas, rocher sombre |
| F3 | **ML — TOWN MARKET** | (0,352)-(580,724) | 580×372 | Ville / marché | **Répétition de la place de F1** (mêmes maisons) décalée vers le bas ; étals du marché, maisons colorées, arbres, la même enseigne/statue |
| F4 | **MR — FOREST EDGE** | (580,352)-(1083,724) | 503×372 | Forêt / lisière | Forêt dense, kiosque de marché (toit moucheté), hutte jaune, statue dorée (Gibble), chemin sablonneux sinueux, arbres |
| F5 | **BL — MEADOW** | (0,724)-(580,876) | 580×152 | Prairie | Prairie verte claire à taches, arbres épars, chemin qui descend, bord bas |
| F6 | **BR — RIVER / PIER** | (580,724)-(1083,876) | 503×152 | Rivière / plage / pont | Plage jaune, **pont en bois**, rivière verte animée à pierres/îlots, cascade de droite, mur d'enceinte brique en haut → **zoom ~2× par rapport aux fragments ville** |

---

## 3. PLACEHOLDERS ET CONtenu NON-CONVERTISSABLE

Détection par région à très faible variance locale (aplat uniforme) et palette
spécifique.

| Élément | Boîte exacte | Couleur | Sens |
|---|---|---|---|
| **Slab vert** (droit, F4/F6) | (1012,340)-(1082,659) | ~(135,189,67) | **Aplat de remplissage brut** (0,93 de remplissage) — PAS un biome, PAS des arbres. C'est la marge « post-it » du montage. |
| Bande verte partielle | (580,219)-(1082,285) | ~(135,189,67) | Recouvre une bande horizontale de F2/zone de couture ; partiellement de la pixel-art, partiellement de l'aplat. |
| Barre noire gauche | (0,30)-(3,599) | (0,0,0) | Bordure/marge de l'éditeur. |
| **Barre noire bas** | (360,862)-(539,875) | (0,0,0) | **Bloc noir de remplissage** (couvre le bas de la place F3/F5). |
| Bande noire haut | (0,16)-(1083,16) | noir | Liseré d'assemblage en haut. |

**Ces zones ne sont pas de la map.** Elles ne peuvent pas être converties en
tuiles PMDO sans inventer. Le protocole les classe en `MISSING / NON-CONVERTISSABLE`.

---

## 4. DÉCOMPOSITION MÉTHODOLOGIQUE (structure Palika)

Appliquée à **chaque fragment**, car il n'y a pas une map unique. Exemple
structuré pour le fragment représentatif **F1/F3 (Metano Town plaza)** — la
scène la plus canonique et la mieux documentée :

```
F1/F3 (METANO TOWN PLAZA)
├── BASE
│   ├── Ground        — herbe verte claire (autotile continu, coins/bords)
│   ├── Grass         — rangées d'herbe claire, touffes
│   ├── Dirt / Path   — chemin de sable (255,223,159), autotile continu
│   └── (pas d'eau dans F1/F3 — l'eau est portée par F6)
│
├── TERRAIN
│   ├── Paths         — chemin principal vertical + branches, croix centrale
│   ├── Cliffs        — (absentes de F1/F3 ; portées par F2/F6 : mur brique)
│   ├── Edges / Transitions — liserés sombres de bord de chemin, herbes de bord
│   └── (frontières hachurées par les coutures du montage)
│
├── VEGETATION
│   ├── Trees         — arbres feuillus (ronds, sombres, à tronc visible)
│   ├── Bushes        — buissons bas entre les maisons
│   ├── Grass patches — touffes d'herbe claire, herbes hautes en rangées
│   └── Flowers       — plantes/légumes alignés dans les parcelles cultivées
│
├── STRUCTURES
│   ├── Buildings     — maisons PMD (toits à baldaquin rouge/jaune, maison-poste)
│   ├── Roofs         — tuiles de toit (magenta/rouge/jaune)
│   ├── Walls         — murs clairs des façades
│   ├── Entrances     — portes / seuils des échoppes
│   └── Special       — enseigne à l'étoile (Kecleon), statue, tour à fusée
│
├── DECORATION
│   ├── Rocks         — pierres éparses sur chemin
│   ├── Signs         — panneaux, enseignes de boutiques
│   ├── Lamps         — (absents)
│   ├── Benches       — (absents)
│   └── Misc          — parcelles cultivées, jarres, tonneaux
│
├── FOREGROUND
│   └── (canopées d'arbres passant devant le joueur quand présentes)
│
└── LOGIC
    ├── Collision     — bâtiments bloqués, chemins walkable, arbres bloqués
    ├── Entrances     — portes des maisons
    ├── Exits         — bords de fragment (coutures du montage)
    └── Interactions  — échoppes, statues, parcelles
```

---

## 5. COMPOSITION GLOBALE — zones ouvertes / fermées / circulation

| Fragment | Axe de circulation | Zones ouvertes | Zones fermées | Masses végétales | Points d'intérêt |
|---|---|---|---|---|---|
| F1 TL | vertical (place → bas) | place centrale | bâtiments | arbres feuillus | poste, tour fusée, enseigne, échoppes |
| F2 TR | horizontal (prairie) | prairie haute = ouverte | falaise/brique = bloquée | ligne d'arbres haute dense | mur d'enceinte crénelé, rocher |
| F3 ML | vertical (marché) | allée de marché | bâtiments/étals | arbres, haies | étals, maisons colorées |
| F4 MR | serpentin (chemin de sable) | clairière | forêt dense | forêt dense | kiosque, hutte, statue dorée |
| F5 BL | vertical (descente) | prairie | ~ | arbres épars | chemin de descente |
| F6 BR | horizontal (rivière) | plage/berge | eau (bloquée) | ~ | **pont en bois**, cascade, îlots |

---

## 6. TILESET MAPPING — ASSETS PMDO EXISTANTS

Le dépôt contient déjà le **tileset Metano** complet. C'est la source exacte de
la plupart des fragments du montage. Mesures confirmées à l'aide du lecteur
canonique (`png2tileset.lire_planche`) :

| Ressource | Fichier | Taille de tuile | Grille | Confirmation |
|---|---|---|---|---|
| Metano Town Base | `Content/Tile/Metano_Town_Base.tile` | 8 px | **189×189** | `ts=8, 35646 tuiles, x/y ∈ [0,188]` |
| Metano Town Objects | `Content/Tile/Metano_Town_Objects.tile` | 8 px | — | — |
| Metano Town Fringe | `Content/Tile/Metano_Town_Fringe.tile` | 8 px | — | — |
| Metano Town Cliffs | `Content/Tile/Metano_Town_Cliffs.tile` | 8 px | — | — |
| Metano Town River (anim ×4) | `Metano_Town_River_Animation_{1..4}.tile` | 8 px | — | pour la rivière animée de F6 |
| Metano Town Objects Over/Under | `..._Over.tile` / `..._Under.tile` | 8 px | — | pour foreground/depth |
| Metano Town Builders (maisons) | `Metano_Town_*_Home_Base/Objects.tile` | 8 px | — | maisons / échoppes |
| Metano ground canonique | `Data/Ground/metano_town.rsground` | 24 px/cell | **189×189** | 11 couches : Base, Cliffs, River, Layer4, Objects Under(+Anim), Objects(+Anim), Objects Over(+Anim), Fringe |

**Mappings élément par élément (source → asset PMDO)**

| Élément source | Tileset PMDO | Tile/Sprite | Layer | Scale | Position |
|---|---|---|---|---|---|
| Herbe verte claire (base) | `Metano_Town_Base` | autotile herbe 8 px | Ground | PMDO 24 px/cell | partout |
| Chemin de sable | `Metano_Town_Base` | autotile chemin | Path | PMDO | croix centrale F1/F3 |
| Arbre feuillu | `Metano_Town_Objects` | arbre variant 03 | Objects | PMDO | F1/F3/F4 |
| Mur d'enceinte brique violette | `Metano_Town_Cliffs` | falaise/mur brique | Cliffs | PMDO | F2/F6 |
| Rivière animée verte | `Metano_Town_River_Animation_*` | eau frames 1-4 | River | PMDO | F6 |
| Pont en bois | `Metano_Town_Objects` | platelage pont natif | Objects | PMDO | F6 |
| Maison-poste rouge | `Metano_Town_*_Home_Base/Objects` | bâtiment | Objects | PMDO | F1/F3 |
| Enseigne à l'étoile (Kecleon) | `Metano_Town_Objects` | panneau étoile | Objects | PMDO | F1/F3 |
| Statue / ailes bleues | `Metano_Town_Objects` | objet statue | Objects | PMDO | F1 |

> **Note d'échelle.Critique** : la tuile native Metano est de **8 px**, mais le
> moteur PMDO affiche à **24 px/cellule** (voir `ENGINE_DISPLAY_REFERENCE.md` :
> `TileSize=24`, `DungeonTexSize=TEX_SIZE=...`, projection 1 cellule BMA = 1
> cellule PMDO 24 px). La relation correcte source→PMDO est donc
> **1 cellule source (8 px) → 1 cellule PMDO (24 px)**, soit un facteur ×3, passant
> par un **autotile** (le ground Metano est un atlas 1:1 à TexSize=1 ; chaque
> cellule a un TexLoc propre). Ce n'est PAS « largeur image / 16 » ni un simple
> downscale de l'image montée.

---

## 7. AUDIT DES ARTEFACTS PRÉEXISTANTS DE CONVERSION

La branche source contient un `Data/Ground/mapacomplete_metano.rsground` (stub)
et `Content/Tile/mapacomplete_metano_Base.tile`. Analyse :

- `.rsground` : **1 seule couche** (`Base`), **201 lignes × 162 colonnes**,
  `TexSize=1`, `AssetName=mapacomplete_metano`, `Music=Treasure Town.ogg`,
  nom `"Metano Outskirts (Treehouse)"`, `Comment="Calibrated to 24px Metano
  Town scale with 100% pixel integrity"`, 2 spawn markers
  (Spawn_North à 792,48 / Spawn_South à 792,1224), **aucun objet, aucune
  décoration, aucun spawner**.
- `.tile` : le byte-header lu via le lecteur standard est incohérent
  (`ts=8` mais `count` dans le mauvais ordre) → **fichier mal formé / partiel**.
- `MAPACOMPLETEVIAPIXELLAB_METANO_SCALE.webp` : simple **upscale 1.5×** de la
  source (1624×1314), **aucune** correction des coutures ni des placeholders.

**Conclusion : les artefacts préexistants sont des brouillons partiels et ne
constituent pas une conversion fidèle.** Ils documentent néanmoins la **cible
d'échelle** (24 px Metano, town-style) et le **nom** (« Metano Outskirts
(Treehouse) »).

---

## 8. RÉCAPITULATIF DE LA DÉCOMPOSITION

```
SOURCE (1083×876) — MONTAGE PixelLab
├── F1 TL  Town Plaza     (0,0)-(580,352)      → Metano Town plaza  [CONVERTISSABLE]
├── F2 TR  Cliff Meadow   (580,0)-(1083,352)   → prairie + mur brique [CONVERTISSABLE]
├── F3 ML  Town Market    (0,352)-(580,724)    → répétition F1 (décalée) [DUPLICAT]
├── F4 MR  Forest Edge    (580,352)-(1083,724) → forêt + kiosques [CONVERTISSABLE]
├── F5 BL  Meadow         (0,724)-(580,876)    → prairie [CONVERTISSABLE partiel]
├── F6 BR  River/Pier     (580,724)-(1083,876) → rivière + pont [CONVERTISSABLE, zoom ~2×]
│
├── PLACEHOLDER slab vert (1012,340)-(1082,659)   → [NON-CONVERTISSABLE — MISSING]
├── PLACEHOLDER bande verte (580,219)-(1082,285)  → [NON-CONVERTISSABLE — MISSING]
├── PLACEHOLDER barre noire (360,862)-(539,875)   → [NON-CONVERTISSABLE — MISSING]
└── PLACEHOLDER barre noire gauche (0,30)-(3,599) → [NON-CONVERTISSABLE — MISSING]
```

---

## 9. DÉCISION REQUISE (BLOQUANTE) — avant toute reconstruction

Le protocole interdit de dénaturer, d'inventer et de remplacer silencieusement.
Une source qui est un montage multi-échelle à placeholders **ne peut pas** être
convertie en une seule map PMDO pixel-perfect sans arbitraire. Trois lectures
possibles, très différentes :

### Option A — « Chaque fragment est une scène » (fidélité stricte)
Convertir **F1** (Town Plaza) et/ou **F3** en `mapacomplete_metano.rsground`
comme la scène représentative canonique (c'est la lecture du stub préexistant :
« Metano Outskirts (Treehouse) », 201×162). Les autres fragments (TR, MR, BR)
sont des **scènes séparées** à convertir en autant de grounds distincts. Les
placeholders sont `MISSING` (documentés, non remplis).

### Option B — « Une seule grande map cousue » (dénaturation probable)
Recoller tous les fragments en une seule map. ⚠️ **Procure des coutures
abruptes, des échelles incohérentes (zoom ~2× sur BR) et des doublons (F1/F3)
dans la map finale.** Cela produit une map **non-fidèle** à la structure d'une
vraie map PMD — à éviter selon le protocole.

### Option C — « Map de travail partielle »
Ne convertir que le **fragment principal F1/F3** (et éventuellement F4) en
contexte des assets Metano, et marquer explicitement les autres fragments et
tous les placeholders en `MISSING`/`NON-CONVERTISSABLE`.

**Recommandation du rapport : Option A/C.** Elle respecte « 90 % terminé /
100 % fidèle » : on convertit fidèlement le fragment canonique, on ne remplit
pas les placeholders, on documente le manque. Le stub préexistant (nom « Metano
Outskirts (Treehouse) ») conforte cette lecture.

> **Merci de valider l'option A, B ou C avant que je commence la reconstruction.**
> Sans cette validation, toute reconstruction serait un arbitraire silencieux,
> ce que le protocole interdit explicitement.
