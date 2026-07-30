# Outil Générateur Entrance Donjon — Avenues en segments de camp uniques
## New Era : Abyss to Ascension — Exigence unicité entrance §4

> **Règle** : pour les entrances construites comme des avenues en segments de camp, même exigence d'unicité que relais : chaque entrance doit se distinguer des autres par sa combinaison de biomes et son traitement propre, jamais gabarit recopié.

---

### 1. Pourquoi une entrance n'est pas un simple menu

Dans PMD Explorateurs, l'entrée d'un donjon est un lieu qui raconte déjà l'expédition :

- **Forêt de Crystals** : entrée = clairière avec 2 sentiers, l'un piétiné, l'autre effacé — on comprend que les anciens sont partis par l'un
- **Mont Travail** : entrée = camp de base au pied, tentes déchirées par vent, drapeaux — tension avant montée

Une entrance générique (même disposition Kangourex + 3 teammates + Dungeon_Entrance alignés) trahit manque de soin. Le joueur le sent immédiatement, même sans le nommer.

### 2. Template référence — searing_tunnel_entrance (modèle)

- **Position** : pied Tunnel Incandescent, transition forêt basse → grotte chaude
- **Biomes progression** : clairière forêt (verdoyant) → pierres chaudes (Falling_Rock_Shadow) → source petite avant tunnel (steam)
- **Éléments distinctifs** : coquilles Slugma au sol (clan Slugma défend tunnel), fumerolles latérales (MapStatus steam), pierres chaudes River_Stone_Round, source petite qui fume
- **Disposition** : avenue en 3 segments — segment 1 clairière avec souches (repos), segment 2 pierres chaudes avec coquilles (avertissement), segment 3 source petite (dernier abri) → Dungeon_Entrance
- **Trace narrative** : Phileas, clan Slugma, chaleur qui monte
- **Camp** : Kangourex au segment 1 (clairière, accessible), feu segment 3 derrière source (abri), teammates répartis segments (pas alignés)

C'est le patron à reproduire mais JAMAIS dupliquer.

### 3. Workflow avenue unique

#### Étape 0 — Définir combinaison biomes progression

Chaque entrance est entre ville (Metano ou guild) et donjon. Elle doit montrer dégradé progressif du précédent au suivant, comme donjon multi-segments (exemple Mont Windsep : verdoyant → falaise → sommet).

Documenter :

```
Entrance: vast_steppe_entrance
Précédent: Metano bourg plaine
Suivant: Grande Steppe seg0 prairie verdoyante basse
Biome entrance: lisière plaine → prairie, herbe rase → herbe haute taillée
Transition: herbe rase du bourg → herbes hautes coupées + Mère-Roche visible loin
```

#### Étape 1 — Choisir base via outil map_tileset mais finaliser manuellement

Outil `convert_relays_official.py` fournit base, mais entrance doit être avenue en segments de camp, pas camp circulaire.

**Étapes manuelles** :

1. Créer carte 40x40 tiles minimum (8px → 320x320 px) en 3 segments longitudinaux sud→nord
2. Segment 1 (sud, entrée depuis ville) : biome précédent, sol accueillant, Kangourex, 1 teammate
3. Segment 2 (centre, transition) : biome charnière, élément distinctif principal, feu / sacs
4. Segment 3 (nord, avant donjon) : biome suivant, sol plus hostile, Dungeon_Entrance, dernier teammate

**Jamais** : même plan recopié avec juste tileset changé. Chaque entrance a combinaison unique.

#### Étape 2 — Exigences par entrance (registre)

