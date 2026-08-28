# DOUBLETRIO — ANALYSE DE GÉNÉRATION PAR DONJON

## 1. Wishmaker Cave (`wishmaker_cave.json`, 1.1 Mo)
- Zone : Level 10, TeamSize 2, BagRestrict 2 (roguelocke), MoneyRestrict, KeepSkills, Rogue=3.
- seg0 LayeredSegment **27 étages / 35 ZoneSteps** ; seg1 SingularSegment (final).
- Répartition des étages : **17 GridFloorGen** (procéduraux) + **10 RoomFloorGen** (étages 5–14 : zone wish/évolution, semi-fixes).
- RoomGens utilisés (ce seul donjon) : Cave 27, AngledHall 38, Diamond 10, Round 10, Oasis 10, Blocked 7, Square 5, LoadMap 5, Evo 2, Default 3 → **aucun étage n'a la même « texture » de salles**.
- Paths : GridPathCross 5, GridPathBranch 5, GridPathCircle 7 + ConnectGridBranchStep 10 (boucles 75 %) + AddConnectedRoomsStep (freeform).
- ZoneSteps notables :
  - 2× SpreadHouseZoneStep (MH avec items thème « gummi_wonder » Rate 4, plage 0–30, Amount mobs 7–13).
  - 18× SpreadStepZoneStep priorité 6.1, chacun = `RandomSpawnStep<EffectTile>` d'UN type de piège.
  - 3× SpreadRoomZoneStep `RoomGenLoadMap` (wish rooms préfab .rsmap) + 1× `RoomGenEvo` (chambre évolution, « every 3-4 floors »).
  - SpreadStepRangeZoneStep : ShopStep (Kecleon) ; `AddConnectedRoomsStep` Amount 1–2 en priorité -2.2 sur plage → densification topologique en profondeur.
  - 2× ScriptZoneStep (Lua : PNJ story, effets).

## 2. Emberfrost Depths (`emberfrost_depths.json`, 3.7 Mo) — LE plus complexe
- **14 segments** : 4 SingularSegment (hubs/boss), 6 LayeredSegment (30+9+15+30+9+10 étages), 4 **RangeDictSegment** (étages uniques à position précise : boss/événements).
- Modèle « donjon-campagne » : segments = biomes (blaze/frost/cove/forest/rocky/elemental — cf. les 6 grounds checkpoints), avec checkpoints .rsground entre segments.
- Enseignement : la structure Segments de RogueEssence supporte des donjons multi-biomes de 100+ étages avec hubs — sans aucun code custom.

## 3. Adventurers Peak (`adventurers_peak.json`)
- Level 50, TeamSize -1 (illimité), Rogue=1 ; 24 + 5 étages, 2 SingularSegment.
- Donjon endgame « liberté d'équipe » (README Terrasphere) : mêmes primitives, restrictions différentes → la difficulté est portée par la DATA de zone, pas par du code.

## 4. Boss : 17 rsmap dédiées
`alakazam_boss, cursed_treasure_boss, dark_boss, fossil_boss, ice_boss, large_bug_boss, perfect_accuracy_boss, perish_song_boss, pharaoh_boss, pirate_boss, sand_team_boss, snorlax_boss, spooky_ghost_boss, sun_boss, swift_swim_boss, telapathy_boss + team_ember` — noms = GIMMICK du combat (précision parfaite, perish song, sable...). Chaque boss est un PUZZLE mécanique, pas juste des stats. Injection via RoomGenLoadBoss/SingularSegment.

## 5. Classification globale
| Élément | Classe |
|---|---|
| Layout étages standard | PROCÉDURAL (grid/paths/roomgens variés) |
| Étages 5–14 Wishmaker | SEMI-PROCÉDURAL (prefab + AddConnectedRooms) |
| Wish rooms, boss rooms | FIXE (rsmap) injecté procéduralement |
| Pièges | PARAMÉTRÉ (18 spread steps probabilisés) |
| Monster Houses | PARAMÉTRÉ (SpreadHouse par plage) |
| Wish crystals, menus, PNJ | SCRIPTÉ (Lua + beholder) |
| Kecleon | PARAMÉTRÉ (ShopStep sur plages) |
| Récompenses spatiales | PROCÉDURAL INTENTIONNEL (Terminal/Due/TerrainSpawn) |
