# Lot Red Story 02 — Silent Chasm + Great Canyon

## Résultat

| Donjon | Réconcilié | Généré | Mapgen | Promu | Blocage exact |
|---|---:|---:|---:|---:|---|
| Silent Chasm | non | non | non | non | `ITEM_BLOWBACK_ORB`, `ITEM_HURL_ORB`, `ITEM_RADAR_ORB`, `ITEM_SWITCHER_ORB`, `ITEM_WARP_ORB` sans équivalent PMDO exact |
| Great Canyon | non | non | non | non | `ITEM_LINK_BOX` et `ITEM_TM_TOXIC` absents des assets PMDO |

Les deux manifests, DTEF et Grounds sont identifiés, mais aucune DungeonDefinition candidate n’est écrite : le gate de configuration s’arrête avant génération. Les orbes ne sont pas remplacés par des baguettes et la TM Toxic n’est pas remplacée par un objet ou move différent.

Le rapport machine est `batch_report.json`.
