# Exemples Ground multi-stratégies

Ces quatre Grounds ont été générés avec des intentions et seeds distincts. Ils
ne copient aucun layout source. Chaque dossier contient le `.rsground`, la
métadonnée explicative, le controller, une preview SVG et un rendu PNG natif.

| Exemple | Stratégie | Référence choisie | Preuve principale |
|---|---|---|---|
| [canyon](canyon/canyon_sinueux.png) | `winding_canyon` | `mount_windswept_entrance` | trois poches + masse de contrôle visuel, navigation 1.0 |
| [cour ancienne](courtyard/cour_ancienne.png) | `ancient_courtyard` | `ledian_dojo` | cour hiérarchisée et piliers symétriques intentionnels |
| [caverne](crystal/caverne_cristalline.png) | `crystal_cavern` | `altere_pond` | six régions, bassin animé, repli mono-bibliothèque prouvé |
| [arène](arena/arene_finale.png) | `boss_arena` | `ledian_dojo` | boss à exactement 6 cases, sans escalier automatique |

Le repli `altere_pond` de la caverne est volontaire : parmi les références
alignées, cette bibliothèque fournit une grammaire d'eau animée valide. Le
système refuse un mélange cavernicole visuellement ou fonctionnellement non
prouvé plutôt que de fabriquer des transitions.

Les valeurs exactes, fallbacks localisés, hashes des sources, rôles topologiques,
motifs et décisions de controller sont dans chaque `*.metadata.json`.
