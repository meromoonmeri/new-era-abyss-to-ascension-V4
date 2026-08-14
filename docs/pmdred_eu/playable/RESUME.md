# Reconstruction jouable PMD Red EU — checkpoint

Checkpoint du `2026-08-15`, branche
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

La première archive `command_complete_runtime` reste conservée. Ses onze Ogg
sont octet pour octet identiques à la v2 et son PASS natif reste valide, mais
son manifeste fanfare nommait un hash de source intermédiaire non suivi. Elle
est donc supplantée **uniquement pour la reproductibilité de provenance**. La
v2 archive les manifestes audio et
[`provenance.json`](tiny_woods/command_complete_runtime_v2/provenance.json),
qui lie le renderer suivi au SHA-256
`eec95deff18c4e22514541e21986c76843af3850caa6e3f4549df69ec6e53f10`.

## Portée exacte du PASS

Le PASS natif de parcours couvre la branche grammaticale D1/neutre déjà
sélectionnée par le plan de scène, avec une itération de la boucle de refus. Les
27 tableaux, les 975 commandes et les 195 associations françaises sont tous
préservés et contrôlés adresse par adresse dans l’overlay. La passe palette
ajoute l’exécution sémantique des 15 commandes concernées : 14 sur le parcours
sélectionné et 15/15 dans le dispatcher isolé. Elle ne prétend pas exécuter les
autres familles d’opcodes ni toutes les alternatives grammaticales dans une
seule partie. La preuve historique `scene_runtime` reste un **PARTIAL PASS** et
n’est ni remplacée ni réécrite. Le fallback déclaratif `actor.control_unknown`
du plan reste volontairement intact tant qu’une famille n’est pas certifiée.

Ce checkpoint ne promeut pas encore les scripts Ground de l’overlay dans la
quête live. Il certifie le mécanisme natif borné de `0x56/0xDE`, la convention
spatiale et le cycle de vie de l'effet, mais ne prétend pas avoir généré,
intégré ou exécuté le supplément complet de 304 commandes. La prochaine passe
doit produire ce supplément en bulk depuis le plan immuable, tester ses branches
puis l’intégrer étroitement sans modifier les preuves historiques.

## Reprise exacte

```bash
bash tools/restore_pmdred_eu_validation_runtime.sh
python3 tools/update_pmdred_eu_validation_progress.py --check
bash docs/pmdred_eu/playable/tiny_woods/efob108_attachment_runtime_v2/commands.sh
```

Rejouer également les régressions sans `pytest` :

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
  tools.test_pmdred_efob108_attachment -v
```

Les rendus audio, fixtures et preuves sont create-only. Si les destinations
`pmdred-efob108-attachment-repro-v1` ou
`pmdred-efob108-attachment-evidence-repro-v1` existent, copier `commands.sh` et
choisir un nouveau suffixe cohérent plutôt que les écraser.

## Étape suivante

Phase `tiny_woods_304_command_semantic_supplement_generation_integration_and_native_certification` :

1. générer en bulk depuis `command_plan.json` les **304** commandes restantes :
   `0x2D=25`, `0x2E=54`, `0x54=18`, `0x56=1`, `0x62=1`, `0x6A=1`,
   `0x6B=31`, `0x8B=8`, `0x91=46`, `0x95=2`, `0x98=1`, `0x99=1`,
   `0xDB=108`, `0xDD=2`, `0xDE=1`, `0xDF=4` ;
2. réutiliser la convention spatiale et le mécanisme d'attachement certifiés,
   respecter appels, retours, labels et branches grammaticales, et garder le
   fallback intact avant certification complète ;
3. sérialiser les gates PMDO : inventaire exhaustif, scénarios isolés pour les
   alternatives/retries, puis parcours sélectionné, avec terminaison stricte ;
4. après seulement ces preuves, intégrer étroitement les scripts et assets à la
   quête live puis certifier ouverture → donjon → sauvetage → base → titre avant
   de poursuivre automatiquement la restitution des donjons.

Les références aplaties existantes ne sont pas canoniques par défaut. Les octets
EU restent l’autorité de contenu ; `pret/pmd-red` reste une référence structurelle
uniquement.
