# Registre canonique des parcours — PMD Red EU, Réminiscencia et Relict

## Pourquoi ce registre existe

Un donjon canonique n'est pas seulement un JSON ou un Ground. Le contrat
PMD Red exige neuf composants indivisibles : entrée, gameplay, relais,
événements internes, pré-rencontre, mise en scène, combat, issues
victoire/défaite/retry et retour narratif.

`CANONICAL_JOURNEY_REGISTRY.json` relie sans écriture en production :

- les **219 Grounds PMD Red EU certifiés et immuables** ;
- les **133 scènes** de l'autorité narrative ;
- les **26 modules** de cinématique de donjon ;
- les **27 relations dungeon-backed** ;
- les **17 candidats environnementaux Réminiscencia** ;
- les **5 candidats environnementaux Relict**.

Un `PASS` du registre signifie que l'inventaire et ses blocages sont complets.
Il ne signifie jamais que les parcours sont déjà jouables ou canoniquement
terminés. À ce jour, le gate de production reste volontairement `BLOCKED` :
**0/133 scènes** et **0/27 chaînes** ont passé tous les gates runtime.

## Réminiscencia et Relict

Ces bibliothèques restent strictement **environnementales**. Le registre ne
porte ni casting source, ni dialogue, ni audio, ni moteur. Les tables de
Pokémon et de gameplay des candidats sont explicitement classées
`NEW_ERA_ADAPTATION_NOT_SOURCE_CANON`. Elles ne doivent jamais être présentées
comme le canon narratif de ces jeux ni mélangées silencieusement au canon PMD
Red.

## Gate ciblé actuel : Sinister Woods

Les éléments suivants passent :

- Grounds D04P01/D04P02 présents ;
- musique `Sinister Woods.ogg` sur les trois tranches procédurales ;
- architecture 15 + 5 + 3 étages ;
- tables Pokémon/niveaux/probabilités exactes sur le cycle canonique de 13
  étages, puis répétition déclarée comme adaptation New Era.

Deux blocages empêchent encore le statut canonique complet :

1. les étages procéduraux emploient les AutoTiles `treeshroud_forest_1_*` ;
2. ils chargent encore des blobs `relic_forest_blob_*`.

Aucun des deux n'est corrigé en modifiant silencieusement la Zone : le portage
du tileset procédural Sinister Woods et la politique de suppression des blobs
doivent être prouvés séparément. Les Grounds certifiés, scripts de chapitres
1–5 et routes FugitiveArc restent intacts.

## Reproduction

```bash
python3 tools/build_canonical_journey_registry.py \
  --output docs/canonical_journeys/CANONICAL_JOURNEY_REGISTRY.json

python3 tools/test_canonical_journey_registry.py \
  --authority .runtime-cache/canonical-authority
```

Le deuxième appel utilise des copies ignorées des autorités suivies ; sur une
branche complète, les chemins par défaut du premier appel suffisent.
