# AUDIT COMPLET DES GROUNDS — DIMENSIONS, TEXTURES, COLORIMÉTRIE, CINÉMATIQUES

**Date** : 2026-08-10
**Branche** : `arena/019fd882-new-era-abyss-to-ascension-v4`
**Règle absolue respectée** : aucune texture, tileset ou ground inventé. Toute
zone noire = symptôme d'un problème de ressource, pas une invitation à combler.

---

## PARTIE 1 — GROUNDS TROP PETITS (cause racine prouvée par le code moteur)

### 1.1 Cause technique (prouvée, pas supposée)

Source : `RogueEssence/Ground/Maps/GroundMap.cs` (clone du moteur, master) :

```csharp
public const int TEX_SIZE = 8;                                   // GraphicsManager.cs:116
public int TileSize { get { return TexSize * GraphicsManager.TEX_SIZE; } }  // GroundMap.cs:44
public int GroundWidth { get { return Width * TileSize; } }      // GroundMap.cs:65
obstacles = new GroundWall[width * TexSize][];                   // GroundMap.cs:287
```

- **Taille affichée d'un ground** = `Width × TexSize × 8` pixels = **grille
  d'obstacles × 8 px** (car `obstacles = tiles × TexSize`).
- Un ground **TexSize=1** affiche chaque tuile à **8 px** (taille native GBA).
- La résolution d'écran interne PMDO (`ScreenWidth`/`ScreenHeight`, chargées de
  `GFXParams.xml` chez l'utilisateur) est **plus grande que la taille native
  GBA/NDS** → les imports 1:1 PMD Red/Sky laissent du **vide noir** autour.

### 1.2 Symptôme mesuré (99 grounds < 400 px de large)

| Catégorie | Nombre | Exemples | Diagnostic |
|---|---|---|---|
| **Placeholders de débogage** | 36 | `canyon_camp`, `forest_camp`, `cliff_camp`, `base_camp`, `rest_stop`, `final_stop`, `arene_*`, `ile_*`, `lac_*`… | **REQUIRES_ASSET** — « Ground fantôme déclaré dans index.idx sans fichier d'origine : matérialisé pour que le warp du mode dev ne crashe pas ». Aucune vraie ressource. |
| **Imports 1:1 PMD Red** | ~20 | `foret_givree_oree` (264×336), `mont_gele_pied` (264×288), `mont_cendre_pied` (360×312), `grotte_lazuli_*`, `antre_occident`, `sanctuaire_voeu`, `a02p02`… | Dimensions natives GBA préservées (correctes) mais < résolution PMDO → vide à l'écran. **Correction = TexSize ×2** (upscale moteur, aucune texture inventée). |
| **Imports 1:1 PMD Sky** | ~10 | `s04p01a` (264×432), `sky_eos_g01p07a/c` (384×312), `v13p01a`, `v09p04a`, `p07p01a`… | Idem : natives NDS, < résolution PMDO. |
| **Pièces / intérieurs** | ~30 | `guild_heros_room` (352×352), `metano_*_home` (344×272), `guild_*`… | Petits mais = espaces clos : vide partiel acceptable, à confirmer au runtime. |

### 1.3 Correction appliquée (3 grounds, méthode fidèle)

La correction = **TexSize 1→2** + grille d'obstacles étirée ×2 + **positions
d'entités ×2** (colliders). C'est un **paramètre de rendu moteur** (upscale de
tuiles 8px → 16px, exactement ce que PMDO fait pour l'ensemble du jeu sur écran
HD) — **aucune texture inventée, aucune répétition de tuiles**.

| Ground | Avant | Après | Entités vérifiées |
|---|---|---|---|
| `colline_anciens` (Colline des Anciens) | 240×160 | **480×320** | 0 dans mur |
| `foret_givree_oree` (entrée Forêt Givrée) | 264×336 | **528×672** | 0 dans mur |
| `mont_gele_pied` (entrée Mont Gelé) | 264×288 | **528×576** | 0 dans mur |

