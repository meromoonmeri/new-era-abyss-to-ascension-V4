# BLUE_TO_PMDO — Spécification de référence de la retransposition
# Pokémon Mystery Dungeon: Blue Rescue Team (NDS, APHP) → PMDO / RogueEssence 0.8.12

**Version du document :** 1.0 — 2026-08-10
**Source de vérité (unique) :** `https://github.com/meromoonmeri/POKEMON-ROM`
→ `Pokemon Mystery Dungeon - Blue Rescue Team (Europe) (En,Fr,De,Es,It).nds`
**Hashes de la source :**

| Propriété | Valeur |
|---|---|
| SHA-256 ROM | `2540966e1e9cd722bf2ae401069df10b81875af03f0618d413b9d32511c14b05` |
| Gamecode / Makercode | `APHP` / `01` |
| Taille | 33 554 432 octets (32 MiB) |

**Règle d'or :** aucune hypothèse présentée comme un fait ; aucune conversion PMDO
tant que la donnée source ou sa correspondance sémantique n'est pas prouvée ;
tout élément non démontré reste `UNKNOWN` (jamais remplacé par une valeur plausible).

**Statuts utilisés dans ce document :** `PROVEN` (octets ROM démontrés),
`ADAPTED/PROVEN` (correspondance PMDO démontrée), `PARTIAL` (partiellement décodé),
`UNKNOWN` (non décodé), `BLOCKED` (bloqué par une différence architecturale ou un
format non décodé).

---

## 1. Architecture complète : NDS → données décodées → adaptation PMDO

```
ROM APHP (32 MiB)
├─ En-tête NDS « POKE DUNGEON » (FNT @0x40, FAT @0x48)        [PROVEN]
├─ FAT : 169 entrées {u32 start, u32 end}                     [PROVEN]
│  ├─ entrées 0..144 : code ARM9/ARM7 + overlays              [PROVEN — non analysé]
│  └─ entrées 145..168 : fichiers nommés (FNT plat, base=145) [PROVEN]
│     ├─ dungeon.sbin  (804 entrées, pack nommé)              [PROVEN]
│     │  ├─ mapparam (SIR0)                                   [PROVEN — tables SW décodées]
│     │  ├─ b{NN}{fon,cel,cex,canm,pal} × 130 tilesets        [fon/cel/cex/pal PROVEN, canm PARTIAL]
│     │  ├─ zmappat, trappat, talkp*, items, …                [inventaire PROVEN]
│     ├─ ground.sbin  (724 entrées : A01P01, B10P01*, …)      [inventaire PROVEN — format UNKNOWN]
│     ├─ sound.sbin   (SDAT)                                  [PROVEN — chaîne SEQ complète]
│     ├─ monster.sbin (16,6 Mo : sprites/animations Pokémon)  [inventaire PROVEN — format UNKNOWN]
│     ├─ system.sbin  (polices)                               [inventaire PROVEN]
│     ├─ message_{e,f,g,i,s}.bin/.str (dialogues 5 langues)   [PARTIAL]
│     └─ effect.sbin, ornament.sbin, sample.sbin, titlemenu…  [inventaire PROVEN]
└─ Décompression : SIR0, AT4PX/PX                              [PROVEN, byte-à-byte]

Cible PMDO 0.8.12 (moteur RogueEssence, source vérifiée RogueCollab/RogueEssence)
├─ Data/Zone/<id>.json      — zones de donjon (Segments + GenSteps)
├─ Data/Ground/<id>.rsground— Grounds (tiles, obstacles, entités, marqueurs)
├─ Data/Map/<id>.rsmap      — maps d'arène/combat
├─ Data/Tile/*.json + Content/Tile/*.png — tilesets dynamiques et statiques
├─ Data/Script/<ns>/…       — scripts Lua des grounds/cinématiques
├─ Content/Music/*.ogg      — musiques avec boucles
├─ Content/Chara|Portrait|Particle|BG|Item|UI… — assets
└─ Mod.xml                  — déclaration du mod
```

**Outils utilisés :** `nds2pmdo` v0.1.0 (modules `rom/` extraction+SIR0+AT4PX+pack,
`blue/` mapparam+graphics+sdat, `audit.py`, `decode.py`, `render.py`, `proofs.py`,
`report.py`) ; références croisées : source RogueEssence (RogueCollab/RogueEssence,
sha d9565606…) — étiquetées `CROSS_REFERENCE`, jamais présentées comme extraites de la ROM.

