# Reminiscencia — lancement prioritaire

Reminiscencia passe désormais avant Nova.

## Réalisé

- objet source V2.3 identifié et verrouillé par SHA-256 et taille Git LFS ;
- identité confirmée indépendamment par le hash public Uptodown ;
- archive brute maintenue hors Git New Era ;
- convertisseur d'archive RMXP borné ajouté ;
- convertisseur testé sur les 28 Maps Relict : 28 rendus produits, dont Map 012
  byte-identique au rendu PMDO validé ;
- politique d'export : panoramas, couches et événements-tuiles seulement, sans
  sprites d'acteurs, dialogues, scripts ou audio.

## Commande de production

```bash
python3 external/BIBLIOTHEQUE_WORKSPACE/tools/render_rmxp_archive_maps.py \
  --archive /chemin/ignore/ReminiscenciaV2_3.zip \
  --game-id reminiscencia \
  --output external/BIBLIOTHEQUE_WORKSPACE/games/reminiscencia/conversion/pmdo_renders
```

## État d'acquisition

Le pointeur Git LFS est présent au commit canonique, mais le blob de 341 630 283
octets n'est pas encore matérialisé dans le sandbox. Les endpoints CDN Git LFS,
MEGA et MediaFire ferment actuellement leurs connexions TLS depuis ce sandbox.
L'accès GitHub principal reste fonctionnel et aucune action utilisateur n'est
demandée. Le pipeline est prêt à démarrer automatiquement dès que l'objet est
matérialisable.
