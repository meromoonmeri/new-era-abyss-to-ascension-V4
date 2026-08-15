# Reconstruction jouable PMD Red EU — checkpoint

Checkpoint du `2026-08-16`, branche
`arena/019ff05e-new-era-abyss-to-ascension-v4`.

## État autoritatif

- Grounds archive-backed : **219/219 PASS**, historique inchangé dans
  [`../pmdo_validation/progress.json`](../pmdo_validation/progress.json).
- Petit Bois, génération procédurale 1–3F : **PASS**.
- Petit Bois, ouverture/escaliers/sortie/échec/retry/sauvetage/nettoyage :
  **PASS v2** dans [`tiny_woods/route_runtime_v2`](tiny_woods/route_runtime_v2),
  avec les facings Red `4=North` corrigés. La v1 reste conservée avec erratum.
- Graphe scènes d’ouverture EU : **697 commandes / 117 textes français**.
- Route après sauvetage EU : **278 commandes / 78 textes français**, destination
  corrigée `d01p02:g1 → d01p01:g3 → b01p00a:g16 → s02_fre:g2`.
- Surface combinée : **27 tableaux / 975 adresses uniques / 61 opcodes / 195
  associations françaises**, conservée dans
  [`tiny_woods/command_plan.json`](tiny_woods/command_plan.json).
- Overlay privé jouable de la branche canonique sélectionnée : **NATIVE PASS v2**
  dans [`tiny_woods/command_complete_runtime_v2`](tiny_woods/command_complete_runtime_v2).
  Les deux exécutions isolées chargent chacune les 975 enregistrements avec
  opérandes/handlers exacts, puis exécutent 94 dialogues français avec fermeture
  de 94 menus, le renommage du héros après la ligne 23, un refus suivi d’une
  acceptation, le renommage d’équipe, les trois récompenses, les six BGM et les
  onze cues authentifiés.
- Progression post-`g3` : **NATIVE PASS** — Petit Bois `Completed`, scénario
  `3,0`, `EVENT_DIVIDE`, avec les index `master_zone` 141/308/329 et les Grounds
  promus `b01p00a` et `s02_fre` montés sans modification.
- Attachement natif Chenipan `0x56(62,0)` / attente `0xDE` : **NATIVE PASS**
  dans [`tiny_woods/efob108_attachment_runtime_v2`](tiny_woods/efob108_attachment_runtime_v2).
  La convention authentifiée convertit le centre EU `(180,148)` en top-left
  PMDO `(172,140)` ; le point `Head` terminal `(179,153)` et `LocHeight=4`
  placent `PMDRed_Efob108` au centre AX exact `(179,149)`. L'action terminale
  est `Walk`, non bouclée, et l'effet sélectionne les 13 poses authentifiées
  deux ticks chacune, `Finished=false` à 25 puis `true` à 26.
- Supplément sémantique bulk v3 : **304/304 PASS** dans
  [`command_semantic_supplement_v3.json`](tiny_woods/command_semantic_supplement_v3.json),
  SHA-256 `5c9463d14a7de20c40f8d1e183966de0fb43b28e2b0e853672bbe38cbc111237`.
  Il couvre 16 opcodes, 251 commandes du parcours sélectionné, 53 retry-only,
  108 attentes et exactement 3 001 frames source. Le plan 975-commandes reste
  octet pour octet inchangé et ses 15 lignes `actor.control_unknown` sont
  conservées hors supplément.
- Certification PMDO exacte v5 : **NATIVE PASS** dans
  [`tiny_woods/command_semantic_native_v5`](tiny_woods/command_semantic_native_v5).
  Les modes isolés `semantic_selected_v3` et `semantic_all_v3` valident
  respectivement 251 et 304 paires start/complete strictement adjacentes ; les
  92 attentes sélectionnées totalisent 2 690 frames et les 108 attentes du mode
  exhaustif totalisent 3 001 frames. Les deux terminaisons sont normales et
  strictement gracieuses.
