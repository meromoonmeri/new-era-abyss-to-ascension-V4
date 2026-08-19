# Les 11 rooms NO_PROOF — conversion et collision produites

Le motif `NO_PROOF` était : **« ni rendu ni collision »**. Le rendu avait été
levé précédemment. **La conversion et la collision le sont maintenant.**

## Résultat

11 rooms sur 11 converties en Grounds PMDO puis normalisées ×0,125.
**0 échec, 0 tuile non résolue.**

| Room | Couverture tuiles | Cellules 8 px bloquantes | Ratio |
|---|---:|---:|---:|
| `rm38` | 99,8 % | 1 473 | 24,2 % |
| `rm47` | 99,4 % | 1 734 | 28,5 % |
| `rm48` | 96,7 % | 1 310 | 21,5 % |
| `rm49` | 99,2 % | 1 535 | 25,2 % |
| `rm57` | 99,7 % | 1 965 | 32,3 % |
| `rm68` | 98,6 % | 2 002 | 32,9 % |
| `rm77` | 100,0 % | 593 | 9,8 % |
| `rmcave1` | 95,8 % | 349 | 5,7 % |
| `rmcave1_0` | 94,2 % | 830 | 13,6 % |
| `rmcave1_1` | 94,3 % | 861 | 14,2 % |
| `rmcave1_2` | 97,1 % | 315 | 5,2 % |

Géométrie obtenue, identique pour les 11 : monde **624 px**, `TexSize` **1**,
grille de collision **78**, cellule de tuile **8 px**. Conforme au référentiel
PMDO de `reports/pmdo-scale-reference/`.

Les règles de normalisation ne sont pas réécrites : elles sont **importées** de
`tools/apply_nnv_normalisation.py`, celui déjà validé. Une divergence entre les
deux chemins est donc structurellement impossible. Le module vérifie au chargement
que `FACTOR`, `NEW_TEX_SIZE` et `NEW_CELL_PX` sont bien ceux attendus.

## Un défaut de mesure trouvé et corrigé, pas contourné

Le premier passage annonçait **6,7 % à 29,7 %** de remplissage pour les quatre
grottes. C'était alarmant : la source donnait 94,9–97,9 %.

**La conversion n'était pas en cause, ma métrique l'était.** Elle comptait les
pixels « non noirs » sur un fond noir opaque. Or **le sol des grottes NNV est
noir** : il était compté comme un trou.

Correction : le rendu se fait désormais sur fond **transparent**, et la mesure
porte sur l'**alpha** — « cette cellule a-t-elle reçu une tuile ? » — jamais sur
la couleur. Les grottes remontent à 94,2–97,1 %, ce qui **recoupe la source**.
Pour la lecture, le hors-cavité non tuilé est peint en gris foncé afin d'être
distinguable à l'œil du sol de grotte noir mais tuilé.

Je note que je n'avais pas le droit de me satisfaire du premier chiffre : c'est
en regardant `rmcave1_collision.png` que l'incohérence est apparue.

## Vérification visuelle, pas seulement chiffrée

`ALL_NOPROOF_COLLISION.png` — les 11 rooms avec un **voile rouge sur chaque
cellule 8 px bloquante**. Ce que l'image montre, après l'avoir regardée :

- la collision épouse les **troncs d'arbres**, les **falaises** et les **bords
  d'eau** sur les 7 rooms extérieures ;
- sur les 4 grottes, elle suit **exactement les parois** de la cavité, ce qui
  explique le ratio faible de 5,2 % : la grotte est un couloir étroit dans un
  hors-cavité entièrement noir, et non une salle ouverte ;
- **le gris foncé du fond n'apparaît nulle part** — aucun trou de tuilage.

## Ce qui reste, et pourquoi les 57 entités ne sont PAS promues

`promotion_allowed` reste **`false`**. Les preuves manquantes ont été produites,
les exigences n'ont pas été abaissées. Restent ouverts :

- les **blockers du convertisseur**, conservés tels quels sans filtrage : faune
  non liée au moteur, transitions non résolues, couches `Effect` non portées ;
- le **runtime PMDO 0.8.12**, jamais exécuté — ni `dotnet` ni `mono` disponibles
  ici, les 5 hôtes .NET répondent `000`. Statut `NOT_CERTIFIED`.

Les Grounds normalisés (~47 Mo pièce avant normalisation) restent **hors Git**,
sous `.runtime-cache/nnv-noproof-grounds/`. Ils sont reproductibles :
`python3 tools/convert_noproof_rooms.py`. Seuls les rapports, les rendus et les
hashes sont versionnés.
