# RECONSTRUCTION — SINISTER WOODS (D04P01/D04P02) — PILOTE DE LA MISSION SCÈNES PMD RED

**Date : 2026-08-10 — Mission « MÊME SCÈNE, MÊME CHORÉGRAPHIE, CAST NEW ERA » — pilote appliqué au
diptyque canonique Sinister Woods (Team Meanies → Team Dazzling).**

Sources réelles utilisées (téléchargées depuis `pret/pmd-red`, aucune donnée inventée) :
- `src/data/ground/ground_data_d04p01_station.h` (gs184 — orée)
- `src/data/ground/ground_data_d04p02_station.h` (gs185 — clairière)
- `src/ground_lives.c` (résolution kind → espèce : kind 34 = partenaire ; kinds 91/92/93 = PNJ fixes
  des Meanies ; kinds 10-13 = membres recrutés ; kind 94 = client/objectif)
- Collisions/positions : exports 1:1 `PMD-RED-PMDO-PORT` (d04p01/d04p02) et `.rsground` du mod.

---

## 1. DÉCODAGE CANONIQUE — D04P01 (gs184, orée de Sinister Woods)

### Acteurs (positions demi-tuiles GBA → pixels ×8)
| Entité | kind | Position GBA (demi-tuile) | Pixel | Rôle |
|---|---|---|---|---|
| héros | 0 | (26,24) | (208,192) | héros |
| partenaire | 34 | (30,24) | (240,192) | partenaire |
| effet | — | (28,22) | (224,176) | effet de sol |

### Chorégraphie g1 (1re visite) — script complet
1. `BGM_SWITCH(MUS_SINISTER_WOODS)` (→ *Mystifying Forest.ogg* dans New Era)
2. `{0x22 0x01 0x1e}` / `AWAIT_CUE(3)` / `{0x23 0x01 0x1e}` (entrée caméra)
3. `WAIT(30)`
4. `ALERT_CUE(6)` → partenaire : `CMD_UNK_93(4, TURN_10, 0)` (se tourne vers le héros)
5. `WAIT(20)`
6. **Partenaire — 3 messages (portrait, variantes par kind)** :
   « This is it. {NAME_2} is lost in these woods. » / « {NAME_3}'s crew should have a head start on us. » /
   « We'd better hurry. »
7. `ALERT_CUE(6)` → partenaire : `{0x53}` + `WALK_GRID(384, 1)` (marche vers le donjon)
8. Héros : `{0x23 0x3c}` + `{0x53}` + `WALK_GRID(384, 0)` (marche vers le donjon)
9. `ALERT_CUE(3)` → `NEXT_DUNGEON(30, SCRIPT_DUNGEON_SINISTER_WOODS)` → entrée donjon

**g2 (retour)** : partenaire — 3 messages « Let's move it, {NAME_0}! » / « …{NAME_2}'s team… » /
« Hurry! Chop, chop! » puis marche + donjon.

**Fonctions scéniques D04P01** : partenaire = *motivation/urgence* (le client est perdu, les autres
ont de l'avance) ; héros = *action* (s'élance) ; transition immédiate vers le donjon.

---

## 2. DÉCODAGE CANONIQUE — D04P02 (gs185, clairière)

### Acteurs
| Entité | kind | Position (demi-tuile) | Pixel | Rôle |
|---|---|---|---|---|
| 0 | 0 | (32,32) | (256,256) | héros |
| 1 | 34 | (37,32) | (296,256) | partenaire |
| 2 | 94 | (34,15) | (272,120) | **client/objectif** (victime, carapace durcie) |
| 3 | 91 | (34,24) | (272,192) | **Meanie meneur** (menace, « Owowowow… ») |
| 4 | 92 | (39,28) | (312,224) | Meanie 2 (réagit cue 9, sort dir 2) |
| 5 | 93 | (30,28) | (240,224) | Meanie 3 (réagit cue 10, sort dir 3) |
| 6 | 10 | (33,37) | (264,296) | membre recruté (tourne ouest→nord) |
| 7 | 11 | (36,37) | (288,296) | membre recruté (tourne ouest→nord) |
| 8 | 12 | (30,37) | (240,296) | membre recruté (immobile) |
| 9 | 13 | (39,37) | (312,296) | membre recruté (immobile) |
| effet | — | (34,30) | (272,240) | effet de sol |

