# Reconstruction jouable PMD Red EU — checkpoint

Checkpoint du `2026-08-13`, branche
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

La première archive `command_complete_runtime` reste conservée. Ses onze Ogg
sont octet pour octet identiques à la v2 et son PASS natif reste valide, mais
son manifeste fanfare nommait un hash de source intermédiaire non suivi. Elle
est donc supplantée **uniquement pour la reproductibilité de provenance**. La
v2 archive les manifestes audio et
[`provenance.json`](tiny_woods/command_complete_runtime_v2/provenance.json),
qui lie le renderer suivi au SHA-256
`eec95deff18c4e22514541e21986c76843af3850caa6e3f4549df69ec6e53f10`.

## Portée exacte du PASS

Le PASS natif couvre la branche grammaticale D1/neutre déjà sélectionnée par le
plan de scène, avec une itération de la boucle de refus. Les 27 tableaux, les
975 commandes et les 195 associations françaises sont tous préservés et
contrôlés adresse par adresse dans l’overlay. Les alternatives grammaticales et
les chemins de contrôle non sélectionnés ne sont pas prétendus exécutés dans
une seule partie. La preuve historique `scene_runtime` reste un **PARTIAL PASS**
et n’est ni remplacée ni réécrite.

Ce checkpoint ne promeut pas encore les scripts Ground de l’overlay dans la
quête live : la prochaine passe doit donner une sémantique PMDO exécutable aux
handlers de contrôle/chorégraphie secondaires non parcourus, tester leurs
branches, puis intégrer l’overlay étroitement sans modifier les preuves
historiques.

## Reprise exacte

```bash
bash tools/restore_pmdred_eu_validation_runtime.sh
python3 tools/update_pmdred_eu_validation_progress.py --check
bash docs/pmdred_eu/playable/tiny_woods/command_complete_runtime_v2/commands.sh
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
  tools.test_pmdred_tiny_woods_command_complete -v
```

Les rendus audio, fixtures et preuves sont create-only. Si les destinations
`*-repro-v2` existent, choisir un nouveau suffixe cohérent dans `commands.sh`
plutôt que les écraser.

## Étape suivante

Phase `tiny_woods_opcode_semantic_choreography_and_production_integration` :

1. transformer les handlers déclaratifs des 61 opcodes en exécution PMDO sûre,
   en respectant appels, retours, labels, branches grammaticales et attentes ;
2. restituer et tester les émotions/portraits, rotations, marches, animations,
   caméra et synchronisations secondaires que la branche native actuelle ne
   parcourt pas encore ;
3. exécuter des scénarios isolés pour les alternatives et les retries sans
   affaiblir les gates de terminaison ;
4. seulement après ces preuves, intégrer étroitement les scripts et assets de
   l’overlay à la quête live, puis certifier un playthrough ouverture → donjon →
   sauvetage → base → titre.

Les références aplaties existantes ne sont pas canoniques par défaut. Les octets
EU restent l’autorité de contenu ; `pret/pmd-red` reste une référence structurelle
uniquement.
