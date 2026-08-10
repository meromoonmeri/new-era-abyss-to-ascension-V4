# REGISTRE MAÎTRE — RECONSTRUCTION DES SCÈNES PMD RED + PMD SKY DANS NEW ERA

**Date : 2026-08-10 — Mission : « Reconstruire les scènes, cinématiques, événements, mises en scène et
séquences narratives de PMD Red et PMD Sky dans New Era en conservant au maximum leur représentation
originale — MÊME SCÈNE, MÊME CHORÉGRAPHIE, MÊME CAMÉRA, MÊMES TIMINGS, MÊMES ANIMATIONS, MÊMES
EFFETS, MÊMES TRANSITIONS, MÊME STRUCTURE — MAIS CAST NEW ERA. »**

Règle de base : **PMD Red et PMD Sky sont démontés puis réassemblés** ; le dépôt n'est pas une source de
vérité, chaque scène existante est un état à auditer contre la source canonique ; **aucun asset n'est
inventé** (REQUIRES_ASSET/REQUIRES_ROM sinon).

---

## 1. MÉTHODOLOGIE — PIPELINE DE RECONSTRUCTION (à appliquer scène par scène)

```
SOURCE (GBA pret/pmd-red | NDS pret/pmd-sky SSB)
   │  1. extraction complète du script/scène (ground_data_*.h | .ssb -> IR -> exps)
   │  2. décodage : positions (halftiles), ordre d'apparition, déplacements (WALK_GRID/ROTATE_TO),
   │     orientations, attentes (WAIT), cues (ALERT/AWAIT_CUE), caméra (CAMERA_PAN), BGM/SFX
   │     (BGM_SWITCH/FANFARE), dialogues (MSG_NPC/MSG_VAR/PORTRAIT), VFX (NOTICE_FUNC, FLASH_*)
   ▼
SCÈNE CANONIQUE (table de chorégraphie beat par beat, timings en frames)
   │  3. identification des rôles dramatiques (fonctions scéniques de chaque acteur)
   ▼
CAST NEW ERA (mapping des rôles : canon New Era établi, sinon DEMANDER)
   │  4. ground New Era correct (Data/Ground/*.rsground, positions = marqueurs canoniques translatés)
   │  5. reconstruction PMDO : coroutines Lua (GAME:WaitFrames, GROUND:MoveToPosition,
   │     CharAnimateTurnTo, CharSetEmote, TASK:BranchCoroutine, MoveCamera, SOUND:PlayBGM...)
   │  6. test de fidélité (matrice SOURCE vs PMDO, §3) — RUNTIME requis pour VALIDÉ
   ▼
MÊME SCÈNE DANS L'UNIVERS NEW ERA (30 ans après, cohérence narrative, zéro doublon)
```