### Chorégraphie g1 — protocole de cues (frames GBA)
| # | Fils principal (héros) | Cues | Acteurs parallèles |
|---|---|---|---|
| 1 | `BGM_SWITCH(MUS_IN_THE_DEPTHS_OF_THE_PIT)` | — | (musique d'ambiance donjon) |
| 2 | WAIT(30) | | |
| 3 | ALERT_CUE(8) | → lives3 | Meanie meneur : fanfare 457 (colère) + {0x56 0x47} + {0xde} |
| 4 | AWAIT_CUE(5) | ← lives3 | Meanie meneur : ALERT_CUE(5) |
| 5 | **MSG_NPC(3)** « Owowowow… You'll pay for this! Don't you forget it! » (portrait 3, émo 0x43) | | |
| 6 | WAIT(16) ; ALERT_CUE(8) ; ALERT_CUE(9) ; ALERT_CUE(10) | → lives3/4/5 | **les 3 Meanies sortent** : WALK_GRID(512, dir 1/2/3) + ALERT_CUE(5) |
| 7 | WAIT(10) ; ALERT_CUE(6) ; ALERT_CUE(11) | → lives1, lives6/7 | partenaire : SPINLEFT1→WEST ; membres : tournent ouest→nord |
| 8 | **Héros : ROTATE_TO(10, SPINLEFT1, WEST)** | | |
| 9 | AWAIT_CUE(5) (fin de sortie des Meanies) | | |
| 10 | WAIT(60) — **pause d'une seconde** | | |
| 11 | ALERT_CUE(6) ; ALERT_CUE(11) | → lives1, lives6/7 | partenaire : {0x53}+SPINLEFT1 (vers 0) ; membres idem |
| 12 | **Héros : ROTATE_TO(4, SPINRIGHT1, EAST)** | | |
| 13 | WAIT(30) | | |
| 14 | **Partenaire (portrait 1, émo 9)** : « Well, those pests are gone. Let's find {NAME_2}. » | | |
| 15 | WAIT(16) — **client** : « Um, excuse me… » | | |
| 16 | WAIT(16) ; ALERT_CUE(7) | → lives2 | client : WALK_GRID(256, 0) (s'approche) + ALERT_CUE(5) |
| 17 | ALERT_CUE(6) ; ALERT_CUE(11) | → lives1 | partenaire : NOTICE_FUNC (« ! ») + tourne vers client |
| 18 | **Héros : FANFARE 465 + NOTICE_FUNC (« ! ») + SPINLEFT1 vers 94 (client)** | | |
| 19 | WAIT_FANFARE2(465) ; AWAIT_CUE(5) | | |
| 20 | **Client (portrait 2, pos -3)** : « Did you maybe come looking for me? » | | |
| 21 | WAIT(16) ; ALERT_CUE(6) | → lives1 | partenaire : TURN_10→NORTHWEST (vers le client) |
| 22 | **Héros : ROTATE_TO(4, TURN_10, NORTHEAST)** (vers le client) | | |
| 23 | **Héros** : « You must be {NAME_2}. » / « Let's get you home. Caterpie was worried about you. » | | |
| 24 | WAIT(16) ; ALERT_CUE(7) | → lives2 | client : SMILE_START |
| 25 | **Client** : « Yay! » / « I was scared, so I kept my shell hardened…and waited and waited. » / « Thank you! » | | |
| 26 | ALERT_CUE(7) | → lives2 | client : fanfare 455 + SMILE_END + WAIT(10) + JUMP_HAPPY + WAIT(16) |
| 27 | ALERT_CUE(3) — fin (RET) | | |

### Fonctions scéniques D04P02
- **Meanie meneur** = menace/retraite (la confrontation a eu lieu avant l'arrivée) ;
- **Meanies 2-3** = soutien de la menace, fuite (3 directions) ;
- **Partenaire** = réaction (colère) → soulagement (« pests are gone ») ;
- **Héros** = enregistrement de la tension (pivots), puis intervention (notice « ! », se tourne vers le client) ;
- **Client** = victime apeurée → joie (sourire, saut) au sauvetage ;
- **Membres recrutés** = témoins (se tournent).

---

## 3. MAPPING CAST NEW ERA (canon New Era établi)

| Rôle GBA | Acteur GBA | Fonction | Acteur New Era | Notes |
|---|---|---|---|---|
| Meneur | Gengar (Meanies) | menace/retraite | **Adagio** (Team Dazzling) | 3 acteurs → 3 actrices (rivales, pas ennemies : arc ch6 établi, `team_dazzling_chapter6.md`) |
| 2e | Ekans | soutien | **Aria** | |
| 3e | Medicham | soutien | **Sonata** | |
| Client | carapace durcie (Chrysacier) | victime sauvée | **Chenipent** | victime : sauvetage déplacé dans le donjon (seg1 F16-F20) par le canon New Era |
| Héros/Partenaire | — | intervention/réaction | Héros/Partenaire New Era | conservés |

**Décision d'adaptation** (différence assumée vs canon) : dans le canon, les Meanies fuient déjà à
l'arrivée (la confrontation a eu lieu hors-champ) ; dans New Era, la Team Dazzling **rivalise** avec
l'équipe du héros pour la même mission (course au sauvetage) — même fonction de blocage/obstacle et de
rivalité, mais sans la violence des Meanies. Le point « client présent sur scène dans la clairière »
(canon) vs « Chenipent secouru dans les étages » (New Era) est signalé à l'arbitrage utilisateur (§6).

---

## 4. AUDIT DE L'IMPLÉMENTATION PRÉEXISTANTE (avant 2026-08-10)

| Élément | État avant | Verdict |
|---|---|---|
| Positions finales Dazzling (clairière) = marqueurs du ground (240,144)/(280,176)/(208,176) | praticables (vérifié) | OK |
| Positions finales D04P02 source (272,192)/(312,224)/(240,224) | toutes praticables sur le ground | OK (translatées de -32,-48 par recadrage, documenté dans le .rsground) |
| **Spawn Dazzling D04P01** (224,136)/(192,160)/(256,160) | **rows 10-20 SOLIDES** | **BUG R4** |
| **Spawn Dazzling D04P02** (240,80)/(280,96)/(208,96) | **rows 10-12 SOLIDES** | **BUG R4** |
| Sortie Dazzling D04P01 (224,96)/(192,104)/(256,104) | **SOLIDE** | **BUG R4** |
| Objet Dungeon_Entrance D04P01 | **ABSENT** (perdu en 79c48f9) | **BUG R1 — chapitre bloqué** |
| BGM : In the Depths of the Pit → Team_Dazzling_Theme | conforme à la bascule canonique | OK |
| Avancée groupée des 3 actrices avant 1re réplique (sub_8087144) | présente | OK |
| Pivot du héros pendant l'échange (SPINLEFT/WAIT 60/SPINRIGHT) | **ABSENT** | **BUG R5** (corrigé) |
| Déplacements/retours des membres recrutés | absents (pas de membres dans le parti à ce stade) | Écart assumé (documenté) |
| Victime sur scène (approche, sourire, saut) | absente (Chenipent hors-champ, sauvetage en donjon) | Écart narratif New Era — **arbitrage utilisateur** |

---

## 5. CORRECTIONS APPLIQUÉES (commit de ce document)

1. **R1-R3** : objets `Dungeon_Entrance` restaurés sur `gloomy_forest_entrance`,
   `palier_celeste`, `parvis_celeste` (perte systématique lors du remplacement des grounds
   canoniques 79c48f9/752e705).
2. **R4** : tous les slots Dazzling déplacés sur cellules praticables (vérification grille par
   grille, cf. registre maître §4) :
   - D04P01 (bande praticable rows 24-31) : héros (208,248), partenaire (248,248),
     Adagio (224,216), Aria (192,224), Sonata (256,224), écarts (176,224)/(272,224),
     sortie (224,200)/(192,200)/(256,200) — lisière puis fondu.
   - D04P02 (clairière rows 14-45) : spawns lisière (240,120)/(280,136)/(208,136),
     finales inchangées.
3. **R5** : battement canonique du pivot du héros (gauche → pause → droite) ajouté après GF6E_A12,
   partenaire à gauche, avant la bascule sérieuse.
4. Commentaires de position corrigés (l'ancien commentaire annonçait des positions canoniques
   non utilisées et une praticabilité fausse).

## 6. TEST DE FIDÉLITÉ (état après correction — validation runtime REQUISE)

| Critère | État | Détail |
|---|---|---|
| CHOREOGRAPHY MATCH | **PARTIAL** | entrée groupée, blocage, sortie, pivots héros/partenaire OK ; sortie des 3 actrices vers la lisière (au lieu de 3 directions) ; membres recrutés absents |
| CAMERA MATCH | **PARTIAL** | MoveCamera (224,224) D04P01 / (240,160→240,192) D04P02 ; pas de pan canonique supplémentaire |
| ANIMATION MATCH | **PARTIAL** | CharAnimateTurnTo, CharTurnToCharAnimated, émotions OK ; animations GBA {0x2d}/{0x56}/{0x53} non transposées 1:1 (idiomes PMDO) |
| TIMING MATCH | **PARTIAL** | WAIT(30)/WAIT(16)/WAIT(60)/WAIT(10) transposés en frames ; les pauses d'affichage dialogue suivent le moteur |
| VFX MATCH | **PARTIEL** | NOTICE_FUNC (« ! ») transposé en CharSetEmote 'exclaim' ; flashs absents (pas de flash dans la source D04) |
| AUDIO MATCH | **PARTIEL** | BGM conforme ; fanfares GBA 455/457/465 → aucun équivalent PMDO identifié (REQUIRES_ASSET si souhaité) |
| DIALOGUE MATCH | **ADAPTÉ** | 9 boîtes GF6E_A04-A12 recastées ; les 3 messages D04P01 existent en GF6E_A01/A02+ ; dialogues du client remplacés par la trame Chenipent (canon New Era) |
| GROUND MATCH | **OK** | D04P01/D04P02 1:1 (collision, positions, marqueurs) |
| NARRATIVE MATCH | **ADAPTÉ** | rivalité Dazzling vs menace Meanies (canon New Era ch6) ; à arbitrer (§6) |

**Statut global : PARTIAL — validation RUNTIME requise avant tout « COMPLETE ».**

---

## 7. FICHIERS SOURCES CONSERVÉS (traçabilité)

`/home/user/V4/sources/pmd_red/` : `ground_data_d04p01_station.h`, `ground_data_d04p02_station.h`,
`ground_data_d03p01_station.h`, `ground_data_d05p01_station.h`, `ground_data_d13p01_station.h`,
`ground_data_d13p02_station.h`, `ground_lives.c/.h`, `GroundMap.cs` (moteur), `GroundObject.cs`.
