# Outil Générateur Map / Tileset — Cohérence biome exacte du relais
## New Era : Abyss to Ascension — Conception relais uniques §4

> **Rôle** : point de départ pour cohérence tileset avec biome exact de position du relais dans progression segment. Fournit base cohérente, ne remplace pas travail manuel composition qui donne identité propre.

---

### 1. Principe

Chaque relais est un point FIXE, construit à la main, qui ancre progression joueur dans lieu reconnaissable au milieu d'étages procéduraux qui, eux, varient. La génération procédurale (RogueElements) porte sur structure étages entre relais, jamais sur relais eux-mêmes.

Un relais n'est jamais généré aléatoirement.

### 2. Workflow complet

#### Étape 0 — Définir position exacte dans progression biome

Avant tout tileset, répondre :

- Quel est segment N et N+1 autour du relais ?
- Quel est biome exact de transition ? Exemple : vast_steppe seg0 verdoyant basse prairie (troupeaux, herbe rase) → seg2 herbes hautes + brume (voix). Le relais est donc **lisière falaise herbeuse, transition verdoyant → falaise**.
- Un relais entre verdoyant et falaise n'a PAS même composition qu'un relais entre falaise et sommet — chacun capture instant différent transition.

Documenter dans registre_relais_uniques_biomes.md :

```
Donjon: vast_steppe
Segment: 0 → 2
Biome exact: lisière falaise herbeuse, vent nord commence
Transition: herbe rase → herbe haute taillée + Mère-Roche
```

#### Étape 1 — Choisir tileset source cohérent via outil

Outil : `tools/convert_relays_official.py` + `tools/rebuild_tile_index.py` + `docs/bibliotheque_ressources_pmd.md`

**Sources d'assets validées UNIQUEMENT** : DumpAsset, PMDODump, RawAsset. Interdit d'importer tilesets non listés.

Piocher tileset PMDO officiel le plus proche du biome exact :

| Relais | Biome exact | Tileset source officiel utilisé | Justification |
|--------|-------------|---------------------------------|---------------|
| vast_steppe_midpoint | falaise herbeuse ouverte | cliff_camp (CliffCamp.tile) | falaises herbeuses ouvertes, vues larges |
| mount_windswept_midpoint | corniche mi-hauteur venteuse | canyon_camp (CanyonCamp.tile) | canyon rocheux, parois |
| searing_tunnel_midpoint | grotte → boyaux vaporeux charnière | spring_cave (Magma Cavern) | vapeur, pierres chaudes |
| crooked_cavern_midpoint | salle aérage caverne | rest_stop (CaveStop) | halte caverne officielle |
| gloomy_forest_midpoint | lisière lumière → profondeurs | forest_camp (ForestCamp) | clairière forestière |
| cloven_ruins_midpoint | esplanade nivelée artificielle | end_moonlit_temple (Wish Cave) | temple ancien |
| crystal_sanctuary_relay | chambre cristaux muets | final_stop (SnowCamp) | neige/pureté |
| forgotten_marsh_relay | îlot terre ferme brume n'ose | end_ambush_forest | sous-bois dense sombre |
| celestial_peak_relay | corniche au-dessus mer nuages | guildmaster_summit (Summit) | sommet |

**Commande outil** :

```bash
python3 tools/convert_relays_official.py --source cliff_camp --dest vast_steppe_midpoint --biome "lisière falaise herbeuse"
python3 tools/rebuild_tile_index.py --check
```

L'outil :
1. Copie ground officiel (AssetName, Name FR/EN, Comment, Music)
2. Supprime tous MapChars hérités (Rival, NPC_*, Snorlax...)
3. Supprime objets gameplay base (Assembly, Storage, boutiques, Ferry, gates) et remplace par patron New Era : Kangaskhan_Rock (Action) + North_Exit/South_Exit (Touch) + TEAMMATE_1..3 + Main_Entrance_Marker
4. Conserve objets décoratifs neutralisés (tentes, feux, pots, souches, barrières) trigger 0
5. Spawners TEAMMATE vérifiés walkable + connexité
6. Collisions officielles conservées telles quelles (correctes PMDO)

