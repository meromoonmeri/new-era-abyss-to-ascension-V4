# Smart Dungeon Designer

Level designer procédural déterministe et explicable pour PMDO/RogueElements.

```bash
python3 tools/smart_dungeon.py --help
python3 tools/smart_dungeon.py create --help
python3 tools/smart_dungeon.py explain-design --help
```

La Phase 2 ajoute direction artistique déduite des assets, identités d'étages,
familles de composition, fonctions de salles, rythme spatial, landmarks,
groupes décoratifs, mémoire globale et validation structurelle/artistique
séparée. La version 3 ajoute un profil de parcours complet par étage : évolution
du biome, ennemis, Pokémon neutres, loot, règles et boutiques Kecleon natives.
Les relais sont des Grounds médians à statue Kangourex séparant deux
`RangeDictSegment`, jamais des salles procédurales internes. Le boss utilise un
Ground d'introduction/conclusion et un segment de combat sans escalier.

`analyze-references` indexe par défaut toutes les Zones, Grounds, maps et
AutoTiles. `generate-ground` choisit automatiquement des références compatibles,
compose plusieurs familles de géométrie abstraite, résout les cellules par
classe/voisins/transitions, place des motifs multicellules natifs puis valide
collisions, animations, navigation, viewport et controller.
`validate-ground-runtime` étend l'overlay ignoré d'Agent A pour charger le
candidat dans PMDO 0.8.12, sonder les collisions et capturer les ticks natifs.

Documentation :

- `docs/SMART_DUNGEON_DESIGNER.md`
- `docs/SMART_DUNGEON_PHASE2_DESIGN.md`
- exemple : `docs/smart_dungeon/example_sanctuaire/`
