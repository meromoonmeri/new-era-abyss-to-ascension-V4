# Registre de suivi anti-duplication — Relais et points médians uniques
## New Era : Abyss to Ascension — Exigence d'unicité totale (Prompt §7)
### Date : 2026-07-30 — Mise à jour : après audit complet

> **Règle** : aucun relais ne doit ressembler à un autre, même entre biomes proches. Un relais n'est pas une pièce fonctionnelle interchangeable — c'est un lieu qui appartient à ce donjon précis, à ce moment précis de la traversée.

---

## Template de référence (niveau Explorers)

**searing_tunnel_midpoint** — le seul actuellement conforme
- **Donjon** : Tunnel Incandescent (searing_tunnel) ch5
- **Position** : entre segment 0 (entrée grotte chaude) et segment 1 (boyaux vaporeux) puis segment 2 (lac lave). Biome exact : **charnière grotte/tempestive** — vapeur + pierres chaudes, pas encore lave pure
- **Éléments distinctifs** :
  - Source chaude centrale active (MapStatus steam, particules Steam BG)
  - Formation : anneau de River_Stone_Round + River_Stone_Diamond autour source
  - Sol : dalles brûlées + cendres (Ash_Fall particles)
  - Camp : feu Campfire au bord source (eau = chaleur), Grassy_Bag à l'écart vapeur (logique)
- **Disposition adaptée topo** : anneau autour source, pas rectangle. Feu est à l'abri vent, sacs sur zone sèche walkable vérifiée 100%
- **Trace narrative** : récits Phileas sur clan Slugma qui défend tunnel — traces coquilles Slugma inoffensives (faune)
- **Fonctions gameplay** : Kangaskhan_Rock (PP + ventre + stockage), Food_Big près feu, rencontres : Slugma inoffensifs lvl 5, Koffing lointain cohérent
- **Cinématique correspond** : FirstArrival dialogue "source qui chante" = map montre source
- **Anti-duplication** : 0 autre relais avec source chaude active — unique

---

## Registre existant — état actuel + fix requis

