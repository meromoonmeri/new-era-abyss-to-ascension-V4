# Inventaire des outils — Pipeline de production New Era

> Dernière mise à jour : 2026-07-29
> Document lié à `PROMPT_MAITRE.md` (§ Outils internes)

---

## 1. Outils existants (dans `tools/`)

### 1.1 Validation & audit

| Outil | Rôle | Couvre quelle exigence de la directive ? |
|---|---|---|
| `validate_all.py` | Validation des 5 salles de boss Ch5 (fichiers, tilesets, obstacles, spawners, positions cinématiques, connexité) | Audit final — points 2, 9 |
| `validate_ch5.py` | Validation bout en bout de la chaîne Ch5 | Continuité inter-maps |
| `audit_bugs.py` | Chasse aux bugs d'exécution (appels absents, SV non déclarés, handlers manquants) | Outil technique (pas scénaristique) |
| `audit_integrite.py` | Audit d'intégrité global du mod | Couverture large, forme |
| `audit_dialogues.py` | Détecte les dialogues anglais restants (non traduits) | Analyseur de dialogues — partiel |
| `audit_fade_leaks.py` | Détecte les fuites de fondu (transitions mal fermées) | Transitions — partiel |
| `audit_boss_cinematics.py` | Audit qualité des cinématiques de boss | Vérificateur mise en scène — partiel |
| `count_dialogue.py` | Compte les lignes de dialogue par chapitre | Métrique volume |

### 1.2 Vérification technique

| Outil | Rôle |
|---|---|
| `verify_cutscene_guard.py` | Détecte les cartes sans CutsceneMode (crash potentiel) |
| `verify_scene_positions.py` | Vérifie les positions des entités dans les scènes |
| `verify_ground_registration.py` | Vérifie l'enregistrement des grounds dans les zones |
| `verify_bg_format.py` | Vérifie le format des backgrounds |
| `verify_lua_globals.py` | Vérifie les variables globales Lua |
| `verify_legend.py` | Vérifie l'absence de mots interdits (Necrozma, Eternatus) |
| `verify_spawner_enabled.py` | Vérifie que les spawners sont bien activés |

### 1.3 Génération & import de contenu

| Outil | Rôle |
|---|---|
| `gen_boss_cinematics.py` | Génère 42 scènes « Éveil des Ancrages » |
| `gen_addon_pmdred_network.py` | Add-on Réseau des Anciens Chemins (donjons) |
| `gen_addon_pmdred_network_v2.py` | v2 — 12 derniers donjons |
| `gen_addon_sky_network.py` | Add-on Réseau du Ciel |
| `gen_season_particles.py` | Particules saisonnières |
| `mapgen/gen_entrance.py` | **Générateur d'entrances de donjon** (avenue Kangourex, transition de biome) |
| `mapgen/gen_map.py` | Générateur/vérificateur de maps à tileset cohérent |
| `mapgen/gen_relais.py` | Assortir les relais au biome de leur donjon |
| `import_wave1_dungeons.py` à `import_wave6_friendareas.py` | Imports par vagues de donjons |
| `make_dream_map.py` | Construit la map `songe_source` |
| `make_cloven_entrance.py` / `make_gemini_cloven.py` | Maps Cloven Ruins |
| `make_songe_source.py` | Clone luminous_spring pour le rêve |

### 1.4 Conversion & correction

| Outil | Rôle |
|---|---|
| `convert_pmdred_batch.py` / `convert_pmdred_ground.py` | Conversion GBA → PMDO |
| `convert_relays_official.py` | Remplace les relais par des grounds officiels |
| `fix_ch7_ch10_flow.py` | Corrections de flux ch7-10 |
| `fix_ground_serialization.py` | Fix écran noir au chargement |
| `fix_grounds_entities.py` | Corrige le placement d'entités |
| `rebalance_bosses.py` | Renivelage des boss |
| `rebuild_tile_index.py` | Régénère l'index des tilesets |
| `tile_night.py` | Génère les variantes nuit des tilesets |
| `render_ground.py` | Rendu PNG d'un ground |

### 1.5 Simulation

| Outil | Rôle |
|---|---|
| `simulate.py` | Exécute la logique Lua dans un moteur simulé |
| `sim_legend.py` | Simulation des zones légendaires |
| `test_scenarios.py` | Rejoue 3 scénarios en exécutant le vrai Lua |

---

## 2. Outils manquants (à construire selon la directive)

### 2.1 Générateur de cinématiques — `tools/gen_cutscene_standard.py`

