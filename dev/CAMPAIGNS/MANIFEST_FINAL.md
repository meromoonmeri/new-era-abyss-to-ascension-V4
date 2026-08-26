# MANIFEST FINAL — PMD Red Rescue Team EU & PMD Explorers of Sky EU dans PMDO

**Date** : 2026-08-26 · **Branche** : `arena/01a0357e-new-era-abyss-to-ascension-v4`
**Règle d'or** : le canon vient des ROM ; PMDO/RogueEssence fournit le runtime ; les
outils font le pont. Toute approximation est déclarée `TECHNICAL_ADAPTATION` ou `GAP`,
jamais canonique. Les couvertures sont par **dimensions séparées** — aucun pourcentage
global fusionné n'existe.

Render de synthèse : `dev/docs/canonical/renders/SHOWCASE_RED_SKY.png`
(hub Bourg-Trésor, Guilde de Grodoudou, Plage, panorama défilant de l'intro, 4 arènes
boss Sky dont DIALGA, Place Pokémon Red, 3 arènes boss Red dont GROUDON/RAYQUAZA
décodées octet par octet).

---

## 0. Correspondance Nom humain ↔ Ground technique (PROUVÉE, audit 2026-08-26)

**Autorité Sky** : bloc ROM `Ground Map Names` (text_*.str EU, 5 langues), résolu à la
base d'index 16256 — preuve croisée : G01P01A(nameid 277)=« Wigglytuff's Guild /
Guilde de Grodoudou », T01P01A(303)=« Treasure Town / Bourg-Trésor »,
P01P01A(290)=« Crossroads / Croisement ». Table complète :
`PMD_SKY_EXPLORERS/Docs/LEVEL_HUMAN_NAMES.json` (366 levels nommés, 93 nameid hors
bloc = pas de nom de lieu). **143 noms ROM appliqués au MANIFEST Sky** (anciens
libellés conservés dans `previous_human_name`).

**Autorité Red** : pret/pmd-red `ground_map.h` (enum GroundMapID) →
`ground_map_conversion_table.c` → `map_files_table.c` (fichiers BPL/BPC/BMA/BPA) ;
45/45 noms de donjons du manifest = pret, 0 divergence.

| Nom humain (FR / EN) | Ground | Campagne | Preuve | Render | Runtime |
|---|---|---|---|---|---|
| Bourg-Trésor / Treasure Town | `t01p01a` (+t01p02a_sky) | Sky | nameid 303/304→bloc ROM | ✓ | LOAD+MOVE SAFE |
| **Guilde de Grodoudou** / Wigglytuff's Guild | **`g01p01a`** (variantes b/c/2) | Sky | nameid 277→bloc ROM | ✓ | LOAD+MOVE SAFE |
| Croisement / Crossroads | `p01p01a` | Sky | nameid 290 (l'ancien showcase l'étiquetait « Guilde » — **corrigé**) | ✓ | SAFE |
| Plage / Beach | `d01p11a` | Sky | nameid 196 | ✓ | SAFE |
| Café Spinda / Spinda's Café | `p01p04a` | Sky | nameid 293 | ✓ | SAFE |
| Panorama intro (sans nom, `???` ROM) | `s13p05a` | Sky | S13P05A nameid 185=`???` | ✓ | SCROLL_PASS |
| Place Pokémon / Pokémon Square | `t01p01` | Red | MAP_POKEMON_SQUARE→T01P01+BPA T01P011 (6 frames portées) | ✓ | journey |
| Base d'équipe / Rescue Team Base | `t00p01` | Red | MAP_SQUARE→T00P01 (**restauré** — était écrasé par le Sky homonyme) | ✓ | LOAD_PASS |
| Étang Barbicha / Whiscash Pond | `t01p02a` | Red | MAP_WHISCASH_POND→T01P02A+BPA T01P021 (336 frames) (**restauré**) | ✓ | LOAD_PASS |
| Mont Gel (Ninetales) / Mt. Freeze | `d11p01/p02/p03` | Red | MAP_MT_FREEZE_* (aucun BPA ROM → statique canonique) | ✓ | journey CH? |
| Ravin Aubaine (ép. Sunflora) / Fortune Ravine | `d45p21a` (non porté) | Sky | nameid→bloc ROM ; DUNGEON_SCREEN post-game | render ROM | NOT_BUILT |

