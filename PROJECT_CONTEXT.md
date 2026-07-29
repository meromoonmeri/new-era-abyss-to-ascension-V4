# PROJECT_CONTEXT — New Era : Abyss to Ascension

Dernière mise à jour : 2026-07-26 (prise en main de session par agent Arena.ai)

## But de ce fichier

Fichier de reprise à la racine du dépôt. À lire au début de la prochaine session, en complément de `docs/CONTEXTE_PROJET.md`.

## Prise en main effectuée

- Dépôt cloné depuis `https://github.com/meromoonmeri/new-era-abyss-to-ascension-V4.git`.
- Branche locale : `main`, alignée sur `origin/main` au commit `239525a`.
- `Mod.xml`, `patchnotes.txt`, la structure `CONVERSION/`, `Content/`, `Data/`, `Strings/`, `docs/`, `tools/` et l'historique `git log` ont été inspectés.
- Les pages wiki de référence ont été ouvertes au moins pour cadrage initial : `Floor_Generation_Overview`, `Text_Guide`, `Scripting_Cheat_Sheet`, `Script_Reference`. Pour une tâche de code/contenu précise, relire la page pertinente avant modification.
- Le fichier racine `PROJECT_CONTEXT.md` n'existait pas avant cette prise en main ; celui-ci a donc été créé conformément au protocole.

## Identité du mod vérifiée

Dans `Mod.xml` :

- `Name` : `New Era : Abyss to Ascension`
- `Namespace` : `halcyon`
- `UUID` : `CAE98609-7A96-4CFC-B5AB-0E1D41F6A1FF`
- `Version` : `0.5.1`
- `GameVersion` : `0.8.12`
- `ModType` : `Quest`

Rappel : ne pas modifier `Namespace` / UUID sans validation explicite, pour préserver la compatibilité des sauvegardes.

## Intégrité du clone local

Contrôles effectués le 2026-07-26 :

- `git status --short --branch` : propre avant création de ce fichier.
- `git ls-files -d` : aucun fichier suivi supprimé.
- `git fsck --no-progress` : aucune sortie signalant un problème.
- Fichiers suivis vs présents :
  - `Data/Ground/*.rsground` : 68 suivis, 68 présents.
  - `Content/Tile/*.tile` : 248 suivis, 248 présents.
  - `Content/Music/*.ogg` : 51 suivis, 51 présents.
- Tous les gros fichiers critiques observés sont présents, notamment `Data/Ground/metano_town.rsground` (~38,3 Mo), `Content/Tile/index.idx` (~4,4 Mo), `Content/Music/Team_Dazzling.ogg`.

Attention : `verify_new_era.sh` est obsolète sur les compteurs exacts. Il attend 61 `.rsground` et 219 `.tile`, mais le dépôt actuel en contient 68 et 248. Le script signale donc 2 erreurs de comptage alors que les fichiers suivis sont présents.

## Validation exécutée

- `python3 tools/validate_all.py` : OK.
  - Les 5 salles de boss Ch5 (`vast_steppe_miniboss`, `vast_steppe_guardian`, `searing_tunnel_miniboss`, `mount_windswept_miniboss`, `mount_windswept_guardian`) sont validées par le script : présence des fichiers, tilesets, cohérence obstacles, spawners/markers, positions cinématiques, connexité.
- Pas de test en jeu effectué dans cet environnement.

## État technique/narratif constaté

- Le renommage public Halcyon vers `New Era : Abyss to Ascension` est bien présent dans `Mod.xml`, mais le namespace reste `halcyon`.
- `patchnotes.txt` documente seulement les versions 0.3.0, 0.4.0 et 0.5.0 ; il n'est pas à jour avec le commit courant `Version 0.5.1` de `Mod.xml`.
- Le dossier `docs/CONTEXTE_PROJET.md` contient une mémoire longue du projet, notamment les formats `.tile`, `Content/Tile/index.idx`, l'architecture `.rsground` / `.rsmap` / `Data/Zone/*.json`, et la règle de `require` explicite des `ground/<map>/<map>_ch_N.lua`.
- L'architecture Lua réelle diffère du résumé du prompt : il n'y a pas de `newera_common.lua` ni de `newera_include.lua`. Les scripts sont sous le namespace `halcyon`.
- `Data/Script/halcyon/main.lua` charge les services `debug_tools`, `menu_tools`, `upgrade_tools`, `config_tools`.
- `Data/Script/halcyon/event.lua` charge `origin.common`, `halcyon.dungeon_event.beginner_lesson_evt`, `event_single`, `event_battle`, `event_misc`, `event_mapgen`.
- Les `ground/*/init.lua` possédant des fichiers frères `_ch_N.lua` ont été inspectés : aucun cas détecté de sibling `_ch_N.lua` sans `require` correspondant.

## Team Dazzling / Lockpin

- `CharacterEssentials.lua` contient un commentaire explicite : `Lockpin` est le nom français d'espèce de Lopunny, pas un second personnage.
- Team Dazzling utilise les codenames `Adagio` (Tsareena), `Aria` (Lopunny) et `Sonata` (Mismagius).
- `Mawile` existe séparément comme PNJ `Bria`, pas comme membre Team Dazzling.
- `docs/team_dazzling_chapter6.md` dit aussi que le nom utilisé dans les dialogues est `Team Dazzling`, pas `Les Trois Reines`.

## Zones légendaires / Grodoudou

- Le système n'est plus seulement une idée : il existe dans `Data/Script/halcyon/LegendZones.lua`, `Data/Script/halcyon/ground/metano_town/metano_town_legend.lua`, `SV.LegendZones` dans `scriptvars.lua`, et le `require` correspondant dans `metano_town/init.lua`.
- Règle actuelle : achat chez Grodoudou = accès à un lieu de revanche, pas recrutement automatique ni rencontre aléatoire.
- Une seule entrée est actuellement `ready = true` : `verdant_oath` / Zarude, déverrouillée par `SV.Chapter6.DefeatedGloomyBoss == true`, destination `gloomy_forest` segment 3.
- Les autres entrées sont des contrats d'avenir avec `ready = false` ou flags non prêts.

## Points d'attention trouvés pendant la prise en main

1. `verify_new_era.sh` doit être mis à jour : ses seuils exacts 61 maps / 219 tilesets sont faux pour le dépôt courant (68 / 248).
2. `docs/audit_critique_2026-07-26.md` dit que la branche défaite Team Dazzling est absente, mais le code courant contient `PostDefeatCutscene()` et le dispatch depuis `metano_town/init.lua`. Cet audit est donc au moins partiellement dépassé.
3. Suspicion de bug dans `metano_town_ch_6.SetupGround()` : en branche `SV.Chapter6.DefeatedByZarude`, le code appelle `GROUND:TeleportTo(hero, ...)` et `GROUND:TeleportTo(partner, ...)` sans déclarer `local hero = CH('PLAYER')` ni `local partner = CH('Teammate1')` dans cette fonction. À confirmer/corriger avant de travailler sur la branche défaite.
4. Suspicion de bug de progression Ch6 : `PostDefeatCutscene()` pose `SV.Chapter6.PostMissionScenePlayed = true`. Comme le dispatch de la scène de victoire vérifie `MissionComplete and not PostMissionScenePlayed`, cela pourrait empêcher la scène post-victoire après une défaite préalable. À confirmer en test / simulation avant correction.

