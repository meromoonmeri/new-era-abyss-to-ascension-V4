# Metano Town — Brief Pixel Artist pour ville similaire

**Branche** : `arena/01a0357e-new-era-abyss-to-ascension-v4`
**Date** : 2026-08-29
**But** : Créer une ville Pokémon Mystery Dungeon dans le style visuel exact de **Metano Town** (ville canonique du mod New Era)

---

## 1. Résumé visuel de Metano Town

- **Dimensions** : 189×189 tuiles = **1512×1512 pixels** (15.8 écrans PMD de large)
- **Style artistique** : PMD Red/Sky Rescue Team, **pixel art 8 px/tuile**, palette diurne lumineuse
- **Ambiance** : Bourg central entouré de forêt, traversé par une rivière, place pavée centrale
- **11 layers** : sol + cliffs + objects + animations (eau, drapeau, fumée) + variantes jour/nuit

## 2. Carte visuelle de Metano Town (1512×1512 px)

📁 Le rendu PNG complet est disponible dans :
- `.runtime-cache/metano_renders/metano_town.png` (1876 KB, 1512×1512 px)
- `.runtime-cache/metano_renders/metano_town_nuit.png` (1948 KB, version nuit)
- `.runtime-cache/metano_renders/metano_altere_transition.png` (Metano Outskirts, transition sud)
- `.runtime-cache/metano_renders/metanol_cafe.png` (café, 456×320 px)
- `.runtime-cache/metano_renders/metanol_cave.png` (grotte, 416×368 px)
- `.runtime-cache/metano_renders/metanol_inn.png` (auberge, 448×352 px)
- `.runtime-cache/metano_renders/metanol_fire_home.png` / `_water_home.png` / `_grass_home.png` / `_electric_home.png` / `_rock_home.png` / `_normal_home.png` (chaque maison typée, ~272-368 px)
- `.runtime-cache/metano_renders/treasure_spinda_cafe.png` (café alternatif, 456×696 px)

## 3. Tile sheets (atlas) — pour réutilisation directe des textures

📁 Dossier `.runtime-cache/metano_atlases/` (125 fichiers PNG, ~10-1500 KB chacun) :

| Sheet | Dims (tiles) | Dims (px) | Usage |
|---|---|---|---|
| `Metano_Town_Base.png` | 189×189 | 1512×1512 | Sol (herbe + sable + eau) |
| `Metano_Town_Base_Night.png` | 189×189 | 1512×1512 | Sol version nuit |
| `Metano_Town_Cliffs.png` | 189×68 | 1512×544 | Falaises + cliffs |
| `Metano_Town_Objects.png` | 189×189 | 1512×1512 | Décors (bâtiments, arbres) |
| `Metano_Town_Objects_Night.png` | 189×189 | 1512×1512 | Décors version nuit |
| `Metano_Town_Objects_Over.png` | 173×166 | 1384×1328 | Surcouches (toits, cheminées) |
| `Metano_Town_Objects_Under.png` | 185×186 | 1480×1488 | Sous-couches (ombres, fondations) |
| `Metano_Town_Fringe.png` | 133×143 | 1064×1144 | Bord haut (frange visuelle) |
| `Metano_Town_River.png` | 142×189 | 1136×1512 | Rivière (frame statique) |
| `Metano_Town_River_Animation_1.png` … `_4.png` | 142×189 | 1136×1512 | Eau animée (4 frames) |
| `Metano_Town_Animated.png` | 189×? | 1512×? | Animations (drapeau, fumée) |
| `Metano_Town_Animation_Tileset.png` | 64×176 | 512×1408 | Tilesets d'animations |

**Les mêmes en Night** : `*_Night.png` pour chaque.

## 4. Palette de couleurs (à respecter pour cohérence PMD)

PMD Red/PMDO utilise typiquement :
- **Herbe** : `#80D050` (vert clair) / `#60A040` (vert moyen) / `#387030` (vert foncé)
- **Sable/chemin** : `#F0D090` (clair) / `#D0A060` (moyen) / `#906030` (foncé)
- **Eau** : `#80B0F0` (clair) / `#5080C0` (moyen) / `#3060A0` (foncé)
- **Bois/branches** : `#804020` (marron) / `#603010` (foncé)
- **Pierre** : `#9090A0` (clair) / `#606070` (moyen)
- **Tuile brique** : `#B86030` (rouge-brique) / `#885030` (marron)
- **Ombre** : à pre-multiplier en alpha (cf. notes techniques plus bas)

## 5. Éléments du décor (par tile 8×8 px)

