# Metano Town — Référence projet & plan d'implémentation

Mesures prises directement dans le dépôt (2026-08-29). Aucun chiffre de ce
document ne vient du brief : le brief suppose une petite carte placeholder ;
l'état réel est celui-ci.

## 1. Référence/template réellement trouvé

| Objet | Fichier | Taille/état |
|---|---|---|
| Ville jour | `Data/Ground/metano_town.rsground` | 36,3 Mo, 11 layers, **189×189** cases (tuiles sol 8 px → carte 1512×1512 px), musique `Treasure Town.ogg` |
| Ville nuit | `Data/Ground/metano_town_nuit.rsground` | 38,8 Mo, clone géométrique exact (procédure documentée `docs/metano_nuit.md`) |
| Scénario ville | `Data/Script/halcyon/ground/metano_town/init.lua` | **3418 lignes**, dispatch 10 chapitres (`metano_town_ch_1..10`) + `metano_town_legend.lua` |
| Transitions | `metano_altere_transition`, `metano_cave` | entrées sud/nord/est + sortie donjon |
| Zone hôte | `Data/Zone/master_zone.json` | `GroundMaps` = **391 noms** ; les entry points sont les **markers nommés** (`Main_Entrance_Marker`, init.lua:301) |

Le réseau de **locales** de la ville est déjà posé dans les 62 `GroundObjects` :
Guild, Café, Dojo, Poste, Well, Market, Merchants, Exploration, North/South
Houses, Cave, Legend Stand, plus `Shop`, `Bank`, `Storage`, `Swap`, `TM`,
`Tutor`, `Postboard`, panneaux d'orientation, sièges `Cafe_Seat_1..6`,
`Town_Seat_1/2` et sorties `North/East/South_Exit`.

## 2. Dimensions exactes (vérifiées, pas supposées)

- Grille : **189×189** obstacles × tuiles (couche `obstacles` = 189×189, cells
  8 px avec `Tags`). Solide mesuré : **41,9 %** — 58 % de surface libre.
- Échelle PMDO ground : tuile 8 px, pas de personnage 16 px, `TexSize=1`,
  `EdgeView=1` (caméra clampée aux bords), `NoSwitching=True`.
- Aucune limite moteur connue sur la taille de ground (viewport + edge view),
  mais **la limite pratique est le fichier** : 36 Mo en JSON mono-ligne, ×2
  avec la variante nuit. Un passage à 240×240 ferait dépasser ~55 Mo par map
  et casserait l'éditabilité script-safe.
- **Décision : pas d'agrandissement.** La densité des zones vides existantes
  est le vrai levier (le brief « feel large » est atteint par la richesse, pas
  par le vide). Si une extension de district est décidée plus tard, le
  mécanisme sécurisé existe : régénération scriptée des 11 tableaux +
  `obstacles` couplée (précédent : `tools/tile_night.py` + clonage nuit).

## 3. Tilesets/assets réellement disponibles

- **53 fichiers** `Content/Tile/Metano_Town_*` : 14 feuilles jour pour la carte
  (Base, Cliffs, River 1-4 animés, Objects, Objects Under/Over, Animated ×3,
  Fringe, Animation Tileset), 14 variantes nuit (`*_Night`), et feuilles par
  intérieur (Cafe, Cave, Fire/Electric/Grass/Normal/Rock/Water Home).
- Format `.tile` **décodé, roundtrip-prouvé** (docs/metano_nuit.md §2 :
  MD5 identique après relire+réécrire ; `docs/outil_png2tileset.md`).
  Ajouter des tuiles = étendre le `.tile` via `png2tileset`, pas de rescale.
- Intérieurs guild : feuilles `Guild_*` et `GuildBasement(-Night)`,
  `GuildOutside(-Dusk/Night/NightGate)`, `EoN_GuildMesshallAnims`,
  `EoN_GuildmasterRoomNight` (matériel EoN déjà adapté).
- Inventaire PMU : `docs/pmu_asset_inventory/manifest.json` = **83 objets
  qualifiés**, byte-exact, non redimensionnés :
  `containers_and_storage` 18, `weapons_armor_and_tools` 13,
  `furniture_and_textiles` 13, `plants_and_natural_decor` 12,
  `wall_art_and_fixtures` 11, `books_and_documents` 10,
  `lighting_and_tableware` 4, `toys_and_miscellaneous` 2.
  Extrait mais **jamais placé en jeu** (statut `..._NOT_PMDO_RUNTIME_VALIDATED_NOT_PLACED`
  des outils `extract_*`).

