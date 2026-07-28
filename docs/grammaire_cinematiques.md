# Grammaire des cinématiques — analyse des sources et application à New Era

Build `2026-07-31-P`

---

## 1. Le diagnostic, avant toute création

Avant d'écrire quoi que ce soit, j'ai mesuré la densité narrative réelle de
chaque chapitre (nombre de boîtes de dialogue, commentaires exclus) :

| Chapitre | Boîtes | Fichiers de scène |
|---|---|---|
| 1 | 633 | 13 |
| 2 | 577 | 18 |
| 3 | 573 | 20 |
| 4 | 442 | 19 |
| 5 | **1229** | 25 |
| 6 | 105 | 5 |
| 7 | 115 | 5 |
| 8 | **71** | 2 |
| 9 | **52** | 2 |
| 10 | **53** | 2 |

**Le déséquilibre est d'un facteur 10 à 20.** Les chapitres 8, 9 et 10 n'ont
que deux fichiers chacun : la chambre et la ville. Ni entrée de donjon
scénarisée, ni relais, ni arène mise en scène — alors que **les grounds
existent tous** (`crystal_sanctuary_entrance`, `forgotten_marsh_relay`,
`celestial_peak_entrance`…), avec un `init.lua` réduit à `GAME:FadeIn(20)`.

C'est là, et seulement là, que le besoin était prouvé. Le reste de ce document
part de ce constat.

---

## 2. Ce que j'ai analysé dans les sources

### Fichiers réellement ouverts

| Dépôt | Fichier | Ce qu'il enseigne |
|---|---|---|
| ExplorersOfSkyOrigins | `ground/beach/init.lua` | arrivée sur un lieu, malaise du héros, sortie synchronisée |
| ExplorersOfSkyOrigins | `ground/storm_cutscene_a/init.lua` | vision, éclairs stroboscopiques, bascule en coroutines |
| ExplorersOfSkyOrigins | `ground/chapter_card/init.lua` | carton-titre, aiguillage de progression |
| ExplorersOfSkyOrigins | `ground/guild_bedroom_night/init.lua` | veillée, script GBA conservé en commentaire |
| ExplorersOfSkyOrigins | `CharacterActions.lua` | `DizzyFade`, `ShakeHead`, `ScaredJump`, `Explain` |
| pret/pmd-red | `data/scripts/` | structure des cinématiques d'ouverture |

EoS Origins tourne **sur le même moteur que nous**. Son code est directement
transposable, contrairement à l'assembleur GBA de `pmd-red`.

### La grammaire extraite

**a) On établit le lieu avant les personnages.**
Dans `beach`, le son d'ambiance monte, *puis* 60 frames passent, *puis*
quelqu'un parle. Le joueur entend le lieu, le voit, et seulement ensuite on
lui adresse la parole.

**b) Le dialogue va du concret à l'abstrait.**
Constat sensoriel → réaction affective → décision d'avancer. Jamais l'inverse.
On ne commente pas l'enjeu avant d'avoir décrit ce qu'on a sous les yeux.

**c) La caméra suit le sujet du discours.**
Elle cadre le décor pendant qu'on le décrit, puis redescend sur le duo au
moment de la décision. Le mouvement accompagne le changement de sujet.

**d) Rien ne « coupe » : tout s'éteint ensemble.**
Le patron `BranchCoroutine` × 3 + `JoinCoroutines` synchronise fondu d'image,
réplique et fondu sonore sur la *même* durée.

**e) Le geste remplace la réplique.**
Sky fait parler les corps : un pas de côté, un hochement de tête, un sursaut.
`CharacterActions` existe uniquement pour ça.

---

## 3. Ce qui a été créé

### `Data/Script/halcyon/ChapterScenes.lua`

Trois scènes d'arrivée, une par chapitre orphelin. **Chacune a une identité
distincte** — c'était une exigence explicite :

| Ch. | Lieu | Registre | Ouverture | Ressort |
|---|---|---|---|---|
| 8 | Sanctuaire de Cristal | **contemplation** | une cascade *silencieuse* | la beauté inquiète parce qu'elle est trop parfaite |
| 9 | Marais de l'Oubli | **malaise physique** | une *odeur* avant la vue | la menace est déjà passée par là |
| 10 | Pic Céleste | **adrénaline** | le *vent* qui frappe de côté | les rivaux ont de l'avance et savent où aller |

