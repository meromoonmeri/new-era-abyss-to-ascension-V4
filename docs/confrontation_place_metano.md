# La confrontation de la place — Team Dazzling, chapitre 6

> **Rien n'a été testé en jeu.** Tout ce qui suit est vérifié par lecture
> du moteur, mesure sur les fichiers et validation automatique.

---

## 1. Le verrou levé : se battre « dans Metano » sans quitter Metano

Le tour précédent concluait : *combat en ville impossible*. C'est vrai —
mais la conclusion tirée était trop large.

**Ce qui est réellement impossible** (vérifié) : se battre sur un
*ground*. `GameManager.cs:626` — `Segment == -1` **signifie** ground ;
`GroundChar` (`Ground/GroundChar.cs:21`) n'a ni PV, ni capacités, ni
statuts. Aucun combat ne peut s'y dérouler.

**Ce qui n'a jamais été impossible** : qu'une *carte de combat*
ressemble exactement à la ville.

La réserve qui bloquait — « aucun autotileset urbain » — reposait sur une
prémisse fausse. Metano Town n'utilise **aucun autotileset** : ses
tuiles sont des références brutes `Sheet` + `TexLoc` vers
`Metano_Town_Base`, `Metano_Town_Objects`, etc.

Or `MapLayer.Tiles` (donjon) et `GroundMap.Layers[].Tiles` (ville) sont
**le même type** : `AutoTile[][]` (`Dungeon/Maps/MapLayer.cs:16`). Et
`AutoTile.draw()` (`Tiles/AutoTile.cs:88-100`) dessine `Layers` tel quel
dès que `AutoTileset` est vide.

**Le dépôt le faisait déjà** : `foret_embuscade_fond.rsmap` et
`montagne_traitresse_fond.rsmap` sont deux arènes de combat bâties sur
des tuiles brutes (`ForestGrove`, `MountainPeak`), sans autotileset.

### La seule vraie difficulté, et sa résolution

| | ville | donjon |
|---|---|---|
| pas de grille | **8 px** (`TexSize=1`) | **24 px** (`GFXParams`) |

Il faut donc fusionner chaque bloc de **3×3 cellules de 8 px** en **une
tuile de 24 px**. C'est licite ici parce que la mesure le confirme :

- **aucune** cellule de `metano_town` n'a plus d'un `TileLayer` → les 9
  sous-cellules occupent des zones disjointes, c'est une mosaïque, pas
  une superposition alpha ;
- les cadences d'animation sont homogènes par bloc (0 mélange sur les
  couches statiques ; 17 blocs mixtes sur 710 dans `Objects Anim`,
  résolus en prenant la cadence la plus courte).

**Résultat mesuré** — rendu de `metano_town_duel.rsmap` comparé au rendu
de la ville sur la même fenêtre :

```
pixels différents : 0 / 142 272
```

Les animations sont préservées (rivière, étals) : 5 750 pixels bougent
entre les frames 0 et 1.

**Outils** : `tools/make_metano_arene.py`, `tools/render_rsmap.py`.
`tools/rebuild_tile_index.py` régénère `index.idx` — contrôle de
non-régression : régénéré sur l'état d'origine, il redonne un fichier
**identique octet pour octet**.

---

## 2. Les spectateurs sont inoffensifs *par le moteur*

C'est le mécanisme des PNJ neutres des donjons PMDO, pas un bricolage
de script.

Les 11 habitants sont dans **`AllyTeams`**, pas dans `MapTeams`.
`Map.ReconnectMapReference()` (`Maps/Map.cs:1082-1087`) leur impose
`Faction.Friend` **à chaque chargement de la carte**. Puis
`DSceneAction.GetMatchup()` (`DSceneAction.cs:691-707`) :

```csharp
if (attackerFaction == targetFaction) return Alignment.Friend;
if (attackerFaction == Faction.Friend || targetFaction == Faction.Friend)
{
    bool foeTruce = true;
    if (attackerFaction == Faction.Foe || targetFaction == Faction.Foe)
    {
        foeTruce &= !attacker.MemberTeam.FoeConflict;
        foeTruce &= !target.MemberTeam.FoeConflict;
    }
    if (foeTruce) return Alignment.Friend;   // ← la trêve
}
```

Conséquence, sans une ligne de script : joueur → habitant,
**Dazzling → habitant**, habitant → quiconque, tout est `Alignment.Friend`.
`FoeConflict` n'est pas sérialisé dans les `.rsmap` du dépôt ; sa valeur
par défaut côté moteur est `false`, ce qui **est** la trêve — on ne
l'écrit donc pas, pour ne pas faire diverger le format.

