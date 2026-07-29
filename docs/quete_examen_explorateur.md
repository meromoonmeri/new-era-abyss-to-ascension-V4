# Quête annexe — Examen d'Explorateur

> Conception détaillée pour New Era. Basée sur l'analyse d'ExplorersOfSkyOrigins
> (café de Spinda, Qulbutoké/Okéoké) et adaptée à l'univers de New Era.

---

## Principe

La progression de badges de la Guilde sert de condition de déblocage.
Une fois le badge requis obtenu, une cinématique au café de Spinda
débloque l'accès à un nouveau donjon.

## Condition de déblocage

**Badge requis** : Rang Argent (obtenu après le chapitre 5 — retour
d'expédition du Mont Venteux).

**Moment narratif** : entre le chapitre 6 et le chapitre 7. Le joueur
a prouvé sa valeur lors de l'expédition. La Fédération des Explorateurs
le reconnaît et lui donne accès à des donjons plus dangereux.

## PNJ impliqués

| PNJ | Rôle | Personnalité |
|---|---|---|
| **Spinda** | Tenancier du café | Accueillant, distrait, tourne en rond |
| **Qulbutoké** | Représentant Fédération | Parle en répétant « Qulbutoké ! » — convention officielle reprise |
| **Okéoké** | Assistant de Qulbutoké | Pré-évolution, traduit ce que Qulbutoké « veut vraiment dire » |

### Décision : mode d'expression de Qulbutoké

New Era reprend la convention officielle : **Qulbutoké ne dit que
« Qulbutoké ! »** (avec des variations d'intonation). Okéoké sert
d'interprète — c'est lui qui « traduit » pour le joueur.

Ce duo fonctionne comme un gag récurrent : le joueur finit par
comprendre les intonations de Qulbutoké, et Okéoké confirme ou corrige
sa compréhension. C'est cohérent avec le ton léger des scènes de café
dans PMD.

## Structure de la quête

### Acte 1 — L'invitation

**Déclenchement** : après avoir obtenu le Rang Argent, un PNJ de
Metano Town (Kecleon vert, par exemple) mentionne que « quelqu'un
cherche le héros au café ».

**Au café** :
1. Spinda accueille le joueur, tournant en rond comme à son habitude
2. Il indique une table au fond où Qulbutoké et Okéoké attendent
3. Cinématique d'approche : le duo se tourne vers le héros en arrivant

### Acte 2 — L'examen

**Qulbutoké pose trois questions** (en « Qulbutoké ! ») qu'Okéoké traduit :

1. **« Qulbutoké ! Qulbu... toké ? »**
   → Okéoké : « Il demande : pourquoi êtes-vous devenu explorateur ? »
   → Choix du joueur (3 options, chacune avec une réaction différente)

2. **« Toké toké ! Qulbutoké ! »**
   → Okéoké : « Il demande : que feriez-vous si votre équipe était en danger dans un donjon ? »
   → Choix du joueur (3 options)

3. **« ...Qulbutoké. »** (dit doucement, presque tristement)
   → Okéoké : « Il demande... si vous savez ce que signifie perdre quelqu'un en mission. »
   → Réponse unique, plus grave (pas de choix — le héros répond honnêtement)

### Acte 3 — La validation

Qulbutoké hoche la tête, se lève, et remet un objet symbolique
(une carte, un laissez-passer). Okéoké explique que la Fédération
reconnaît le héros comme Explorateur Qualifié.

**Déblocage** : le donjon associé (un donjon secondaire de difficulté
moyenne, cohérent avec le Rang Argent) devient accessible.

**Réaction mise en scène** : le partenaire réagit à la nouvelle,
pas un simple changement silencieux de variable.

## Cinématique — détails techniques

- **Lieu** : café de Spinda (ground `spinda_cafe` ou zone Metano adaptée)
- **Musique** : thème de café (existant dans le projet)
- **Durée** : ~3-4 minutes, ~60-80 dialogues
- **Staging** : Qulbutoké et Okéoké ne restent PAS figés — ils se
  tournent vers le héros, Okéoké sautille en traduisant, Qulbutoké
  hoche la tête à chaque réponse
- **Pas de Voix** dans cette scène (usage restreint, directive boss/Voix)

## Intégration narrative

Cette quête n'est PAS un aparté : elle renforce le thème du chapitre
(la reconnaissance de la guilde après l'expédition) et prépare les
chapitres suivants (accès à des donjons plus difficiles = montée en
puissance cohérente).

Le donjon débloqué doit :
- Être dans un biome cohérent avec la progression (pas un donjon de
  fin de jeu accessible au Rang Argent)
- Avoir sa propre identité visuelle (conception_donjons_segmentes.md)
- Contenir un boss/mini-boss justifié narrativement (directive_boss.md)

## Auto-questionnement

- [ ] L'analyse d'ExplorersOfSkyOrigins a-t-elle été faite avant l'écriture ?
- [ ] Qulbutoké et Okéoké réagissent-ils dynamiquement ?
- [ ] Le mode d'expression de Qulbutoké est-il cohérent partout ?
- [ ] Le déblocage est-il mis en scène (pas silencieux) ?
- [ ] Le donjon débloqué est-il cohérent avec la progression ?
