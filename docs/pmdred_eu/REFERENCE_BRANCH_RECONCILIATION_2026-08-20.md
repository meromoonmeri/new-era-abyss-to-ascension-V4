# Réconciliation de la branche méthodologique PMD Red

**Référence étudiée :** `arena/019ff05e-new-era-abyss-to-ascension-v4` à
`c548f0a2cdaf1fb7d740c849c185548ba39f5bc4`  
**Branche actuelle :** `arena/01a01fce-new-era-abyss-to-ascension-v4` à partir
de `4b9618489bde6c9453497ff60307e82bdae5235f`  
**Date :** 2026-08-20

## Travail repris, pas seulement audité

La branche de référence contenait un chantier jouable qui n'était plus présent
dans le checkout actuel. Ont été restaurés sans toucher au jeu live :

- **303 fichiers** de preuves et manifests sous `docs/pmdred_eu/playable/` ;
- **70 outils/tests PMD Red** absents du checkout actuel ;
- les preuves préexistantes d'échec create-only et de correction d'index dont
  dépendent les tests de récupération fail-closed ;
- zéro Ground, zone, tile, script ou musique live promu.

Le générateur du supplément sémantique Petit Bois dépendait de la date murale et
ne pouvait plus reproduire l'artefact du 2026-08-16. Il utilise désormais la
date immuable de l'événement de récupération. Trois tests restés sur l'ancien
nom de phase ont été alignés sur le checkpoint plus récent
`early_dungeon_bulk_after_mt_steel_begin_sinister_woods`.

Le guard courant repasse après ces opérations et protège toujours 219 IDs / 438
destinations, 99 fichiers chapitres 1–5, 27 routes FugitiveArc et 48 fichiers
d'intégration historique.

## Ce que la branche de référence avait réellement terminé

### Petit Bois

- génération procédurale 1–3F : `PASS` ;
- entrée, escaliers, sortie, échec/retry, sauvetage et nettoyage : `PASS NATIVE
  V2` ;
- graphe d'ouverture : 697 commandes et 117 textes français ;
- route post-sauvetage : 278 commandes et 78 textes français ;
- plan combiné : 975 adresses, 61 opcodes, 195 associations françaises ;
- branche sélectionnée, dialogues, renommages, récompenses et progression :
  preuves natives ;
- palettes, attentes et effet Chenipan `efob108` : preuves natives dédiées.

**Mais la narration est explicitement `PARTIAL_PASS`.** Les contrats non-wait
restent à lier aux acteurs et à la caméra de production ; les alternatives non
sélectionnées ne sont pas toutes exécutées dans une route de jeu complète.

### Grotte Éclair

- cinq étages, tables EU, spawns, objets, pièges, musique, AutoTiles, Ground
  final direct et sortie sans marqueur inventé : `PASS_STATIC_INTEGRATION` ;
- 22 gates statiques ;
- certification native route/gameplay/audio/unload :
  **`DEFERRED_NOT_EXECUTED`**.

### Mt Acier

- 1–8F procéduraux, 9F fixe, tables EU, Airmure, Taupiqueur protégé, musique,
  Ground final direct : `PASS_STATIC_INTEGRATION` ;
- 38 gates statiques ;
- certification native route/gameplay/audio/unload :
  **`DEFERRED_NOT_EXECUTED`**.

Les Grounds directs `d02p02` et `d03p02` de la référence sont byte-identiques
aux candidats déjà conservés dans `RESERVE/pmdred_direct/` dans la branche
actuelle. Il n'est donc pas nécessaire de les reconstruire ou de les remplacer.

## Avances propres à la branche actuelle

La branche actuelle a, entre autres :

- le contrat définitif d'intégration dans New Era ;
- la garde immuable narrative ;
- le démarrage New Era restauré et validé ;
- `s01` entièrement rejouée en runtime isolé mais encore dormante ;
- le matériau ROM EU `b41` de Sinister Woods promu sous namespace dédié et
  validé sans réutiliser les blobs Relic Forest ;
- l'inventaire des 133 scènes et l'IR de cinématiques de donjon.