## Règles opérationnelles pour la prochaine tâche

- Toujours vérifier `git status --short` et `git ls-files -d` avant tout `git add`.
- Ne pas utiliser `git add -A` / `git add .` sans contrôle explicite des suppressions.
- Pour toute affirmation technique, citer fichier + ligne.
- Le test en jeu reste requis dès que possible ; les validations statiques ne suffisent pas.

---

## Session 2026-07-26 — Priorités 1 à 3 traitées sans commit

### Pré-contrôle d'intégrité

Au début de la reprise, le répertoire avait perdu `.git` dans le snapshot local. Le dépôt a été réinitialisé avec `git init`, `git fetch origin main`, puis restauré avec `git reset --hard origin/main` avant toute modification de contenu. Après restauration :

- `Data/Ground/*.rsground` : 68 présents ;
- `Content/Tile/*.tile` : 248 présents ;
- `Content/Music/*.ogg` : 51 présents ;
- `Data/Ground/metano_town.rsground` : 38 335 570 octets ;
- `git ls-files -d` : aucun fichier suivi supprimé.

### Priorité 1.1 — Ch6 `hero` / `partner` non déclarés

Bug confirmé.

Preuve dans l'état `origin/main` : `metano_town_ch_6.SetupGround()` utilisait `GROUND:TeleportTo(hero, ...)` et `GROUND:TeleportTo(partner, ...)` dans la branche retour après défaite Zarude, mais aucune déclaration locale `hero` / `partner` n'existait dans cette fonction. Les seules déclarations de ce type étaient dans d'autres fonctions (`DazzlingIntroduction`, `PostMissionCutscene`, `PostDefeatCutscene`) et ne pouvaient pas être capturées par `SetupGround`.

Test de reproduction par exécution Lua simulée via Lupa, avec `GROUND:TeleportTo` configuré pour refuser un premier argument nil :

```text
C_ORIGIN_CONFIRMED_ERROR [string "<python>"]:9: GROUND.TeleportTo first argument is nil
```

Correction appliquée dans `Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua` :

- `local hero = CH('PLAYER')` ajouté en début de `SetupGround()` ;
- `local partner = CH('Teammate1')` ajouté juste après ;
- la branche défaite utilise maintenant ces deux valeurs locales.

Lignes actuelles : `metano_town_ch_6.lua:24-26` pour les déclarations, `metano_town_ch_6.lua:69-72` pour les deux `TeleportTo`.

Test après correction :

```text
C_FIXED_TELEPORTS [('Butterfree', 824, 816), ('Adagio', 1008, 784), ('Aria', 1040, 816), ('Sonata', 1072, 848), ('PLAYER', 792, 896), ('Teammate1', 824, 896)]
```

Conclusion : la branche se déclenche en simulation sans erreur nil et téléporte bien le héros + partenaire.

### Priorité 1.2 — Conflit de flag `PostMissionScenePlayed`

Bug confirmé.

Dans l'état `origin/main`, la séquence simulée `défaite Zarude -> PostDefeatCutscene -> nouvelle tentative victorieuse` donnait :

```text
D_ORIGIN_AFTER_DEFEAT calls= ['CALL.PostDefeatCutscene'] PostMission= True PostDefeat= True
D_ORIGIN_AFTER_RETRY_WIN calls= [] PostMission= True PostDefeat= True
```

Donc la scène de victoire était bloquée : `PostDefeatCutscene()` posait `PostMissionScenePlayed = true`, puis le dispatch de victoire ne passait plus.

Correction appliquée :

- le dispatch Ch6 dans `Data/Script/halcyon/ground/metano_town/init.lua` vérifie désormais `DefeatedByZarude and not PostDefeatScenePlayed` pour la branche défaite (`init.lua:102-105`) ;
- `PostDefeatCutscene()` vérifie désormais `PostDefeatScenePlayed` au lieu de `PostMissionScenePlayed` (`metano_town_ch_6.lua:829-832`) ;
- `PostDefeatCutscene()` ne pose plus `PostMissionScenePlayed`; elle pose seulement `PostDefeatScenePlayed = true` (`metano_town_ch_6.lua:957`).

Le contenu narratif de `PostDefeatCutscene()` n'a pas été modifié ; seule la logique de flags/dispatch a été changée.

Tests après correction :

```text
D_FIXED_AFTER_DEFEAT calls= ['CALL.PostDefeatCutscene'] PostMission= False PostDefeat= True
D_FIXED_AFTER_RETRY_WIN calls= ['CALL.PostMissionCutscene'] PostMission= True PostDefeat= True
D_FIXED_VICTORY_ONLY calls= ['CALL.PostMissionCutscene'] PostMission= True PostDefeat= False
```

Conclusion :

- défaite puis victoire : la scène défaite se joue, puis la scène victoire se joue à la réussite ultérieure ;
- victoire seule : la scène victoire continue de se jouer ;
- pas de test en jeu réel effectué, seulement simulation Lua avec stubs moteur.

### Priorité 2 — `verify_new_era.sh`

Script mis à jour :

- `EXPECTED_GROUNDS=68` (`verify_new_era.sh:13`) ;
- `EXPECTED_TILESETS=248` (`verify_new_era.sh:14`) ;
- `EXPECTED_MUSIC=51` (`verify_new_era.sh:15`) ;
- les checks `.rsground`, `.tile` et musiques comparent désormais contre ces constantes (`verify_new_era.sh:20-25`, `:56-61`, `:79-84`).

Autres compteurs inspectés :

- Lua : le script affiche 229 fichiers mais ne bloquait pas sur un seuil obsolète ;
- zones JSON : le script affiche 31 zones mais ne bloquait pas sur un seuil obsolète ;
- `.resx` : pas de compteur dédié dans ce script.

Relance après correction :

```text
✅ TOUT OK — 68 maps, 248 tilesets, 51 musiques
```

### Priorité 3 — Grodoudou / Zarude segment 3

Deux niveaux de vérification ont été exécutés.

#### Vérification statique complète

`python3 tools/verify_legend.py /home/user/new-era-abyss-to-ascension-V4` : résultat `TOUT EST VERIFIE`.

Points vérifiés par ce script :

- `Legend_Merchant` est présent sur `metano_town.rsground`, espèce `wigglytuff`, action activable, case marchable ;
- `Legend_Stand` et `Legend_Stand_Marker` existent ;
- `metano_town/init.lua` require et délègue au module `metano_town_legend.lua` ;
- `LegendZones.lua` existe ;
- toutes les clés `LZ_*` utilisées existent en EN et FR ;
- `verdant_oath` est la seule entrée `ready=true` ;
- `gloomy_forest` possède le segment 3 ;
- le segment 3 charge `verdant_oath_arena.rsmap` ;
- la map contient Zarude et `Unrecruitable = false` ;
- `zone/gloomy_forest/init.lua` gère `segmentID == 3` et appelle `LegendZones.SetDefeated('verdant_oath')`.

#### Simulation Lua du parcours boutique

