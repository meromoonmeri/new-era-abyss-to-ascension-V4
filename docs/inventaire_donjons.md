# INVENTAIRE CENTRAL DES DONJONS (Source de Vérité Unique)

**Projet** : *New Era : Abyss to Ascension* (moteur RogueEssence / PMDO)  
**Rôle** : Répertoire unique des donjons d'histoire et secondaires (Chapitres 6 à 32), consignant nom, chapitre, rang narratif, structure, biomes, arènes d'étage (`.rsmap`), mini-boss, légendaires, bestiaire (20 à 50 espèces/donjon), objets, marchand Kecleon, missions du Job Board (`SecondaryJobs.lua`) et musique.  
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

## 2. SYNTHÈSE DU ROSTER DES DONJONS SECONDAIRES (CHAPITRES 6 À 10 — POUR VALIDATION)

> **Exigence Structure & Arènes d'Étage (§1, §1.5)** :  
> Chaque donjon secondaire ci-dessous comporte **20 ÉTAGES EXACTS** :
> - **17 étages d'exploration procédurale** (divisés en 2 segments de biome avec scaling de niveau et 22 à 26 espèces sauvages vérifiées).
> - **3 ARÈNES D'ÉTAGE DÉDIÉES (`.rsmap`)** intégrées dans le donjon (Étage 6, Étage 13, Étage 20) : chaque mini-boss ou boss est combattu dans sa **propre salle de confrontation (`.rsmap`)**, adaptée aux tuiles et au biome de son segment.  
> **Zéro ground indépendant (`.rsground`) pour les boss**, et **zéro légendaire gratuit** dans ces donjons secondaires.

---

### A. CHAPITRE 6 — DONJONS SECONDAIRES (20 ÉTAGES / 3 ARÈNES D'ÉTAGE)

| Identifiant (`ID`) | Nom Français | Total Étages | Biomes (Seg 1 → Seg 2) | Espèces Sauvages (`20-50/donjon`, Lv 18-33) | Les 3 Arènes d'Étage (`.rsmap` intégrées, adaptées au biome) | Relais (Modèle Tunnel Incandescent + Kangourex) |
| :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| **`forsaken_desert`** | **Désert des Oubliés** | **22 ét.** | Désert Ardent → Vallée Stérile | **22 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 7 (`forsaken_desert_mb1.rsmap`)** : Sablaireau l'Ancien<br>• **Ét. 14 (`forsaken_desert_mb2.rsmap`)** : Cacturne le Veilleur<br>• **Ét. 22 (`forsaken_desert_boss.rsmap`)** : Hippodocus le Colosse | `forsaken_desert_relay.rsground` (Biome Désert Aride) |
| **`geode_crevice`** | **Crevasse de Géode** | **24 ét.** | Grotte Cristal → Caverne Quartz | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 8 (`geode_crevice_mb1.rsmap`)** : Gravalanch du Filon<br>• **Ét. 16 (`geode_crevice_mb2.rsmap`)** : Tarinor la Boussole<br>• **Ét. 24 (`geode_crevice_boss.rsmap`)** : Gigalithe le Diamant | `geode_crevice_relay.rsground` (Biome Cristal) |
| **`wild_orchard`** | **Verger Sauvage** | **23 ét.** | Bois Pommes → Sentier Verger | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 7 (`wild_orchard_mb1.rsmap`)** : Scarhino la Corne<br>• **Ét. 15 (`wild_orchard_mb2.rsmap`)** : Scarabrute la Pince<br>• **Ét. 23 (`wild_orchard_boss.rsmap`)** : Apireine la Souveraine | `wild_orchard_relay.rsground` (Biome Forêt) |
| **`scorched_plains`** | **Plaines Brûlées** | **25 ét.** | Plaines Élec → Plaines Arides | **22 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 8 (`scorched_plains_mb1.rsmap`)** : Luxio l'Éclair<br>• **Ét. 16 (`scorched_plains_mb2.rsmap`)** : Phanpy la Charge<br>• **Ét. 25 (`scorched_plains_boss.rsmap`)** : Élecsprint la Tempête | `scorched_plains_relay.rsground` (Biome Savane) |

---

### B. CHAPITRE 7 — DONJONS SECONDAIRES (20 ÉTAGES / 3 ARÈNES D'ÉTAGE)

