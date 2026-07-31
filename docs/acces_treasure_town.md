# Accès à Treasure Town — la traversée en Lokhlass

> Rien n'est validé manette en main. Analyse statique et contrôles
> automatiques uniquement.

## Ce qui a été fait

Treasure Town, le bourg d'*Explorateurs du Ciel*, est désormais présent
dans le mod avec ses commerçants, et s'atteint **en Lokhlass** depuis le
continent — jamais par un menu de voyage.

## Origine de la carte

`Data/Ground/treasure_town.rsground` vient de
[PMDO-Explorers-Maps](https://github.com/slothplaysnecro/PMDO-Explorers-Maps),
dépôt qui autorise explicitement la réutilisation (« Feel free to use
these in your own projects »). Les assets amont proviennent
d'ExplorersOfSkyOrigins. Crédité dans `CREDITS.md`.

| | |
|---|---|
| dimensions | 1152 × 504 px (48 × 21 cellules, TexSize 3) |
| tilesets | `TreasureTownEast`, `TreasureTownWest` |
| version format | 0.8.2.0 — champs **identiques** au format 0.8.9 du mod, vérifié clé par clé |
| collisions | déjà présentes, 23 % praticable, **pas** une feuille |

La carte importée était un **décor nu** : six totems en `GroundObjects`,
aucun personnage. Tout le peuplement a été fait ici.

## Les neuf habitants

Placés à la main devant leur devanture réelle, puis vérifiés contre la
grille d'obstacles. Quatre positions initiales tombaient dans le décor et
ont été recalées automatiquement vers le sol libre le plus proche
appartenant à la poche accessible.

| PNJ | nom propre | rôle | position |
|---|---|---|---|
| Kecleon | Lars | marché, objets courants | (152, 192) |
| Kecleon (violet) | Zigs | marché, objets rares | (304, 192) |
| Chimecho | Carilla | lieu de rassemblement | (656, 192) |
| Duskull | Osselin | dépôt / banque | (984, 192) |
| Marowak | Tibo | terrain d'entraînement | (240, 368) |
| Croagunk | Vasco | échange | (384, 272) |
| Bidoof | Castorin | apprenti de la guilde | (744, 328) |
| Wigglytuff | Grodou | maître de guilde | (960, 344) |
| **Lapras** | **Nessie** | **passeuse** | (576, 248) |

Les tenanciers gardent leur **rôle canonique** mais portent un nom
propre, comme tous les PNJ du projet (convention de
`CharacterEssentials` : Kecleon = Lars, Shuckle = Dion). Aucun n'est un
panneau : chacun commente le bourg, la mer ou les explorateurs de
passage.

Contrôle `tools/audit_spatial.py` sur la carte : **0 entité murée, 0
isolée, 0 hors carte**.

## La traversée

```
altere_pond (berge sud, Nessie en 512,472)
        │  verrou : SV.Chapter5.FinishedExpedition
        ▼
treasure_town (arrivée berge, marqueur en 576,224)
        │  Nessie en 576,248
        ▼
metano_altere_transition (retour continent)
```

**Le bourg n'a aucune sortie de carte.** Nessie est le seul moyen d'y
entrer et d'en sortir, dans les deux sens. C'est ce qui fait de la
traversée un trajet, pas une téléportation.

### Pourquoi `altere_pond` comme embarcadère

J'ai d'abord regardé `metano_altere_transition`, que le nom désignait
naturellement. Le rendu montre un **sentier forestier avec une rivière** :
aucune berge, aucun embarcadère crédible.

`altere_pond` est un véritable plan d'eau (928 × 768 px) avec une
plateforme centrale et une large berge sud dégagée — 46 positions libres
sur la bande `y = 464..528`. Nessie y est posée en (512, 472), tournée
vers la berge (`Dir8.Up = 4`).

### Verrou narratif

La traversée ne s'ouvre qu'une fois **l'expédition du chapitre 5
terminée** (`SV.Chapter5.FinishedExpedition`). Avant, Nessie décline :

> « La mer est grande, vous savez. Revenez me voir quand vous aurez une
> vraie raison de la traverser. »

Ouvrir plus tôt laisserait le joueur atteindre un bourg dont l'histoire
ne parle pas encore. Après le sommet du Mont Venteux, le duo a vu assez
loin pour que traverser ait un sens.

## Bug d'enregistrement trouvé et corrigé

`tools/verify_ground_registration.py` a signalé, à raison :

> `treasure_town` : carte ATTEIGNABLE mais ABSENTE de `index.idx`
> → « Invalid Ground Map Name » au moment du transfert

En le corrigeant j'ai **failli casser tout le jeu**. `Data/Zone/index.idx`
listait encore les 192 zones purgées ; en les retirant, la liste `Grounds`
de `master_zone` est passée de 87 à 58 entrées — et **tous les indices
ont décalé**. Or le code appelle `EnterZone("master_zone", -1, N, 0)` où
`N` est l'indice dans cette liste : Cloven Ruins serait passé de 65 à 50,
soit 15 crans d'écart, envoyant le joueur dans une carte au hasard à
chaque sortie de donjon.

La liste `Grounds` est donc restaurée en **miroir exact** de
`GroundMaps`, y compris les entrées dont le `.rsground` manque
(`base_camp`, `guild_path`…) — elles étaient déjà absentes avant la purge
et servent de bouche-trou d'indice.

Résultat : **0 anomalie bloquante**, indices préservés
(`metano_town` 1, `mount_windswept_guardian` 60, `cloven_ruins_entrance`
65, `treasure_town` 86).

## Validation

```
265 fichiers Lua compilent, 0 erreur
audit_bugs                    11 signalements
verify_ground_registration    0 bloquante, 6 avertissements (dette existante)
verify_scene_positions        aucune entité hors carte
audit_spatial treasure_town   0 / 0 / 0 / 0
XML des .resx                 valide (10 clés FR + 10 EN, 3 + 3 pour altere_pond)
```

Toutes les API employées sont attestées ailleurs dans le mod :
`GeneralFunctions.StartConversation` (90 fichiers),
`EndConversation` (93), `PartnerEssentials.InitializePartnerSpawn` (56),
`GetPartnerDialogue` (46), `COMMON.RespawnAllies` (66).

Deux ajustements faits après lecture du moteur :

- `triggerType = 1` (`Action`) et non `EntityCallbacks = [3]`
  (`TouchOnce`) — sinon les PNJ se déclenchaient au contact au lieu du
  bouton. Patron relevé sur `metano_town`.
- suppression d'un `CharTurnToChar` redondant : `StartConversation`
  tourne déjà le PNJ vers le héros (`npcTurn = true` par défaut,
  `GeneralFunctions.lua:1746`).

## Ce qui reste ouvert

1. **Validation en jeu** : la traversée dans les deux sens, et le verrou
   avant fin d'expédition.
2. **Fonctions marchandes non branchées.** Les neuf PNJ ont pour l'instant
   un dialogue d'accueil. Brancher réellement le marché Kecleon, le dépôt
   Duskull, le dojo Marowak et l'échange Croagunk sur les systèmes
   existants du mod est un chantier à part.
3. **Moment d'histoire.** Le verrou actuel est un simple drapeau. Une
   scène d'introduction du bourg — la première traversée, la découverte
   du port — reste à écrire.
4. **Parité Metano / Treasure Town** évoquée dans le brief : les deux
   villes n'ont pas encore le même niveau de services.
