# docs/blue_to_pmdo — Dossier de preuves de la retransposition Blue → PMDO

Document de référence : **`spec/BLUE_TO_PMDO.md`** (spécification complète :
architecture, règles spatiales/collision/markers/spawns/objets/caméra/tiles/
animations/musique/cinématiques/VFX/scripts/dialogues, limitations PMDO,
adaptations, provenance, matrice, statuts, outils, commandes, tests, non-régression).

## Contenu

| Dossier | Contenu | Statut |
|---|---|---|
| `spec/` | BLUE_TO_PMDO.md (spécification de référence) | actif |
| `tilesets/` | feuilles de tiles b41/b10 (415/416 tiles) + 12 sous-palettes | PROVEN |
| `palettes/` | nuanciers 192 couleurs BGR555 → RGB888 | PROVEN |
| `cells/` | atlas des 2250 cellules (tile+palette) b41/b10 | PROVEN |
| `comparisons/` | b10 vs b41 (tilesets alternatifs) | PROVEN |
| `grounds/` | graphique des FloorProperties par étage (données prouvées) | PROVEN |
| `collision/` | (vide — format ground.sbin non décodé) | BLOCKED |
| `markers/` | (vide — idem) | BLOCKED |
| `animations/` | (vide — sémantique canm UNKNOWN) | BLOCKED |
| `cinematics/` | (vide — packages B10P01 non décodés) | BLOCKED |
| `music/` | chaîne SDAT complète : manifeste JSON + CSV (index→nom→fichier) | PROVEN |
| `matrices/` | nds_to_pmdo_matrix.csv (18 entrées, statuts) | actif |
| `manifests/` | provenance_manifest.json (chaque PNG tracé vers sa source) | actif |
| `reports/` | coverage.md / coverage.json (compteurs finaux) | actif |

## Règle

Aucun PNG n'est retouché : chaque image est un rendu brut de validation issu des
données décodées, avec sa provenance dans `manifests/provenance_manifest.json`.
Les dossiers BLOCKED restent vides tant que la source n'est pas décodée —
jamais de placeholder.
