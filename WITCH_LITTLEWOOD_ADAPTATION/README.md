# WitchLittlewood → PMDO

Le chantier a démarré après la validation PMDO de No Name Village.

Le dépôt source audité au commit `d247e92b…` ne contient ni projet natif, ni
maps, ni scripts, ni manifeste : seulement sept parties d’une archive RAR5
tierce d’un jeu commercial. Les parties ne sont pas réellement gérées par la
règle Git LFS du dépôt (`*.rar` ne correspond pas à `*.rar.part-001`).

Aucune extraction ni intégration n’est effectuée depuis cette redistribution
sans provenance. Le rapport `reports/source-audit.json` conserve les tailles,
hashes, en-tête RAR et la décision. La suite doit partir d’un export natif à
provenance sûre, puis reprendre le même pipeline que No Name Village : audit
exhaustif, données structurées, adaptation Pokémon, saisons/temps s’ils sont
présents, et validation dans PMDO 0.8.12 réel.
