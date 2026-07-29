# Directive — Boss & mini-boss : justification narrative et usage de la Voix

> Intégrée le 2026-07-29. Complète `directive_arenes_boss_tournoi.md`
> (implantation physique des arènes) en traitant du **pourquoi** de
> chaque affrontement et de la place de la Voix dans la narration.

---

## Principe : aucun boss ni mini-boss gratuit

Un boss ou mini-boss n'est jamais un simple mur de statistiques.
Chaque affrontement doit avoir **une histoire**, une raison d'exister
à cet endroit précis, à ce moment précis.

### Avant de placer un boss ou mini-boss, définir :

1. **Qui est-il ?** Personnalité, origine, liens avec l'histoire
2. **Pourquoi est-il ici ?** Garde un lieu, protège quelque chose,
   poursuit un but, a été placé là par un événement antérieur
3. **Que veut-il ?** Motivation, pas un script "attaquer le joueur"
4. **Enjeu pour le héros ?** Ce que le joueur gagne, apprend ou risque
5. **Que devient-il après ?** Vaincu/allié, disparu, épargné, fuite —
   chaque issue a une conséquence narrative

### Modèle de référence : Chartor au Searing Tunnel

Ce mini-boss doit avoir une raison logique d'être présent : garde d'un
passage, créature liée au lieu, obstacle posé par un événement antérieur.
Utiliser ce type de justification comme modèle pour tout mini-boss :
jamais "parce qu'il fallait un point de difficulté", toujours parce que
sa présence raconte quelque chose.

---

## La Voix : élément rare, pas outil par défaut

La Voix (speaker anonyme `\uE040`) doit redevenir **un élément narratif
rare**, réservé à des moments d'exception.

### Règles

- **Retirer** la Voix de toute scène de boss/mini-boss où sa présence
  n'est pas indispensable
- Une apparition doit se justifier par un lien direct avec la trame de
  l'Abîme ou l'enjeu central de l'histoire
- Si un boss peut être présenté sans la Voix, elle ne doit pas apparaître
- **La rareté fait le poids** : plus elle est utilisée, moins chaque
  apparition compte

### Audit en cours — occurrences de la Voix par boss

| Boss / Mini-boss | Occurrences \uE040 | Verdict |
|---|---|---|
| Searing Crucible (Magcargo + Slugma) | 6 | ⚠️ À auditer : la Voix est-elle indispensable ici ? |
| Vast Steppe guardian (Stantler) | 6 | ⚠️ À auditer |
| Cloven Ruins boss (Regigigas) | 6 | ✅ Justifié : lien direct Genèse/Abîme |
| Mount Windswept miniboss (Gligar/Skarmory) | 4 | ⚠️ À auditer : sentinelles, la Voix commente |
| Mount Windswept guardian (Aerodactyl) | 4 | ⚠️ À auditer : dernier gardien |
| Vast Steppe miniboss (Mudbray/Stantler) | 4 | ⚠️ À auditer |
| Searing Tunnel miniboss (Torkoal/Magmar) | 3 | ⚠️ À auditer |
| Gloomy Forest boss (Zarude) | 2 | ✅ Sobre, usage limité |

**Action requise** : pour chaque boss marqué ⚠️, vérifier si la Voix
peut être retirée ou remplacée par une mise en scène portée par les
personnages eux-mêmes (dialogue du boss, réaction de l'équipe,
environnement).

---

## Critères qualitatifs de scène

### Introduction du combat

- Rencontre amenée par une mise en scène cohérente avec le lieu
- Le joueur comprend pourquoi cet affrontement a lieu

### Personnalité en jeu

- Dialogues du boss reflètent sa personnalité (pas de répliques génériques)
- Langage corporel et animations traduisent son état d'esprit

### Mise en scène du combat

- L'arène sert le combat visuellement (cf. `directive_arenes_boss_tournoi.md`)
- Phases scriptées si le moteur le permet

### Conclusion et conséquences

- Issue mise en scène avec autant de soin que l'introduction
- Conséquences répercutées sur la suite (cf. `directive_structure_donjons_chapitres.md`)

### Cohérence

- Pas de contradiction avec des informations déjà établies
- Foreshadowing payé correctement

---

## Auto-questionnement avant validation d'une scène de boss

- [ ] Ce boss a-t-il une histoire et une raison d'être clairement définies ?
- [ ] Sa présence à cet endroit est-elle justifiée narrativement ?
- [ ] La Voix intervient-elle ? Si oui, est-elle indispensable ?
- [ ] Les dialogues reflètent-ils sa personnalité propre ?
- [ ] L'issue du combat a-t-elle une conséquence visible sur la suite ?

Si une case n'est pas cochée, la scène n'est pas terminée.
