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
séparée. Les relais sont des Grounds médians à statue Kangourex séparant deux
`RangeDictSegment`, jamais des salles procédurales internes.

Documentation :

- `docs/SMART_DUNGEON_DESIGNER.md`
- `docs/SMART_DUNGEON_PHASE2_DESIGN.md`
- exemple : `docs/smart_dungeon/example_sanctuaire/`
