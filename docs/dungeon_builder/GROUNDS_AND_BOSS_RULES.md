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

## 3. Ce qui reste à produire pour un nouveau donjon

* si le donjon n'a pas de Ground de fin : créer le `.rsmap` d'arène, puis le
  convertir en Ground (le Builder refuse tant que le `.rsmap` n'existe pas) ;
* si le donjon a besoin d'un midpoint : disposer d'une planche de tuiles de son
  biome, puis lancer la commande `ground` ci-dessus.
