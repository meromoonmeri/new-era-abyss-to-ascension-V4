# nds2pmdo — Pipeline de conversion Pokémon Donjon Mystère (NDS/GBA) → PMDO 0.8.12

Pipeline sur mesure, reproductible, documenté, testable et traçable pour reconstruire
le contenu d'un jeu Pokémon Donjon Mystère (source : ROM **Blue Rescue Team Europe `APHP`**)
dans l'écosystème **PMDO 0.8.12** (RogueEssence).

## Source de vérité

La **seule** référence source est le dépôt :

```
https://github.com/meromoonmeri/POKEMON-ROM
  → Pokemon Mystery Dungeon - Blue Rescue Team (Europe) (En,Fr,De,Es,It).nds
```

| Propriété | Valeur (vérifiée) |
|---|---|
| Taille | 33 554 432 octets (32 MiB) |
| Gamecode | `APHP` |
| Makercode | `01` |
| SHA-256 | `2540966e1e9cd722bf2ae401069df10b81875af03f0618d413b9d32511c14b05` |

La ROM est consommée **en lecture seule** ; elle n'est jamais copiée dans le dépôt de
conversion. Tout autre projet (pret/pmd-red, SkyTemple, …) n'est utilisé que comme
`CROSS_REFERENCE`, jamais comme source.

## Règle de provenance (stricte)

Chaque donnée importante du pipeline est taguée :

| Tag | Sens |
|---|---|
| `SOURCE_NDS` | Octets lus directement dans la ROM `APHP` |
| `SOURCE_NDS_DECODED` | Octets ROM décompressés/décodés (SIR0, AT4PX, …) |
| `CROSS_REFERENCE` | Valeur provenant d'un autre projet (pmd-red, SkyTemple…) — jamais présentée comme extraite |
| `DERIVED_MAPPING` | Règle de correspondance dérivée (ex. tileset N → blob `b{N:02d}`) |
| `PMDO_VALUE` | Valeur actuelle dans le mod New Era — **jamais** une preuve NDS |
| `UNKNOWN` | Non décodé — aucune valeur inventée |
| `ADAPTATION_REQUIRED` | Fonctionnalité NDS sans équivalent direct PMDO, stratégie documentée |

Interdiction absolue : remplacer une donnée manquante par une valeur plausible.

## Architecture (séparation stricte)

```
nds2pmdo/
├── source/         # POINTEUR vers la ROM (jamais la ROM elle-même)
├── extracted/      # fichiers bruts extraits de la ROM (FAT → *.sbin, *.bin)
├── decoded/        # données décompressées/décodées (SIR0, AT4PX, tables)
├── manifest/       # manifests de mapping NDS ↔ PMDO (lisibles, versionnés)
├── generated/      # contenu PMDO 0.8.12 généré (zones, grounds, tiles, scripts…)
├── validation/     # rendus de comparaison, diff, métriques, rapports de couverture
└── docs/           # spécifications de formats NDS et PMDO, correspondances
```

Les données brutes ne sont jamais mélangées aux fichiers générés.

## Phases

1. **Phase 1 — Reconstruction autonome** : copie fonctionnelle et autonome du contenu
   source dans l'écosystème PMDO 0.8.12, limitations documentées. Aucune déduplication.
2. **Phase 2 — Intégration New Era / déduplication** : seulement après que la Phase 1
   soit terminée, auditée et validée. Comparaison avec les assets New Era existants,
   mutualisation des doublons — sans jamais masquer les trous de la Phase 1.

## Exécution

```bash
# 0. Environnement
python3 -m venv .venv_pxl && .venv_pxl/bin/pip install -r nds2pmdo/requirements.txt

# 1. Extraction (ROM → extracted/)
NDS_ROM=/home/user/nds_sources/POKEMON-ROM/'Pokemon Mystery Dungeon - Blue Rescue Team (Europe) (En,Fr,De,Es,It).nds' \
  .venv_pxl/bin/python -m nds2pmdo extract

# 2. Décodage (extracted → decoded/)
.venv_pxl/bin/python -m nds2pmdo decode --scope dungeon_sinister_woods

# 3. Audit de fidélité source (gates)
.venv_pxl/bin/python -m nds2pmdo audit --target sinister_woods

# 4. Conversion (décodé → generated/, bloquée si UNKNOWN critiques)
.venv_pxl/bin/python -m nds2pmdo convert --target sinister_woods

# 5. Validation (rendu source vs rendu PMDO, diff, rapport)
.venv_pxl/bin/python -m nds2pmdo validate --target sinister_woods
.venv_pxl/bin/python -m nds2pmdo report
```

## CI

`.github/workflows/ci.yml` exécute la suite de tests (`pytest`) qui vérifie :
références manquantes, tiles invalides, palettes incorrectes, dimensions incohérentes,
frames d'animation absentes, Grounds sans entrée valide, scripts sans dépendances,
assets non référencés, et la reproduction byte-à-byte des artefacts ground truth committés.