### Collisions d'ID résolues (10 découvertes par l'audit)

`t00p01` et `t01p02a` : les grounds **Red GBA canoniques avaient été écrasés** par les
ports Sky NDS homonymes (Treasure Town ≠ Whiscash Pond !). Corrigé : contenu Red
restauré depuis 0f691fa3 (référence verrouillée), contenu Sky déplacé vers
`t00p01_sky` / `t01p02a_sky` (convention rock_path/rock_path_sky), zone+index mis à
jour. Les 8 autres IDs (`d18p11a, d19p11a, d20p11a, d21p21a, d21p41a, d22p11a,
s04p01a, s21p01a`) sont du contenu Sky listé par erreur dans le manifest Red —
marqués `is_red_canon: false`. Preuves post-correction : 96/96 grounds sky_hub_zone
SAFE, RED_GLOBAL_JOURNEY_PASS re-vérifié.

---

## 1. Sources canoniques authentifiées

| ROM | Fichier | sha256 |
|---|---|---|
| Sky EU (NDS, C2SP) | `Pokemon Mystery Dungeon - Explorers of Sky (Europe) (En,Fr,De,Es,It).nds` | `1fa39d35…c789f170c1` |
| Red EU (GBA) | `converter/rom_input/pmdred-eu.gba` | `0f9d125d…f604c14cbcd` |

Références de décodage : `pret/pmd-red@bf0092d0` (fixedmap.inc, dungeon_generation*.c,
pokemon_found.json, learnset_data.json), `pmdsky-debug` (enums music_id, opcodes),
`skytemple-files` (handlers BPL/BPC/BMA/BPA/SSB/SSA natifs).

Runtime cible : **PMDO 0.8.12** (bundle headless réel, quest `New-Era`,
sortie JSONL par harnais Lua — jamais de faux PASS : chaque verdict est émis par le
moteur lui-même pendant une partie réelle).

---

## 2. Chaîne complète (ROM RESOURCE → PMDO RESOURCE → RUNTIME BEHAVIOR)

```
ROM vérifiée (sha256)
  → extraction brute (scripts, maps, tables, dialogues, placements)
  → classification FONCTIONNELLE par preuves ROM (jamais par nom de fichier)
  → adaptation TECHNIQUE vers PMDO (documentée, fail-closed)
  → intégration (Data/Zone, Data/Map, Data/Ground, Content/Tile, Data/Script)
  → validation RUNTIME réelle (harnais Lua dans PMDO headless, JSONL)
  → JOURNEYS bout-en-bout (NEW SAVE → chapitres → boss final → état de fin)
  → matrice de couverture + audit + ce manifest
```

### 2.1 Extraction (établie, preuves commitées)

**Sky** : 3760/3760 SSB décompilés en ExplorerScript+JSON (dialogues 5 langues),
1884/1884 SSA/SSE/SSS (placements acteurs/objets/triggers), 315/315 LSD,
180 donjons / 1795 étages de tables mappa_s.bin (178 donjons PASS ; d71 et d173 sont
des slices vides DANS la ROM, documentés), LEVEL_MAP_LINKS (level→MAP_BG→mapty),
graphe de progression 245 états / 97 bit flags.
→ `PMD_SKY_EXPLORERS/Cinematics/`, `Tables/`, `Docs/PROGRESSION_GRAPH.json`.

**Red** : chaîne EVENT_* décodée octet par octet depuis la ROM EU
(gFunctionScriptTable @0x08294450, 399/407 scripts PASS, 136 états SCENARIO_MAIN 1:1
avec pret), 69 stations exactes + 3073 blocs de dialogues 5 langues, 133 cif.json de
cinématiques, progression jouable 121 états.
→ `PMD_RED_RESCUE_TEAM/Cinematics/`, `Docs/`.

