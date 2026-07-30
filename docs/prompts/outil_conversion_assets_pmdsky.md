# Outil à concevoir — Conversion d'assets décompilés PMD Sky vers le format PMDO

## Objectif

Concevoir un outil interne, spécifique à New Era, capable de convertir des assets issus de décompilations/extractions libres de Pokémon Mystery Dungeon: Explorers of Sky vers le format attendu par RogueEssence/PMDO, **en préservant leur intégrité totale** : aucun recadrage (crop), aucune frame d'animation manquante, aucune perte de palette, de hitbox, d'offset ou de métadonnée d'animation.

Le format source (Sky, NDS) et le format cible (PMDO) ne sont pas structurellement identiques. L'outil doit donc faire une conversion fidèle, pas une réinterprétation approximative — en cas de doute sur une correspondance de champ ou de structure entre les deux formats, marquer l'élément comme "à vérifier manuellement" plutôt que de deviner une valeur.

## Sources et documentation de référence

Avant de concevoir cet outil, étudier les projets suivants qui traitent déjà l'extraction et la structure des données de PMD Explorers of Sky :

- **pret/pmd-sky** — décompilation d'Explorers of Sky : https://github.com/pret/pmd-sky
- **UsernameFodder/pmdsky-debug** — informations de reverse engineering (tables de symboles, structures mémoire, layout des données) pour Explorers of Sky : https://github.com/UsernameFodder/pmdsky-debug
- **SkyTemple/skytemple-files** — bibliothèque d'extraction/lecture des fichiers de données et sprites d'Explorers of Sky (formats d'animation, sprites, palettes) : dépôt de l'organisation SkyTemple sur GitHub
- **SkyTemple/skytemple** — application d'édition de ROM Explorers of Sky, référence pour comprendre comment les sprites, animations et hitboxes sont structurés et manipulés côté Sky : dépôt de l'organisation SkyTemple sur GitHub

Ces projets ne sont pas des sources d'assets à copier directement dans New Era : ce sont des références techniques pour comprendre **la structure exacte du format source** (organisation des frames d'animation, palettes indexées, offsets de sprite, métadonnées de hitbox/collision) avant de bâtir la conversion vers le format PMDO. Rappel : toute réutilisation d'assets doit rester conforme aux sources légitimes déjà validées pour ce projet (Règle 7 du fichier de méthode général).

Pour le format cible, se référer à la documentation déjà validée pour ce projet :
- RogueEssence (moteur) : https://github.com/RogueCollab/RogueEssence
- Documentation Lua : https://github.com/RogueCollab/RogueEssence/tree/master/RogueEssence/Lua
- DumpAsset (référence de structure d'assets déjà utilisée côté PMDO) : https://github.com/audinowho/DumpAsset

## Exigences d'intégrité (non négociables)

1. **Aucune frame d'animation manquante** : le nombre de frames de l'asset converti doit être strictement identique au nombre de frames de l'asset source, pour chaque animation (marche, attaque, dégât, victoire, etc.).
2. **Aucun recadrage** : les dimensions et le cadrage de chaque frame doivent être conservés tels quels. Si le format cible impose une contrainte de dimension différente, adapter la logique d'import plutôt que de rogner le sprite.
3. **Palette et couleurs préservées** : pas de perte ou d'altération de palette lors de la conversion.
4. **Offsets et points d'ancrage conservés** : les points d'ancrage (centre du sprite, décalage entre frames, offsets liés aux effets) doivent être reportés fidèlement, pour que l'animation reste alignée une fois importée dans PMDO.
5. **Hitboxes et données de collision préservées** si le format source les inclut.
6. **Vitesse et timing d'animation préservés** : la cadence originale entre les frames ne doit pas être altérée par la conversion, sauf ajustement explicitement demandé.

## Fonctionnement attendu de l'outil

**1. Analyse de l'asset source**
- Identifier le format exact fourni (spritesheet, données d'animation séparées, structure issue de pmd-sky/pmdsky-debug/skytemple-files).
- Extraire un inventaire complet : nombre de frames par animation, dimensions, palette, offsets, hitboxes.

**2. Mapping vers le format PMDO**
- Étudier la structure attendue par RogueEssence pour les sprites et animations de Pokémon.
- Construire une table de correspondance explicite entre les champs du format source et ceux du format cible.
- Documenter tout champ du format source qui n'a pas d'équivalent direct côté PMDO, plutôt que de le supprimer silencieusement.

**3. Conversion**
- Convertir l'asset en respectant strictement les exigences d'intégrité ci-dessus.
- Produire un rapport de conversion listant : nombre de frames avant/après (doivent être égaux), toute anomalie détectée, tout champ non mappé.

**4. Validation post-conversion**
- Comparer visuellement (frame par frame si possible) l'asset converti à l'asset source.
- Vérifier que l'animation importée dans PMDO conserve le même nombre de frames, le même rythme et le même alignement que l'original.
- Si une divergence est détectée, ne pas valider automatiquement l'asset : la signaler pour vérification manuelle.

## Intégration au pipeline d'outils du projet

Cet outil de conversion s'ajoute à la suite d'outils internes de New Era (générateur de cinématiques, générateur de map, audit de Ground, contrôleur de continuité). Les assets convertis avec succès doivent être stockés dans les emplacements déjà définis comme sources légitimes du projet, pour rester utilisables par les autres outils sans étape de validation supplémentaire.
