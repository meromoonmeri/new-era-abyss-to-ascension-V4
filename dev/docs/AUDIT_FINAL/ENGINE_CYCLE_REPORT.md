# RAPPORT DU CYCLE MOTEUR C# — NewEra.Engine

## 0. Infrastructure (commit `3d36bb3c` + fix lockfile `79b31352`)
Pas de SDK .NET ni NuGet dans la sandbox (réseau restreint à GitHub) → **compilation in-process par le Roslyn du bundle PMDO lui-même** :
- Source : `dev/engine/src/NewEraEngine.cs` (namespace `NewEra.LevelGen`, assembly `NewEra.Engine`).
- Loader : `Data/Script/halcyon/services/engine_loader/init.lua` — compile au BOOT (avant toute désérialisation de zone), cache par hash SHA-256 dans `.runtime-cache/enginelab/`, échec = log fort jamais silencieux. Requis via `services/nre_probe` (main.lua CH1-5 verrouillé intact).
- Les JSON de zones référencent normalement `$type: NewEra.LevelGen.X, NewEra.Engine` — API data standard du moteur.

## 1. Primitives livrées (chaîne ROM → RE existant → gap → C# → data → preuves)

### MonsterHouseRomStep (R4.4 exact + R4.5 pièges POSÉS)
- ROM : mobs = RandRange(70 %,80 % des tuiles libres de la salle), min 1, cap `MobCap×3/2` (GBA 12→18, NDS 30→45) ; items+pièges = max(6, RandRange(50 %,80 %)) cap 7, tirage 50/50 item/piège (pret SpawnEnemies/SpawnNonEnemies ; dungeon-eos l.3161-3218) ; pièges MH gated `dungeon_id>=28` (MH_MIN_TRAP_DUNGEON).
- RE/PMDO existant : `MonsterHouseBaseStep` (data Items/ItemThemes/Mobs/MobThemes réutilisée à l'identique — extension propre, pas un doublon) ; `MonsterHouseStep` ne scalait pas sur la salle et ne posait pas de pièges.
- Le « MobThemeRoomScaled » est intégré : le step force `MobTheme.Amount = RandRange(70-80 % salle)` sur le thème choisi — comportement exact R4.4, espèces/niveaux/distribution inchangés (mêmes MobThemes data).
- Pièges : `Traps` SpawnList dédiée, fallback `map.TileSpawns` (table de pièges de l'étage — même sémantique que la ROM qui résout le flag 0x4 via la trap table de l'étage).
- Déployé : **232 steps / 130 zones ROM** (remplaçant les MonsterHouseStep des SpreadHouseZoneStep).
- Preuves : `monster_house_rom_step_proof.jsonl` — NDS mh 22-27 ; **GBA wish_cave mh=18 = cap 12×3/2 EXACT** ; pièges dans MH (traps avg 15.0 vs 11.8 hors MH).
- **§37 déclenchement réel** (commit `01c85df7`) : leader téléporté dans les Bounds + `Apply` des `MonsterHouseMapEvent` (code moteur identique à CheckIntrudeBounds) → **shimmer_desert 6→39 et 2→37 monstres sur la carte, IA active** (`mh_trigger_runtime_proof.jsonl`). Collision/pathfinding/perfs : le run dprobe complet (10 étages + 2 MH déclenchées à 33-35 mobs) tourne sans erreur ni gel.

### RoomGenMaze (R10)
- ROM : pret GenerateMaze/GenerateMazeLine (serpentins de murs à pas de 2 depuis les bords impairs puis remplissage interne) — porté ligne à ligne.
- RE existant : aucun RoomGen labyrinthe. Gap réel → primitive `RoomGenMaze<T> : PermissiveRoomGen<T>` (dims impaires forcées, ≥5×5).
- Déploiement : **DISPONIBLE mais volontairement NON déployé en masse** — contre-épreuve binaire : la mécanique est DORMANTE dans les DEUX ROMs (GBA guard `unk3A16>=0` pret l.3385 « prevents maze rooms from ever being created » ; NDS `PATCH_APPLIED=0 && maze_value=0` dungeon-eos l.1348). La déployer serait inventer du contenu non canonique. Utilisable par les futurs donjons customs comme composant normal.

### ImperfectRoomStep (R7)
- ROM : pret GenerateRoomImperfections (60 % de chance, grignotage des coins (w+h)/4 itérations, 2 passes horaire/anti-horaire) — porté exactement.
- Même statut : **UNUSED canonique** (GBA roomFlags&0x4 = 0/1764 étages ; Sky generate_imperfect_rooms=false 1795/1795). Primitive disponible, non déployée par fidélité.

### IslandRoomStep (R8 ISLAND) — commit `29510d66`
- ROM : pret GenerateSecondaryStructure case ISLAND (salle ≥6×6 : douve d'eau 6×6, île centrale 2×2 avec items + Warp Tile).
- Gap : PatternTerrainStep (LOT M) couvrait POOL/CHECKERBOARD/DIVIDER/MAZE+DOT mais pas la composition île+loot+warp.
- C# : `IslandRoomStep<T>` (douve peinte autour d'une île 2×2, warp `trap_warp` + items de la table de la zone posés sur l'île).
- Déployé : **134 étages / 11 zones GBA** aux étages `secondaryStructuresBudget>0`, Amount 0-1 (~1 structure sur 6, tirage ROM Rand(6)).
- Preuve : `island_rooms_proof.jsonl` — wish_cave fl2 : île 2×2 items entourée d'eau visible tuile/tuile en ASCII ; 5 îles/48 étages (probabiliste conforme).

### Météo RANDOM (81 étages)
- Contre-épreuve poussée : pret/pmd-sky ne contient pas le code du tirage (non décompilé) ; pmdsky-debug documente l'enum weather_id 0-7 + RANDOM=8 sans table pondérée publique ; dungeon-eos ne modélise pas la météo. **Aucune source binaire n'atteste d'une pondération non uniforme** → le LOT K (DefaultMapStatusStep natif, tirage uniforme seedé parmi les 8 météos 0-7, par étage) reste l'implémentation la plus fidèle documentable, au niveau moteur (pas de Lua). Si une table pondérée est un jour extraite d'overlay29, elle se branchera par data (rates du DefaultMapStatus).

## 2. Différences assumées vs ROM (documentées, jamais silencieuses)
1. La MH ROM répartit monstres/items par flags de tuiles résolus au chargement ; PMDO spawne à l'intrusion (CheckIntrudeBounds) — même résultat gameplay (embuscade), séquence moteur différente.
2. IslandRoomStep pose l'île au centre de la salle (ROM : positions dérivées du RNG de salle) — positionnel, non observable statistiquement.
3. RoomGenMaze/ImperfectRoomStep : fidèles à l'algo mais non déployés (mécaniques mortes dans les ROMs).

## 3. Performances
- Compilation Roslyn : ~2-4 s au premier boot, 0 s ensuite (cache par hash).
- Génération : dprobe 10 étages + MH 33-35 mobs déclenchées sans latence anormale ni fuite (process stable sur runs successifs).

## 4. Non-régression
- GLOBAL_JOURNEY_PASS après déploiement MonsterHouseRomStep (commit 3d36bb3c) et re-vérifié post-K/L/M/N (`journey_post_klmn_proof.jsonl`).
- Lockfile CH1-5 : INTÉGRITÉ OK sur tous les commits du cycle (le fix 79b31352 a corrigé la seule violation détectée — main.lua restauré à l'octet).

## 5. Limites restantes
- Secret Bazaar PNJ (salles secrètes) : hors périmètre moteur — prochaine étape.
- Table météo RANDOM pondérée : si extraite d'overlay29 un jour → data.
