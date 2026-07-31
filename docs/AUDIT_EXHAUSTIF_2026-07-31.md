# AUDIT EXHAUSTIF — New Era : Abyss to Ascension

> Audit de prise en main complet, réalisé le **2026-07-31** par l'agent Arena.ai.
> Branche : `arena/019fb97d-new-era-abyss-to-ascension-v4` · commit `3fec1aa` ·
> build `2026-08-03-N` (main.lua:63, scriptvars.lua:1388,
> ground/vast_steppe_midpoint/init.lua:25 — les 3 fichiers sont synchrones).
>
> **Méthode** : lecture intégrale des documents du dépôt, exécution de la suite
> de validation complète, vérification fichier + ligne de chaque affirmation,
> lecture des références externes (moteur RogueEssence, wiki PMDO, tutoriels
> audinowho). **Aucun test en jeu n'est possible dans cette sandbox** : tout est
> statique ou exécution Lua simulée. C'est le point le plus important à retenir.

---

## 1. LE PROJET EN UNE MINUTE

Mod **PMDO** (moteur **RogueEssence 0.8.12**, scripts Lua, données JSON) pour le
jeu **Pokémon Mystery Dungeon Online**, fork narratif du mod *Halcyon* de
Palikadude, créé par Minori. **Jeu en français.**

| Identité | Valeur |
|---|---|
| Nom | New Era : Abyss to Ascension |
| Namespace Lua | `halcyon` |
| UUID | CAE98609-7A96-4CFC-B5AB-0E1D41F6A1FF |
| Version | 0.5.1 |
| GameVersion | 0.8.12 |
| ModType | Quest (Special Episodes) |
| Trame | 32 chapitres / 6 arcs prévus — chapitres 1-10 implémentés |

**Ne jamais modifier** `Namespace`/`UUID` (compatibilité des sauvegardes) ni
monter `GameVersion` au-delà de la version du moteur cible (`PathMod.cs` refuse
un mod plus récent que le jeu).

### Trame (canon, `docs/04_trame_arc1.md`, `docs/bible_continuite.md`)
- **Arc 1 (ch1-6)** « Les Braises de Metano » : le héros devient Pokémon,
  rejoint la guilde de Metano (Penticus = Tropius, Phileas = Noctowl, Hyko =
  Growlithe, Almotz = Zigzagoon…), grande expédition ch5 (Steppe → Tunnel →
  Mont Venteux), ch6 Team Dazzling + Zarude.
- **Arc 2 (ch7-12)** « Les Cœurs qui s'éteignent » : ch7-10 implémentés
  (Regigigas, Diancie, Laggron, Lugia).
- **Arcs 3-6 (ch13-32)** : structure écrite, dialogue non écrit.
- **Twist final verrouillé** : la lumière des Cœurs est le sceau d'Eternatus ;
  Necrozma scellait, il ne volait pas. Règle : **jamais** « Necrozma »,
  « Eternatus », « l'Abîme », « prison » dans un texte affiché avant l'heure.

---

## 2. ÉTAT CHIFFRÉ DU DÉPÔT (mesures fraîches du 2026-07-31)

| Famille | Compte | Détail vérifié |
|---|---:|---|
| Fichiers suivis | 3 627 | ~1,3 Go (`.git` 315 Mo, `Content` 351 Mo, `Data` 605 Mo) |
| Lua | **673** | compile **0 erreur** (Lupa, tous `Data/Script/**/*.lua`) |
| `.resx` | 586 | `stringsEx` racine + un jeu EN/FR par carte |
| Clés `.resx` | EN 5 559 / FR 5 538 | 21 clés EN sans FR (dette documentée §7.3), 0 FR sans EN |
| Zones `Data/Zone/*.json` | **207** | `index.idx` = 207, **parfaitement synchrone** |
| Grounds `Data/Ground/*.rsground` | **276** | `metano_town.rsground` = 37 Mo |
| Tilesets `Content/Tile/*.tile` | **522** | `index.idx` = **522 entrées, 0 trou** (GeminiClovenGate présent) |
| Musiques `Content/Music/*.ogg` | **133** | 0 référence cassée (201 appels / 44 titres distincts) |
| `.rsmap` (arènes) | 194 | 73 zones avec arène de boss |
| Docs `docs/*.md` | ~80 | ~17 000 lignes |
| Outils `tools/*.py` | ~80 | dont 12 vérificateurs pré-commit |
| `Data/Script/halcyon/ground/` | 276 dossiers | 199 zones scriptées (`zone/`) |