Simulation via Lupa du vrai `LegendZones.lua` + `metano_town_legend.lua` avec stubs moteur :

```text
A no story unlock: buy list stays empty
  keys_contains_Verdant= False nothing= True
  spent= [] purchased= False defeated_flag= False
  enterDungeon= []

B story unlock: purchase succeeds
  keys_contains_Verdant= True nothing= False
  spent= [15000] purchased= True defeated_flag= False
  enterDungeon= []
  sounds= ['DUN_Money']
  flash= [(0, 0, 2, 6, 26)]

C owned zone: travel enters gloomy_forest segment 3
  keys_contains_Verdant= True nothing= False
  spent= [] purchased= True defeated_flag= False
  enterDungeon= [('gloomy_forest', 3, 0, 0)]

D segment 3 combat context
  segment_count= 4 mapid= verdant_oath_arena rsmap_exists= True
  map_species= ['zarude'] unrecruitable= [False]
```

Conclusion : le parcours achat puis voyage vers `gloomy_forest` segment 3 est cohérent en simulation. Le combat réel en jeu n'a pas été lancé dans cet environnement.

### Validations générales relancées

- `bash verify_new_era.sh` : OK, plus de fausse erreur de compteur.
- `python3 tools/verify_legend.py /home/user/new-era-abyss-to-ascension-V4` : OK.
- `python3 tools/validate_all.py` : OK, les 5 salles de boss Ch5 restent valides.

### État Git après cette session

Fichiers modifiés non commités :

- `Data/Script/halcyon/ground/metano_town/init.lua`
- `Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua`
- `verify_new_era.sh`

Fichier non suivi :

- `PROJECT_CONTEXT.md`

Aucun commit/push effectué.

---

## Session 2026-07-26 — Application du guide maître Team Dazzling

Guide lu : `/home/user/uploads/guide-maitre-new-era.md`.

### Décision d'application

Le guide demande une introduction officielle Team Dazzling immédiatement après `Grand Stepped` (`guide-maitre-new-era.md:103-104`). Dans le dépôt réel, aucun identifiant exact `Grand Stepped` n'existe ; l'équivalent le plus proche est `vast_steppe` / Grande Steppe. Or `vast_steppe` est intégré au chapitre 5 comme étape de l'expédition : après victoire finale, `Data/Script/halcyon/zone/vast_steppe/init.lua:100-102` route directement vers `searing_tunnel_entrance`, et `vast_steppe_guardian_ch_5.DefeatedBoss()` route aussi vers `searing_tunnel_entrance` (`Data/Script/halcyon/ground/vast_steppe_guardian/vast_steppe_guardian_ch_5.lua:239-244`).

Après clarification utilisateur, carte blanche a été donnée. Choix appliqué : ne pas casser le flux Ch5 existant ; renforcer la première scène Team Dazzling déjà chargée par l'architecture actuelle en chapitre 6, tout en appliquant les exigences qualitatives du guide : entrée célébrité, foule, thème musical, ton condescendant non maléfique, mission Chenipent comme contraste prestige/compassion.

### Changements appliqués

Fichier : `Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua`.

- Ajout d'un court temps de célébration avant l'arrivée des Dazzling : nouvelles clés `MT6_118` à `MT6_121`, jouées juste après le placement initial du héros, du partenaire et de Papilusion.
- Réorganisation locale : Papilusion ne formule sa demande qu'après l'entrée de la Team Dazzling, pour suivre le déroulé du guide : satisfaction du retour -> rumeur -> entrée Dazzling -> demande de secours.
- Ajout du thème `Team_Dazzling.ogg` dans l'introduction, avec `SOUND:FadeOutBGM(30)` puis `SOUND:PlayBGM("Team_Dazzling.ogg", true)`. Le fichier existe et `verify_new_era.sh` le vérifie.
- Réécriture des clés `MT6_003` à `MT6_006`, `MT6_015` à `MT6_017`, `MT6_042` à `MT6_047` pour coller au guide : Adagio polie et supérieure, Aria provocatrice, Sonata théâtrale, foule impressionnée.

Fichiers de texte :

- `Data/Script/halcyon/ground/metano_town/strings.resx` : valeurs EN ajustées et clés `MT6_118` à `MT6_121` ajoutées.
- `Data/Script/halcyon/ground/metano_town/strings.fr.resx` : valeurs FR ajustées et clés `MT6_118` à `MT6_121` ajoutées.

Adaptation assumée : le guide parle de Chenipotte, mais le dépôt réel a déjà `Venipede` / `Chenipent` comme personnage de mission (`CharacterEssentials.lua` et `docs/team_dazzling_chapter6.md`). La scène conserve donc Chenipent pour ne pas casser les scripts de mission existants.

### Tests effectués

- Parse XML de `strings.resx` et `strings.fr.resx` : OK.
- Simulation Lua de `metano_town_ch_6.SetupGround()` + `DazzlingIntroduction()` avec stubs moteur : OK.
  - `SV.Chapter6.DazzlingIntroPlayed` devient `true`.
  - `SV.Chapter6.MissionAvailable` devient `true`.
  - `SOUND:PlayBGM("Team_Dazzling.ogg", true)` est bien appelé.
  - Les nouvelles clés `MT6_118` à `MT6_121` sont bien lues.
- `bash verify_new_era.sh` : OK.
- `python3 tools/validate_all.py` : OK.
- `python3 tools/verify_legend.py /home/user/new-era-abyss-to-ascension-V4` : OK.

Pas de test en jeu réel effectué dans cet environnement.

### État Git

Modifications non commitées supplémentaires :

- `Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua`
- `Data/Script/halcyon/ground/metano_town/strings.resx`
- `Data/Script/halcyon/ground/metano_town/strings.fr.resx`

Les modifications précédentes restent non commitées :

- `Data/Script/halcyon/ground/metano_town/init.lua`
- `verify_new_era.sh`
- `PROJECT_CONTEXT.md` non suivi

---

## Session 2026-07-27 (agent Arena.ai) — Addendum boss Ch5 : LOT -1, 6, 7, 8

Branche : `arena/019fa547-new-era-abyss-to-ascension-v4`. PR #3.

### LOT -1 — Intégrité (vérifié AVANT toute écriture)

