# Zones Amis de Rondoudou — Intégration New Era

> Basé sur les Friend Areas de PMD Rescue Team.
> Source : données adaptées PMDO (Google Drive référencé).
> Document lié à `PROMPT_MAITRE.md`, `directive_monde_vivant.md`.

---

## Les Friend Areas dans Rescue Team

### Principe original

Après avoir recruté un Pokémon, le joueur peut lui attribuer une Zone Ami
(Friend Area) — un habitat où le Pokémon vit quand il ne fait pas partie
de l'équipe active. Chaque Zone Ami a :
- Un biome unique (forêt, étang, volcan, etc.)
- Des Pokémon résidents qui s'y promènent
- Un décor interactif

### Progression

Les Zones Amis sont achetées auprès de Rondoudou (Wigglytuff) dans
Rescue Team, ou débloquées par l'histoire. Elles représentent la
croissance de l'équipe et la construction d'un foyer.

---

## Adaptation New Era

### Placement narratif

Les Zones Amis sont débloquées **progressivement** à partir du chapitre 4
(après l'Assemblée) et tout au long de l'aventure. Rondoudou (Wigglytuff,
instance `Groodoudou` dans New Era) gère leur accès depuis Metano Town.

### Intégration au système LegendZones

Les Zones Amis utilisent le système `LegendZones.lua` déjà en place :
- Chaque Zone Ami est une entrée dans la table LegendZones
- Débloquée par achat (Éclats d'Âme) ou par progression narrative
- Le ground associé est une carte d'exploration libre (pas de donjon)

### Zones Amis planifiées (16 zones)

| # | Nom FR | Biome | Pokémon résidents | Déblocage |
|---|---|---|---|---|
| 1 | Prairie Lumineuse | Plaine | Roucool, Rattata, Chenipan | ch4 (gratuit, Assemblée) |
| 2 | Étang Paisible | Eau | Magicarpe, Barpau, Lombre | ch5 (achat) |
| 3 | Forêt Ancienne | Forêt | Chenipotte, Balignon, Granivol | ch5 (achat) |
| 4 | Caverne Cristalline | Grotte | Onix, Racaillou, Nosferapti | ch6 (achat) |
| 5 | Sommet Venteux | Montagne | Airmure, Éoko, Nidorino | ch6 (achat) |
| 6 | Jardin Suspendu | Fleurs | Papilusion, Rosélia, Ceriflor | ch7 (narratif) |
| 7 | Rivage Doré | Plage | Staross, Lokhlass, Otaria | ch8 (achat) |
| 8 | Volcan Endormi | Lave | Limagma, Torkoal, Magmar | ch8 (achat) |
| 9 | Marais Brumeux | Marais | Rosélia, Nostenfer, Tentacool | ch9 (narratif) |
| 10 | Ciel Étoilé | Ciel nocturne | Soporifik, Noarfang, Mentali | ch10 (narratif) |
| 11 | Temple des Glaces | Glace | Artikodin, Oniglali, Regice | ch12 (achat) |
| 12 | Désert des Mirages | Désert | Desseliandre, Libégon, Cacnea | ch14 (achat) |
| 13 | Abysses Marines | Océan profond | Kyogre, Laggron, Léviator | ch16 (narratif) |
| 14 | Jardin du Temps | Forêt magique | Celebi, Florizarre, Tortank | ch20 (narratif) |
| 15 | Pic de l'Aurore | Sommet sacré | Ho-Oh, Sulfura, Électhor | ch24 (narratif) |
| 16 | Sanctuaire Final | Dimension | Arceus, Mew, Jirachi | ch32 (post-game) |

### Ground de chaque Zone Ami

Chaque Zone Ami est un ground exploré librement :
- Carte de ~600×400 px (biome dédié)
- 4-8 PNJ résidents avec dialogues variables
- Kangaskhan Rock pour stockage local
- Musique d'ambiance propre au biome
- Pas de combat (zone de repos)
- Les Pokémon recrutés s'y promènent quand inactifs

### Intégration au monde vivant

Les Zones Amis respectent les mêmes standards que Metano Town :
- PNJ réactifs aux événements de l'histoire (TownVoices pattern)
- Positions variables par jour (TownPositions pattern)
- Dialogues qui évoluent selon les chapitres

---

## Implémentation technique

### Structure de données

```lua
-- Dans LegendZones.lua, ajout des entrées friend_area
friend_areas = {
  prairie_lumineuse = {
    key = 'prairie_lumineuse', species = nil, -- pas de légendaire
    ground = 'friend_prairie',
    cost = 0,  -- gratuit (ch4)
    condition = function() return SV.ChapterProgression.Chapter >= 4 end,
  },
  etang_paisible = {
    key = 'etang_paisible', species = nil,
    ground = 'friend_pond',
    cost = 500,  -- Éclats d'Âme
    condition = function() return SV.ChapterProgression.Chapter >= 5 end,
  },
  -- ... etc
}
```

### SV.FriendAreas

```lua
SV.FriendAreas = {
  Unlocked = {},       -- [key] = true
  Visited = {},        -- [key] = true
  Residents = {},      -- [key] = {species1, species2, ...}
  TotalPurchased = 0,
}
```

### Accès depuis Metano Town

Groodoudou (Wigglytuff) dans Metano Town propose :
1. Liste des Zones Amis disponibles (selon chapitre + argent)
2. Achat/déblocage de nouvelles zones
3. Téléportation vers une zone déjà débloquée
4. Vue des résidents de chaque zone

---

## Google Drive — données adaptées PMDO

Le document référencé contient les données détaillées de chaque Zone Ami
adaptées au format PMDO. À intégrer quand accessible :
- Tilesets recommandés pour chaque biome
- Positions des PNJ résidents
- Dialogues de base
- Musique associée

En attendant, les Zones Amis peuvent être construites avec les tilesets
existants du projet (VastSteppe, LuminousSpring, RelicForest, etc.).
