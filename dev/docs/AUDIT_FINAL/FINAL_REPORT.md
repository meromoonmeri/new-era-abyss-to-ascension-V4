# AUDIT_FINAL — MODERNISATION DU SYSTÈME DE DONJONS (RAPPORT FINAL)

Branche `arena/01a0357e-new-era-abyss-to-ascension-v4`. Base d'audit : `dev/docs/AUDIT_PRE_MODIFICATION/` (14 livrables, commit `9d4abca1`). Ce rapport couvre l'implémentation des lots de `MODERN_DUNGEON_RECIPE.md` et leurs preuves.

## 1. Lots implémentés (tout est data + primitives natives, zéro hack par-donjon)

### LOT A — Structures exotiques Sky (R6) — commit `b8d87595`
- Outil : `dev/tools/fix_sky_exotic_structures.py` ; rapport `SKY_EXOTIC_STRUCTURE_FIX_REPORT.json`.
- 73 étages / 15 zones : `structure` mappa_s → path RogueElements exact :
  RING→GridPathCircle (grille 6×4 EoS), CROSSROADS/CROSS→GridPathCross (5×4 / 3×3), BETTLE→GridPathBeetle PMDC (3×3, colonne géante fusionnée = GiantHallGen, Vertical=false conformément à generate_beetle/merge_rooms), LINE→grille 5×1.
- Justification binaire : dungeon-eos (portage 1:1 du générateur EoS, adresses US) : generate_ring/crossroads/cross/beetle/room_line.
- RoomGens/Halls/Components de l'étage CONSERVÉS (seul le path change).
- Preuve runtime : dumps ASCII dprobe — chasm_cave fl0 LINE (1 rangée), fl1 CROSSROADS (croix), apple_woods fl7 RING, fl8 CROSS visibles tuile par tuile. 1 étage non transformé : apple_woods fl7 déjà non-branch (note au rapport).

### LOT B — Monster Houses canoniques (R4.4) — commit `ec1e31e7`
- Outil : `dev/tools/fix_monster_house_amounts.py` ; rapport `MONSTER_HOUSE_AMOUNT_FIX_REPORT.json`.
- Loi ROM : N = RandRange(70 %, 80 % des tuiles de la salle), caps : GBA 12×3/2=18 (pret dungeon_config.c l.22), NDS 30×3/2=45 (dungeon-eos l.64 MH_NORMAL_SPAWN_ENM=30, l.3355 ×3/2).
- Approximation data phase 1 (MobThemeNone.Amount ne dépend pas de la salle) fondée sur la distribution mesurée des salles (4492 salles, P25=30/P75=42 tuiles) : Sky 21–33, GBA 14–18. 226 occurrences / 122 zones ROM. Amounts 2–4 (houses spéciales) intacts ; zones customs intactes ; CH1–CH5 exclues.
- Preuve runtime : `dev/docs/canonical/sky/monster_house_canonical_proof.jsonl` — MH en attente de 24, 28, 31, 32 mobs (>>10, conforme §18/§37 ; cap 45 respecté). Le dprobe lit désormais `CheckIntrudeBoundsEvent→MonsterHouseMapEvent.Mobs`.

### LOT C — Mystery Floors / hidden stairs Sky (R11) — commit `369d7cf1`
- Outil : `dev/tools/add_hidden_stairs_sky.py` ; rapport `HIDDEN_STAIRS_SKY_REPORT.json`.
- 430 étages / 34 zones : `hidden_stairs_spawn_chance` mappa_s (% par étage) → `RandomRoomSpawnStep<EffectTile>` SuccessPercent=chance ROM, tuile vanilla `stairs_secret_down` **Revealed=false** + DestState absolu vers un **segment « salles secrètes »** ajouté (1 étage par étage éligible : grille 2×2, 0 ennemi, items ×3 + argent, nom « Salle Secrète », sortie → étage suivant du segment principal via DestState, dernier étage → EndSegment Cleared). `index.idx` (ZoneEntrySummary.Maps) mis à jour pour les 34 segments.
- Mécanique 100 % vanilla (pattern faded_trail). Statut : probabilités et flux EXACTS ; contenu de salle PORTED_APPROXIMATED (Secret Bazaar PNJ non porté — documenté).
- Preuve runtime : `hidden_stairs_runtime_proof.jsonl` — 16 salles secrètes générées/jouées (0 mob, 1–7 items), plus d'erreur `Invalid Segment ID`.

### LOT D — Sticky items Sky (R12) — commit `431bf369`
- Outil : `dev/tools/fix_sticky_item_chance.py` ; rapport `STICKY_ITEM_FIX_REPORT.json`.
- 3813 entrées d'items dédoublées (`Cursed=true` au taux S%, `rate_cursed = rate*S//100`, somme des rates préservée → distribution d'espèces INCHANGÉE) dans les 36/36 zones mappées dont la ROM a sticky>0. Contrôle : bottomless_sea 6,81 % vs 7 % ROM (écart = arrondi entier, documenté). Shops (Price>0) et argent exclus.

