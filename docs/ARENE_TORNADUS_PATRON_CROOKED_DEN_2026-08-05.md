# Arène Tornadus régénérée par la méthode des relais (patron : crooked_den)

Date : 2026-08-05. Outil : `tools/mapgen/gen_tornadus_arene.py`.

## 1. Problème traité

L'ancien `Data/Ground/mount_windswept_guardian.rsground` (141×168 cellules
de 8 px) référençait la feuille **`Mt Horn Entrance Layer 1`, tuiles de
24 px sur une grille 8 px** — saillie détectée par `validate_all.py`
(`ts=24 != carte 8`). Rendu en jeu : image compressée dans le coin
haut-gauche et vide partout ailleurs. C'est la même famille de panne que le
damier mauve/noir du duel (carte et planches désaccordées).

Par ailleurs, la chorégraphie de
`mount_windswept_guardian_ch_5.lua` (recalée au commit `26e3c1a`) vit
**entièrement** dans le carré 432×432 px du coin haut-gauche
(x∈[168,264], y∈[24,392], caméras centrées sur (216,216-220)).

## 2. Méthode (celle des relais, transposée aux salles de boss)

Comme pour les relais `new_era_sky_*` : **cloner un patron éprouvé,
re-skin par les matériaux du biome, ne jamais toucher à la structure ni au
câblage.**

| Élément | Choix | Inchangé ? |
|---|---|---|
| Patron structurel | `crooked_den` (salle compacte à feuille dédiée 8 px, spawners TEAMMATE, marker d'entrée, une couche) | ✅ topologie clonée |
| Matériau visuel | fenêtre 54×54 extraite de `mount_windswept_entrance` (feuilles `Mount_Windswept_*`, famille EoS Mt Horn) couloir recentré | ✅ aucune tuile dessinée à la main |
| Taille | **54×54 cellules = 432×432 px** : exactement l'espace de la chorégraphie Lua existante | ✅ Lua **non modifié** |
| Feuille | nouvelle `Mount_Windswept_Guardian_Base` (8 px, identity-mapped 2916 cellules, dédupliquée) **+ injection dans `index.idx` (541→542)** | ✅ vérifiée par `tools/verify_tile_index.py` |
| Réparations | pourtour falaise (sauf entrée sud x24-29), perchoir nord-centre (24-29, 2-5) marchable, couloir de scène garanti, positions Lua forcées libres, poches isolées bouchées (BFS depuis l'entrée) | ✅ obstacles régénérés |
| Identité | `AssetName`, `Name` (« Sommet Venteux »), `Music` (`Sky Tower.ogg`) repris de l'ancien fichier | ✅ |
| Entités | spawners `TEAMMATE_1/2/3` aux positions du Lua ((168,376), (264,376), (216,392)) ; `Main_Entrance_Marker` (utilisé par `zone/mount_windswept/init.lua:148,156`) + marker `entrance` repositionnés en (216,408) | ✅ noms conservés |
| Combat | `Data/Map/mount_windswept_guardian.rsmap` (19×19 `craggy_peak`, Tornadus 33 en (9,5), entrées (9,16)/(10,16)) | ✅ **non touché** (déjà valide) |
| Zone / scripts | `Data/Zone/mount_windswept.json`, `*_ch_5.lua`, `TornadusBattle.lua` | ✅ non touchés |

## 3. Validation

- `tools/validate_all.py` : **✅ toutes les salles valides** — l'arène passe
  de ❌ à ✅ (54×54, ts=8 == carte 8, 74 % marchable, perchoir atteignable
  depuis l'arrivée sud, Teammate1 + marker présents). Les anciennes positions
  de validation de l'outil ont été resynchronisées sur les coordonnées réelles
  du Lua ((216,376) → (216,24)).
- `tools/verify_tile_index.py` : 542/542 cohérent.
- Rendu par l'outil du dépôt : `docs/renders/mount_windswept_guardian.png`.

## 4. Non testé

Validation statique uniquement. À vérifier en jeu : entrée depuis le segment 2
(`ExitSegment` → `Main_Entrance_Marker`), cinématique complète (caméras (216,216)),
atterrissage de Tornadus (216,24), `ContinueDungeon('mount_windswept', 2)` →
combat, séquences `DefeatedBoss` / `DiedToBoss`.
