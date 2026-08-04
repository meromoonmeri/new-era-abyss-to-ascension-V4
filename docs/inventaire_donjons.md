# INVENTAIRE CENTRAL DES DONJONS (Source de Vérité Unique)

**Projet** : *New Era : Abyss to Ascension* (moteur RogueEssence / PMDO)  
**Rôle** : Répertoire unique des donjons d'histoire et secondaires (Chapitres 6 à 32), consignant nom, chapitre, rang narratif, structure, biomes, mini-boss, légendaires, bestiaire, objets, marchand Kecleon et musique.  
**Règle du Framework (§9)** : Chaque chapitre secondaire est **d'abord listé et présenté pour validation** ci-dessous avant toute génération détaillée de fichiers `.json` ou `.lua`.

---

## 1. DONJONS PRINCIPAUX D'HISTOIRE (CHAPITRES 6 À 10 — VALIDÉS)

| Chapitre | Identifiant (`ID`) | Nom Français | Étages / Segments | Relais / Checkpoints | Boss Final (Arène `.rsmap`) | Mini-Boss | Musique Principale |
| :---: | :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| **Ch 6** | `gloomy_forest` | Forêt Lugubre | 26 ét. / 11 seg. | `gloomy_forest_relay` | **Zarude** (`gloomy_forest_boss`) | Shiftry & Nuzleaf (`gloomy_forest_miniboss`) | `Mystifying Forest.ogg` |
| **Ch 7** | `cloven_ruins` | Ruines Tordues | 24 ét. / 8 seg. | `cloven_ruins_midpoint` | **Regigigas** (`cloven_ruins_boss`) | Claydol & Golurk (`cloven_ruins_miniboss`) | `In the Depths of the Pit.ogg` |
| **Ch 8** | `crystal_sanctuary` | Sanctuaire de Cristal | 25 ét. / 6 seg. | `crystal_sanctuary_relay` | **Diancie** (`crystal_sanctuary_boss`) | Carbink & Froslass (`crystal_sanctuary_miniboss`) | `Crystal Crossing.ogg` |
| **Ch 9** | `forgotten_marsh` | Marais de l'Oubli | 25 ét. / 6 seg. | `forgotten_marsh_relay` | **Laggron / Swampert** (`forgotten_marsh_boss`) | Swalot & Toxicroak (`forgotten_marsh_miniboss`) | `Cave Camp.ogg` |
| **Ch 10** | `celestial_peak` | Pic Céleste | 44 ét. / 6 seg. | `celestial_peak_relay` | **Lugia** (`celestial_peak_boss`) | Escouade Fulgur (`celestial_peak_fulgur`) | `Summit.ogg` |

---

## 2. CHAPITRE 6 — ROSTER DES DONJONS SECONDAIRES (GÉNÉRÉS & VALIDÉS)

> **État du processus (§9, Étape 3)** : Le roster des **4 donjons secondaires du Chapitre 6** a été **généré, mis en conformité et validé dans le moteur** (`Data/Zone/*.json`).  
> Tous les noms respectent la **Convention de Nommage (`[Lieu] + [Qualificatif]`)**, le **Scaling Évolutif sur 15 niveaux (`Lv 18-33`)** et la règle des **Relais modèle Tunnel Incandescent + Kangourex par biome**.

### 6.S1 — Désert des Oubliés (`forsaken_desert` / PMDODump)
- **Nommage original (§1–§6)** : `[Désert]` (Lieu) + `[des Oubliés]` (Qualificatif géographique/narratif). Aucun conflit avec l'inventaire ni avec la nomenclature officielle de la licence.
- **Chapitre & Rang narratif** : Chapitre 6 — Rang 30.
- **Étages & Segments** : 20 étages en **2 segments** de 10 étages (`RangeDictSegment` / `LayeredSegment`).
  - *Segment 1 (Ét. 1–10)* : Biome **Désert Ardent** (`furnace_desert_floor` / `wall`). Météo : *Tempête de sable* aux étages 4, 8 et 9 (§6.5).
  - *Segment 2 (Ét. 11–20)* : Biome **Vallée Stérile** (`barren_valley_floor` / `wall`). Météo : *Tempête de sable* à l'étage 18.
