# Constitution de continuité — trente ans après Rescue Team / Explorers of Sky

## Statut

Document autoritatif. En cas de contradiction, il prime sur les anciens audits, inventaires et plans qui classent les Aegis Cave au chapitre 7 ou imposent un renommage original aux lieux canoniques.

## Canon du projet

*New Era: Abyss to Ascension* est une suite située dans le même monde que *Pokémon Mystery Dungeon: Red/Blue Rescue Team* et *Explorers of Sky*, environ trente ans plus tard.

Les imports Sky/Red sont les fondations géographiques du monde : géométrie, collisions et positions structurantes sont conservées en 1:1 avant une retouche artistique manuelle montrant le temps écoulé.

## Verrou chronologique du chapitre 5

`cloven_ruins` / **Aegis Cave**, héritières d’**Aegis Cave**, constituent le **donjon final du chapitre 5**.

Chaîne canonique :

`vast_steppe` → `searing_tunnel` → `mount_windswept` → camp `cloven_ruins_entrance` → secteurs Aegis/Regi → Puits → `sanctuaire_titans` / Regigigas → révélation → `FinishedExpedition` → chapitre 6.

Le code actuel matérialise déjà cette intention :

- scripts d’entrée `cloven_ruins_entrance_ch_5.lua` ;
- drapeaux de défaite et victoire sous `SV.Chapter5` dans la zone ;
- sortie du Mont Venteux vers le camp des Ruines ;
- `RuinesRenforts` pose `RuinsExpeditionDone` et `FinishedExpedition` ;
- `ReplayEnding.cloven_ruins` lit `SV.Chapter5.SawAnimaCoreCorruption`.

Toute mention « cloven_ruins = chapitre 7 » est une dette documentaire ou un vestige de nommage interne, pas le canon.

Le chapitre 7 doit recevoir son propre rôle narratif ; il ne peut pas revendiquer à nouveau les Ruines comme donjon principal. Les champs historiques `SV.Chapter7.*Ruins*` ne doivent plus servir au flux principal et seront migrés uniquement avec une stratégie de compatibilité de sauvegarde.

## Deux catégories de lieux

### Lieux hérités

- nom canonique conservé ;
- provenance et version documentées ;
- fondation spatiale 1:1 ;
- vieillissement visible ajouté manuellement ;
- casting New Era par défaut ;
- personnage historique uniquement sur décision explicite.

### Lieux nouveaux

- nom original selon la convention du projet ;
- aucune usurpation d’un nom canonique pour créer artificiellement de la reconnaissance.

## Lieux prioritaires

- Treasure Town ;
- ville/camp de l’Équipe de Secours ;
- Aegis Cave / Aegis Cave ;
- Sky Tower ;
- Mt. Thunder ;
- Mt. Blaze ;
- Mt. Freeze ;
- Temporal Tower ;
- Spacial Rift ;
- Buried Relic ;
- autres réserves documentées dans `pmdred_extraction_tracabilite.md`.

## Statut des héros et personnages historiques

**Arbitrage encore ouvert — ne pas improviser dans un script.** Jusqu’à décision de l’auteur :

- aucune scène ne doit affirmer contradictoirement qu’un héros historique est mort, disparu, retraité et encore actif ;
- les mentions restent légendaires, indirectes ou explicitement incertaines ;
- une future décision unique devra préciser le statut des équipes de Rescue Team et Explorers, puis être propagée dans tous les dialogues.

## Définition de « lieu terminé »

Un lieu hérité n’est terminé que si : nom, provenance, géométrie/collision, marques des trente ans, casting, statut des figures historiques, statut du légendaire et connexions géographiques sont tous documentés et vérifiés.
