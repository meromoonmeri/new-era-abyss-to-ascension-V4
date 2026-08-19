# Structure fournie par le propriétaire — mesure et aperçu

**Étape : `PREVIEW_ONLY`.** Rien n'est écrit sous `Data/`. Aucun `.rsground`,
aucune planche `.tile`, aucune `Decoration` ajoutée. Le choix final t'appartient.

Source : `ASSSET.png`, poussé sur la branche (`1e859d4d`),
sha256 `be2d42…` (voir `owner-structure.json`).

---

## 1. Ce que l'asset est réellement

Il **ressemble** à du pixel-art. Il n'en est pas. Mesuré, pas supposé :

| Mesure | Valeur | Ce que ça implique |
|---|---:|---|
| Couleurs distinctes | **224 057** | du pixel-art en a quelques dizaines |
| Pixels à alpha 255 | **0** | *aucun* pixel pleinement opaque, alpha max 254 |
| Halo alpha 1–8 | **27 889 px** | résidu de compression (noir/vert/rouge purs), retiré |
| Épaisseur de contour | **5 à 12 px** | un contour natif est d'épaisseur constante |
| Variance intra-bloc | croissante dès f=2 | **aucune grille de pixels détectable** |

Conséquence directe, et elle est importante : **il n'existe pas de « taille
native » à retrouver par division entière.** Toute réduction est un *rendu*,
pas une *restitution*. Je le dis au lieu de choisir un facteur en silence.

Le halo transparent a été retiré avant toute mesure : le garder décalait la
bbox de 6 px et aurait sali les bords en jeu.

**Taille du sujet nettoyé : 1369 × 971 px** — soit **85,6 × 60,7 Pokémon**.
À ×1, c'est **12 fois trop large** pour une maison PMDO. Intégration à ×1 refusée.

## 2. Référentiel appliqué

Celui déjà établi et versionné dans `reports/pmdo-scale-reference/` :

```
unité monde PMDO       = 8 px
Pokémon                = 16 px = 2×2 unités monde
maison PMDO médiane    = 114 px de large = 7,1 Pokémon
structures PMU confirmées = 40 à 212 px, médiane 98 px
```

## 3. Les quatre candidats

| Largeur | Taille | En Pokémon | vs maison PMDO médiane | Dans la plage PMU |
|---:|---:|---:|---:|:---:|
| **114 px** | 114×81 | 7,1 × 5,1 | ×1,00 | ✅ |
| **144 px** | 144×102 | 9,0 × 6,4 | ×1,26 | ✅ |
| **176 px** | 176×125 | 11,0 × 7,8 | ×1,54 | ✅ |
| **212 px** | 212×150 | 13,3 × 9,4 | ×1,86 | ✅ (borne haute) |

Aucun diviseur n'est entier — conséquence directe du point 1, pas une négligence.

**Rééchantillonnage NEAREST exclusivement**, conformément à la règle du projet.
Les fichiers `CONTROL_ONLY_*_LANCZOS.png` existent **uniquement pour montrer ce
que NEAREST coûte** sur une source non-pixel-art. Ils ne sont pas proposés à
l'intégration et ne le seront pas.

## 4. Aperçu in situ, aux 4 saisons

`IN_SITU_ALL_SEASONS.png` — les quatre candidats posés sur le terrain
`rmvillage` réel, à côté des **six maisons PMU déjà intégrées**, dans les
quatre saisons.

L'emplacement de chaque aperçu est choisi par intersection de rectangles contre
les six bâtiments existants, pas à l'œil : `overlaps_existing_building: false`
sur les quatre.

Le terrain vient des PNG de `reports/season-coherence/`, eux-mêmes rendus depuis
les Grounds matérialisés — pas d'une composition à la volée.

### Ce que l'image montre, après l'avoir regardée

À **114 px** la structure est plus petite que les maisons PMU voisines : elle se
lit comme une cabane secondaire. À **212 px** elle domine le four à pain et le
sanctuaire, ce qui déséquilibre le village. **À 176 px elle a la même présence
que les maisons PMU déjà posées** — c'est le seul candidat qui s'intègre sans
hiérarchiser le village en sa faveur.

C'est une lecture visuelle, elle t'est soumise, elle ne se substitue pas à ton
choix.

## 5. Ce qui n'est pas prouvé

- La **collision** de cette structure n'existe pas : aucune cellule 8 px n'a été
  posée. Un bâtiment traversable est un défaut, pas un détail.
- L'**intérieur** n'existe pas : pas de Ground d'intérieur, pas de porte câblée.
- Le **runtime PMDO 0.8.12** reste `NOT_CERTIFIED` (ni dotnet ni mono
  disponibles ici).
- Aucun choix de parcelle n'a été fait : la position dans l'aperçu est un
  emplacement libre quelconque, pas une proposition d'urbanisme.