- **Scaling Évolutif (`Lv 18–33`, 15 niveaux d'écart)** :
  - *Segment 1 (Stade 1, Lv 18–24)* : Sabelette, Cacnea, Trapinch, Baltoy, Hippopotas, Skorupi.
  - *Segment 2 (Stade Évolué, Lv 25–33)* : Sablaireau, Cacturne, Vibrava, Claydol, Hippodocus, Drapion.
- **Points médians (Relais, toutes les 5 étages)** :
  - `forsaken_desert_relay.rsground` ➔ **Modèle Tunnel Incandescent avec statue Kangourex (`Kangaskhan_Rock`)**, `North_Exit` et `South_Exit`, adapté au biome **Désert Aride / Rocheux**.
- **Mini-Boss (3 par donjon, noms propres & musique dédiée)** :
  - *Ét. 6* : **Sablaireau l'Ancien** (Sandslash, Lv. 24) — Musique : `Boss Battle.ogg`.
  - *Ét. 12* : **Cacturne le Veilleur** (Cacturne, Lv. 28) — Musique : `Boss Battle.ogg`.
  - *Ét. 19* : **Hippodocus le Colosse** (Hippowdon, Lv. 32) — Musique : `Boss Battle 2.ogg`.
- **Légendaire** : *Aucun — Donjon d'exploration désertique secondaire (§2).*
- **Objets & Marchand Kecleon (§4.5, §4.6)** :
  - Patron de spawn : `ItemSpawnZoneStep` (calqué sur `PMDODump` `DataAsset/Zone/Forsaken_Desert.out.txt`). Pool : Orbes désertiques, Baies Oran, Graines Résurrection.
  - Marchand Kecleon : Spawn aléatoire (`probabilité 12 %` par étage dans le segment 2).

---

### 6.S2 — Crevasse de Géode (`geode_crevice` / PMDODump)
- **Nommage original (§1–§6)** : `[Crevasse]` (Lieu) + `[de Géode]` (Qualificatif minéral).
- **Chapitre & Rang narratif** : Chapitre 6 — Rang 31.
- **Étages & Segments** : 20 étages en **2 segments** de 10 étages.
  - *Segment 1 (Ét. 1–10)* : Biome **Grotte de Cristal** (`crystal_cave_1_floor` / `wall`).
  - *Segment 2 (Ét. 11–20)* : Biome **Caverne de Quartz** (`quartz_cavern_floor` / `wall`). Météo : *Brouillard électrostatique* aux étages 14 et 17.
- **Scaling Évolutif (`Lv 18–33`, 15 niveaux d'écart)** :
  - *Segment 1 (Stade 1, Lv 18–24)* : Racaillou, Roggenrola, Tarinor, Strassie, Galekid.
  - *Segment 2 (Stade Évolué, Lv 25–33)* : Gravalanch, Grolem, Géolithe, Gigalithe, Tarinorme, Ténéfix.
- **Points médians (Relais)** :
  - `geode_crevice_relay.rsground` ➔ **Modèle Tunnel Incandescent avec statue Kangourex (`Kangaskhan_Rock`)**, `North_Exit` et `South_Exit`, adapté au biome **Grotte de Cristal / Caverne de Quartz**.
- **Mini-Boss (3 par donjon)** :
  - *Ét. 7* : **Gravalanch du Filon** (Graveler, Lv. 24) — Musique : `Boss Battle.ogg`.
  - *Ét. 14* : **Tarinor la Boussole** (Nosepass, Lv. 28) — Musique : `Boss Battle.ogg`.
  - *Ét. 20* : **Gigalithe le Diamant** (Gigalith, Lv. 33) — Musique : `Boss Battle 2.ogg`.
- **Légendaire** : *Aucun (§2).*
- **Objets & Marchand Kecleon** : `ItemSpawnZoneStep` riche en Évolurocs et sphères de lumière. Marchand Kecleon aléatoire (`probabilité 15 %`).

---

### 6.S3 — Verger Sauvage (`wild_orchard` / ExplorersOfSkyOrigins)
- **Nommage original (§1–§6)** : `[Verger]` (Lieu) + `[Sauvage]` (Qualificatif atmosphérique/naturel).
- **Chapitre & Rang narratif** : Chapitre 6 — Rang 32.
- **Étages & Segments** : 20 étages en **2 segments** de 10 étages.
  - *Segment 1 (Ét. 1–10)* : Biome **Bois aux Pommes** (`apple_woods_floor` / `wall`).
  - *Segment 2 (Ét. 11–20)* : Biome **Sentier du Verger** (`orchard_path_floor` / `wall`). Météo : *Pluie* à l'étage 16.
- **Scaling Évolutif (`Lv 18–33`, 15 niveaux d'écart)** :
  - *Segment 1 (Stade 1, Lv 18–24)* : Chenipan, Aspicot, Ceribou, Cheniti, Apitrini.
  - *Segment 2 (Stade Évolué, Lv 25–33)* : Papilusion, Dardargnan, Scarhino, Scarabrute, Apireine, Ceriflor.
- **Points médians (Relais)** :
  - `wild_orchard_relay.rsground` ➔ **Modèle Tunnel Incandescent avec statue Kangourex (`Kangaskhan_Rock`)**, `North_Exit` et `South_Exit`, adapté au biome **Nature / Forêt (`Apple Woods`)**.
- **Mini-Boss (3 par donjon)** :
  - *Ét. 5* : **Scarhino la Corne** (Heracross, Lv. 24) — Musique : `Boss Battle.ogg`.
  - *Ét. 13* : **Scarabrute la Pince** (Pinsir, Lv. 28) — Musique : `Boss Battle.ogg`.
  - *Ét. 20* : **Apireine la Souveraine** (Vespiquen, Lv. 33) — Musique : `Boss Battle 2.ogg`.
- **Légendaire** : *Aucun (§2).*
- **Objets & Marchand Kecleon** : Abondance de Pommes d'Or et Baies Pecha. Marchand Kecleon aléatoire (`probabilité 10 %`).

---

### 6.S4 — Plaines Brûlées (`scorched_plains` / PMDODump)
- **Nommage original (§1–§6)** : `[Plaines]` (Lieu) + `[Brûlées]` (Qualificatif sensoriel/atmosphérique).
- **Chapitre & Rang narratif** : Chapitre 6 — Rang 33.
- **Étages & Segments** : 20 étages en **2 segments** de 10 étages.
  - *Segment 1 (Ét. 1–10)* : Biome **Plaines Électriques** (`amp_plains_floor` / `wall`).
  - *Segment 2 (Ét. 11–20)* : Biome **Plaines Arides** (`scorched_plains_floor` / `wall`). Météo : *Soleil ardent* à l'étage 15.
- **Scaling Évolutif (`Lv 18–33`, 15 niveaux d'écart)** :
  - *Segment 1 (Stade 1, Lv 18–24)* : Lixy, Wattouat, Dynavolt, Phanpy, Zébibron.
  - *Segment 2 (Stade Évolué, Lv 25–33)* : Luxio, Luxray, Lainergie, Pharamp, Élecsprint, Donphan.
- **Points médians (Relais)** :
  - `scorched_plains_relay.rsground` ➔ **Modèle Tunnel Incandescent avec statue Kangourex (`Kangaskhan_Rock`)**, `North_Exit` et `South_Exit`, adapté au biome **Plaines Arides / Savane Électrique**.
- **Mini-Boss (3 par donjon)** :
  - *Ét. 8* : **Luxio l'Éclair** (Luxio, Lv. 24) — Musique : `Boss Battle.ogg`.
  - *Ét. 15* : **Phanpy la Charge** (Phanpy, Lv. 28) — Musique : `Boss Battle.ogg`.
  - *Ét. 20* : **Élecsprint la Tempête** (Manectric, Lv. 33) — Musique : `Boss Battle 2.ogg`.
- **Légendaire** : *Aucun (§2).*
- **Objets & Marchand Kecleon** : Graines Éclair, Orbes Paralysie. Marchand Kecleon aléatoire (`probabilité 15 %`).

---

## 3. CHAPITRE 7 — PROPOSITION DU ROSTER DES DONJONS SECONDAIRES

> **État du processus (§9, Étape 2)** : Proposition formelle des **4 donjons secondaires du Chapitre 7** pour **validation utilisateur** avant génération des fichiers `.json` détaillés.  
> *Règle Légendaires (§2)* : Zéro légendaire gratuit dans ces donjons ; l'enjeu légendaire du Ch7 reste concentré sur **Regigigas et les 4 Régis** (`cloven_ruins`).

### 7.S1 — Jardin d'Énergie (`energy_garden` / PMDODump)
- **Nommage original (§1–§6)** : `[Jardin]` (Lieu) + `[d'Énergie]` (Qualificatif minéral/atmosphérique).
- **Chapitre & Rang narratif** : Chapitre 7 — Rang 34.
- **Étages & Segments** : 20 étages en **2 segments** de 10 étages.
  - *Segment 1 (Ét. 1–10)* : Biome **Grotte de Cristal** (`crystal_cave_1_floor` / `wall`).
  - *Segment 2 (Ét. 11–20)* : Biome **Caverne d'Énergie** (`quartz_cavern_floor` / `wall`). Météo : *Brouillard électrostatique* aux étages 14 et 18.
- **Scaling Évolutif (`Lv 20–35`, 15 niveaux d'écart)** :
  - *Segment 1 (Stade 1, Lv 20–26)* : Magnéti, Porygon, Lixy, Dynavolt, Racaillou, Tarinor.
  - *Segment 2 (Stade Évolué, Lv 27–35)* : Magnéton, Porygon2, Luxio, Élecsprint, Gravalanch, Tarinorme.
- **Points médians (Relais)** :
  - `energy_garden_relay.rsground` ➔ **Modèle Tunnel Incandescent avec statue Kangourex (`Kangaskhan_Rock`)**, `North_Exit` et `South_Exit`, adapté au biome **Grotte de Cristal / Énergie**.
- **Mini-Boss (3 par donjon)** :
  - *Ét. 6* : **Magnéton le Flux** (Magneton, Lv. 26) — Musique : `Boss Battle.ogg`.
  - *Ét. 13* : **Tarpaud la Résonance** (Politoed, Lv. 30) — Musique : `Boss Battle.ogg`.
  - *Ét. 20* : **Lucario l'Onde** (Lucario, Lv. 35) — Musique : `Boss Battle 2.ogg`.
- **Légendaire** : *Aucun (§2).*
- **Objets & Marchand Kecleon** : `ItemSpawnZoneStep` (Évolurocs, Sphères). Marchand Kecleon aléatoire (`probabilité 12 %`).

---

### 7.S2 — Relique Engloutie (`sunken_relic` / compatible PMDODump)
- **Nommage original (§1–§6)** : `[Relique]` (Lieu) + `[Engloutie]` (Qualificatif géographique/descriptif).
- **Chapitre & Rang narratif** : Chapitre 7 — Rang 35.
- **Étages & Segments** : 20 étages en **2 segments** de 10 étages.
  - *Segment 1 (Ét. 1–10)* : Biome **Grotte Ouest** (`western_cave_1_floor` / `wall`).
  - *Segment 2 (Ét. 11–20)* : Biome **Ruines Antiques** (`ancient_relic_floor` / `wall`). Météo : *Brouillard* à l'étage 17.
- **Scaling Évolutif (`Lv 20–35`, 15 niveaux d'écart)** :
  - *Segment 1 (Stade 1, Lv 20–26)* : Baltoy, Archéomire, Tutafeh, Fantominus, Skuélénox.
  - *Segment 2 (Stade Évolué, Lv 27–35)* : Kaorine, Archéodong, Tutufeur, Spectrum, Téraclope.
- **Points médians (Relais)** :
  - `sunken_relic_relay.rsground` ➔ **Modèle Tunnel Incandescent avec statue Kangourex (`Kangaskhan_Rock`)**, adapté au biome **Ruines Antiques**.
- **Mini-Boss (3 par donjon)** :
  - *Ét. 7* : **Kaorine le Sceau** (Claydol, Lv. 26) — Musique : `Boss Battle.ogg`.
  - *Ét. 14* : **Archéodong la Cloche** (Bronzong, Lv. 30) — Musique : `Boss Battle.ogg`.
  - *Ét. 20* : **Tutufeur le Gardien** (Cofagrigus, Lv. 35) — Musique : `Boss Battle 2.ogg`.
- **Légendaire** : *Aucun (§2).*
- **Objets & Marchand Kecleon** : Orbes antiques, Baies Oran. Marchand Kecleon aléatoire (`probabilité 15 %`).

---

### 7.S3 — Labyrinthe Moussue (`mossy_labyrinth` / ExplorersOfSkyOrigins Ch7)
- **Nommage original (§1–§6)** : `[Labyrinthe]` (Lieu) + `[Moussue]` (Qualificatif atmosphérique/végétal).
- **Chapitre & Rang narratif** : Chapitre 7 — Rang 36.
- **Étages & Segments** : 20 étages en **2 segments** de 10 étages.
  - *Segment 1 (Ét. 1–10)* : Biome **Forêt Moussue** (`treeshroud_forest_1_floor` / `wall`).
  - *Segment 2 (Ét. 11–20)* : Biome **Forêt Envahie** (`overgrown_forest_floor` / `wall`). Météo : *Pluie* à l'étage 15.
- **Scaling Évolutif (`Lv 20–35`, 15 niveaux d'écart)** :
  - *Segment 1 (Stade 1, Lv 20–26)* : Grainipiot, Saquedeneu, Tortipouss, Mystherbe, Balignon.
  - *Segment 2 (Stade Évolué, Lv 27–35)* : Pifeuil, Tengalice, Bouldeneu, Boskara, Ortide, Chapignon.
- **Points médians (Relais)** :
  - `mossy_labyrinth_relay.rsground` ➔ **Modèle Tunnel Incandescent avec statue Kangourex (`Kangaskhan_Rock`)**, adapté au biome **Forêt Moussue**.
- **Mini-Boss (3 par donjon)** :
  - *Ét. 6* : **Tengalice la Canopée** (Shiftry, Lv. 26) — Musique : `Boss Battle.ogg`.
  - *Ét. 13* : **Bouldeneu la Racine** (Tangrowth, Lv. 30) — Musique : `Boss Battle.ogg`.
  - *Ét. 20* : **Torterra le Géant** (Torterra, Lv. 35) — Musique : `Boss Battle 2.ogg`.
- **Légendaire** : *Aucun (§2).*
- **Objets & Marchand Kecleon** : Pommes d'Or, Graines Résurrection. Marchand Kecleon aléatoire (`probabilité 10 %`).

---

### 7.S4 — Carrière Magmatique (`magma_quarry` / compatible PMDODump)
- **Nommage original (§1–§6)** : `[Carrière]` (Lieu) + `[Magmatique]` (Qualificatif géologique/chaleur).
- **Chapitre & Rang narratif** : Chapitre 7 — Rang 37.
- **Étages & Segments** : 20 étages en **2 segments** de 10 étages.
  - *Segment 1 (Ét. 1–10)* : Biome **Caverne Magma** (`magma_cavern_2_floor` / `wall`).
  - *Segment 2 (Ét. 11–20)* : Biome **Sommet Volcanique** (`mt_blaze_floor` / `wall`). Météo : *Soleil ardent* à l'étage 16.
- **Scaling Évolutif (`Lv 20–35`, 15 niveaux d'écart)** :
  - *Segment 1 (Stade 1, Lv 20–26)* : Chamallot, Malosse, Limagma, Goupix, Caninos.
  - *Segment 2 (Stade Évolué, Lv 27–35)* : Camerupt, Démolosse, Volcaropod, Feunard, Arkani.
- **Points médians (Relais)** :
  - `magma_quarry_relay.rsground` ➔ **Modèle Tunnel Incandescent avec statue Kangourex (`Kangaskhan_Rock`)**, adapté au biome **Volcanique / Magmatique**.
- **Mini-Boss (3 par donjon)** :
  - *Ét. 8* : **Camerupt la Lave** (Camerupt, Lv. 26) — Musique : `Boss Battle.ogg`.
  - *Ét. 15* : **Démolosse le Foyer** (Houndoom, Lv. 30) — Musique : `Boss Battle.ogg`.
  - *Ét. 20* : **Arkani la Flamme** (Arcanine, Lv. 35) — Musique : `Boss Battle 2.ogg`.
- **Légendaire** : *Aucun (§2).*
- **Objets & Marchand Kecleon** : Orbes Feu, Baies Rawst. Marchand Kecleon aléatoire (`probabilité 15 %`).

---

## 4. CHECK-LIST DE VALIDATION INTERMÉDIAIRE (FRAMEWORK §9)

- [ ] Les 4 donjons secondaires proposés pour le **Chapitre 6** et les 4 du **Chapitre 7** conviennent-ils dans leur structure (20 étages, 2 segments/biomes, relais toutes les 5 étages) ?
- [ ] Le respect de la règle d'absence de légendaire gratuit est-il validé pour les Ch6 et Ch7 ?
- [ ] Les noms propres et musiques de chaque mini-boss sont-ils approuvés ?

**Action attendue** : Dès ta validation sur ces propositions des Chapitres 6 et 7, nous lancerons la génération détaillée de leurs fichiers `.json` et `.lua`.

