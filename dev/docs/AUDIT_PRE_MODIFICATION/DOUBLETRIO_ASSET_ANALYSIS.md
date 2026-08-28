# DOUBLETRIO — ANALYSE DES ASSETS

## Inventaire Content/ (85 fichiers seulement)
| Dossier | N | Contenu |
|---|---|---|
| BG | 1 | fond titre |
| Chara | 3 | sprites custom (shopkeeper, PNJ) |
| Icon | 21 | icônes UI (menus wish/enchant) |
| Item | 4 | sprites d'objets custom |
| Music | 19 | musiques originales commandées (Danirbu, FiveNineSquared, Yash) |
| Object | 23 | objets ground (crystaux — base craftpix réadaptée) |
| Particle | 3 | VFX custom (minimal !) |
| Portrait | 2 | portraits |
| Sound | 1 | SFX |
| Tile | 5 | tilesets (dont ice_maze_with_lava) |
| UI | 2 | éléments d'interface |

## Data/ contenu-jeu
- **Item 163** : le plus gros investissement data — wish gems, crystals, enchantements (l'identité du donjon est portée par l'ÉCONOMIE d'objets, pas par les assets visuels).
- **Status 45 + MapStatus 11** : effets custom (Frostbite crédité MistressNebula, Shimmering...) = mécaniques de combat nouvelles en pure data + handlers Lua.
- **Tile 22** : pièges/tuiles custom (a_pitfall_trap, fire_tile, ice_tile, wish_*, sealed_*, hidden_item_tile, tile_no_item, trap_haze/heal, crystals).
- **AutoTile 3** : un seul tileset procédural custom (ice_maze_with_lava floor/wall/secondary) — tout le reste réutilise les autotiles vanilla.
- **AI 9** : comportements ennemis custom (rôles — changelog « Roles assigned instead of Normal »).

## Pipeline assets identifié
`scripts/tiledtef/` : outillage Tiled → DTEF → autotile PMDO. Même philosophie que notre pipeline ROM→DTEF→AutoTile : l'autotile est une STRUCTURE (47 masques), jamais un simple PNG.

## Leçons
1. **Ratio data/assets ≈ 10:1** : un bon donjon PMDO est surtout du JSON (économie, statuts, spawns), très peu d'assets.
2. Réutilisation systématique du vanilla (règle « natif avant custom ») — cohérent avec notre règle d'or §79.
3. Les 3 particules suffisent car PMDO fournit déjà le système VFX complet (skills/statuts) — le mod n'ajoute que les VFX spécifiques à ses mécaniques.
4. Items custom richement thématisés = levier de rejouabilité le moins coûteux.