## 4. Facilités — ce qui existe vs le brief

| Exigence du brief | État réel | Action |
|---|---|---|
| Magasins/boutiques | `Shop` + stocks Kecleon scriptés (`GenerateGreen/PurpleKecleonStock`) | conserver |
| Bank/storage | objets `Bank`, `Storage` (menu-interactables) | option : locaux dédiés (§6) |
| Café | `metano_cafe` 57×40, 2 PNJ, 18 markers, `Spinda's Cafe.ogg` | enrichir mobilier PMU |
| Dojo/training | `dojo_ossatueur` + `Dojo_Entrance`, `Tutor`, `TM` | conserver |
| Auberge | `metano_inn` 56×44, **0 PNJ** | ajouter réceptionniste + nuit logique |
| Poste | `metano_altere_*`/`Post_Office_Entrance` + `Post_Locale` | conserver |
| Guild complète | voir §7-8 | premier floor à refondre |
| Soigneur/médical | `Growlithe_Desk` en place de guilde (objet ville) | câbler dans hall guilde |
| Bâtiments publics/décor | 6 maisons élémentales, Well, Legend Stand, places | densifier |

## 5. Plan du layout extérieur

Les quartiers sont **déjà nommés** par les locales/panneaux ; le travail est
de la densification, pas une table rase :

1. **Entrée** : garder `Metano_South_Entrance_Marker` depuis l'altere
   transition ; axe sud → `Crossroads_Sign` comme pivot de lisibilité.
2. **Axes** : les rues existantes forment le squelette ; vérifier au render
   qu'aucune zone morte > 12×12 cases libres n'existe hors places prévues.
3. **Résidentiel** : autour de `North_Houses_Locale`/`South_Houses_Locale`,
   composer des maisons supplémentaires **à partir des tuiles déjà dans
   `Metano_Town_Base/Objects`** (toits/roofs variants), en variant empreinte
   et silhouette par combination de pièces existantes — pas d'art neuf, pas
   de recoloc.
4. **Places** : Well, Market, Merchants, Cafe seats : ajouter plants/détails
   (déjà dispo) et bancs/tables via mobilier existant ; les 83 objets PMU
   entrent en §9 (phase meublage intérieurs) plutôt que sur la voirie.
5. Éviter la grille : contrôler par le render une distribution des
   empreintes de toits (tailles distinctes 5..11 tuiles).

## 6. Intérieurs

Existants et câblés (marker entrée + `_Partner` dans la ville, handler
`*_Entrance_Touch` dans init.lua) : cafe, inn, dojo, cave, 6 maisons
élémentales, poste/altere, les 15 grounds de guilde.

Nouveaux candidats (faible risque, forte valeur brief) :
- **`metano_bank`** : réutiliser le gabarit `metano_cafe` (57×40, 5 layers)
  avec tuiles Base/Objects de la ville ; câblage = 2 markers + 1 handler +
  objet `Bank` existant pointant dessus au lieu du menu nu.
- **`metano_healer`** : idem, logique nuit (fermé la nuit via `TownNight`).
Chaque nouvel intérieur doit suivre les règles projet L4/L5/L15/L16
(déclaré dans la zone, même zone pour `EnterGroundMap`, FadeOut→attente→
transition) et être enregistré dans `master_zone.GroundMaps` **et**
`index.idx`.

## 7. Guilde — état réel

| Ground | Grille | Layers | Objets | Constat |
|---|---|---:|---:|---|
| `guild_first_floor` | 40×30 | **1** | 2 | **Le point faible : le hall d'entrée n'est pas un vrai commun** |
| `guild_second_floor` | 84×56 | 8 | 5 | couloir + accès chambres, riche |
| `guild_third_floor_lobby` | 100×56 | 8 | 6 | lobby sommet, riche |
| `guild_guildmasters_room` | 48×48 | 6 | 2 | bureau présent mais spartiate |
| `guild_dining_room` | 56×36 | 7 | 14 | riche (matériel EoN MessHall) |
| 4 bedrooms + hallway + storage ×2 + heros_room + hut + parvis | — | — | — | structure complète déjà là |