- Régression indépendante : les trois anciens modes palette/commande complète
  repassent **15 commandes / 14 sélectionnées / 94 dialogues** dans
  [`tiny_woods/command_semantic_legacy_regression_v5`](tiny_woods/command_semantic_legacy_regression_v5).
  Le gate négatif create-only
  [`tiny_woods/command_semantic_failure_propagation_v3`](tiny_woods/command_semantic_failure_propagation_v3)
  injecte un mauvais address ordinal 0 : erreur explicite, verdict `FAIL`, zéro
  start accepté, zéro complete, arrêt natif gracieux rc 0, puis rejet obligatoire
  du certificateur avec rc 1. La régression focalisée complète passe **53/53**.

Les deux processus PMDO 0.8.12 se terminent par `LoadPhase.Unload`,
`NORMAL_EXIT`, rc 0, `terminal=true`, `graceful=true`, sans watchdog, signal,
SIGSEGV, kill forcé ni orphelin. Le rapport durable est
[`native_command_complete_validation.json`](tiny_woods/command_complete_runtime_v2/native_command_complete_validation.json),
SHA-256 `2a6fa101d35b9ad84656835b1583a6163d39a3ff4bf8b13100f4fdd084f5f97b`.
Le manifeste fixture a le SHA-256
`afbfde161c7f5280333b2411786a329ec600d450ea0696e32d1abeea890f6f65`.

Le script v2 a également été exécuté de bout en bout le `2026-08-13` dans
quatre nouvelles destinations create-only : rendu frais des six BGM et onze
cues, construction d'un overlay privé frais, puis deux nouvelles exécutions
natives. Cette **CLEAN REPRODUCTION PASS** est archivée sans modifier la v2 dans
[`tiny_woods/command_complete_clean_reproduction_v1`](tiny_woods/command_complete_clean_reproduction_v1).
Son certificat SHA-256 est
`2a2f86efc88d242a2345ca6d5e7ccce8b3c9af5598cf477021279882324dfda9`.
Les deux manifestes audio frais sont identiques octet pour octet aux manifestes
v2 ; le rapport est sémantiquement identique à la v2 hors hashes propres aux
nouveaux streams/logs/terminaisons et la fixture ne diffère que par ses racines
absolues create-only. Les deux nouvelles terminaisons satisfont les mêmes gates
stricts.

La première famille de handlers secondaires est maintenant certifiée : les 15
commandes palette exactes `0x22/0x23/0x25/0x26`, réparties dans six tableaux,
ont une sémantique épinglée aux sources pret et RogueEssence dans
[`secondary_palette_semantics_v1.json`](tiny_woods/secondary_palette_semantics_v1.json),
SHA-256 `c3e7b71dc3929680b665b2ef441624185e92b8bcb517257fb2f20fe007dbbb73`.
L’adaptateur applique les canaux principal/front, les sens entrée/sortie et les
durées EU 0/30/60 ; une durée source nulle est tracée comme telle mais exécutée
en une frame PMDO, car `ScreenFadeFX` ne rejoint pas un nouvel endpoint avec
`fadeTime=0`.

Trois exécutions natives strictes — `opening_naming`, `post_route` et
`palette_adapter_all` — sont **PASS**. Les deux parcours intégrés exécutent 14
transitions et ferment toujours les 94 dialogues ; le mode isolé adresse les
15/15 commandes dans l’ordre authentifié, y compris la transition retry non
sélectionnée `0x084CFFE8`. Toutes chargent et contrôlent encore les 975
commandes. L’archive durable create-only est
[`tiny_woods/palette_semantics_runtime_v1`](tiny_woods/palette_semantics_runtime_v1) ;
le rapport natif a le SHA-256
`6ca93529cf35868ed0125fc7e03d459cb082a9625e5137e7e5130f9ad54e10fb`
et le certificat le SHA-256
`e952b9118becfd2472ebec9366ac469567686c9d73d6254e1bbace9c5f85d0a1`.
Les trois terminaisons passent `LoadPhase.Unload`, `NORMAL_EXIT`, rc 0,
`terminal/graceful=true`, sans watchdog, signal, SIGSEGV, kill forcé ni
orphelin.

