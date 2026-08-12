# Migration narrative PMD Red EU → New Era

La migration effective a commencé après l’audit exhaustif. Elle utilise un namespace parallèle `halcyon.pmdred_eu`, sans connexion à `FugitiveArc` ni aux chapitres New Era.

## État actuel

- **Lot actif :** phase 6.1, socle global, scène `s01` — prélude du portail avant le test de personnalité.
- **Résultat :** `PARTIAL_PASS_DEPENDENCY_BLOCKED`.
- **Scènes totalement migrées :** **0/133**.
- **Scène en cours :** `s01`, **11 commandes source sur 16** reproduites jusqu’au changement de musique inclus.
- **Connexion aux routes de jeu :** aucune.

La scène n’est volontairement **pas déclarée terminée**. Les commandes suivantes restent bloquées : opcode palette `0x22`, `SPECIAL_TEXT_PERSONALITY_QUIZ`, fondu BGM, opcode palette `0x23` et `RET`. Le sélecteur direct de personnages New Era ne remplace pas silencieusement le test de personnalité canonique.

## Ce qui est effectivement porté pour `s01`

1. arrêt de la musique ;
2. assertion du Ground certifié `s01`, sans modification ;
3. masquage des acteurs PMDO absents du secteur source ;
4. six blocs français exacts de la ROM EU, centrés sur fond noir ;
5. conservation de l’attente interne `#W` du sixième bloc sous forme de deux pages confirmées ;
6. nettoyage du texte ;
7. assertion du secteur d’entités canonique sans injection ;
8. lancement de `MUS_WELCOME_TO_THE_WORLD_OF_POKEMON` via l’asset PMDO hashé ;
9. arrêt dur et explicite sur la dépendance suivante.

Les textes ne proviennent pas de pret : `authority.json` conserve leur adresse et leurs bytes français EU dans l’ordre d’exécution.

## Validation PMDO réelle

Le replay isolé a été exécuté dans **PMDO 0.8.12** avec le SDL headless patché d’Agent A :

- 55 événements de timeline contigus avec frames monotones, frontière atteinte à la frame runtime 199 ;
- six commandes de dialogue et sept pages dans l’ordre attendu, avec début, capture et fin de chaque page journalisés ;
- sept captures synchronisées du plan Ground noir, sans acteur parasite ;
- arrêt explicite sur la dépendance attendue, jamais assimilé à une réussite complète ;
- sortie native `LoadPhase.Unload`, code **0** ;
- aucun signal watchdog, SIGSEGV, kill forcé ou processus résiduel ;
- aucun `RUNTIME_FAIL`, exception Lua ou clé de texte manquante.

Limite de preuve : `_GROUND:Screenshot()` capture le plan Ground, pas les glyphes UI. Les glyphes français sont donc prouvés par égalité avec les bytes ROM EU, puis par les appels UI réels sans exception et les événements synchronisés ; aucune comparaison pixel des glyphes n’est revendiquée.

Le transport GitHub actuel de DumpAsset n’a plus le hash gzip historique, mais son extraction possède exactement les **11 485 fichiers** et le manifeste d’arbre SHA-256 verrouillé par Agent A. Le lock suivi n’a pas été modifié.

## Garde immuable

`protected_baseline.json` gèle avant migration :

- 219 IDs Ground et leurs **438 destinations Ground/tile** certifiées ;
- les 99 fichiers explicitement protégés des chapitres 1–5 ;
- les 27 routes `FugitiveArc` et 48 fichiers d’intégration historique associés.

Commande obligatoire avant et après chaque lot :

```bash
python3 tools/verify_pmdred_eu_narrative_migration_guard.py
```

Cette commande ne régénère et ne revalide aucun Ground ; elle compare seulement les destinations promues aux hashes historiques.

Reproduction du lot PMDO, une fois l’environnement headless verrouillé présent :

```bash
bash tools/run_pmdred_eu_scene_s01_runtime.sh
```

Le runner ne lance ni convertisseur, ni finalizer, ni promoteur Ground.

## Artefacts

- [`protected_baseline.json`](protected_baseline.json) — baseline create-only ;
- [`progress.json`](progress.json) — progression machine des 133 scènes ;
- [`scenes/s01/authority.json`](scenes/s01/authority.json) — commandes, textes EU, Ground et audio ;
- [`scenes/s01/runtime/validation.json`](scenes/s01/runtime/validation.json) — verdict PMDO partiel ;
- [`scenes/s01/runtime/events.jsonl`](scenes/s01/runtime/events.jsonl) — timeline réelle ;
- [`scenes/s01/runtime/termination.json`](scenes/s01/runtime/termination.json) — terminaison native ;
- [`scenes/s01/runtime/evidence_hashes.sha256`](scenes/s01/runtime/evidence_hashes.sha256) — intégrité de la preuve ;
- [`HASHES.sha256`](HASHES.sha256) — intégrité du lot, des scripts et des autorités consommées.

## Prochaine étape obligatoire

Porter exactement le test de personnalité PMD Red EU et déterminer les opcodes palette `0x22`/`0x23`, puis reprendre `s01` au même point. La scène ne pourra être promue qu’après validation des questions, branches, résultat héros, fondus, audio, état final et transition vers la suite canonique.
