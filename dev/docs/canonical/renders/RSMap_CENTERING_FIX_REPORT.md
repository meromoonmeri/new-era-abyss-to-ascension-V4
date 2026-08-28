# RSMap CENTERING FIX REPORT — arènes fixes ROM (5 fichiers)

## Diagnostic (obligatoire avant toute modification)

| FILE | CANVAS (px) | LOGICAL MAP | MAIN AREA BOUNDS (floor, tiles) | CANVAS CENTER | MAIN AREA CENTER | DELTA X/Y (tiles) |
|---|---|---|---|---|---|---|
| dark_ice_mountain_pinnacle_map | 384×288 | 16×12 | x[1,9] y[0,6] | (7.5,5.5) | (5.0,3.0) | −2.5/−2.5 |
| star_cave_pit_map | 384×336 | 16×14 | x[1,9] y[1,9] | (7.5,6.5) | (5.0,5.0) | −2.5/−1.5 |
| temporal_pinnacle_arena | 432×456 | 18×19 | x[1,11] y[1,13] | (8.5,9.0) | (6.0,7.0) | −2.5/−2.0 |
| underground_lake_arena | 480×480 | 20×20 | x[2,12] y[2,14] | (9.5,9.5) | (7.0,8.0) | −2.5/−1.5 |
| vast_ice_mountain_pinnacle_map | 384×360 | 16×15 | x[3,8] y[2,8] | (7.5,7.0) | (5.5,5.0) | −2.0/−2.0 |

## ROOT CAUSE (contre-épreuve ROM, cellule par cellule)

Comparaison de la bbox `floor` de chaque rsmap avec la bbox `FLOOR/SPAWN`
du `fixed.bin` ROM Sky EU (ff35/ff31/ff10/ff5/ff36) :

    dark_ice_mountain_pinnacle_map : ROM 16×12 bbox (1,0,9,6)  == PMDO — IDENTIQUE
    star_cave_pit_map              : ROM 16×14 bbox (1,1,9,9)  == PMDO — IDENTIQUE
    temporal_pinnacle_arena        : ROM 18×19 bbox (1,1,11,13)== PMDO — IDENTIQUE
    underground_lake_arena         : ROM 20×20 bbox (2,2,12,14)== PMDO — IDENTIQUE
    vast_ice_mountain_pinnacle_map : ROM 16×15 bbox (3,2,8,8)  == PMDO — IDENTIQUE

**La géométrie est donc CANONIQUE : l'asymétrie de la zone jouable dans la
grille vient de la ROM elle-même** (les salles fixes EoS ne sont pas centrées
dans leur grille fixed.bin ; le remplissage droite/bas est du mur/secondaire
ROM). Le renderer d'audit `render_rsmap_autotile.py` dessinait la GRILLE
COMPLÈTE (canvas = W×H tuiles), sans transform caméra — le "décalage" perçu
est l'absence de caméra dans l'outil d'audit, PAS un décalage de données ni
du renderer moteur.

En jeu, RogueEssence (`BaseDungeonScene.UpdateCam`) centre le viewport
320×240 sur le leader (position `EntryPoint` = `LEADER_SPAWN` ROM), avec
clamp aux bords : la zone jouable est correctement cadrée au runtime.

## FIX LOCATION

`dev/tools/render_rsmap_autotile.py` : ajout d'une sortie `--camera-view`
reproduisant EXACTEMENT la transform caméra moteur (viewport 320×240 centré
EntryPoint, clamp bords, centrage si carte < viewport, coordonnées entières,
aucun filtrage/scaling). Le rendu pleine grille est conservé (référence
d'audit). **Aucune donnée `.rsmap` modifiée** : STRUCTURAL_DIFF = 0 (tile
IDs, positions, dimensions, textures, UV, autotiles, layers, collisions,
objets, EntryPoints inchangés — vérifié par `git diff` vide sur Data/Map).

## Validation (vue caméra, référentiel = leader, tolérance = clamp bord)

| FILE | OLD delta (grille brute, tiles) | NEW delta leader↔centre viewport (px) | Explication du résidu | STATUS |
|---|---|---|---|---|
| dark_ice_mountain_pinnacle_map | −2.5/−2.5 | −52/−36 | clamp: carte 384×288, leader près du coin — comportement moteur exact | PASS |
| star_cave_pit_map | −2.5/−1.5 | −28/0 | clamp X (leader à 132 < 160) | PASS |
| temporal_pinnacle_arena | −2.5/−2.0 | 0/0 | plein centrage | PASS |
| underground_lake_arena | −2.5/−1.5 | 0/−12 | clamp Y | PASS |
| vast_ice_mountain_pinnacle_map | −2.0/−2.0 | −28/0 | clamp X | PASS |

Les résidus non nuls sont le clamp canonique du moteur (identique en jeu) :
quand le leader est près d'un bord, la caméra s'arrête au bord au lieu de
montrer du hors-carte. `new_delta ≈ 0` partout où le clamp ne s'applique pas.

## Régression

- Rendus pleine grille des 5 rsmaps régénérés : dimensions et contenus
  identiques (aucune donnée modifiée).
- Rendus non concernés vérifiés (magma_pit_groudon, sky_summit_rayquaza,
  mt_blaze_summit…) : inchangés.
- PIXEL CHANGES : uniquement les nouveaux fichiers `camera_*.png` (vue
  caméra) ; les `rsmap_*.png` pleine grille restent la référence d'audit.

## Conclusion

- ROOT CAUSE : outil d'audit sans transform caméra ; données canoniques
  ROM confirmées identiques cellule par cellule.
- OLD OFFSET : bbox jouable asymétrique dans la grille (héritée de la ROM).
- NEW OFFSET : caméra moteur reproduite ; delta 0 hors clamp canonique.
- STRUCTURAL CHANGES : 0.
- STATUS GLOBAL : **PASS 5/5**.
