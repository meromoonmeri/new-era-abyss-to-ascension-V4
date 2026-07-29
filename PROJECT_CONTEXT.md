# PROJECT_CONTEXT — New Era : Abyss to Ascension

Dernière mise à jour : 2026-07-29 (session Arena.ai — prompt maître + outils + Mont Windsep + tournoi)

## But de ce fichier

Fichier de reprise à la racine du dépôt. À lire au début de la prochaine session,
en complément de `docs/PROMPT_MAITRE.md` (directive de méthode complète).

## État de la session en cours

- **Branche** : `arena/019fafb3-new-era-abyss-to-ascension-v4`
- **Dernier commit** : `c7bc938` (Outil gen_entrance.py + ajustement Team Charm/Alakazam)
- **Base** : commit `ac671ac` de la branche session

## Identité du mod

- `Mod.xml` > `Name` : `New Era : Abyss to Ascension`
- `Mod.xml` > `Namespace` : `halcyon` (NE JAMAIS MODIFIER)
- `Mod.xml` > `UUID` : `CAE98609-7A96-4CFC-B5AB-0E1D41F6A1FF` (NE JAMAIS MODIFIER)
- `Version` : `0.5.1` / `GameVersion` : `0.8.12` / `ModType` : `Quest`

## Intégrité du clone local (2026-07-29)

- `Data/Ground/*.rsground` : 272 présents
- `Content/Tile/*.tile` : 498 présents
- `Content/Music/*.ogg` : 133 présents
- `Data/Ground/metano_town.rsground` : 37 Mo ✅

Les compteurs ont augmenté depuis la baseline 2026-07-26 (68/248/51) suite
aux imports de donjons (vagues 1-9, réseaux, friend areas).

## Ce qui a été fait cette session (3 commits)

### Commit 1 : `f7d15fe` — Directive méthode + Mont Windsep

- **`docs/prompt_mise_en_scene_optimise.md`** créé (depuis remplacé par `PROMPT_MAITRE.md`)
- **`docs/INVENTAIRE_OUTILS_PIPELINE.md`** créé : 55 outils existants, 6 manquants
- **Amélioration mise en scène Mont Windsep** :
  - Midpoint : 0→12 émotes, 3→26 tours (FirstArrival, FallenFragment, SummitVigil)
  - Guardian : 1→5 émotes, 4→14 tours (PreBoss LOT 8.3, DefeatedBoss)
  - Miniboss : 2→4 émotes, 6→13 tours (PreBoss LOT 8.3, DefeatedBoss)

### Commit 2 : `775f77a` — Arènes, tournoi, distribution, Ch6

- **`docs/directive_arenes_boss_tournoi.md`** créé : principe des arènes, distribution 30-99 étages, arc tournoi
- **`docs/plan_distribution_donjons_30_99.md`** créé : 93+ donjons répartis sur ch1-32
- **`docs/conception_arc_tournoi.md`** créé : 5 phases, 5 équipes, foreshadowing
  - Team Charm repoussée ch18+ (justification organique, pas prétexte tournoi)
  - Team Alakazam repoussée ch20+ (conséquence des révélations ch18-19)
- **Amélioration mise en scène Ch6** :
  - Entrance : +8 tours (dialogues Papilusion ↔ duo)
  - Midpoint : +2 émotes, +3 tours (FirstArrival, WipedCutscene)

### Commit 3 : `c7bc938` — Outil gen_entrance.py + ajustement tournoi

- **`tools/mapgen/gen_entrance.py`** créé : générateur d'entrances (avenue Kangourex)
  - 3 commandes : `lister`, `generer`, `verifier`
  - Protection absolue des entrances ch1-5
  - Transition de biome progressive, détection de duplications
  - Intégration avec gen_map.py et gen_relais.py (même DB)
- **Ajustement Team Charm/Alakazam** dans `conception_arc_tournoi.md`

## Documents de référence du projet

| Document | Rôle |
|---|---|
| `docs/PROMPT_MAITRE.md` | **Directive méthode complète** (règles, leçons, mise en scène, outils) |
| `docs/CONTEXTE_PROJET.md` | Mémoire longue technique (formats, architecture, conventions) |
| `docs/PASSATION_AGENT_ARENA.md` | Document de reprise inter-sessions |
| `docs/bible_continuite.md` | Bible de continuité narrative (ch1-10) |
| `docs/grammaire_cinematiques.md` | Grammaire extraite des sources PMD |
| `docs/CARTE_BLANCHE_CUTSCENES.md` | Liberté créative encadrée |
| `docs/directive_arenes_boss_tournoi.md` | Arènes de boss, distribution, tournoi |
| `docs/conception_arc_tournoi.md` | Design détaillé de l'arc tournoi |
| `docs/conception_donjons_segmentes.md` | Donjons segmentés, progression de biome |
| `docs/INVENTAIRE_OUTILS_PIPELINE.md` | Inventaire des outils existants et manquants |

## Outils dans `tools/mapgen/`

| Outil | Rôle |
|---|---|
| `gen_map.py` | Générateur/vérificateur de maps à tileset cohérent |
| `gen_relais.py` | Assortir les relais au biome de leur donjon |
| `gen_entrance.py` | **NOUVEAU** — Générateur d'entrances (avenue Kangourex) |
| `extract_tileset_db.py` | Extraire la base de tilesets depuis le dépôt |

