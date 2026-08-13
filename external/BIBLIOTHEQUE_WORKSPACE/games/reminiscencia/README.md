# Reminiscencia — priorité avant Nova

## Source vérifiée

- dépôt : `meromoonmeri/BIBLIOTHEQUE` ;
- commit : `6963878956ec4c53833c03f26aa6a9aafd17800f` ;
- archive Git LFS : `Reminiscencia/ReminiscenciaV2_3.zip` ;
- SHA-256 vérifié :
  `cf74db06c2c06b36cdd88c3139ab8c123b932269c34e7b0f10349f05e475be08` ;
- taille vérifiée : 341 630 283 octets ;
- archive brute conservée uniquement en cache ignoré.

## Rendus PMDO

`tools/render_rmxp_archive_maps.py` a chargé sans exécuter le jeu :

- `MapInfos.rxdata` ;
- `Tilesets.rxdata` ;
- les 552 `MapNNN.rxdata` ;
- leurs tilesets, autotiles et panoramas environnementaux.

Livrables :

- `conversion/pmdo_renders/maps/map_NNN.png` : 552 PNG individuels ;
- `conversion/pmdo_renders/contact_sheet.png` : planche globale ;
- `conversion/pmdo_renders/contact_pages/` : 12 planches lisibles de 50 Maps ;
- `conversion/pmdo_renders/manifest.json` : dimensions, provenance, hashes et
  problèmes par Map.

## Qualification actuelle

- 522 rendus environnementaux complets ;
- 29 Maps `ADAPTATION_REQUIRED` à cause de références visuelles absentes dans
  l'archive source, signalées en magenta ;
- Map 463 exclue et remplacée par un placeholder neutre : scène graphique avec
  casting/UI directement encodé dans le tileset ;
- aucun sprite d'acteur événementiel, dialogue, corps de script ou audio
  exporté ;
- cible visuelle PMDO : `TexSize=4`, pas graphique de 32 px.

Reminiscencia reste prioritaire pour l'inventaire des collisions, placements,
animations et VFX avant toute conversion en série. Nova vient ensuite.