### 1. vast_steppe_midpoint — Grande Steppe mi-parcours
- **Donjon** : vast_steppe ch5
- **Position progression** : entre segment 0 (prairie verdoyante basse, troupeaux) et segment 2 (herbes hautes + brume). Exact : **lisière falaise herbeuse, transition verdoyant → falaise**. Doit capter instant où herbe rase devient haute, vent se lève.
- **Biome exact** : falaise ouverte, herbes hautes taillées par anciens équipiers
- **Éléments distinctifs actuels** : AUCUN (cliff_camp générique)
- **Éléments distinctifs requis — UNIQUE** :
  - **"Mère-Roche"** : formation rocheuse 3x3 avec mousses + Flowers_Town_3 (asset attesté au relais), centre carte, visible de loin
  - Souches taillées en cercle (référence : anciens équipiers ont aménagé camp, dialogue partenaire)
  - Point d'eau asséché (River_Stone_Round sec + Food_Big vide renversé) — raconte que steppe manque d'eau (foreshadow boss point d'eau)
  - Herbes hautes coupées au nord de la carte (tiles herbes rases vs hautes), chemin tracé
- **Disposition camp adaptée** : camp adossé à Mère-Roche, face au vent (vent vient nord, camp sud de roche = abrité). Feu derrière roche, pas au centre. Sac à l'est, Kangaskhan à l'ouest accessible, pas sur falaise
- **Trace narrative** : disque Plum (Jigglypuff) — Jigglypuff qui a chanté et endormi public, sa berceuse = celle de sa mère. Respiration comique seule du ch5
- **Fonctions gameplay** : PP + estomac via Kangaskhan, faune : Taillow inoffensif + Shinx (steppe), 1x Tropius lointain mange herbe (pas agressif)
- **Statut** : ❌ À refaire — générique
- **Auto-Q 6** : Comparé à autres ? Oui, ressemble à canyon_camp. Doit devenir unique avec Mère-Roche + point d'eau asséché

### 2. mount_windswept_midpoint — Mont Venteux mi-pente
- **Donjon** : mount_windswept ch5
- **Position** : entre segment 0 (pied montagne forêt basse) et segment 2 (paroi venteuse). Exact : **corniche mi-hauteur, juste sous ligne des vents violents**
- **Biome exact** : canyon rocheux venté, drapeaux expédition, traces 25 ans
- **Éléments distinctifs actuels** : AUCUN
- **Requis UNIQUE** :
  - **Corniche effondrée** : bord est de map écroulé, rochers brisés (Falling_Rock_Shadow), vide sous brume (neige pas atteignable)
  - **Drapeau guilde déchiré** : objet Paper_1 déchiré + River_Stone_Diamond = marque expédition il y a 25 ans (Arcanin père Hyko mort ici)
  - **Fissure venteuse** : BG SE5_Wind_Background défile, particules Snow_Fall légères
  - Formation : "Épine du Vieux" — pointe rocheuse isolée 2x2 où Penticus s'est hissé
- **Disposition adaptée** : camp en L le long paroi ouest (abri vent), feu au coin abrité, Kangaskhan à 176,352 (fix bug falaise), entrée sud en lacet, sortie nord via corniche étroite (tension approche boss)
- **Trace narrative** : événement "Ce que le vent a emporté" (Hyko apprend vérité père Arcanin coéquipier Penticus mort ici)
- **Fonctions** : PP/ventre, faune : Wingull inoffensif emporté vent + Swablu
- **Statut** : ❌ À refaire

### 3. crooked_cavern_midpoint — Caverne Tortueuse
- **Donjon** : crooked_cavern ch3
- **Position** : entre segment 0 (entrée berdée) et segment 1 profondeurs. Exact : **salle d'aérage avec rayon lumière zénithal**
- **Biome** : caverne humide, stalactites
- **Éléments actuels** : rest_stop générique
- **Requis UNIQUE** :
  - **Puits de lumière** : ouverture plafond, tiles lumineuses, particules Leaf_Fall verticales
  - Stalagmite percée (trou au centre) — unique formation
  - Graffitis anciens équipes (Paper_1 au sol, mais neutralisé = décor)
- **Disposition** : camp circulaire autour puits lumière, Kangaskhan sous lumière (symbolique : seul endroit où on voit ciel)
- **Fonctions** : PP/ventre, faune : Zubat inoffensif pendu, Woobat
- **Statut** : ❌ À refaire

### 4. gloomy_forest_midpoint — Forêt Lugubre
- **Donjon** : gloomy_forest ch6
- **Position** : entre segment 0 (forêt entrée claire-obscure) et segment 1 profondeurs (forêt sombre corrup). Exact : **lisière où lumière ne passe plus**
- **Biome** : clairière forestière à canopée fermée, mousses épaisses
- **Éléments actuels** : forest_camp générique mais sortie unique = fonction unique, visuel pas unique
- **Requis UNIQUE** :
  - **Arbre-Racines** : chêne énorme dont racines forment arche entrée profondeurs, tiles ForestCampFront avec racines en travers
  - Tapis mousse épais (tiles vert sombre), champignons luminescents (si_light_1.6.png etc attestés)
  - Statue Kangourex couverte mousse, à moitié enfoncée (raconte ancienneté)
  - **Sortie unique** : seule sortie nord vers profondeurs, pas de retour (règle ch6) — déjà unique fonctionnellement
- **Disposition** : camp sous racines, en cuvette, protégé canopée. Feu petit, presque caché. Caméra basse.
- **Trace narrative** : Team Dazzling campe ici tant que duel pas fait (DazzlingArc.GloomyVictory) — 3 tentes distinctes Tsareena/Lopunny/Mismagius
- **Fonctions** : PP/ventre, faune : Oddish / Gloom inoffensifs, Musharna lointain
- **Statut** : ⚠️ Partiellement unique (fonction sortie unique OK), visuel à enrichir

### 5. cloven_ruins_midpoint — Ruines Tordues
- **Donjon** : cloven_ruins ch7
- **Position** : entre segment 0 (ruines extérieurs éboulés) et segment 2 (cœur ruines). Exact : **esplanade nivelée artificiellement, vestige civilisé**
- **Biome** : temple ancien, dalles dorées, veines lumière
- **Éléments actuels** : end_moonlit_temple générique, texte dit "sol plat taillé, veines dorées convergent" mais map ne montre pas
- **Requis UNIQUE** :
  - **Dalles dorées convergentes** : tiles AntreDragon_Base ou Celeste avec veines dorées pointant centre-bas (vers Cœur)
  - **Socle vide Titan** : emplacement vide 2x2 où Regirock/Regice/Registeel étaient scellés, marques au sol
  - **Mur gravé** : tiles avec glyphes (enigma_cristal), lisible mais érodé
- **Disposition** : esplanade rectangulaire parfaite (preuve taille humaine/ancienne), camp au centre géométrique, Kangaskhan au centre exact (symétrie voulue bâtisseurs)
- **Trace narrative** : légende Trois Serviteurs et Colosse (Rubble Aggron, café) — ce relais = lieu où serviteurs montaient garde
- **Fonctions** : PP/ventre, faune : Baltoy inoffensif qui tourne autour socle, Bronzor
- **Statut** : ❌ À refaire — décalage texte/décor critique

### 6. crystal_sanctuary_relay — Sanctuaire de Cristal
- **Donjon** : crystal_sanctuary ch8
- **Position** : entre segment 0 (galeries cristallines bruyantes) et segment 2 (salle glyphes silencieuse). Exact : **chambre où cristaux cessent de chanter — silence**
- **Biome** : grotte cristalline, neige/pureté, reflets
- **Éléments actuels** : final_stop neige générique
- **Requis UNIQUE** :
  - **Cristaux muets** : Anima_Core éteints (Core_Deactivation) au centre, alors que précédents étaient lumineux
  - Sol gelé partiel + reflets bleutés (Genesis_Cores BG)
  - **Écho** : SE léger quand on marche (à coder via son)
  - Particules Leaf_Fall bleutées lentes
- **Disposition** : camp en cercle autour cristaux muets, feu petit (peur de faire fondre), Kangaskhan à l'écart reflets
- **Trace narrative** : Diancie mentionne "réserve d'Anima cristallisée" — ce relais est avant-poste purification
- **Fonctions** : PP/ventre, faune : Carbink inoffensif endormi, Snom
- **Statut** : ❌ À refaire

### 7. forgotten_marsh_relay — Marais de l'Oubli
- **Donjon** : forgotten_marsh ch9
- **Position** : entre segment 0 (berges vaseuses, roseaux couchés même sens sans vent) et segment 2 (abysses vaseux). Exact : **îlot terre ferme que brume n'ose pas entrer**
- **Biome** : marais, eau morte, odeur sucrée fausse, fleurs fanent un côté
- **Éléments actuels** : end_ambush_forest générique
- **Requis UNIQUE** :
  - **Îlot aux Racines** : racines émergées formant berceau, terre ferme au milieu eau croupie (tiles boue vs terre)
  - Eau autour avec bulles lentes (ps_bubble.7.png)
  - Roseaux couchés tous même sens autour îlot (décor orienté)
  - **Trace Cercle Suaire** : empreintes qui s'arrêtent au bord îlot (tiles pas + absence pas)
- **Disposition** : camp sur îlot, forme ovalaire suivant racines, Kangaskhan au centre îlot (seul endroit sûr), feu surélevé sur pierre
- **Trace narrative** : Gloom mentionne brume aux trois silhouettes + fleurs fanent un côté → ce relais matérialise cela
- **Fonctions** : PP/ventre, faune : Croagunk inoffensif qui patauge, Toxel lointain (marais), Grimer qui évite îlot
- **Statut** : ❌ À refaire

### 8. celestial_peak_relay — Pic Céleste
- **Donjon** : celestial_peak ch10
- **Position** : entre segment 0-2 (contreforts, course Fulgur) et segment 4-6 (arène Lugia). Exact : **corniche au-dessus mer de nuages, réutilisée post-Fulgur segment 4**
- **Biome** : sommet venteux, ciel ouvert, mer nuages dessous
- **Éléments actuels** : guildmaster_summit générique, pas de mer nuages visible
- **Requis UNIQUE** :
  - **Mer de nuages** : BG Genesis_Fade + Steam en bas carte, tiles nuages en bord sud
  - **Autel vent** : formation rocheuse plate face aux vents, drapeau Fulgur arraché (trace rivaux)
  - **Traces Fulgur** : empreintes griffes Luxray, éclair sur roche (bs_plant.8.png jauni)
  - Vent : SE5_Wind_Background + particules Snow_Fall déviées
- **Disposition** : camp en ligne contre paroi nord (abri), feu ancré vent, Kangaskhan face vide (regarde nuages). Entrée sud large, sortie nord étroite corniche (tension §6)
- **Trace narrative** : course Escouade Fulgur, ils ont de l'avance. Lugia juge légitimité. Dernier relais doit porter tension approche finale : ici, vide sous les pieds
- **Fonctions** : PP/ventre, faune : Swablu / Wingull emportés, Drifloon lointain (ciel)
- **Statut** : ❌ À refaire

### 9. Entrances — même exigence d'unicité §4

| Entrance | Élément distinctif requis | Combinaison biomes unique |
|----------|---------------------------|---------------------------|
| **vast_steppe_entrance** | Avenue herbe haute rase + souches taillées historique guildes + point d'eau asséché fond + Mère-Roche visible loin | Prairie basse (verdoyant) → herbes hautes taillées → camp balisé |
| **searing_tunnel_entrance** | Avenue pierres chaudes + fumerolles latérales + coquilles Slugma + source petite avant tunnel | Cave claire → boyaux vaporeux → source chaude |
| **mount_windswept_entrance** | Avenue lacet + drapeaux expédition déchirés + Kangaskhan 176,352 accessible + Épine du Vieux visible | Forêt basse → falaise → corniche ventée |
| **cloven_ruins_entrance** | Avenue dalles fissurées + colonnes effondrées + glyphes au sol + veines dorées début | Extérieur éboulé → esplanade taillée → cœur |
| **crystal_sanctuary_entrance** | Avenue cascade sans bruit (Crystal Crossing) + reflets bleus + cristaux petits chantants | Cascade silencieuse → galeries chantantes → silence |
| **forgotten_marsh_entrance** | Avenue berges vaseuses + roseaux couchés + odeur sucrée + empreintes qui évitent | Berges → vase → îlot |
| **celestial_peak_entrance** | Avenue pied pic + nuages bas + traces Fulgur + vent léger | Plaine → contreforts → corniche → ciel |

---

## Registre technique — anti-duplication concrète

Chaque entrée ci-dessous doit être vérifiée avant création nouveau relais :

```json
{
  "vast_steppe_midpoint": {
    "biome": "falaise herbeuse transition verdoyant->falaise",
    "distinct": ["Mère-Roche 3x3 mousses + Flowers_Town_3", "souches taillées cercle", "point d'eau asséché River_Stone_Round sec"],
    "camp": "adossé Mère-Roche sud, abrité vent nord",
    "narrative": "Plum Jigglypuff berceuse mère",
    "fauna": ["Taillow inoff", "Shinx inoff"]
  },
  "mount_windswept_midpoint": {
    "biome": "corniche mi-hauteur falaise->sommet",
    "distinct": ["corniche effondrée Falling_Rock_Shadow", "drapeau guilde déchiré Paper_1", "Épine du Vieux 2x2"],
    "camp": "L le long paroi ouest, feu coin abrité",
    "narrative": "Arcanin père Hyko mort 25 ans, Penticus",
    "fauna": ["Wingull inoff vent", "Swablu"]
  },
  ...
}
```

**Règle de validation automatique future** :
- `tools/verify_unique_relays.py` à créer : scanner tous `.rsground` relay/midpoint, extraire liste objets décor (Anima_Core, River_Stone, etc) + positions + tileset, calculer similarité Jaccard. Si > 0.7 similarité entre deux relais → ÉCHEC.
- Vérifier que chaque relais a au moins 1 objet décor absent de tous les autres (ex: Mère-Roche n'existe que dans vast_steppe_midpoint).

---

## Statut au 2026-07-30

- [x] searing_tunnel_midpoint : conforme, référence
- [ ] vast_steppe_midpoint : non-conforme, fix requis
- [ ] mount_windswept_midpoint : non-conforme
- [ ] crooked_cavern_midpoint : non-conforme
- [ ] gloomy_forest_midpoint : partiellement (fonction OK, visuel non)
- [ ] cloven_ruins_midpoint : non-conforme (décalage texte/décor)
- [ ] crystal_sanctuary_relay : non-conforme
- [ ] forgotten_marsh_relay : non-conforme
- [ ] celestial_peak_relay : non-conforme
- [ ] entrances : toutes non-conformes à exigence avenue unique

Tous les futurs relais ch11-32 (42 Ancrages) doivent suivre même règle : **1 biome = 1 relais unique**, avec élément distinctif lié au légendaire (ex: Groudon → croûte craquelée + chaleur, Kyogre → vasque tidale, etc).

*— Registre vivant, à mettre à jour à chaque nouveau relais —*