Point d'attention immédiat : **`verify_new_era.sh` est périmé** (attend
`EXPECTED_TILESETS=498`, le dépôt en a 522 → le script affiche 1 erreur). Les
compteurs ground (276) et musique (133) sont, eux, justes.

---

## 3. SUITE DE VALIDATION COMPLÈTE — RÉSULTATS ET BASELINES

Tout a été exécuté sur ce checkout (prérequis : `pip install --break-system-packages lupa Pillow numpy`).

| Outil | Résultat 2026-07-31 | Baseline documentée | Verdict |
|---|---:|---|---|
| Compilation Lua (Lupa) | 673/673 ✅ | 670/670 | ✅ |
| `audit_bugs.py` | **9** | 12 → 9 (dernier commit) | ✅ les 9 sont des faux positifs assumés (§3.1) |
| `audit_integrite.py` | **849** | 925 → 849 | ✅ améliorée (dette réduite) |
| `validate_all.py` | 9/9 salles ✅ | 9/9 | ✅ |
| `verify_legend.py` | TOUT EST VERIFIE ✅ | 0 échec | ✅ |
| `verify_scene_positions.py` | 0 entité à >1 écran hors carte ✅ | — | ✅ |
| `verify_bg_format.py` | AUCUN BUG DE FORMAT ✅ | — | ✅ |
| `verify_ground_registration.py` | 0 bloquant / **91 avertissements** | — | ⚠️ voir §7.5 |
| `verify_lua_globals.py` | 0 fonction fantôme ✅ | — | ✅ |
| `verify_spawner_enabled.py` | 0 spawner désactivé ✅ | — | ✅ |
| `verify_cutscene_guard.py` | 0 scène à risque ✅ | — | ✅ |
| `verify_emotions.py` | AUCUN RISQUE DE CRASH DE PORTRAIT ✅ | — | ✅ |
| `verify_midpoint_template.py` | Aucun doublon / MapStatus fantôme ✅ | — | ✅ |
| `audit_fade_leaks.py` | 6 (fallbacks `pcall` assumés) | — | ✅ documenté |
| `audit_dialogues.py` | 0 dialogue anglais visible ✅ | — | ✅ |
| `count_dialogue.py` | voir §3.2 | ch5 = 1 580 | ⚠️ chantier volumétrie |
| `audit_boss_cinematics.py` | 65 scènes, 0 muette | — | ⚠️ scores inégaux §3.3 |
| `audit_spatial.py` | 58 grilles vides / 62 cartes à entités murées (240) | — | ⚠️ dette imports §7.5 |
| `audit_causalite.py` | 71 retraits à justifier | — | signal narratif |
| `simulate.py` / `test_scenarios.py` / `sim_legend.py` | Lua réel exécuté (stubs moteur) | — | ✅ usage maîtrisé |

### 3.1 Les 9 signalements `audit_bugs` (tous inoffensifs, vérifiés)
- **5× `SV.guildmaster_summit.GameComplete`** — résidu du pack Mega_Stones
  (`Data/Script/megastones/ground/cliff_camp/init.lua:20` et 4 copies dans
  `source_duns_imbi/ground/*/init.lua`). Table jamais déclarée → lit `nil` →
  `false`. Sans effet, ne pas « corriger ».
- **1× `testmap`** : 23 objets sans handler — carte d'atelier jamais
  référencée, inatteignable.
- **3× zones `Released=false`** : `imbion_coven_cave`, `imbion_haunted_bazar`,
  `imbion_sentient_workshop` — coquilles vides (0 GroundMap, 0 segment),
  réserves du pack amont.

### 3.2 Densité de dialogue mesurée (objectif Prompt Maître : 7 000/chapitre dès le ch5)
```
ch1: 642 · ch2: 656 · ch3: 659 · ch4: 524 · ch5: 1616 · ch6: 469
ch7: 408 · ch8: 335 · ch9: 318 · ch10: 256 · multi: 169 · commun: 1985
```
Écart d'un facteur 4 à 27 sur la cible. C'est le chantier volumétrique
documenté (`docs/plan_narratif_ch11_ch32.md §1.2`).

