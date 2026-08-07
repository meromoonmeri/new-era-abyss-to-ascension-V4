# PMDSky_PMDO_Framework — Architecture & Doctrine du Framework Industriel de Portage

**Projet** : *New Era : Abyss to Ascension* (Fondation canonique PMD Explorers of Sky → PMDO/RogueEssence)  
**Source officielle analysée** : `pret/pmd-sky` ([https://github.com/pret/pmd-sky](https://github.com/pret/pmd-sky))  
**Répertoire Framework** : `PMDSky_PMDO_Framework` ([https://github.com/meromoonmeri/PMD-RED-PMDO-PORT/tree/main/PMDSky_PMDO_Framework](https://github.com/meromoonmeri/PMD-RED-PMDO-PORT/tree/main/PMDSky_PMDO_Framework))  
**Date d'établissement** : 2026-08-07

---

## 1. Vision et Objectif Industriel

Le **`PMDSky_PMDO_Framework`** n'est pas un simple extracteur d'assets bruts. C'est un **framework industriel de conversion et d'adaptation** conçu pour analyser 100 % de la décompilation de *Pokémon Mystery Dungeon: Explorers of Sky* (`pret/pmd-sky`) et générer automatiquement des structures natives PMDO / RogueEssence, **sans jamais dupliquer ce que le moteur gère déjà**.

Ce framework produit la base canonique, fidèle au pixel et à la frame près au jeu Nintendo DS, qui sert de fondation technique au mod d'histoire *New Era : Abyss to Ascension*.

---

## 2. Cartography Complète : `pret/pmd-sky` → PMDO / RogueEssence

La règle d'or du framework est le **tri sélectif rigoureux** : chaque asset ou système de la Nintendo DS est classé selon une doctrine justifiée.

```
       [ pret/pmd-sky ] (Décompilation DS complète)
                 │
                 ├─► 1. RÉUTILISER PMDO (0 duplication)
                 │      ├── Espèces, Sprites, Portraits Pokémon
                 │      ├── Capacités (SkillData), Animations de combat
                 │      ├── Intelligence Artificielle (AITactics)
                 │      └── Météos de base (Rain, Hail, Sandstorm, Sun, Fog)
                 │
                 ├─► 2. CONVERTIR & RECONSTRUIRE À 100 % (Pixel Perfect DS)
                 │      ├── Ground Maps (BPL/BPC/BMA/BPA -> .rsground + .tile)
                 │      ├── Arènes de Boss & Lieux de Vie (Metano Town, Guilde)
                 │      ├── Chorégraphies & Mise en Scène (Scripts de Scène DS -> Lua)
                 │      ├── Donjons (FloorData, Spawns, Météo, Pièges -> ZoneData/RogueElements)
                 │      └── Objets, UI et FX exclusifs
                 │
                 └─► 3. VALIDER & AUDITER (Couverture 100 %)
                        └── validate_all.py / audit_grounds_correlation.py
```

### 2.1. Tableau de Matrice de Décision

| Système DS (`pret/pmd-sky`) | Décision Framework | Justification Technique & Règle d'Intégration |
| :--- | :---: | :--- |
| **Espèces & Sprites Pokémon**<br>(`monster.json`, `chara/`) | **RÉUTILISER PMDO** | Le moteur PMDO intègre déjà le catalogue complet (`MonsterFeature.json`, 1 011 espèces), leurs sprites 8 directions, portraits et tables d'évolution. |
| **Capacités & Attaques**<br>(`skill/`, `move_table`) | **RÉUTILISER PMDO** | Les classes `SkillData`, effets, portées et animations sont natives dans RogueEssence. Seules les données d'équilibrage spécifiques à un boss sont ajustées en Lua. |
| **Intelligence Artificielle (IA)**<br>(`ai/`, `tactic/`) | **RÉUTILISER PMDO** | RogueEssence possède son propre moteur comportemental (`AITactics`, `ground_partner.lua`). Aucun code assembleur/C d'IA DS n'est porté. |
| **Météo de Donjon**<br>(`weather/`, `rain`, etc.) | **RÉUTILISER (Paramètres)** | Les moteurs de météo (`Rain`, `Sandstorm`, `Fog`, etc.) existent. On ne convertit que la **table de planification** par étage dans le JSON de zone. |
| **Ground Maps & Décors**<br>(`files/MAP_BG/`) | **CONVERTIR À 100 %** | Conversion **pixel-perfect** : décodage BMA/BPC/BPL/BPA, reconstruction des calques (*Layers*), tuiles d'animation multi-frames et grilles de collision 8 px. |
| **Arènes de Boss & Hubs**<br>(`files/MAP_BG/dXXpYY`) | **CONVERTIR À 100 %** | Import intégral des salles d'affrontement officielles (ex. `sky_d01p11a`), transformées en salles intégrées `.rsmap` adaptées aux biomes. |
| **Cinématiques (Mise en Scène)**<br>(`files/SCRIPT/`) | **CONVERTIR À 100 %** | Extraction de la **chorégraphie pure** (caméra, déplacements, pauses, silences, FX, tremblés, regards) transposée en appels Lua RogueEssence. **Zéro dialogue importé** (écriture originale New Era). |
| **Générateur de Donjon**<br>(`dungeon/`, `floor/`) | **CONVERTIR (Structures)** | L'algorithme DS est ignoré. On convertit les données brutes (étages, biomes, tables de Spawns, objets, pièges, musique) en structures `RogueElements`. |

---

## 3. Doctrine et Méthodologie par Système

### 3.1. Les Grounds : Rendu *Pixel Perfect* Nintendo DS

Le framework ne se contente pas d'extraire des index bruts (`BMA` / `BPC` / `BPL` / `BPA`). Il **reconstruit automatiquement le rendu visuel final affiché sur Nintendo DS** :
1. **Décodage multi-couches** : Lecture via `skytemple-files` des palettes et blocs graphiques.
2. **Animation par tuile (Multi-Frames)** : Chaque case 8×8 px animée (rivière, cascade, torche, drapeau, cristal lumineux) est exportée avec son cycle de frames exact (`Frames[]`) et sa durée moteur (`FrameLength`).
3. **Collision source intacte** : La grille binaire `BMA` est convertie en table d'obstacles 8 px (`Tags == 0` pour praticable, `Tags == 1` pour mur), garantissant 0 collision artificielle ni débordement.
4. **Implémentation active** : `tools/convert_sky_all.py` (467 cartes DS, `RESERVE/sky_grounds/` & `RESERVE/sky_tiles/`).

### 3.2. Cinématiques : Extraction de la Chorégraphie et du Rythme Chunsoft

Le framework dissocie les dialogues de la mise en scène. Pour chaque scène de la DS :
* **Caméra & Cadrage** : Extraction des trajectoires (`GAME:MoveCamera(x, y, speed, false)`).
* **Rythme & Pauses** : Conversion des délais en frames moteur (`GAME:WaitFrames(N)`).
* **Silences Dramatiques** : Détection des coupures de musique (`SOUND:FadeOutBGM`) avant révélation ou tension (0,5 à 2 secondes de silence).
* **Déplacements & Orientations** : Transposition des chemins 8 directions (`GeneralFunctions.EightWayMove`) et des rotations relatives (`GROUND:CharTurnToCharAnimated`).
* **Effets Visuels & Sonores** : Flashs, secousses d'écran (`BossFX.Shake`), points d'exclamation et bruitages (`SOUND:PlayBattleSE`).

### 3.3. Donjons : Génération Déclarative `RogueElements`

Le générateur de donjon DS est remplacé par le moteur de niveaux de RogueEssence :
* **Structure du donjon (`ZoneData`)** : Nombre d'étages, segmentation par biomes, relais Kangourex (`searing_tunnel_midpoint`).
* **Tables d'apparitions (`TeamSpawnZoneStep`)** : Extraction des listes de Pokémon par étage avec scaling évolutif (Stade 1 → Évolué, 20 à 50 espèces par donjon vérifiées contre `MonsterFeature.json`).
* **Enrichissement équilibré** : Injection mesurée des Dalles Miracle (`WonderTileStep`), des marchands Kecleon aléatoires (`ShopStep`, 12-15%) et des étages de repos Café Spinda (`SecretRoomStep`).

---

## 4. Architecture de Validation et Couverture

Chaque convertisseur du framework est impérativement couplé à un validateur automatisé :

1. **Validation des Grounds & Collisions (`tools/validate_all.py`)** :  
   * Vérifie 100 % des cartes (`.rsground` et `.rsmap`).
   * Calcule le pourcentage de surface marchable au pixel près.
   * Contrôle la connexité et l'accessibilité du point de départ vers les marqueurs d'entrée ou de boss.
2. **Validation du Catalogue d'Apparitions (`tools/audit_wild_spawns_exhaustif.py`)** :  
   * Vérifie que chaque espèce présente dans les `ZoneSteps` et `GenSteps` existe dans `MonsterFeature.json` (1 011 espèces officielles).
   * Contrôle la conformité des quotas (20 à 50 espèces distinctes par donjon).
3. **Audit de Réalisation Cinématique (`tools/audit_director_ch6_ch10.py`)** :  
   * Vérifie la présence de balises de respiration (`[pause=10..30]`), d'émotions et de transitions sonores/silences.
   * Certifie l'absence totale de mots interdits (Temps, Espace, Dialga, Palkia) dans le contenu secondaire.
4. **Validation Non-Régression Globale (`verify_new_era.sh`)** :  
   * S'assure que 100 % des musiques (`.ogg`), cartes (`.rsground`), tilesets (`.tile`), scripts Lua et zones JSON sont intègres et prêts pour l'exécution en jeu.

---