**Commandes de reproduction (dans le dépôt convertisseur `nds2pmdo/`) :**
```bash
python -m nds2pmdo extract            # ROM → extracted/ (fs + dungeon_pack + ground_pack)
python -m nds2pmdo decode             # extracted/ → decoded/ (mapparam, graphics, sdat, ground)
python -m nds2pmdo audit --json       # gates de fidélité → validation/audit_report.json
python -m nds2pmdo render             # feuilles de tiles → validation/renders/
python -m nds2pmdo proofs             # preuves visuelles → docs/blue_to_pmdo/
python -m nds2pmdo report             # rapport de couverture → validation/coverage_report.*
python -m pytest nds2pmdo/tests/      # tests (20) — reproductibles sans ROM
```

---

## 2. Règles de conversion spatiale

### 2.1 Modèle PMDO (vérifié dans la source RogueEssence)
- **GroundMap** : `Width/Height` en tuiles ; `TileSize = TexSize * GraphicsManager.TEX_SIZE`
  (TEX_SIZE = 8 px) ; `GroundWidth/Height` = pixels ; positions d'entités en **pixels**
  (`Position` = `Collider.Start`, coin supérieur-gauche) ; direction `Dir8`.
- **Donjon** : `MapGenContext` — grille en tuiles ; `Loc` = case de grille ;
  `PostProcGrid[loc.X][loc.Y]` ; `GenEntrances[i].Loc` / `GenExits` ; génération par
  `GenSteps` (GridFloorGen + étapes de plan, salles, couloirs, bordures…).
- **Collision Ground** : AABB grid (`obstacles` = rectangles `Bounds` + `Tags`) ;
  les cases non marchables sont des obstacles rectangulaires, pas des bits de tile.
- **Caméra** : `ViewCenter` / `ViewOffset` (pixels).

### 2.2 Modèle NDS Blue — état réel
- **Étages de donjon** : générés procéduralement (pas de tilemap statique) ;
  les paramètres sont dans `FloorProperties` (28 B × entrée) — **PROVEN** pour
  Sinister Woods (indices 17..29) : layout, roomDensity, enemyDensity, trapDensity,
  itemDensity, monsterHouseChance, kecleonShopChance, buriedItemDensity,
  allowDeadEnds, numExtraHallways, visibilityRange, …
  L'**algorithme** de génération (code ARM9) n'est **pas** extrait → la reproduction
  géométrique exacte (dimensions de salles, largeurs de couloirs, grille) est
  `UNKNOWN/BLOCKED` : PMDO génère avec ses propres GenSteps.
- **Grounds (villes/cinématiques)** : packages `ground.sbin` — format **non décodé**
  → toute donnée spatiale (positions, entités, caméra) est `UNKNOWN/BLOCKED`.
- **Origine des coordonnées / axes NDS** : non vérifiable tant que le format des
  packages n'est pas décodé → `UNKNOWN`. Aucune coordonnée NDS ne sera copiée dans
  PMDO sans démonstration préalable de son repère (procédure : décoder un package
  connu, y repérer une entité de référence, confronter avec un rendu connu).

### 2.3 Règles de transposition
1. **Jamais de copie brute** d'une coordonnée NDS vers PMDO : les repères
   (pixels vs cases, origine, orientation Y) doivent être démontrés puis convertis
   par une transformation écrite et testée (fonction de conversion unique, testée).
2. **Dimensions de grille** : vérifier que `Width/Height` PMDO = dimensions du
   rendu canonique ; interdiction de crop/étirement/changement de dimensions
   silencieux (validation visuelle + test).
3. **Tuiles 8×8 NDS** : PMDO utilise aussi 8 px/tuile (TEX_SIZE) → pas de
   ré-échantillonnage ; le rendu doit être pixel-identique à la source.

---

## 3. Règles de collision

- NDS : modèle de collision des étages/grounds **non démontré** (code/géométrie)
  → `UNKNOWN` pour l'instant.
- PMDO : obstacles = rectangles (`Bounds` + `Tags`) sur les Grounds ; `UnbreakableBorderStep`
  pour les bordures de donjon ; `TileSpawnStep`/`MapTextureStep` pour le terrain.
