# INVENTAIRE CENTRAL DES DONJONS (Source de Vérité Unique)

**Projet** : *New Era : Abyss to Ascension* (moteur RogueEssence / PMDO)  
**Rôle** : Répertoire unique des donjons d'histoire et secondaires (Chapitres 6 à 32), consignant nom, chapitre, rang narratif, structure, biomes, mini-boss, légendaires, bestiaire (20 à 50 espèces/donjon), objets, marchand Kecleon et musique.  
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

> **Exigence Bestiaire (§4)** : Chaque donjon intègre de **20 à 25 espèces sauvages vérifiées** (`Content/Chara/`), réparties en Scaling Évolutif (Stade 1 en Seg 1 ➔ Stade évolué en Seg 2).

### 6.S1 — Désert des Oubliés (`forsaken_desert` / PMDODump)
- **Nommage original** : `[Désert]` (Lieu) + `[des Oubliés]` (Qualificatif géographique/narratif).
- **Chapitre & Rang narratif** : Chapitre 6 — Rang 30.
- **Étages & Segments** : 20 étages en **2 segments** de 10 étages (`furnace_desert` ➔ `barren_valley`). Météo : *Tempête de sable* (ét. 4, 8, 18).
- **Bestiaire vérifié (22 espèces, `Lv 18–33`)** :  
  *Seg 1 (Lv 18-24)* : Sandshrew, Cacnea, Trapinch, Baltoy, Hippopotas, Skorupi, Diglett, Numel, Gible, Silicobra, Sandile.  
  *Seg 2 (Lv 25-33)* : Sandslash, Cacturne, Vibrava, Claydol, Hippowdon, Drapion, Dugtrio, Camerupt, Gabite, Sandaconda, Krokorok.
- **Points médians (Relais)** : `forsaken_desert_relay.rsground` ➔ **Modèle Tunnel Incandescent avec statue Kangourex**, adapté au biome **Désert Aride**.
- **Mini-Boss (3 par donjon)** :
  - *Ét. 6* : **Sablaireau l'Ancien** (Sandslash, Lv. 24) — Musique : `Boss Battle.ogg`.
  - *Ét. 12* : **Cacturne le Veilleur** (Cacturne, Lv. 28) — Musique : `Boss Battle.ogg`.
  - *Ét. 19* : **Hippodocus le Colosse** (Hippowdon, Lv. 32) — Musique : `Boss Battle 2.ogg`.
- **Légendaire** : *Aucun (§2).* Objets : `ItemSpawnZoneStep` + Marchand Kecleon (`12%`).

---

### 6.S2 — Crevasse de Géode (`geode_crevice` / PMDODump)
- **Nommage original** : `[Crevasse]` (Lieu) + `[de Géode]` (Qualificatif minéral).
- **Chapitre & Rang narratif** : Chapitre 6 — Rang 31.
- **Étages & Segments** : 20 étages en **2 segments** (`crystal_cave_1` ➔ `quartz_cavern`). Météo : *Brouillard* (ét. 14, 17).
- **Bestiaire vérifié (24 espèces, `Lv 18–33`)** :  
  *Seg 1 (Lv 18-24)* : Geodude, Roggenrola, Nosepass, Carbink, Aron, Onix, Ferroseed, Dwebble, Klink, Bronzor, Bergmite, Rhyhorn.  
  *Seg 2 (Lv 25-33)* : Graveler, Golem, Boldore, Gigalith, Probopass, Sableye, Lairon, Steelix, Ferrothorn, Crustle, Klang, Bronzong.
