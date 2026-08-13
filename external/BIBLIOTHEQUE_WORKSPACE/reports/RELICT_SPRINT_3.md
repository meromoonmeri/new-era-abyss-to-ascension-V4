# Relict — rapport Sprint 3 timelines, timings et VFX

## Timings d'autotiles qualifiés

L'autorité source `Data/Scripts/006_Map renderer/001_TilemapRenderer.rb` fixe
`AUTOTILE_FRAME_DURATION = 5` en unités de 1/20 seconde. Les 17 autotiles animés
utilisés n'ont aucun suffixe de durée : leurs 88 frames ont donc une durée
source exacte de **250 ms chacune**. L'ordre, la boucle et les durées passent au
statut `SOURCE_DOCUMENTED`.

Seuls le chemin, le hash et la constante sont exportés. Aucun script n'est
exécuté ou copié dans les métadonnées.

## Timelines visuelles

Le pipeline produit 34 timelines de Maps (28 canoniques et 6 variantes
réellement divergentes) ainsi que 6 Common Events contenant des commandes
visuelles.

Éléments préservés dans l'ordre source :

- 680 attentes avec durée exacte en frames RGSS et valeur nominale à 40 FPS ;
- 332 routes forcées avec cible, mouvements, attentes et changements d'état ;
- 262 attentes de fin de mouvement ;
- 123 animations déclenchées sur entité ;
- 28 transferts de map ;
- 20 relocalisations d'entités ;
- 14 changements de panorama/fog ;
- 17 affichages, 14 déplacements et 51 suppressions de Pictures ;
- branches, boucles, appels de Common Events et labels nécessaires à la
  reconstruction du flux.

Les paramètres numériques, tones, couleurs et durées sont conservés. Les noms
de cast, dialogues, scripts, sons et Pictures potentiellement liés aux
personnages restent redacted sous forme de hashes.

L'autorité temporelle des événements est le tick RGSS nominal de 40 FPS, soit
25 ms, car `mkxp.json` ne contient aucun override `fixedFramerate` actif. Les
attentes restent attachées à leur branche et ne sont jamais additionnées comme
si le flux était linéaire.

## Ressources environnementales utilisées

Quatre dépendances de scène sont attestées et résolues :

- 3 panoramas statiques ;
- 1 fog animé (`forest.gif`).

Le fog est extrait en 12 PNG composités de 320×240. Les Graphic Control
Extensions du GIF donnent **100 ms par frame** et une boucle infinie. Le
coalescing ImageMagick est normalisé ensuite par le codec PNG déterministe du
pipeline ; la version et le hash de l'exécutable sont verrouillés dans le
manifest.

Neuf Pictures/Transitions utilisées par des scènes restent en file
`REVIEW_REQUIRED`. Leurs identités et hashes source sont conservés, mais aucun
pixel n'est exporté avant classification manuelle environnement/casting.

## Limite explicitement ouverte

Les événements contiennent 1 140 commandes de script redacted. Certaines
peuvent piloter des caméras ou VFX. Elles ne sont pas exécutées et leur corps
n'est pas exporté. Un audit statique ciblé des appels visuels constitue donc le
prochain lot obligatoire avant de déclarer les cinématiques entièrement
documentées.

Aucune conversion PMDO n'est commencée.