- **Règle** : une case « mur » NDS devra être traduite en obstacle PMDO couvrant
  exactement la même surface (pas une case de plus ni de moins) ; les zones
  marchables/non-marchables, bordures et escaliers seront validées case par case
  par comparaison de cartes de collision (voir §Validation).

---

## 4. Règles de markers / entrances / exits

- **PMDO (vérifié)** : `GroundMarker` = entité nommée `{name, Loc pos, Dir8 dir}` ;
  API `GetMarker(name)`, `GetMarkerPosition(name)`, `GetEntryPoint(name/idx)`
  (LocRay8 = position + direction). Les noms `Main_Entrance_Marker`,
  `Dungeon_Entrance`, `Exit` sont des **conventions de scripts PMDO** (PMDC),
  pas des données NDS.
- **NDS** : les points d'entrée/sortie des grounds vivent dans les packages
  `ground.sbin` (non décodés) → `BLOCKED`. Pour les donjons, les escaliers/entrées
  sont générés par l'algorithme → `UNKNOWN`.
- **Règle** : lors du décodage d'un package, chaque point de spawn/entrée/sortie
  NDS sera transformé en `GroundMarker` nommé selon la convention PMDO, avec la
  direction conservée, et validé par position.

---

## 5. Règles de spawns (Pokémon / NPC)

- **Donjons — PROVEN (Sinister Woods)** : `SpawnPokemonData` (8 B/entrée, Blue) :
  `bits` (species = bits & 0x1FF, level = (bits >> 9) & 0x7F), `s16 weight0`,
  `s16 weight1`, terminateur KECLEON poids nuls. 13 tables d'étage extraites,
  concordance byte-à-byte avec les artefacts committés.
  - Noms d'espèces : `CROSS_REFERENCE` (pmd-red via artefacts) ; la table de noms
    de la ROM (`monster.sbin`/message) est `NOT_DECODED` (pas encore localisée).
  - **Formule poids → probabilité** : `UNKNOWN` (deux poids par entrée ; sémantique
    à démontrer) — interdiction de la remplacer par une formule inventée.
  - Traduction PMDO : étapes de spawn PMDO (`MobSpawnStep`/spawners) —
    `ADAPTATION_REQUIRED` : species/level sont DIRECTS, la distribution de poids
    nécessite un mapping documenté une fois la formule démontrée.
- **NPC de Ground** : packages non décodés → `BLOCKED`.

---

## 6. Règles objets / pièges

- **Items — PARTIAL/PROVEN partiel** : flux u16 des tables d'items (mapparam
  @0x28978) : marqueurs de catégorie `0x7500+cat` + **poids cumulés** par catégorie,
  terminator `0x753F` ; tables 11/12 pour Sinister Woods ; frontières de poids
  concordantes avec pmd-red (`CROSS_REFERENCE`).
  - **IDs des items par catégorie : UNKNOWN** (absents du flux — probablement
    référencés depuis le code) → la conversion des items est `BLOCKED` tant que
    ce n'est pas démontré.
- **Pièges — PARTIAL** : u16[20] par table ; Sinister Woods = table 2,
  `index 17 = 10000` (seul piège). **Nom du piège 17 : UNKNOWN** (la constante
  pmd-red serait CROSS_REFERENCE).
- **Objets enterrés / boutiques Kecleon / maisons de monstres** : champs
  `buriedItemDensity`, `kecleonShopChance`, `monsterHouseChance`, `itemlessMonsterHouseChance`
  — **PROVEN** (SOURCE_NDS) ; leur traduction vers les GenSteps PMDO correspondants
  est `ADAPTATION_REQUIRED` (mapping documenté, pas de copie brute).

---

## 7. Règles caméra

- PMDO : `ViewCenter`/`ViewOffset` (Grounds) ; donjons : vue fenêtrée gérée par le
  moteur. RogueEssence n'a pas de « points caméra » nommés dans les données Ground
  (la caméra est pilotée par script) → les éventuels points caméra NDS devront être
  traduits en appels de script PMDO (`ADAPTATION_REQUIRED`).
- NDS : données caméra dans les packages ground (non décodés) → `BLOCKED/UNKNOWN`.

---

## 8. Règles tiles / palettes / cellules

Chaîne graphique **PROVEN** (Sinister Woods, blobs b41 et b10) :