### LOT E — Kecleon shops Sky (R5) — commit `3e5b73df`
- Outil : `dev/tools/add_kecleon_shops_sky.py` ; rapport `KECLEON_SHOP_SKY_REPORT.json`.
- 171 plages / 65 zones : `kecleon_shop_chance` mappa_s par plages contiguës de même % → `SpreadStepRangeZoneStep<ShopStep>` (modèle buried_relic exact : Kecleon shopkeeper MobSpawnBoost 256/color_change/shop_security). Items du shop = table ROM de l'étage médian de la plage (poids /10000 décumulés), mappés via PMDO_MAPPING (EXACT/RENAMED/TM) ; 67 espèces REQUIRES_MOD_ITEM exclues et comptées (cohérent ZONE_FIX_REPORT).
- Preuve runtime : `kecleon_shop_runtime_proof.jsonl` — 9/120 étages avec Kecleon (7,5 % observé vs 8–10 % ROM apple_woods/waterfall_cave, binôme conforme). Exclusivité MH gérée nativement par le moteur.


### LOT F' — Items des Monster Houses (R4.5 volet items) — commit `f893b4cb`
- Outil : `dev/tools/fix_monster_house_items.py` ; rapport `MONSTER_HOUSE_ITEMS_FIX_REPORT.json`.
- 146 SpreadHouseZoneStep / 90 zones Sky : `Items` = table ROM `items['monster_house']` de l'étage médian (poids /10000 décumulés, REQUIRES_MOD exclus), `ItemThemeNone.SpecialRatio=100` (items MH exclusivement issus de la table ROM comme EoS), `Amount` 6–7 (loi ROM min 6 / cap MH_NORMAL_SPAWN_ITEM=7, dungeon-eos l.3191-3197).
- Régression attrapée par le protocole : `SpawnRangeList` exige `Range.Length>=1` (RogueElements l.49) → 8205 entrées corrigées (Range=FloorRange du SpreadPlan) + outil durci ; audit global : 0 entrée Range<=0 sur les 260 zones.
- Preuve runtime : `monster_house_items_proof.jsonl` (MH 23–32 mobs, zones rechargées sans erreur) + **GLOBAL_JOURNEY_PASS re-confirmé** (14ch/313 étages, `journey_post_mh_items_proof.jsonl`).
- Volet pièges 50/50 : reste PARTIAL (MonsterHouseStep PMDO ne pose pas de pièges — primitive C# au cycle moteur).

### LOT E-GBA — Kecleon Red vs ROM (R5) — commit `37864e39`
- Outil : `dev/tools/audit_kecleon_gba_vs_rom.py` (audit + --fix) ; rapport `KECLEON_GBA_VS_ROM_AUDIT.json`.
- Contre-épreuve exhaustive kecleonShopChance (FloorProperties offset 7, stream main_data.inc/28) sur les 51 donjons mappés : **25 PASS**, **25 EXTRA_INHERITED_PORT** (ShopStep du port d'origine avec chance ROM=0 — conservés §62, documentés), **mt_blaze FIXED** (chances ROM 6-10 % par étage + table KecleonShop ROM de dungeon_item_data.json mappée via convert_item). Preuve runtime : `red/kecleon_mt_blaze_proof.jsonl` (3 étages Kecleon ≈ 5 % vs 6-10 % ROM).

### LOT G' — Impasses canoniques Sky (R9 dead_ends) — commit `a3946568`
- Outil : `dev/tools/fix_dead_ends_sky.py` ; rapport `DEAD_ENDS_SKY_FIX_REPORT.json`.
- Loi EoS (dungeon-eos create_connections l.507) : dead_end=1 ⇒ impasses CONSERVÉES. 707 ConnectGridBranchStep 100→0 sur les étages `dead_ends=true` (114 zones). Preuve : 80/80 étages régénérés avec escalier accessible (DetectIsolatedStairsStep protège), 0 layout dupliqué.

### LOT H' — Météo par étage Sky (§31) — commit `fecc312e`
- Outil : `dev/tools/fix_weather_sky.py` ; rapport `WEATHER_SKY_FIX_REPORT.json`.
- 139 étages / 31 zones : `weather` mappa_s → `DefaultMapStatusStep(default_weather,[fog/cloudy/sunny/rain/sandstorm/snow])` (pattern vanilla barren_tundra). Preuve runtime : `weather_per_floor_proof.jsonl` — blizzard_island : `map_status=default_weather,snow` EXACTEMENT aux étages 4 et 8 (= mappa_s), les autres étages restent clear. RANDOM (81 étages) : UNIMPLEMENTED_DATA documenté (tirage météo EoS = step à créer au cycle moteur).
- GLOBAL_JOURNEY_PASS re-confirmé après G'+H' (14ch/313 étages/870 mobs).


### LOT I — Aires de repos NDS dXXp21a + statues Kangourex — commit `d686fc71`
- 27 grounds convertis pixel-perfect (convert_sky_all : BMA/BPC/BPL skytemple, collision source) puis promus (`promote_sky_rest_grounds.py` : AssetName, sheets D*_Base, EdgeView 1, noms FR canoniques GROUP_NAMES, marker entrée).
- **27 statues Kangourex posées** (placements SSA enter.sse 1:1 pixels, modèle GroundObject d06p11a exact) → **57/57 statues ROM posées au total**.
- Enregistrés dans sky_hub_zone.GroundMaps + index. Preuve runtime : `rest_grounds_runtime_proof.jsonl` — **27/27 LOAD+MOVEMENT_PASS**.
- Suite documentée : câblage des aires dans la progression des zones donjon (checkpoint mi-parcours type Mt Horn 6F) — nécessite le mapping étage→ground par donjon (scripts ROM), étape séparée.

## 2. Outillage nouveau (§16 ASCII + stats)
- `dprobe` étendu (validator Lua) : dumps **ASCII tuile/tuile** (murs/sol/eau/lave/gouffre/escaliers `>`/pièges `^`/items `$`/mobs `M`), répétitions **multi-seed** (`PMDO_DPROBE_REPS`, reseed ReRandom), comptage **MH en attente** (`mh_mobs`), **shopkeepers** (`neutrals`), cible `zone@segment`, clamp FloorCount.
- `dev/tools/analyze_dungeon_generation_stats.py` : stats §36 (min/max/moy mobs/items/traps, hash structurel des layouts, détection identiques/quasi-identiques ≥98 %).

## 3. Résultats statistiques (§17/§19/§36)
- Baseline : 400 étages multi-seed → **0 layout identique, 0 quasi-identique** ; densités conformes aux formules R3 (`GENERATION_STATS_BASELINE.md`, `dungeon_generation_statistics.json`).
- Post-LOT A : layouts exotiques régénérés et variés (ASCII preuves) ; post-LOT B/E : preuves MH/Kecleon ci-dessus.

## 4. Checklist finale (§44) — état
- RNG reproductible : PASS (ReRandom/FirstSeed, multi-seed prouvé).
- Étages réellement variés : PASS (0/400 doublons).
- Salles irrégulières : PASS (Cave/Cross/Blocked/Bump/Diamond en pool + imperfections ROM restant PARTIAL, cf. §5).
- Topologies complexes : PASS (Branch/Circle/Cross/Beetle/boucles ConnectGridBranch).
- MH >10 Pokémon : PASS (24–32 mesurés, cap canonique).
- Pièges réellement placés : PASS (baseline dprobe, plages R3.3).
- Kecleon probabilisé : PASS (7,5 % vs 8–10 % ROM).
- Mystery Floors : PASS mécanique (probas+flux ROM) / PARTIAL contenu (Bazaar).
- Aucun DEV_ONLY requis : PASS (Dusk Forest élucidé — zone réelle CH15, runtime normal).
- Non-régression : lockfile CH1–CH5 OK à chaque commit ; skyjourney complet relancé (résultat consigné dans runtime_audit.json).

## 4bis. Régression détectée ET corrigée par le protocole §41 (preuve que la non-régression fonctionne)
- Skyjourney post-lots : **FAIL CH10 « boss manectric absent »** (amp_clearing). Cause racine : `add_kecleon_shops_sky`/`add_hidden_stairs_sky` avaient injecté leurs steps dans des segments **LoadGen** (arènes boss rsmap fixes : amp_clearing, crystal_lake — canoniquement des fixed floors ROM, PAS des étages procéduraux : un ShopStep/escalier caché n'y a pas de sens et perturbe le chargement).
- Fix commit `01a7d59c` : revert des 2 zones à l'état `15edd49c` (vérifié : LOT B ne les touchait pas), restauration `index.idx`, **garde-fou générique SKIP_LOADGEN_BOSS** ajouté aux deux outils (rejouables sans risque), rapports annotés `REVERTED_LOADGEN_BOSS`.
- Skyjourney relancé intégralement après fix (verdict consigné dans runtime_audit.json).

## 5. Restes documentés (jamais supprimés silencieusement)
État après lots E-GBA/F'/G'/H' : R4.5-items TRAITÉ (LOT F'), R5-GBA TRAITÉ (audit+mt_blaze), R9-dead_ends TRAITÉ (LOT G'), météo fixe TRAITÉE (LOT H'). Restent :
1. R7 imperfections / R10 RoomGenMaze / R8 ISLAND composé : PARTIAL — nécessitent des primitives C# nouvelles (RoomGenImperfect/RoomGenMaze) ; le bundle headless actuel ne compile pas PMDC → à faire lors d'un cycle moteur (documenté, aucune donnée perdue).
2. MobThemeRoomScaled (MH ∝ salle exacte) : approximation data en place ; primitive C# au même cycle moteur.
3. Secret Bazaar (PNJ Sky) dans les salles secrètes : PORTED_APPROXIMATED.
4. R4.5 items+pièges 50/50 dans MH : les HouseStepSpawns actuels portent les items thématiques ; l'ajout des pièges MH reste à brancher (données prêtes dans mappa items['monster_house']).
