# Audit d'intégration — Treasure Town, guilde Grodoudou, cartes de nuit

> Phase 1 du prompt de démarche : **audit de l'existant avant toute
> hypothèse narrative**. Aucun chapitre ni déclencheur n'est proposé ici.
> Rien n'est validé manette en main.

## Réponses directes aux deux questions

### « La guilde Grodoudou est-elle présente ? »

**Oui — mais elle est orpheline et inatteignable.**

Cinq cartes existent déjà dans le mod, importées avant ce chantier :

| carte du mod | source EoS | dimensions | collisions | entités |
|---|---|---|---|---|
| `guilde_parvis` | `guild_outside` | 480×408 | 90 % | 0 |
| `guilde_parvis_soir` | `guild_outside_dusk` | 480×408 | **0 %** → corrigé | 9 |
| `guilde_parvis_nuit` | `guild_outside_night` | 480×408 | **0 %** → corrigé | 0 |
| `guilde_sous_sol` | `guild_basement` | 648×432 | 77 % | 0 |
| `guilde_sous_sol_nuit` | `guild_basement_night` | 648×432 | **0 %** → corrigé | 0 |

Trois problèmes, dans l'ordre de gravité :

1. **Absentes de `master_zone.json`** → le moteur ne peut pas les charger.
2. **Citées par zéro script** → aucun accès depuis le jeu.
3. **Aucun PNJ** (sauf `guilde_parvis_soir`, qui ne contient que des
   marqueurs d'une cinématique d'intro jamais écrite).

Les tilesets, eux, sont **tous déjà présents** dans `Content/Tile`
(`GuildOutside`, `GuildOutsideNight`, `GuildOutsideNightGate`,
`GuildOutsideDusk`, `GuildBasement`, `GuildBasementNight`, plus les
quatre calques `*_layer2`). Rien à réimporter côté graphique.

### « La zone a-t-elle une carte de nuit ? »

**Treasure Town : non.** Le dépôt source ne contient qu'un seul
`treasure_town.rsground`, version jour. Le CSV de conversion officiel le
confirme : `T00P02` et `T00P03` (Treasure Town East/West) sont
`COMPLETE`, sans variante nocturne — elle n'existe pas dans le matériel
converti.

**La guilde : oui**, parvis et sous-sol ont leur version nuit, plus une
version crépuscule pour le parvis.

## Correction appliquée — les trois « feuilles » nocturnes

Les variantes nuit avaient **0 mur** alors que leur jumelle diurne en a
2756 et 3380. Vérification faite : le défaut vient de **la source**, pas
de l'import.

```
source guild_outside          60x51  2756 murs (90 %)
source guild_outside_dusk     60x51     0 murs
source guild_outside_night    60x51     0 murs
source guild_basement         81x54  3380 murs (77 %)
source guild_basement_night   81x54     0 murs
```

Le joueur aurait traversé les bâtiments dès la tombée du jour — exactement
le défaut décrit dans `docs/audit_logique_spatiale.md`.

