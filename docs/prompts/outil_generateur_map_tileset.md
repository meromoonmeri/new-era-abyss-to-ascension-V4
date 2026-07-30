# Outil à concevoir — Générateur de map avec tileset cohérent (New Era)

## Objectif

Concevoir un outil interne, spécifique à New Era, capable de générer ou d'assister la génération de maps (Grounds et étages de Donjons) en sélectionnant et en assemblant des tilesets qui restent cohérents avec le biome et le segment définis pour la zone concernée. L'outil ne doit jamais produire un assemblage de tiles esthétiquement incohérent, hors-style, ou étranger aux règles de progression de biome déjà définies (`conception_donjons_segmentes.md`).

Cet outil s'intègre à la suite d'outils internes du projet (générateur de cinématiques, audit de Ground, analyseur de continuité) définie dans le fichier de méthode général — il en est l'équivalent pour la partie génération de map.

## Documentation de référence obligatoire

Avant de concevoir ou de faire évoluer cet outil, s'appuyer intégralement sur la documentation suivante. Elle doit être lue et comprise avant d'écrire le moindre script de génération.

**Moteur et systèmes**
- RogueEssence (moteur) : https://github.com/RogueCollab/RogueEssence
- Documentation Lua : https://github.com/RogueCollab/RogueEssence/tree/master/RogueEssence/Lua
- RogueElements (génération procédurale) : https://github.com/audinowho/RogueElements
- PMDC (systèmes de combat) : https://github.com/PMDCollab/PMDC

**Contenu et assets**
- PMDODump : https://github.com/audinowho/PMDODump
- PMDODump releases : https://github.com/audinowho/PMDODump/releases
- DumpAsset : https://github.com/audinowho/DumpAsset
- PMDCollab/RawAsset : https://github.com/PMDCollab/RawAsset

**Tutoriels et wiki (spécifiquement pertinents pour cet outil)**
- Lesson 1 — Starting Hub Map : https://github.com/audinowho/PMDOTutorial/releases/tag/v0.1
- Lesson 2 — Ground Maps In-Depth : https://github.com/audinowho/PMDOTutorial/releases/tag/v0.2
- Lesson 3 — Dungeon Maps : https://github.com/audinowho/PMDOTutorial/releases/tag/v0.3
- Lesson 5 — Multi-Floor Generation : https://github.com/audinowho/PMDOTutorial/releases/tag/v0.5
- PMDOTutorial, toutes releases v0.1 à v0.8 : https://github.com/audinowho/PMDOTutorial/releases
- Floor Generation Overview : https://wiki.pmdo.pmdcollab.org/Floor_Generation_Overview
- Text Guide : https://wiki.pmdo.pmdcollab.org/Text_Guide
- Scripting Cheat Sheet : https://wiki.pmdo.pmdcollab.org/Scripting_Cheat_Sheet
- Script Reference : https://wiki.pmdo.pmdcollab.org/Script_Reference

**Mods et projets de référence (bibliothèque qualitative)**
- PMDO-Explorers-Maps (maps d'Explorers of Sky adaptées à PMDO) : https://github.com/slothplaysnecro/PMDO-Explorers-Maps
- pmd-red (décompilation Red Rescue Team) : https://github.com/pret/pmd-red
- ProjectEoN : https://github.com/Logical321/ProjectEoN
- Halcyon (mod PMDO d'origine du projet) : https://github.com/Palikadude/Halcyon
- ZMDO : https://github.com/RaoKurai/ZMDO
- minior-game-jam : https://github.com/CregALeg/minior-game-jam

Étudier en priorité comment ces références gèrent la cohérence de tileset par zone, les transitions entre biomes sur une même map, et la génération procédurale d'étages de donjon — reproduire la logique de conception, pas le contenu à l'identique.

## Fonctionnement attendu de l'outil

**1. Entrée**
- Le segment ou la zone à générer (référencé à sa fiche de biome définie dans `conception_donjons_segmentes.md` : type de terrain, palette, densité de végétation, altitude).
- Le type de map (Ground ou étage de Donjon).
- Pour un Donjon : la position du segment dans la progression globale (début, intermédiaire, sommet/fin), afin d'appliquer le bon niveau de nuance de biome.

**2. Sélection du tileset**
- Piocher exclusivement dans les tilesets déjà validés du projet ou dans les sources légitimes listées ci-dessus (DumpAsset, RawAsset, PMDODump).
- Vérifier que le tileset choisi correspond au biome attendu du segment (pas de tileset de forêt basse utilisé pour une zone de sommet).
- Si aucun tileset existant ne correspond exactement au biome requis, le signaler explicitement plutôt que de forcer un tileset approximant mal l'ambiance recherchée.

**3. Génération procédurale (Donjons)**
- S'appuyer sur RogueElements pour la génération de layout, en respectant les capacités et contraintes réelles du moteur (pas de logique maison qui dupliquerait ce que RogueElements sait déjà faire).
- Appliquer la variété d'étages et la courbe de difficulté définies dans `conception_donjons_segmentes.md`.
- Le biome et le tileset restent fixés par le segment ; seule la structure de l'étage (layout) varie aléatoirement.

**4. Validation avant sortie**
Avant de considérer une map générée comme valide, vérifier automatiquement :
- cohérence du tileset avec le biome du segment ;
- absence de collisions incohérentes (passage possible à travers un élément censé être solide, ou blocage d'un passage censé être ouvert) ;
- lisibilité de la composition pour la caméra (cf. règles de composition du fichier de méthode général) ;
- cohérence de la progression de biome si la map fait partie d'un donjon à segments (dégradé logique entre segments adjacents) ;
- absence d'éléments visuels orphelins ou de tiles mal raccordés (bords de transition non gérés entre deux types de terrain).

## Intégration au pipeline d'outils du projet

Ce générateur de map doit pouvoir être appelé par ou couplé aux autres outils internes déjà prévus pour New Era (générateur de cinématiques, audit de Ground, contrôleur de continuité), afin qu'une map générée par cet outil soit automatiquement compatible avec les cutscenes qui s'y dérouleront, et inversement. Toute évolution des règles de biome ou de tileset définies dans `conception_donjons_segmentes.md` doit être répercutée dans la logique de sélection de cet outil.