Tuiles individuelles principales (toutes en 8×8) :
- Herbe (4-5 variantes : clair/foncé/avec fleurs/avec touffes)
- Sable/chemin de terre (3-4 variantes)
- Bordures : eau/herbe, sable/herbe, falaise/herbe
- Arbres (4 frames statiques + 1-2 frames animées)
- Rochers (2-3 tailles)
- Bâtiments : toits de tuiles rouges, façades en pierre/bois
- Objets : panneaux, fontaine, escalier, drapeau, fumée
- Eau (transparente + animation 4 frames)

## 6. Bâtiments (taille approximative en tiles)

| Bâtiment | Dim. (tiles) | Dim. (px) | Contenu |
|---|---|---|---|
| Guilde | ~22×15 | 176×120 | Toit rouge, façade pierre, panneau "Guild" |
| Café Spinda | ~30×12 | 240×96 | Intérieur ouvert, comptoir, tables, panneau "Café" |
| Magasin Kecleon | ~14×12 | 112×96 | Toit rouge, façade brique, 2 comptoirs |
| Boutique TM | ~10×10 | 80×80 | Petit bâtiment, comptoir |
| Banque Murkrow | ~12×10 | 96×80 | Bâtiment banque, comptoir |
| Stockage Kangaskhan | ~14×10 | 112×80 | Bâtiment kangaskhan |
| Auberge | ~18×14 | 144×112 | 2 étages, lits, comptoir, panneau "Inn" |
| Dojo | ~14×14 | 112×112 | Toit spécial, drapeau, panneau "Dojo" |
| Bureau des missions | ~12×10 | 96×80 | Tableau de quêtes, panneau "Missions" |
| 6 maisons typées | ~12×12 | 96×96 | 1 par type élémentaire (fire/water/etc.) |
| Maison standard | ~12×12 | 96×96 | Variante "normal" |
| Stand Légendaire | ~10×8 | 80×64 | Stand de vente (apparait chapitre 6+) |

## 7. PNJ (12 dans la ville principale)