| Blob | Structure décodée | Statut |
|---|---|---|
| `fon` | motifs 8×8, 4 bpp (32 B/tile) — b41 : 415 tiles, b10 : 416 | PROVEN (AT4PX byte-à-byte) |
| `cel` | u16/cell : bits 0-9 tile, bits 14-15 palette (0-2), bits 10/12/13 flags | PROVEN (2250 cells) — sémantique des flags UNKNOWN |
| `cex` | comportements étendus (u16) | PROVEN (décompressé) — sémantique UNKNOWN |
| `pal` | 768 B = 384 u16 BGR555 en paires (couleur, couleur\|0x8000) → 192 couleurs distinctes ; sous-palettes 12×16 via cel | PROVEN |
| `canm` | SIR0, main = 16 offsets → entrées 68 B {u16,u16,16×u32} | PARTIAL — sémantique UNKNOWN |

**Règles :**
1. **Conversion BGR555 → RGB888** : `(v & 0x1F) << 3` par canal — exacte, sans
   perte de luminosité/saturation ; la paire (couleur, couleur|0x8000) est réduite
   à 192 couleurs distinctes (le bit 15 est un flag de variante, pas une couleur).
2. **Pas de réduction de palette** : aucune quantification ; la palette PMDO devra
   contenir les 192 couleurs (ou les sous-palettes 16 couleurs telles quelles).
3. **Mapping tile/cell/palette** : la palette d'un tile est déterminée par SA CELLULE
   (bits 14-15), pas par le tile seul → le rendu PMDO devra reproduire ce mapping.
4. **Flips/flags** : les flags de cellule (bits 10/12/13) sont conservés dans le
   décodage ; leur traduction (flips horizontaux/verticaux ? priorité ?) est
   `UNKNOWN` tant que la sémantique n'est pas démontrée.
5. **Aucun tile noir / transparent par erreur** : un index 0 est une vraie couleur
   de la palette (jamais un substitut) ; toute ressource absente déclenche une
   erreur documentée (`MISSING`), jamais un noir.
6. **Dimensions finales PMDO** : feuille de tiles exacte (415/416 tiles) ; un
   Ground PMDO doit occuper l'écran comme l'original (vérifié par rendu de
   comparaison).

**Preuves visuelles :** `docs/blue_to_pmdo/tilesets/*.png`, `palettes/*.png`,
`cells/*.png`, `comparisons/b10_vs_b41_tilesets.png` — tous générés depuis les
données décodées (voir `manifests/provenance_manifest.json`).

---

## 9. Règles animations et `canm`

- **État** : `canm` décompressé en structure (SIR0, 16 entrées de 68 octets) —
  **sémantique UNKNOWN** : ni frames, ni durées, ni boucles ne peuvent être
  affirmés. Le fait d'avoir décodé la forme ne constitue PAS une preuve de
  sémantique.
- **Procédure de démonstration requise** : (1) croiser avec un tileset dont
  l'animation est connue visuellement (eau/lave) ; (2) identifier quelles entrées
  canm référencent quelles cells ; (3) reproduire le cycle en PMDO (tiles animés
  via `Data/Tile/*.json` — ex. `flowing_lava.json`) ; (4) valider frame par frame.
- **Règle** : aucune animation PMDO ne sera générée à partir de canm avant cette
  démonstration ; l'absence d'animation sera signalée `UNKNOWN`, jamais remplacée
  par un rendu statique silencieux.
- Les animations de tilesets PMDO existent (`Data/Tile/` : eau, lave, escaliers)
  — leur correspondance avec les tiles NDS sera établie tile par tile.

---

## 10. Règles musique / SDAT / SEQ — **PROVEN**

Chaîne complète démontrée (sound.sbin, SDAT) :

| Élément | Valeur | Statut |
|---|---|---|
| Fichiers SDAT | 186 entrées FAT : 98 SSEQ + 83 SBNK + 4 SWAR + 1 SSAR | PROVEN |
| Section SEQ | 220 index, **122 trous conservés** (offset=0), 98 réels | PROVEN |
| Record SEQ | `{u32 file_id, u16?, u16?, u16?, u16?}` (12 B) ; file_id → FAT → SSEQ | PROVEN (magics vérifiés) |
| Noms SEQ | pool SYMB aligné sur les trous — reproduit exactement `sdat_seq_names.json` | PROVEN |
| Section BANK | 301 index, 218 trous, 83 réels → SBNK | PROVEN |
| STRM / WAVE / GRP / PLAYER | 1 SSAR / 4 SWAR / 6 groupes / 1 player | PROVEN (structure) — sémantique des champs PARTIAL |
| Mapping `bgMusic` → SEQ | table dans le code ARM9 | **UNKNOWN** — candidats : SEQ 4 (`EVENT_DREAM_01`), SEQ 15 (`DUNGEON_AYASHIIMORI_01`) — non démontrés |
| Boucles SSEQ | headers SSEQ non parsés | UNKNOWN |

