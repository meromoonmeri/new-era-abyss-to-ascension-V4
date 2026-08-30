# MILESTONE 1 — RAW_TOWN_ENVIRONMENT

STATUS: **PASS (M1)** — .rsground natif matérialisé, rendu canonique,
animations rivière/cascades prouvées, RUNTIME réel PMDO : LOAD_PASS +
MOVEMENT_PASS + SAFE, marche 94,5 % de l'aire libre atteignable depuis
l'entrée (zones non atteignables = plateau au-dessus de la falaise et
poches de forêt — intentionnelles).

## Contexte

Nouveau jeu indépendant de Halcyon/New Era. L'intégralité du travail
New Era est archivée sur la branche `archive/new-era-halcyon-complete`
(commit `a8fddc73`). Ce milestone démarre la nouvelle ville.

## MAP

- Nom : **Vallon de l'Éclusée** — `Data/Ground/vallon_eclusee.rsground`
  (12,6 Mo, 11 couches natives Metano, animations rivière 4 frames
  FrameLength 10, colorimétrie canonique par recopie de cellules
  représentatives du donneur)
- Zone : master_zone ground 392 (json + index.idx alignés)
- Script : `Data/Script/halcyon/ground/vallon_eclusee/init.lua`
- Layout v4 (croquis utilisateur comme PLAN, jamais croppé) : falaise
  nord haute, DEUX cascades Metano complètes (crête+chute+écume),
  deux rivières verticales serpentines, DEUX ponts en bois Metano
  (platelage praticable natif, extrait au pixel 119..127×74..81),
  place centrale, croisée de chemins organiques, forêt périmétrique
- Render canonique : `reports/renders/m1_raw_town_environment.png`
  (+ `_2x`, `_tick20` = preuve animation, détails cascade/pont/place)

## DIMENSIONS

- 84 × 78 cellules de 8 px = 672 × 624 px
- Grille : unité monde PMDO 8 px (identique à metano_town 189×189×8)

## RESOURCE SOURCES (fondation primaire = Metano, mission)

- `Data/Ground/metano_town.rsground` — Ground primaire : la TOTALITÉ
  des supertiles (pixels composites 8 px des 11 couches + collision
  native) provient de metano_town. AUCUNE tuile inventée/redessinée.
- Luluby (`luluby_town_*.rsground`) : analysé (render, langage) ;
  ressources non mélangées en v1 — écosystème UNIQUE Metano conservé
  (règle « prefer one coherent Ground ecosystem »).
- PMU / Grass Town–style (Won overw*) : références de composition
  (proportions, densités, hiérarchie des chemins) — RIEN copié.
- NNV : méthodologie milestone/QA (structure reports/, renders,
  validation mécanique, statuts honnêtes).

## MÉTHODE (ni collage de crops, ni copie de géométrie)

1. **Base de langage** (`tools/metano_db.py`) : 189×189 cellules → hash
   des pixels composites → **9 739 supertiles**, 13 638 paires H /
   13 966 paires V observées, classes mesurées (G herbe 707,
   P chemin 1 416, W eau animée 1 873, O autres 5 743).
2. **Vocabulaire** (`tools/mt_vocab.py`) : tables d'**autotiles
   extraites du Ground lui-même** — chemin 177 codes de voisinage
   8 bits, eau 73, forêt 176, berges (non-eau adjacent eau) ; +
   **109 objets végétaux complets** (composantes fermées, collision
   native) ; **bâtiments exclus mécaniquement** (composantes bloquées
   ≥ 40 cellules non vertes + marge 2 : 7 076 cellules, 2 767
   supertiles interdits).
3. **Layout ORIGINAL** (`tools/mt_layout.py`, seed 20260830,
   déterministe) : rivière nord-centre → arc → sortie OUEST (Metano :
   verticale centre-est + cascade — silhouette différente) ; entrée
   SUD-EST ; place centrale ovale ; remontée nord ; branche ouest vers
   parcelle ; ceinture de forêt asymétrique ; 3 parcelles futures
   plates et connectées (NE, ouest, SE) — **zéro bâtiment**.
4. **Réalisation** (`tools/mt_stamp.py`) : chaque cellule de masque
   reçoit un supertile observé pour son code d'autotile exact
   (**3 491/3 492 codes exacts**, 1 approché) ; passe berges dédiée ;
   objets posés uniquement sur herbe (764), densité décroissante vers
   le centre (langage mesuré : bord dense, centre ouvert).

## TECHNICAL

- Ground cible : à matérialiser en `.rsground` (couches Base/River
  anim/Objects/collision) — **non fait encore**
- Tileset : Metano_Town_* (Content/Tile), réutilisé tel quel
- Collision : recopiée du donneur par supertile (votes natifs)
- Animation : supertiles W marqués animés (frames rivière Metano) —
  la matérialisation .rsground devra réécrire les 4 frames natives

## VALIDATION (état honnête)

- Resources : PASS (100 % supertiles Metano, 0 asset étranger)
- Grid : PASS (8 px, aucune cellule fractionnaire)
- Autotiles : PASS mécanique (codes exacts 3 491/3 492)
- Paires H/V vs corpus : 62,4 % observées — les 37,6 % restants sont
  des juxtapositions nouvelles (autotile correct de part et d'autre,
  ex. herbe|herbe d'une autre variante) : à réduire en QA visuelle,
  critère final = zéro couture visible au zoom
- Layers : PASS (11 couches natives recopiées, .rsground 0.8.9.0)
- Collision : PASS (native par cellule ; BFS : place/ponts/col nord/
  rives atteignables depuis l'entrée sud, 94,5 % de l'aire libre)
- Animation : PASS (tick0 vs tick20 : 2 883 px échantillonnés changent
  sur rivières+cascades — 4 frames canoniques FrameLength 10)
- Runtime : PASS (PMDO réel headless : ground_entered, LOAD_PASS,
  spawn 344,592, move 4 directions MOVEMENT_PASS, verdict SAFE —
  `reports/m1_runtime_proof.jsonl`)
- Walkability : PASS (voir Collision)

## QA

- Render : PASS (canonique + 3 vignettes détail)
- Visual : IN_PROGRESS (berges corrigées ; passes zoom restantes)
- Runtime : BLOCKED
- Boundaries : ceinture de forêt périmétrique posée ; audit bord à
  faire au moment .rsground

## KNOWN ISSUES

1. Les cellules « pont » ont été retirées du layout v2 (rivière
   contournable) — un pont Metano natif pourra être ajouté quand le
   groupe pont complet (planches + rambardes) sera extrait comme objet.
2. Quelques juxtapositions herbe-variante/herbe-variante hors corpus
   (voir % paires) : à lisser.
3. Objets : la passe de densité peut créer des amas près des lisières —
   réglage fin à la QA visuelle.

## GIT

- Branche : arena/01a0357e-new-era-abyss-to-ascension-v4
- Archive New Era : archive/new-era-halcyon-complete (a8fddc73)

## FINAL STATUS

**IN_PROGRESS** — pas de PASS tant que .rsground + runtime + marche ne
sont pas prouvés (règle NO OVERCLAIMING).