**Verrous supplémentaires** posés sur chaque spectateur :
`Skills` vide (rien à lancer), `EnemyOfFriend = false` et
`AttackFriend = false` (les deux seuls drapeaux qui, dans `GetMatchup`
l.683-687, pourraient forcer `Alignment.Foe`), `CantInteract`,
`CantWalk`, `Unrecruitable`, et `Tactic = wait_only`.

`wait_only` n'est pas inventé : la première version de l'outil employait
`wait_here`, qui a **0 occurrence** dans le dépôt. Le comptage l'a
signalé avant écriture ; le gabarit réel a été recopié depuis
`terrakion_fight.rsmap` (`WaitPlan` seul, `IQ` 400).

Le combat reste **3 contre 2** : les spectateurs n'ajoutent aucune force.

---

## 3. Les trois actes

`Data/Script/halcyon/DazzlingPlaza.lua` (941 lignes), 64 clés de
dialogue en `strings.resx` **et** `strings.fr.resx`.

### Acte I — la rencontre
La présentation existante des rivales est **intacte** ; la confrontation
s'enchaîne derrière, sans rendre la main : une seule séquence pour le
joueur.

- **Formation tenue du début à la fin** : Adagio devant (992,832), Aria
  arrière-gauche (1016,808), Sonata arrière-droite (1024,856).
- La mère Papilusion **court** (`run = true`) — c'est une urgence.
- **Aria répond avant la fin de la phrase**, sans méchanceté : c'est ce
  qui rend la réplique dévastatrice.
- **50 frames de silence**, puis les sueurs froides de la foule. Le
  malaise a besoin de durer pour exister.
- **Sonata tourne la tête en 14 frames** au lieu de 4 : la lenteur *est*
  la réaction.