| Espèce | Rôle | Position (px) | Direction |
|---|---|---|---|
| Kecleon (vert) | Shop_Owner (magasin d'items) | (1056, 832) | Down |
| Kecleon (violet) | TM_Owner (TMs/orbs/wands) | (1080, 832) | Down |
| Murkrow | Bank_Owner (banque) | (1020, 991) | Down |
| Kangaskhan | Storage_Owner (stockage) | (1220, 848) | Down |
| Chatot | Musician (changeur BGM) | (1296, 1128) | Down |
| Ambipom | Swap_Owner (échange d'items) | (1288, 1265) | Down |
| Sneasel | Appraisal (évaluation trésors) | (1197, 1016) | Down |
| Slowpoke | Tutor_Owner (moves) | (1159, 1277) | Down |
| Lombre | Red_Merchant (daily deal) | (720, 1296) | Right |
| Nuzleaf | Green_Merchant (rival deal) | (592, 1296) | UR |
| Growlithe | Rescue Board (missions) | (665, 924) | DL |
| Wigglytuff | Legend_Merchant (stand Légende) | (656, 1272) | Down |

## 8. Lieux (8 bâtiments + 6 maisons + 1 auberge)

Carte visuelle interactive :

```
                                        N (Illuminant Riverbed)
                                              ↑
   ┌────────────────┬─────────────────┬─────────────────┐
   │  Fire Home     │  Electric Home  │   Rock Home     │  West Houses
   │  tile (26, 60) │  tile (24, 122) │  tile (70, 61)  │
   ├────────────────┴─────────────────┴─────────────────┤
   │  Water Home        Normal Home    Grass Home      │
   │  tile (54, 122)    tile (28, 80)  tile (45, 79)   │  East/South Houses
   ├────────────────┬─────────────────┬─────────────────┤
   │                                                  │
   │  Guild (Audino + Wigglytuff)  tile (87, 111)    │  North: shops
   │  Assembly (cloche bell)      tile (173, 73)    │
   │                                                  │
   ├─────────────────┬─────────────────┬───────────────┤
   │ Postboard      │  Centre Square  │  Well         │  Centre: NPCs
   │ tile (161, 31) │  + Fontaine     │  tile (86, 23)│
   ├─────────────────┴─────────────────┴───────────────┤
   │  Marché (Café, Kecleon, Bank, Storage, Swap...)  │  Centre
   │  tile (124, 132) (Market_Locale)                 │
   ├──────────────────────────────────────────────────┤
   │  Café (Spinda)  tile (143, 74) + 6 tables       │  East: Café
   │  + Kirlia (PNJ)                                 │
   ├──────────────────────────────────────────────────┤
   │  Auberge (Audino)  tile (67, 82)                 │  South: Inn
   │  + Kangaskhan                                     │
   ├──────────────────────────────────────────────────┤
   │  Dojo tile (113, 139) + Flag                     │  West: Dojo
   │  + Marowak Sensei (PNJ)                          │
   └──────────────────────────────────────────────────┘
                                              ↓
                                     S (Sortie vers Altere)
```

## 9. Marqueurs (38 dans Metano Town)

Liste des marqueurs visibles dans le JSON `Data/Ground/metano_town.rsground` :

**Entrées principales** (5) :
- `entrance` (712, 936) — entrée principale
- `entrance_north` (248, 16) — entrée nord (depuis l'extérieur)
- `entrance_1` (89, 430) — entrée secondaire
- `North_Exit` (200, 0) — vers north road
- `South_Exit` (240, 1503) — vers Metano Outskirts
- `East_Exit` (1503, 592) — vers east road

**Marqueurs de bâtiments** (avec _Partner = position du partenaire) :
- `Guild_Entrance_Marker` + `_Partner` (696, 904) / (696, 904)
- `Cafe_Entrance_Marker` + `_Partner` (1136, 608) / (1160, 608)
- `Inn_Entrance_Marker` + `_Partner` (528, 680) / (560, 680)
- `Post_Office_Entrance_Marker` + `_Partner` (1224, 328) / (1192, 328)
- `Dojo_Entrance_Marker` + `_Partner` (904, 1152) / (928, 1152)
- `Cave_Entrance_Marker` + `_Partner` (872, 544) / (872, 520)
- `Fire/Water/Grass/Electric/Rock/Normal_Home_Entrance_Marker` × 6 (chaque maison)
- `Metano_South_Entrance_Marker` + `_Partner` (288, 1456) / (288, 1480)
- `Main_Entrance_Marker` (0, 0) — spawn du joueur

**Sièges et tables** (6) :
- `Cafe_Seat_1` à `Cafe_Seat_6` — tables du café
- `Town_Seat_1` et `_2` (354, 513) / (432, 514)

**Légendaire** :
- `Legend_Stand_Marker` (656, 1272) — stand du marchand Légende

## 10. Musique

- **Ville jour** : `Treasure Town.ogg`
- **Ville nuit** : `Goodnight.ogg`
- **Café** : `Spinda's Cafe.ogg`

## 11. Layer system (technique pour le pixel artist)

Le moteur PMDO compose **4 couches** (sur 11 dans Metano) :

1. **Ground (sol)** : tuile de 8×8 du sheet `Metano_Town_Base` (herbe/sable/eau)
2. **Cliff/Mask (décor)** : tuile de `Metano_Town_Cliffs` (falaises, rochers, arbres)
3. **Object (objets)** : tuile de `Metano_Town_Objects` (bâtiments, panneaux)
4. **Animated (animation)** : tuile de `Metano_Town_Animated` (eau qui coule, drapeau)

L'ordre de superposition est important : Ground → Mask → Object → Animated.

## 12. Format technique des .tile (pour information)

- **Tile size** : 8×8 pixels
- **Format PNG** : alpha **premultiplié** (les PNG standard donneraient des halos sur fond sombre)
- **Compression** : déduplication des tuiles identiques (chacun pointe vers un blob unique)
- **Tile count** : 35 646 cellules par layer (avec 75 tuiles vides sur 35 721)
- **Unique tiles** : 3 929 tuiles différentes dans le sheet Base

## 13. Recommandations pour la nouvelle ville

Pour une ville **similaire à Metano** mais différente (ex: "Aquanova Town" / "Bourg d'Aquanova"), garder :

✅ **Style pixel art 8 px/tuile** (cohérent avec PMD Red/PMDO)
✅ **Palette diurne lumineuse** (équivalent des 125 tile sheets Metano)
✅ **Layout 189×189 tuiles** (15.8 écrans PMD, taille canonique)
✅ **11 layers** (1 ground + 1 cliff + 1 object + 4 animations × over/under + 1 fringe)
✅ **12 PNJ** (même nombre, 8 marchands + 4 services)
✅ **6 maisons typées** + 1 auberge + 1 café + 1 guilde + 1 dojo
✅ **Rivière traversante** (caractéristique de Metano)
✅ **Place pavée centrale** avec fontaine (Wishing Well) + assembly bell

**Varier** :
❓ Nom (au choix — ex: "Aquanova" pour une ville côtière)
❓ Thème (côtier, montagne, désert, forêt, etc.) → adapte palette + tiles
❓ PNJ espèces (garder la même fonction, changer l'espèce)
❓ Position des bâtiments (grid différent, layout original)
❓ 1 rivière → peut être 1 lac, 1 cascade, 1 mer, 1 marais

## 14. Fichiers livrés au pixel artist

```
.runtime-cache/
├── metano_renders/         (13 PNG = rendus finaux des maps)
│   ├── metano_town.png        (1512×1512 — 1.9 MB)
│   ├── metano_town_nuit.png   (1512×1512 — 2.0 MB)
│   ├── metano_cafe.png        (456×320 — 62 KB)
│   ├── metano_inn.png         (448×352 — 91 KB)
│   ├── metano_cave.png        (416×368 — 77 KB)
│   ├── metano_fire_home.png   (344×272 — 60 KB)
│   ├── metano_water_home.png  (344×272 — 48 KB)
│   ├── metano_grass_home.png  (368×280 — 70 KB)
│   ├── metano_electric_home.png (344×272 — 57 KB)
│   ├── metano_rock_home.png   (352×272 — 48 KB)
│   ├── metano_normal_home.png (360×280 — 65 KB)
│   ├── metano_altere_transition.png (512×304 — 110 KB)
│   └── treasure_spinda_cafe.png (456×696 — 101 KB)
│
└── metano_atlases/         (125 PNG = tile sheets sources)
    ├── Metano_Town_Base.png         (1512×1512)
    ├── Metano_Town_Base_Night.png
    ├── Metano_Town_Cliffs.png
    ├── Metano_Town_Cliffs_Night.png
    ├── Metano_Town_Objects.png
    ├── Metano_Town_Objects_Night.png
    ├── Metano_Town_Animated.png
    ├── Metano_Town_Animated_Night.png
    ├── Metano_Town_River.png
    ├── Metano_Town_River_Animation_1..4.png
    ├── Metano_Town_River_Sparkles.png
    ├── Metano_Town_Fringe.png
    ├── Metano_Town_Trimmed.png    (1.6 MB — version complète composée)
    ├── Metano_Town_Cafe.png
    ├── Metano_Town_Cave_Base.png
    ├── Metano_Town_Inn_Base.png
    ├── Metano_Town_Inn_Objects.png
    ├── Metano_Town_Fire_Home_*.png
    ├── Metano_Town_Water_Home_*.png
    ├── Metano_Town_Grass_Home_*.png
    ├── Metano_Town_Electric_Home_*.png
    ├── Metano_Town_Rock_Home_*.png
    ├── Metano_Town_Normal_Home_*.png
    ├── Metano_Arene_*.png         (15 sheets — arène de combat)
    ├── Metano_Full_Battle_*.png   (45 sheets — battle ground complet)
    └── Metano_Raid_*.png          (16 sheets — donjon raid)

docs/audit/METANO_TOWN_PIXEL_ARTIST_BRIEF.md  ← ce document
```

## 15. Outils pour décoder d'autres tilesets PMDO

```bash
# Décoder un fichier .tile en PNG atlas
python3 tools/decode_metano_tiles.py --sheet Content/Tile/Nom_Sheet.tile

# Décoder tous les tilesets d'un préfixe
python3 tools/decode_metano_tiles.py --all --prefix Metano_

# Rendre une map complète (combine les 4 layers)
python3 tools/render_metano_map.py --ground Data/Ground/metano_town.rsground
python3 tools/render_metano_map.py --all
```

## 16. Résumé technique ultra-court

- **Tile** = 8×8 px, PNG alpha-prémultiplié
- **Layer 0** = ground (sol)
- **Layer 1** = cliffs (falaises, rochers)
- **Layer 2** = objects (bâtiments, arbres)
- **Layer 3** = animated (eau qui coule, drapeau)
- **Format fichier** : `.tile` (binaire dédupliqué) + `.rsground` (JSON) + `.rsmap` (Map)
- **Couleurs** : palette 8-bit, alpha-premultiplié
- **Conventions** : 
  - Up = Y=0, Down = Y=max
  - Right = X=max, Left = X=0
  - Origin (0,0) = coin haut-gauche
- **Direction NPC** : 0=Down 1=Up 2=Left 3=Right (dans le Collider, le char regarde le bas = 0)

---

**Contacts** : pour toute question sur la structure PMDO 0.8.12, voir :
- `dev/tools/png2tileset.py` — décodeur PNG → .tile
- `dev/tools/make_entrance_grounds.py` — template de génération de ground
- `docs/AUDIT_FINAL/FINAL_REPORT.md` — documentation complète du projet