**Ce qu'il doit faire :**
- Prendre en entrée : liste de personnages, lieu, événement narratif, chapitre
- Produire un squelette Lua respectant la grammaire (`grammaire_cinematiques.md`) :
  - Établir le lieu avant les personnages (ambiance sonore → pause → parole)
  - Chaque réplique accompagnée d'un geste (émote, tour, déplacement)
  - Coroutines parallèles pour les mouvements synchrones
  - Caméra qui suit le sujet du discours
  - Fondu synchronisé (image + son + réplique sur même durée)
- Intégrer les positions validées du ground concerné
- Vérifier que les API utilisées existent (comptage d'occurrences)

**Priorité : HAUTE** — C'est l'outil le plus demandé par la directive.

### 2.2 Analyseur de cohérence scénaristique — `tools/audit_narrative_coherence.py`

**Ce qu'il doit faire :**
- Parser la `bible_continuite.md` pour extraire les faits établis
- Pour chaque scène d'un fichier `_ch_N.lua` :
  - Vérifier que les personnages mentionnés existent au chapitre N
  - Vérifier que les connaissances présupposées sont acquises à ce stade
  - Détecter les contradictions avec les chapitres précédents
  - Signaler les personnages qui parlent sans avoir été introduits
- Croiser avec `CharacterEssentials.lua` pour les espèces et rôles

**Priorité : MOYENNE** — Complexe à construire, mais essentiel pour les chapitres 6-10.

### 2.3 Vérificateur de mise en scène — `tools/audit_staging.py`

**Ce qu'il doit faire :**
- Pour chaque scène cinématique dans un fichier Lua :
  - Compter les émotes par rapport aux dialogues (ratio minimum : 1 émote pour 3 boîtes)
  - Compter les `CharTurnToChar`/`CharAnimateTurnToChar` par rapport aux changements de locuteur
  - Détecter les personnages présents (spawnés) qui ne parlent ni ne bougent de toute la scène
  - Vérifier que la caméra est déplacée au moins une fois par scène de plus de 10 boîtes
  - Détecter les `MoveToPosition` qui amèneraient un personnage hors du cadre caméra
  - Signaler les personnages qui restent à la même position pendant plus de 15 boîtes de dialogue consécutives

**Priorité : HAUTE** — Directement applicable, mesurable, et comble le manque R2 de l'audit Mont Windsep.

### 2.4 Analyseur de dialogues avancé — `tools/audit_dialogues_avance.py`

**Ce qu'il doit faire :**
- Améliorer `audit_dialogues.py` existant (qui ne fait que détecter l'anglais) :
  - Détecter les répétitions de mots/tics de langage entre personnages différents
  - Détecter les répliques interchangeables (même texte pour deux personnages)
  - Vérifier le registre de langage par personnage (formel/familier/argot)
  - Détecter les transitions brusques (changement de sujet sans lien)
  - Compter les pauses `[pause=N]` par scène (rythme)
  - Vérifier que les dialogues du héros sont cohérents avec le test de personnalité

**Priorité : MOYENNE** — L'existant couvre déjà le besoin urgent (dialogues non traduits).

### 2.5 Contrôleur de continuité — `tools/audit_continuite.py`

**Ce qu'il doit faire :**
- Comparer les flags `SV.*` écrits dans un chapitre avec les flags lus dans les suivants
- Détecter les flags écrits mais jamais lus (contenu mort)
- Détecter les flags lus mais jamais écrits (crash potentiel)
- Vérifier la progression des chapitres : chaque `SV.ChapterProgression.Chapter` est cohérent
- Croiser les `EnterGroundMap` avec les destinations réelles (pas de carte fantôme)
- Vérifier que les PNJ déplacés par une cinématique sont repositionnés correctement

**Priorité : HAUTE** — `audit_bugs.py` couvre déjà les SV non déclarés, mais pas la continuité inter-chapitres.

### 2.6 Audit de Ground — `tools/audit_ground_quality.py`

**Ce qu'il doit faire :**
- Vérifier que les objets de décor solides ont bien `triggerType 0` (bloquants)
- Détecter les PNJ positionnés sur des cases d'obstacle
- Vérifier que les PNJ qui restent après une cinématique sont bien les PNJ attendus
- Détecter les objets décoratifs temporaires non purgés (comme le feu I4 du relais)
- Vérifier les collisions entre positions de PNJ (pas de superposition)
- Vérifier que la caméra rend la main au joueur à la fin de chaque cinématique

**Priorité : MOYENNE** — `verify_scene_positions.py` couvre déjà une partie.

---

## 3. Inventaire des assets externes (PMDODump et GitHub)

### 3.1 Dépôts de référence

| Dépôt | URL | Contenu principal | Statut dans New Era |
|---|---|---|---|
| **PMDODump** | `github.com/audinowho/PMDODump` | Mod PMDO de référence (tilesets, sprites, items, zones) | Base du moteur |
| **PMDODump releases** | `github.com/audinowho/PMDODump/releases` | Builds stables | Moteur 0.8.12 |
| **DumpAsset** | `github.com/audinowho/DumpAsset` | Extraction d'assets depuis les jeux officiels | Non utilisé directement |
| **ExplorersOfSkyOrigins** | GitHub (PMDO) | Mod EoS sur PMDO — cinématiques, CharacterActions | Techniques de mise en scène exploitées |
| **ProjectEoN** | GitHub (PMDO) | Mod Explorers of Nature — MapStatus, IA d'escorte | MapStatus visuels documentés |
| **ZMDO** | GitHub (PMDO) | 827 objets sketch_* (Zorua) | Écarté (non pertinent) |
| **Mega_Stones** | GitHub (PMDO) | 48 méga-gemmes | **Importé** (lot précédent) |
| **minior-game-jam** | GitHub (PMDO) | MapStatus blood_moon | Documenté, à poser |
| **PMDOTutorial** | `github.com/audinowho/PMDOTutorial` | Leçons 1-8 | Documentation de référence |
| **pmd-red** | `github.com/pret/pmd-red` | Code source GBA (PMD Rouge) | Structure de référence |

### 3.2 Assets intégrés dans New Era

| Catégorie | Quantité | Source |
|---|---|---|
| Tilesets (.tile) | 248 | PMDO de base + ProjectEoN (6) + Friend Areas (8) |
| Items (JSON) | 229 | PMDO de base (181) + Mega Stones (48) |
| Musiques (.ogg) | 51 | PMDO + compositions originales |
| Grounds (.rsground) | 68 | Création propre + imports |
| Zones (JSON) | 208 | Création propre + imports |
| Sprites battle effects (PNG) | 74 | OBJECT RAW ASSET |
| MapStatus | 6 | Création propre (blowing_wind, darkness, dusk, steam, mysterious_distortion, +1) |

### 3.3 Assets documentés mais non intégrés (réservés pour besoin narratif)

| Asset | Source | Usage prévu |
|---|---|---|
| MapStatus `cutscene_rain` | ProjectEoN | Scènes de tempête futures |
| MapStatus `clouds_overhead` | ProjectEoN | Pic Céleste |
| MapStatus `fog` | ProjectEoN | Brouillard avec compte à rebours |
| MapStatus `sunset` | ProjectEoN | Voile chaud |
| MapStatus `blood_moon` | minior-game-jam | Nuit anormale (teinte rouge) |
| IA `escortee` | ProjectEoN | Missions d'escorte |
| Particule `Confuse` | ProjectEoN | Effet confusion générique |
| Particule `Dragon_Ascent_Explosion` | minior-game-jam | Boss volant |
| 62 tilesets ProjectEoN numériques | ProjectEoN | Rejetés (rips officiels sans usage) |

---

## 4. Priorités de construction d'outils

### Phase 1 — Immédiat (cette session ou suivante)
1. **`audit_staging.py`** — Vérificateur de mise en scène (ratio émotes/dialogues, personnages immobiles, caméra)
2. **`audit_continuite.py`** — Contrôleur de continuité inter-chapitres (flags SV)

### Phase 2 — Court terme
3. **`gen_cutscene_standard.py`** — Générateur de cinématiques avec grammaire intégrée
4. **`audit_ground_quality.py`** — Audit qualité des Grounds (collisions, purges, PNJ)

### Phase 3 — Moyen terme
5. **`audit_narrative_coherence.py`** — Analyseur de cohérence scénaristique
6. **`audit_dialogues_avance.py`** — Analyseur de dialogues avancé

---

## 5. Conventions de développement d'outils

- Tout outil doit être **conservateur** : en cas de doute, ne pas signaler (éviter les faux positifs qui font perdre confiance)
- Tout outil doit citer **fichier + ligne** pour chaque problème détecté
- Tout outil doit être **idempotent** : exécuter deux fois = même résultat
- Tout outil doit pouvoir tourner sans dépendance externe autre que `lupa`, `Pillow`, `numpy`
- Validation systématique après exécution : `python3 tools/<outil>.py` → code retour 0 = OK
- Les nouveaux outils doivent être référencés dans ce document