Résultat : base cohérente tileset avec biome exact, prête pour finalisation manuelle.

#### Étape 2 — Finalisation manuelle élément distinctif (OBLIGATOIRE)

L'outil fournit base cohérente, il ne remplace pas travail composition qui donne lieu son identité propre. Chaque relais doit avoir AU MOINS un élément distinctif absent de tous autres relais.

**Méthode** :

1. Ouvrir ground généré dans éditeur PMDO ou via `tools/fix_grounds_entities.py` pour visualiser
2. Ajouter formation rocheuse / arbre remarquable / ruine / source d'eau / vestige narratif lié histoire donjon

Exemples attestés :

- **vast_steppe_midpoint** : Mère-Roche 3x3 mousses + Flowers_Town_3 au sommet + point d'eau asséché River_Stone_Round sec + souches taillées cercle 8 + herbes hautes coupées nord (tiles rases vs hautes)
- **mount_windswept_midpoint** : Épine du Vieux 2x2 pointe isolée + corniche effondrée est Falling_Rock_Shadow vide sous brume + drapeau guilde déchiré Paper_1 + River_Stone_Diamond + fissure venteuse SE5_Wind_Background
- **cloven_ruins_midpoint** : dalles dorées convergentes AntreDragon/Céleste + socle vide Titan 2x2 marques cercle + mur gravé glyphes enigma_cristal
- **crystal_sanctuary_relay** : cristaux muets Core_Deactivation centre vs Core_Activation précédents + sol gelé partiel + reflets bleutés Genesis_Cores
- **forgotten_marsh_relay** : îlot racines émergées berceau ovalaire + eau croupie bulles ps_bubble + roseaux couchés même sens orientés + empreintes qui s'arrêtent bord
- **celestial_peak_relay** : mer nuages Genesis_Fade + Steam bas + autel vent roche plate + traces Fulgur griffes Luxray bs_plant jaune