- `git status` propre, `git ls-files` vs disque : **aucune différence** sur `Data/Map/*.rsmap`.
- Les 6 `.rsmap` de boss présents et non vides (84 Ko à 229 Ko).
- Aucun fichier de taille nulle dans `Data/Ground` / `Data/Map`.
- **Correction d'une inexactitude de doc** : le guide maître annonce 370 `.rsmap` et 244 `.rsground`. Le dépôt contient **186 `.rsmap`** et 244 `.rsground`, et `git ls-files` en compte exactement 186 — ce n'est donc pas une perte de données mais un compteur faux dans la doc. `verify_new_era.sh` attend lui 68 `.rsground` (chiffre d'une ancienne arborescence). Ces compteurs sont à réconcilier un jour.

### LOT 1 — Positions réelles des boss (vérifiées, pas estimées)

Lues dans `MakeCharactersFromList` : Mudbray (184,232) + Stantler (152,200) ; Stantler Alpha (184,200) ; Torkoal (220,232) + Magmar (292,208) ; Magcargo (256,192) ; Gligar (180,240) + Skarmory (268,192) ; Aerodactyl (224,192).
Toutes conformes aux estimations du prompt (±8 px) **sauf** le second membre de chaque duo, plus haut/latéral que l'estimation. Positions duo/coéquipiers recalculées sur la position réelle du boss le plus bas de chaque arène.

### LOT 6.2 — Écran de résultats : bug trouvé et corrigé

`GeneralFunctions.EndDungeonRun(result, zone, structure, mapid, entryid, display, fanfare)` : c'est **`display`** qui déclenche le journal de fin de donjon.

- `vast_steppe_guardian` (Steppe → premier camp) passait `display=false, fanfare=false` → **aucun écran de résultats** avant la cinématique du camp. Corrigé en `true, true`.
- Deux autres sorties de victoire ont le même défaut mais sont **hors périmètre autorisé** : `zone/vast_steppe/init.lua:133` (ground 47) et `zone/searing_tunnel/init.lua:216` (ground 49, Crucible). Le correctif a été préparé puis **annulé** (`git checkout`) pour respecter la liste blanche. **À corriger dans une prochaine tâche autorisant `Data/Script/halcyon/zone/`.**
- Les mini-boss n'utilisent pas `EndDungeonRun` (ils restent dans la session : `EnterGroundMap` intra-zone ou `ContinueDungeon`) : pas d'écran de résultats attendu à ce stade, c'est cohérent.
- `mount_windswept_guardian` (fin de chapitre) était déjà correct (`true, true`).

### LOT 8 — Modèle Crooked Cavern + portraits

- Référence étudiée : `ground/crooked_den/crooked_den_ch_3.lua` (108 clés FR). Caméra assez **statique** (3 `MoveCamera` sur toute la scène) mais **densité et variété d'emotes très supérieures** : Angry, Crying, Joyous, Special1/2, Stunned… Écart signalé : les scènes Ch5 visent une caméra plus mobile que ce modèle ; c'est assumé et conforme à l'addendum.
- **Portraits : contrainte majeure.** `Content/Portrait/` ne contient que **34 portraits**, indexés par n° national. **Aucune espèce de boss du Ch5 n'a de portrait** : Mudbray #749, Stantler #234, Torkoal #324, Magmar #126, Gligar #207, Skarmory #227, Aerodactyl #142, Magcargo #219 — tous absents. Growlithe #58 (Hyko) et Audino #531 (Rin) également absents. Présents : starters, Zigzagoon #263 (Almotz), Tropius #357 (Penticus).
  → Conséquence : les boss **ne peuvent pas** avoir de portrait dans une boîte de dialogue. Le texte narratif les concernant est donc écrit en boîte centrée (`UI:SetCenter(true)`), comme le fait déjà le code existant. Les emotes employées sont toutes issues du jeu de Crooked Cavern (Normal, Worried, Determined, Surprised, Sad, Pain, Inspired), donc sûres.

### Durée / densité (LOT 6.1 et 8.3) — mesuré, non atteint, signalé

Estimation (12 car/s + 1,2 s par boîte, hors combats et exploration) :

| Scène | Avant | Après |
|---|---|---|
| Steppe mini-boss | 2,0 min | **3,2 min** |
| Steppe gardien | 1,8 min | **2,7 min** |
| Tunnel mini-boss | 1,9 min | **2,5 min** |
| Crucible (créateur) | 9,5 min | 9,5 min |
| Mont mini-boss | 2,0 min | **2,8 min** |
| Mont gardien | 1,8 min | **2,6 min** |
| **Total cinématiques boss** | 19,0 min | **23,3 min** |

+48 clés EN/FR ajoutées. L'objectif de 10 min par scène **n'est pas atteint** (sauf Crucible) et n'a pas été forcé : conformément à la consigne, on signale plutôt que de remplir. Le Crucible montre qu'atteindre 10 min demande ~86 boîtes et plusieurs PNJ nommés présents dans la scène — les arènes de boss n'ont que héros + partenaire + une Voix sans portrait.

**Estimation durée totale Ch5 : ~2 h 30 à 3 h 30** (36 étages procéduraux + 6 arènes + cinématiques + camp), donc **en dessous des 5 h visées**. Le levier réaliste n'est pas le dialogue de boss mais les relais (`vast_steppe_midpoint` n'a que **4 clés**) et les lots A-F de `docs/production_ch5_dialogues.md`.

---

## Session 2026-07-31 (agent Arena.ai) — arc 2, add-ons, Grodoudou, Team Dazzling

Branche `arena/019fa547`. **PR #3 toujours OUVERTE** — rien n'est mergé, rien n'est testé en jeu.

### Livré dans cette session

| Vague | Contenu |
|---|---|
| Boss ch5 | cadrage caméra, flash blanc, stats 25-32, dialogues, tag |
| Réseau des Anciens Chemins | Veilleurs (12 arènes) + ouverture des voies + 12 derniers donjons pmd-red (zones 44-55) |
| Réseau du Ciel | 67 zones EoS (`new_era_sky_00..66`), 25 Stations-Relais |
| Tunnel Ardent | fix brume + **arène mini-boss qui n'existait pas** + clan de lave développé |
| Arc 2 | `SuaireArc.lua` (5 actes) + `SuaireJobs.lua` (5 contrats de job board) |
| Grodoudou | déplacée au comptoir libre + cinématique d'arrivée |
| Team Dazzling | audit + **16 clés de dialogue non traduites** corrigées |

### Bugs réels trouvés et corrigés (pas des ajouts, des réparations)

1. **`searing_tunnel_miniboss.rsmap` était orpheline** : aucun segment ne la chargeait.
   Le combat Torkoal/Magmar n'avait donc jamais lieu, et `DefeatedBoss`/`DiedToBoss`
   étaient du code mort. Segment d'arène créé, renumérotation complète de la zone.
2. **Brume du Tunnel** : `AddMapStatus("steam")` absent, remplacé par un overlay
   ponctuel sur une carte de 416×544 → salle couverte en partie seulement.
3. **`colossus_quarry`** : `cloven_ruins` n'appelait jamais `SetDefeated`. La zone-amie
   Regigigas à 22 000 P n'était jamais marquée comme conquise. `verify_legend` passe
   maintenant à **0 échec** (contre 2 au baseline).
4. **16 clés Team Dazzling** (MT6_101..116) écrites en français dans le fichier
   **anglais** et absentes du fichier FR → le joueur FR voyait du texte non traduit sur
   toute la scène de défaite et de victoire du ch6.
5. **`TunnelMiniBossDefeated/Lost`** non déclarés dans `scriptvars`, contrairement à
   leurs 6 homologues.

### ⚠️ Risque à tester en priorité

**La renumérotation des segments de `searing_tunnel`** : avant `2=Crucible, 3=annexe`,
après `2=arène, 3=Crucible, 4=annexe`. Le moteur stocke segment+étage dans le `ZoneLoc`
de la sauvegarde. Une partie sauvegardée **à l'intérieur** du Tunnel peut pointer sur un
segment qui a changé de sens. Un `ZoneLoc` n'est pas modifiable depuis Lua : le décalage
est documenté dans `debug_tools` avec un garde `OnUpgrade`. **Sortir du donjon avant de
charger cette version.**

