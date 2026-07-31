# Conversion et audit des donjons — Rescue Team + ProjectEoN

> Audit demandé avant toute décision d'intégration. **Aucune décision
> narrative n'est prise ici** : le chapitre 6 reste ouvert.
> Rien n'est validé manette en main.

## Ce qui a été converti

**52 zones Rescue Team** au format PMDO, soit **1440 étages** et
**3481 entrées de bestiaire**. Toutes en `Released = false` : elles sont
chargeables mais volontairement invisibles tant qu'aucune n'est testée.

Outil : `tools/convert_rescue_team.py`.

## Ce que la source donne — et ce qu'elle ne donne pas

La décompilation `jtjanecek/rogue-rescue-team` expose deux fichiers
exploitables par donjon :

| fichier | contenu | exploitable |
|---|---|---|
| `floor_id.json` | nombre d'étages, index de tables | **oui** |
| `pokemon_found.json` | espèce, niveau, probabilité, par plage d'étages | **oui** |
| `main_data.inc` | géométrie et réglages d'étage | **non** — octets bruts GBA, format non documenté dans le dépôt |

**Décision assumée** : `main_data.inc` n'est pas utilisé. Deviner la
signification de chaque octet produirait des donjons faux, pas des
donjons fidèles. La conversion reprend donc l'**identité** du donjon —
bestiaire, niveaux, profondeur, progression — et confie la géométrie à
RogueElements, le générateur natif du moteur. C'est ce que demande le
brief : « adapter au moteur », pas transposer une structure GBA que
RogueEssence ne sait pas lire.

### Fidélité conservée

- nombre d'étages **exact** de chaque donjon d'origine ;
- bestiaire **exact**, avec les niveaux d'origine ;
- probabilités converties du format GBA (sur 10000) en poids PMDO ;
- **découpage en plages d'étages respecté** : le nom des tables porte la
  plage en clair (`MagmaCavern_1F_3F`), on la lit au lieu de répartir le
  bestiaire au hasard. C'est ce qui préserve la courbe de difficulté.

### Le piège de la validation d'espèces

Première tentative : filtrer les espèces sur les listes du mod. Résultat,
**84 espèces écartées à tort** — `machop`, `arcanine`, `espeon`, `golem`…
`Data/Monster` ne contient que 22 surcharges locales, et
`mission_gen.lua` n'énumère qu'une sélection de recrutables.