| Entrance | Combinaison biomes unique | Élément distinctif | Disposition avenue | Trace narrative |
|----------|---------------------------|--------------------|--------------------|-----------------|
| **vast_steppe_entrance** | plaine bourg (herbe rase, champs Zigzaton) → prairie basse verdoyante (troupeaux) → lisière herbes hautes taillées | Mère-Roche visible loin au nord, souches taillées cercle 8 en seg2, point d'eau asséché seg3, herbes hautes coupées chemin | 3 segments sud→nord en pente douce x=256, seg1 champs + Kangourex accessible, seg2 souches cercle feu, seg3 point d'eau sec + Dungeon_Entrance. Teammates : un par segment, pas alignés | Famille Zigzaton Almotz gratin Baies Oran, premiers rapports expéditions |
| **searing_tunnel_entrance** | clairière forêt basse → pierres chaudes + coquilles Slugma → source petite vaporeuse | coquilles Slugma, fumerolles, pierres chaudes, source petite steam | seg1 clairière souches + Kangourex, seg2 pierres chaudes coquilles + Almotz, seg3 source vapeur feu + Dungeon_Entrance | Clan Slugma défend tunnel, Phileas hypothèses |
| **mount_windswept_entrance** | forêt basse → falaise → corniche venteuse avec drapeaux | lacet x=256, drapeaux déchirés, Épine du Vieux visible haut, Kangaskhan 176,352 accessible (fix), falaise abrupte est | avenue en lacet sud→nord qui serpente, pas droite. seg1 forêt basse camp, seg2 falaise drapeaux déchirés, seg3 corniche venteuse Épine visible + Dungeon_Entrance au pied paroi | Arcanin père Hyko mort il y a 25 ans, Penticus mensonge mission routine |
| **crooked_cavern_entrance** | sentier forêt → éboulis caverne → boyau bas boyau | puits lumière mini seg2, graffitis anciennes équipes seg2, éboulis | seg1 sentier forêt clairière, seg2 éboulis puits lumière tamisée, seg3 boyau bas plafond bas + Dungeon_Entrance dans noir | Team Style hors-la-loi, rivaux comiques |
| **cloven_ruins_entrance** | plaine → dalles fissurées extérieur → colonnes effondrées + glyphes | dalles fissurées, colonnes effondrées 2x2, glyphes au sol AntreDragon, veines dorées début convergence | seg1 plaine dalles fissurées, seg2 colonnes effondrées camp en ruine, seg3 glyphes + veines dorées début + Dungeon_Entrance sous arche | Rubble Aggron légende Trois Serviteurs et Colosse |
| **crystal_sanctuary_entrance** | cascade silencieuse → galeries chantantes petites → chambre préparatoire | cascade sans bruit Crystal Crossing tiles, reflets bleus, cristaux petits chantants Core_Activation faible, sol qui résonne | seg1 cascade sans bruit (son manquant), seg2 cristaux petits chantants + reflets bleutés, seg3 chambre préparatoire silence respectueux + Dungeon_Entrance derrière rideau eau | Vieux Relicanth Trois Lacs, Phileas Fourneau Cœurs |
| **forgotten_marsh_entrance** | berges terre ferme → vase + roseaux couchés → sentier qui s'assèche | berges vaseuses, roseaux couchés même sens sans vent seg2, empreintes qui évitent seg3, odeur sucrée fausse | seg1 berges terre ferme + Kangourex, seg2 vase roseaux couchés orientés, seg3 sentier s'assèche vers îlot + Dungeon_Entrance dans vase | Gloom brume trois silhouettes, Cercle Suaire |
| **celestial_peak_entrance** | plaine → contreforts avec nuages bas → corniche pied pic | nuages bas Genesis_Fade seg2, traces Fulgur griffes Luxray + éclair jaune seg2, vent léger SE5, mer nuages visible loin seg3 | seg1 plaine vent léger, seg2 contreforts nuages bas + traces Fulgur, seg3 corniche pied pic avec mer nuages + Dungeon_Entrance face ciel | Escouade Fulgur course, Lugia juge, vision Necrozma |

#### Étape 3 — Adapter disposition camp topo réelle

Chaque entrance a Kangaskhan_Rock (sauvegarde), mais position adaptée :

- vast_steppe : Kangaskhan seg1 champs (accessible, pas sur falaise)  — déjà fix
- mount_windswept : Kangaskhan 176,352 accessible (fix bug incrusté falaise ouest 160,144) — zone 4x4 libre
- autres : Kangaskhan dans segment le plus sûr (pas dans vase, pas sous éboulis)

Teammates répartis : un par segment, pas les 3 au même endroit (vie du camp).

Feu : position abritée selon vent/biome (derrière Mère-Roche, derrière paroi ouest, etc).

#### Étape 4 — Cohérence cinématique arrivée

ChapterScenes.lua pour ch8-10 : arrivée devant donjon = caméra sur décor, pas personnages, 3 temps constat sensoriel → réaction affective → décision avancer.

Entrance doit correspondre exactement décor mentionné dans cinématique arrivée :

- ch8 Crystal : cascade tombe sans bruit, halo bleu pâle traverse, silence couvercle → entrance doit montrer cascade silencieuse
- ch9 Marsh : odeur sucrée fausse, roseaux couchés tous même sens sans vent → entrance montre roseaux couchés
- ch10 Peak : vent frappe côté, 3 silhouettes sur corniche, voix portées vent → entrance montre vent + traces

Vérifier que cinématique et visuel entrance correspondent.

#### Étape 5 — Registre + auto-questionnement

Même 6 questions que relais :

1. Élément distinctif absent autres entrances ?
2. Combinaison biomes progression lisible (on comprend qu'on est entre tel biome et tel autre) ?
3. Disposition avenue en segments adaptée topo réelle, pas plan recopié ?
4. Fonctions gameplay (Kangaskhan, teammates, Dungeon_Entrance accessible) présentes ?
5. Cinématique arrivée correspond décor propre ?
6. Comparé registre entrances existantes ?

Si non, entrance pas terminée.

### 4. Validation

```bash
python3 tools/verify_scene_positions.py --entrance vast_steppe_entrance
# Vérifie : Kangaskhan accessible, teammates walkables connectés Main_Entrance_Marker, Dungeon_Entrance walkable, aucun hors bornes
```

### 5. Ce qui est interdit

- Même disposition Kangaskhan + 3 teammates + Dungeon_Entrance alignés pour toutes entrances
- Entrance neutre déplaçable dans autre donjon sans incohérence
- Tileset changé mais plan identique
- Entrance générée aléatoirement

*— Outil vivant, avenue unique par donjon —*