- **Points médians (Relais)** : `geode_crevice_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Grotte Cristal / Quartz**.
- **Mini-Boss** : Gravalanch du Filon (Lv 24), Tarinor la Boussole (Lv 28), Gigalithe le Diamant (Lv 33).
- **Légendaire** : *Aucun (§2).* Objets : Évolurocs, Sphères + Marchand Kecleon (`15%`).

---

### 6.S3 — Verger Sauvage (`wild_orchard` / ExplorersOfSkyOrigins)
- **Nommage original** : `[Verger]` (Lieu) + `[Sauvage]` (Qualificatif naturel).
- **Chapitre & Rang narratif** : Chapitre 6 — Rang 32.
- **Étages & Segments** : 20 étages en **2 segments** (`apple_woods` ➔ `orchard_path`). Météo : *Pluie* (ét. 16).
- **Bestiaire vérifié (24 espèces, `Lv 18–33`)** :  
  *Seg 1 (Lv 18-24)* : Caterpie, Weedle, Cherubi, Burmy, Combee, Oddish, Bellsprout, Hoppip, Sunkern, Seedot, Shroomish, Sewaddle.  
  *Seg 2 (Lv 25-33)* : Butterfree, Beedrill, Heracross, Pinsir, Vespiquen, Cherrim, Gloom, Weepinbell, Skiploom, Sunflora, Nuzleaf, Breloom.
- **Points médians (Relais)** : `wild_orchard_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Forêt / Verger**.
- **Mini-Boss** : Scarhino la Corne (Lv 24), Scarabrute la Pince (Lv 28), Apireine la Souveraine (Lv 33).
- **Légendaire** : *Aucun (§2).* Objets : Pommes d'Or + Marchand Kecleon (`10%`).

---

### 6.S4 — Plaines Brûlées (`scorched_plains` / PMDODump)
- **Nommage original** : `[Plaines]` (Lieu) + `[Brûlées]` (Qualificatif sensoriel).
- **Chapitre & Rang narratif** : Chapitre 6 — Rang 33.
- **Étages & Segments** : 20 étages en **2 segments** (`amp_plains` ➔ `scorched_plains`). Météo : *Soleil ardent* (ét. 15).
- **Bestiaire vérifié (22 espèces, `Lv 18–33`)** :  
  *Seg 1 (Lv 18-24)* : Shinx, Mareep, Electrike, Phanpy, Blitzle, Magnemite, Voltorb, Elekid, Helioptile, Dedenne, Yamper.  
  *Seg 2 (Lv 25-33)* : Luxio, Luxray, Flaaffy, Ampharos, Manectric, Donphan, Magneton, Electrode, Electabuzz, Heliolisk, Boltund.
