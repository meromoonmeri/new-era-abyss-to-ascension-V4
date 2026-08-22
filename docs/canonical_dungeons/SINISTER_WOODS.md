# Chapitre 6 — Sinister Woods / Forêt Sinistre

**Zone de compatibilité :** `gloomy_forest`

**Nom affiché :** `Sinister Woods 1` … `Sinister Woods 13`

**Source de gameplay :** [Bulbapedia — Sinister Woods](https://bulbapedia.bulbagarden.net/wiki/Sinister_Woods),
section *Red Rescue Team and Blue Rescue Team*.

> Cette fiche reformule les données officielles en paramètres PMDO. Elle ne
> reproduit pas un tableau de Bulbapedia tel quel.

## Structure livrée

| Partie | Étages | Génération / Ground | Intention |
|---|---:|---|---|
| Approche | 1–10 | `RangeDictSegment`, 10 noeuds, 3 `ChanceFloorGen`/noeud | forêt dense, embranchements et boucles |
| Relais | après 10 | `sinister_woods_mid` | template fonctionnel de Tunnel Incandescent, Rock Kangourex, soin/sauvegarde/stockage, sortie avant/arrière |
| Profondeurs | 11–12 | `RangeDictSegment`, 2 noeuds, 3 `ChanceFloorGen`/noeud | même forêt rendue plus opaque par le statut `darkness` |
| Clairière de boss | 13 | `sinister_woods_boss` → `sinister_woods_boss.rsmap` | template Crooked Den, combat fixe calibré pour trois ennemis |

Les 12 étages d'exploration ont chacun leur propre noeud de plage unitaire et
choisissent au runtime une famille **branchée**, **étagée**, ou **à boucles**.
Les tailles de grille, densités de halls, ratio de salles et raccordements
varient aussi selon l'étage. Il n'y a ni seed sérialisée, ni layout pré-calculé.

Le donjon canonique ne décrit pas une montée vers un sommet ni une descente vers
un fond : **aucun** Ground `_fond` ou `_sommet` n'est donc créé. Les étages
11–12 reprennent la pénombre officielle (5–7, 11 et 12 sont sombres dans RB),
plutôt que d'inventer un changement géographique brutal sur un lieu dont les
12 étages procéduraux emploient le même environnement source. L'ancien asset
source `sinister_woods_clearing` reste archivé sur disque pour la traçabilité
D04P02, mais n'est plus enregistré ni routé : `sinister_woods_boss` est le
seul Ground de boss actif.

## DTEF et auto-tiling

| Élément | Binding |
|---|---|
| Dossier RawAsset associé | `Content/TileDtef/sinister_woods/TreeshroudForest1/` |
| Source | `PMDCollab/RawAsset/TileDtef/TreeshroudForest1` |
| Matériau runtime isolé | `CanonTreeshroud.tile` |
| AutoTiles PMDO | `canon_treeshroud_floor`, `_wall`, `_secondary` |
| Validation | `tools/build_chapter6_sinister_woods.py --check` |

Le package RawAsset est conservé dans son format DTEF XML-less original, avec
les frames d'animation et son manifeste de hash. PMDO sait l'importer via son
outil **Import DTEF** ; aucun convertisseur DTEF maison n'est ajouté au projet.

Le runtime procédural utilise le matériau `CanonTreeshroud` déjà isolé dans
le dépôt, plutôt que de réutiliser les noms `TreeshroudForest1` partagés avec
Relic Forest. Ses trois `AutoTileAdjacent` sont vérifiés avant construction.

Les **Grounds fixes** ne sont en revanche pas réduits à une salle carrée
auto-générée : l'entrée conserve D04P01, le boss conserve la clairière D04P02,
et le relais conserve une scène forestière composée à la main. Ainsi les
transitions DTEF restent réservées aux étages procéduraux, tandis que les lieux
narratifs gardent une composition canonique lisible.

Voir aussi [`dtef_bindings.json`](dtef_bindings.json) et
`Content/TileDtef/sinister_woods/TreeshroudForest1/RAWASSET_PROVENANCE.json`.

## Rencontres Pokémon

La page Bulbapedia indique quinze espèces sauvages en RB. Elles sont toutes
présentes dans les deux `TeamSpawnZoneStep` du donjon, avec les niveaux source
et des poids PMDO adaptés à la densité du jeu :

| Tranche | Faune PMDO | Niveau de référence |
|---|---|---:|
| 1–3 | Marcacrin, Mystherbe, Simularbre | 8, 7, 7 |
| 2–7 | Héliatronc, Fouinette | 8, 6 |
| 4–6 | Blindalys, Armulys | 8 |
| 6–10 | Balignon, Linéon, Coxy, Axoloto | 9, 8, 7, 10 |
| 8–10 | Insécateur | 10 |
| 11–12 | Balignon, Insécateur, Noadkoko, Hoothoot, Parecool | 9, 10, 8, 6, 8 |

Les espèces à recrutement difficile dans la source ne deviennent pas des
rencontres hors-biome ; elles restent dans le même habitat et le moteur PMDO
applique ses propres règles de recrutement. Aucun Pokémon étranger n'a été
ajouté afin de remplir artificiellement le quota : la liste officielle atteint
à elle seule le minimum demandé de 10–20 espèces.

### Boss fixe — 13F

Le combat fixe reprend la composition officielle de Team Meanies, non
recrutable :

- **Ectoplasma**, niveau 15 — Curse, Lick, Spite, Hypnosis ;
- **Abo**, niveau 15 — Wrap, Leer, Bite, Poison Sting ;
- **Charmina**, niveau 12 — Meditate, Confusion, Detect, ThunderPunch.

La carte 15×18 est volontairement compacte : elle ménage plusieurs couloirs de
repli entre l'arrivée au sud et les trois positions ennemies au nord, sans
transformer un combat de début d'aventure en arène vide.

## Objets et interdictions canoniques

RB propose du Poké, des Pommes, baies de soin/statut, graines Blast et Reviver,
Max Elixir, Gummies de couleur et Orbes utilitaires. La table PMDO emploie les
équivalents disponibles (`food_apple`, baies Cheri/Oran/Pecha/Rawst,
`seed_blast`, `seed_reviver`, `medicine_max_elixir`, Gummies et Orbes de fuite,
lumière, repérage et rappel), avec des poids par catégorie plutôt que des lignes
copiées de la source.

Les interdictions sont aussi portées explicitement par la Zone :

- **pas de pièges** dans RB ;
- **pas de Maison de Monstres** ;
- **pas de boutique Kecleon** dans RB ;
- **pas d'objet enfoui**.

Ainsi aucun `ShopStep`, `SpreadHouseZoneStep`, pool de pièges ni butin enterré
n'est hérité d'un ancien donjon substitut.

## Contrôles à rejouer

```bash
python3 tools/build_chapter6_sinister_woods.py --write --check
python3 tools/validate_sinister_woods_variation.py --passes 10
python3 tools/mapgen/gen_map.py check --cible Data/Ground/sinister_woods_mid.rsground
python3 tools/verify_zone_index.py .
```

Le dernier contrôle humain reste une session PMDO : parcourir deux générations
différentes de chaque tranche, utiliser le Rock Kangourex, perdre après le
checkpoint, puis gagner/perdre la bataille du 13F.