La recommandation historique d'une campagne parallèle est donc supplantée : le
contrat actuel interdit une seconde campagne et un second Personality Quiz.
Les preuves isolées de la référence restent utilisables comme harnesses, pas
comme route produit concurrente.

## Divergence protégée découverte

Le test de correction des pilotes de la référence attend `h26p01` et `a01p01`
dans `master_zone.GroundMaps`. Les deux Grounds existent, mais ces deux entrées
sont absentes du JSON actuel.

Une insertion minimale a été essayée localement puis immédiatement annulée : le
guard autoritatif courant protège `Data/Zone/master_zone.json` avec le hash
`f9e39a…` et rejette cette modification. Cette divergence ne peut donc pas être
« réparée » silencieusement. Elle exige un lot explicite de migration de
baseline, réindexation PMDO et preuve runtime ; elle reste bloquée jusque-là.

## Blocages externes précis

Aucun fichier `.gba`, exécutable PMDO/PMDC ou DumpAsset officiel n'est présent
dans le workspace.

1. **ROM PMD Red EU** requise :
   `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`.
   Sans elle, aucune nouvelle extraction/reconstruction/source-authentication
   ne peut être qualifiée.
2. **PMDO 0.8.12** requis :
   `faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327`.
   Sans lui et ses assets correspondants, impossible de produire les nouvelles
   preuves exact-engine route/gameplay/audio/unload.
3. **DumpAsset officiel correspondant** : nécessaire aux promotions create-only
   des AutoTiles, items et feuilles PMDO absents.
4. `pret/pmd-red` et RogueEssence sont publics et ont été récupérés
   temporairement aux commits verrouillés ; les tests de structure concernés
   passent. Ils ne remplacent jamais la ROM comme autorité de contenu.

## Ordre de reprise

1. Restaurer localement les trois autorités externes exactes dans le stockage
   ignoré.
2. Rejouer les builders existants en `--check`, sans écriture live.
3. Construire les fixtures isolées Petit Bois, Grotte Éclair et Mt Acier dans
   l'état **actuel** du dépôt.
4. Fermer les bindings acteurs/caméra et les opcodes encore non exécutés de
   Petit Bois.
5. Exécuter la certification groupée PMDO route/gameplay/audio/unload des trois
   donjons précoces.
6. Proposer ensuite seulement une promotion atomique compatible avec le contrat
   New Era et le guard.
7. Continuer les vagues dans l'ordre canonique, en gardant séparés le gate des
   27 Grounds directs et le gate narratif des 133 scènes.

La matrice complète et les blocages sont également enregistrés dans
`REFERENCE_BRANCH_RECONCILIATION_2026-08-20.json`.

## Mise à jour — autorités publiques récupérées le 2026-08-20

L'enquête ne s'est pas arrêtée au workspace : le lock existant
`runtime_dependencies.lock.json` et les dépôts indiqués par l'utilisateur ont
permis une restauration complète.

- `meromoonmeri/RUNTIMEPMDO@61c005e1` fournit l'archive
  `c64f72af…61577`; son apphost est exactement
  `faf9755c…de8327` (**MATCH**).
- `audinowho/PMDODump@v0.8.12` verrouille PMDC
  `e975bd33…8bab` et DumpAsset `9d864d14…9c9`.
- DumpAsset extrait contient exactement **11 485 fichiers** et reproduit le
  manifeste `42be7408…356d` (**MATCH**).
- la source explicitement verrouillée
  `meromoonmeri/PMD-RED-PMDO-PORT@b441d467` contient la ROM EU ; taille
  33 554 432 et SHA-256 `0f9d125d…cbcd` (**MATCH**).
- le restoreur a régénéré 724 ressources et 219 candidats, puis reproduit
  23 716 938 comparaisons tile/tick sans échec.

La qualification a repris immédiatement : Petit Bois repasse en runtime natif,
Grotte Éclair passe les probes exact-engine sur 5/5 étages, et Mt Acier passe
1F–8F. Le probe 9F de Mt Acier a découvert un vrai défaut que l'ancien PASS
statique ne voyait pas : `mt_steel_peak.rsmap` encode `Character.Tactic` comme
une chaîne, donc PMDO 0.8.12 refuse la map. Une première correction isolée du
Tactic révèle ensuite un second champ invalide (`Character.BackRef` entier au
lieu de `TempCharBackRef`). La 9F tombe sur une map vide 10×10 : elle est donc
**FAIL runtime**, non promotable. Les preuves complètes sont conservées dans
`docs/pmdred_eu/playable/runtime_recovery_2026-08-20/`.

