# DOUBLETRIO — ANALYSE DES SCRIPTS (47 Lua, 28 102 lignes)

## Organisation
```
main.lua / common.lua / scriptvars.lua      → bootstrap, SV
event.lua, event_battle.lua, event_mapgen.lua,
event_single.lua, event_misc.lua            → handlers d'événements par domaine
beholder.lua                                 → lib pub/sub (Enrique García Cota)
helpers.lua, GeneralFunctions.lua            → utilitaires
zone/<dungeon>/init.lua (3)                  → hooks de zone (69–225 lignes seulement !)
ground/                                      → scripts de grounds checkpoints
menu/ + services/{custom_upgrade,enchant_tools,
  melody_box_tools,menu_tools}               → UI custom (wish menus, enchants)
wish_table/wish_table_tier1..5.lua           → tables de récompenses par palier
```

## event_mapgen.lua — le pont data↔Lua
- Importe les types C# par `luanet.import_type` : `PresetMultiTeamSpawner`, `PlaceRandomMobsStep`, `MonsterHouseStep`, `ScriptGenStep`, `MapEffectStep`, `RandomRoomSpawnStep`, `PickerSpawner`, `PresetMultiRand`, `PresetPicker`, `DefaultMapStatusStep`…
- Fonctions `ZONE_GEN_SCRIPT.*` appelées par `ScriptZoneStep` avec `(zoneContext, context, queue, seed, args)` :
  - `MelodyBoxZoneScript` — injection conditionnelle d'un step selon SV.
  - `AddEnchantmentActiveEffects` — MapEffectStep construit en Lua (effets d'étage dynamiques).
  - `EmberfrostSwitchUp` — variation de génération par état de sauvegarde.
  - `ShimmeringZoneStep` — construit un MapStatus custom avec effets par type.
  - `SpawnStoryNpc` — PNJ narratifs DANS le donjon (story mode).
- **Pattern clé : le Lua PRODUIT des GenSteps natifs et les pousse dans la `queue` de génération** — il n'implémente jamais la génération lui-même. La procéduralité reste 100 % RogueElements (seed passé au script = déterminisme conservé).

## beholder.lua — événementiel
`beholder.observe(event, cb)` / `beholder.trigger(event, ...)` : découple les triggers (ramassage wish gem, entrée d'étage) des réactions (menus, VFX, statuts). Évite le couplage dur des callbacks PMDO.

## Mécaniques de combat custom
- Portées par Data/Status + Data/MapStatus JSON, avec events C# natifs référencés dedans ; Lua uniquement quand une décision dynamique est nécessaire (event_battle.lua).
- Rien n'est hardcodé par donjon : `EmberfrostSwitchUp` est le seul script « nommé donjon » et il ne fait que sélectionner de la data.

## Comparaison avec notre projet
| Pattern | DoubleTrio | Nous |
|---|---|---|
| ScriptZoneStep → GenSteps natifs poussés en queue | ✔ | ✔ (rare) |
| pub/sub découplé | beholder | services halcyon (équivalent) |
| Menus custom | services/ | services/ ✔ |
| Tables de récompenses par palier (wish_table_tier1..5) | ✔ | mission_gen (équivalent) |

## À généraliser chez nous
1. `ScriptZoneStep(seed)` comme mécanisme officiel d'étages conditionnels (SV-dépendants) — déterminisme garanti par le seed transmis.
2. Tables de paliers façon wish_table pour les récompenses de fin de donjon.