- **Points médians (Relais)** : `scorched_plains_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Savane Électrique**.
- **Mini-Boss** : Luxio l'Éclair (Lv 24), Phanpy la Charge (Lv 28), Élecsprint la Tempête (Lv 33).
- **Légendaire** : *Aucun (§2).* Objets : Graines Éclair + Marchand Kecleon (`15%`).

---

## 3. CHAPITRE 7 — PROPOSITION DU ROSTER DES DONJONS SECONDAIRES (VALIDATION EN COURS)

> **Exigence Bestiaire (§4)** : Chaque donjon de ce roster comporte **22 à 26 espèces sauvages vérifiées** (`20 à 50 espèces différentes/donjon`).

### 7.S1 — Jardin d'Énergie (`energy_garden` / PMDODump)
- **Nommage original** : `[Jardin]` (Lieu) + `[d'Énergie]` (Qualificatif minéral).
- **Chapitre & Rang narratif** : Chapitre 7 — Rang 34.
- **Étages & Segments** : 20 étages en **2 segments** (`crystal_cave_1` ➔ `quartz_cavern`). Météo : *Brouillard* (ét. 14, 18).
- **Bestiaire vérifié (24 espèces, `Lv 20–35`)** :  
  *Seg 1 (Lv 20-26)* : Magnemite, Porygon, Shinx, Electrike, Geodude, Nosepass, Chinchou, Mareep, Elekid, Blitzle, Joltik, Klink.  
  *Seg 2 (Lv 27-35)* : Magneton, Porygon2, Luxio, Manectric, Graveler, Probopass, Lanturn, Flaaffy, Electabuzz, Zebstrika, Galvantula, Klang.
- **Points médians (Relais)** : `energy_garden_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Grotte Cristal / Énergie**.
- **Mini-Boss** : Magnéton le Flux (Lv 26), Tarpaud la Résonance (Lv 30), Lucario l'Onde (Lv 35).
- **Légendaire** : *Aucun (§2).*

---

### 7.S2 — Relique Engloutie (`sunken_relic` / compatible PMDODump)
- **Nommage original** : `[Relique]` (Lieu) + `[Engloutie]` (Qualificatif descriptif).
- **Chapitre & Rang narratif** : Chapitre 7 — Rang 35.
- **Étages & Segments** : 20 étages en **2 segments** (`western_cave_1` ➔ `ancient_relic`). Météo : *Brouillard* (ét. 17).
- **Bestiaire vérifié (22 espèces, `Lv 20–35`)** :  
  *Seg 1 (Lv 20-26)* : Baltoy, Bronzor, Yamask, Gastly, Duskull, Shuppet, Misdreavus, Drifloon, Litwick, Golett, Elgyem.  
  *Seg 2 (Lv 27-35)* : Claydol, Bronzong, Cofagrigus, Haunter, Dusclops, Banette, Mismagius, Drifblim, Lampent, Golurk, Beheeyem.
- **Points médians (Relais)** : `sunken_relic_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Ruines Antiques**.
- **Mini-Boss** : Kaorine le Sceau (Lv 26), Archéodong la Cloche (Lv 30), Tutufeur le Gardien (Lv 35).
- **Légendaire** : *Aucun (§2).*

---

### 7.S3 — Labyrinthe Moussue (`mossy_labyrinth` / ExplorersOfSkyOrigins Ch7)
- **Nommage original** : `[Labyrinthe]` (Lieu) + `[Moussue]` (Qualificatif végétal).
- **Chapitre & Rang narratif** : Chapitre 7 — Rang 36.
- **Étages & Segments** : 20 étages en **2 segments** (`treeshroud_forest_1` ➔ `overgrown_forest`). Météo : *Pluie* (ét. 15).
- **Bestiaire vérifié (24 espèces, `Lv 20–35`)** :  
  *Seg 1 (Lv 20-26)* : Seedot, Tangela, Turtwig, Oddish, Shroomish, Paras, Bellsprout, Hoppip, Sunkern, Exeggcute, Cherubi, Sewaddle.  
  *Seg 2 (Lv 27-35)* : Nuzleaf, Shiftry, Tangrowth, Grotle, Torterra, Gloom, Breloom, Parasect, Weepinbell, Skiploom, Sunflora, Swadloon.
- **Points médians (Relais)** : `mossy_labyrinth_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Forêt Moussue**.
- **Mini-Boss** : Tengalice la Canopée (Lv 26), Bouldeneu la Racine (Lv 30), Torterra le Géant (Lv 35).
- **Légendaire** : *Aucun (§2).*

---

### 7.S4 — Carrière Magmatique (`magma_quarry` / compatible PMDODump)
- **Nommage original** : `[Carrière]` (Lieu) + `[Magmatique]` (Qualificatif géologique/chaleur).
- **Chapitre & Rang narratif** : Chapitre 7 — Rang 37.
- **Étages & Segments** : 20 étages en **2 segments** (`magma_cavern_2` ➔ `mt_blaze`). Météo : *Soleil ardent* (ét. 16).
- **Bestiaire vérifié (22 espèces, `Lv 20–35`)** :  
  *Seg 1 (Lv 20-26)* : Numel, Houndour, Slugma, Vulpix, Growlithe, Charmander, Cyndaquil, Torchic, Torkoal, Magby, Litleo.  
  *Seg 2 (Lv 27-35)* : Camerupt, Houndoom, Magcargo, Ninetales, Arcanine, Charmeleon, Quilava, Combusken, Magmar, Pyroar, Salazzle.
- **Points médians (Relais)** : `magma_quarry_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Volcanique / Magma**.
- **Mini-Boss** : Camerupt la Lave (Lv 26), Démolosse le Foyer (Lv 30), Arkani la Flamme (Lv 35).
- **Légendaire** : *Aucun (§2).*

---

## 4. CHAPITRE 8 — PROPOSITION DU ROSTER DES DONJONS SECONDAIRES

> **Exigence Bestiaire (§4)** : Chaque donjon intègre **22 à 26 espèces sauvages vérifiées** (`20 à 50 espèces différentes/donjon`). Scaling `Lv 25–40`.

### 8.S1 — Toundra Désolée (`barren_tundra` / PMDODump)
- **Nommage original** : `[Toundra]` (Lieu) + `[Désolée]` (Qualificatif glaciaire).
- **Chapitre & Rang narratif** : Chapitre 8 — Rang 38.
- **Étages & Segments** : 20 étages en **2 segments** (`glacial_path` ➔ `barren_tundra`). Météo : *Neige / Grêle* (ét. 6, 15).
- **Bestiaire vérifié (26 espèces, `Lv 25–40`)** :  
  *Seg 1 (Lv 25-31)* : Swinub, Snorunt, Spheal, Cubchoo, Snover, Bergmite, Vanillite, Smoochum, Sneasel, Alolan Vulpix, Alolan Sandshrew, Delibird, Snom.  
  *Seg 2 (Lv 32-40)* : Piloswine, Mamoswine, Glalie, Froslass, Sealeo, Walrein, Beartic, Abomasnow, Avalugg, Vanillish, Vanilluxe, Jynx, Weavile.
- **Points médians (Relais)** : `barren_tundra_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Neige / Toundra**.
- **Mini-Boss** : Mammochon le Glacier (Lv 32), Oniglali le Gel (Lv 36), Blizzarroi l'Hiver (Lv 40).
- **Légendaire** : *Aucun (§2).*

---

### 8.S2 — Caverne Stérile (`barren_cavern` / original)
- **Nommage original** : `[Caverne]` (Lieu) + `[Stérile]` (Qualificatif minéral).
- **Chapitre & Rang narratif** : Chapitre 8 — Rang 39.
- **Étages & Segments** : 20 étages en **2 segments** (`rocky_cave` ➔ `deep_cavern`). Météo : *Brouillard* (ét. 12).
- **Bestiaire vérifié (24 espèces, `Lv 25–40`)** :  
  *Seg 1 (Lv 25-31)* : Zubat, Wooper, Onix, Dunsparce, Whismur, Makuhita, Mawile, Aron, Meditite, Sableye, Diglett, Paras.  
  *Seg 2 (Lv 32-40)* : Golbat, Crobat, Quagsire, Steelix, Loudred, Exploud, Hariyama, Lairon, Aggron, Medicham, Dugtrio, Parasect.
- **Points médians (Relais)** : `barren_cavern_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Grotte Rocheuse**.
- **Mini-Boss** : Steelix la Faille (Lv 32), Galeking le Fer (Lv 36), Charmina le Sceau (Lv 40).
- **Légendaire** : *Aucun (§2).*

---

### 8.S3 — Crête Craquelée (`cracked_ridge` / original)
- **Nommage original** : `[Crête]` (Lieu) + `[Craquelée]` (Qualificatif géologique).
- **Chapitre & Rang narratif** : Chapitre 8 — Rang 40.
- **Étages & Segments** : 20 étages en **2 segments** (`rock_pass` ➔ `cracked_ridge`). Météo : *Tempête de sable* (ét. 14).
- **Bestiaire vérifié (24 espèces, `Lv 25–40`)** :  
  *Seg 1 (Lv 25-31)* : Machop, Geodude, Rhyhorn, Larvitar, Bagon, Drilbur, Timburr, Rufflet, Vullaby, Gligar, Onix, Trapinch.  
  *Seg 2 (Lv 32-40)* : Machoke, Machamp, Graveler, Rhydon, Rhyperior, Pupitar, Tyranitar, Shelgon, Salamence, Excadrill, Gurdurr, Conkeldurr.
- **Points médians (Relais)** : `cracked_ridge_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Crête Rocheuse**.
- **Mini-Boss** : Rhinastoc la Roche (Lv 32), Tyranocif l'Abysse (Lv 36), Drattak la Cime (Lv 40).
- **Légendaire** : *Aucun (§2).*

---

### 8.S4 — Vallon Suspendu (`suspended_valley` / original)
- **Nommage original** : `[Vallon]` (Lieu) + `[Suspendu]` (Qualificatif aérien).
- **Chapitre & Rang narratif** : Chapitre 8 — Rang 41.
- **Étages & Segments** : 20 étages en **2 segments** (`misty_valley` ➔ `suspended_valley`). Météo : *Vent violent* (ét. 15).
- **Bestiaire vérifié (22 espèces, `Lv 25–40`)** :  
  *Seg 1 (Lv 25-31)* : Pidgey, Spearow, Hoothoot, Taillow, Starly, Swablu, Tropius, Chatot, Hawlucha, Fletchling, Noibat.  
  *Seg 2 (Lv 32-40)* : Pidgeotto, Pidgeot, Fearow, Noctowl, Swellow, Staravia, Staraptor, Altaria, Fletchinder, Talonflame, Noivern.
- **Points médians (Relais)** : `suspended_valley_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Vallon / Cimes**.
- **Mini-Boss** : Roucarnage le Vent (Lv 32), Altaria la Brume (Lv 36), Bruyverne le Cri (Lv 40).
- **Légendaire** : *Aucun (§2).*

---

## 5. CHAPITRE 9 — PROPOSITION DU ROSTER DES DONJONS SECONDAIRES

> **Exigence Bestiaire (§4)** : Chaque donjon intègre **24 à 26 espèces sauvages vérifiées** (`20 à 50 espèces différentes/donjon`). Scaling `Lv 30–45`.

### 9.S1 — Bassin Tari (`depleted_basin` / PMDODump)
- **Nommage original** : `[Bassin]` (Lieu) + `[Tari]` (Qualificatif aquatique/sec).
- **Chapitre & Rang narratif** : Chapitre 9 — Rang 42.
- **Étages & Segments** : 20 étages en **2 segments** (`dry_basin` ➔ `depleted_basin`).
- **Bestiaire vérifié (24 espèces, `Lv 30–45`)** :  
  *Seg 1 (Lv 30-36)* : Psyduck, Poliwag, Tentacool, Slowpoke, Krabby, Horsea, Goldeen, Staryu, Magikarp, Chinchou, Wooper, Barboach.  
  *Seg 2 (Lv 37-45)* : Golduck, Poliwhirl, Poliwrath, Tentacruel, Slowbro, Slowking, Kingler, Seadra, Kingdra, Seaking, Starmie, Gyarados.
- **Points médians (Relais)** : `depleted_basin_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Bassin Aquatique/Sec**.
- **Mini-Boss** : Akwakwak la Secheresse (Lv 35), Flagadoss le Calme (Lv 40), Léviator le Courroux (Lv 45).
- **Légendaire** : *Aucun (§2).*

---

### 9.S2 — Marais Errants (`wayward_wetlands` / PMDODump)
- **Nommage original** : `[Marais]` (Lieu) + `[Errants]` (Qualificatif mystère).
- **Chapitre & Rang narratif** : Chapitre 9 — Rang 43.
- **Étages & Segments** : 20 étages en **2 segments** (`damp_marsh` ➔ `wayward_wetlands`). Météo : *Pluie* (ét. 8, 16).
- **Bestiaire vérifié (24 espèces, `Lv 30–45`)** :  
  *Seg 1 (Lv 30-36)* : Lotad, Surskit, Carvanha, Barboach, Corphish, Feebas, Clamperl, Luvdisc, Tympole, Basculin, Skrelp, Croagunk.  
  *Seg 2 (Lv 37-45)* : Lombre, Ludicolo, Masquerain, Sharpedo, Whiscash, Crawdaunt, Milotic, Huntail, Gorebyss, Palpitoad, Seismitoad, Dragalge.
- **Points médians (Relais)** : `wayward_wetlands_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Marais / Eau**.
- **Mini-Boss** : Ludicolo la Danse (Lv 35), Colhomard la Pince (Lv 40), Milobellus le Bassin (Lv 45).
- **Légendaire** : *Aucun (§2).*

---

### 9.S3 — Jungle Méridionale (`southern_jungle` / original)
- **Nommage original** : `[Jungle]` (Lieu) + `[Méridionale]` (Qualificatif tropical).
- **Chapitre & Rang narratif** : Chapitre 9 — Rang 44.
- **Étages & Segments** : 20 étages en **2 segments** (`tropical_forest` ➔ `deep_jungle`). Météo : *Soleil ardent* (ét. 12).
- **Bestiaire vérifié (26 espèces, `Lv 30–45`)** :  
  *Seg 1 (Lv 30-36)* : Oddish, Bellsprout, Exeggcute, Tangela, Hoppip, Sunkern, Shroomish, Roselia, Cacnea, Carnivine, Snover, Leafeon, Fomantis.  
  *Seg 2 (Lv 37-45)* : Gloom, Vileplume, Bellossom, Weepinbell, Victreebel, Exeggutor, Tangrowth, Skiploom, Jumpluff, Sunflora, Breloom, Roserade, Cacturne.
- **Points médians (Relais)** : `southern_jungle_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Jungle Tropicale**.
- **Mini-Boss** : Empiflor le Liane (Lv 35), Noadkoko le Soleil (Lv 40), Roserade le Venin (Lv 45).
- **Légendaire** : *Aucun (§2).*

---

### 9.S4 — Gouffre Immergé (`submerged_chasm` / original)
- **Nommage original** : `[Gouffre]` (Lieu) + `[Immergé]` (Qualificatif aquatique/profond).
- **Chapitre & Rang narratif** : Chapitre 9 — Rang 45.
- **Étages & Segments** : 20 étages en **2 segments** (`marine_cave` ➔ `submerged_chasm`).
- **Bestiaire vérifié (24 espèces, `Lv 30–45`)** :  
  *Seg 1 (Lv 30-36)* : Shellder, Gastly, Krabby, Cubone, Lickitung, Koffing, Rhyhorn, Chansey, Tangela, Horsea, Omanyte, Kabuto.  
  *Seg 2 (Lv 37-45)* : Cloyster, Haunter, Gengar, Kingler, Marowak, Lickilicky, Weezing, Rhydon, Rhyperior, Blissey, Tangrowth, Seadra.
- **Points médians (Relais)** : `submerged_chasm_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Grotte Marine**.
- **Mini-Boss** : Crustabri la Coquille (Lv 35), Ectoplasma l'Ombre (Lv 40), Hyporoi le Fond (Lv 45).
- **Légendaire** : *Aucun (§2).*

---

## 6. CHAPITRE 10 — PROPOSITION DU ROSTER DES DONJONS SECONDAIRES

> **Exigence Bestiaire (§4)** : Chaque donjon intègre **24 à 26 espèces sauvages vérifiées** (`20 à 50 espèces différentes/donjon`). Scaling `Lv 35–50`.

### 10.S1 — Sentier Enneigé (`snowbound_path` / PMDODump)
- **Nommage original** : `[Sentier]` (Lieu) + `[Enneigé]` (Qualificatif climatique).
- **Chapitre & Rang narratif** : Chapitre 10 — Rang 46.
- **Étages & Segments** : 20 étages en **2 segments** (`white_path` ➔ `snowbound_path`). Météo : *Neige* (ét. 14, 18).
- **Bestiaire vérifié (24 espèces, `Lv 35–50`)** :  
  *Seg 1 (Lv 35-41)* : Swinub, Snorunt, Spheal, Cubchoo, Snover, Bergmite, Cryogonal, Vanillite, Smoochum, Sneasel, Lapras, Delibird.  
  *Seg 2 (Lv 42-50)* : Piloswine, Mamoswine, Glalie, Froslass, Sealeo, Walrein, Beartic, Abomasnow, Avalugg, Vanillish, Vanilluxe, Weavile.
- **Points médians (Relais)** : `snowbound_path_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Neige / Glace**.
- **Mini-Boss** : Kaimorse le Croc (Lv 40), Polagriffe la Tempête (Lv 45), Momartik le Souffle (Lv 50).
- **Légendaire** : *Aucun (§2).*

---

### 10.S2 — Col de la Foudre (`thunderstruck_pass` / PMDODump)
- **Nommage original** : `[Col]` (Lieu) + `[de la Foudre]` (Qualificatif électrique).
- **Chapitre & Rang narratif** : Chapitre 10 — Rang 47.
- **Étages & Segments** : 20 étages en **2 segments** (`stormy_pass` ➔ `thunderstruck_pass`). Météo : *Pluie orageuse* (ét. 15).
- **Bestiaire vérifié (24 espèces, `Lv 35–50`)** :  
  *Seg 1 (Lv 35-41)* : Magnemite, Voltorb, Electabuzz, Jolteon, Chinchou, Mareep, Elekid, Electrike, Shinx, Pachirisu, Blitzle, Emolga.  
  *Seg 2 (Lv 42-50)* : Magneton, Magnezone, Electrode, Electivire, Lanturn, Flaaffy, Ampharos, Manectric, Luxio, Luxray, Zebstrika, Heliolisk.
- **Points médians (Relais)** : `thunderstruck_pass_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Col Électrique**.
- **Mini-Boss** : Élekable la Haute-Tension (Lv 40), Luxray le Foudre (Lv 45), Magnézone l'Éclair (Lv 50).
- **Légendaire** : *Aucun (§2).*

---

### 10.S3 — Falaises de l'Envol (`flyaway_cliffs` / PMDODump)
- **Nommage original** : `[Falaises]` (Lieu) + `[de l'Envol]` (Qualificatif aérien).
- **Chapitre & Rang narratif** : Chapitre 10 — Rang 48.
- **Étages & Segments** : 20 étages en **2 segments** (`aerial_cliffs` ➔ `flyaway_cliffs`). Météo : *Vent violent* (ét. 17).
- **Bestiaire vérifié (26 espèces, `Lv 35–50`)** :  
  *Seg 1 (Lv 35-41)* : Pidgey, Spearow, Zubat, Hoothoot, Natu, Murkrow, Taillow, Wingull, Swablu, Tropius, Starly, Rufflet, Vullaby.  
  *Seg 2 (Lv 42-50)* : Pidgeotto, Pidgeot, Fearow, Golbat, Crobat, Aerodactyl, Noctowl, Xatu, Honchkrow, Skarmory, Swellow, Pelipper, Altaria.
- **Points médians (Relais)** : `flyaway_cliffs_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Falaises / Altitude**.
- **Mini-Boss** : Airmure la Lame (Lv 40), Xatu l'Oracle (Lv 45), Roucarnage le Sommet (Lv 50).
- **Légendaire** : *Aucun (§2).*

---

### 10.S4 — Tour du Temps Oubliée (`forgotten_time_tower` / original)
- **Nommage original** : `[Tour]` (Lieu) + `[Oubliée]` (Qualificatif temporel/mystère).
- **Chapitre & Rang narratif** : Chapitre 10 — Rang 49.
- **Étages & Segments** : 20 étages en **2 segments** (`ancient_spiral` ➔ `forgotten_spire`).
- **Bestiaire vérifié (24 espèces, `Lv 35–50`)** :  
  *Seg 1 (Lv 35-41)* : Abra, Drowzee, Exeggcute, Staryu, Jynx, Espeon, Unown, Wobbuffet, Girafarig, Ralts, Spoink, Lunatone.  
  *Seg 2 (Lv 42-50)* : Kadabra, Alakazam, Hypno, Exeggutor, Starmie, Slowking, Kirlia, Gardevoir, Gallade, Grumpig, Solrock, Claydol.
- **Points médians (Relais)** : `forgotten_time_tower_relay.rsground` ➔ **Modèle Tunnel Incandescent avec Kangourex**, adapté au biome **Tour Antique**.
- **Mini-Boss** : Alakazam l'Esprit (Lv 40), Gardevoir la Vision (Lv 45), Kaorine l'Antique (Lv 50).
- **Légendaire** : *Aucun (§2).*

---

## 7. CHECK-LIST DE VALIDATION INTERMÉDIAIRE (FRAMEWORK §9)

- [ ] Les donjons secondaires proposés pour les **Chapitres 6, 7, 8, 9 et 10** conviennent-ils dans leur structure (20 étages, 2 segments/biomes, relais modèle Tunnel Incandescent + Kangourex toutes les 5 étages) ?
- [ ] Le respect de l'exigence de **20 à 50 espèces sauvages différentes par donjon** en scaling évolutif (Stade 1 -> Stade Évolué) est-il validé ?
- [ ] La **Convention de Nommage (`[Lieu] + [Qualificatif]`)** est-elle approuvée pour l'ensemble du roster ?

**Action attendue** : Dès ta validation sur ce roster des Chapitres 6 à 10, nous enclencherons la génération détaillée et passerons aux propositions des **Chapitres 11 à 15** !
