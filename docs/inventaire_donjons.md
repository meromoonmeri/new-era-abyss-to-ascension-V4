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

## 2. CHAPITRE 6 — PROPOSITION DU ROSTER DES DONJONS SECONDAIRES

> **État du processus (§9, Étape 2)** : Proposition formelle des **4 donjons secondaires du Chapitre 6** pour **validation utilisateur** avant génération des fichiers `.json` détaillés.  
> Tous les mini-boss portent des noms propres, utilisent des musiques présentes dans `Content/Music/` et les espèces sont vérifiées dans `Content/Chara/`.  
> *Note Légendaire (§2)* : Conformément au garde-fou, **aucun légendaire gratuit** n'est inséré dans ces donjons secondaires ; l'enjeu légendaire du Ch6 reste concentré sur **Zarude** et son contrat de revanche Grodoudou (`verdant_oath`).

### 6.S1 — Désert des Oubliés (`forsaken_desert` / PMDODump)
- **Chapitre & Rang narratif** : Chapitre 6 — Rang 30.
- **Étages & Segments** : 20 étages en **2 segments** de 10 étages (`RangeDictSegment` / `LayeredSegment`).
  - *Segment 1 (Ét. 1–10)* : Biome **Désert Ardent** (`furnace_desert_floor` / `wall`). Météo : *Tempête de sable* aux étages 4, 8 et 9 (§6.5).
  - *Segment 2 (Ét. 11–20)* : Biome **Vallée Stérile** (`barren_valley_floor` / `wall`). Météo : *Tempête de sable* à l'étage 18.
- **Points médians (Relais)** : `forsaken_desert_relay.rsground` — Modèle Tunnel Incandescent avec **statue Kangourex (`Kangaskhan_Rock`)**, `North_Exit` et `South_Exit`, adapté au biome **Désert Aride / Rocheux**.
- **Mini-Boss (3 par donjon, noms propres & musique dédiée)** :
  - *Ét. 6* : **Sablaireau l'Ancien** (Sandslash, Lv. 22) — Musique : `Boss Battle.ogg`.
  - *Ét. 12* : **Cacturne le Veilleur** (Cacturne, Lv. 24) — Musique : `Boss Battle.ogg`.
  - *Ét. 19* : **Hippodocus le Colosse** (Hippowdon, Lv. 26) — Musique : `Boss Battle 2.ogg`.
- **Légendaire** : *Aucun — Donjon d'exploration désertique secondaire (§2).*
- **Bestiaire vérifié (`Content/Chara/`, 14 espèces)** :  
  Sandshrew, Sandslash, Cacnea, Cacturne, Trapinch, Vibrava, Baltoy, Claydol, Hippopotas, Hippowdon, Gible, Gabite, Skorupi, Drapion.
- **Objets & Marchand Kecleon (§4.5, §4.6)** :
  - Patron de spawn : `ItemSpawnZoneStep` (calqué sur `PMDODump` `DataAsset/Zone/Forsaken_Desert.out.txt`). Pool : Orbes désertiques, Baies Oran, Graines Résurrection.
  - Marchand Kecleon : Spawn aléatoire (`probabilité 12 %` par étage dans le segment 2).
- **Diversité géométrique (§1.5)** : Étages 1–5 : grands plateaux ouverts ; Étages 6–15 : couloirs rocheux étroits ; Étages 16–20 : labyrinthe de dunes.

---

### 6.S2 — Crevasse de Géode (`geode_crevice` / PMDODump)
- **Chapitre & Rang narratif** : Chapitre 6 — Rang 31.
- **Étages & Segments** : 20 étages en **2 segments** de 10 étages.
  - *Segment 1 (Ét. 1–10)* : Biome **Grotte de Cristal** (`crystal_cave_1_floor` / `wall`).
  - *Segment 2 (Ét. 11–20)* : Biome **Caverne de Quartz** (`quartz_cavern_floor` / `wall`). Météo : *Brouillard électrostatique* aux étages 14 et 17.
- **Points médians (Relais)** : `geode_crevice_relay.rsground` — Modèle Tunnel Incandescent avec **statue Kangourex (`Kangaskhan_Rock`)**, `North_Exit` et `South_Exit`, adapté au biome **Grotte de Cristal / Caverne de Quartz**.
- **Mini-Boss (3 par donjon)** :
  - *Ét. 7* : **Gravalanch du Filon** (Graveler, Lv. 23) — Musique : `Boss Battle.ogg`.
  - *Ét. 14* : **Tarinor la Boussole** (Nosepass, Lv. 25) — Musique : `Boss Battle.ogg`.
  - *Ét. 20* : **Gigalithe le Diamant** (Gigalith, Lv. 27) — Musique : `Boss Battle 2.ogg`.