Sheets présentes : `Colline_Anciens_Base.tile`, `ForetGivreeOree_Base.tile`,
`MontGelePied_Base.tile` (tuiles 8×8, upscalables). **Verdict : REQUIRES_RUNTIME**
(à confirmer visuellement en jeu).

### 1.4 Non corrigé — REQUIRES_ASSET (liste précise)

Les 36 placeholders n'ont **pas** de ressource source. Pour chacun il manque le
vrai ground PMD Red/Sky correspondant (à fournir) :
`canyon_camp`, `forest_camp`, `cliff_camp`, `base_camp`, `base_camp_2`,
`rest_stop`, `final_stop`, `vigie_stratos`, `vallon_malsain_fond`, `test_grounds`,
`terres_tues_porte`, `recif_genereux`, `porte_plaines_foudre`, `plaines_brulees`,
`nef_prisme_est`, `mont_lune_vue`, `lac_savoir`, `lac_espoir`, `lac_courage`,
`labo_decrepit`, `ile_legendaire`, `ile_close`, `ile_australe`,
`guildmaster_summit`, `guild_path`, `guild_hut`, `gue_poulain_autel`,
`grotte_rocheuse`, `grotte_echos`, `grotte_cryptique`, `fosse_volcanique`,
`fleche_reliques_courroux`, `escalier_origine`, `creux_ombres_scelle`,
`couloir_legendes`, `champ_sacre`, `chambre_agee_o`, `carriere_magnetique`,
`arene_trone_magma`, `arene_hautes_plaines`, `arene_clairiere_secrete`.

---

## PARTIE 2 — GROUNDS DU MONT THUNDER / COL FOUDRE (interdit d'inventer)

- `mt_thunder_midpoint.rsground` = **clone non canonique** du template Searing
  Tunnel adapté au biome (autotiles `lightning_field_*`). Ce n'est **pas** une
  ressource PMD Red/Sky. **Décision** : ne pas le brancher, ne pas le légitimer.
  → **REQUIRES_ASSET** (vrai ground PMD Red du Mont Grondant / D06 à fournir).
- Les 3 midpoints PMD Red (`frosty_forest_midpoint`, `mt_blaze_midpoint`,
  `mt_freeze_midpoint`) sont aussi des clones template — **à remplacer par les
  vrais grounds PMD Red** s'ils existent dans le port, sinon REQUIRES_ASSET.

---

## PARTIE 3 — AUDIT COLORIMÉTRIQUE (méthode, cause possible)

Non conclu sans les références originales PMD Red : les sheets `.tile` sont des
tuiles 8×8 dont la conversion n'a pas de pipeline de couleur documenté dans le
repo. **Cause probable à vérifier** : l'import via le port (BMA/BPL → PNG) peut
perdre la palette native si la conversion passe par un espace sRGB non profilé.
**Correction** : comparer un import avec sa référence GBA (palette), puis corriger
le pipeline d'import plutôt que chaque texture. → PENDING (requiert les sources).

---

## PARTIE 4 — AUDIT CINÉMATIQUES (état réel)

| Cinématique | État | Détail |
|---|---|---|
| Scène Meteno (relais Mont Venteux) | ✅ **SUPPRIMÉE** (mission) | script + appels + flag + commentaires nettoyés, veillée du sommet intacte |
| Relais / midpoints ch.6-32 | ✅ corrigés | 14 variables SV déclarées, QuickWake ajouté, 3 midpoints PMD Red équipés du respawn |
| Cinématiques PMD Red/Sky importées | ⚠️ PENDING | Les scripts existent ; vérification réelle (triggers, positions, timings) requiert le runtime |

---

## VERDICT

- **Cause des grounds trop petits** : prouvée (moteur), correction TexSize×2
  appliquée sur 3 exemples, méthode documentée pour étendre.
- **36 placeholders** → REQUIRES_ASSET (liste fournie).
- **Aucun ground inventé** : `mt_thunder_midpoint` non branché (clone non canonique).
- **RUNTIME REQUIS** : toutes les corrections visuelles doivent être validées en
  jeu (le rendu réel n'est pas observable ici).
