# Exemples Ground multi-stratégies

Ces quatre candidats ont été générés avec des intentions et seeds distincts :
trois sont validés et la caverne est conservée comme preuve de rejet. Ils ne
copient aucun layout source. Chaque dossier contient le `.rsground`, la
métadonnée explicative, le controller et une preview SVG d'audit.

| Exemple | Stratégie | Référence choisie | Preuve principale |
|---|---|---|---|
| [canyon](canyon/canyon_sinueux.svg) | `winding_canyon` | `mount_windswept_entrance` | trois poches + masse de contrôle visuel, navigation 1.0 |
| [cour ancienne](courtyard/cour_ancienne.svg) | `ancient_courtyard` | `ledian_dojo` | cour hiérarchisée et piliers symétriques intentionnels |
| caverne cristalline (candidat rejeté) | `crystal_cavern` | `altere_pond` | `SEMANTIC_REFERENCE_MISMATCH` : aucun thème cavernicole compatible avec l'eau native |
| [arène](arena/arene_finale.svg) | `boss_arena` | `ledian_dojo` | boss à exactement 6 cases, sans escalier automatique |

Le candidat `altere_pond` de la caverne démontre désormais un **rejet**, pas un
succès : sa grammaire d'eau est valide mais son identité n'est pas cavernicole.
Le système refuse donc de maquiller ce conflit en réussite et attend une
bibliothèque eau+caverne compatible ou une correction explicite de la demande.

Les valeurs exactes, fallbacks localisés, hashes des sources, rôles topologiques,
motifs et décisions de controller sont dans chaque `*.metadata.json`. La campagne
PMDO exacte (quatre succès moteur et un rejet sémantique) est consignée dans
[`../GROUND_RUNTIME_VALIDATION_2026-08-13.json`](../GROUND_RUNTIME_VALIDATION_2026-08-13.json).