**Règles :**
1. Les **index SEQ ne seront jamais compactés** : les trous (47-49, 53-99, …) sont
   des données ; un futur mapping PMDO conservera l'indexation ou documentera le
   changement.
2. La musique PMDO = OGG avec boucle : la conversion SSEQ → OGG devra conserver
   les points de boucle une fois ceux-ci démontrés.
3. Le champ `Music` des zones PMDO (`MapDataStep`) ne sera renseigné que lorsque
   `bgMusic → SEQ` sera prouvé (procédure : analyse statique du code ARM9 ou test
   runtime avec émulateur).
4. Fichiers SSEQ/SBNK/SWAR/SSAR extraits : `nds2pmdo/decoded/sound/files/`.

**Preuves :** `decoded/sound/sdat.json` (chaîne complète), `music/` (manifest),
test `test_sdat_chain_file_ids_are_sseq`.

---

## 11. Règles cinématiques

- **Inventaire NDS (PROVEN)** : packages `B10P01A/B/C` (664/724/664 B) et
  `B10P02A/B/C` (+1972 B pour A) dans `ground.sbin` — structure de blocs
  `{u32 count, u32…}` avec plages de couleurs 24-bit possibles.
- **Décodage : BLOCKED/UNKNOWN** — ni Ground, ni caméra, ni positions, ni
  déplacements, ni timing, ni dialogues de cinématique ne sont extractibles
  aujourd'hui. Aucune « frame » de cinématique ne sera produite.
- **Règle** : une cinématique Blue sera reconstruite comme **séquence temporelle**
  PMDO (scripts Lua + entités + marqueurs + transitions + dialogues) uniquement
  quand le format des packages sera décodé ; les données issues de la ROM seront
  séparées des adaptations de script (mapping `DIRECT`/`ADAPTATION` par élément).