La certification d'attachement contient exactement 44 événements et termine
elle aussi par `LoadPhase.Unload`, `NORMAL_EXIT`, rc 0,
`terminal/graceful=true`, sans watchdog, signal, SIGSEGV, kill forcé ni
orphelin. Le rapport
[`native_attachment_validation.json`](tiny_woods/efob108_attachment_runtime_v2/native_attachment_validation.json)
a le SHA-256
`7922fc3610c2ecccd5a5ff031f592ae739cb08c575fe17f706aa87a84895006f` ;
l'asset particle a le SHA-256
`18d392d82c2c8b6aa101aa0a49bab0af58aae16aa6e5aebba92a7bf288f46def`.
La première archive
[`efob108_attachment_runtime_v1`](tiny_woods/efob108_attachment_runtime_v1)
reste un diagnostic conservé : son exécution native était PASS, mais le wrapper
post-runtime attendait par erreur 45 événements. Seul ce cardinal a été corrigé
à 44 ; aucun gate natif ou sémantique n'a été relâché.

La correction de métadonnées retrouvée est documentée create-only dans
[`tiny_woods/command_semantic_metadata_correction_v3`](tiny_woods/command_semantic_metadata_correction_v3).
Elle assigne une catégorie et un contrat API à chacune des 304 lignes sans
modifier leurs adresses, opcodes, opérandes ou handlers source. La certification
native v5 recopie plan, supplément, manifeste fixture et preuves brutes, puis
les revalide indépendamment. Son rapport a le SHA-256
`e0ab16d361c77ccb5e9b533189037243590df6dcfaedbb96cf6465abb31dc7c7` et
son certificat le SHA-256
`04b1c16520ccda82d5392b3166f58ee841210f48f9f5abd16653ef0a530acc12`.
Chaque processus atteint `LoadPhase.Unload`, `NORMAL_EXIT`, rc 0,
`terminal/graceful=true`, sans watchdog, signal, SIGSEGV, kill forcé ni
orphelin. Un pre-roll strictement interne au harness consomme le bootstrap tick
zéro de PMDO avant la première commande authentifiée ; aucun argument d'attente
source n'est modifié ou décompté.

La première archive `command_complete_runtime` reste conservée. Ses onze Ogg
sont octet pour octet identiques à la v2 et son PASS natif reste valide, mais
son manifeste fanfare nommait un hash de source intermédiaire non suivi. Elle
est donc supplantée **uniquement pour la reproductibilité de provenance**. La
v2 archive les manifestes audio et
[`provenance.json`](tiny_woods/command_complete_runtime_v2/provenance.json),
qui lie le renderer suivi au SHA-256
`eec95deff18c4e22514541e21986c76843af3850caa6e3f4549df69ec6e53f10`.

## Portée exacte du PASS

Le PASS natif de parcours historique couvre la branche grammaticale D1/neutre,
avec une itération de la boucle de refus. Les 27 tableaux, les 975 commandes et
les 195 associations françaises restent préservés et contrôlés adresse par
adresse. La passe palette exécute ses 15 commandes exactes, dont 14 sur le
parcours sélectionné. La passe v3 ajoute un inventaire sémantique exhaustif des
304 commandes ciblées et deux dispatches isolés : 251 commandes sélectionnées,
puis 304 avec les 53 alternatives retry-only. Elle ne prétend pas parcourir
toutes les alternatives grammaticales dans une seule partie. La preuve
historique `scene_runtime` reste un **PARTIAL PASS**, ni remplacée ni réécrite.