- Adagio explose (`ASSEZ !` seule dans sa boîte), puis se recompose.
- Le cercle se referme **à pied**, en décalé (11 frames d'écart).
- Regards suivis : `CharTurnToCharAnimated` à chaque prise de parole ;
  le duo pivote en décalé de 7 frames, jamais d'un bloc.

### Acte II — le combat
`GAME:ContinueDungeon("gloomy_forest", 7, ...)` → `metano_town_duel.rsmap`,
c'est-à-dire la place. Le fondu de `COMMON.BossTransition()` couvre la
bascule technique. Terrain vérifié **entièrement connecté** : 167/167
cases atteignables depuis le joueur, les trois rivales incluses.

### Acte III — deux branches
- **Défaite** : Adagio pousse sans ralentir, Aria imite sans comprendre,
  Sonata conclut. Départ à pied, caméra jusqu'à disparition. Les
  habitants **accourent** (`run = true`). La vue se brouille en trois
  battements de plus en plus lents, puis le carton **« Quelques heures
  plus tard… »** (`UI:WaitShowTimedDialogue`, comme les transitions du
  jeu). Réveil à la guilde, déclenché par
  `SV.Chapter6.PlazaBedsidePending` — patron exact de
  `RaidScenes.Bedside`.
- **Victoire** : exceptionnelle, jamais humiliante. Adagio ne s'excuse
  pas, elle **corrige** : « J'avais mal regardé. » Puis : « Ceci ne
  règle rien. Ça repousse simplement le vrai duel. »

**Casting du chevet — un écart assumé.** « Chucrin » (Bidoof) **n'existe
pas dans ce mod** : aucune entrée dans `CharacterEssentials`, zéro
occurrence dans le dépôt. L'invoquer aurait produit un `CH()` nil et une
scène amputée. Remplacé par **Rin (Audino)**, qui tient l'infirmerie —
légitime au chevet de deux blessés, et déjà son rôle dans
`RaidScenes.Bedside`. Le reste est conforme : Penticus (Tropius),
Almotz/Zigzaton (Zigzagoon), Phileas (Noctowl). Même contrôle pour
Sudowoodo (absent) → retiré du cercle.

---

## 4. Continuité

| variable | rôle |
|---|---|
| `SV.Chapter6.PlazaMet` | la rencontre a eu lieu — **verrou d'unicité** |
| `SV.Chapter6.PlazaOutcome` | `'win'` / `'loss'` — lu par les témoins |
| `SV.Chapter6.PlazaPending` | issue en attente de mise en scène |
| `SV.Chapter6.PlazaBedsidePending` | le chevet reste à jouer |

Le segment 7 sert désormais **deux usages**, distingués par `PlazaMet` :
la confrontation de la place, et — inchangée — l'Épreuve des Trois de la
Forêt Lugubre.

Rattrapage pour les sauvegardes antérieures (`debug_tools/init.lua`) :
si la présentation des rivales a déjà été vue, la confrontation est
réputée avoir eu lieu, sinon elle se rejouerait alors que le récit l'a
dépassée.

**7 témoins** (Mawile, Floatzel, Quagsire, Marill, Azumarill, Butterfree,
Venipede) ont chacun **deux répliques exclusives**, l'une par issue,
chacune renvoyant à un détail précis de la scène. Elles priment sur la
cascade de dialogues habituelle, qui reprend ensuite.

---

## 5. Contrôles

| contrôle | résultat |
|---|---|
| `audit_bugs.py` | **12** (référence : 12) |
| `audit_integrite.py` | **849** (référence : 849) |
| compilation Lua | **673 fichiers, 0 erreur** |
| `verify_emotions` | aucun risque de crash de portrait |
| `verify_lua_globals` | aucune fonction fantôme |
| `verify_cutscene_guard` | aucune scène à risque |
| `verify_scene_positions` | aucune entité hors carte |
| `validate_all` | toutes les salles valides |
| rendu vs ville réelle | **0 pixel d'écart** |
| positions de la cinématique | **0 en mur, 0 collision** (41 vérifiées) |
| clés `.resx` | 64 déclarées, **0 orpheline, 0 manquante** |
| terrain de combat | **167/167 cases connectées** |

Erreurs interceptées par ces contrôles avant écriture : `wait_here`
inventé, 5 spectateurs dans un mur, 10 positions de cinématique dans un
mur, 2 destinations de secours dans un mur, une position de départ
joueur dans un mur, `Bidoof`/`Sudowoodo` inexistants, 2 clés orphelines.

---

## 6. Correction : la GRANDE PLACE MARCHANDE, et l'arrivee par le nord

La premiere version placait la scene sur l'esplanade OUEST (px x720..1176).
Verification faite, c'etait le mauvais endroit : **la riviere de Metano la
traverse de part en part**, et les commerces (Kec Shop 1056,848 · TM
1080,848 · Entrepot 1220,864 · Banque 1016,1008) sont tous a l'EST.

La scene a ete deplacee sur la **vraie place marchande**, fenetre
`x984..1320 / y696..1128` (tuiles 41..54 / 29..46) :

- **la riviere n'y entre pas** — seules 20 cellules d'eau touchent le coin
  nord-ouest (x 984..1008, y 696..744), tres loin des acteurs ;
- **l'arrivee des rivales se fait par le nord, entre les magasins** : le
  defile `x = 1152` passe entre le comptoir TM a l'ouest et l'Entrepot a
  l'est, et **se resserre a une seule case** en `y = 860`. Le decor impose
  donc de lui-meme une entree en file indienne — Adagio, puis Aria, puis
  Sonata a 26 frames d'intervalle, avant deploiement en triangle ;
- **les spectateurs occupent d'abord le centre**, y compris la bouche du
  defile (`CERCLE`), puis **s'ecartent sur les cotes** (`CERCLE_ECARTE`)
  pour laisser passer les rivales. Chacun reflue du cote dont il est le
  plus proche : **personne ne traverse la place** devant elles. Controle :
  apres ecartement, la colonne centrale est libre de `y = 864` a `y = 952`.

### Le controle qui a rattrape l'erreur de fond

Un premier jet validait les positions **par leur centre seul**. Le plan
rendu a montre des habitants poses sur des caisses. `plan_place_marchande.py`
teste desormais **trois conditions** par position :

1. marchable pour un corps de **20x20** (pas seulement le centre) ;
2. **hors riviere** (couche `River` du `.rsground`) ;
3. **>= 40 px du collider de tout commerce** — aucun effleurement.

Sur cette base : **105 cases irreprochables** recensees, et les acteurs y
ont ete recales. Distance minimale finale aux commerces : **41 px**.

| controle (nouvelle place) | resultat |
|---|---|
| rendu vs ville reelle | **0 pixel d'ecart** / 145 152 |
| positions carte (joueur + 3 rivales + 8 spectateurs) | **0 anomalie** |
| positions du script | **55 verifiees, 0 invalide** |
| distance min aux commerces | **41 px** |
| entites sur la riviere | **0** |
| rivales atteignables depuis le joueur | oui |
| trajets d'ecartement | **8/8 franchissables** |

## 7. Ce qui reste ouvert

- **Rien n'est testé en jeu.** L'équilibrage du combat, en particulier,
  demande une manette.
- Le **module météo** et l'**intro de Rondoudou** ne sont pas commencés.
- `npc_routines.lua` conserve ses **8 points de passage sur 11 dans un
  mur** (chapitres 8-10).
