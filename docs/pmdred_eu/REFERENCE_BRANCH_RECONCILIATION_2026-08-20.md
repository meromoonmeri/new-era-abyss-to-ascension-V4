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
