# Inventaire central des donjons — livrable canonique unique Ch. 6 à 32

> **Périmètre livré :** les 27 routes principales et les 51 donjons PMD Red du roster, fusionnés dans un seul bundle.
> **Registre machine :** [`docs/canonical_dungeons/complete_bundle_registry.json`](canonical_dungeons/complete_bundle_registry.json).

## Résumé de livraison

- Routes principales : **27** ;
- roster PMD Red : **51** ;
- lieux partagés/dédupliqués : **5** ;
- zones physiques générées : **72**, auxquelles s’ajoute `gloomy_forest` déjà construit ;
- chaque zone physique possède entrée, midpoint Kangourex, finale/boss, scripts, index et binding DTEF.

La spécification, les données source normalisées et les contrôles sont décrits dans [COMPLETE_BUNDLE.md](canonical_dungeons/COMPLETE_BUNDLE.md).

## Routes principales

| Ch. | Zone technique | Nom public | Boss/issue | État |
|---:|---|---|---|---|
| 6 | `gloomy_forest` | Forêt Sinistre | — | détaillé Ch. 6 |
| 7 | `magma_cavern` | Grotte Magma | groudon | généré dans le bundle |
| 8 | `waterfall_pond` | Sanctuaire de Cristal | diancie | généré dans le bundle |
| 9 | `bottomless_sea` | Mer Sans Fond | kyogre | généré dans le bundle |
| 10 | `sky_tower` | Tour Céleste | rayquaza | généré dans le bundle |
| 11 | `fugitive_arc` | Les Accusés | — | généré dans le bundle |
| 12 | `treasure_town` | Nouvelle Route de Guilde | — | généré dans le bundle |
| 13 | `waterfall_cave` | Grotte Cascade | — | généré dans le bundle |
| 14 | `fogbound_lake` | Lac Brumeux | uxie | généré dans le bundle |
| 15 | `amp_plains` | Plaines Ampère | — | généré dans le bundle |
| 16 | `quicksand_cave` | Grotte Sables Mouvants | mesprit | généré dans le bundle |
| 17 | `crystal_crossing` | Passage Cristal | azelf | généré dans le bundle |
| 18 | `brine_cave` | Grotte Saumâtre et Terre Cachée | — | généré dans le bundle |
| 19 | `temporal_tower` | Tour du Temps Restaurée | dialga | généré dans le bundle |
| 20 | `mystifying_forest` | Héritage de la Remise de Diplôme | — | généré dans le bundle |
| 21 | `crevice_cave` | Grotte Fissure | froslass | généré dans le bundle |
| 22 | `miracle_sea` | Mer Miracle | — | généré dans le bundle |
| 23 | `dark_crater` | Cratère Obscur | darkrai | généré dans le bundle |
| 24 | `sky_peak` | Pic Céleste | shaymin | généré dans le bundle |
| 25 | `spacial_rift` | Faille Spatiale | palkia | généré dans le bundle |
| 26 | `world_abyss` | Abîme du Monde | giratina | généré dans le bundle |
| 27 | `zero_isle` | Réseau Île Zéro | — | généré dans le bundle |
| 28 | `destiny_tower` | Tour du Destin | arceus | généré dans le bundle |
| 29 | `hidden_land` | Fracture de la Terre Cachée | yveltal | généré dans le bundle |
| 30 | `the_sky` | Ciel Suspendu | zygarde | généré dans le bundle |
| 31 | `starfall_heights` | Les Deux Lumières | necrozma | généré dans le bundle |
| 32 | `world_nerve` | Des Abysses à l’Ascension | necrozma, eternatus, arceus | généré dans le bundle |

## Roster PMD Red

