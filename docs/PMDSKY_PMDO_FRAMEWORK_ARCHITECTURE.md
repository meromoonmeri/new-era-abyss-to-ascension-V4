# Doctrine Officielle — PMDSky → PMDO Framework

**Projet** : *New Era : Abyss to Ascension* (Fondation canonique PMD Explorers of Sky → PMDO/RogueEssence)  
**Source officielle à analyser** : `pret/pmd-sky` ([https://github.com/pret/pmd-sky](https://github.com/pret/pmd-sky))  
**Répertoire du Framework** : `PMDSky_PMDO_Framework` ([https://github.com/meromoonmeri/PMD-RED-PMDO-PORT/tree/main/PMDSky_PMDO_Framework](https://github.com/meromoonmeri/PMD-RED-PMDO-PORT/tree/main/PMDSky_PMDO_Framework))  
**Date d'établissement** : 2026-08-07

---

## 1. Objectif

Construire un framework d'extraction et de conversion capable de porter **l'intégralité du contenu de Pokémon Mystery Dungeon: Explorers of Sky** vers RogueEssence / PMDO en conservant le comportement, le rendu visuel et la mise en scène d'origine, tout en **réutilisant systématiquement les systèmes natifs de PMDO lorsqu'ils existent déjà**.

Le framework doit être **déterministe**, **reproductible**, **auditable** et **sans approximation**.

---

## 2. Principe Fondamental

Le framework ne doit jamais recréer un système déjà implémenté dans RogueEssence ou PMDC.

Il doit uniquement :
- extraire les données originales de Sky,
- les convertir,
- les adapter au format PMDO,
- réutiliser les systèmes natifs du moteur.

Chaque conversion doit être justifiée.

---

## 3. Matrice de Décision

| Système | Décision | Justification & Règle d'Intégration |
| :--- | :---: | :--- |
| **Pokémon** | **Réutiliser PMDO** | Catalogue complet déjà implémenté dans le moteur PMDO. |
| **Portraits** | **Réutiliser PMDO** | Portraits émotionnels 8 directions natifs. |
| **Sprites Pokémon** | **Réutiliser PMDO** | Sprites 8 directions et formulaires déjà intégrés. |
| **Animations Pokémon** | **Réutiliser PMDO** | Séquences d'animation de combat, de marche et d'émotion natives. |
| **IA** | **Réutiliser PMDO** | Moteur comportemental (`AITactics`) propre à RogueEssence. |
| **Combat** | **Réutiliser PMDO** | Algorithmes de dégâts, coups critiques et priorités gérés par le moteur. |
| **Capacités** | **Réutiliser PMDO** | `SkillData`, portées, effets et animations déjà pris en charge. |
| **États** | **Réutiliser PMDO** | Statuts (Brûlure, Sommeil, Gel, etc.) gérés nativement. |
| **Talents** | **Réutiliser PMDO** | Talents et capacités spéciales intégrés au moteur. |
| **Météo** | **Réutiliser PMDO** | Météos (`Rain`, `Hail`, `Sandstorm`, `Sun`, `Fog`) natives ; convertir uniquement les paramètres de planification. |
| **Génération procédurale** | **Réutiliser RogueElements** | Algorithmes de création d'étages et de couloirs délégués à `RogueElements`. |
| **UI** | **Réutiliser PMDO** | Menus, boîtes de dialogue, fenêtres de confirmation et ATH natifs. |
| **Sauvegarde** | **Réutiliser PMDO** | Systèmes de sérialisation et de persistance gérés par RogueEssence. |

---

## 4. Ce qui doit être extrait intégralement

### 4.1. Grounds
Extraction exhaustive de tous les Grounds.

Le framework doit reconstruire exactement le rendu Nintendo DS :
- geometry
- collisions
- layers
- palettes
- BPA
- animations
- scrolling
- priorités
- transparence
- ombres
- overlays

Le résultat doit être identique au rendu obtenu dans l'émulateur.

Le framework doit produire :
- PNG de référence
- Tilesheets PMDO
- Tilesets
- rsground
- collisions
- metadata

### 4.2. Donjons
Le framework ne réimplémente pas l'algorithme DS.

Il extrait uniquement :
- nombre d'étages
- musique
- biomes
- floor rules
- spawn Pokémon
- spawn objets
- pièges
- météo
- Kecleon
- Monster Houses
- salles spéciales
- salles fixes
- boss

Puis convertit ces informations vers `RogueElements`.

### 4.3. Cinématiques
Le framework extrait uniquement la chorégraphie.  
Jamais les dialogues.

Extraction :
- caméra
- déplacements
- rotations
- vitesse
- pauses
- attentes
- timing
- animations
- expressions
- SFX
- BGM
- Fade
- Flash
- Shake
- téléportation
- spawn
- despawn
- regards
- changements de direction
- timing exact

Puis traduction vers les API Lua RogueEssence.  
Aucune réécriture artistique.  
Aucune IA.  
Simple traduction.

### 4.4. Objets
Réutiliser les objets existants dans PMDO.  
Extraire uniquement ceux absents.

Pour chaque objet absent :
- sprite
- icône
- nom
- données
- comportement
- prix
- catégorie

### 4.5. FX
Extraire :
- animations exclusives
- effets spéciaux
- effets de boss
- effets environnementaux

Convertir vers les systèmes RogueEssence.

### 4.6. Assets
Extraire :
- Grounds
- Boss Rooms
- Friend Areas
- Hub Maps
- Entrées
- Sommets
- Profondeurs
- Cutscene Maps
- Overworld Maps

Toujours avec le rendu exact.

---

## 5. Validation Obligatoire

Aucune conversion n'est considérée terminée tant que les validations suivantes n'ont pas réussi.

### 5.1. Validation Visuelle
Comparer automatiquement :
* **PNG reconstruit** vs **capture d'émulateur**

Pixel par pixel.  
Objectif : **0 différence visible**.

### 5.2. Validation Collisions
Comparer :
- murs
- eau
- lave
- trous
- obstacles

avec le jeu original.

### 5.3. Validation Cinématique
Comparer :
- caméra
- déplacements
- temps
- pauses
- animations
- FX

avec la séquence originale.

### 5.4. Validation Donjons
Comparer :
- Pokémon
- objets
- météo
- pièges
- salles fixes
- boss
- musique

avec les données DS.

### 5.5. Validation PMDO
Vérifier que chaque ressource :
- est valide
- charge correctement
- ne provoque aucune exception
- n'utilise aucun système déjà fourni par PMDO

---

## 6. Objectif Final

Le framework doit permettre de reconstruire **100 % du contenu de Pokémon Mystery Dungeon: Explorers of Sky** dans RogueEssence en utilisant exclusivement les systèmes natifs de PMDO lorsqu'ils existent, et en convertissant uniquement les données et ressources absentes.

Le résultat recherché n'est pas une réinterprétation du jeu, mais une **transposition fidèle** : le rendu visuel, la géométrie, les animations, les cinématiques, les donjons et les ressources exclusives doivent être reproduits aussi fidèlement que possible, tandis que le gameplay de base (combat, IA, météo, Pokémon, capacités, génération procédurale) reste pris en charge par les implémentations natives de RogueEssence, PMDC et `RogueElements`.