Les grilles étant **rigoureusement identiques** (mêmes dimensions, même
`TexSize` : c'est le même lieu à une autre heure), `tools/copier_collisions.py`
recopie la grille du jour vers la nuit. L'outil refuse d'écrire si les
dimensions divergent, si la source est vide, ou si la cible a déjà des
murs — on n'écrase jamais un travail manuel.

Résultat : grilles vides du projet **9 → 6**. Diff vérifié :
`git diff | grep -cv '"Tags":'` renvoie **0**, aucune ligne parasite.

## Inventaire du hub Treasure Town

Ce que le dépôt source contient, et ce que le mod en a déjà :

| carte source | rôle | état dans le mod |
|---|---|---|
| `treasure_town` | la place du bourg | **importée** (idx 86) |
| `guild_outside` ×3 | parvis jour/soir/nuit | importées, **orphelines** |
| `guild_basement` ×2 | sous-sol jour/nuit | importées, **orphelines** |
| `spinda_cafe` | Café Qulbutoké | **absente** |
| `crossroads` ×3 | carrefour nord / rassemblement / sud | **absentes** |
| `beach` / `dusk_beach` | plage jour / crépuscule | **absentes** |
| `marowak_dojo_final_maze` | labyrinthe du dojo | **absente** |
| `hot_spring` | source chaude | **absente** |
| `habitat_sharpedo_bluff_day` | falaise Sharpedo | **absente** |

**Huit cartes du hub manquent.** Toutes ont de vraies collisions dans la
source (67 % à 93 %), sauf `dusk_beach` à 0 % — même défaut nocturne, à
traiter de la même façon si elle est importée.

### Point à ne pas confondre

`metano_cafe` et `ledian_dojo` du mod **ne sont pas** des reprises d'EoS :
ils utilisent des tilesets propres (`Metano_Town_Cafe_*`,
`Ledian_Dojo_*`). Le Café Spinda et le dojo Ossatueur de Treasure Town
restent donc entièrement à importer — ce ne sont pas des doublons.

## Ce que dit le CSV officiel de conversion

Source de vérité du dépôt amont pour l'état réel des fonds :

| ID | pièce | état |
|---|---|---|
| T00P02 / T00P03 | Treasure Town Est / Ouest | COMPLETE |
| T00P04A | parvis guilde (jour) | COMPLETE |
| G01P01C | parvis guilde (nuit) | COMPLETE |
| G01P01B | parvis guilde (crépuscule) | **Not Started** |
| G01P02A | entrée de la guilde | COMPLETE |
| G01P03A | **salle des tableaux de missions** | COMPLETE |
| G01P04C | salle d'échange (nuit) | COMPLETE |
| G01P04A | salle d'échange (jour) | **Not Started** |
| G01P05A | chambre du maître (jour) | COMPLETE |
| G01P05C | chambre du maître (nuit) | **Not Started** |
| G01P06A | réfectoire (jour et nuit) | **Not Started** |
| G01P07A | lits héros/partenaire | **Not Started** |
| G01P08A | couloir des quartiers | **Needs Fixes** |
| G01P09/10 | quartiers nord et sud | **Not Started** |

**Nuance capitale** : « COMPLETE » désigne le **fond converti**, pas une
carte jouable. Seules 5 pièces de guilde ont réellement un `.rsground`
(parvis ×3, sous-sol ×2). L'entrée, la salle des missions et la chambre
du maître existent en fond mais **sans map** — il faudrait les construire.

Conséquence directe pour la parité de monde vivant exigée : le **job
board de Treasure Town** demanderait de bâtir la salle `G01P03A` à partir
de son fond, ce n'est pas un simple import.

## État après ce tour

```
64 grounds, 265 fichiers Lua compilent, 0 erreur
grilles de collision vides : 9 -> 6
audit_spatial : B 33 grounds / C 5 / D 2
```

## Ce qui reste à trancher — et pourquoi je m'arrête ici

Le prompt de démarche demande de **ne pas** proposer de chapitre avant
d'avoir bouclé l'audit. Trois constats conditionnent la suite, et je
préfère les poser avant de bâtir des hypothèses :

1. **Treasure Town n'a pas de version nuit.** Si la ville doit vivre au
   même rythme que Metano (qui a `metano_town_nuit`), il faut soit
   accepter une ville figée en plein jour, soit générer une variante
   nocturne par retint — `tools/tile_night.py` existe déjà dans le
   projet et a servi pour Metano.

2. **La guilde est un décor sans intérieur jouable.** Parvis et sous-sol
   seulement. Une guilde Grodoudou crédible suppose au minimum l'entrée
   et la salle des missions, à construire depuis leurs fonds.

3. **Huit cartes du hub manquent**, dont le Café Spinda et la plage —
   qui sont les lieux où se joue la vie sociale du bourg dans le
   matériel d'origine.

Autrement dit : rendre Treasure Town aussi vivante que Metano n'est pas
un import, c'est un chantier de construction. Le placement narratif doit
être décidé en connaissant ce coût.