Aucune n'ouvre, ne se termine ni ne respire de la même façon.

**Chapitre 8 — le silence comme anomalie**
> « Écoute...[pause] Non. N'écoute pas. Il n'y a RIEN à écouter. »
> « Je ne vois pas une bibliothèque. Je vois un endroit qu'on a fermé.
> Et le silence, c'est le couvercle. »

**Chapitre 9 — la peur admise, et le geste qui la dit**
Le partenaire fait un pas *vers* le héros avant de parler — `MoveInDirection`,
pas une réplique.
> « ...Je peux rester près de toi ? C'est bête, je sais. »
> → « (Ce n'est pas bête. Je l'allais demander.) »

**Chapitre 10 — les rivaux qu'on entend sans les voir**
> « Le vent apporte un éclat de voix. Un rire, peut-être. Puis plus rien. »
> « Pourquoi est-ce qu'ils montent SI vite ? Ils ne cherchent pas. Ils SAVENT
> où aller. » → « (Quelqu'un leur a dit. Ou quelque chose.) »

Cette dernière réplique n'est pas gratuite : elle prépare la révélation du
chapitre 10 sans la livrer.

### `DizzyFade` intégré aux visions

`CharacterActions.DizzyFade()` est **l'effet des Cris Temporels** de Sky : un
voile noir semi-transparent (alpha 128) en `RepeatX`/`RepeatY`.

Le `RepeatX/RepeatY` est le point important : un `FlashEmitter` ponctuel ne
couvre qu'une zone autour de son point d'émission — c'était le défaut de ma
première version, déjà rencontré sur la brume du Tunnel Ardent. L'overlay
répété couvre l'écran quelle que soit la taille de la carte.

Ajouté comme `VoiceVisions.DizzyVeil()`, appelé automatiquement dès que la
nausée atteint le niveau 2.

---

## 4. Cohérence vérifiée

- **Aucun nom interdit** dans les 31 répliques (contrôle automatisé).
- **La Voix reste anonyme.**
- **Chronologie respectée** : le ch10 évoque l'avance de Fulgur, déjà établie ;
  le ch9 montre les traces du Cercle du Suaire, introduit au ch9 côté donjon.
- **Longueur des boîtes** : la plus longue fait 109 caractères (limite ~150).
- **Format des fonds** : `verify_bg_format.py` — aucun bug.
- Rejouabilité : les scènes sont gardées par `PlayedArrivalScene`, avec
  rattrapage `OnUpgrade` pour les sauvegardes en cours.

---

## 5. Résultat mesuré, et ce qui reste à faire

| Ch. | Avant | Après |
|---|---|---|
| 8 | 71 | ~81 |
| 9 | 52 | ~70 |
| 10 | 53 | ~71 |

**Soyons clairs : c'est une amélioration, pas une égalisation.** Les chapitres
8-10 restent très en dessous des chapitres 1-5. Ce lot pose les *scènes
d'arrivée* — le maillon le plus visiblement absent — mais il manque encore,
pour chacun de ces trois chapitres :

- une scène de **relais mi-donjon** avec dialogue de progression ;
- une scène **d'après-boss** (les arènes enchaînent directement) ;
- des **PNJ de ville réactifs** à l'avancement intra-chapitre ;
- pour le ch6, rien n'a été fait dans ce lot (105 boîtes, à traiter aussi).

Atteindre la densité des chapitres 1-5 demanderait plusieurs lots de cette
taille. Je préfère l'annoncer que le laisser croire.

---

## 6. Non vérifié

**Rien n'est testé en jeu.** En particulier :

- Les **coordonnées de caméra** (`camera`, `focus`) sont posées d'après les
  conventions des autres grounds, **sans avoir ouvert les `.rsground`
  correspondants**. Le cadrage peut tomber à côté du décor voulu.
- Le `MoveInDirection` du partenaire au ch9 suppose de la place libre à sa
  droite — non vérifié sur la carte.
- Les musiques (`Crystal Crossing`, `Dark Hill`, `Sky Peak Prairie`) existent
  bien, mais leur justesse de ton n'a pas été jugée à l'écoute.
