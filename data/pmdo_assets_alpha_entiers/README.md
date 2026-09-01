# Bibliothèque Complète d'Assets Entiers en Alpha Isolate (PMDO / PMU / EoS)

Cette bibliothèque contient l'ensemble des structures, bâtiments, échoppes, panneaux, objets et animations **entièrement préservés en sprites complets et autonomes (zéro découpage en tuiles 8x8 ou 24x24)**, avec un **fond transparent RGBA 32-bit sans perte**.

---

## 📂 Organisation des Dossiers (`data/pmdo_assets_alpha_entiers/`)

### 🚩 1. `01_panneaux_et_missions/` (Panneaux & Tableaux de Guilde)
- `grand_panneau_carrefour_4_directions.png` ($64 \times 64\text{ px}$) : Panneau de carrefour entier avec ses 4 flèches de direction.
- `tableau_affichage_missions_guilde.png` ($72 \times 72\text{ px}$) : Grand tableau des avis de recherche et missions d'exploration.
- `panneau_bois_simple.png` ($40 \times 40\text{ px}$) : Panneau indicateur en bois simple.

---

### 🏪 2. `02_boutiques_et_marche/` (Échoppes, Boutiques & Mobilier Urbain)
- `boutique_kecleon_vert_jour.png` ($112 \times 120\text{ px}$) : Stand Kecleon vert complet avec auvent rayé et présentoir.
- `boutique_kecleon_violet_nuit.png` ($112 \times 120\text{ px}$) : Stand Kecleon violet (Variante Nuit).
- `grand_cafe_spinda_terrasse_jour.png` ($259 \times 109\text{ px}$) : Bâtiment complet du Café Spinda avec terrasse.
- `grand_cafe_spinda_terrasse_nuit.png` ($259 \times 109\text{ px}$) : Café Spinda illuminé de nuit.
- `eventaire_marche_bois.png` ($72 \times 60\text{ px}$) : Stand de marché en bois sculpté.
- `comptoir_marchand_bas.png` ($56 \times 20\text{ px}$) : Comptoir d'accueil bas.
- `reserve_coffre_kangourex.png` ($32 \times 32\text{ px}$) : Coffre fort de stockage Kangourex.
- `panier_baies_rouges.png` & `panier_baies_bleues.png` ($24 \times 24\text{ px}$) : Paniers d'étals remplis de baies.
- `jarre_terre_cuite.png` ($16 \times 16\text{ px}$) : Poteries et vases de marché.
- `cloture_bois_palissade.png` ($48 \times 48\text{ px}$) : Section de barrière en piquets de bois.
- `table_souche_bois.png` & `chaise_souche_bois.png` : Mobilier sculpté dans des troncs d'arbres.

---

### ⛺ 3. `03_batiments_et_tentes/` (Maisons, Tentes & PMUniverse)
- `tente_expedition_bleue.png` ($80 \times 80\text{ px}$) : Tente d'expédition ouverte.
- `grande_tente_campement_unie.png` ($96 \times 96\text{ px}$) : Grande tente de campement fermée.
- `tente_plage_cotiere.png` ($50 \times 76\text{ px}$) : Abri côtier en toile.
- `maison_standard_bourg_tresor.png` ($112 \times 112\text{ px}$) : Maison urbaine classique de Bourg-Trésor.
- `chaumiere_feuilles_foret_1.png` & `_2.png` ($87 \times 76\text{ px}$ & $88 \times 97\text{ px}$) : Chaumières à toiture végétale.
- `grand_bazar_guilde.png` ($190 \times 156\text{ px}$) : Grand magasin commercial à double auvent.
- `maison_style_feu.png`, `_roche.png`, `_normal.png` : Maisons thématiques de Metano Town.
- **`pmuniverse_143_batiments/`** : Les **143 bâtiments entiers** extraits des archives PMUniverse ($46\text{ à }170\text{ px}$).

---

### 🌿 4. `04_vegetation_et_nature/` (Décors Naturels & Extérieur)
- `stele_pierre_kangourex.png` ($32 \times 32\text{ px}$) : Statue de pierre Kangourex.
- `porte_guilde_fermee.png` ($64 \times 64\text{ px}$) : Grande double porte d'entrée de la Guilde.
- `couchette_paille_dortoir.png` ($40 \times 40\text{ px}$) : Lit de paille de base.
- `rocher_riviere_rond.png` & `_diamant.png` ($24 \times 24\text{ px}$) : Galets et pierres de cours d'eau.
- `noigrume_geant.png` ($16 \times 16\text{ px}$) : Noigrume mûr pour cueillette.
- `sac_provisions_herbe.png`, `panier_gros_vivres.png`, `tablette_zarbi_mystere.png`.

---

### 🎬 5. `05_objets_animes_frames_completes/` (Objets Animés Frame par Frame)
*Chaque sous-dossier contient toutes les frames entières isolées (`frame_0.png`, `frame_1.png`...), la bande de sprite (`*_animation_strip.png`) et le fichier `.dir` PMDO :*

1. **`feu_de_camp_bivouac/`** (4 frames entières, $36 \times 36\text{ px}$) : Boucle de flammes de campement.
2. **`moulin_a_vent_ailes_tournantes/`** (4 frames entières, $64 \times 72\text{ px}$) : Rotation complète des pales du moulin.
3. **`puits_village_manivelle_et_eau/`** (4 frames entières, $72 \times 56\text{ px}$) : Puits oscillant avec manivelle et niveau d'eau.
4. **`boite_tresor_scintillante/`** (6 frames entières, $24 \times 24\text{ px}$) : Boîte mystère dorée scintillante.
5. **`coeur_energie_animique/`** (36 frames entières, $154 \times 121\text{ px}$) : Grand cœur magique pulsant.
6. **`racines_telluriques_lueur/`** (16 frames entières, $154 \times 121\text{ px}$) : Racines luminescentes.
7. **`journal_bleu_ouverture/` & `_fermeture/`** (4 frames entières, $24 \times 24\text{ px}$).
8. **`journal_rouge_ouverture/` & `_fermeture/`** (4 frames entières, $24 \times 24\text{ px}$).
9. **`grande_cascade_de_lave/` & `petite_cascade_de_lave/`** (64 frames entières, $48 \times 48\text{ px}$).
10. **`bassin_lave_bouillonnante/`** (66 frames entières, $48 \times 24\text{ px}$).
11. **Effets d'environnement PMDO** : Fleurs animées (`si_flower_1.5`, `si_flower_2.5`), bulles (`ps_bubble.7`), vagues (`ec_wave_2.4`), fumée (`c_smoke`), braises (`sp_fire`).

---

### 🪑 6. `06_accessoires_et_decor_interieur/` (Décors & Mobilier PMU)
- **83 objets complets** : Vases de fleurs, champignons rouges, tatamis, étagères murales, livres ouverts/fermés, commodes en bois, balances, lances, boucliers, vaisselle, lampes à huile, fioles.

---

## 📋 Manifeste & Showcase
- **Manifeste JSON** : `manifest_assets_entiers.json` (Référençant les 338 assets entiers avec leurs dimensions réelles).
- **Showcase Visuel** : `showcase_assets_entiers.png` (Planche de prévisualisation directe).