## Mise à jour — achèvement du sérialiseur boss fixe Mt Acier (2026-08-21)

La branche de référence a avancé jusqu'à `b3d7278f`, qui étend le renderer et le
validateur aux `PlaceNoLocMobsStep` hostiles introduits par `c548f0a2`. Ce
couple de commits révélait l'objectif inachevé : sortir les boss des anciens
`Character` sérialisés dans la map et les créer via les `MobSpawn` natifs du
`MapLoadContext`.

La continuation termine cette intention sans relâcher les gates :

- Airmure est maintenant un hostile chargé après `MappedRoomStep` ;
- Taupiqueur est un allié chargé séparément, `wait_only`, `all_protect` et non
  recrutable ;
- la map fixe ne contient plus aucun `Character` historique invalide ;
- le conteneur vient d'une map PMDO 0.8.12 native (`ReRandom`, couche de décor
  `AnimLayer`) au lieu du template 0.8.9 ;
- `BattlePositionEvent.StartLocs` utilise des offsets relatifs à l'entrée ;
- renderer et validateur contrôlent indépendamment hostiles **et** alliés
  chargés.

Le replay exact PMDO 0.8.12 charge désormais réellement la 9F en 9×17 avec la
musique Mt Acier, l'entrée (4,9), Airmure (4,8), Taupiqueur protégé (4,3) et les
29 cellules isolées explicitement autorisées. Verdict du probe : `PASS`, sortie
native `LoadPhase.Unload`, rc 0, sans diagnostic ni processus résiduel.

Preuve create-only :
`docs/pmdred_eu/playable/mt_steel/native_9f_fix_2026-08-21/validation.json`.
La promotion reste interdite tant que le combat naturel, le callback de victoire,
la transition `d03p02` et les routes retry/abandon ne sont pas certifiés.

## Mise à jour — route native Mt Acier (2026-08-21)

La passe suivant le chargement 9F a joué le combat via
`DungeonScene.ProcessPlayerInput` et un `GameAction.Attack` natif. Pour rendre
la preuve déterministe sans court-circuiter les événements de combat, l'équipe
de fixture est montée au niveau 100 ; Airmure est vaincu par le moteur en une
attaque. Le callback `MountSteelSkarmoryClear` termine le segment.

Cette exécution a découvert et corrigé dans le candidat de fixture un second bug
historique : `RedEarlyDungeonRoute` passait `config.ending_ground` (`d03p02`)
comme **Zone ID** à `EndDungeonRun`. Le contrat correct utilise `zone.ID`, puis
le map index numérique. Après correction, PMDO observe `d03p02`, exécute sa
sortie, pose `D03Cleared=true`, efface `Pending` et revient à `metano_town`.

Verdict : `PASS_NATIVE_BOSS_CLEAR_ENDING_RETURN`, terminaison native rc 0, sans
diagnostic. Preuve :
`docs/pmdred_eu/playable/mt_steel/native_route_2026-08-21/validation.json`.
La preuve ne certifie pas encore le texte français des dialogues ni les routes
défaite/retry/abandon ; aucune promotion live n'est effectuée.

### Route d'échec Mt Acier

Le même candidat a été exécuté avec un vrai `GameAction.GiveUp`. PMDO produit le
résultat `Failed`, n'entre pas dans `d03p02`, ne pose pas `D03Cleared` et revient
à `metano_town`. Verdict `PASS_NATIVE_GIVEUP_FAILURE_RETURN`, rc 0, aucun
diagnostic. Preuve :
`docs/pmdred_eu/playable/mt_steel/native_failure_2026-08-21/validation.json`.
Le wipe naturel n'est pas assimilé à cette preuve et reste distinct ; la route
Mt Acier actuelle ne possède pas de contrat retry dédié.