- **Légendaire** : *Aucun (§2).*
- **Bestiaire vérifié (`Content/Chara/`, 12 espèces)** :  
  Geodude, Graveler, Golem, Nosepass, Probopass, Roggenrola, Boldore, Gigalith, Carbink, Sableye, Mawile, Aron.
- **Objets & Marchand Kecleon** : `ItemSpawnZoneStep` riche en Évolurocs et sphères de lumière. Marchand Kecleon aléatoire (`probabilité 15 %`).

---

### 6.S3 — Verger Sauvage (`wild_orchard` / ExplorersOfSkyOrigins)
- **Chapitre & Rang narratif** : Chapitre 6 — Rang 32.
- **Étages & Segments** : 20 étages en **2 segments** de 10 étages.
  - *Segment 1 (Ét. 1–10)* : Biome **Bois aux Pommes** (`apple_woods_floor` / `wall`).
  - *Segment 2 (Ét. 11–20)* : Biome **Sentier du Verger** (`orchard_path_floor` / `wall`). Météo : *Pluie* à l'étage 16.
- **Points médians (Relais)** : `wild_orchard_relay.rsground` — Modèle Tunnel Incandescent avec **statue Kangourex (`Kangaskhan_Rock`)**, `North_Exit` et `South_Exit`, adapté au biome **Nature / Forêt (`Apple Woods`)**.
- **Mini-Boss (3 par donjon)** :
  - *Ét. 5* : **Scarhino la Corne** (Heracross, Lv. 22) — Musique : `Boss Battle.ogg`.
  - *Ét. 13* : **Scarabrute la Pince** (Pinsir, Lv. 24) — Musique : `Boss Battle.ogg`.
  - *Ét. 20* : **Apireine la Souveraine** (Vespiquen, Lv. 26) — Musique : `Boss Battle 2.ogg`.
- **Légendaire** : *Aucun (§2).*
- **Bestiaire vérifié (`Content/Chara/`, 16 espèces)** :  
  Caterpie, Metapod, Butterfree, Weedle, Kakuna, Beedrill, Scyther, Pinsir, Heracross, Combee, Vespiquen, Cherubi, Cherrim, Burmy, Wormadam, Mothim.
- **Objets & Marchand Kecleon** : Abondance de Pommes d'Or et Baies Pecha. Marchand Kecleon aléatoire (`probabilité 10 %`).

---

### 6.S4 — Plaines Brûlées (`scorched_plains` / PMDODump)
- **Chapitre & Rang narratif** : Chapitre 6 — Rang 33.
- **Étages & Segments** : 20 étages en **2 segments** de 10 étages.
  - *Segment 1 (Ét. 1–10)* : Biome **Plaines Électriques** (`amp_plains_floor` / `wall`).
  - *Segment 2 (Ét. 11–20)* : Biome **Plaines Arides** (`scorched_plains_floor` / `wall`). Météo : *Soleil ardent* à l'étage 15.
- **Points médians (Relais)** : `scorched_plains_relay.rsground` — Modèle Tunnel Incandescent avec **statue Kangourex (`Kangaskhan_Rock`)**, `North_Exit` et `South_Exit`, adapté au biome **Plaines Arides / Savane Électrique**.
- **Mini-Boss (3 par donjon)** :
  - *Ét. 8* : **Luxio l'Éclair** (Luxio, Lv. 23) — Musique : `Boss Battle.ogg`.
  - *Ét. 15* : **Phanpy la Charge** (Phanpy, Lv. 25) — Musique : `Boss Battle.ogg`.
  - *Ét. 20* : **Élecsprint la Tempête** (Manectric, Lv. 27) — Musique : `Boss Battle 2.ogg`.
- **Légendaire** : *Aucun (§2).*
- **Bestiaire vérifié (`Content/Chara/`, 15 espèces)** :  
  Shinx, Luxio, Luxray, Electrike, Manectric, Mareep, Flaaffy, Ampharos, Phanpy, Donphan, Blitzle, Zebstrika, Helioptile, Heliolisk, Dedenne.
- **Objets & Marchand Kecleon** : Graines Éclair, Orbes Paralysie. Marchand Kecleon aléatoire (`probabilité 15 %`).

---

## 3. CHECK-LIST DE VALIDATION INTERMÉDIAIRE (FRAMEWORK §9)

- [ ] Les 4 donjons secondaires proposés pour le **Chapitre 6** conviennent-ils dans leur structure (20 étages, 2 segments/biomes, relais toutes les 5 étages) ?
- [ ] Le respect de la règle d'absence de légendaire gratuit est-il validé pour le Ch6 ?
- [ ] Les noms propres et musiques de chaque mini-boss sont-ils approuvés ?

**Action attendue** : Dès ta validation sur cette proposition du Chapitre 6, nous lancerons la génération détaillée de leurs fichiers `.json` et `.lua`.
