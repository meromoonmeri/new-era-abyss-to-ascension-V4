# Outil à concevoir — Générateur d'entrance de donjon (avenue Kangourex)

## Périmètre et exception importante

**Ne jamais toucher aux entrances déjà construites des chapitres 1 à 5** : elles sont validées et considérées comme terminées. Cet outil s'applique exclusivement à la création de nouvelles entrances, pas à la régénération ou à la modification de l'existant déjà accepté.

## Objectif

Concevoir un outil interne, spécifique à New Era, capable de générer une zone d'entrance de donjon construite comme une avenue orientée selon un axe cardinal (est → ouest, ouest → est, ou sud → nord), découpée en segments organisés comme un camp, à l'image de la fonction que Kangourex (Kangaskhan) occupe traditionnellement à l'entrée des donjons dans les jeux PMD (garde-objets / point de service avant l'exploration).

Chaque entrance doit être **différente des autres** — pas de gabarit générique réutilisé tel quel d'un donjon à l'autre. La différenciation vient principalement du tileset, pas de la structure.

## Logique d'orientation

- L'outil doit permettre de choisir l'axe de l'avenue (est-ouest, ouest-est, ou sud-nord) selon la géographie et la logique narrative du lieu : la direction doit avoir un sens par rapport à la carte du monde et à la provenance du héros, pas être tirée au hasard sans justification.
- L'avenue relie un point d'arrivée (où le joueur entre depuis la carte du monde ou une zone de transition) à l'entrée effective du donjon, en traversant les segments de camp.

## Construction en segments de type camp

- Reprendre les templates d'entrance déjà présents dans PMDODump comme base structurelle : https://github.com/audinowho/PMDODump/tree/master/DataAsset/Docs
- La structure du camp (agencement des zones, emplacement du service façon Kangourex, emplacement des PNJ, chemin de circulation) reste fondée sur ces templates : l'outil n'a pas à réinventer la structure depuis zéro.
- **Seul le tileset doit être édité** pour adapter le camp au biome du donjon vers lequel il mène. Exemple donné : un camp forestier situé devant un donjon enneigé doit intégrer une transition vers de la neige à mesure qu'on approche de l'entrée du donjon — le segment du camp le plus proche du donjon reflète déjà le biome intérieur, exactement selon la logique de nuance progressive déjà établie pour les segments de donjon (`conception_donjons_segmentes.md`).
- S'appuyer sur l'outil de génération de map/tileset déjà spécifié (`outil_generateur_map_tileset.md`) pour la sélection et l'assemblage cohérent des tiles, en respectant les mêmes sources légitimes (DumpAsset, PMDODump, RawAsset).

## Exigence de diversité

Avant de valider une nouvelle entrance générée, vérifier qu'elle ne reproduit pas à l'identique une entrance déjà existante ailleurs dans le projet (mêmes segments, même disposition, même palette). La diversité peut venir de :
- la combinaison biome de départ / biome du donjon (camp forestier → donjon enneigé, camp désertique → donjon aquatique, etc.), qui donne naturellement une transition de tileset différente à chaque fois ;
- l'orientation de l'avenue (est-ouest, ouest-est, sud-nord), qui change la composition et le sens de lecture de la scène ;
- des variations de détails de décor spécifiques au lieu (éléments narratifs propres au donjon concerné).

## Fonctionnement attendu de l'outil

**1. Entrée**
- Le donjon cible et son biome de segment de départ (référencé à sa fiche dans `conception_donjons_segmentes.md`).
- Le biome du point de départ de l'avenue (zone d'où vient le joueur).
- L'axe d'orientation choisi.

**2. Génération structurelle**
- Construire le camp à partir des templates PMDODump, avec le nombre de segments nécessaire pour représenter une transition crédible entre les deux biomes.
- Placer le point de service façon Kangourex à un emplacement cohérent du camp (accessible, visible, non gênant pour la circulation).

**3. Édition du tileset**
- Appliquer le tileset de départ au premier segment, le tileset du donjon cible au dernier segment, et une transition progressive sur les segments intermédiaires — jamais une coupure brutale d'un biome à l'autre.

**4. Validation avant sortie**
- Vérifier la cohérence de la transition de tileset (pas de raccord abrupt ou mal géré).
- Vérifier que l'entrance ne duplique pas une combinaison déjà utilisée ailleurs.
- Vérifier le respect du périmètre : confirmer qu'aucune entrance des chapitres 1 à 5 n'a été touchée par l'exécution de l'outil.
- Appliquer l'auto-questionnement du fichier de méthode général sur le positionnement et les collisions (feu de camp, éléments de décor solides, PNJ).

## Intégration au pipeline d'outils du projet

Cet outil complète le générateur de map/tileset déjà spécifié et s'appuie sur la même logique de biome que `conception_donjons_segmentes.md`. Toute évolution des règles de biome ou de tileset doit être répercutée ici comme dans l'outil de génération de map générale.
