# Petit Bois — scènes françaises EU exécutables

Statut : **PARTIAL PASS fonctionnel** (`2026-08-13`).

Cette étape authentifie directement dans la ROM Europe les graphes complets de
`d01p01` (Ground régional 183) et `d01p02` (184) : **697 commandes** et **117
blocs de texte français**, sans divergence de graphe typé. Le plan exécutable
sélectionne les branches D1/default neutres faute de correspondance authentifiée
entre `PARTNER_TALK_KIND` de Red et un profil PMDO ; les autres variantes restent
conservées dans `../eu_scene_graph.json`.

## Preuve PMDO

Trois processus exact-PMDO 0.8.12 exécutent quatre groupes :

- `d01p01:g1` : 38 lignes, réveil, rencontre, arrivée de Papilusion et départ ;
- `d01p01:g2` : 11 lignes, réveil après défaite et nouvelle tentative ;
- `d01p02:g1` : 6 lignes, rencontre de Chenipan ;
- `d01p01:g3` : 19 lignes, remerciements et invitation du partenaire.

Les **74 lignes françaises sélectionnées** sont observées dans l’ordre exact de
leurs pointeurs ROM. Chacune ouvre puis ferme un menu natif. Les acteurs sont
instanciés aux positions et facings Red, dont `4=North → PMDO Up:4`. Les trois
scénarios exécutent 18 jalons de chorégraphie et les transitions d’état
ouverture/défaite/sauvetage. Toutes les terminaisons sont `LoadPhase.Unload`,
`NORMAL_EXIT`, rc 0, sans watchdog, signal, SIGSEGV, kill ni orphelin.

## Musiques ROM

Quatre morceaux sont rendus depuis la ROM avec M4plAy/libogg/libvorbis épinglés.
Pour chaque morceau, un processus découvre la répétition complète de l’état de
séquence, puis deux nouveaux processus doivent produire des Ogg byte-identiques :

| ID | Fichier | SHA-256 |
|---:|---|---|
| 10 | `PMD Red - There's Trouble.ogg` | `ee1472d8f2121e2f1388106fb24a601f7b276ca58cf032f1c0594466e039b707` |
| 101 | `PMD Red - Heartwarming.ogg` | `6ef0e60aa3aafc5606393103c9631d89c030341443d126df997cddb9107d5ac0` |
| 103 | `PMD Red - A Successful Rescue.ogg` | `9c581ff4ea0c231b58bd19c7fc5681a927a0dcf911eefef0f73858760475fd2e` |
| 114 | `PMD Red - In the Depths of the Pit.ogg` | `09f3bec584f3d35a1a2e9173ec977b4363169d99fdfa3cca7e2e1844c9c2f3d6` |

Ces quatre nouveaux fichiers sont promus non destructivement ; l’ancien asset
`In the Depths of the Pit.ogg` reste intact.

## Reproduction

```bash
bash tools/restore_pmdred_eu_validation_runtime.sh
bash docs/pmdred_eu/playable/tiny_woods/scene_runtime/commands.sh
```

L’audit ROM et le rendu musical complet utilisent respectivement
`tools/audit_pmdred_eu_tiny_woods_scenes.py` et
`tools/render_pmdred_scene_music.py` avec les commits de dépendances consignés
dans `music_render_validation.json`.

## Limite restante

Ce PASS n’est pas encore la restitution commande-par-commande de chaque cue :
les fanfares, portraits/émotions secondaires, tous les chemins de marche, le
renommage interactif, les messages d’objets de récompense et la destination
post-`g3` doivent encore être branchés et certifiés avant promotion des scripts
Ground live. Le graphe et les textes complets sont désormais durables pour cette
étape suivante.
