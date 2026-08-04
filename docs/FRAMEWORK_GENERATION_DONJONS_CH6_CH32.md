# FRAMEWORK DE GÉNÉRATION DES DONJONS (Chapitres 6 à 32)

**Projet** : *New Era : Abyss to Ascension* (moteur RogueEssence / PMDO)  
**Date d'exécution** : 2026-08-04  
**Rôle du document** : Constitution technique et méthodologique régissant la création de tous les donjons des chapitres 6 à 32 du mod.

---

## RÈGLE ABSOLUE
Avant de générer le moindre donjon, connaître par cœur la documentation du moteur (*Floor Generation Overview*, *Script Reference*, *RogueElements*) et l'état réel du dépôt. Aucune structure de donjon, aucun roster d'espèces, aucun nom de fichier n'est deviné — tout est vérifié contre ce que le moteur et le projet supportent réellement.  
Étant donné l'ampleur de cette tâche (plus de 200 donjons sur 27 chapitres), **ne jamais générer en un seul bloc non vérifié** : traiter **chapitre par chapitre, donjon par donjon**, avec validation intermédiaire avant de passer au suivant.

---

## 1. PORTÉE ET STRUCTURE GÉNÉRALE
- **Chapitres concernés** : 6 à 32.
- **Par chapitre** : 1 donjon principal (scénarisé) + jusqu'à **10 donjons secondaires**.
- **Étages par donjon** : 20 à 60 étages.
- **Segments** : Chaque tranche de **10 étages** constitue un segment avec **changement de biome** (`RangeDictSegment` / `LayeredSegment`).
- **Points médians (Relais)** : Chaque donjon dispose de points médians de repos à mi-parcours construits sur le modèle du relais du Tunnel Incandescent (`searing_tunnel_midpoint` avec la statue Kangourex `Kangaskhan_Rock`, les marqueurs `North_Exit` / `South_Exit` et les spawners d'équipe `TEAMMATE_1..3`), **STRICTEMENT ADAPTÉS AU BIOME DU DONJON** (ex. donjon nature/sylvestre ➔ point médian nature avec Kangourex ; donjon désertique ➔ point médian désert avec Kangourex ; donjon cristal/grotte ➔ point médian cristal avec Kangourex).
- **Mini-boss** : 3 par donjon, répartis logiquement dans la progression — chacun avec un nom propre et une musique dédiée (`Content/Music/`).
- **Salle de boss dédiée par légendaire** : Si un donjon comporte une rencontre légendaire, sa salle est conçue spécifiquement pour lui (échelle `24 px`, décor et biome adaptés), jamais une arène générique réutilisée.
- **Numérotation d'histoire** : Rang narratif de 30 à 99 pour le Chapitre 32, consigné dans `docs/inventaire_donjons.md`.

---

## 2. DIVERSITÉ GÉOMÉTRIQUE DES ÉTAGES (Section 1.5)
- **Chaque étage d'un donjon a une géométrie spatiale différente** des autres étages du même donjon (longs couloirs sinueux, grandes salles ouvertes, enchevêtrements, étages vastes vs compacts). La variation est structurelle (`GenSteps`, taille de grille, densité de salles), pas seulement cosmétique.
- **Unité de DA par segment** : Toute cette variété géométrique est habillée par le **même tileset** sur l'ensemble d'un segment de 10 étages. La diversité est dans la forme de l'étage, jamais dans un changement incohérent de décor.

---

## 3. GARDE-FOU NARRATIF SUR LES LÉGENDAIRES (Section 2)
- **Légendaire réservé à un enjeu narratif fort, jamais gratuit.**
- Les rencontres légendaires s'appuient en priorité sur le système de lieu de revanche (`LegendZones.lua`, modèle Zarude / `verdant_oath`).
- Si un donjon secondaire n'a pas besoin de légendaire pour être réussi, **le signaler explicitement** plutôt que d'en inventer un artificiellement pour remplir un quota.

---

## 4. NOMMAGE ORIGINAL, MUSIQUE ET INVENTAIRE CENTRAL (Section 3 & Convention)
- **Convention de Nommage (`[Lieu] + [Qualificatif]`)** :
  - **Interdiction de réutilisation directe** : Aucun nom de donjon officiel de la licence Pokémon Donjon Mystère n'est repris verbatim ou presque identique (« Forêt Glauque 2 », etc. sont proscrits).
  - Chaque nom de donjon de New Era est une création originale suivant la structure : **`[Nom commun de lieu/biome] + [Qualificatif]`** (ex. *Désert des Oubliés*, *Crevasse de Géode*, *Verger Sauvage*, *Plaines Brûlées*, *Cime d'Argent Oubliée*).
  - **Règle de variété** : Ne pas réutiliser le même nom de lieu plus de 2-3 fois sur les 27 chapitres sans un qualificatif très distinct.
  - **Banque de qualificatifs** : À choisir en cohérence avec le biome réel et le lore (sans spawner de spoil avant le payoff) parmi les catégories Sensoriel/atmosphérique, Géographique/descriptif, Émotionnel/narratif et Lié à l'Anima.
- **Noms de Mini-boss** : Les 3 mini-boss reçoivent un **nom propre individuel** (ex. *Sablaireau l'Ancien*, *Cacturne le Veilleur*, *Hippodocus le Colosse*), semblable à un nom de personnage ou PNJ.
- **Musique dédiée** : Vérifiée dans `Content/Music/` avant tout appel dans un script (`SOUND:PlayBGM`).
- **Fichier d'inventaire central (`docs/inventaire_donjons.md`)** : Source de vérité unique.

---

## 5. BESTIAIRE (20-50 ESPÈCES/DONJON), SCALING ÉVOLUTIF ET OBJETS (Sections 4, 4.5, 4.6)
- **Bestiaire et Quota d'Espèces** : Chaque donjon intègre de **20 à 50 espèces sauvages différentes**, vérifiées dans `Content/Chara/` et cohérentes avec le biome du segment.
- **Scaling Évolutif sur ~15 niveaux (`Lv 18-33`, etc.)** :
  - La progression d'un segment à l'autre est marquée par l'**évolution des espèces rencontrées**.
  - *Exemple* : Segment 1 (Étages 1 à 10) = faune au **Stade 1 non évolué** (Sabelette, Cacnea, Trapinch) ➔ Segment 2 (Étages 11 à 20) = faune au **Stade Évolué** (Sablaireau, Cacturne, Vibrava, Claydol, Hippodocus).
- **Spawn d'objets (`ItemSpawnZoneStep`)** : Chaque donjon fait apparaître des objets selon les patrons légitimes (`PMDODump` `DataAsset/Zone/*.out.txt`, `RangeDictSegment`).
- **Marchand Kecleon** : Spawn aléatoire obligatoire et modéré par étage, cohérent avec la difficulté du segment.

---

## 6. FAIRPLAY, ÉTAGES SPÉCIAUX ET MÉTÉO (Sections 5, 6, 6.5)
- **Fairplay de génération** : Un escalier ou passage obligatoire n'est jamais placé dans une position désavantageant injustement une équipe (pas d'escalier bloqué par la lave sans chemin praticable alternatif).
- **Étages spéciaux & Mods** : Maisons de monstres, salles de coffres/clés et mécaniques de niche issues d'ExplorersOfSkyOrigins, ZMDO ou `dungeon-pack` intégrées avec parcimonie et progressivité.
- **Météo en donjon** : Quelques étages ciblés par segment intègrent un statut météo actif (pluie, tempête de sable, brouillard) cohérent avec le biome, renforçant les moments de tension avant un mini-boss ou un relais.

---

## 7. CINÉMATIQUES INATTENDUES & SCALING (Sections 7, 8)
- **Donjons vivants** : Embuscades, visites et explorations surprises brèves avec des PNJ uniques créés pour l'occasion.
- **Scaling de difficulté** : Mini-boss toujours au-dessus du niveau et des stats des résidents du donjon. Évolutivité de la difficulté globale en fonction de l'avancement dans les chapitres 6 à 32.

---

## 8. MÉTHODE DE TRAITEMENT OBLIGATOIRE (Section 9)
1. Traiter **un chapitre à la fois**, jamais plusieurs en parallèle.
2. **Pour chaque chapitre** : lister d'abord les donjons secondaires prévus et **présenter cette liste avant de générer le contenu détaillé**.
3. Une fois un chapitre validé, passer au suivant en mettant à jour l'inventaire `docs/inventaire_donjons.md`.
