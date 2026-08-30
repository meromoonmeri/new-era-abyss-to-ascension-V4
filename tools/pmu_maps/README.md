# tools/pmu_maps — PMU → PNG → New Era

Pipeline complet pour récupérer les maps de Pokémon Mystery Universe et les
importer dans New Era/PMDO, SANS jamais inventer de pixel.

| fichier | rôle |
|---|---|
| `render_pmu_maps.py` | noyau de rendu : parse `.dat` MapData V4/V9 + archives `.tile` PMU (1 PNG 32×32 par enregistrement) + passe `MapRenderer.cs` exacte. autonome (CLI). C'est lui qui a produit la preuve `map95`. |
| `pmu_pipeline.py` | orchestrateur : `catalog` → `render --select` → `preview` → `validate` → `approve` → `import --mode A|B [--write] [--register]` → `status` → `selftest [--golden]` |
| `selector_view.py` | génère `output/pmu/selector.html` : vignettes cliquables des maps découvertes, produit la commande exacte à copier |
| `tests_data/` | fixtures de régression : `map95.dat` (donnée PMU réelle, MIT PMU Staff), `map95_render_golden.png`, `golden_map95.json` (sha256 du rendu) |

Dépendances : `pillow` (le rendu) ; rien d'autre — le round-trip de
validation utilise `tools/render_ground_png.py` du dépôt, pas un moteur parallèle.

Les règles de foi (index 0 = rien, hors bornes = tuile 0, anim = remplacement,
pré-multiplication, dédup, dimensions strictes, dimensions 32 px/tuile) et les
garanties d'import (round-trip disque byte-identical, gates d'approbation,
cartes chiffrées = `encrypted-unrecoverable` + intrant manquant) sont
documentées dans `docs/pmu_maps/PIPELINE_GUIDE.md`.

## Le test d'or

```bash
python3 tools/pmu_maps/pmu_pipeline.py selftest --golden
```

17 checks dont : déterminisme, transparence, obstacles issus du TYPE (pas des
pixels), refus texsize4, gates périmés, et sha256 du rendu map95 == preuve
engagée. Sans les planches PMU sous la main, le golden s'affiche SKIP bruyant
— jamais un faux PASS.
