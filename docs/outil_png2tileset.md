# `png2tileset.py` — convertir un PNG en tileset RogueEssence/PMDO

> **Rien n'a été testé en jeu.** Tout ce qui suit est vérifié par lecture du
> moteur et par mesure sur les fichiers du dépôt.

Un PNG (illustration d'arène, planche de tuiles dessinée à la main, capture)
devient une planche `.tile` indexée, et si on veut une carte de combat
`.rsmap` ou un décor `.rsground` prêts à charger.

---

## Commandes

```bash
# 1. Inspecter sans rien écrire : découpage, résidu, taux de doublons
python3 tools/png2tileset.py decoupe image.png --tile 24

# 2. Créer seulement la planche .tile (+ réindexation)
python3 tools/png2tileset.py importer image.png Nom_Planche --tile 24 --apply

# 3. Créer une CARTE DE COMBAT complète (.rsmap)
python3 tools/png2tileset.py carte image.png Nom_Planche sortie.rsmap \
        --tile 24 --sol 560,700 --apply

# 4. Créer un DÉCOR (.rsground)
python3 tools/png2tileset.py ground image.png Nom_Planche sortie.rsground \
        --grid 8 --sol 560,700 --apply

# 5. Relire une planche existante et en sortir un aperçu
python3 tools/png2tileset.py verifier MtBristlePeak
```

| option | rôle |
|---|---|
| `--tile N` | taille de tuile (**24** = donjon, valeur de `GraphicsManager.TileSize`) |
| `--grid N` | pas de grille d'un ground (**8** × `TexSize`) |
| `--align X,Y` | décale le découpage, pour choisir où tombe la coupe |
| `--seuil N` | % d'opacité minimum pour retenir une tuile (défaut 1) |
| `--sol X,Y` | **pixel échantillon du terrain marchable** — voir plus bas |
| `--apply` | écrit réellement ; sans lui, simple essai à blanc |

---

## Les trois pièges du format, et comment l'outil les traite

### 1. L'alpha est **prémultiplié** — le piège principal

`BaseSheet.ImportTex` (l.188-192) applique `premultiply(tex, false)` à
l'import, et `BaseSheet.Load` (l.63-73) **ne l'applique pas**. Les octets
stockés dans un `.tile` sont donc déjà prémultipliés.

Mesure de confirmation sur `Metano_Town_Objects` : **45 760 pixels d'alpha 0
testés, 0 avec un RGB non nul**, et tous les pixels d'alpha partiel
respectent `RGB ≤ A`. C'est la signature du prémultiplié.

Écrire un PNG standard donnerait des **halos clairs** sur tous les bords
transparents. L'outil prémultiplie à l'écriture et dé-prémultiplie à la
lecture.

**Un bug attrapé par le test de non-régression.** La dé-prémultiplication
n'est pas réversible sans perte : elle divise par l'alpha, et sur un alpha
faible l'erreur d'arrondi explose. Cas réel, pixel (1,2) de la tuile
(161,2) de `Metano_Town_Objects` :

```
stocké (191,127,63, a=4)  →  droit (255,255,255)  [saturé]
                          →  restocké (4,4,3)     [127/255 d'écart]
```

D'où un **mode brut** : `lire_planche(nom, brut=True)` +
`ecrire_planche(..., deja_premultiplie=True)` copient les octets d'origine
sans conversion. C'est ce qu'il faut pour **copier ou ré-empaqueter** une
planche existante.

### 2. La déduplication est **native au format**

Les tuiles identiques partagent le même offset. Ce n'est pas une
optimisation ajoutée : `Metano_Town_Base` déclare 35 646 entrées pour bien
moins d'images réelles. L'outil déduplique donc à l'écriture.

### 3. L'index conditionne l'affichage

`GraphicsManager.GetTile` lit la position dans `Content/Tile/index.idx`.
Une planche absente de l'index renvoie 0 → **tuile d'erreur affichée**.
L'outil appelle donc `rebuild_tile_index.py` après chaque écriture.

---

## Détection sol / mur

**Sans `--sol`** : heuristique de luminance, les tuiles les plus claires
sont supposées marchables. Rapide, mais elle se trompe dès qu'il y a un
ciel clair. Sur l'arène de Tornadus elle classait **le ciel et les nuages
en terrain marchable** (ciel lum 225 > plateforme lum 138).

**Avec `--sol X,Y`** : on échantillonne la tuile contenant ce pixel et on
retient celles de même profil — luminance **et saturation**. C'est la
saturation qui tranche proprement :

| zone | luminance | saturation |
|---|---|---|
| plateforme (sol) | 138 | **10** |
| corniche (sol) | 137 | **10** |
| ciel / nuage | 225 | **44** |
| roche sombre (mur) | 68 | 17 |

Résultat sur l'arène de Tornadus : le ciel est exclu, la plateforme
centrale et les corniches sont retenues.

⚠️ Cette détection reste une **aide au dégrossissage**, pas une vérité.
Un terrain de combat doit toujours être revérifié (connectivité, positions
des combattants) avant usage — c'est le rôle des outils de validation
existants.

---

## Contrôles automatiques

L'outil refuse ou signale :

- un PNG qui **n'est pas un multiple** de la taille de tuile — il annonce
  le résidu en pixels et prévient qu'il sera ignoré (sur l'image de
  Tornadus : `reste 23x23 px`) ;
- une carte de **combat** demandée en tuiles ≠ 24 px (`--force` pour
  passer outre) ;
- un pas de grille de ground qui n'est pas un multiple de 8.

Après chaque écriture, il **relit la planche** et la compare à la source,
puis affiche `VERIFICATION : OK` ou `ECHEC`.

---

## Résultats mesurés

**Non-régression** — relire une planche du jeu, la réécrire, la relire :

| planche | tuiles | taille | écart |
|---|---|---|---|
| `MtBristlePeak` | 7 047 | 8 px | **0/255** |
| `Metano_Town_Objects` | 16 766 | 8 px | **0/255** |
| `MountainPeak` | 572 | 24 px | **0/255** |
| `Metano_Town_Base` | 35 646 | 8 px | **0/255** |

**Bout en bout** — l'image de l'arène de Tornadus (1128×1344, recadrée au
multiple de 24) convertie en `.rsmap`, puis rendue et comparée au PNG
source :

```
pixels différents : 0 / 1 516 032
écart max : 0
```

47 × 56 = 2 632 tuiles, dont 2 632 uniques (aucun doublon dans cette
illustration).

L'index régénéré après nettoyage est **identique à l'original** ; les
baselines du dépôt sont inchangées (**12 / 849**).