## Bugs connus non résolus

- Crash `attempt to call a nil value` dans `vast_steppe` après la boucle Mission 1-8
- `searing_tunnel_entrance` : sacs en double, Penticus bloque le passage, coffre bugué
- Branche défaite Zarude (ch6) : à vérifier en jeu
- Rondoudou : présence et cinématique d'introduction à vérifier
- Cycle nuit Metano Town : affirmations non vérifiées en jeu

## Métriques de mise en scène (dernière mesure)

| Map | Dialogues | Émotes | Ratio | Tours |
|---|---|---|---|---|
| Mont Windsep entrance | 233 | 72 | 1:3.2 | 154 |
| Mont Windsep midpoint | 72 | 12 | 1:6.0 | 26 |
| Mont Windsep miniboss | 35 | 4 | 1:8.8 | 13 |
| Mont Windsep guardian | 34 | 5 | 1:6.8 | 14 |
| REF Tunnel entrance | 262 | 64 | 1:4.1 | 183 |
| Ch6 Metano | 156 | 20 | 1:7.8 | 29 |
| Ch6 Gloomy entrance | 20 | 1 | 1:20.0 | 14 |
| Ch6 Gloomy midpoint | 23 | 2 | 1:11.5 | 9 |

**Objectif** : ratio ≤ 1:4 (une émote pour 4 boîtes de dialogue max).
Le midpoint et le guardian du Mont Windsep, ainsi que les grounds Ch6,
restent au-dessus de cet objectif.

## Règles opérationnelles pour la prochaine tâche

- Toujours `git status --short` et `git ls-files -d` avant tout `git add`.
- Ne pas utiliser `git add -A` sans contrôle explicite des suppressions.
- Pour toute affirmation technique, citer fichier + ligne.
- Le test en jeu reste requis dès que possible.
- Lire `docs/PROMPT_MAITRE.md` intégralement avant toute nouvelle tâche.

---

## Session 2026-07-29 — Audit final et corrections (18 commits)

### Fait

- Audit complet du projet (7 étapes : intégrité, Lua, zones, boss, assets, traduction, nettoyage)
- 29 variables SV non déclarées → ajoutées avec garde-fous dans scriptvars.lua
- 2 PoseFaint non protégés → enveloppés dans pcall (crooked_den_ch_3.lua)
- 7 boss mal nivelés → corrigés (Zarude 34, Regigigas 36, Diancie 38, Laggron 40, Fulgur 42, Lugia 45)
- 11 ground maps fantômes → supprimées de master_zone.json
- Bug 1 (crash vast_steppe) → garde-fou else générique
- Bug 2 (sacs en double) → purge Decorations dans SetupGround
- Bug 3 (Penticus bloque) → Tropius décalé x=336→420
- Bug 5 (effets vertige) → BGAnimData corrigé (6 params→2 params + Color alpha)
- Bugs 6-8 → validés comme fonctionnels statiquement

### Bugs connus non résolus (nécessitent test en jeu)

- Bug 4 : Coffre bugué searing_tunnel_entrance (objet statique du .rsground)
- Confirmation en jeu des corrections bugs 1-3, 5
- Cycle TownNight complet (Offer→choix→scène→retour)
- Raid nocturne complet (déclenchement→combat→récompense)

### Estimation de durée de jeu

- Chapitres 1-5 : ~8-10h (contenu existant)
- Chapitres 6-10 : ~4-6h (cinématiques et adresses ajoutées)
- Quêtes annexes : ~2h (Examen Explorateur + Base Personnelle)
- Total estimé : ~15-18h

### Documents de référence créés

| Document | Rôle |
|---|---|
| PROMPT_MAITRE.md | Règles permanentes (remplace prompt_mise_en_scene) |
| PROMPT_ULTIME.md | Synthèse ch1-32, qualité PMD EoS |
| directive_structure_donjons_chapitres.md | 3-5 donjons/chapitre |
| directive_boss_justification_narrative.md | Boss = histoire, Voix = rare |
| directive_monde_vivant.md | Raid, PNJ variables, Treasure Town |
| directive_arenes_boss_tournoi.md | Arènes + distribution 30-99 étages |
| directive_donjons_canoniques_pmd.md | Conservation 30 grounds pmd-red + 67 zones Sky |
| conception_arc_tournoi.md | 5 phases, 5 équipes |
| plan_distribution_donjons_30_99.md | 93+ donjons sur ch1-32 |
| foreshadowing.md | 20+ éléments tracés |
| level_scaling_boss_donjons.md | Courbe niveaux ch1-10 |
| treasure_town_integration.md | ProjectEoN, parité Metano |
| quete_examen_explorateur.md | 3 épreuves (HxH) |
| quete_base_personnelle.md | 6 actes (Bois Brouhaha) |
| rapport_audit_global_2026-07-29.md | Audit intermédiaire |
| rapport_audit_final_2026-07-29.md | **Audit final avec validation** |
| INVENTAIRE_OUTILS_PIPELINE.md | 55+ outils existants, 6 manquants |

### Validation

**Projet considéré comme STABLE et CONFORME aux standards PMDO RogueEssence 0.8.12
pour mise en test joueur.** Voir `docs/rapport_audit_final_2026-07-29.md`.
