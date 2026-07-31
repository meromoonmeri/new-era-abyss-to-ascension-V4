# Inventaire des sources de donjons — ce qui est réellement importable

> Audit préalable au chantier des donjons, mené avant tout import.
> Rien n'est validé manette en main.

## Ce que contient réellement chaque dépôt

Les six dépôts de la bibliothèque n'ont pas du tout le même contenu. Le
mot « donjon » recouvre trois choses différentes selon la source : une
**zone jouable** (`Data/Zone/*.json` avec ses segments et sa génération),
une **carte de décor** (`Data/Ground/*.rsground`), ou du **code source
C#** qui décrit un donjon sans être chargeable.

| dépôt | zones jouables | grounds | maps de combat | verdict |
|---|---|---|---|---|
| **ProjectEoN** | **13** (dont 8 avec segments) | 49 | 5 | **la seule vraie source de donjons jouables** |
| ExplorersOfSkyOrigins | 5 (dont 3 donjons) | 95 | 2 | excellent pour les décors, peu de donjons |
| PMDO-Explorers-Maps | 0 | 82 | 0 | **décors uniquement**, aucune zone |
| PMDODump | 0 | 0 | 0 | **code source C#**, pas des données |
| pret/pmd-red, pret/pmd-sky | — | — | — | décompilations C/ASM, hors format moteur |
| pmdsky-debug | — | — | — | documentation de reverse engineering |

### Le piège du mot « donjon »

`PMDODump/DataAsset/Zone/` contient 51 fichiers `.out.txt`. Le nom laisse
croire à des zones importables. En réalité :

```csharp
ItemSpawnZoneStep itemSpawnZoneStep = new ItemSpawnZoneStep();
necessities.Spawns.Add(new InvItem("berry_leppa", true), ...);
```

C'est du **C# généré**, la description d'un donjon dans le code du jeu de
base — pas un `.json` que RogueEssence sait charger. Ces fichiers sont
précieux comme **référence de dosage** (quels objets, à quel taux, sur
quelle plage d'étages), pas comme contenu à importer.

Même remarque pour `pret/pmd-red` et `pret/pmd-sky` : ce sont des
décompilations en C et assembleur de la ROM d'origine. Elles documentent
la logique de conception, elles ne fournissent aucun asset au format
PMDO. C'est bien ce que demande le brief — « étudier leur logique de
conception, jamais copier leur contenu ».

## Donjons jouables disponibles — ProjectEoN

| zone | nom | segments | grounds |
|---|---|---|---|
| `beginners_footpath` | Beginner's Footpath | 1 | 0 |
| `branchwaywoodsdungeon` | Branchway Woods | 1 | 0 |
| `cacklingquarry` | Cackling Quarry | 1 | 1 |
| `craggy_coast` | Craggy Coast | 1 | 0 |
| `drenchedbluff` | Drenched Bluff | 1 | 1 |
| `mossyoutcroppings` | Mossy Outcroppings | 1 | 1 |
| `roadwalkpathway` | Crumbling Canyonway | **3** | 3 |
| `seaside_serenade` | Seaside Serenade | 1 | 1 |
| `prologueEX` | Prologue EX | 1 | 0 |

Avec quatre arènes de combat déjà construites :
`BranchwayWoodsBoss.rsmap`, `CrumblingCanyonThieves.rsmap`,
`Beginner'sFootpath.rsmap`, `craggycoastdungeontest1.rsmap`.

Et depuis EOSO : `beach_cave` (2 segments), `drenched_bluff`,
`mt_bristle` (2 segments) — avec `beach_cave_pit.rsmap` et
`mt_bristle_peak.rsmap`.

## Point de licence — à trancher avant d'importer

C'est le seul vrai obstacle, et il n'est pas technique.

| dépôt | licence | statut |
|---|---|---|
| **PMDO-Explorers-Maps** | « Feel free to use these in your own projects » | **autorisation explicite** |
| **PMDODump** | MIT (Audino, 2021) | **licence permissive claire** |
| ExplorersOfSkyOrigins | aucun fichier LICENSE | tacite — crédits nominatifs présents dans le README |
| **ProjectEoN** | **aucun fichier LICENSE**, README : « This is not a finished product, the only reason this is here is to get help from people who know the jank more than I do » | **pas d'autorisation de réutilisation** |

Les imports déjà réalisés (Treasure Town, guilde Grodoudou) viennent de
PMDO-Explorers-Maps et d'ExplorersOfSkyOrigins, tous deux crédités dans
`CREDITS.md`.

**ProjectEoN est un cas différent.** Son README ne dit pas « servez-vous
», il dit que le dépôt est publié pour obtenir de l'aide au débogage.
C'est justement la source la plus riche en donjons jouables — et la seule
sans autorisation même tacite.

Deux options, à arbitrer :

1. **Demander l'accord à Logical321** avant tout import. C'est la voie
   propre, et le dépôt étant petit, un contact direct est réaliste.
2. **Ne pas importer ses zones**, et reconstruire les donjons à partir
   des décors d'EOSO/PMDOEM (libres) plus la logique de génération lue
   dans PMDODump (MIT). Plus long, mais sans zone grise.

Je n'importe rien de ProjectEoN tant que ce point n'est pas tranché.

## Ce que le triptyque impose en plus

`prompt_triptyque_entrance_relais_arene.md` pose une contrainte qui
change la manière d'importer : **entrance, point médian et arène forment
un ensemble**, pas trois pièces à assembler.

Conséquences concrètes pour ce chantier :

- **Importer le donjon ET son boss.** Une zone reprise sans son
  affrontement emblématique est un import raté. Réciproquement, une arène
  sans son donjon n'a pas de contexte.
- **Respecter l'absence d'entrance.** Le brief est explicite : beaucoup
  de donjons d'origine n'ont pas d'entrance dédiée, et « ce n'est pas une
  incohérence à corriger ». Sur les 9 donjons EoN, **5 n'ont aucun
  ground** — donc pas d'entrance. Cette absence sera consignée comme
  décision documentée, pas comme un manque.
- **Le dernier relais avant l'arène** doit porter l'annonce la plus nette
  du boss. Un seul donjon disponible a plusieurs segments
  (`roadwalkpathway`, 3) : c'est le seul candidat immédiat à un vrai
  triptyque complet.
- **Aucun recyclage entre donjons.** Le registre de suivi devra tracer,
  par donjon, l'indice visuel utilisé pour qu'il ne resserve pas ailleurs.

## Ce qui manque encore pour avancer

Le chantier des donjons demande deux décisions qui ne sont pas
techniques, et que je ne peux pas prendre seul :

1. **Le statut de ProjectEoN** (ci-dessus).
2. **Le rattachement narratif.** Le brief interdit d'ajouter un donjon
   sans besoin narratif réel : « ne pas construire plusieurs entrées d'un
   coup sans lien avec un besoin narratif réel du chapitre en cours ».
   Or le chapitre 6 est vide depuis la purge — son donjon
   (`gloomy_forest`) a été supprimé. C'est le point d'insertion évident,
   mais il suppose de décider d'abord *quel* donjon et *quel* boss
   occupent ce chapitre.

## État du dépôt

```
83 grounds, 285 fichiers Lua compilent, 0 erreur
audit_bugs                    10 signalements
verify_ground_registration    0 anomalie, 0 avertissement
hub Treasure Town             31 liaisons, 0 en défaut
```
