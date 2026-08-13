# Reminiscencia — chantier prioritaire

Reminiscencia est traité avant Nova.

## Source verrouillée

- dépôt : `meromoonmeri/BIBLIOTHEQUE` ;
- commit : `6963878956ec4c53833c03f26aa6a9aafd17800f` ;
- pointeur : `Reminiscencia/ReminiscenciaV2_3.zip` ;
- objet Git LFS SHA-256 :
  `cf74db06c2c06b36cdd88c3139ab8c123b932269c34e7b0f10349f05e475be08` ;
- taille exacte : 341 630 283 octets.

Le même hash est publié pour Pokémon Reminiscencia 2.3 par le miroir Uptodown,
ce qui fournit une seconde preuve d'identité de l'archive.

## Rendu prévu

`tools/render_rmxp_archive_maps.py` est prêt et testé sur un projet RMXP complet.
Il décompresse l'archive dans un espace ignoré, n'exécute aucun code source,
charge `MapInfos.rxdata`, `Tilesets.rxdata` et chaque `MapNNN.rxdata`, assemble
panorama, trois couches et événements-tuiles environnementaux, puis produit :

- un PNG PMDO 32 px par Map ;
- une planche globale annotée ;
- un manifest de dimensions et hashes ;
- aucun pixel d'acteur, dialogue, script ou audio.

Destination dérivée : `conversion/pmdo_renders/`.
