# Chenipan / efob108 — diagnostic v1 conservé

Cette première archive est conservée parce que le wrapper Python a échoué
**après** une exécution PMDO native réussie : il attendait par erreur 45
événements alors que l'inventaire explicite en contient 44. La terminaison
native est bien `PASS`, `LoadPhase.Unload`, `NORMAL_EXIT`, rc 0 et sans signal,
watchdog, SIGSEGV, kill forcé ou orphelin.

Aucune preuve n'a été transformée en PASS. Le diagnostic exact est dans
`CERTIFICATION_DIAGNOSTIC.json`. La correction limitée au cardinal du wrapper
et la certification complète sont conservées dans
`../efob108_attachment_runtime_v2/`.
