# Directive — Conservation des donjons légendaires canoniques PMD

> Intégrée le 2026-07-29. Document lié à `PROMPT_MAITRE.md`,
> `directive_arenes_boss_tournoi.md`, `conception_donjons_segmentes.md`.

---

## Principe

Les donjons, arènes, événements et rencontres impliquant les Pokémon
légendaires issus de **PMD Explorateurs du Ciel** et **PMD Rescue Team**
sont du **contenu canonique** de New Era. L'histoire principale repose
sur les mêmes fondations que Sky.

**Règle** : le joueur doit retrouver tous les lieux légendaires iconiques
de Sky et Rescue Team, mais avec une qualité de réalisation digne d'un
PMD moderne sur PMDO RogueEssence.

---

## Sources techniques

| Source | URL | Usage |
|---|---|---|
| ExplorersOfSkyOrigins | github.com/slothplaysnecro/ExplorersOfSkyOrigins | Assets Sky, cinématiques, maps déjà format PMDO |
| pret/pmd-red | github.com/pret/pmd-red | Structure Rescue Team (GBA), quêtes, dialogues |

**Règle d'adaptation** : analyser la logique de conception, puis adapter
à New Era. Jamais de copie — toujours une réécriture modernisée.

---

## État actuel du projet

### Donjons pmd-red déjà importés (30 grounds)

| Ground | Donjon d'origine | Légendaire | Assigné à |
|---|---|---|---|
| `fosse_ardente` | Magma Cavern Pit (D12P04) | Groudon | caldeira_endormie |
| `abime_tempetes` | Stormy Sea (D14P01) | Kyogre | eaux_inexplorees |
| `fosse_argentee` | Silver Trench (D15P01) | Lugia | fosse_abysses |
| `champ_braises` | Fiery Field (D16P01) | Entei | ile_lave_flottante |
| `champ_foudre` | Lightning Field (D17P01) | Raikou | crete_voilee |
| `champ_vent_boreal` | Northwind Field (D18P01) | Suicune | montagne_traitresse |
| `sommet_aurore` | Mt. Faraway (D19P01) | Ho-Oh | tour_sacree |
| `antre_occident` | Western Cave (D20P01) | Mew | forteresse_abandonnee |
| `cretes_boreales` | Northern Range (D21P01) | Latios | ile_eon |
| `bois_des_plaintes` | Howling Forest (D25P01) | Suicune | antre_chuchotant |
| `sanctuaire_voeu` | Wish Cave (D23P01) | Jirachi | dedale_voeu |
| `autel_celeste` | Sky Tower Summit (D13P03) | Rayquaza | celestial_peak |
| `parvis_celeste` | Sky Tower (D13P01) | (entrée) | réserve |
| `palier_celeste` | Sky Tower (D13P02) | (palier) | hauteurs_etoile |
| + 16 autres | Entrées, cinématiques | — | réserve ou assignés |

### Zones Sky (EoSO) — 67 zones new_era_sky

Importées du mod ExplorersOfSkyOrigins, format PMDO natif. Couvrent
la majorité des donjons d'Explorateurs du Ciel.

---

## Règles de conservation

### 1. Aucun donjon emblématique supprimé, déplacé ou remplacé

Chaque légendaire habite son environnement iconique. Les arènes finales,
sanctuaires, salles de combat, accès secrets et événements d'approche
sont conservés.

### 2. Adaptation Rescue Team (GBA → PMDO)

Les cartes GBA sont extrêmement simples et limitées. Elles doivent être
**entièrement reconstruites** pour respecter les standards PMDO :

- Composition environnementale riche
- Terrain crédible, dénivelés naturels
- Végétation cohérente, falaises détaillées
- Rivières, cascades, lacs pertinents
- Éléments décoratifs nombreux
- Lisibilité du level design
- Profondeur visuelle, éclairages adaptés
- Effets atmosphériques

**Objectif** : donner l'impression que ces lieux ont toujours existé
dans New Era tout en restant immédiatement reconnaissables.

### 3. Sky (DS → PMDO)

Les cartes Sky sont déjà proches du format moderne. Conservation large
possible, avec enrichissement si nécessaire.

### 4. Cinématiques — réécrites, pas copiées

Les cinématiques originales servent de **référence narrative** :

- Disposition générale, ambiance, identité visuelle
- Progression du donjon, mécaniques particulières
- Mise en scène, dialogues, musique, événements
- Combat, récompense, conséquences scénaristiques

Chaque scène doit exploiter pleinement le moteur PMDO :
- Déplacements réalistes, caméra cinématique
- Animations naturelles, réactions crédibles
- Gestion du regard, expressions, timing des dialogues
- Pauses dramatiques, effets visuels, ambiance sonore

### 5. Dialogues — adaptés, jamais recopiés

Les dialogues originaux servent de base narrative mais doivent être :
- Réécrits en français idiomatique
- Cohérents avec l'univers, le scénario et les personnages de New Era
- Fidèles à la personnalité officielle des légendaires
- Reconnaissables sans donner l'impression de relire les textes d'origine

### 6. Portails de Dusknoir

Les assets de portail trouvés dans ExplorersOfSkyOrigins sont mis de côté
pour réutilisation future — mécanique de téléportation liée à l'Abîme,
potentiellement activée par Dusknoir dans Treasure Town.

---

## Audit obligatoire avant modification

Avant toute modification d'un donjon ou d'une rencontre légendaire :

1. Disposition générale de la carte
2. Ambiance et identité visuelle
3. Progression du donjon
4. Mécaniques particulières
5. Mise en scène et cinématique de rencontre
6. Dialogues et musique
7. Combat et récompense
8. Conséquences scénaristiques

Aucune adaptation ne doit faire perdre l'identité de ces lieux.

---

## Philosophie

**Le résultat attendu n'est pas un remake fidèle au pixel près, mais la
version définitive et modernisée de ces lieux mythiques, parfaitement
intégrée à l'univers de New Era, tout en respectant leur rôle canonique.**

Chaque donjon doit donner l'impression que les développeurs originaux
avaient accès au moteur PMDO RogueEssence.
