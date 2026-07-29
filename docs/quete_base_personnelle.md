# Quête annexe — Construction de la base personnelle

> Adaptation de la quête du Bois Brouhaha (Uproar Forest) de PMD
> Red/Blue Rescue Team. Analyse de pret/pmd-red et ExplorersOfSkyOrigins.

---

## Principe

Le duo Okéoké/Qulbutoké est à l'origine de la construction de la base
du joueur, avec l'aide de Pokémon recrutés (Chenipan et les anciens
adversaires du donjon). La quête est un moment de respiration comique
au milieu de la trame principale.

## Condition de déblocage

**Moment narratif** : après le chapitre 7 (retour des Ruines Tordues).
Le héros a purifié son premier Cœur d'Anima. Penticus décide que
l'équipe mérite un espace personnel à la guilde — une vraie base,
pas juste un dortoir partagé.

**Jalon** : `SV.Chapter7.DefeatedRuinsBoss = true` + au moins 10
missions secondaires accomplies (vérifié via `SV.adventure.Rescues`).

## Structure en 6 actes

### Acte 1 — L'annonce (guilde, ~20 dialogues)

Penticus annonce au héros qu'un terrain est disponible derrière la
guilde pour construire une base personnelle. Il envoie le héros voir
« les spécialistes de la construction » au café — Okéoké et Qulbutoké.

### Acte 2 — Le recrutement (café, ~30 dialogues)

Au café, Qulbutoké explique (via Okéoké) que pour construire une base,
il faut des matériaux spécifiques qui se trouvent dans un donjon voisin.
Ce donjon est le Bois Brouhaha (ou son équivalent New Era).

**Complication** : le bois est occupé par un groupe de Pokémon sauvages
bruyants qui empêchent quiconque d'approcher. Il faut les calmer (ou
les vaincre) pour récupérer les matériaux.

### Acte 3 — Le donjon (gameplay, ~5-8 étages)

Traversée du donjon. Boss de fin : trio de Pokémon bruyants (équivalent
des Grahyèna/Mankey de l'original).

**Adaptation New Era** : les boss du Bois Brouhaha sont des Pokémon
insecte/plante du biome forestier — un Papilusion énervé, un Chenipan
territorial, et un Boustiflor qui hurle quand on approche de ses fleurs.

**Justification narrative** (directive boss) : ces Pokémon ne sont pas
méchants — ils protègent leur territoire parce qu'un événement récent
(la corruption d'un Cœur voisin) les a rendus anxieux. Le combat est
un malentendu, pas une guerre.

### Acte 4 — La construction (base, ~40 dialogues)

Après le donjon, les matériaux sont rapportés. La construction commence :

1. **Qulbutoké dirige** (en « Qulbutoké ! » qu'Okéoké traduit en
   instructions de chantier)
2. **Chenipan** (recruté du donjon) transporte des feuilles et du bois
3. **Les anciens adversaires** (Papilusion, Boustiflor) participent
   à contrecœur — ils sont « en gage de bonne foi »
4. **Le partenaire** aide physiquement (coroutines de transport)

**Scène collective mise en scène** : chaque PNJ a ses animations,
ses déplacements, ses réactions. Pas un écran de transition silencieux.

### Acte 5 — La complication comique (~30 dialogues)

**Adaptation de la grève des Mankey** : à mi-chantier, Boustiflor
s'arrête de travailler. Il exige des Baies Sucrées comme paiement
supplémentaire — « ses fleurs ont besoin de sucre pour produire de
la résine de qualité ».

Okéoké traduit la frustration de Qulbutoké : « Qulbutoké dit que
c'est du chantage. »

Le héros doit trouver des Baies Sucrées (soit dans l'inventaire,
soit en allant au marché de Kecleon). Quand il revient, Boustiflor
est ravi et reprend le travail avec enthousiasme.

**Ton** : comique léger, cohérent avec les scènes de Ganlon/Shuca
déjà écrites. Pas de moquerie cruelle — Boustiflor est sincère dans
sa demande, il a vraiment besoin de sucre.

### Acte 6 — L'inauguration (~20 dialogues)

La base est terminée. Penticus vient l'inaugurer. Chaque PNJ présent
a une réplique. Le partenaire fait visiter les lieux au héros.

**Réintégration dans la trame principale** : pendant l'inauguration,
un PNJ apporte une nouvelle urgente — un rapport sur le prochain
Cœur qui faiblit (préparation du chapitre 8). La quête annexe se
termine, la trame principale reprend.

## PNJ impliqués

| PNJ | Rôle | Personnalité |
|---|---|---|
| Penticus | Commanditaire | Bienveillant, autoritaire |
| Qulbutoké | Chef de chantier | « Qulbutoké ! » (Okéoké traduit) |
| Okéoké | Interprète | Enthousiaste, sautille en parlant |
| Chenipan | Transporteur | Timide, courageux malgré sa taille |
| Papilusion | Ancien adversaire | Fier, participe à contrecœur |
| Boustiflor | Gréviste comique | Gourmand, dramatique |
| Partenaire | Aide physique | Déterminé, s'amuse de la situation |

## Intégration technique

- **Base** : ground `hero_base` (nouveau, construit à partir du
  template `guild_heros_room` avec des éléments ajoutés)
- **Donjon** : zone `bois_brouhaha` (nouveau, biome forêt, 5-8 étages)
- **Boss** : trio Papilusion/Chenipan/Boustiflor, justifiés narrativement
- **Progression** : la base s'améliore par étapes (pas tout d'un coup)
  au fur et à mesure des chapitres suivants

## Auto-questionnement

- [ ] L'équivalent New Era du combat respecte-t-il la justification narrative ?
- [ ] La reconstruction est-elle un moment collectif mis en scène ?
- [ ] La complication comique est-elle cohérente avec le ton du projet ?
- [ ] La reprise de la trame principale est-elle fluide ?
- [ ] La base s'intègre-t-elle au monde vivant ?
