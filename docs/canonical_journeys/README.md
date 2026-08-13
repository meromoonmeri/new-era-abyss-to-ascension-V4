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

## IR des cinématiques de donjon

`PMD_RED_DUNGEON_SCENE_IR.json` conserve dans l'ordre les **4 967 actions** des
**267 tableaux** appartenant aux 27 relations dungeon-backed. Les 712 actions
brutes ou inconnues ne sont jamais supprimées : elles portent
`UNMAPPED_PRESERVED` et maintiennent chaque scène en état non routable. Le texte
n'est conservé que par hash d'autorité ; aucun corps de dialogue protégé n'est
recopié dans ce registre.

## Registre sémantique des opcodes et premiers adaptateurs

`PMD_RED_OPCODE_REGISTRY.json` relie les 88 types d'action du corpus aux
exécuteurs `pret/pmd-red` verrouillés et aux API de l'exact PMDO 0.8.12. La
preuve PMDO ne repose pas sur une API actuelle supposée compatible : le PDB du
runtime verrouillé contient un Source Link vers le commit RogueEssence
`4961b227…`, lui-même vérifié fichier par fichier.

Le registre classe **4 731 actions** avec une sémantique source prouvée et
conserve **236 actions** derrière une sémantique seulement partielle (callbacks
ou contrôleurs encore non nommés). Trois primitives seulement ont pour
l'instant une équivalence d'implémentation prouvée : `WAIT`, `BGM_FADEOUT` et
`SET_DIR_WAIT`, soit **586 occurrences**. Leur module dormant
`CanonicalPrimitiveAdapters.lua` :

- remappe les huit directions par symbole, car les valeurs numériques
  est/ouest de PMD Red et RogueElements sont inversées ;
- refuse tout opérande invalide et tout opcode hors de ces trois primitives ;
- n'enregistre aucune route et ne modifie aucun Ground ou Zone.

Ces trois primitives passent aussi le harness moteur
`primitive_adapter_runtime/` dans l'exécutable exact PMDO 0.8.12. Le harness
emploie uniquement son Ground synthétique ignoré : aucun Ground certifié n'est
revalidé.

Cela ne rend toujours aucune scène jouable : acteurs, textes EU, assets audio,
graphes de branches, cues concurrents, waypoints et transitions restent à lier
et à valider dans le runtime exact.

## Garde runtime dormant

`Data/Script/halcyon/pmdred_eu/CanonicalJourneyRegistry.lua` expose les 27
chaînes et leurs neuf composants au namespace technique PMD Red. Il ne require
aucun service et n'enregistre aucune route. `AssertReady(id)` refuse donc toute
entrée tant que la chaîne n'est pas complètement validée ; cela empêche qu'un
Ground certifié soit confondu avec un parcours canonique terminé.

## Reproduction

```bash
python3 tools/build_canonical_journey_registry.py \
  --output docs/canonical_journeys/CANONICAL_JOURNEY_REGISTRY.json \
  --report docs/canonical_journeys/JOURNEY_STATUS.md \
  --lua-output Data/Script/halcyon/pmdred_eu/CanonicalJourneyRegistry.lua

python3 tools/build_pmdred_dungeon_scene_ir.py \
  --output docs/canonical_journeys/PMD_RED_DUNGEON_SCENE_IR.json

python3 tools/build_pmdred_opcode_registry.py \
  --source-actions .runtime-cache/canonical-authority/source_action_index.json \
  --narrative-scope .runtime-cache/canonical-authority/narrative_scope.json \
  --pret-root .runtime-cache/pmd-red-bf0092 \
  --rogue-root .runtime-cache/rogue-essence-0812 \
  --pmdo-pdb .runtime-cache/pmdo-api-proof/RogueEssence.pdb \
  --output docs/canonical_journeys/PMD_RED_OPCODE_REGISTRY.json

python3 tools/test_canonical_journey_registry.py \
  --authority .runtime-cache/canonical-authority
python3 tools/test_pmdred_dungeon_scene_ir.py \
  --authority .runtime-cache/canonical-authority
python3 tools/test_pmdred_opcode_registry.py \
  --authority .runtime-cache/canonical-authority \
  --pret-root .runtime-cache/pmd-red-bf0092 \
  --rogue-root .runtime-cache/rogue-essence-0812 \
  --pmdo-pdb .runtime-cache/pmdo-api-proof/RogueEssence.pdb
.runtime-cache/test-venv/bin/python \
  tools/test_pmdred_primitive_adapters.py
python3 tools/test_pmdred_primitive_adapter_runtime.py \
  --pmdo .runtime-cache/pmdo-headless-bundle/PMDO
```

La reproduction moteur complète est documentée dans
`primitive_adapter_runtime/README.md`.

Les autorités, checkouts verrouillés et environnements d'exécution sous
`.runtime-cache/` sont ignorés. Les artefacts publiés ne contiennent aucun de
leurs chemins locaux.