| # | Zone technique / alias | Donjon source | Ch. | Étages | Boss | État |
|---:|---|---|---:|---:|---|---|
| 1 | `red_tinywoods` | Tiny Woods / Forêt Tendre | 7 | 3 | — | généré dans le bundle |
| 2 | `red_thunderwavecave` | Thunderwave Cave / Grotte Statique | 7 | 5 | — | généré dans le bundle |
| 3 | `red_mtsteel` | Mt. Steel / Pic Ferreux | 7 | 9 | — | généré dans le bundle |
| 4 | `gloomy_forest` (partagé) | Sinister Woods / Bois Sombres | 8 | 13 | — | alias du lieu principal |
| 5 | `red_silentchasm` | Silent Chasm / Gouffre Muet | 8 | 9 | — | généré dans le bundle |
| 6 | `red_mtthunder` | Mt. Thunder / Mont Grondant | 9 | 10 | — | généré dans le bundle |
| 7 | `red_mtthunderpeak` | Mt. Thunder Peak / Cime du Mont Grondant | 9 | 3 | Zapdos | généré dans le bundle |
| 8 | `red_greatcanyon` | Great Canyon / Grand Canyon | 9 | 12 | — | généré dans le bundle |
| 9 | `red_lapiscave` | Lapis Cave / Grotte Lazuli | 10 | 14 | — | généré dans le bundle |
| 10 | `red_mtblaze` | Mt. Blaze / Mont Cendré | 10 | 12 | — | généré dans le bundle |
| 11 | `red_mtblazepeak` | Mt. Blaze Peak / Cime du Mont Cendré | 10 | 3 | Moltres | généré dans le bundle |
| 12 | `red_frostyforest` | Frosty Forest / Forêt Givrée | 11 | 9 | — | généré dans le bundle |
| 13 | `red_frostygrotto` | Frosty Grotto / Grotte Givrée | 11 | 5 | Articuno | généré dans le bundle |
| 14 | `red_mtfreeze` | Mt. Freeze / Mont Gelé | 11 | 15 | — | généré dans le bundle |
| 15 | `red_mtfreezepeak` | Mt. Freeze Peak / Cime du Mont Gelé | 12 | 5 | — | généré dans le bundle |
| 16 | `magma_cavern` (partagé) | Magma Cavern / Gorge Ardente | 12 | 23 | — | alias du lieu principal |
| 17 | `magma_cavern` (partagé) | Magma Cavern Pit / Fond de la Gorge Ardente | 12 | 3 | Groudon | alias du lieu principal |
| 18 | `sky_tower` (partagé) | Sky Tower / Tour Céleste (déjà) | 10 | 25 | — | alias du lieu principal |
| 19 | `sky_tower` (partagé) | Sky Tower Summit / Sommet de la Tour Céleste (déjà) | 10 | 9 | Rayquaza | alias du lieu principal |
| 20 | `red_stormysea` | Stormy Sea / Mer Orageuse | 13 | 40 | Kyogre | généré dans le bundle |
| 21 | `red_silvertrench` | Silver Trench / Fosse d'Argent | 13 | 99 | Lugia | généré dans le bundle |
| 22 | `red_meteorcave` | Meteor Cave / Grotte de la Météorite | 14 | 20 | Deoxys | généré dans le bundle |
| 23 | `red_westerncave` | Western Cave / Grotte Occidentale | 14 | 99 | Mewtwo | généré dans le bundle |
| 24 | `red_wishcave` | Wish Cave / Grotte du Vœu | 15 | 99 | Jirachi | généré dans le bundle |
| 25 | `red_buriedrelic` | Buried Relic / Relique Enfouie | 15 | 99 | Regis | généré dans le bundle |
| 26 | `red_pitfallvalley` | Pitfall Valley / Vallon Perdu | 16 | 25 | — | généré dans le bundle |
| 27 | `red_northernrange` | Northern Range / Chaîne Nordique | 16 | 25 | Latios | généré dans le bundle |
| 28 | `red_desertregion` | Desert Region / Région Désertique | 17 | 20 | — | généré dans le bundle |
| 29 | `red_southerncavern` | Southern Cavern / Caverne Méridionale | 17 | 50 | — | généré dans le bundle |
| 30 | `red_wyvernhill` | Wyvern Hill / Colline aux Drakes | 18 | 30 | — | généré dans le bundle |
| 31 | `red_fieryfield` | Fiery Field / Plaine Ardent | 18 | 30 | Entei | généré dans le bundle |
| 32 | `red_northwindfield` | Northwind Field / Champ du Vent du Nord | 19 | 30 | Suicune | généré dans le bundle |
| 33 | `red_solarcave` | Solar Cave / Grotte Solaire | 19 | 20 | — | généré dans le bundle |
| 34 | `red_lightningfield` | Lightning Field / Champ de Foudre | 20 | 30 | Raikou | généré dans le bundle |
| 35 | `red_darknightrelic` | Darknight Relic / Relique de la Nuit | 20 | 15 | — | généré dans le bundle |
| 36 | `red_murkycave` | Murky Cave / Caverne Trouble | 21 | 19 | — | généré dans le bundle |
| 37 | `red_grandsea` | Grand Sea / Grande Mer | 21 | 30 | — | généré dans le bundle |
| 38 | `red_uproarforest` | Uproar Forest / Forêt du Tumulte | 22 | 10 | — | généré dans le bundle |
| 39 | `red_odditycave` | Oddity Cave / Caverne Étrange | 22 | 15 | — | généré dans le bundle |
| 40 | `red_remainsisland` | Remains Island / Île des Vestiges | 23 | 20 | — | généré dans le bundle |
| 41 | `red_marveloussea` | Marvelous Sea / Mer Merveilleuse | 23 | 20 | — | généré dans le bundle |
| 42 | `red_fantasystrait` | Fantasy Strait / Détroit Fantastique | 24 | 30 | — | généré dans le bundle |
| 43 | `red_rockpath` | Rock Path / Sentier Rocheux | 24 | 4 | — | généré dans le bundle |
| 44 | `red_snowpath` | Snow Path / Sentier Neigeux | 25 | 4 | — | généré dans le bundle |
| 45 | `red_howlingforest` | Howling Forest / Forêt des Hurlements | 25 | 15 | — | généré dans le bundle |
| 46 | `red_waterfallpond` | Waterfall Pond / Étang de la Cascade | 26 | 19 | — | généré dans le bundle |
| 47 | `red_unownrelic` | Unown Relic / Relique des Zarbi | 26 | 11 | — | généré dans le bundle |
| 48 | `red_joyoustower` | Joyous Tower / Tour Joyeuse | 27 | 99 | — | généré dans le bundle |
| 49 | `red_faroffsea` | Far-Off Sea / Mer Lointaine | 27 | 75 | — | généré dans le bundle |
| 50 | `red_mtfaraway` | Mt. Faraway / Mont Lointain | 28 | 40 | Ho-Oh | généré dans le bundle |
| 51 | `red_purityforest` | Purity Forest / Forêt de la Pureté | 29 | 99 | Celebi | généré dans le bundle |

## Convention

- Grounds : `[zone]_entrance`, `[zone]_mid`, `[zone]_boss` ; un suffixe `_fond` ou `_sommet` n’est utilisé que lorsqu’une source verticale le justifie.
- Étages : `[Nom du donjon] [numéro]` grâce à `MapNameIDStep` et à l’offset de segment.
- Les zones Red tirent leurs Pokémon/niveaux/items du snapshot normalisé de `pret/pmd-red`; les routes sans équivalent Red utilisent un pool cohérent explicitement signalé dans le registre.
- Aucun layout procédural n’est sauvegardé : les familles RogueElements sont choisies à chaque visite.
