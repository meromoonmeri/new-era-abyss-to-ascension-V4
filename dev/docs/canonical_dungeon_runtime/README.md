# canonical-dungeon — validation runtime par étage

Outil : `dev/tools/canonical_dungeon.py` (manifest | test | validate | report).

## Campagne du 2026-08-25 (PMDO 0.8.12 headless réel)

Environnement : bundle exact du projet (apphost `faf9755c…e8327`,
SDL offscreen patché `2cec7b5f…c14e71f`, DumpAsset épinglé `9d864d14…`),
service moteur `mapgen_validator` (génération RogueElements réelle via
`structure:GetMap(context)` + analyse de traversabilité).

Résultats observés (exécution réelle, agrégation stricte multi-itérations —
le pire cas gagne) :

| Zone | Étages | Générations | Verdict |
|---|---|---|---|
| wish_cave | 99 | 396/396 valides (4 itérations) | CANONICAL_RUNTIME_PASS |
| magma_cavern | 23 | toutes valides (3 itérations) | CANONICAL_RUNTIME_PASS |
| sky_tower | 25 | toutes valides (3 itérations) | CANONICAL_RUNTIME_PASS |

Boucle de convergence appliquée (échecs réels diagnostiqués puis corrigés
au niveau RogueElements, jamais masqués) :

* `magma_cavern` seg2 f4/f5 : grille 3x2/4x2 -> 4x3 (le contrat
  `large_rooms` était mathématiquement intenable : 2-3 salles max,
  `topology_ok=false` émis par le moteur) ; seg2 f2 (`looping`)
  `ConnectPercent` 85 -> 100 (cycle garanti) ; seg1 f0, seg2 f6/f7
  (`mixed`) `BranchRatio.Min` -> 50 (branches=0 flaky sinon).
* `wish_cave` : f10 grille 4x3 -> 5x4 + branch 60 + room 85 ;
  f4/f28/f46 branch -> 50 ; tous les étages `looping`
  `ConnectPercent` -> 100 ; tous les étages `branching`
  `ConnectPercent` -> 10 (préserve les impasses exigées par le contrat —
  un durcissement global uniforme avait été REJETÉ par le moteur : 58
  invalides, preuve que la correction doit être par profil).
* `sky_tower` : aucun changement nécessaire.

## Preuves persistées (2026-08-25, rematérialisées)

Les JSONL bruts de cette campagne SONT commités dans ce dossier :
`mapgen_wish_cave_magma_cavern_sky_tower.jsonl` (441 générations) et
`mapgen_magma_cavern.jsonl` (115 générations, 5 itérations après les
correctifs RoomRatio/ConnectPercent). `matrix.json` est la matrice par
étage agrégée strictement (pire cas gagne). Verdicts reproduits :
3/3 CANONICAL_RUNTIME_PASS (wish_cave 99, magma_cavern 23, sky_tower 25).
Regénération : `python3 dev/tools/canonical_dungeon.py test <zones>`.