### État chiffré du dépôt

- **202 donjons** (12 histoire + 68 Ancrages/secondaires + 46 pmd-red + 67 EoS + 9 mazes)
- **73 ont une arène de boss** ; les 67 zones EoS et 34 des 46 pmd-red n'en ont pas
  (choix assumé des vagues : les cinématiques viendront après)
- Validation intégrale : Lua **634/634**, zones **208/208**, resx **555/555**,
  rsground **269/269**, index **209 entrées, 0 zone manquante**

### Corrections d'idées fausses de mes rapports précédents

- **Les portraits ne manquent pas.** Les 34 fichiers de `Content/Portrait/` sont des
  surcharges du mod ; le moteur PMDO fournit nativement les autres. Mes réserves sur
  Torkoal/Magmar/Suaire/Veilleurs étaient infondées.
- **`Data/Monster/` ne contient que des surcharges** (12 espèces). La liste réelle est
  dans `Data/Misc/MonsterFeature.json` (975 espèces) — c'est la source à interroger.
- **Les autotiles de donjon viennent du jeu de base**, pas du dépôt. Vérifier leur
  existence dans `Data/AutoTile/` (8 fichiers seulement) donne un faux négatif ; le bon
  critère est « déjà référencé par une zone existante ».

### Ce qui reste (par valeur décroissante)

1. **Tester en jeu.** 10 vagues de contenu non testé, c'est le vrai risque du projet.
2. Cinématiques de boss pour les 67 zones EoS et les 34 pmd-red sans arène.
3. Densité des relais ch5 : `vast_steppe_midpoint` et `mount_windswept_midpoint` n'ont
   que **4 clés** chacun, contre 42 pour `searing_tunnel_midpoint`.
4. Chapitres 11-32 : donjons et 42 cinématiques d'Ancrage prêts, **scénario non écrit**.
5. `normal_maze` déclare 38 GroundMaps (toute la ville, la guilde…) — résidu de test à
   nettoyer, sans danger immédiat mais brouille les audits.


## Audit de session 2026-07-28 — vérification des affirmations du build `2026-08-01-G` (cycle nuit + Rondoudou)

Audité sur la branche `arena/019fa547-new-era-abyss-to-ascension-v4`, commit `7773049`.
Étape 0 : `git status` propre, 0 `deleted:`, 271 `.rsground` / 497 `.tile` / 133 `.ogg` présents.

### 1. Format `.tile` + roundtrip — CONFIRMÉ
- `tools/tile_night.py` existe (7 071 o), documente le format `[u32 tileSize][u32 nb][table 16o][PNG 8×8]`.
- `python3 tools/tile_night.py --check` réexécuté : **14/14 tilesets roundtrip=OK**, « FORMAT VALIDE ».
- Vérification indépendante (script séparé) : Metano_Town_Base = 35 646 refs / 3 929 tuiles distinctes, PNG magic OK, MD5 `2dd72c6a…` conforme au commentaire du script.
- Planche `docs/apercu_tuiles_nuit.png` présente (672×236 RGB, lisible).

### 2. Carte `metano_town_nuit.rsground` — CONFIRMÉ avec 2 écarts
- Fichier présent, 38 815 146 o (non vide).
- **Écart 1** : la carte est à l'index **79** de `master_zone.json`, PAS 80 (80 = `guild_guildmasters_bedroom`). Le routage Lua (`TownNight.lua:272`, `NightWatch.lua:244`) passe par `EnterGroundMap('metano_town_nuit', …)` par nom → aucun impact fonctionnel, mais l'affirmation « index 80 » est fausse.
- Les 14 tilesets `Metano_Town_*_Night.tile` existent physiquement dans `Content/Tile/` (listés un à un).
- **Écart 2 (corrigé ce jour)** : les 14 tilesets Night étaient **absents de `Content/Tile/index.idx`** (483 entrées au lieu de 497). Régénéré via `tools/rebuild_tile_index.py` : 497 entrées, toutes les anciennes préservées bit à bit (vérifié par parsing comparatif). `Data/Zone/index.idx` contenait déjà `metano_town_nuit`.
- Obstacles nuit == jour : **True** (comparaison structurelle des deux grilles 189×189, pas des tailles).
- Musique : `Goodnight.ogg` (jour : `Treasure Town.ogg`).

