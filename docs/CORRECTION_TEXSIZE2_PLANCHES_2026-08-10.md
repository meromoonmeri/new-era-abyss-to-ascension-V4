# CORRECTION — GROUNDS REDIMENSIONNÉS (TexSize 2) : PIXELS NOIRS / TUILES MANQUANTES

**Date : 2026-08-10 — Rapport utilisateur : « corrige les grounds que tu as redimensionnés à la taille
de l'écran, il y a des pixels noirs et des tuiles manquantes ».**

## 1. CAUSE PROUVÉE (code moteur, pas supposée)

Dans RogueEssence/PMDO, le dessin d'un ground se fait par cellules de tuiles à **taille native** :
- `GroundMap.TileSize = TexSize × 8` (pas de la grille d'affichage) ;
- `TileLayer.Draw` → `GraphicsManager.GetTile(frame)` → `texture.Draw(pos)` : la texture est blittée à
  sa **taille de cellule native** (aucun scaling).

Le redimensionnement TexSize 1→2 (commit 673f76b : colline_anciens, foret_givree_oree,
mont_gele_pied) a doublé le PAS de grille (8→16 px) **sans doubler les cellules des planches .tile**
(restées 8×8) : chaque cellule de 16 px n'était couverte qu'à 50 % → **pixels noirs + tuiles
manquantes**, exactement le symptôme signalé.

Vérifié sur les 3 planches : `tileSize=8` dans l'en-tête .tile (Colline_Anciens_Base : 600 cellules
8×8 ; ForetGivreeOree_Base : 1386 ; MontGelePied_Base : 10845).

## 2. CORRECTION APPLIQUÉE

Pour chacune des 3 planches (exclusives à leur ground — vérifié sur les 192 grounds du repo) :
1. Lecture du .tile (format mod : u32 tileSize, u32 tileCount, table (key,offset), PNG par offset,
   alpha **prémultiplié**, déduplication native des cellules identiques) ;
2. **Upscale ×2 de chaque cellule 8×8 → 16×16 en NEAREST** (préserve le pixel art authentique ; copie
   de valeurs, donc le prémultiplié reste correct — pas de ré-échantillonnage bilinéaire) ;
3. Ré-empaquetage avec `tileSize=16` (déduplication conservée : cellules identiques → même offset) ;
4. Mise à jour de `Content/Tile/index.idx` : `tileSize` 8→16 pour les 3 planches (offset 4382995 /
   7041110 / 15780190), les autres 720 planches **intactes** octet pour octet.

## 3. VALIDATION

Rendu PNG (outil `tools/render_ground.py`, même logique de blit que le moteur) avant/après :

| Ground | TexSize | Taille | Avant (noirs purs) | Après (noirs purs / transparents) |
|---|---|---|---|---|
| colline_anciens | 2 | 480×320 | 100 % | 0,00 % / 0,00 % |
| foret_givree_oree | 2 | 528×672 | 100 % | 0,00 % / 0,00 % |
| mont_gele_pied | 2 | 528×576 | 100 % | 0,00 % / 0,00 % |

Contenu vérifié : art réel présent (67/22/23 couleurs uniques, tons attendus : terre pour la colline,
bleu neige pour la forêt givrée et le mont gelé). Les références des grounds (Sheet + TexLoc) n'ont
**pas** changé : seules les cellules ont doublé.

## 4. VÉRIFICATION DE NON-RÉGRESSION

- Les 3 planches sont **exclusives** à leurs grounds (aucun autre ground ne les référence) ;
- Les 18 grounds TexSize 3 utilisent des planches à cellules 24×24 (pas 24 px = 8×3) : corrects,
  non touchés ;
- index.idx : seule la taille de cellule des 3 planches change ; les positions/tailles de toutes les
  autres planches restent strictement identiques.

## 5. LIMITE — VALIDATION RUNTIME REQUISE

Le rendu outil reproduit la logique du moteur, mais **seule une exécution réelle de PMDO** peut
confirmer le rendu en jeu (règle projet : pas de RUNTIME VERIFIED sans exécution). À valider sur
`foret_givree_oree` (entrée Forêt Givrée), puis les deux autres.

## 6. AUTRES GROUNDS < 400 px (non redimensionnés — PENDING décision)

Les autres imports 1:1 PMD Red/Sky restés en TexSize 1 (ex. mont_cendre_pied 360×312,
grotte_lazuli_seuil 360×288, antre_occident 360×336, sanctuaire_voeu 360×336, a02p02 264×192…) :
**pas touchés** — la même méthode (TexSize 1→2 + planches ×2 + obstacles/entités ×2) pourra leur être
appliquée si l'utilisateur confirme le rendu sur les 3 premiers.