## 8. Structure 3 étages — réponse au brief

Le cycle « reception/common → corridors/bedrooms → master office + lobby »
existe **déjà** : first (hall) → second (chambres/couloirs/dining/storage) →
third (lobby). Les actions correctes sont donc :
1. **refondre `guild_first_floor`** en vrai hall à plusieurs couches :
   comptoir Growlithe (dossier `Growlithe_Desk` déjà créé), panneau de
   missions, table/chaises du `EoN_GuildMesshallAnims`, escaliers visibles
   vers le 2e, PNJ permanents (Wigglytuff, Chatot, Chimecho selon SV),
   passage de 1 layer → 6-8 layers en réutilisant les feuilles `Guild_*`
   du second floor ;
2. enrichir le bureau du maître : moquette/potted/plants PMU (12 dispo),
   livres (10 dispo), lampe (4) ;
3. ne pas toucher aux dimensions 40×30 si le hall peut vivre dedans
   (le Wigglytuff's guild originel est petit) — agrandir seulement si le
   placement du comptoir + zone mission + escaliers l'exige, au pire
   56×30 en conservant l'actuel comme sous-rectangle (migration sûre).

## 9. Conformité technique (règles vérifiées dans le dépôt)

- Édition `.rsground` **uniquement par scripts ciblés** (précédents :
  `fix_ground_serialization.py`, `tile_night.py`,
  `materialize_pmdred_eu_entity_integration.py` avec contrôle sha256 et
  « additive-only ») ; jamais de re-save manuel qui reformaterait les
  `LocalTexts`.
- Toute carte modifiée doit garder `obstacles` strictement cohérent avec les
  tuiles posées : outil `collisions_depuis_png.py` + audit
  `audit_collisions_grounds.py`.
- La variante **nuit** est un clone géométrique : toute modif jour impose la
  re-projection nuit (`tools/tile_night.py` transform déjà validée).
- Nouveaux grounds : JSON de zone + `index.idx` + fichiers sur disque, sinon
  crash (règles L5/L15 de la checklist projet).
- `EnterGroundMap` limité à `master_zone` : les intérieurs restent dans la
  zone courante (conforme, tous y sont déjà).

## 10. Réutilisables PMUniverse — ce qui est vraiment utilisable

83 objets qualifiés, crop interdit, rescale interdit, PNG d'origine byte-exact,
preview 2× nearest uniquement. Mapping :
- Guild hall : tables/chaises/étagères (`furniture_and_textiles`,
  `containers_and_storage`) ;
- Bureau maître : livres, lampes, posters muraux ;
- Café/auberge : tableware, plantes ;
- Maisons : textiles/murs.
Pipeline : découpe déjà faite (`isolated_candidates/`), il manque uniquement
l'encodage en `.tile` ville (png2tileset, palette/style 8 px à respecter —
les sprites PMU village étant en 16 px, **les objets nécessitent un pass de
conversion 16→2×8 documenté ou sont posés en `ObjAnim` sur la layer Objects,
16 px = 2×2 cases, ce qui est le mode natif PMDO**. C'est la voie retenue :
placement en objets 16 px, pas de redécoupe).

## 11. Assets à créer (inventaire honnête, court)