### 3. `TownNight.lua` + 3 PNJ — CONFIRMÉ avec 1 nuance
- `Data/Script/halcyon/TownNight.lua` (446 l.). PNJ : `Nuit_Garde` (Veilleur de Nuit), `Nuit_Etoiles` (Compteuse d'Étoiles), `Nuit_Insomniaque` (Plume-Grise) — nicknames dans `CharacterEssentials.lua:1058-1076`.
- 4 paliers **distincts** chacun (`TownNight.LINES`, l.324-364 ; textes différents vérifiés) ; sélection par compteur `s.Met[inst]` (`Talk`, l.366).
- **Nuance** : les 12 marchands ne sont PAS retirés de la carte (les entités existent dans le `.rsground` nuit) ; ils sont masqués par `GROUND:Hide` à l'Init (`metano_town_nuit/init.lua:73-75`). Le code le documente honnêtement (l.345-352) et pose un filet : 12 handlers `*_Owner_Action` → réplique `absent(…)`.
- Commerces fermés : `Shop/Bank/Storage/Swap/TM/Tutor/Appraisal_Action` + panneaux + `Legend_Stand_Action` donnent tous du texte (l.130-344). Vérifiable en statique uniquement — non testé en jeu.

### 4. Choix de fin de journée — CONFIRMÉ avec 1 nuance
- `TownNight.StoryLocked()` : `TownNight.lua:91`. `Offer()` (l.128) : deux ChoiceMenuYesNo enchaînés → 'diner'/'dormir'/'ville'. Gating chapitre ≥ 6 (`Available`, l.122).
- **Nuance** : StoryLocked teste `MissionCompleted`, `MorningWakeup`, `MorningAddress` — mais PAS `Dinnertime`/`Bedtime` en entrée (ces deux-là sont *reposés* par `EndDay` l.192-241 pour préserver l'enchaînement d'origine). L'affirmation « teste les 4 drapeaux » est donc partiellement vraie (2/4 testés + MissionCompleted).
- Point d'insertion : PAS dans `GeneralFunctions.lua` — dans les `zone/*/init.lua` (9 zones appellent `TownNight.EndDay`/`EndDayWithEpilogue` : gloomy_forest, mount_windswept, searing_tunnel, vast_steppe, relic_forest, apricorn_grove, crooked_cavern, illuminant_riverbed, …).

### 5. Pas de système temporel parallèle — CONFIRMÉ
- `DaysPassed` : 31 usages ; `EndOfDay` : 17 ; drapeaux fin de journée : 214 usages — tous en place.
- Aucun `CurrentHour`/`TimeOfDay`/`NightMode` dans `scriptvars.lua` (grep = 0).

### 6. Rondoudou (Grodoudou) — PARTIELLEMENT CONFIRMÉ
- Entité `Legend_Merchant`, espèce `wigglytuff`, nick `Grodoudou`, **présente et visible** dans les DEUX cartes, pos **(656, 1272)** ; objet `Legend_Stand` (648,1248). Sprite : `Content/Chara/40.chara` ABSENT du dépôt (39 .chara custom seulement) → le sprite vient de l'asset pack PMDO de base, non vérifiable dans ce dépôt.
- **Position vs « Ramolos »** : ambiguïté dans la demande. Le Kecleon (Shop_Owner « Lars ») est en **(1056, 832)** → ~594 px de Grodoudou : PAS adjacent. Le vrai Ramolos/Slowpoke (Tutor_Owner « Ezalor ») est en **(1159, 1277)** → ~503 px : PAS adjacent non plus. Grodoudou est dans la **rangée des étals** avec Mido/nuzleaf **(592, 1296)** et Rhizo/lombre **(720, 1296)** (~68 px chacun) — zone commerciale cohérente, mais PAS celle de Lars/Ezalor. À trancher : le déplacer ou valider l'emplacement actuel.
- **Population du shop Kecleon** : autour de (1056,832) il n'y a que Lars et Zigs/TM_Owner (1080,832). Aucun client/passant statique dans la carte (les 12 MapChars sont tous des marchands + Hyko en 663,924) ; la vie ambiante repose sur les scripts (TownVoices…). Signalé, non « supposé normal ».
- Interaction : `metano_town_legend.lua` a une vraie mise en scène d'achat (FaceUp, PurchaseFlash, émotes) — pas un menu sec.
- **Cinématique d'introduction du stand : ELLE EXISTE** — `metano_town_legend.ArrivalScene` (`metano_town_legend.lua:215`), caméra sur le comptoir, partenaire + Grodoudou se présentent, jouée une fois après `FinishedExpedition`, branchée dans `metano_town/init.lua:2825/2832`.

### Réserve générale
Audit statique (fichiers/lignes). Aucun test en jeu dans cette sandbox.


## Correctifs test en jeu 2026-07-28 (2e passe) — Mount Windswept Entrance
- BUG 1 (sacs multiples + Yellow_Box) : BuildCampDay = 1 seul Grassy_Bag (196,224), caisse supprimee ; BuildCampMorning = sac seul, feu eteint.
- BUG 2 (Penticus sur le feu / immobile) : feu purge au matin (BuildCampMorning) + Penticus s'ecarte en (216,240) et Phileas (216,208) avant les departs (section 14).
- Cameras trop brutes + arrivee : l'expedition arrive desormais PAR LE SUD (spawn 256,588-636) et remonte la colonne x=256 en ligne droite (couloir degage : 8 pointes rocheuses taillees cols 31-32), camera en 2 glissements longs (150/110 frames). Anciennes coords heritees du Tunnel (92,176/60,136) supprimees.
- BUG 3 (carte) : agrandie 63x69 -> 63x81 (commit precedent) ; clairiere degagee ; 8 touffes Flowers_Town_3 (asset atteste au relais) posees en deco ; marker sud (256,616).
- BUG 4 (coffre) : c'est Kangaskhan_Rock (depot Kangaskhan, GeneralFunctions.Kangashkhan_Rock_Interact — callback existant, pas un bug de script). Il etait INCRUSTE dans la falaise ouest (160,144, 3 cellules sous collision). Deplace en (176,352), zone 4x4 verifiee libre, accessible.
- BUG 5 (vertige/reve invisibles) : le reve utilise desormais le patron des visions : DreamSky (Dream_Back+Dream_Front en parallaxe, les « fichiers dream qui se superposent » = leur usage prevu) + UI:WaitShowBG('Genesis_Void') par-dessus le fondu noir (comme HeroVisions), puis WaitHideBG. Le DizzyVeil du matin reste (ecran allume).
- Reste a faire (assume, non code) : tentes (aucun asset objet 'tent' dans le depot — les tentes du relais sont dans SON tileset) et ocean visible (repeinture de tiles cote sud avec DuskBeach/beach_animation, gros chantier a part). Les lits n'apparaissent QUE la nuit (DeployBeds) et disparaissent au matin : le camp est bien « demonte au reveil ».


## Chantiers complementaires 2026-07-28 (3e passe) — Mount Windswept Entrance

### Verification tentes (demande de suivi — documentee, non concluante en assets objets)
Fichiers consultes :
- Content/Object/ (29 .dir listes un a un) : AUCUN asset de tente. Seuls camp-assets : Campfire, Grassy_Bag, Hay_Bed, Yellow_Box, River_Stone_*.
- Content/Tile/ : ForestCamp/ForestCampFront/ForestCampSecret(+Front) rendus en PNG -> ce sont des tilesets de clairiere forestiere (murs de feuillage + herbe), PAS de tentes dessinees.
- CliffCamp, SnowCamp, CanyonCamp rendus -> paysages (falaises, neige, canyon+riviere). Le rendu complet de mount_windswept_midpoint (624x1152) montre falaises/riviere/pont, pas de sprites de tentes distincts.
- DumpAsset (API GitHub, 209 entrees Content/Tile) : BaseCamp/CaveStop/ForestCamp etc. examines ; BaseCamp = clairiere du camp de base RB (rendu verifie), pas de tuiles de tente isolables proprement.
Conclusion actee : pas d'asset de tente reutilisable -> le camp reste raconte par feu + sac + paillasses nocturnes (DeployBeds) ; « camp demonte au reveil » deja conforme.

### Chantier ocean (commit 174df36)
- Mer animee DuskBeach (8 frames, FrameLength 10 — patron riviere Metano) sur les rows 76-80, infranchissable (Tags=1).
- 6 pierres cotieres River_Stone_* en deco sur la greve ; marker remonte en (256,592) ; file d'arrivee remontee hors de l'eau (lua).
- Valide : luac OK, audit 0 defaut, BFS marker->feu->portail OK, rendu PNG controle. NON teste en jeu (pas d'executable dans la sandbox) : retest joueur requis.

### Rappel : retest en jeu des 5 bugs (31dce6b) + ocean (174df36) a faire par le joueur sur la save v6.


## Session 2026-07-29 — Mont Venteux, retours de test en jeu (builds F et G)

Branche : `arena/019faad0-new-era-abyss-to-ascension-v4`
Commits : `1f9504a` (build F), `739b631` (build G). Poussés.
Tag de build courant : **2026-08-02-G** (3 fichiers : `main.lua`, `scriptvars.lua`, `ground/vast_steppe_midpoint/init.lua`).

### Bugs corrigés, avec la cause racine lue dans le moteur

1. **Le rêve ne s'affichait pas** — deux causes cumulées, indépendantes.
   - *Culling.* `OverlayEmitter.cs:83` construit son `OverlayAnim` avec `omnipresent = false` ;
     `GetDrawSize()` renvoie alors `Loc(TileSize)` = 24×24, et `BaseScene.IterateRelevantDraw`
     ne dessine que si ce rectangle touche le `ViewRect` (`BaseGroundScene.cs:155`).
     Un overlay émis en **(0,0)** avec la caméra sur le camp (256,228) est donc supprimé du rendu,
     alors même que `RepeatX/RepeatY` le ferait paver l'écran. `DizzyVeil` et `first_core`
     marchaient car émis à la caméra / sur l'objet. Correctif dans `BossFX.Overlay` :
     émission au centre caméra quand aucune position n'est demandée.
   - *Le rêve jouait sous le fondu noir.* `fadeScreen` est dessiné **après** la scène
     (`GameManager.Draw:1363`) : aucun overlay, même `DrawLayer.Top`, ne passe devant.
     On lève donc la lumière après avoir posé la parallaxe (les planches `Dream_*` sont
     opaques, alpha 255 mesuré, et masquent le bivouac).

2. **Le héros « courait sur place »** — `VoiceVisions.Recover` posait
   `CharSetAnim(chara,"Idle",true)`, une `IdleAnimGroundAction` explicite et **bouclée**
   (`ScriptGround.cs:791`) qui ignore le gel de `CutsceneMode` (`GlobalIdle=0`).
   Le héros était le seul personnage animé de la carte. Remplacé par `CharEndAnim`.

3. **Formation du rassemblement** — reprise de la disposition canonique du mod, relevée dans
   les marqueurs de `Data/Ground/guild_third_floor_lobby.rsground` et utilisée par
   `guild_third_floor_lobby_helper.SetupMorningAddress` aux ch1/3/4/5/7 :
   **2 rangées de 5**, colonnes tous les 32 px, chef devant, savant en retrait.
   L'ancienne colonne de 5 rangs faisait 156 px de profondeur pour un viewport de 240.

4. **Le feu de camp se traversait** — `Ground/Maps/GroundAnim.cs`, en-tête :
   « Unlike GroundObject, it cannot be collided or interacted with ». `GroundAnim`
   n'implémente pas `IObstacle`. Correctif : `GroundObject` invisible (anim `""`) superposé,
   patron `altere_pond_ch_5.lua:10`, `Passable=false` → `Tags=1` → `SlideResponse`.
   Boîte **24×24 centrée** (et non 36×36) : BFS sur la grille, les 25 cases perdues sont
   exactement celles du foyer, **zéro déconnexion**.
   Fonctions : `AddFireBlocker` / `RemoveFireBlocker`, appelées par `BuildCampDay`,
   `DeployBeds` et `PurgeDecor`.

5. **Le camp se vidait en fin de cinématique** — la fin d'`ArrivalCutscene` retirait les dix
   PNJ, dont les trois que la scène laisse au camp ; `SetupGround` n'est pas appelée sur ce
   chemin. Seuls les **sept partants** sont retirés désormais ; Penticus, Phileas et Hyko
   restent, aux positions exactes de `SetupGround` (230,190 / 288,196 / 224,206).

6. **Cinématique de secours (KO)** — Hyko jouait `DUN_Heal_Bell`, le son de la capacité Soin
   (signature d'Audino) alors qu'il est de type Feu, et agissait **en silence**.
   Remplacé par `DUN_Heal` (attesté `DazzlingArc.lua:561`, `event_battle.lua:1049`),
   avec annonce avant et commentaire après (clés `MWE5_179`, `MWE5_180`).

7. **Son de Soin dans le rêve** — `DUN_Heal_Bell` jouait à l'apparition de l'entité.
   Remplacé par `_UNK_DUN_Water_Drop`, déjà la signature d'entrée de la présence
   dans ce même rêve : une seule signature sonore pour l'entité.

8. **Sac retiré** — le `Grassy_Bag` (260,196) encombrait le centre du camp.
   `BuildCampMorning` laisse désormais le calque vide.

9. **Accueil par caractère** (clés `MWE5_172..178`) et **gag de la cordée**
   (clés `MWE5_181..185`, `Guildmaster Wigglytuff.ogg` démarrant exactement sur l'insulte).

10. **OST d'arrivée** — il y avait ~500 lignes de silence total entre `StopBGM` et le
    `PlayBGM` final : le `FadeOutBGM` qui ouvre le gag du camp s'appliquait sur du vide.
    `Cliff Camp.ogg` (déjà le camp de la Grande Steppe) démarre sous le noir.

### Outil corrigé
`tools/count_dialogue.py` ignorait les helpers `Says` / `SaysA` / `greet` : la carte
sous-comptait de 33 boîtes et **le compteur ne bougeait pas** quand on ajoutait du dialogue.
Test négatif vérifié (1617 → 1616 → 1617).

### Références de validation (à reproduire avant chaque commit)
lua compile OK · `audit_bugs` 12 · `verify_legend` vert · `verify_scene_positions` vert ·
`audit_integrite` 925 · `verify_ground_reachability` 27 · `verify_assets_exist` 0 ·
`verify_bg_format` vert · `audit_scene_collisions` 0 · `audit_micro_moves` 0 ·
`verify_scene_fades` 23 (dette) · `audit_scene_liveliness` 988 (dette mod entier).
resx Mont Venteux : **173/173**, zéro manquante, zéro orpheline. ch5 : **1624** boîtes.
`count_dialogue.py` se lance **sans argument** (plante avec `.`).

### À TESTER EN JEU (rien de ce qui précède ne l'a été)
- Le rêve s'affiche-t-il enfin (parallaxe du test de personnalité) ?
- Le feu de camp bloque-t-il, sans coincer personne autour du foyer ?
- Le camp reste-t-il peuplé (Penticus, Phileas, Hyko) après la cinématique ?
- L'assemblée matinale : plus de course sur place, formation 2×5 lisible en un plan ?
- Le gag Ganlon/Shuca tombe-t-il juste après la nausée ?
- La scène de secours après KO est-elle cohérente (Hyko parle, son de baie) ?

### Bugs connus NON résolus (hors périmètre de cette session)
- Sprite de l'entité du rêve : `Content/Chara/282.chara` (Gardevoir) **absent**, le mod
  n'embarque que 39 espèces. Décision utilisateur en attente (importer vs silhouette).
- `GeneralFunctions.EmoteAndPause` est **défini deux fois** (lignes 398 et 455) ;
  la seconde écrase la première.
- 23 cartes sans garde-fou de fondu dans `Init` (`verify_scene_fades`).
- Statisme : `mount_windswept_midpoint_ch_5` à 96 %, `vast_steppe_midpoint` 84 %,
  `vast_steppe_guardian` 82 %, `searing_tunnel_entrance` 41 %.
- Bureau du maître de guilde : ch7-10 inexistants, ch6 = 2 boîtes.
- Densité : ch6 457 / ch7 397 / ch8 324 / ch9 307 / ch10 256, contre 7000 visés.


## Session 2026-07-29 (suite) — builds H à K

Commits : `7652fec` (H) · `aa4d3d4` (I) · `6894d3a` (J) · `7619a06` (K). Tous poussés.
Tag de build courant : **2026-08-02-K**.

### LE RÊVE A SA PROPRE CARTE
`Data/Ground/hero_dream.rsground` (320×240) + `Data/Script/halcyon/ground/hero_dream/`.

Le décor onirique n'est plus un overlay mais le **fond de carte**
(`Background.Layers` / `LayeredBG`), copie structurelle de `personality_test.rsground` :
`Dream_Back` alpha 255 dérive +30, `Dream_Front` alpha 128 dérive −30, sens contraires.
Le moteur le dessine avant tout le reste, **sans condition de culling** — contrairement à
un `FiniteOverlayEmitter`, qui était supprimé du rendu (voir plus haut, `GetDrawSize()`).

L'entité apparaît par **clignotement** en enchaînant les trois seuls paliers d'opacité que
le moteur expose (`UpdateDrawEffects:78-82`) : `Absent`=0, `Transparent`=128, rien=255.

### ⚠️ DÉCLARER UNE CARTE DEMANDE **DEUX** FICHIERS
Erreur commise, crash bloquant en jeu (`Invalid Ground Map Name: hero_dream`).

Le moteur ne lit **pas** `Data/Zone/master_zone.json` pour valider un nom de ground :
il interroge l'index compilé `Data/Zone/index.idx`
(`GameManager.MoveToGround:712` → `ZoneEntrySummary.GroundValid` → `Grounds.Contains`).
`index.idx` est du **JSON** malgré son extension.

→ Toute nouvelle carte doit être ajoutée **à la même position dans les deux fichiers**,
et les deux listes doivent rester strictement identiques.
Contrôle : comparer `index.idx > Object > master_zone > Grounds` avec le `GroundMaps`
de `master_zone.json`.

### UN CHANGEMENT DE CARTE NE DOIT JAMAIS COUPER `CutsceneMode`
Cause du bug « on revoit le ground du tunnel pendant la transition ».
`GroundScene.cs:176` : couper le mode cinématique réveille la boucle de rendu de la carte
sortante. Or `EnterGroundMap` ne bascule pas sur-le-champ — il arme `SceneOutcome`, que la
boucle principale consomme au tour suivant (`GameManager.cs:506-512`).
→ Garder `CutsceneMode(true)` jusqu'au bout ; c'est la carte d'**arrivée** qui le relâche
après avoir posé son propre fondu.

### LES SPRITES SONT PLUS GRANDS QUE LES COLLIDERS
Un personnage n'occupe pas 16×16 à l'écran. `GroundAction.GetDrawLoc:116` centre la feuille
sur le collider : `drawX = MapLoc.X + 8 − TileWidth/2`.
Mesuré dans l'en-tête des `.chara` : **Tropius 40×40 · Noctowl 38×32 · Growlithe 32×28**.
→ Tout contrôle de recouvrement (feu, décor, cadrage caméra) doit se faire **sprite compris**,
jamais sur le collider seul.

### Corrections de mise en scène
- **Cercle du repas élargi** : 9 paires de voisins étaient à 18-22 px (une largeur de sprite) —
  aucun passage ne subsistait, d'où 12 traversées. Rayon 74 / offset 14, écart minimum **34 px**.
  Ordre de départ calculé (60000 permutations) + waypoints → **0 traversée**.
- **Kino / Reinier** : les dix membres tournent la tête en décalé, sept les **suivent du regard**
  pendant la remontée (`FaceMovingCharacter`).
- **Cadrage d'arrivée** : caméra (256,310) → (264,262). Penticus était coupé de 12 px.
- **Duo au coucher** : il n'était pas dans `sleepOrder` et attendait figé. Il part maintenant
  avec Hyko et Almotz — le partenaire s'étire, le héros s'attarde vers le sommet.
- **Phileas réagit au cauchemar** : il entend, se tourne, traverse le camp (trajet calculé
  sans piétiner les dix dormeurs), s'arrête à 26 px, parle, **reprend son poste**.
- **Poste de garde de Phileas** (240,142) était **sur un obstacle** → (241,166).
- **Hyko ne soigne plus** : il alerte et dégage, Penticus donne la Baie Oran.
- **Ganlon parlait avec la voix de Hyko** : `Teammate2/3` était routé en dur alors que
  `SetParty` échange la cordée. On lit désormais `LTBL(chara).Importance`.

### NOUVEL OUTIL — `tools/audit_detours.py`
Signale les trajectoires qui rallongent sans raison (ratio parcouru/direct), et vérifie sur
la grille d'obstacles si le trajet **direct** était praticable.
Deux garde-fous après faux positifs mesurés : frontières de fonction, et détection de
demi-tour retenue seulement si le trajet rallonge (≥ 5 %).
Référence : **0**. Test négatif vérifié (détour de Coco réintroduit → détecté).

### Références de validation (build K)
lua OK · `audit_bugs` 12 · `verify_legend` vert · `verify_scene_positions` vert ·
`audit_integrite` **925** · `verify_ground_reachability` 27 · `verify_assets_exist` 0 ·
`verify_bg_format` vert · `audit_scene_collisions` 0 · `audit_micro_moves` 0 ·
**`audit_detours` 0** · `verify_scene_fades` 23 (dette).

### À TESTER EN JEU — rien de tout cela ne l'a été
Le jeu **plantait** avant d'atteindre le rêve (crash `hero_dream`) : toute la mise en scène
du rêve est donc écrite mais **jamais vue tourner**.
1. Le jeu atteint-il le rêve sans crasher ?
2. Le fond parallaxe s'affiche-t-il, l'entité clignote-t-elle ?
3. Le retour au camp recrée-t-il les dix PNJ sur leurs couches (`ResumeAfterDream`) ?
4. L'intro ne se rejoue-t-elle pas en boucle ?
5. Plus d'aperçu du Crucible pendant la transition ?
6. Le cercle du repas est-il lisible, sans personne qui se traverse ?

### Manque identifié
Aucun outil ne contrôle la cohérence `index.idx` ↔ `master_zone.json`. C'est précisément
ce qui a produit le crash : à écrire avant la prochaine création de carte.

## Piège moteur : `EntEnabled` d'un spawner (le `true/false` du rêve)

`GroundSpawner.Spawn` — `Ground/Maps/GroundSpawner.cs:78-81` :

```csharp
public virtual GroundChar Spawn(GroundMap currentmap)
{
    if (!EntEnabled)
        return null;
```

Un spawner à `EntEnabled=False` **ne crée jamais son personnage**, et
`SpawnerDoSpawn` renvoie `null` sans lever d'erreur
(`ScriptGround.cs:243-258` : l'exception est attrapée et loguée).

Conséquence en chaîne, constatée sur `hero_dream` :
`COMMON.RespawnAllies` tolère le `nil`, mais
`PartnerEssentials.InitializePartnerSpawn` ne teste que la TAILLE de
l'équipe (`GetPlayerPartyCount() < 2`) avant de faire
`partner.Direction`. L'équipe contient bien 2 membres, la garde est donc
franchie — et on indexe un `nil`. Le moteur avorte la coroutine
(xpcall, `LuaEngine.cs:895`) : pas de plantage visible, mais la scène
s'arrête net et l'écran reste noir, sans sortie.

**Règle** : un spawner `TEAMMATE_*` doit toujours être `EntEnabled=True`.
Pour qu'un personnage n'apparaisse pas dans une scène, utiliser
`GROUND:Hide(chara.EntName)` APRÈS le spawn — c'est ce que fait
`hero_dream.DreamScene`. Référence : `personality_test.rsground`, la carte
modèle, a bien `Teammate1` à `True`.
