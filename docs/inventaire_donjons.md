# Inventaire central des donjons — reconstruction canonique Ch. 6 à 32

> **Source de vérité active depuis la purge des substituts Ch. 6–32 :**
> [`docs/canonical/MASTER_TIMELINE_CH5_CH32.json`](canonical/MASTER_TIMELINE_CH5_CH32.json).
>
> Les anciens tableaux de donjons secondaires New Era, leurs mini-boss inventés
> et leurs arènes de remplissage ne décrivent plus du contenu actif. Ils ne
> doivent pas être réintroduits par copie.

## Convention de production

- La construction se fait **chapitre par chapitre**, jamais par génération de
  masse non vérifiée.
- Chaque entrée doit recevoir : un dossier DTEF RawAsset associé, des étages
  RogueElements régénérés à chaque visite, une entrée, un point médian, une
  salle de boss fixe si le donjon en a une, et des tables Pokémon/objets
  adaptées d'une source canonique documentée.
- Les noms des Grounds suivent strictement
  `[donjon]_entrance`, `[donjon]_mid`, `[donjon]_boss`, puis seulement
  `[donjon]_fond` **ou** `[donjon]_sommet` si la direction canonique le justifie.
- Les noms affichés d'étage suivent `[Nom du donjon] [numéro]`.
- Une zone n'est marquée **construite** qu'après validations JSON, index,
  connectivité, variation 5–10 passages et essai PMDO en jeu.

## État actuel

| Ch. | Zone technique | Donjon public canonique | Boss/issue | État |
|---:|---|---|---|---|
| 6 | `gloomy_forest` | Sinister Woods / Forêt Sinistre | Team Meanies, 13F | **construit — validation statique** |
| 7 | `magma_cavern` | Magma Cavern | Groudon | à construire |
| 8 | `waterfall_pond` | Crystal Sanctuary / Waterfall Pond séparé | Diancie / postgame séparé | à arbitrer puis construire |
| 9 | `bottomless_sea` | Bottomless Sea | Kyogre | à construire |
| 10 | `sky_tower` | Sky Tower | Rayquaza | à construire |
| 11 | `fugitive_arc` | Those Accused | — | à construire |
| 12 | `treasure_town` | A New Guild Road | — | à construire |
| 13 | `waterfall_cave` | Waterfall Cave | — | à construire |
| 14 | `fogbound_lake` | Fogbound Lake | Uxie | à construire |
| 15 | `amp_plains` | Amp Plains | — | à construire |
| 16 | `quicksand_cave` | Quicksand Cave | Mesprit | à construire |
| 17 | `crystal_crossing` | Crystal Crossing | Azelf | à construire |
| 18 | `brine_cave` | Brine Cave and Hidden Land | — | à construire |
| 19 | `temporal_tower` | Temporal Tower Restored | Dialga | à construire |
| 20 | `mystifying_forest` | Graduation Legacy | — | à construire |
| 21 | `crevice_cave` | Crevice Cave | Froslass | à construire |
| 22 | `miracle_sea` | Miracle Sea | — | à construire |
| 23 | `dark_crater` | Dark Crater | Darkrai | à construire |
| 24 | `sky_peak` | Sky Peak | Shaymin | à construire |
| 25 | `spacial_rift` | Spacial Rift | Palkia | à construire |
| 26 | `world_abyss` | World Abyss | Giratina | à construire |
| 27 | `zero_isle` | Zero Isle Network | — | à construire |
| 28 | `destiny_tower` | Destiny Tower | Arceus | à construire |
| 29 | `hidden_land` | Hidden Land Fracture | Yveltal | à construire |
| 30 | `the_sky` | Sky Suspended | Zygarde | à construire |
| 31 | `starfall_heights` | The Two Lights | Necrozma | à construire |
| 32 | `world_nerve` | Abyss to Ascension | Necrozma → Eternatus → Arceus | à construire |

## Lot Ch. 6 — Sinister Woods

| Élément | Fichier / décision |
|---|---|
| Zone | `Data/Zone/gloomy_forest.json` |
| Entrée | `sinister_woods_entrance` |
| Relais Kangourex | `sinister_woods_mid` |
| Boss Ground | `sinister_woods_boss` |
| Boss map | `Data/Map/sinister_woods_boss.rsmap` |
| Étages | 1–10 → relais → 11–12 → boss fixe 13 |
| Matériau | `sinister_woods_b41_floor/wall/secondary` + source `Content/TileDtef/sinister_woods/TreeshroudForest1/` |
| Données source | [Bulbapedia — Sinister Woods](https://bulbapedia.bulbagarden.net/wiki/Sinister_Woods) |
| Fiche | [`docs/canonical_dungeons/SINISTER_WOODS.md`](canonical_dungeons/SINISTER_WOODS.md) |

Les quinze espèces sauvages officielles, les niveaux de référence, l'absence
canonique de pièges/Maisons de Monstres/boutique Kecleon/objets enfouis et le
trio de Team Meanies sont documentés dans la fiche Ch. 6.
