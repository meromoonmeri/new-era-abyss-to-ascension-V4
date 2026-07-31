# Crédits — New Era: Abyss to Ascension

## Projet de base
- **Halcyon** par [Palikadude](https://github.com/Palikadude/Halcyon) — base du mod
- **PMDO** par [audinowho](https://github.com/audinowho) — moteur RogueEssence / PMDC
- **RogueCollab** — [RogueEssence](https://github.com/RogueCollab/RogueEssence), [RogueElements](https://github.com/rogueessence/RogueElements), [PMDC](https://github.com/PMDCollab/PMDC)
- **PMDODump** / **DumpAsset** — contenu dumpé du jeu officiel

## Packs intégrés

### Mega_Stones
- **Auteur** : [Deeshura](https://github.com/Deeshura/Mega_Stones)
- **Description** : Système de Méga-Évolution pour PMDO
- **Contenu repris** : scripts Lua (`Data/Script/megastones/`), tileset `shady_shop.tile`, ground map, zone, musique `Shady Shop.ogg`
- **Crédits additionnels** : icônes d'objets par Ryveriel ; contributions de Trio-, FlowerSnek, Palika, Sh*tpost Sunkern, MistressNebula

### ZMDO (Zorua Mystery Dungeon Origins)
- **Auteur** : [RaoKurai](https://github.com/RaoKurai/ZMDO)
- **Description** : Démo de mod PMDO (thème Zorua)
- **Contenu repris** : tilesets `CrystalEntrance`, `CrystalExit`, `GardenEnd`, `MysteryEntrance`, `MysteryExit` (préfixés `ZMDO_`)

### Trio's Dungeon Pack
- **Auteur** : [DoubleTrio](https://github.com/DoubleTrio/dungeon-pack)
- **Description** : Pack de donjons + outillage Python
- **Contenu repris** : scripts Python d'outillage (`tools/dungeon_pack/`)
- **Note** : certains graphismes proviennent de craftpix.net (vérifier licence avant réutilisation directe)

### rogue-rescue-team (décompilation Rescue Team)
- **Auteur** : [jtjanecek](https://github.com/jtjanecek/rogue-rescue-team), d'après [pret/pmd-red](https://github.com/pret/pmd-red)
- **Description** : décompilation de Pokémon Mystery Dungeon: Red Rescue Team
- **Contenu repris** : données de donjon (nombre d'étages, bestiaire, niveaux, probabilités d'apparition) de 52 donjons, converties au format PMDO par `tools/convert_rescue_team.py`
- **Non repris** : la géométrie d'étage (`main_data.inc`, octets bruts GBA non documentés) — remplacée par la génération native RogueElements
- **Autorisation** : accordée par le porteur du projet New Era

### ProjectEoN
- **Auteur** : [Logical321](https://github.com/Logical321/ProjectEoN)
- **Description** : fangame PMDO
- **Contenu repris** : donjons jouables au format PMDO natif et leurs arènes de boss
- **Autorisation** : accordée par le porteur du projet New Era

### ExplorersOfSkyOrigins
- **Auteur** : [Minemaker0430 / ItsMochaTheOtter](https://github.com/Minemaker0430/ExplorersOfSkyOrigins)
- **Contributeurs cités par le dépôt** : Sloth (ground maps, musique), servantofTestator (cinématiques), Palika (shaders, objets, scripts), MistressNebula (framework du système de missions), BobTheBobCatt (objets)
- **Description** : remake d'Explorers of Sky sous PMDO, ciblant la même GameVersion 0.8.12 que New Era
- **Contenu repris** : hub de Treasure Town — la place du bourg (18 PNJ canoniques placés), le Café Spinda, les trois carrefours, la plage jour/crépuscule, le dojo Ossatueur et son labyrinthe, la source chaude, la falaise Sharpedo, et l'intérieur complet de la guilde Grodoudou (entrée, salle des tableaux de missions, réfectoire, chambres, quartiers du maître, versions jour et nuit) ; les tilesets correspondants
- **Note** : cartes renommées avec le préfixe `tt_` pour ne pas entrer en collision avec les cartes propres de New Era (`guild_second_floor`, `metano_cafe`, `ledian_dojo` sont des créations du projet, pas des reprises)

### PMDO-Explorers-Maps
- **Auteur** : [slothplaysnecro](https://github.com/slothplaysnecro/PMDO-Explorers-Maps)
- **Description** : cartes d'Explorers of Sky importées et prêtes à l'emploi sous PMDO
- **Licence** : le dépôt autorise explicitement la réutilisation — « Feel free to use these in your own projects »
- **Contenu repris** : ground `treasure_town.rsground`, tilesets `TreasureTownEast` / `TreasureTownWest`
- **Crédits amont** : assets initialement issus d'[ExplorersOfSkyOrigins](https://github.com/Minemaker0430/ExplorersOfSkyOrigins)

### Project EoN
- **Auteur** : [Logical321](https://github.com/Logical321/ProjectEoN)
- **Description** : Fangame PMDO (non terminé)
- **Contenu repris** : tilesets sélectionnés pour biomes variés (DrenchedBluff, CrumblingCanyon, Mt Cleft, ForestDark, Cloudless, IntroRoad, IntroStormy, HedgeHides, BanditStealing, Dininghall, Guild) — préfixés `EoN_`
- **Note** : projet inachevé — contenu original vs rip officiel à documenter plus finement

### Resource Dungeon Pack (Imbion)
- **Auteur** : Imbion
- **Source** : [Codeberg](https://codeberg.org/Imbion/pmdoResourceDungeons) / [GameBanana #618475](https://gamebanana.com/mods/618475)
- **Licence** : CC BY-NC-ND 4.0 (pas de modification autorisée)
- **Contenu repris** : 7 zones (ashen_geode, berry_grove, coven_cave, gourmet_jungle, grainy_pasture, haunted_bazar, sentient_workshop), tileset Ashen Geode, 4 musiques, scripts
- **Fichiers** : préfixés `imbion_` dans Data/Zone/, `Imbion_` dans Content/Tile/

### Knightcore (Imbion)
- **Auteur** : Imbion
- **Source** : [GameBanana #623115](https://gamebanana.com/mods/623115)
- **Statut** : ❌ repo Codeberg inaccessible (authentification requise) — non intégré

### Friend Area Pack (Google Drive)
- **Source** : https://drive.google.com/drive/folders/1_MeXe1XD_wTxxBCYx1GluDYeV9uvLV7U
- **Statut** : ❌ inaccessible depuis le sandbox — à télécharger manuellement et intégrer

## Musiques
- `Team_Dazzling.ogg` — thème original de l'équipe Team Dazzling (Sucreine/Lockpin/Magiréve)

## Agents de développement
- Agent Arena.ai — développement scripts, maps, dialogues, correctifs (V4.5.1+)

## Direction musicale (2026-08-01)

Aucune piste externe n'a été ajoutée. `Data/Script/halcyon/BossMusic.lua`
**redistribue** les musiques déjà embarquées et déjà créditées ci-dessus :
48 arènes de gardiens sur 49 jouaient le même `Boss Battle!.ogg`, et
14 pistes n'étaient jamais jouées. La table attribue désormais 12 thèmes
distincts selon sept registres (cosmique, ciel, ombre, nature, tellurique,
machine, épreuve).

**Note de licence** — les remixes de chaînes YouTube (type GlitchxCity) ont
été écartés volontairement : un remixeur ne détient pas les droits de
l'œuvre d'origine et ne peut donc pas en autoriser la redistribution dans
un mod. Toute piste future doit venir d'un auteur autorisant explicitement
l'usage en fangame, et être créditée ici avec sa licence.