| Identifiant (`ID`) | Nom Français | Total Étages | Biomes (Seg 1 → Seg 2) | Espèces Sauvages (`20-50/donjon`, Lv 20-35) | Les 3 Arènes d'Étage (`.rsmap` intégrées, adaptées au biome) | Relais (Modèle Tunnel Incandescent + Kangourex) |
| :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| **`energy_garden`** | **Jardin d'Énergie** | **20 ét.** | Grotte Cristal → Caverne Énergie | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`energy_garden_mb1.rsmap`)** : Magnéton le Flux<br>• **Ét. 13 (`energy_garden_mb2.rsmap`)** : Tarpaud la Résonance<br>• **Ét. 20 (`energy_garden_boss.rsmap`)** : Lucario l'Onde | `energy_garden_relay.rsground` (Biome Énergie) |
| **`sunken_relic`** | **Relique Engloutie** | **20 ét.** | Grotte Ouest → Ruines Antiques | **22 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`sunken_relic_mb1.rsmap`)** : Kaorine le Sceau<br>• **Ét. 13 (`sunken_relic_mb2.rsmap`)** : Archéodong la Cloche<br>• **Ét. 20 (`sunken_relic_boss.rsmap`)** : Tutufeur le Gardien | `sunken_relic_relay.rsground` (Biome Ruines Antiques) |
| **`mossy_labyrinth`** | **Labyrinthe Moussue** | **20 ét.** | Forêt Moussue → Forêt Envahie | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`mossy_labyrinth_mb1.rsmap`)** : Tengalice la Canopée<br>• **Ét. 13 (`mossy_labyrinth_mb2.rsmap`)** : Bouldeneu la Racine<br>• **Ét. 20 (`mossy_labyrinth_boss.rsmap`)** : Torterra le Géant | `mossy_labyrinth_relay.rsground` (Biome Forêt Moussue) |
| **`magma_quarry`** | **Carrière Magmatique** | **20 ét.** | Caverne Magma → Sommet Volcan | **22 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`magma_quarry_mb1.rsmap`)** : Camerupt la Lave<br>• **Ét. 13 (`magma_quarry_mb2.rsmap`)** : Démolosse le Foyer<br>• **Ét. 20 (`magma_quarry_boss.rsmap`)** : Arkani la Flamme | `magma_quarry_relay.rsground` (Biome Volcan) |

---

### C. CHAPITRE 8 — DONJONS SECONDAIRES (20 ÉTAGES / 3 ARÈNES D'ÉTAGE)

| Identifiant (`ID`) | Nom Français | Total Étages | Biomes (Seg 1 → Seg 2) | Espèces Sauvages (`20-50/donjon`, Lv 25-40) | Les 3 Arènes d'Étage (`.rsmap` intégrées, adaptées au biome) | Relais (Modèle Tunnel Incandescent + Kangourex) |
| :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| **`barren_tundra`** | **Toundra Désolée** | **20 ét.** | Sentier Glace → Toundra Désolée | **26 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`barren_tundra_mb1.rsmap`)** : Mammochon le Glacier<br>• **Ét. 13 (`barren_tundra_mb2.rsmap`)** : Oniglali le Gel<br>• **Ét. 20 (`barren_tundra_boss.rsmap`)** : Blizzarroi l'Hiver | `barren_tundra_relay.rsground` (Biome Neige) |
| **`barren_cavern`** | **Caverne Stérile** | **20 ét.** | Grotte Rocheuse → Caverne Profonde | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`barren_cavern_mb1.rsmap`)** : Steelix la Faille<br>• **Ét. 13 (`barren_cavern_mb2.rsmap`)** : Galeking le Fer<br>• **Ét. 20 (`barren_cavern_boss.rsmap`)** : Charmina le Sceau | `barren_cavern_relay.rsground` (Biome Grotte) |
| **`cracked_ridge`** | **Crête Craquelée** | **20 ét.** | Col Rocheux → Crête Craquelée | **25 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`cracked_ridge_mb1.rsmap`)** : Rhinastoc la Roche<br>• **Ét. 13 (`cracked_ridge_mb2.rsmap`)** : Tyranocif l'Abysse<br>• **Ét. 20 (`cracked_ridge_boss.rsmap`)** : Drattak la Cime | `cracked_ridge_relay.rsground` (Biome Crête) |
| **`suspended_valley`** | **Vallon Suspendu** | **20 ét.** | Vallon Brumeux → Vallon Suspendu | **22 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`suspended_valley_mb1.rsmap`)** : Roucarnage le Vent<br>• **Ét. 13 (`suspended_valley_mb2.rsmap`)** : Altaria la Brume<br>• **Ét. 20 (`suspended_valley_boss.rsmap`)** : Bruyverne le Cri | `suspended_valley_relay.rsground` (Biome Cimes) |

---

### D. CHAPITRE 9 — DONJONS SECONDAIRES (20 ÉTAGES / 3 ARÈNES D'ÉTAGE)