La distinction de portée du certificat v3 est impérative : les 108 commandes
`wait` sont effectivement exécutées et mesurées à leur durée source exacte ; les
196 autres commandes certifient métadonnées, ordre, adresse et contrat API dans
un harness isolé. Leur liaison aux acteurs, caméras et scènes canoniques de la
quête live reste à faire. Le mode « selected » du harness charge `d01p01` mais ne
constitue pas à lui seul un parcours live ouverture → donjon → sauvetage → base
→ titre. Les 15 lignes `actor.control_unknown` du plan sont disjointes du
supplément et restent inchangées.

Ce checkpoint ne promeut donc pas encore les scripts Ground privés dans la quête
live. Il clôt la génération bulk, les gates natifs selected/all, la régression
legacy et la propagation de FAIL. La prochaine passe doit lier étroitement les
contrats non-wait aux contextes canoniques, certifier le parcours live complet,
puis poursuivre la restitution bulk des donjons sans modifier les preuves
historiques.

## Reprise exacte

```bash
bash tools/restore_pmdred_eu_validation_runtime.sh
python3 tools/update_pmdred_eu_validation_progress.py --check
python3 -m unittest tools.test_pmdred_tiny_woods_command_semantic_v3 -v
bash docs/pmdred_eu/playable/tiny_woods/command_semantic_native_v5/commands.sh
```

`commands.sh` reconstruit un supplément frais déterministe, une fixture privée
fraîche, deux preuves PMDO fraîches, puis les certifie dans des destinations
create-only. Pour ne revalider que la correction de métadonnées :

```bash
bash docs/pmdred_eu/playable/tiny_woods/command_semantic_metadata_correction_v3/commands.sh
```

Rejouer également les régressions historiques sans `pytest` :

```bash
PYTHONPATH=tools .runtime-cache/test-venv/bin/python -m unittest \
  tools.test_build_pmdred_tiny_woods \
  tools.test_pmdred_tiny_woods_native \
  tools.test_pmdred_tiny_woods_route \
  tools.test_pmdred_tiny_woods_scenes \
  tools.test_pmdred_tiny_woods_post_route \
  tools.test_build_pmdred_tiny_woods_command_plan \
  tools.test_build_pmdred_tiny_woods_command_complete_overlay \
  tools.test_pmdred_tiny_woods_command_complete \
  tools.test_pmdred_tiny_woods_palette_semantics \
  tools.test_pmdred_efob108_attachment \
  tools.test_pmdred_tiny_woods_command_semantic_v3 -v
```

Les rendus audio, suppléments, fixtures, preuves et archives sont create-only.
Si une destination de reproduction existe, copier `commands.sh` et choisir un
nouveau suffixe cohérent plutôt que l’écraser. Ne jamais réutiliser ni modifier
les fixtures consommées v1–v18.

## Étape suivante

Phase `tiny_woods_production_actor_context_binding_live_route_integration_and_native_certification` :

1. consommer le supplément v3 immuable et résoudre en bulk les contextes
   canoniques acteur/caméra/scene des 196 contrats non-wait, sans modifier le
   plan, les adresses, les opérandes, les 108 attentes ou les archives v1–v5 ;
2. intégrer uniquement les liaisons authentifiées dans une nouvelle fixture
   privée create-only, en réutilisant la convention spatiale, l'attachement
   efob108, les palettes, musiques, cues et dialogues déjà certifiés ;
3. sérialiser les gates PMDO : alternatives/retries isolées, parcours live
   sélectionné ouverture → Petit Bois 1–3F → sauvetage → base → titre,
   progression et nettoyage, avec terminaison stricte et propagation FAIL ;
4. promouvoir seulement après preuve exhaustive et régression historique, puis
   commit/push/remote exact ; poursuivre automatiquement l'inventaire et la
   restitution bulk des donjons suivants.

Les références aplaties existantes ne sont pas canoniques par défaut. Les octets
EU restent l’autorité de contenu ; `pret/pmd-red` reste une référence structurelle
uniquement.