**Statuts utilisés** (règle projet, jamais de COMPLETE sans preuve) :
`COMPLETE` · `PARTIAL` · `FAILED` · `PENDING` · `REQUIRES_ASSET` · `REQUIRES_ROM` ·
`REQUIRES_RUNTIME` (validation en jeu impossible ici — le moteur n'a jamais tourné dans cet environnement) ·
`UNVERIFIED` (implémenté mais non audité contre la source).

---

## 2. PARTIE A — SCÈNES PMD RED (GBA, `pret/pmd-red`)

Sources : `src/data/ground/ground_data_*.h` (scripts complets, positions GroundLivesData, effets,
liens, BGM/fanfares) ; `src/dungeon_cutscene_*.c` (cinématiques de boss) ;
`data/map_bg/*.bma/bpl/bpc/bpa` (grounds). Le port 1:1 `PMD-RED-PMDO-PORT` (245 maps) fournit les
`.rsground`/`.tile` correspondants.

### 2.1 Cinématiques d'histoire (série A)

| Scène GBA | Ground GBA | Contenu canonique | Ground New Era | Cast New Era | Statut |
|---|---|---|---|---|---|
| gs171 (A04P01) | MAP_COMET (météorite) | **MÉTÉORITE** : 8 secteurs g0-g7 — flashs blancs (FLASH_FROM/TO 32), caméra pan, BGM World Calamity, Xatu + Rayquaza (portrait/voix), fanfares 465/489/212, Gemme de Téléportation | **AUCUN** (A04P01 non converti) | Xatu→à définir ; Rayquaza→à définir (cast New Era) | **REQUIRES_ASSET** (voir `AUDIT_CINEMATIQUE_METEORITE_PMD_RED.md` : musiques World Calamity / Rayquaza's Domain absentes, map A04P01 non convertie, sprite météorite OBJ non versionné, commandes brutes 0x22/0x89 non documentées) |
| A04P02/A04P03 | — | Suite météorite / coucher de soleil | — | — | PENDING |
| A05P01-03 | — | Rayquaza / climax ciel | tour_celeste_sommet (convergence ch10) | Rayquaza | UNVERIFIED |
| gs207 (D13P01) | MAP_SKY_TOWER_ENTRY | Entrée Tour Céleste (parvis) : BGM Sky Tower, COMMON_ENTER | **parvis_celeste** (D13P01 1:1) | — | UNVERIFIED + **bug corrigé 2026-08-10** (objet Dungeon_Entrance restauré) |
| gs208 (D13P02) | MAP_SKY_TOWER_MID | Palier : ASK « Keep going? » → NEXT_DUNGEON summit ; ASK « Return to base? » → base ; objet SAVE_POINT | **palier_celeste** (D13P02 1:1) | — | PARTIAL (option retour/save absente) + **bug corrigé 2026-08-10** (objet Dungeon_Entrance restauré) |

### 2.2 Route canonique — 51 donjons + cinématiques de boss (arc hors-trame, ch.≥7)

Cf. `PLAN_NARRATIF_ARC_ROUTE_CANONIQUE_PMD_RED.md`. Chaque donjon = entrée (DxxP01) + arène de boss
(DxxP02, `dungeon_cutscene_*.c`). Statut global : **PENDING** (plan narratif validé, implémentation à
conduire donjon par donjon avec ce registre).

| # | Donjon | Entrée GBA | Arène/boss GBA | Cinématique canonique | Statut |
|---|---|---|---|---|---|
| 1 | Tiny Woods | D01P01 | — | — | PENDING |
| 2 | Thunderwave Cave | D02P01 | — | — | PENDING |
| 3 | Mt. Steel | D03P01 | — | — | PENDING |
| 4 | Sinister Woods | D04P01 (gs184) | D04P02 (gs185) | **Team Meanies vs Chenipan → sauvetage** (diptyque reconstruit — voir `RECONSTRUCTION_SINISTER_WOODS_D04P01_D04P02_2026-08-10.md`) | **PARTIAL** (pilot 2026-08-10) |
| 5 | Silent Chasm | D05P01 | — | — | PENDING |
| 6-7 | Mt. Thunder (+Peak) | D06P01… | — | Zapdos (`dungeon_cutscene_zapdos.c`) | PENDING — **REQUIRES_ASSET** pour le vrai ground d'entrée PMD Red du Mont Grondant (mt_thunder_midpoint = clone non canonique, non branché) |
| 8-16 | Great Canyon… Magma Cavern Pit | D07-D17 | Moltres/Articuno/Groudon | `dungeon_cutscene_moltres/articuno/groudon.c` | PENDING (Groudon : audit chorégraphie déjà aligné en 4ce956e/74e0d28) |
| 17+ | Sky Tower… post-game (33) | D18-D25 + quêtes 34-50 | Kyogre, Lugia, Deoxys, Ho-Oh, Mewtwo, Regis+Mew, Jirachi, Celebi, Latios, Entei, Suicune, Raikou | `dungeon_cutscene_*.c` | PENDING |

### 2.3 Villes / hubs / scènes spéciales

| Scène GBA | Ground | Contenu | Statut |
|---|---|---|---|
| Pokémon Square (T00P01) + bâtiments T01P01-07 | — | hub, équipes, guildes | UNVERIFIED (à auditer contre T00P01 g0-gN) |
| S01-S06 | — | scènes spéciales (dont Team Meanies intro à la place, ...) | UNVERIFIED |
| W01-W06 | — | world map / écrans | UNVERIFIED |
| H01-H29 (65 Friend Areas) | — | zones d'accueil / arènes de boss | UNVERIFIED (décision actée : zones d'accueil, pas donjons) |

---

## 3. PARTIE B — SCÈNES PMD SKY (NDS, `pret/pmd-sky` SSB)

Sources : `.ssb` → IR (JSON) → `.exps` (voir `docs/ssb_ir/`, `docs/ssb_decoded/`,
`MATRICE_COUVERTURE_SSB_LUA.md`). Conversion opcode→PMDO documentée (89 opcodes, table complète).

### 3.1 Arc du futur (24 scènes — déjà converties à 97.6 %)

Cf. `MATRICE_COUVERTURE_SSB_LUA.md` pour la matrice par scène (P05P01A…P09P01A). Statut global :
**PARTIAL** (converties, mais chaque scène doit être re-auditée beat par beat contre son IR pour la
fidélité chorégraphique, puis validée runtime). Les 6 scènes antagonistes Dusknoir→Necrozma :
P05P03A_m17a0302, P05P03A_m26a06d3, P09P01A_m19b1001, m19b1007, m19b1009, P09P01A_m19d1072.

### 3.2 Aegis Cave (Grotte Egide) — 4 chambres des Titans + entrée

| Scène NDS | Ground NDS | Ground New Era | Statut |
|---|---|---|---|
| Entrée Grotte Egide (D52P31A…) | D52P31A | cloven_ruins_entrance | PARTIAL (blueprint conservé ; rendus `preuves_sky/grounds_cloven/`) |
| Chambre Regice (D32P31A) | d55p41a | cloven_ruin_regice_chamber_sky | PARTIAL |
| Chambre Regirock (D32P32A) | d57p44a | cloven_ruin_regirock_chamber_sky | PARTIAL |
| Chambre Registeel (D32P33A, sauvetage Team Charm) | d59p41a | cloven_ruin_registeel_chamber_sky | PARTIAL |
| Chambre Regigigas (D32P44A) | d61p41a | cloven_ruin_regigigas_chamber_sky | PARTIAL |
| Éveil Ruines Cachées (D32P14A) | — | — | PARTIAL |
| Séquence finale (victoire→stèle→séisme→fuite→Ruines Cachées→adieux Team Charm) | — | — | PARTIAL (doc `AUDIT_AEGIS_CAVE_CLOVEN_RUIN_NDS_PMDO.md`) |

### 3.3 Tour Céleste / autres zones Sky

| Scène | Ground New Era | Statut |
|---|---|---|
| tour_celeste (entrée/relais/sommet) | parvis_celeste / palier_celeste / tour_ciel_sommet | PARTIAL + bug Dungeon_Entrance corrigé |
| Épisodes spéciaux / post-game Sky | — | PENDING |

---

## 4. BUGS DE RECONSTRUCTION TROUVÉS ET CORRIGÉS (2026-08-10)

| # | Ground | Bug | Correction | Statut |
|---|---|---|---|---|
| R1 | gloomy_forest_entrance (D04P01) | **Objet `Dungeon_Entrance` perdu** depuis 79c48f9/752e705 (présent en 1cf5bfc) → le joueur ne peut PAS entrer dans gloomy_forest → chapitre 6 bloqué à l'orée | Objet GroundObject `Dungeon_Entrance` (triggerType Touch, Passable, X136 Y192 200×24 — haut de la bande praticable) | CORRIGÉ (RUNTIME requis) |
| R2 | palier_celeste (D13P02) | Objet `Dungeon_Entrance` manquant → ascension Tour Céleste bloquée au palier | Objet ajouté (X168 Y168 112×24, connecteur haut) | CORRIGÉ (RUNTIME requis) |
| R3 | parvis_celeste (D13P01) | Objet `Dungeon_Entrance` manquant → Tour Céleste inaccessible | Objet ajouté (X224 Y88 48×16, sommet du parvis) | CORRIGÉ (RUNTIME requis) |
| R4 | gloomy_forest_entrance + sinister_woods_clearing | **Spawns/déplacements de la Team Dazzling DANS les murs** (collision BMA 1:1 : rows 10-20 solides / lisière) — le commentaire « slots tous praticables » était faux | Positions déplacées sur cellules praticables (vérifié grille par grille) ; départs à la lisière, sortie vers la bande haute | CORRIGÉ (RUNTIME requis) |
| R5 | sinister_woods_clearing | Battement canonique manquant : pivot du héros (SPINLEFT1 WEST / WAIT 60 / SPINRIGHT1 EAST) pendant l'échange | Ajouté après GF6E_A12 (CharAnimateTurnTo Left→Wait 30→Right→Wait 15, partenaire Left) | CORRIGÉ (RUNTIME requis) |

---

## 5. ÉTAT GLOBAL + PROCHAINES VAGUES

1. **Pilote Sinister Woods (D04P01/D04P02)** — fait (doc dédié). À valider runtime par l'utilisateur.
2. **Météorite (A04P01)** — bloquée sur REQUIRES_ASSET (musiques, map, sprite) : décision utilisateur requise.
3. **Route canonique PMD Red (51 donjons)** — à implémenter donjon par donjon (registre §2.2).
4. **Re-audit des 24 scènes SSB arc futur** beat par beat (matrice opcode→PMDO existante).
5. **Audit des autres grounds d'entrée/boss** pour le même type de perte d'objets que R1-R3
   (script : vérifier chaque ground dont le Lua attend `Dungeon_Entrance_Touch`).

**Règle absolue rappelée** : aucun statut VALIDÉ sans exécution réelle de PMDO (RUNTIME VERIFIED interdit ici).