| Identifiant (`ID`) | Nom Français | Total Étages | Biomes (Seg 1 → Seg 2) | Espèces Sauvages (`20-50/donjon`, Lv 30-45) | Les 3 Arènes d'Étage (`.rsmap` intégrées, adaptées au biome) | Relais (Modèle Tunnel Incandescent + Kangourex) |
| :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| **`depleted_basin`** | **Bassin Tari** | **20 ét.** | Bassin Aride → Fond Tari | **25 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`depleted_basin_mb1.rsmap`)** : Akwakwak la Secheresse<br>• **Ét. 13 (`depleted_basin_mb2.rsmap`)** : Flagadoss le Calme<br>• **Ét. 20 (`depleted_basin_boss.rsmap`)** : Léviator le Courroux | `depleted_basin_relay.rsground` (Biome Bassin) |
| **`wayward_wetlands`** | **Marais Errants** | **20 ét.** | Marais Humide → Marais Errants | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`wayward_wetlands_mb1.rsmap`)** : Ludicolo la Danse<br>• **Ét. 13 (`wayward_wetlands_mb2.rsmap`)** : Colhomard la Pince<br>• **Ét. 20 (`wayward_wetlands_boss.rsmap`)** : Milobellus le Bassin | `wayward_wetlands_relay.rsground` (Biome Marais) |
| **`southern_jungle`** | **Jungle Méridionale** | **20 ét.** | Forêt Tropicale → Jungle Dense | **26 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`southern_jungle_mb1.rsmap`)** : Empiflor le Liane<br>• **Ét. 13 (`southern_jungle_mb2.rsmap`)** : Noadkoko le Soleil<br>• **Ét. 20 (`southern_jungle_boss.rsmap`)** : Roserade le Venin | `southern_jungle_relay.rsground` (Biome Jungle) |
| **`submerged_chasm`** | **Gouffre Immergé** | **20 ét.** | Grotte Marine → Gouffre Profond | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 6 (`submerged_chasm_mb1.rsmap`)** : Crustabri la Coquille<br>• **Ét. 13 (`submerged_chasm_mb2.rsmap`)** : Ectoplasma l'Ombre<br>• **Ét. 20 (`submerged_chasm_boss.rsmap`)** : Hyporoi le Fond | `submerged_chasm_relay.rsground` (Biome Océanique) |

---

### E. CHAPITRE 10 — DONJONS SECONDAIRES (20 ÉTAGES / 3 ARÈNES D'ÉTAGE)

| Identifiant (`ID`) | Nom Français | Total Étages | Biomes (Seg 1 → Seg 2) | Espèces Sauvages (`20-50/donjon`, Lv 35-50) | Les 3 Arènes d'Étage (`.rsmap` intégrées, adaptées au biome) | Relais (Modèle Tunnel Incandescent + Kangourex) |
| :--- | :--- | :---: | :--- | :--- | :--- | :--- |
| **`snowbound_path`** | **Sentier Enneigé** | **22 ét.** | Sentier Blanc → Col Glacial | **25 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 7 (`snowbound_path_mb1.rsmap`)** : Kaimorse le Croc<br>• **Ét. 14 (`snowbound_path_mb2.rsmap`)** : Polagriffe la Tempête<br>• **Ét. 22 (`snowbound_path_boss.rsmap`)** : Momartik le Souffle | `snowbound_path_relay.rsground` (Biome Neige) |
| **`thunderstruck_pass`** | **Col de la Foudre** | **24 ét.** | Col Orageux → Crête Foudroyée | **24 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 8 (`thunderstruck_pass_mb1.rsmap`)** : Élekable la Haute-Tension<br>• **Ét. 16 (`thunderstruck_pass_mb2.rsmap`)** : Luxray le Foudre<br>• **Ét. 24 (`thunderstruck_pass_boss.rsmap`)** : Magnézone l'Éclair | `thunderstruck_pass_relay.rsground` (Biome Électrique) |
| **`flyaway_cliffs`** | **Falaises de l'Envol** | **25 ét.** | Falaises Aériennes → Cimes Volantes | **26 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 8 (`flyaway_cliffs_mb1.rsmap`)** : Airmure la Lame<br>• **Ét. 16 (`flyaway_cliffs_mb2.rsmap`)** : Xatu l'Oracle<br>• **Ét. 25 (`flyaway_cliffs_boss.rsmap`)** : Roucarnage le Sommet | `flyaway_cliffs_relay.rsground` (Biome Falaises) |
| **`forgotten_silver_spire`** | **Cime d'Argent Oubliée** | **23 ét.** | Spirale Antique → Cime Oubliée | **25 espèces**<br>*(Stade 1 → Évolué)* | • **Ét. 7 (`forgotten_silver_spire_mb1.rsmap`)** : Alakazam l'Esprit<br>• **Ét. 15 (`forgotten_silver_spire_mb2.rsmap`)** : Gardevoir la Vision<br>• **Ét. 23 (`forgotten_silver_spire_boss.rsmap`)** : Kaorine l'Antique | `forgotten_silver_spire_relay.rsground` (Biome Tour Céleste) |

---

**J'attends ta validation** sur ce roster de **20 donjons secondaires de 20 étages exacts** (dont **3 arènes d'étage `.rsmap` par donjon** et **20 à 50 espèces sauvages en scaling évolutif**) avant d'engager la génération des fichiers de zone et de cartes !