Solution : valider par **numéro dans la table ROM**
(`include/constants/monster.h`). Attention, cette numérotation n'est pas
le Pokédex national — elle compte les formes comme entrées distinctes
(Absol y porte le 387 alors qu'il est le 359ᵉ). Borne retenue : **1 à
427**, au-delà commencent `MONSTER_DECOY`, `MONSTER_STATUE`,
`MONSTER_RAYQUAZA_CUTSCENE`, qui ne sont pas des Pokémon.

Résultat : **0 espèce écartée** sur les 52 donjons.

## Audit des arènes de boss

**65 rencontres de boss ou légendaire** relevées dans les données
d'origine, avec leurs niveaux exacts.

### Boss d'histoire (ligne principale de Rescue Team)

| donjon | étage | boss | niveau |
|---|---|---|---|
| Mt. Thunder Peak | 3F | **Zapdos** | 25 |
| Mt. Blaze Peak | 3F | **Moltres** | 32 |
| Frosty Grotto | 5F | **Articuno** | 33 |
| **Magma Cavern Pit** | **3F** | **Groudon** | **27** |
| Sky Tower Summit | 9F | **Rayquaza** | 35 |
| Sinister Woods | 13F | Gengar | 15 |

### Post-histoire et donjons de légendaires

| donjon | boss | niveau |
|---|---|---|
| Stormy Sea | Kyogre | 25 |
| Silver Trench | Lugia | 30 |
| Mt. Faraway | Ho-Oh | 50 |
| Northern Range | Latias / Latios | 28 / 30 |
| Fiery Field | Entei | 45 |
| Lightning Field | Raikou | 45 |
| Northwind Field | Suicune | 45 |
| Meteor Cave | Deoxys | 35 |
| Buried Relic | Regirock / Regice / Registeel / Mew | 18 / 23 / 25 / 40 |
| Purity Forest | Celebi | 45 |
| Wish Cave | Jirachi | 40 |
| Western Cave | Mewtwo | 40 |
| Darknight Relic | Gengar | 32 |

### Ce que révèle Magma Cavern Pit

La Fosse compte **3 étages**, et son bestiaire est une progression de
combat, pas une zone d'exploration :

```
1F  Onix 30, Steelix 25
2F  Tyranitar 50, Charizard 55
3F  Alakazam 50, Groudon 27
```

**Alakazam niveau 50 est présent au même étage que Groudon.** C'est la
Team ACT du jeu d'origine — elle n'est pas à inventer, elle est dans les
données. Même schéma dans Western Cave (`Alakazam 50 + Tyranitar 50 +
Charizard 40`, puis `Mewtwo 40`) : le trio complet de Team ACT.

Cela répond directement à l'intention exprimée — Groudon, la Caverne
Magma, et l'intervention de la Team Alakazam forment un ensemble déjà
cohérent dans la source.

## Donjons écartés de la conversion

12 entrées mises de côté, avec la raison :

| entrée | raison |
|---|---|
| `Autopilot`, `DojoRegistration` | structures de service, pas des lieux — le brief exige un nom de **lieu**, pas de fonction |
| `D50`, `D51`, `D54`, `D61`, `D63` | donjons sans nom canonique identifiable |
| `Boss3`, `Boss4`, `Boss9` | salles de boss isolées, sans donjon parent |
| `FantasyStraitAlt`, `MtFreezePeakAlt` | variantes alternatives, doublons |

## Ce que ProjectEoN apporte en plus

Maintenant que l'autorisation est acquise, ses **9 donjons jouables**
sont disponibles. Ils ont l'avantage d'être **déjà au format PMDO natif**,
avec leur géométrie — ce que Rescue Team ne fournit pas.

| zone | segments | étages |
|---|---|---|
| `roadwalkpathway` (Crumbling Canyonway) | **3** | 10 + 5 + 1 |
| `cacklingquarry`, `craggy_coast`, `mossyoutcroppings`, `seasideserenade` | 1 | 10 |
| `prologueEX` | 1 | 9 |
| `drenchedbluff` | 1 | 8 |
| `branchwaywoodsdungeon` | 1 | 5 |
| `beginners_footpath` | 1 | 2 |

Avec 4 arènes déjà construites : `BranchwayWoodsBoss.rsmap`,
`CrumblingCanyonThieves.rsmap`, `Beginner'sFootpath.rsmap`,
`craggycoastdungeontest1.rsmap`.

`roadwalkpathway` est le **seul donjon disponible à 3 segments** : c'est
le seul candidat immédiat à un triptyque complet au sens du prompt
(entrance ↔ relais ↔ arène).

## Les 55 arènes de Rescue Team sont extractibles

`extracted_patterns/room_visualizations.txt` contient les **55 salles
fixes** du jeu, en grilles lisibles :

```
Room 1 (17x9)          Room 2 (13x13)
+#######+              #############
#########              #####...#####
###T!T###              ##.##...##.##
#+++++++#              #.....S.....#
~~~~~~~~~              #....213...##
....P....              #...........#
```

Légende documentée : `.` sol, `#` mur, `~` eau, `P` spawn joueur,
`S` escalier, `T` piège. Neuf tilesets d'arène sont également recensés,
dont le **70 — Deep lava, Magma Cavern**.

Ces grilles sont directement convertibles en `.rsmap`. **Non fait à ce
stade** : le brief impose qu'une arène soit liée à son donjon et à son
boss dans un triptyque pensé ensemble — donc après la décision narrative,
pas avant.

## Qualité des sources — comparatif

| critère | Rescue Team | ProjectEoN | EOSO |
|---|---|---|---|
| donjons | **52 convertis** | 9 | 3 |
| bestiaire d'origine | **oui, exact** | oui | oui |
| géométrie | non (générée) | **oui, native** | oui |
| arènes de boss | 55 grilles extractibles | 4 `.rsmap` prêtes | 2 `.rsmap` |
| format | à convertir | **PMDO natif** | **PMDO natif** |
| licence | décompilation, autorisation utilisateur | autorisation utilisateur | crédits nominatifs |

## État du dépôt

```
52 zones rt_* ajoutées, toutes valides, toutes Released=false
index.idx : 67 zones enregistrées
285 fichiers Lua compilent, 0 erreur
verify_ground_registration : 0 anomalie, 0 avertissement
audit_bugs : 62 signalements, dont 55 « Zone Released=false » (voulu)
             les 7 autres sont la dette préexistante
```

## Ce qui reste à décider — ensemble

1. **Quels donjons intégrer réellement.** 52 zones converties ne veut pas
   dire 52 donjons dans le jeu. Le brief interdit d'ajouter un donjon
   sans besoin narratif : ces zones sont un **réservoir**, pas un
   catalogue à déverser.
2. **Le chapitre 6.** Aucune proposition formulée, conformément à la
   consigne.
3. **Le sort des arènes.** 55 grilles disponibles, à convertir donjon par
   donjon une fois les triptyques décidés.
4. **La géométrie des donjons Rescue Team.** Actuellement générée par
   RogueElements. Si tu veux retrouver les layouts exacts, il faudra
   décoder `main_data.inc` — travail de reverse engineering à part
   entière, faisable mais long, et à ne lancer que si le rendu généré ne
   te satisfait pas en jeu.