### 2.2 Classification fonctionnelle Sky (460 grounds, preuves ROM)

`Docs/GROUND_CLASSIFICATION.json` — critères : `mapty` (Pmd2ScriptLevelMapType),
présence enter.sse/.sss/.ssa, collision BMA, xrefs SSB cross-zone. Résultat :
**95 MAP** (lieux marchables), **213 CINEMATIC_BACKGROUND** (dont défilants — jamais
convertis en fausses maps statiques), **62 DUNGEON_SCREEN** (mapty=10),
**26 CINEMATIC_GROUND**, **24 SCRIPTED_SCREEN**, **17 BOSS_ARENA_FIXED** (mapty=11),
22 REVIEW (dormants ROM), 1 UNREFERENCED. Contrat catégorie→pipeline→test :
`Docs/CLASSIFICATION_PIPELINE.md`.

### 2.3 Adaptations techniques documentées (jamais déclarées canoniques)

- Boss : `HP=0` → stats natives du moteur aux niveaux ROM exacts (les anciennes
  arènes à HP=60+4×level restent marquées approximation).
- Scrolling NDS → caméra continue PMDO (durée = distance/vitesse ROM).
- SetEffect EFFECT_* → émotes natives PMDO ; se_Play → PlayBattleSE (tables id→asset).
- 85 items d'Explorers absents du roster PMDO : `REQUIRES_MOD_ITEM` (pas de substitut
  silencieux) ; 8 musiques `REQUIRES_MOD_ASSET`.
- Double écran NDS : scènes concernées `SKIPPED_PARTIAL_FIDELITY`, pas simplifiées.

---

## 3. État runtime PROUVÉ (extraits JSONL commités dans `dev/docs/canonical/`)

### 3.1 Sky — Explorers of Sky EU

| Preuve | Verdict | Fichier |
|---|---|---|
| Journey global NEW SAVE→CH1→…→CH15→**DIALGA** : 14 chapitres, 30 donjons, **313 étages réellement générés**, 10 boss vérifiés, état final 20.0 | `GLOBAL_JOURNEY_PASS` | `sky/global_journey_runtime_proof.jsonl` |
| 43/43 donjons histoire (d01–d43) + **12 post-game** (d44, d50–d60 : Mystifying Forest, Surrounded Sea, Miracle Sea ×3, Aegis Cave ×7) — **55/55 EXACT** vs tables ROM (comparateur durci PAR ÉTAGE, pièges à plages exactes) | `CANONICAL_RUNTIME_PASS` ×55, `EXACT` ×55 | `canonical_dungeon_runtime/`, `Tables/ZONE_VS_ROM_COMPARISON.json`, `sky/postgame_zones_runtime_proof.jsonl` |
| 9 chaînes donjon→arène boss (Team Skull→…→Groudon illusion) | `CHAIN_PASS`/`BOSS_ARENA_PASS` ×9 | `sky/story_chains_runtime_proof.jsonl` |
| 95/95 grounds MAP chargés + marchés en un run | `LOAD_PASS`+`MOVEMENT_PASS` (95 SAFE) | `sky/hub_grounds_runtime_proof.jsonl` |
| Progression : 14 états ROM franchis, 43 déblocages, monotonie | `PROGRESSION_RUNTIME_PASS` | `sky/progression_runtime_proof.jsonl` |
| Persistance : save → quit → **process 2** → LoadProgress → reprise | `RESUME_RUNTIME_PASS` | `sky/resume_runtime_proof.jsonl` |
| Background défilant pilote s13p05a (intro) : mouvement vérifié à 4 instants | `SCROLL_RUNTIME_PASS` | `sky/scroll_pilot_runtime_proof.jsonl` |
| Cinématiques compilées : **419 scènes** (fail-closed V4), 44 rejouées dans le moteur | `CINEMATIC_RUNTIME_PASS` ×44 | `sky/compiled_scenes_runtime_proof.jsonl`, `Docs/SCENE_COMPILER_REPORT.json` |