1. Tuiles de silhouettes de toits additionnelles **si** la combinaison des
   tuiles existantes ne donne pas assez de variété après render de contrôle
   (à trancher à l'étape A de la phase 1, pas avant).
2. Éventuellement une feuille `Metano_Town_Bank`/`_Healer` si la réutilisation
   des feuilles Cafe/Home casse la cohérence visuelle (par défaut : non, on
   réutilise Cafe/Normal_Home).
3. Rien d'autre : mobilier = objets 16 px existants/PMU ; pas de nouveau
   tileset maison.

## 12. Manquants & blocages

- **`.runtime-cache` absent** (reset sandbox constaté ce jour) : la validation
  runtime exacte (index PMDO 0.8.12, rendu offscreen, probes) exige de relancer
  `bash tools/restore_pmdred_eu_validation_runtime.sh` (~9 min, GitHub auth
  OK la dernière fois). **Aucune preuve runtime ne sera revendiquée avant.**
- Aucun éditeur dans la sandbox : tout passage visuel se fait par
  `render_ground_png.py` + lecture image par l'agent, et/ou capture offscreen
  PMDO (précédent : harness `docs/pmdred_eu/pmdo_validation`).
- Les « large town » claims du brief sont déjà ~70 % satisfaits ; le risque
  n'est pas la construction, c'est la **régression** des 3418 lignes de script
  et des 12+219 grounds branchés. Toute modif de `metano_town.rsground` doit
  être livrée par petit pas, render jour+nuit à l'appui, et l'audit
  `audit_grounds_correlation.py` en gate.

## Exécution — Phase A & B (2026-08-29)

**Phase A (audit visuel) : DONE.** Renders de contrôle générés hors dépôt
(`.runtime-work/metano_audit/`) via `tools/render_ground_png.py` + Pillow
12.3.0 (venv ignoré `.runtime-work/render-venv/`). Constats :
- la ville jour est dense et cohérente : réseau de rues lisible, rivière,
  ponts, plaza du puits, quartier résidentiel sud, poche marché à l'est ;
- le seul vrai trou du brief confirmé par le render : le hall de guilde
  (`guild_first_floor`) vide de tout objet au sol ;
- les zones mortes périphériques sont des lisières forestières (intentionnel,
  motif répété d'arbres en grille — améliorable plus tard, non bloquant).

**Phase B (meubler le hall) : DONE — vérifié par render + gardes structurelles.**
Outil : `tools/furnish_guild_hall.py` (idempotent, additive-only, dry-run par
défaut, `--apply` pour écrire, backup automatique).
- transplantation réelle de clusters `Objects` de `guild_dining_room` (même famille de
  tuiles bois), ancrages : panier de baies (8,15), panier (19,20), rangée de
  caisses/barils (19,23) ; 30 tuiles dessinées, 30 cellules solidifiées
  sous le mobilier uniquement.
- **Rejets documentés pendant l'itération** (règle « aucun profil médiocre
  forcé ») :
  1. table ronde 8×8 du réfectoire : zéro ancrage valide dans la salle
     circulaire sans couvrir les markers d'entrée (`Main_Entrance_Marker`,
     `entrance`) — scan d'ancres : liste vide ;
  2. « table core » 4×4 recadrée : le render a révélé que le cluster (13,7)
     du réfectoire est en fait la **fenêtre murale ronde**, pas une table ;
     posée au sol = tuile-fenêtre flottante → supprimée ;
  3. barils en (10,11)/(17,5) : cassent la spirale du couloir (connectivité
     markers) → skip par la garde ;
  4. coude (8,20) de la plante B : isolait 4 cellules → repositionnée en
     (19,20) → 0 cellule isolée.
- Gardes finales passées : `Entities` et `Layers[0]` byte-identiques à la
  sauvegarde ; `obstacles` modifiés uniquement sous les tuiles dessinées
  (30 diffs) ; entrée→escaliers+partner connectés ; 0 cellule praticable
  isolée ; parse-back OK ; re-render correct.
- Statut : **PROTOTYPE_CONFIRMED (renderer du projet)** ; PAS encore
  `RUNTIME_CONFIRMED` — `.runtime-cache` a disparu du sandbox (reset), la
  validation exacte PMDO 0.8.12 doit relancer
  `bash tools/restore_pmdred_eu_validation_runtime.sh` avant toute
  déclaration de passage runtime.

## Ordre d'exécution proposé

- **Phase A (audit visuel)** — DONE, voir « Exécution — Phase A & B » ci-dessus.
- **Phase B (hall de guilde)** — DONE en version additive (mobilier réel
  transplanté, gardes passées). Le refonte multi-layers complète (comptoir
  dessiné, escaliers visibles) reste optionnelle : le hall est petit et le
  mobilier additionnel a été rejeté par les gardes de connectivité/ancrage.
- **Phase C (densité ville)** : maisons supplémentaires sur tuiles existantes,
  places meublées, bancs ; synchronisation nuit obligatoire.
- **Phase D (nouveaux intérieurs)** : bank + healer si le render de la phase A
  confirme le besoin de points d'intérêt supplémentaires.
- **Phase E (living world)** : extension du roster PNJ/routines via le système
  `CreateWalkArea`/`TownNight` existant, sans toucher à la géométrie.
