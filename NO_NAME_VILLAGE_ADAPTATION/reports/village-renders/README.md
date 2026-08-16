# Rendus du village NNV — 6 bâtiments PMU

PNG lus depuis les Grounds transformés (`TexSize 1`, 624×624, cellule 8 px).

| Fichier | Contenu |
|---|---|
| `village_spring.png` | printemps, 624×624 |
| `village_summer.png` | été, 624×624 |
| `village_autumn.png` | automne, 624×624 |
| `village_winter.png` | hiver, 624×624 |
| `VILLAGE_ALL_SEASONS.png` | planche comparative |

## Bâtiments

| Parcelle | Asset PMU | Dimensions ×1 | Position | Origine |
|---|---|---:|---|---|
| Sud-ouest | `tiles9_0744` | 122×120 | (50,361) | remplace `objplayerhouse` |
| Nord-ouest | `tiles9_0422` | 116×99 | (102,181) | remplace `objloggerhouse` |
| Est | `tiles9_0434` | 115×98 | (478,215) | remplace `objhunterhouse` |
| Nord | `tiles9_0406` | 126×94 | (176,3) | remplace `objcarpenterhouse` |
| Centre | `tiles9_0361` | 110×98 | (304,272) | **ajout** sur clairière 100 % libre |
| Sud-est | `tiles9_0380` | 125×88 | (432,456) | **ajout** sur clairière 80 % libre |

Six assets **distincts**, tous à l'échelle native ×1, jamais redimensionnés.

## Méthode des deux ajouts

Emplacements choisis par analyse de la grille de collision : seules les zones
réellement dégagées et éloignées d'au moins 170 px des bâtiments existants ont
été retenues. Parcelles réadaptées comme les quatre premières — herbe dégagée
sur l'emprise + marge de 16 px, couloir d'accès sud 48×72, collision dérivée du
masque alpha réel.

Aucun arbre, chemin ou rocher NNV n'a été supprimé pour faire de la place :
les deux maisons occupent des clairières préexistantes.

## Limite importante

Ces bâtiments sont ajoutés **dans `rmvillage`**, la seule zone NNV convertie.
Les autres zones (`rm54`, `rm45`, `rm56`, `rm65`…) ne peuvent pas recevoir de
maisons : elles ne sont pas converties, et `data.win` reste inaccessible
(blocage TLS sur le CDN LFS), tout comme les matrices de tuiles qui ne sont
suivies que sous forme de hashes.

## Statut

`RENDERED_RUNTIME_NOT_RUN`. 4 saisons alignées, sources PMU intactes.