### 3.2 Red — Rescue Team EU

| Preuve | Verdict | Fichier |
|---|---|---|
| Journey global : **13 chapitres, 182 étages, 6 boss SANS GAP** (Skarmory, Zapdos, Moltres, Glalie, **GROUDON L27**, **RAYQUAZA L35**) | `RED_GLOBAL_JOURNEY_PASS` | `red/global_journey_runtime_proof.jsonl` |
| Route mt_steel : entrée→8 étages→boss Skarmory→sortie | `ROUTE_PASS` | `red/mt_steel_route_runtime_proof.jsonl` |
| Persistance : save état 7.0 depuis t01p02b → quit → **process 2** → LoadProgress → état relu → reprise 8.0 | `RED_RESUME_RUNTIME_PASS` | `red/resume_runtime_proof.jsonl` |
| Chaînes magma_cavern_pit→Groudon et sky_tower_summit→Rayquaza | `CHAIN_PASS` ×2 | idem |
| 89/89 zones donjon (1848 étages) | `CANONICAL_RUNTIME_PASS` | `canonical_dungeon_runtime/matrix.json` |

### 3.3 Arènes GROUDON/RAYQUAZA — méthode (référence)

`fixedmap.inc` GBA décodé octet par octet : table `gUnknown_84A03BC` (index =
FixedRoomID−1), RLE de `sub_80511F0` reproduit, actions de `PlaceFixedRoomTile`
(sol/mur/spawn/escalier/entités ≥16), contre-épreuve Skarmory 9×17 == rsmap existant.
Niveaux ROM : Groudon **L27** (MagmaCavernPit 3F), Rayquaza **L35** (SkyTowerSummit 9F) ;
movesets learnset_data.json ; HP=0 (stats natives — PAS l'approximation 230/280).
Outil : `dev/tools/red_build_gba_fixed_arenas.py`.

---

## 4. Compilateur cinématique Sky (fail-closed)

`dev/tools/sky_compile_scenes.py` → `Data/Script/halcyon/skyscenes/` (374 fichiers Lua).

- **Règle absolue** : jamais d'opcode inconnu ignoré silencieusement, jamais de scène
  complexe remplacée par une version simplifiée déclarée PASS. Toute op non traduite
  est comptée (`PARTIAL_OPS`), toute scène incomplète est SKIPPED avec raison.
- Totaux : **419 COMPILED** (V4), 306 PARTIAL_OPS, 20 NOT_COMPILED_MULTIROUTINE,
  625 SKIPPED_PARTIAL_FIDELITY (double écran NDS), 372 SKIPPED_REQUIRES_ENGINE_EXTENSION,
  2005 TRIVIAL_SKIPPED.
- Transport qualité : dialogues 5 langues ROM (markup NDS nettoyé, langue du joueur),
  déplacements aux positions ROM (tuile×8+offset×4, vitesses walk/slow), caméra
  (performer→MoveCamera), cast SSA (PNJ spawnés aux positions ROM exactes,
  entid→espèce via PMDO_MAPPING 525 entrées), SE→PlayBattleSE, VFX→émotes natives,
  BGM par table enum ROM→jukebox PMDO (56 pistes, 2 GAPs canal ambiance documentés).
- Kit runtime : `Data/Script/halcyon/skyscenes/kit.lua` (say multilingue, spawn_npc,
  cleanup, traces JSONL).

---

## 5. Harnais de validation runtime (opt-in, CH1–CH5 intouchés)

`Data/Script/halcyon/services/ground_gameplay_validator/init.lua` — modes par variable
d'env `PMDO_GROUND_VALIDATOR` :
`sky:<grounds>` (LOAD+MOVE), `skyscene:<scene>@<ground>`, `skyprogress`, `skyjourney`,
`redjourney`. `red_story_route_validator` (env dédiée) : routes Red + chaînes
donjon→boss Sky. Zone conteneur `sky_hub_zone` (95 GroundMaps) — `master_zone.json`
et `main.lua` verrouillés ne sont jamais modifiés.

**Verrou d'intégrité** : `python3 dev/tools/ch1_5_lockfile.py check` →
« INTÉGRITÉ OK — référence 0f691fa3 » (37/37 fichiers identiques) exigé avant chaque
commit. Vérifié à cette session.

---

## 6. Matrice de couverture (dimensions séparées)

Voir `dev/CAMPAIGNS/COVERAGE_MATRIX.md` (regénérée cette session). Points saillants :

**Red** : extraction 254/254 · renders 254/254 · journey global **13/13 PASS** ·
event chain 399/407 · progression 121/121 · donjons 89/89 · AUDIT_PASS.

**Sky** : extraction 460/460 · SSB 3760/3760 · SSA 1884/1884 · classification 437/460 ·
grounds MAP runtime **95/95 PASS** · journey global **14/14 PASS** · resume **PASS** ·
scroll pilote 1/213 · scènes compilées 370/3760 · espèces 484/484 EXACT ·
items 205/290 (85 REQUIRES_MOD_ITEM) · zones vs ROM 43/43 EXACT · AUDIT_PASS.

---

## 7. GAPs restants (honnêtes, aucun masqué)

| # | GAP | Dimension |
|---|---|---|
| 1 | Sky post-game: d44+d50–d60 CONSTRUITS (12 zones, 70 étages, EXACT vs ROM + CANONICAL_RUNTIME_PASS) ; d45–d49 et d61+ restants (tilesets 82/88/180 REQUIRES_MOD_ASSET, épisodes spéciaux) | donjons |
| 2 | 306 scènes PARTIAL_OPS (368→306, V4) + 20 multiroutines + 372 REQUIRES_ENGINE_EXTENSION | cinématiques Sky |
| 3 | 625 scènes double écran NDS (PARTIAL_FIDELITY) non compilées | cinématiques Sky |
| 4 | Scrolling généralisé : 1 pilote / 213 backgrounds | backgrounds Sky |
| 5 | NPC/interactions/transitions des 95 grounds MAP non posés (LOAD+MOVE seulement) | grounds Sky |
| 7 | Red : compilateur cif→Lua FAIT (45 stations compilées, 2/2 testables runtime PASS) ; ops cif Audio/Effect/Camera non ordonnancées = PARTIAL_OPS | cinématiques Red |
| 8 | Red : classifieur formel des grounds (modèle sky_classify_grounds) | classification Red |
| 9 | Red : 64 stations REVIEW_REQUIRED | dialogues Red |
| 10 | 85 items + 8 musiques REQUIRES_MOD_* | mapping Sky |
| 11 | 178 scènes compilées sur grounds non portés (CINEMATIC_GROUND à porter) | cinématiques Sky |
| 12 | 2 GAPs BGM (canal ambiance OCEAN1/2) | audio Sky |

**Aucune promotion New Era n'est proposée tant que ces GAPs ne sont pas comblés ou
explicitement acceptés.**

---

## 8. Manuel — reproduire les validations

### 8.1 Restaurer l'environnement (sandbox recyclé)

```bash
git fetch origin arena/01a0357e-new-era-abyss-to-ascension-v4
git checkout -B arena/01a0357e-new-era-abyss-to-ascension-v4 FETCH_HEAD
bash dev/tools/restore_pmdred_eu_validation_runtime.sh   # bundle PMDO 0.8.12 headless
# ROM Sky (LFS via codeload) :
mkdir -p .runtime-cache/sky-rom
curl -sL "https://codeload.github.com/meromoonmeri/BIBLIOTHEQUE/tar.gz/refs/heads/main" \
  | tar -xz --wildcards --strip-components=1 -C .runtime-cache/sky-rom "*Explorers of Sky*"
python3 -m venv .runtime-cache/sky-venv
.runtime-cache/sky-venv/bin/pip install skytemple-files ndspy Pillow
```

### 8.2 Vérifier l'intégrité CH1–CH5 (obligatoire avant commit)

```bash
python3 dev/tools/ch1_5_lockfile.py check   # attendu: INTÉGRITÉ OK — référence 0f691fa3
```

### 8.3 Rejouer un journey complet (preuve moteur réelle)

```bash
# via canonical_dungeon.pmdo_env() + ensure_quest_appdata(); env:
#   PMDO_GROUND_VALIDATOR=skyjourney   → Sky NEW SAVE→DIALGA (~5 min)
#   PMDO_GROUND_VALIDATOR=redjourney   → Red 13 chapitres (~16 s)
# cmd: PMDO -asset DUMP/ -appdata APP/ -quest New-Era
# sortie: /tmp/ground_gameplay_validator.jsonl (attendre "event":"end")
```

### 8.4 Rejouer une cinématique compilée

```bash
# PMDO_GROUND_VALIDATOR="skyscene:<zone>__<scene>@<ground>"  (ex: n01a0801@t01p01a)
```

### 8.5 Renders

```bash
python3 dev/tools/render_ground_png.py --output-dir /tmp/r t01p01a   # ground pixel-perfect
python3 dev/tools/render_rsmap_autotile.py Data/Map/magma_pit_groudon.rsmap out.png
python3 dev/tools/campaign_render_showcase.py                        # planche composite
python3 dev/tools/campaign_coverage_matrix.py                        # matrice à jour
```

---

## 9. Correctif de cette session (traçé)

`Content/Tile/S13p05a_Base.tile` (sheet du panorama défilant de l'intro) n'avait
jamais été persisté (sandbox recyclé après le pilote scroll). Reconstruit depuis la
ROM Sky EU par association clé rsground ↔ image ROM (BMA/BPC/BPL, 224 frames),
**fail-closed** (0 conflit sur 18756 clés), contre-épreuve **frame 0 PIXEL_PERFECT**
vs ROM. Outil : `dev/tools/sky_rebuild_s13p05a_sheet.py`.

## 9bis. Audit exhaustif des grounds (fail-closed, 2026-08-26)

`dev/tools/campaign_audit_grounds_complete.py` →
`dev/docs/canonical/GROUNDS_COMPLETE_AUDIT.json/.md` : **688 entrées** (600 rsground
+ 88 rsmap), pour chacune : sheets référencées présentes (nom+casse exacts, quest ou
base PMDO avec provenance tracée), **chaque clé TexLoc** référencée existe dans la
planche, autotiles présents avec toutes leurs variantes et frames, détection
d'animations aplaties (cycle ROM>1 vs frames portées — 193 grounds animés vérifiés,
0 aplati), détection d'animations 100 % vides, ressource en RESERVE seulement =
NOT_PERSISTED = FAIL. Résultat après corrections : **688/688 PASS**.
Note : frames `Sheet:""` au sein d'anims mixtes = frames transparentes délibérées
(blink), pas des trous — seule une animation entièrement vide est un défaut.

## 10. Index des artefacts

- Preuves runtime : `dev/docs/canonical/{sky,red}/*.jsonl`
- Renders : `dev/docs/canonical/renders/` + `dev/CAMPAIGNS/*/Renders/` (460 Sky, 254 Red)
- Docs Sky : `dev/CAMPAIGNS/PMD_SKY_EXPLORERS/{Docs,Tables,Cinematics}/`
- Docs Red : `dev/CAMPAIGNS/PMD_RED_RESCUE_TEAM/{Docs,Cinematics}/`
- Matrice / comparaison : `dev/CAMPAIGNS/{COVERAGE_MATRIX.md,RED_VS_SKY_COMPARISON.md}`
- Outils : `dev/tools/` (un outil par fonction, pas de doublons *_v2/final)
