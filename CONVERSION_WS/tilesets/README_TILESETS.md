# Tilesets — Metano Town (extraction alpha isolée, échelle PMDO)

Extraction des sprites décoratifs de la map « Metano Town » (source M1 / PMDO),
isolés **en alpha (transparence)** et mis à l'**échelle PMDO**, pour remploi dans
la conversion `MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp`.

## Échelle

- Cellule source Metano : **8 px** (tuile native)
- Cellule PMDO : **24 px**
- Facteur d'agrandissement appliqué : **×3** (NEAREST, pixels francs)
- Conforme à la règle « 1 cellule source → 1 cellule PMDO via autotile ».

## Méthode

Le rendu Metano canonique (`analysis/ref/metano_town.png`, 1512×1512) est la
**vraie source** des assets (les objets de la map en dérivent). Pour isoler en
alpha, on soustrait le **sol plat** connu (herbe ≈ RGB(208,216,88), sable ≈
RGB(228,217,116)) par distance de couleur, puis :

- rampe alpha douce (seuil + marge linéaire),
- filtre médian,
- ouverture/fermeture morphologique,
- conservation de la plus grande composante (ou de la composante ciblée),
- recadrage sur la boîte englobante alpha + upscale ×3.

Les objets difficiles (totems/statues) ont été repérés **visuellement** dans la
source du montage (`analysis/source.png`) car ils ne forment pas des composantes
connexes propres dans le rendu (le sol y est incrusté).

## Fichiers livrés

| Famille | Fichier | Nb sprites | Source |
|---|---|---|---|
| Arbres | `atlas_arbres.png` + `tree_*.png` | 36 | rendu Metano (canopée + tronc) |
| Bâtiments | `atlas_batiments.png` + `building_*.png` | 18 | rendu Metano (chroma-key) |
| Totems/statues | `atlas_totems_statues.png` + `*.png` | 8 | rendu Metano + montage source |
| Panneaux/enseignes | `atlas_panneaux_enseignes.png` + `sign_04_4x3.png` | 1 | rendu Metano (panneau jaune) |

`manifest.json` : registre machine (famille → atlas + liste des sprites).

### Détail « totems_statues »
- `obj_shop_red` — boutique rouge (devanture + auvent)
- `obj_statue_celebi` — grand arbre/temple Célébi
- `obj_statue_island` — îlot herbeux (statue/rocher)
- `src_kiosk_hat` — kiosque / comptoir à chapeau
- `src_statue_blue_wing` — statue aux ailes bleues
- `src_statue_smurf` — grosse statue bleue (kiosque inclus)
- `src_statue_volt` — statue Pikachu/Voltorbe (devant la boutique)
- `src_totem_purple_face` — totem à visage / rocher violet

## Limites (honnêtes)

- **Panneaux/enseignes** : quasi-absent du vocabulaire Metano exploitable. Un
  seul panneau (jaune) a pu être isolé proprement. Les autres candidats
  automatiques (`sign_*`) étaient des berges de rivière / faux positifs et ont
  été **supprimés** — on n'invente pas de panneau manquant.
- **Arbres rognés** : `tree_04`, `tree_14`, `tree_19`, `tree_21`, `tree_22`
  sont coupés au bord du rendu source (l'arbre déborde du canvas 1512×1512).
  Leur silhouette est tronquée, pas dénaturée.
- **Totems/statues rognés** : `obj_statue_celebi` (bords de mur adjacents),
  `src_kiosk_hat`, `obj_statue_island` sont légèrement incomplets en périphérie
  (limites de la zone de recadrage source). Le sujet principal est intact.
- Les sprites proviennent du **rendu Metano** / montage source (assets réels),
  **jamais** générés par IA — aucune réinvention, aucun recolor.

## Réutilisation

Chaque `*.png` est en RGBA avec alpha déjà en place, prêt à être posé sur un sol.
Conserver le fond neutre (aucune couleur de sol incrustée) : l'alpha a été
dérivée du bio du sol, donc un halo d'herbe/sable peut subsister par endroits —
souhaité, car il ancre le sprite sur le terrain.

Réglages : reproductibles via `isolate_final.py`, `isolate_trees2.py`,
`isolate_source.py`, `isolate_zone.py` dans `CONVERSION_WS/`.
