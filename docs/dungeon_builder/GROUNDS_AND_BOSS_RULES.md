# Scènes fixes : Ground de fin, arène, midpoint

Règle verrouillée dans le schéma, dans l'export et dans les tests
(`tests/test_dungeon_builder.py::TestBossSceneRules`).

## 1. Combat final

| Cas | `boss.mode` | Ce que le Builder exige | Ce qu'il interdit |
|---|---|---|---|
| Le donjon possède un Ground de fin canonique exploitable | `canonical_ground` | `boss.ground` (ou `fixed_grounds.end`) doit exister dans `Data/Ground` ; si un `.rsmap` de scène est déclaré, il doit exister dans `Data/Map` | — |
| Aucun Ground de fin exploitable | `arena_rsmap` | `boss.map` doit exister dans `Data/Map` **avant** conversion en Ground | Interdit dès qu'un Ground de fin canonique est détecté |

La détection n'est pas déclarative : `grounds.find_canonical_end_grounds()`
**scanne** `Data/Ground` en croisant l'`id` du donjon et ses `aliases` avec les
suffixes de fin utilisés par le projet (`clearing`, `end`, `fond`, `summit`,
`sommet`, `profondeurs`, `altar`, `den`, `crucible`, `boss`…). Un futur donjon
ne peut donc pas se fabriquer une arène artificielle « par habitude » : le
contrôle échoue avec le nom du Ground canonique qu'il aurait dû utiliser.

Trois validations bloquent en amont, à la lecture de la définition :

* `boss.mode` hors des deux valeurs → erreur de définition ;
* `canonical_ground` sans `ground` ni `fixed_grounds.end` → erreur ;
* `arena_rsmap` déclaré en même temps qu'un `fixed_grounds.end` → erreur.

### Sinister Woods

`aliases: ["sinister_woods"]` → le scan trouve `sinister_woods_clearing`
(D04P02, clairière finale canonique). Le mode est donc `canonical_ground` et le
combat contre Team Dazzling s'y déroule directement. Aucune arène séparée n'est
créée, et une tentative de passer ce donjon en `arena_rsmap` est rejetée par le
test `test_arena_is_forbidden_when_a_canonical_end_ground_exists`.

## 2. Midpoint

Le midpoint n'est **jamais** procédural. `tools/dungeon_builder/ground_pipeline.py`
produit le Ground du donjon à partir du template validé :

```bash
python3 tools/dungeon_builder.py ground sinister_woods --role midpoint \
        --sheet SinisterWoodsB41 --preview
```

Ce que fait le pipeline :

1. lit le template (`Data/Ground/<template>.rsground`, JSON RogueEssence) ;
2. conserve **à l'identique** la géométrie 69×54, les collisions, les marqueurs,
   le spawner et les `GroundObjects` — dont la **Statue Kangourex**
   (`Kangaskhan_Rock`) et les sorties `North_Exit` / `South_Exit` ; l'absence
   d'un objet requis fait échouer la construction ;
3. **retexture** chaque tuile : les deux planches `.tile` sont décodées, chaque
   tuile source reçoit une signature structurelle 4×4 (mosaïque de moyennes
   RGBA) et est appariée à la tuile la plus proche de la planche du donjon.
   Aucun échange de planche « à l'aveugle », aucune transition peinte à la main ;
4. écrit `Data/Ground/<id>_midpoint.rsground` et l'enregistre dans
   `Data/Ground/index.idx` ;
5. `--preview` rend un PNG (`.runtime-cache/<id>.png`) pour vérification visuelle.

Résultat pour Sinister Woods : `gloomy_forest_midpoint.rsground`, 4 455 tuiles
retexturées depuis 1 738 tuiles sources distinctes, entités du template
préservées (2 marqueurs, 1 spawner, 3 ground objects). Le rendu montre bien une
clairière forestière avec l'aire de repos centrale ouverte et les masses
d'arbres en bordure ; un passage artistique manuel reste possible, le pipeline
étant rejouable avec une autre planche via `--sheet`.

## 3. Inventaire canonique des scènes (source d'autorité)

`tools/dungeon_builder/scenes.py` lit
`docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md` — l'inventaire des 245 Grounds PMD
Red convertis, qui donne pour chaque donjon GBA son Ground d'ENTRÉE, de RELAIS
et de FIN/ARÈNE. Chaque nom est ensuite localisé :

| État | Signification | Conséquence |
|---|---|---|
| `ACTIVE_GROUND` | présent dans `Data/Ground` | `canonical_ground`, prêt |
| `ACTIVE_RSMAP` | présent dans `Data/Map` | ce `.rsmap` **devient** ce Ground (pas une seconde arène) → `REQUIRES_INTEGRATION` |
| `ARCHIVED` | présent dans `RESERVE/…` | scène à restaurer telle quelle → `REQUIRES_INTEGRATION` |
| `NONE` | absente partout | et seulement alors : `arena_rsmap` autorisé |

Les sous-donjons de cime/fosse héritent de la scène de leur lieu parent
(`Mt. Blaze Peak` → `d09p03`, `Frosty Grotto` → `d10p03`,
`Magma Cavern Pit` → `fosse_ardente`, `Sky Tower Summit` →
`arc_tour_ciel_sommet`) : la cinématique du légendaire et son combat s'y
déroulent, aucune arène n'est fabriquée.

### Invariant vérifié par les tests

Pour toute définition : `scenes.cinematic_ground == scenes.battle_ground ==
scenes.canonical_end_ground`. Le schéma refuse une définition qui séparerait la
cinématique du combat, et refuse `arena_rsmap` dès que l'inventaire nomme une
scène — **même archivée**.

Résultat du scan exhaustif : sur les 9 arènes que l'étape 6 croyait devoir
créer, **6 possédaient déjà un Ground canonique actif** (`abime_tempetes`
Kyogre, `fosse_argentee` Lugia, `champ_braises`, `champ_vent_boreal`,
`sommet_aurore` Ho-Oh, `antre_occident` Mewtwo, `cretes_boreales` Latios,
`bois_des_plaintes` Suicune) et 2 une scène archivée (`champ_foudre` Raikou,
`caverne_trouble_fond`). Il ne reste que **3 arènes réellement à créer** :
Buried Relic (Regis), Meteor Cave (Deoxys), Purity Forest (Celebi).

## 4. Ce qui reste à produire pour un nouveau donjon

* si le donjon n'a pas de Ground de fin : créer le `.rsmap` d'arène, puis le
  convertir en Ground (le Builder refuse tant que le `.rsmap` n'existe pas) ;
* si le donjon a besoin d'un midpoint : disposer d'une planche de tuiles de son
  biome, puis lancer la commande `ground` ci-dessus.