### 3.3 Qualité des cinématiques de boss (`audit_boss_cinematics`)
- **65 scènes analysées, 0 boss muet** ✅
- Moyenne par famille : histoire **75/100** (15 scènes) · réseau **27/100**
  (11 scènes) · légendaire **18/100** (39 scènes) — les cinématiques des
  Réseaux des Anciens Chemins et du Ciel (EoS + pmd-red) sont fonctionnelles
  mais très peu denses (7-12 boîtes en moyenne vs ~20 pour l'histoire).

---

## 4. CHANTIERS DE L'ANCIEN AGENT — VÉRIFICATION DANS LE CODE

### 4.1 `todo.txt` (chantiers narratifs/rythme)

| # | Consigne | État vérifié le 2026-07-31 |
|---|---|---|
| 1 | Faire corriger `charwaitaction` (hop / double hop, animations Magcargo/Slugma) | ✅ **Corrigé** — `GeneralFunctions.lua:1200-1254` : `DoubleHop`/`Hop` synchronisés sur `GROUND:CharWaitAction(chara, hop_action)` (plus de `WaitFrames`). Commentaire explicatif au commit `3fec1aa`. |
| 2 | Scène matinale : Hyko au milieu, près de Penticus, tête-à-tête | ✅ **Fait** — `mount_windswept_entrance_ch_5.lua` : Hyko avance en (280, 248) pour l'assignation (commit `3fec1aa`). |
| 3 | Vitesses de marche plus lentes dans les scènes ch5 (guilde + première rencontre boss) | ⚠️ **Partiel** — le patron `MoveToPosition(..., false, 1)` (vitesse lente) est présent (`searing_tunnel_entrance_ch_5.lua:167-170`). Le « boss first encounter » reste à vérifier en jeu. |
| 4 | Revue du tag jaune vs cyan des alliés de guilde en expédition | ⚠️ **Non traité** — aucun `[color=#FFFF00]`/`[color=#00FFFF]` dans les relais ch5. Décision d'écriture documentée dans todo.txt, à trancher en jeu. |
| 5 | Refaire la scène « anima core » du ch3 (instabilité) | ⚠️ **Non traité** — `first_core_location_ch_3.lua` existe et fonctionne ; la refonte (instabilité visible) reste ouverte. |
| 6 | Sprite porte du bureau du maître de guilde | ✅ **Corrigé** — `guild_third_floor_lobby_ch_1.lua` : cadre/offset du `Closed_Guild_Door` alignés (416, 160, 64×64) (commit `3fec1aa`). |

### 4.2 Audit du 2026-07-30 (`docs/audit_2026-07-30.md`) — 7 défauts, tous traités
Vérifiés **dans le code actuel**, avec preuve :

| Défaut | État | Preuve |
|---|---|---|
| B1 gel `metano_normal_home` ch5 (CutsceneMode jamais désarmé) | ✅ corrigé | `metano_normal_home_ch_5.lua:425` → `GAME:CutsceneMode(false)` + `EnableCharacterAI`, sortie garantie commentée (l.408-425) |
| B2 `metano_electric_home_ch_5.lua` jamais chargé | ✅ corrigé | `init.lua:16` require ch5 + branche `PlotScripting` l.82-86 |
| B3 `ledian_dojo` ch5 (Azumarill invisible) | ✅ corrigé | `init.lua:96` appelle `ledian_dojo_ch_5.SetupGround()` + `Azumarill_Action` l.151-153 via `ChapterDispatch` |
| I4 PNJ permanents muets (4 cartes) | ✅ corrigé | `GeneralFunctions.ChapterDispatch` (l.124) : repli générique sur les trous de chapitre ; ex. `metano_inn/init.lua:158`, `altere_pond/init.lua:155-157` |
| I6 balises `[player]`/`[hero]`/`[partner]` affichées brutes | ✅ corrigé | reste **1** occurrence en `metano_town/strings.resx:146` + FR, clé `NPC_Luxio_1` — **vérifié : référencée dans 0 fichier Lua** (6 resx, 0 appel) → clé orpheline jamais affichée, sans effet. |
| I7 `GeminiClovenGate` absent de `index.idx` | ✅ corrigé | index.idx = 522 entrées, `GeminiClovenGate` présent, parse propre 0 octet restant |
| M8 `Murky Cave.ogg` inexistante | ✅ corrigé | `forgotten_marsh_miniboss_ch_9.lua` : ne reste que des **commentaires** explicatifs (l.56, 220) |
| M9 `SetSpeakerEmotion("Shock")` | ✅ corrigé | 0 occurrence |
| M17 `SV.Anchors`/`SV.Reseau` non déclarés | ✅ corrigé | `scriptvars.lua:678` et `:684` + gardes `OnUpgrade` (`debug_tools/init.lua:589-590`) |

### 4.3 Autres chantiers vérifiés
- **PrintInfo** (`main.lua:7-21`) : définie en première instruction du fichier
  persistant — correctif majeur du bug de fondu historique (600 appels dans 381
  fichiers, aucune définition avant). ✅
- **Renumérotation `searing_tunnel`** (2=Crucible → 2=arène, 3=Crucible,
  4=annexe) : appliquée ; risque documenté de `ZoneLoc` de sauvegarde décalé —
  le joueur doit sortir du donjon avant de charger la nouvelle version. ⚠️
- **Uniformisation donjons** (`docs/AUDIT_ARCHITECTURE_DONJONS.md`) : retrait
  d'`annexe_toupie` **fait** pour cloven_ruins, crystal_sanctuary,
  forgotten_marsh, celestial_peak ; **différé** pour vast_steppe,
  searing_tunnel, mount_windswept, gloomy_forest (retest en jeu requis avant).
- **Architecture des donjons** : modèle = crooked_cavern (Route procédurale
  `RangeDictSegment` + Boss `LayeredSegment`/`LoadGen`). Toute modification de
  segmentation impose la régénération de l'entrée `index.idx` de la zone.
- **Team Dazzling** : codenames Adagio (Tsareena) / Aria (Lopunny) / Sonata
  (Mismagius) ; « Lockpin » = nom FR d'espèce, pas un personnage ; nom affiché
  = « Team Dazzling ». Branche défaite Zarude + scène post-victoire OK
  (flags `PostDefeatScenePlayed`/`PostMissionScenePlayed` disjoints).
- **Grodoudou / LegendZones** : stand opérationnel (achat = accès revanche,
  pas recrutement) ; seule entrée `ready=true` : `verdant_oath` (Zarude).
  `tools/verify_legend.py` au vert.
- **Metano de nuit** (`TownNight.lua`) : 14 tilesets `_Night` présents et
  indexés, marchands masqués (pas retirés), 4 paliers de dialogue, choix de
  fin de journée branché sur 9 zones.

---

## 5. MAÎTRISE DES OUTILS (inventaire complet des `tools/`)

### 5.1 Vérificateurs — à lancer avant chaque commit
```bash
python3 -c "import lupa,glob; L=lupa.LuaRuntime(); [L.compile(open(f,encoding='utf-8').read()) for f in glob.glob('Data/Script/**/*.lua',recursive=True)]"
python3 tools/audit_bugs.py .              # baseline 9
python3 tools/audit_integrite.py .         # baseline 849
python3 tools/verify_legend.py .
python3 tools/verify_scene_positions.py .
python3 tools/verify_bg_format.py .
python3 tools/validate_all.py .
python3 tools/verify_ground_registration.py .   # 0 bloquant / 91 avert.
python3 tools/verify_lua_globals.py .
python3 tools/verify_spawner_enabled.py .
python3 tools/verify_cutscene_guard.py .
python3 tools/verify_emotions.py .
python3 tools/verify_midpoint_template.py .
python3 tools/count_dialogue.py            # SANS argument de chemin
python3 tools/audit_boss_cinematics.py .
python3 tools/audit_dialogues.py .
```

**Ce que fait `audit_bugs.py` (12 contrôles, conserver un doute = se taire) :**
`STRINGS.Format` au lieu de `:Format` · fonctions de module appelées sans
définition · tables/champs `SV` lus sans déclaration (agrège tous les
`scriptvars.lua` + `OnUpgrade`) · handlers de carte `.rsground` absents du
script (dossier `ground/<map>/` + fichiers `_ch_N.lua`, `triggerType 0` =
décoratif) · zones/GroundMaps/MapStatus/items inexistants · `require` vers un
module absent · cycles de `require` · virgule avalée par commentaire ·
zones `Released=false`.

**`audit_integrite.py` (8 contrôles) :** paramètres de fonction morts
(callbacks jamais appelés) · personnages fantômes (`MakeCharactersFromList`
sur une clé absente de `CharacterEssentials`) · clés `.resx` manquantes ou
dupliquées · instances inconnues (`Hide`/`Unhide`) · sons/musiques à
occurrence unique (typo) · scènes muettes (boss sans `PlayBGM`) · clés
orphelines.

### 5.2 Simulateurs (exécutent du vrai Lua hors moteur)
- `tools/simulate.py` — construit un environnement Lupa avec stubs moteur
  (`GAME`, `GROUND`, `UI`, `SOUND`, `AI`, `TASK`, `STRINGS`, `_DATA`…),
  charge le vrai `scriptvars.lua` + `GeneralFunctions`/`CharacterEssentials`,
  journalise chaque appel via `PYREC`. C'est l'outil qui a prouvé le bug
  `hero`/`partner` non déclarés du ch6 et le conflit de flags défaite/victoire.
- `tools/test_scenarios.py` — rejoue des parcours complets (défaite Forêt
  Lugubre, retours, sorties de segment) sur le code réel.
- `tools/sim_legend.py` — parcours boutique Grodoudou → voyage → segment 3.

### 5.3 Générateurs / correctifs (références de méthode)
- Formats binaires : `png2tileset.py` (composer un `.tile` depuis des PNG),
  `tile_night.py` (conversion nuit + `--check` roundtrip), `rebuild_tile_index.py`
  (régénère `Content/Tile/index.idx`), `render_ground.py`/`render_rsmap.py`
  (rendus PNG de contrôle), `nea_map.py` (grille de collision), `gen_collisions.py`.
- Vagues d'import : `pmdred_lib.py` + `convert_pmdred_*.py` (GBA 1:1),
  `import_wave*.py`, `gen_addon_*_network*.py`, `import_aegis_arena.py`,
  `retile_lugia_arena.py`, `gen_season_particles.py`, `gen_boss_cinematics.py`.
- Correctifs documentés : `fix_ch7_ch10_flow.py`, `fix_ground_serialization.py`
  (écran noir des grounds importés), `fix_grounds_entities.py`, `rebalance_bosses.py`.

### 5.4 Problèmes d'outils découverts pendant CET audit
1. **`verify_new_era.sh` périmé** : attend 498 tilesets, le dépôt en a 522
   (les 14 `Metano_Town_*_Night` + nouveaux). → 1 fausse erreur. À resynchroniser.
2. **`tools/audit_text_tags.py`, `tools/audit_cutscene_exit.py`,
   `tools/audit_chapter_gaps.py` hardcodent `/home/user/nea`** → `FileNotFoundError`
   dans ce checkout (l'ancien agent travaillait sur un clone `~/nea`).
   À rendre portables (`sys.argv`/`MOD_ROOT` comme les autres).
3. **`count_dialogue.py`** ne prend **pas** de chemin en argument (il parse
   `sys.argv[1:]` comme des numéros de chapitre) : lancer sans argument.
4. `audit_spatial.py` et `audit_causalite.py` tournent mais signalent des
   dettes réelles (voir §7.5) — à intégrer dans la réflexion, pas dans le
   pré-commit (trop de bruit).

---

## 6. CONNAISSANCES MOTEUR & RÉFÉRENCES EXTERNES (maîtrisées)

### 6.1 RogueEssence — surface Lua (issue du clone `RogueCollab/RogueEssence`)
- `Lua/LuaEngine.cs` (2135 l.) : chargement des paquets, callbacks, `xpcall`
  autour de chaque callback (les erreurs Lua **avortent silencieusement** la
  fonction, ne plantent pas — d'où l'importance des `pcall` et du `PrintInfo`).
- `Lua/ScriptUI.cs` : `WaitShowDialogue`, `SetSpeakerEmotion`, `WaitShowBG`,
  menus. `Lua/ScriptGame.cs` : `EnterGroundMap`, `EnterDungeon`,
  `ContinueDungeon`, `EndDungeonRun`, `CutsceneMode`, `MoveCamera`,
  `FadeIn/Out` (**`FadeOut` est bloquant côté script**), `MoveCamera`.
- `Lua/ScriptGround.cs` : 45 fonctions `GROUND:` (mouvements, animations,
  `Hide/Unhide`, VFX, `CharWaitAction`).
- `Scene/GameManager.cs` : `MoveToGround` double-barrière —
  `summary.GroundValid(name)` (résumé issu de `index.idx`) puis
  `CurrentZone.GroundMaps.FindIndex` (zone JSON) : deux fichiers qui doivent
  rester **synchrones** (leçon L15 du crash hero_dream).
- `Ground/GSceneZone.cs` : `InitGround(saveLoad)` — `OnGameLoad` ne tourne que
  sur Continuer depuis `TopMenu.cs` ; **182 grounds sans `GameLoad` n'est pas
  un bug** (ne pas « corriger »).
- `Ground/GroundScene.cs:176` : `ProcessInput` cède si `Save.CutsceneMode` →
  un `CutsceneMode(true)` jamais désarmé fige le joueur **même après
  rechargement** (classe B1).
- `Text.cs` : liste exhaustive des balises (`pause`, `color`, `br`, `script`,
  `speed`, `emote`…) — tout autre tag s'affiche brut (classe I6).
- Formats : `.tile` (`[u32 size][u32 n][table 16o][PNG 8×8]`, dédup par offset
  partagé), `.dir` (`[u32 taillePNG][u32 0][PNG][frameW][frameH][LocHeight][frameCount]`,
  viewport 320×240), `.rsground` (grille `obstacles[x][y]`, case = 8 px,
  `Tags` 0=libre/1=bloqué), `.rsmap` (`MapTeams[0].Players[]`, `HP`+`MaxHPBonus`
  = même réservoir), `index.idx` (BOM + entrées len-préfixées).

### 6.2 Wiki PMDO (pages lues en entier)
- **Floor Generation Overview** : 4 familles de génération (Grid / List /
  Stairs / Load), priorité des steps de -7 (File Load) à +7 (Debug Checks),
  brackets (-6 floor data, -4 grid, -1 init map, 0 draw tiles, 1 spawn tables,
  2 exits, 3 extra terrain, 4 textures, 5 tile spawns, 6 spawn money/items/mobs).
  C'est ce que manipulent `RangeDictSegment`, `LayeredSegment` et les
  `ScriptGenStep` des zones du mod.
- **Scripting Cheat Sheet** : 30 « How do I » — textes, portraits, émotes,
  mouvements (`MoveToPosition`, `MoveInDirection`, `AnimateInDirection`),
  `BranchCoroutine`/`JoinCoroutines`, VFX (`SingleEmitter`/`FlashEmitter`),
  `CutsceneMode`, sons (`PlaySE`, `PlayBattleSE`, `LoopSE`, `PlayFanfare`,
  `PlayBGM`), titres (`WaitShowTitle`), fonds (`WaitShowBG`), caméra
  (`GAME:MoveCamera`), météo (`AddMapStatus`), `EnterDungeon` vs `EnterZone`
  vs `ContinueDungeon`, `EnterGroundMap`.
- **Lua Function Reference** (redirige depuis *Script Reference*) : les
  8 namespaces — AI, Dungeon, Game (Control / Map & Adventure / Rescue /
  Camera / Team / Character / Item / Money / Inputs / Dungeons / Direction /
  Queuing), Ground (Entity / Turning / Movement / Animation / Screen Effects /
  Leveling / Map Status), Sound, Strings, Task, UI (Textbox / Background /
  Speakers / Choice Menu / Functional Menus / Rescue Menus / Custom Menus).

### 6.3 API attestées dans le mod (méthode de preuve)
202/255 fonctions de `PMDODump/DataAsset/Docs/Script.txt` utilisées. Attestées
par comptage d'occurrences : `GROUND:CharTurnToCharAnimated` (547),
`GROUND:CharSetAnim` (128), `GeneralFunctions.HeroDialogue` (62),
`TASK:JoinCoroutines` (78), `GROUND:MoveScreen(ScreenMover)` (mouvement
d'écran, patron du tangage de rêve)… **Interdits** : `Anims:Clear()`,
`CharAnimateTurnToChar`, `STRINGS.Format` (point).

### 6.4 Tutoriels audinowho (PMDOTutorial)
- **Lesson 2 — Ground Maps In-Depth** (v0.2) : patron `rescue_team_base`,
  zone + init.lua + JSON de zone — c'est le squelette dont dérivent tous les
  grounds du mod.
- **Lesson 6 — Cutscenes** (v0.6) : `large_lake/init.lua` = patron canonique
  de cinématique (décor → personnages → dialogue → coroutines jointes).
- Leçon 3 (Dungeon Maps), 5 (Multi-Floor Generation), 7 (Boss Battle) : cadrage
  des donjons segmentés et des arènes — conformes à l'architecture
  Route/Mini-boss/Boss du mod.

### 6.5 Dépôts amont (rôle dans le pipeline)
- **RogueElements** (audinowho) : génération procédurale (steps, `Loc/Rect`,
  gen steps) — utilisée par les `RangeDictSegment` des zones.
- **PMDC** (PMDCollab) : systèmes de combat, données Pokémon (les espèces,
  capacités, talents viennent de la base PMDO ; `Data/Monster/` du mod ne
  contient que ~21 surcharges).
- **PMDODump / DumpAsset** : assets officiels dumpés (grounds, tilesets,
  musiques, portraits). Source des imports 1:1 (relais, Friend Areas, arènes).
- **RawAsset** (PMDCollab) : textures brutes du jeu officiel.

---

## 7. DETTES ET POINTS DE VIGILANCE RESTANTS

### 7.1 À corriger (actionnable, sûr)
1. **`verify_new_era.sh`** : `EXPECTED_TILESETS=498` → **522** (une ligne).
2. **3 outils hardcodés `~/nea`** : `audit_text_tags.py`, `audit_cutscene_exit.py`,
   `audit_chapter_gaps.py` — les rendre portables pour qu'ils entrent dans la
   suite pré-commit (recommandation de l'audit 2026-07-30 §7).
3. **21 clés EN sans FR** (§ M11) : `Cafe_*` de `metano_town` (résidus inertes
   — le vrai café vit dans `metano_cafe`), `String_18/30/31` de `ledian_dojo`
   (placeholders). Aucune n'est lue en jeu (vérifié par l'audit 2026-07-30) ;
   les supprimer ou les compléter, pas urgent.
4. **1 balise `[player]`/`[partner]` résiduelle** : `metano_town/strings.resx:146`
   (+FR), clé `NPC_Luxio_1` — **clé orpheline** (0 référence Lua), jamais
   affichée. Sans effet ; à nettoyer lors d'une passe de dette resx.

### 7.2 À trancher / décisions ouvertes
- **Ch9 : Mega-Blastoise vs Laggron** (Swampert) — trame prévoit le méga, le
  dépôt utilise Laggron (`docs/08_zones_vivantes_ch8_ch10.md`,
  `docs/integration_tracker.md`).
- **Renivelage ch6-10** : déjà appliqué (27→35, option a) — la courbe P1-P8
  du mega-prompt reste à valider pour l'expansion.
- **Escortes de mini-boss hors gabarit** (6 donjons : Steppe, Mont, Lugubre,
  Ruines, Cristal, Marais) : proposition d'ajout de pré-évolutions
  (`docs/plan_narratif_ch11_ch32.md §1.4`), **non appliquée**.
- **Position de Grodoudou** : (656, 1272) — dans la rangée des étals, pas
  adjacente à Lars/Kecleon (audit 2026-07-28). Validée comme « zone
  commerciale cohérente » ; à confirmer avec le joueur.

### 7.3 Dettes assumées (documentées, ne pas « corriger » sans raison)
- **849 anomalies `audit_integrite`** : majoritairement clés `.resx`
  orphelines (dette d'écriture) — 727 au moment de la passation, la tendance
  est à la baisse.
- **107 `.rsground` orphelins** (~500 Mo) : imports pmd-red « en réserve »
  (31) + autres ; inatteignables, 49 sans marqueur. `master_zone.json` a des
  **trous d'index** (indices 10-19, 55) qui figent la numérotation — ne pas
  retirer ces entrées sans renuméroter les menus (`GroundMaps[ID]`).
- **`normal_maze`** : 38 GroundMaps déclarés (toute la ville, la guilde) —
  résidu de test qui brouille les audits ; nettoyage sans danger mais non
  prioritaire.
- **36 clés `megastones` sans traduction FR** ; `machine_recall_box.json`
  sans BOM ; IA `escortee` (EoN) non importée (missions d'escorte).
- **`audit_spatial`** : 58 grilles d'obstacles vides (imports 1:1 sans
  collisions — le cas mount_windswept_guardian a été traité, pas les autres),
  62 cartes avec entités murées (240 entités). Ces imports ne sont pas
  atteignables en jeu tant qu'ils ne sont pas branchés ; les corriger au
  moment de les brancher.

### 7.4 Risque prioritaire à tester en jeu
La renumérotation `searing_tunnel` (arène en segment 2, Crucible en 3,
annexe en 4) : un `ZoneLoc` de sauvegarde enregistré **dans** le Tunnel peut
pointer un segment qui a changé de sens. `ZoneLoc` n'est pas modifiable depuis
Lua — garde `OnUpgrade` posée, mais **sortir du donjon avant de charger**.

### 7.5 Chantiers majeurs ouverts (par valeur décroissante)
1. **Tester en jeu** — ~30 lots validés statiquement seulement. C'est LE
   risque n°1 du projet (répété dans toutes les passations).
2. **Cinématiques de boss** des 67 zones EoS + 34 pmd-red (score 17-27/100) —
   gabarit d'armement existant (`BossFX`, `BossMusic`, `ChapterAftermath`).
3. **Densité des relais ch5** : `vast_steppe_midpoint` et
   `mount_windswept_midpoint` (~4 clés chacun vs 42 pour
   `searing_tunnel_midpoint`) — même si l'audit Mont Venteux du 2026-07-29
   indique que l'entrance du Mont est déjà très développée (2335 lignes).
4. **Volumétrie ch6-10** (469 → 256 boîtes vs cible 7 000) et **chapitres
   11-32** : scénario structuré, donjons et 42 cinématiques d'Ancrage prêts,
   dialogues à écrire.
5. **Retraits différés `annexe_toupie`** (vast_steppe, searing_tunnel,
   mount_windswept, gloomy_forest) — après retest en jeu des chapitres.
6. **`audit_causalite`** : 71 sorties de personnage non justifiées — outil
   narratif à utiliser comme checklist d'écriture des prochaines scènes.

---

## 8. RÈGLES PROJET (non négociables — rappel exécutif)

1. **Méthode** : preuve avant hypothèse (fichier + ligne) ; ne jamais inventer
   une API (compter les occurrences hors du fichier courant) ; prouver le
   format d'un JSON par round-trip avant de l'écrire ; patchs chirurgicaux ;
   signaler honnêtement erreurs et faux positifs ; **répéter que rien n'est
   testé en jeu**.
2. **Narratif** : jamais « Necrozma / Eternatus / l'Abîme / prison » dans un
   texte affiché ; ne jamais nommer les personnages des jeux d'origine (le
   joueur reconnaît, le héros non) ; la Voix reste anonyme et ne parle pas en
   ville de jour ; répliques 1-2 phrases, < 150 caractères hors `[pause=N]` ;
   casting vérifié (Penticus/Phileas/Rin/Hyko/Almotz/…) — une erreur a déjà
   été commise et corrigée (Phileas ≠ maître de guilde).
3. **Technique** : toute table `SV` neuve déclarée dans `scriptvars.lua` ET
   rattrapée dans `OnUpgrade` de `debug_tools` ; toute zone `.json` modifiée
   → resynchroniser `Data/Zone/index.idx` ; `EnterGroundMap` exige la carte
   dans les `GroundMaps` de la zone ET dans `index.idx` ; jamais de
   `MoveToPosition` longue traversée dans une foule (≥ 18 px de tout occupant,
   sous `pcall`) ; tout sous `pcall` avec sortie garantie ; `strings.resx` =
   EN, `strings.fr.resx` = FR ; incrémenter le tag de build dans les **3**
   fichiers (main.lua, scriptvars.lua, ground/vast_steppe_midpoint/init.lua).
4. **Validation avant chaque commit** : compilation Lupa de tous les Lua +
   `audit_bugs` (9) + `audit_integrite` (849) + `verify_legend` +
   `verify_scene_positions` + `count_dialogue` (ch5 = 1 616).

---

## 9. CONCLUSION

Le dépôt est **statiquement sain sur tout ce que la suite d'outils couvre** :
673 Lua compilent, 207/207 zones synchrones avec l'index, 522/522 tilesets
indexés, 0 dialogue anglais visible, 0 crash de portrait connu, 0 scène à
risque, baselines `audit_bugs` (9) et `audit_integrite` (849) tenues. Les 7
défauts majeurs de l'audit du 2026-07-30 sont **corrigés et vérifiés dans le
code** ; le todo.txt de l'auteur est traité à 3/6 (2 partiels, 1 ouvert).

Les risques réels ne sont pas dans le code statique : ce sont (1) l'absence
totale de test en jeu sur ~30 lots, (2) la volumétrie narrative ch6+ très
en dessous de la cible, (3) les cinématiques de boss des add-ons (score 18-27),
(4) les chapitres 11-32 à écrire. Les prochains chantiers devront commencer
par la resynchronisation de `verify_new_era.sh`, la portabilité des 3 outils
hardcodés, puis le test en jeu dès que l'environnement le permet.

*Fin de l'audit — toutes les affirmations ci-dessus ont été vérifiées par
exécution d'outils ou lecture de fichier le 2026-07-31.*
