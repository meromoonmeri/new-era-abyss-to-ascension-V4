# Directive — Structure narrative des donjons par chapitre (Ch. 6+)

> Intégrée le 2026-07-29, enrichie le 2026-07-29b.
> Document lié à `PROMPT_MAITRE.md`, `directive_arenes_boss_tournoi.md`,
> `directive_boss_justification_narrative.md`.

---

## RÈGLE PRINCIPALE — 3 à 5 donjons par chapitre

À partir du chapitre 6 inclus, chaque chapitre contient **entre 3 et 5
donjons**. Ce n'est pas une contrainte arbitraire : c'est une règle de
rythme narratif.

- Moins de 3 : l'arc narratif manque de matière
- Plus de 5 : la tension se dilue sans justification

**Exception** : si la fourchette est dépassée, la raison doit être
documentée explicitement.

**Non rétroactif** : ne pas modifier les chapitres 1 à 5 pour les faire
rentrer dans ce cadre.

---

## Fonction narrative obligatoire pour chaque donjon

Aucun des 3 à 5 donjons ne doit être un donjon « de remplissage ».
Avant de placer un donjon, définir explicitement :

1. Ce qu'il apporte à l'intrigue principale ou secondaire
2. Ce que les personnages apprennent, vivent ou perdent
3. En quoi la situation change en sortant (information, allié, obstacle,
   révélation, objet clé)

Si aucune réponse satisfaisante → retravailler ou retirer le donjon.

---

## Progression en 3 temps

| Position | Rôle | Poids narratif |
|---|---|---|
| Donjon(s) d'ouverture | Pose l'enjeu, introduit lieu/personnage/menace | Moyen |
| Donjon(s) intermédiaire(s) | Développe, complique, twist partiel | Croissant |
| Donjon final | Point culminant, boss, conclusion/ouverture | Maximum |

Le donjon final = point de difficulté le plus élevé du chapitre
(Floor Generation, Spawn Tables, niveaux ennemis cohérents).

---

## Exigences narratives

### Twists

Au moins un retournement par chapitre, préparé en amont par du
foreshadowing. Un twist ne contredit jamais une information établie sans
justification narrative explicite (fausse piste volontaire,
recontextualisation).

### Foreshadowing traçable

Chaque chapitre doit :
- Payer du foreshadowing posé antérieurement
- Semer des éléments pour des chapitres futurs ou l'end-game

Suivi dans `docs/foreshadowing.md`.

### Trame principale vs trames secondaires

La trame principale avance de façon lisible. Les trames secondaires
enrichissent sans reléguer ni contredire.

### Lore Pokémon

Mobiliser le lore sans jamais contredire les règles narratives
permanentes (Règle 12 du PROMPT_MAITRE).

---

## Exigences cinématiques par donjon

Appliquer intégralement les règles de `PROMPT_MAITRE.md` :

- **Cinématique d'entrée** : pourquoi les personnages pénètrent ce donjon
- **Événement(s) intermédiaire(s)** : révélation ou rencontre matérialisée
- **Cinématique de fin/boss** : arène cohérente (cf. `directive_boss_justification_narrative.md`)
- **Transitions** : timing fondu, cohérence son/image, sans flottement

---

## Qualité de la langue française

Tout texte doit être rédigé en français idiomatique, jamais calqué sur
une syntaxe anglaise. Reformuler entièrement si besoin.

**Résidus d'anglais** : tout texte encore en anglais (dialogues,
interfaces, descriptions) doit être identifié et traduit. Aucun résidu
anglais ne doit subsister dans le contenu final.

Règle 8 du PROMPT_MAITRE : clés EN dans `strings.resx`, clés FR dans
`strings.fr.resx`. Ne jamais coder du texte en dur dans le Lua.

---

## Écran d'ouverture de chapitre

Chaque chapitre s'ouvre sur un écran de présentation dédié :

- **Fond plein écran** : image représentative du chapitre (lieu clé,
  ambiance, thème narratif)
- **Filtre assombrissant** : pour la lisibilité du titre et la tonalité
  cinématographique
- **Titre du chapitre en français** : traduction idiomatique et soignée,
  jamais un titre laissé en anglais ou traduit littéralement

Chaque chapitre a sa propre image de fond, distincte des autres, pensée
comme une **promesse visuelle** de ce que le chapitre va raconter.

---

## Auto-questionnement avant validation (Ch. 6+)

- [ ] 3 à 5 donjons (ou exception documentée) ?
- [ ] Chaque donjon a une fonction narrative claire ?
- [ ] Progression de poids narratif et de difficulté cohérente ?
- [ ] Pose ET/OU paie du foreshadowing ?
- [ ] Twist préparé en amont ?
- [ ] Cinématiques pour chaque donjon à enjeu (entrée, intermédiaire, fin) ?
- [ ] Donjon final = point culminant avec arène cohérente ?
- [ ] Cohérence trame principale + règles permanentes ?
- [ ] Français idiomatique, sans résidu d'anglais ?
- [ ] Écran d'ouverture avec image dédiée, filtre, titre FR ?
- [ ] Branches victoire ET défaite pour chaque boss ?
- [ ] `git diff --stat` : uniquement les fichiers du périmètre ?

Si une case n'est pas cochée, le chapitre n'est pas terminé.
