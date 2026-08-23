# Lot Red Story 01 — Tiny Woods + Thunderwave Cave

## Statut

| Donjon | Source | Floors | Zone candidate | Mapgen PMDO | Route | Promotion |
|---|---|---:|---|---|---|---|
| Tiny Woods | PMD Red ROM / pret `bf0092…` | 3 | générée en staging | 30/30, invalid 0 | en attente | non |
| Thunderwave Cave | PMD Red ROM / pret `bf0092…` | 5 | générée en staging | 50/50, invalid 0 | en attente | non |

## Règles réconciliées

- shops désactivés : `kecleonShopChance=0` sur tous les floors ;
- Monster Houses désactivées : `monsterHouseChance=0` ;
- météo claire conservée ;
- Tiny Woods : `trapDensity=0`, aucun piège généré ;
- Thunderwave Cave : Wonder Tiles et densité 3 conservées ;
- espèces, probabilités et plages de floors viennent des manifests ROM ;
- objets sont portés avec plages propres aux floors ; l’argent reste traité par le step PMDO dédié ;
- niveaux New Era séparés comme `SUPPLEMENTAL` ;
- profils RogueElements explicitement `INFERRED`, sélectionnés par `ChanceFloorGen` au runtime.

## Assets

- Tiny Woods : package PMDO canonique `tiny_woods_{floor,wall,secondary}` ;
- Thunderwave Cave : package PMDO canonique `thunderwave_cave_{floor,wall,secondary}` ;
- les Grounds D01/D02 et leurs scènes ROM sont référencés dans les provenances ;
- aucune arène de boss n’est inventée : les scènes finales sont des scènes de sauvetage, sans faux combat.

## Validation native

Commande :

```bash
PMDO_MAPGEN_MOD_SRC=/tmp/red-story-01-mod \
PMDO_MAPGEN_MOD_NAME=red-story-01 \
PMDO_MAPGEN_VALIDATOR_SPEC=tiny_woods,thunderwave_cave \
tools/runtime/run_engine_mapgen.sh /tmp/red-story-01-runtime 10
```

Résultat terminal :

```json
{"event":"end","attempted":80,"generated":80,"failures":0,"non_traversable":0,"invalid":0}
```

Preuves :

- `batch_report.json` ;
- `native_mapgen_report.md` ;
- `runtime/native_mapgen.jsonl`.

## Blocages de promotion

Les deux entrées restent bloquées par :

- `ROUTE_RUNTIME_NOT_VALIDATED` ;
- `NOT_PROMOTED`.

Les `Data/Zone` actives ne sont pas modifiées par ce lot.
