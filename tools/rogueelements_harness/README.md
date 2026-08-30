# RogueElements / PMDO topology harness (isolé)

Ce dossier est un harness de laboratoire. Il ne référence ni ne modifie `Data/Zone`,
`Data/Ground`, les index, les assets ou des définitions canoniques. Ses sorties
doivent être écrites sous un répertoire explicitement fourni, typiquement
`.runtime-work/rogueelements-harness/` (ignoré).

## Contrat de preuve

Le harness ne déclare jamais une génération validée par lecture statique :

- `CODE_CONFIRMED` : les types et paramètres ont été vérifiés dans la source.
- `PROTOTYPE_CONFIRMED` : le binaire RogueElements a réellement généré le floor
  et ses métriques/preview proviennent du contexte après `GenMap(seed)`.
- `RUNTIME_CONFIRMED` : le JSON équivalent a été chargé par le runtime PMDO exact.
- `BLOCKED_BY_ENVIRONMENT` : aucun résultat de génération ne doit être présenté.

Chaque run génère de nouvelles seeds cryptographiques, les écrit dans le rapport,
mesure le graphe `FloorPlan`, la connectivité des tuiles et rejette les signatures
structurelles trop proches. Les seeds ne sont ni des seeds de production, ni un
cache de layouts.

## Préparation de l’environnement

Le harness dépend volontairement d'un checkout explicite de RogueElements et d'un
SDK .NET, hors du mod :

```bash
dotnet run --project tools/rogueelements_harness/RogueElementsHarness.csproj \
  -p:RogueElementsRoot=/abs/path/RogueElements \
  -- --out .runtime-work/rogueelements-harness --variants 10
```

Ensuite, `pmdo_probe_plan.json` est la checklist pour exécuter les mêmes profils
sous un overlay PMDO isolé. Cette seconde passe est obligatoire avant de classer
un profil `RUNTIME_CONFIRMED`.

Le SDK `dotnet` demeure requis pour le prototype C# autonome. Le runtime PMDO
exact 0.8.12 peut être restauré séparément, de manière authentifiée et vérifiée,
par `bash tools/restore_pmdred_eu_validation_runtime.sh`; il est installé sous
`.runtime-cache/` et reste ignoré. Le rapport doit enregistrer son SHA-256 et
sa version. Tant que le binaire de ce harness n'a pas exécuté `GenMap` ou que
l'overlay PMDO n'a pas chargé la fixture, ne pas créer de rapport de réussite.