Piocher exclusivement dans sources validées : DumpAsset, PMDODump, RawAsset (Content/Objects/*.png attestés listés dans audit).

Vérifier walkable : chaque case objet distinctif 100% walkable ou décoration hors collision, jamais bloquante sortie.

#### Étape 3 — Adapter disposition camp à topographie réelle

Interdit : plan fixe recopié. Obligatoire : disposition adaptée topo réelle du lieu.

Questions :

- D'où vient vent ? → camp à l'abri vent
- Où est formation distincte ? → camp adossé ou autour, pas dessus
- Où est entrée/sortie ? → entrée sud pente douce, sortie nord étroite si approche boss (tension §6)

Exemples :

- vast_steppe : camp adossé sud Mère-Roche (abri vent nord), feu derrière roche, pas centre, sacs est zone sèche, Kangaskhan ouest accessible 668,256
- mount_windswept : camp en L le long paroi ouest, feu coin abrité ouest, sacs creux L, Kangaskhan 176,352 accessible, entrée sud lacet x=256, sortie nord corniche étroite
- cloven : rectangulaire parfait symétrie bâtisseurs, camp centre géométrique exact, sacs 4 coins cardinaux ordre militaire, Kangaskhan centre exact 196,400
- crystal : cercle autour cristaux muets (respect), feu petit bord (peur fondre glace), sacs écart reflets
- forgotten : ovalaire suivant racines berceau, Kangaskhan centre îlot seul endroit sûr, feu surélevé pierre pas dans vase
- celestial : ligne contre paroi nord abri vent sud, feu ancré pierres lourdes, Kangaskhan face vide regarde nuages

Vérifier via `tools/verify_scene_positions.py` : spawners walkables + connectés entrée + objets atteignables.

#### Étape 4 — Poser fonctions gameplay systématiques

Indépendamment unicité visuelle, tous relais partagent mêmes fonctions prévisibles fiables joueur :

- Restauration PP et estomac via Kangaskhan_Rock (GeneralFunctions.Kangashkhan_Rock_Interact)
- Stockage + équipe
- Possibilité croiser Pokémon sauvages inoffensifs aux abords, faune cohérente biome traversé à endroit précis

Implémentation :

- `Kangaskhan_Rock_Action` → `GeneralFunctions.Kangashkhan_Rock_Interact`
- TeamSpawnZoneStep thématique : steppe → Taillow, Shinx; montagne → Wingull, Swablu; ruines → Baltoy, Bronzor; cristal → Carbink, Snom; marais → Croagunk, Toxel, Grimer; pic → Swablu, Wingull, Drifloon
- Particules : Ash_Fall (tunnel), Snow_Fall légère (mont), Leaf_Fall bleutée (cristal), Bubble (marais)

#### Étape 5 — Cohérence cinématique

Si cinématique se déclenche à relais, décor doit correspondre exactement identité visuelle propre — jamais fond générique qui ignore détails distinctifs.

Vérifier dans Lua `FirstArrival` :

- Caméra glisse d'abord sur élément distinctif, pas sur duo
- Dialogue mentionne élément distinctif visible (Mère-Roche, Épine, socle vide, cristaux muets, îlot racines, mer nuages)
- Pas de décalage texte/décor (ex: cloven ancien disait "dalles dorées" mais map ne montrait pas → ÉCHEC, corrigé)

#### Étape 6 — Dernier relais avant arène boss

Doit particulièrement porter tension approche finale (cf. arenas_boss_arc_tournoi.md). C'est souvent relais qui doit plus clairement annoncer par décor nature combat à venir.

Exemples :

- celestial_peak_relay → vide sous pieds + vent SE5 + traces Fulgur → annonce Lugia ciel + jugement
- mount_windswept_midpoint → corniche effondrée + Épine + drapeau déchiré → annonce Aerodactyl gardien sommet qui utilisait vent
- cloven_ruins_midpoint → dalles convergentes + socle vide → annonce Regigigas + trio

#### Étape 7 — Registre anti-duplication + auto-questionnement

Avant validation, entrer dans registre `docs/registre_relais_uniques_biomes.md` :

- Donjon, position progression, biome exact, éléments distinctifs, disposition camp, trace narrative, faune

Puis 6 questions §8 :

1. Ce relais a-t-il au moins un élément distinctif absent de tous autres ?
2. Sa position dans progression biome segment est-elle visuellement lisible (on comprend qu'on est entre tel biome et tel autre) ?
3. Disposition camp est-elle adaptée topo réelle lieu, ou plan générique recopié ?
4. Fonctions gameplay (PP, estomac, rencontres inoffensives) sont-elles bien présentes fonctionnelles ?
5. Une cinématique déclenchée à ce relais correspondrait-elle exactement à son décor propre ?
6. Ce relais a-t-il été comparé au registre déjà existants pour écarter risque duplication ?

Si une révèle incohérence ou ressemblance non justifiée avec relais déjà existant, relais n'est pas terminé.

---

### 3. Ce qui est interdit

- Réutiliser telle quelle disposition relais déjà construit ailleurs, même en changeant seulement tileset
- Un relais neutre qui pourrait être déplacé dans n'importe quel autre donjon sans que rien paraisse incohérent
- Un point médian dont seul rôle est fonctionnel (restauration) sans aucune identité visuelle propre
- Générer relais aléatoirement (doit être point fixe construit main)

### 4. Validation

```bash
python3 tools/verify_scene_positions.py --relay vast_steppe_midpoint
python3 tools/validate_all.py --relays-only
```

Critères : spawners nommés, walkables, connectés entrée, objets interactifs accessibles, 0 MapChar hérité, 0 problème spatial, élément distinctif présent et unique.

*— Outil vivant, à mettre à jour avec chaque nouveau relais —*
