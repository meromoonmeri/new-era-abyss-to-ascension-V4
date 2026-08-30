# Analyse Mathématique et Spatiale de l'Échelle : PMU → PMDO

## 1. Systèmes de Coordonnées et Granularité

L'adaptation d'une carte de **Pokémon Mystery Universe (PMU)** vers **PMDO / RogueEssence / New Era** repose sur une correspondance mathématique exacte et déterministe, excluant tout redimensionnement bitmap ou filtre destructeur.

```text
┌──────────────────────────────────────────────┐
│             PMU Tile (32×32 px)              │
│                                              │
│  ┌────────────┬────────────┬──────────────┐  │
│  │ Sub (0,0)  │ Sub (1,0)  │  Sub (2,0)   │  │
│  │ (8×8 px)   │ (8×8 px)   │  (8×8 px)    │  │
│  ├────────────┼────────────┼──────────────┤  │
│  │ Sub (0,1)  │ Sub (1,1)  │  Sub (2,1)   │  │
│  │ (8×8 px)   │ (8×8 px)   │  (8×8 px)    │  │
│  ├────────────┼────────────┼──────────────┤  │
│  │ Sub (0,2)  │ Sub (1,2)  │  Sub (2,2)   │  │
│  │ (8×8 px)   │ (8×8 px)   │  (8×8 px)    │  │
│  ├────────────┼────────────┼──────────────┤  │
│  │ Sub (0,3)  │ Sub (1,3)  │  Sub (2,3)   │  │
│  │ (8×8 px)   │ (8×8 px)   │  (8×8 px)    │  │
│  └────────────┴────────────┴──────────────┘  │
│                                              │
└──────────────────────────────────────────────┘
                        │
                        ▼ (Discrétisation Déterministe)
┌──────────────────────────────────────────────┐
│      PMDO Grid (TexSize 1 : 8×8 px)          │
│      16 Obstacles de Collision 8×8 px        │
└──────────────────────────────────────────────┘
```

---

## 2. Formulation Mathématique de la Transformation

### 2.1 Dimensions Physiques et Ratios
Soit une carte PMU de dimensions $W_{PMU}$ tuiles en largeur et $H_{PMU}$ tuiles en hauteur, avec chaque tuile $T_{PMU} = 32 \times 32$ pixels.

- **Largeur physique en pixels** :
  $$W_{px} = W_{PMU} \times 32$$

- **Hauteur physique en pixels** :
  $$H_{px} = H_{PMU} \times 32$$

- **Facteur d'échelle physique** :
  $$S = 1.0 \quad (\text{Ratio 1:1, zéro déformation physique})$$

### 2.2 Grille de Collision PMDO (Cellules de 8×8 px)
RogueEssence modélise les obstacles sous forme de rectangles de dimensions $8 \times 8$ pixels (`Bounds.Width = 8, Bounds.Height = 8`).

- **Nombre de cellules de collision par tuile PMU** :
  $$R_{col} = \left(\frac{32}{8}\right) \times \left(\frac{32}{8}\right) = 4 \times 4 = 16 \text{ cellules}$$

- **Dimensions de la grille de collision PMDO** :
  $$W_{col} = W_{PMU} \times 4$$
  $$H_{col} = H_{PMU} \times 4$$

- **Mappage de collision pour une tuile $(t_x, t_y)$** :
  $$\forall dx \in \{0, 1, 2, 3\}, \; \forall dy \in \{0, 1, 2, 3\} :$$
  $$\text{Obstacle}(4 t_x + dx, 4 t_y + dy).\text{Tags} = \begin{cases} 1 & \text{si } \text{TileType}(t_x, t_y) \in \{1, 14, 31\} \\ 0 & \text{sinon} \end{cases}$$

### 2.3 Grille Visuelle et `TexSize`
PMDO supporte trois granularités pour `TexSize` :
- `TexSize = 1` : $8 \times 8$ pixels par cellule visuelle (grille $4W_{PMU} \times 4H_{PMU}$).
- `TexSize = 2` : $16 \times 16$ pixels par cellule visuelle (grille $2W_{PMU} \times 2H_{PMU}$).
- `TexSize = 4` : $32 \times 32$ pixels par cellule visuelle (grille $W_{PMU} \times H_{PMU}$).

L'utilisation de **`TexSize = 1`** est choisie comme standard canonique car elle offre une synchronisation bijective parfaite entre la grille visuelle et la grille d'obstacles de collision de RogueEssence (toutes deux à $8 \times 8$ pixels).

---

## 3. Transformation des Coordonnées Sémantiques

Pour toute entité ou déclencheur situé à la coordonnée tuile $(t_x, t_y)$ dans PMU :

| Entité | Coordonnées PMU | Coordonnées Physiques PMDO | Coordonnées Grille PMDO (8px) |
| :--- | :--- | :--- | :--- |
| **Origine de la Tuile** | $(t_x, t_y)$ | $(32 t_x, 32 t_y)$ | $(4 t_x, 4 t_y)$ |
| **Centre de la Tuile (PNJ)**| $(t_x, t_y)$ | $(32 t_x + 16, 32 t_y + 16)$ | $(4 t_x + 2, 4 t_y + 2)$ |
| **Collider Panneau** | $(t_x, t_y)$ | $\{X: 32 t_x, Y: 32 t_y, W: 32, H: 32\}$ | $\{X: 4 t_x, Y: 4 t_y, W: 4, H: 4\}$ |
| **Zone Déclencheur Warp** | $(t_x, t_y)$ | $\{X: 32 t_x, Y: 32 t_y, W: 32, H: 32\}$ | $\{X: 4 t_x, Y: 4 t_y, W: 4, H: 4\}$ |

---

## 4. Pourquoi le Simple Redimensionnement Bitmap est Proscrit

Un redimensionnement classique (ex. bicubique ou bilinéaire) :
1. **Détruit les bordures nettes du pixel art** en introduisant du flou et des dégradés parasites.
2. **Altère les canaux alpha** (transparence) en créant des halos sombres autour des éléments de décor.
3. **Faillit à aligner la collision** avec le rendu graphique, créant des collisions fantômes ou des traversées de murs.
4. **Empêche l'édition native dans l'éditeur de sol PMDO** en transformant la carte en une texture opaque monolithique.

Notre pipeline réalise un **découpage vectoriel de sous-cellules** avec déduplication sans perte, garantissant un différentiel visuel de **0.00%** par rapport au moteur PMU original.
