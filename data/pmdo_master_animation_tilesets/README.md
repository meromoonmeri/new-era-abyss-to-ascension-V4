# PMDO Master Animated Tilesets & Metano-Calibrated Ground

Ce package contient l'ensemble des **tilesets d'animation par page**, isolés en **32-bit Alpha (transparence totale)** et formatés spécifiquement pour la sélection directe au **rectangle rouge** dans le **PMDO Map Editor** (Ground Editor / DevKit).

Il inclut également la version **recalibrée à l'échelle officielle de Metano Town (24px / tuile PMDO)** de la map `MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp` sans altération des pixels d'origine.

---

## 📐 1. Utilisation du Rectangle Rouge dans PMDO Map Editor

Chaque animation est disposée sur **une seule planche horizontale alignée sur une grille stricte** :
- **Frame 0** : Rectangle `[X: 0, Y: 0, W: frame_w, H: frame_h]`
- **Frame 1** : Rectangle `[X: frame_w, Y: 0, W: frame_w, H: frame_h]`
- **Frame 2** : Rectangle `[X: 2*frame_w, Y: 0, W: frame_w, H: frame_h]`

👉 *Dans PMDO Map Editor : ouvrez le tileset, sélectionnez le rectangle rouge sur la Frame 0, puis ajoutez les frames suivantes en avançant d'une largeur de case dans l'onglet Animations.*

---

## 📁 2. Structure des Dossiers (`data/pmdo_master_animation_tilesets/`)

1. **🌸 `01_relict_animated_autotiles_pages/`** (17 Planches d'animation) :
   - Fleurs & végétation champêtre (4 frames)
   - Herbes hautes de donjons sets 4 à 12 (6 frames chacune)
   - Mer & vagues côtières (8 frames)
   - Eaux calmes de donjons sets 0 à 12 (4 frames chacune)
   - Étoiles scintillantes (5 à 7 frames)

2. **⚡ `02_reminiscencia_rgss_animations_pages/`** (49 Planches d'animation) :
   - Foudre céleste, vortex aqueux, geysers de magma, boules de feu, ondes psychiques, portails d'ombre.
   - Toutes les frames alignées en continu sur fond alpha.

3. **🌊 `03_water_and_environmental_animations_pages/`** :
   - Écoulement d'eau Treehouse Village (6 frames synchronisées).

4. **💥 `04_pmu_animated_vfx_pages/`** :
   - Éruptions volcaniques, vagues, fumées, feux et orbes d'énergie.

5. **🗺️ `05_mapacomplete_metano_scaled/`** :
   - `MAPACOMPLETEVIAPIXELLAB_METANO_SCALE.webp` & `.png` ($1624 \times 1314\text{ px}$) :
     - Échelle exacte calquée sur **Metano Town** (tuiles de $24 \times 24\text{ px}$ / cellules de $8 \times 8\text{ px}$).
     - Rendu pixel-art ultra-net sans interpolation floue.
   - `mapacomplete_metano_Base.tile` : binaire PMDO prêt à l'emploi.
   - `mapacomplete_metano.rsground` : structure de données de sol PMDO avec grille d'obstacles.

---

## 📋 Manifeste & Showcase
- **Manifeste JSON** : `manifest_master_animations.json` (83 pages d'animation indexées).
- **Grand Showcase** : `showcase_master_animation_tilesets.png`.
