# Fiches Boss — Système d'animation d'entrée à 3 couches (Addendum A)

Outil de suivi anti-répétition. Chaque boss majeur a sa combinaison **biome + détail signature** unique.
Bibliothèque technique : `Data/Script/halcyon/BossFX.lua` (toutes les particules/BG vérifiées existantes).

## Grammaire générique (couche 1 — commune à tous)

1. Voix de l'Abysse (`BossFX.Voice`) — toujours AVANT l'apparition.
2. Irruption selon le biome (couche 2).
3. Recul du groupe (`BossFX.PushBack` — AnimateInDirection "Hurt" en direction opposée).
4. **Flash blanc** (`BossFX.Flash`) — caméra recadrée pendant la coupure (`MoveCamera` avant le flash).
5. Reveal : boss en pose d'intro (`CharSetAnim "Attack"` figé puis `"Idle"`).
6. Titre (`UI:WaitShowTitle`) + fanfare/thème.
7. Ligne de dialogue courte — jamais un pavé.

## Catalogue des boss implémentés

| Boss | Ch. | Biome | Type d'irruption | Détail signature | VFX/SE principaux | Statut |
|---|---|---|---|---|---|---|
| Luxio & co | 3 | caverne | embuscade (existant) | meute coordonnée | — (script ch3 existant) | Fait (legacy) |
| Mini-boss/gardiens ch5 | 5 | steppe/tunnel/mont | scripts `_ch_5` existants | — | — | Fait (legacy) |
| Zarude | 6 | forêt sombre | surgit des lianes | ombres + lianes qui s'écartent | `EmergeShadow` : Ominous_Wind, Dark_Pulse, Leaf_Storm | Fait |
| Regigigas | 7 | ruines | **activation** (pas de surgissement) : les veines dorées s'animent | éboulement + tremblement, veines qui pulsent | `RockFall`, `Rumble`, Overlay White | Fait |
| Diancie | 8 | sanctuaire cristal | **activation** : les gemmes résonnent et s'illuminent | éclats de gemmes en suspension autour d'elle | `AwakenCrystal` : Power_Gem_Charge/Hit, Flash_Cannon_Sparkle, Captivate_Sparkles | Fait (2026-07-26) |
| Laggron | 9 | marais/eau | jaillit de la vase (séquence A.3 complète) | amorce de Telluriforce figée (pose Attack) | `EmergeWater` : Wave_Circle (signal discret ×2), Water_Spout_Up/Splash/Drop, Bubbles ; SE DUN_Water_Sport → DUN_Surf | Fait (2026-07-26) |
| Escouade Fulgur | 10 | crête venteuse | déjà en position (course, pas une embuscade) | trio aligné qui défie | — (dialogue direct, voulu sec) | Fait |
| Lugia | 10 | sommet/ciel | descente réelle depuis les nuages | déploie ses ailes (pose Attack) avant de juger | `DescendSky` : Gust_Wind, Feather ×2, Rock_Slide_Front, Flash, Impact ; recul du groupe | Fait (2026-07-26) |

## Réservations (boss futurs — à remplir AVANT implémentation)

| Boss pressenti | Biome | Irruption réservée | Signature réservée |
|---|---|---|---|
| Jirachi (Grotte du Vœu, P7) | grotte astrale | activation (étoile qui s'éveille) — NE PAS réutiliser le motif cristal de Diancie | vœu murmuré avant le combat |
| Uxie (Sentier du Savoir, P5) | lac | émergence brume (`EmergeMist`) | ouvre les yeux une seule fois |
| Cresselia (Temple du Clair de Lune, P6) | temple | activation lumière lunaire | croissant lumineux |
| Giratina (Faille Primordiale, P7) | distorsion | Overlay `Distortion` + inversion écran | traverse un mur "impossible" |
| Yveltal (Vallée de l'Oubli, P6) | vallée morte | descente ciel — variante SOMBRE de Lugia (obligation de différencier : ciel rouge, silence au lieu de fanfare) | aspiration de lumière |

Règle : deux boss ne partagent jamais le même couple (irruption, signature). Toute nouvelle fiche se vérifie contre ce tableau.

## Maisons de monstre & donjons vivants (Addendum B) — état

- Les Monster House sont gérées nativement par le moteur (PMDC) dans les zones procédurales.
- Mise en scène dédiée (caméra panoramique, musique danger) : **à implémenter** — chantier scripté commun (`SINGLE_CHAR_SCRIPT` sur OnMapStarts), prévu avec la vague 2.
- PNJ inoffensifs en donjon : le moteur du dépôt a déjà `SpawnRandomTutor` purgé des zones importées (SV manquant) — un équivalent New Era (`SV.adventure.Tutors` déclaré chez nous) est le bon véhicule. À traiter avec la vague 2.
- Dosage cible par donjon 10+ étages : 1-2 monster houses mises en scène, 1-3 rencontres de vie, 0-1 mini-cinématique.

---

## RÉVISION Regigigas (ch7) — 2026-07-27

Directive utilisateur : Aegis Cave (PMD Sky) importée 1:1, trio Regi inclus.
- Arène : `sanctuaire_titans.rsmap` (« Sanctuaire des Titans »), 25×27 tuiles
  24px, visuel d'origine intact (tileset `Titans_Arena_Base`, identity-mapped).
- Combat : Regigigas 28 (12,7) + Regirock 26 (7,10) + Regice 26 (17,10) +
  Registeel 26 (12,12) — `clear_body`, movesets thématiques, mysterious_force.
- Branchement : `cloven_ruins` seg3 → `sanctuaire_titans` (l'ancienne
  `cloven_ruins_boss.rsmap` reste en secours, non référencée).
- Écho narratif : légende « Les Trois Serviteurs et le Colosse » (ch5, Rubble).
  L'intro 3 couches du ground `cloven_ruins_boss` reste valable : le trio
  n'apparaît qu'au combat — les Serviteurs répondent à l'éveil du Colosse.