- Les dialogues des cinématiques : `message_*.bin/.str` (PARTIAL — mécanisme
  d'offsets identifié, frontières des messages à documenter).

---

## 12. Règles VFX / particules

- NDS : `effect.sbin` (1,1 Mo, inventaire PROVEN — format UNKNOWN) ; particules de
  combat/donjon non décodées.
- PMDO : `Content/Particle/` + `Data/Status` etc. — équivalents existants.
- **Règle** : aucun VFX ne sera déclaré converti ; inventaire = PROVEN, contenu =
  UNKNOWN ; la stratégie (une fois décodé) : mapping vers les particules PMDO
  natives, jamais de moteur parallèle.

---

## 13. Règles scripts / événements

- NDS : scripts de ground/événements vivent dans les packages `ground.sbin`
  (`B10P01*`…) — **UNKNOWN/BLOCKED** ; scripts de donjon = code ARM9 (algorithmes)
  — non extractibles en données.
- PMDO : scripts Lua (`Data/Script/<ns>/`), GenSteps JSON pour les donjons.
- **Règle** : la génération de scripts PMDO sera data-driven (depuis les données
  décodées) et non écrite à la main ; chaque script généré portera sa provenance.

---

## 14. Règles dialogues et progression narrative

- **Mécanisme NDS (PROVEN)** : `message_*.str` = table u32 (42 902 entrées pour
  l'anglais) d'offsets dans `message_*.bin` (pool de chaînes, codes `#C`, `#R`,
  `\n`). **Frontières exactes des messages : PARTIAL** (à documenter).
- **Ordre des scènes / progression** : porté par les scripts (ground/donjon) —
  UNKNOWN.
- **Règle** : la conversion Blue → PMDO ne devra détruire aucune information
  narrative : chaque message extrait conservera son index source ; les enchaînements
  seront reconstruits depuis les scripts une fois ceux-ci décodés.

---

## 15. Limitations connues de PMDO (vérifiées dans la source RogueEssence)

1. Pas de format « scène de cinématique » natif : les cinématiques sont des
   Grounds + scripts Lua (GroundMap + GroundEntity + GroundMarker + coroutines).
2. Pas de « points caméra » en données : la caméra est pilotée par script
   (`ViewCenter`/`ViewOffset`).
3. La génération de donjon est un pipeline de GenSteps différent de l'algorithme
   NDS : la reproduction géométrique est paramétrique, pas algorithmique.
4. Les animations de tileset PMDO sont des tiles dynamiques (`Data/Tile`), pas un
   système canm : conversion par mapping tile→animation.
5. L'audio PMDO = OGG (pas de SSEQ) : conversion + boucles nécessaires.
6. Les marqueurs sont des conventions de script nommées (pas de type natif
   « entrance »).

---

## 16. Adaptations nécessaires (résumé NDS ↔ PMDO)

| Domaine | Type d'adaptation |
|---|---|
| Géométrie de donjon | paramètres PROVEN → GenSteps (mapping documenté) |
| Spawns | species/level DIRECT ; distribution poids → mapping (formule à démontrer) |
| Items/pièges | IDs UNKNOWN → BLOCKED |
| Tiles/palettes/cells | rendu exact ; flips → sémantique à démontrer |
| canm | sémantique à démontrer → tiles dynamiques PMDO |
| Musique | SSEQ → OGG+boucle ; bgMusic→SEQ à démontrer |
| Grounds/cinématiques | packages à décoder → Grounds + scripts Lua |
| Marqueurs | spawns NDS → GroundMarker nommés (conventions PMDO) |
| VFX | effect.sbin à décoder → particules PMDO natives |

---

## 17. Manifeste de provenance complet

Voir `docs/blue_to_pmdo/manifests/provenance_manifest.json` (preuves visuelles) et
`nds2pmdo/manifest/sinister_woods_mapping.json` (mapping donjon). Règles :
`SOURCE_NDS`, `SOURCE_NDS_DECODED`, `CROSS_REFERENCE`, `DERIVED_MAPPING`,
`PMDO_VALUE`, `UNKNOWN`, `MISSING`, `NOT_DECODED`, `ADAPTATION_REQUIRED`.
La ROM n'est jamais copiée dans le dépôt (pointeur `source/ROM.pointer`).

---

## 18. Matrice NDS → PMDO

Voir `docs/blue_to_pmdo/matrices/nds_to_pmdo_matrix.csv` — colonnes :
`NDS SOURCE | STRUCTURE DÉCODÉE | SÉMANTIQUE ORIGINALE | ÉQUIVALENT PMDO |
TRANSFORMATION NÉCESSAIRE | VALIDATION | STATUT`.

Statuts : PROVEN (structure+données), ADAPTED/PROVEN (correspondance PMDO
démontrée), PARTIAL, UNKNOWN, BLOCKED.

---

## 19. Statut de chaque élément (synthèse)

| Ressource | Compteur | Statut global |
|---|---|---|
| Étages Sinister Woods (paramètres) | 13/13 | PROVEN |
| Tables de spawns | 13/13 | PROVEN (noms CROSS_REFERENCE) |
| Tables d'items | 2/2 | PARTIAL (poids PROVEN, IDs UNKNOWN) |
| Tables de pièges | 1/1 | PARTIAL (poids PROVEN, nom UNKNOWN) |
| Tilesets (fon/cel/cex/pal) | b41, b10 | PROVEN (flags/cex sémantique UNKNOWN) |
| canm | 2 | PARTIAL (forme) / UNKNOWN (sémantique) |
| SEQ (musiques) | 220 idx (98 réels) | PROVEN (chaîne complète) |
| bgMusic → SEQ | 1 | UNKNOWN |
| Grounds (packages) | 724 (B10P01* = 6) | BLOCKED (format non décodé) |
| Cinématiques | 6 packages SW (B10P01*/B10P02*) | BLOCKED (packages non décodés) |
| Dialogues | 5 langues | PARTIAL |
| VFX/particules | effect.sbin | UNKNOWN (inventaire PROVEN) |
| Sprites Pokémon | monster.sbin | UNKNOWN (inventaire PROVEN) |
| Conversion PMDO | — | **BLOQUÉE** (gates) |

---


## 21. Index visuel des Grounds (preuves PNG par Ground)

Le pipeline `nds2pmdo produce_grounds` décode chaque ground Blue (triplet
palette `P` + tiles/chunks `Pc` + map/collision `Pm`) et génère, pour chaque
ground décodable, un dossier de preuves :

```
docs/blue_to_pmdo/grounds/<GROUND_ID>/
├── source_tiles.png     — feuille des tiles 4bpp (palette 0)
├── layer_0.png          — rendu de la couche 0 (et layer_1 si 2 couches)
├── composite.png        — rendu composite final (couches empilées)
├── collision.png        — carte de collision (rouge = bloqué)
├── animation_frames/    — frames d'animation (si BPA actif — aucun détecté à ce jour)
└── report.json          — fiche de conformité (chiffres + statut + provenance)
```

Catalogue visuel : `docs/blue_to_pmdo/grounds_index/all_grounds_contact_sheet.png`
+ `index.csv` (Ground ID → dimensions → layers → tiles → chunks → collision →
statut → chemin du composite).

### Décompte (généré par le pipeline)

| Statut | Nombre |
|---|---|
| Grounds découverts | 187 |
| **FULL** (tiles + chunks + layers + collision rendus) | 69 |
| PARTIAL (tiles 100 % décodées, chunks non reconstruits) | 40 |
| BLOCKED (format spécial non décodé) | 78 |
| Tiles décodées | 58 307 / 58 307 (100 %) |
| Chunks décodés | 10 557 / 19 378 |

### Fiche de conformité par Ground (report.json)

Chaque `report.json` contient : `Ground ID`, `source_files`/`source_offsets`/
`sha256` (provenance exacte), `Tiles attendues (header nt-1)`, `Tiles décodées`,
`Layers attendues/décodées`, `Chunks attendus (nc-1)`, `Chunks décodés`,
`BPA (animations)`, `Collision`, `Dimensions`, `Markers` (UNKNOWN — non stockés
dans ces fichiers), `status` (FULL/PARTIAL/BLOCKED), et les réponses explicites :
- `question_textures_completes` : PASS / FAIL / PARTIAL
- `question_frames_canoniques` : PASS / UNKNOWN

**Règle** : `GROUND_COMPLETE` n'est déclaré que si toutes les textures ET toutes
les frames attendues sont décodées et rendues. Un composite visuellement correct
avec des chunks manquants reste `PARTIAL` (ex. A01P01 — Pokémon Square, map à
2 couches : tiles 474/474 ✓, tilemap en cours de déchiffrage).

### Comparaison NDS → PMDO

Pour les grounds convertis en PMDO (phase 2, après validation des gates) :
`blue_source.png | pmdo_render.png | difference.png | overlay.png` +
`pixel_match % / tile_match % / collision_match % / layer_match % / frame_match %`.
Aucun ground PMDO n'est généré tant que la fiche source n'est pas FULL.

### Formats non encore décodés (BLOCKED, documentés)

- Palettes à en-tête spécial (u16 count + données) : S02_FRE, T01P01, H29P01…
- Fichiers `c` avec nt=1 (variantes d'animation ?) : W03P01c…
- Fichiers `P` de grande taille avec données annexes (positions d'entrée ?
  musique ?) : à décoder.

## 20. Tests de validation et critères de non-régression

**Tests (20, `pytest`, reproductibles sans ROM) :**
1. AT4PX : reproduction byte-à-byte des 6 artefacts committés (b10/b41 fon/cel/cex).
2. Palette : 768 B identiques au ground truth.
3. Pack : parse des entrées nommées (synthétique + ROM si présente).
4. mapparam : floor_id / FloorProperties / spawns identiques aux ground truth.
5. Items/pièges : blobs identiques (sha256) aux artefacts committés.
6. SDAT : noms SEQ alignés (trous compris) = ground truth ; chaîne file_id → SSEQ.
7. Provenance : interdiction des valeurs inventées ; aucun placeholder dans decoded/.

**Critères de non-régression :**
- Toute nouvelle extraction doit reproduire les SHA-256 committés (fixtures).
- Un statut ne passe de UNKNOWN à PROVEN que si la preuve (octets ROM + test)
  est committée avec lui.
- Aucun Ground PMDO définitif ne sera généré pour « faire avancer le compteur » :
  `gloomy_forest.json` et les contenus New Era restent intouchés tant que les
  gates Blue → PMDO ne sont pas satisfaites.
