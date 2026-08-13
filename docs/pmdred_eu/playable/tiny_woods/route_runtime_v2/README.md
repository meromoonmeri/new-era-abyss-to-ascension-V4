# Petit Bois — routage natif, facings EU corrigés (v2)

Statut : **PASS** (`2026-08-13`). Ce dossier remplace exclusivement la
certification de routage v1, dont les acteurs de `d01p02` étaient orientés au
Sud à cause d’une mauvaise traduction de l’énumération Red. L’ancienne preuve
reste conservée avec son erratum ; aucun résultat n’a été effacé.

L’autorité technique `include/constants/direction.h` définit Red `0 = South` et
`4 = North`. PMDO sérialise respectivement `Direction.Down = 0` et
`Direction.Up = 4`. La v2 prouve donc :

- héros `d01p01:g1/g2` vers le Sud ;
- héros `d01p01:g3` vers le Nord ;
- héros, partenaire et Chenipan `d01p02:g1` vers le Nord ;
- marqueur privé `d01p02` sérialisé à `4`.

Les trois scénarios complets ont été rejoués. Le scénario clear conserve 143
`ProcessPlayerInput(GameAction)`, trois escaliers, deux attaques hostiles et 28
replans d’occupation. Géométrie 45×42, 1 503 collisions, acteurs, musique EU,
relais g1/g2/g3 et nettoyage sont PASS. Les trois processus terminent par
`LoadPhase.Unload`, `NORMAL_EXIT`, rc 0, sans watchdog, signal, SIGSEGV, kill
forcé ni orphelin.

Rapport : `native_route_validation.json`. Reproduction :

```bash
bash tools/restore_pmdred_eu_validation_runtime.sh
bash docs/pmdred_eu/playable/tiny_woods/route_runtime_v2/commands.sh
```
