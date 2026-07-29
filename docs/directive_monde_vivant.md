# Directive — Monde vivant : Metano Town, raids, PNJ variables

> Intégrée le 2026-07-29. Document lié à `PROMPT_MAITRE.md`.

---

## État actuel du système (audit 2026-07-29)

Le projet dispose déjà d'un système de ville vivante conséquent :

| Module | Lignes | Rôle |
|---|---|---|
| `TownRaid.lua` | 368 | Mécaniques de raid nocturne |
| `RaidScenes.lua` | 410 | Cinématiques victoire/défaite raid |
| `TownNight.lua` | 446 | Système de nuit (3 PNJ uniques) |
| `TownNightScenes.lua` | 357 | Scènes nocturnes |
| `TownPlunder.lua` | 261 | Pillage en cas de défaite raid |
| `NightWatch.lua` | 290 | Ronde de nuit, tirage des raids |
| `TownReward.lua` | 299 | Récompenses de raid |
| `TownVoices.lua` | 357 | Dialogues PNJ de jour |
| `TownVoicesLate.lua` | 787 | Dialogues PNJ post-histoire |
| `TownVoicesNight.lua` | 361 | Dialogues PNJ de nuit |
| **Total** | **3,936** | — |

### Rondoudou (Plum) — état actuel

- Défini dans `CharacterEssentials.lua:202` comme `Jigglypuff` (nickname `Plum`)
- Dispatch dans `metano_town/init.lua:2727` vers les handlers par chapitre
- Dialogues dans `TownVoices`, `TownVoicesLate`, `TownVoicesNight`
- Apparaît dans `guild_second_floor` et `guild_bottom_right_bedroom`
- **Problème identifié** : position dans le shop libre à vérifier/corriger

---

## 1. Amélioration du système de raid

- Auditer intégralement le déroulement d'un raid (déclenchement, montée en
  difficulté, mise en scène d'entrée et de fin, récompenses)
- Appliquer les exigences de mise en scène du PROMPT_MAITRE
- Corriger toute incohérence avant d'ajouter de nouvelles fonctionnalités
- Cohérence avec la progression narrative (conception_donjons_segmentes.md)

## 2. Rondoudou dans le shop libre

- Positionné dans le shop libre, pas rattaché à un PNJ figé
- **Interactif** : le joueur peut engager une interaction (dialogue, service)
- Ne bloque pas la circulation, ne se superpose pas à un autre PNJ
- Traiter le bug d'audit « présence et cinématique d'introduction » en même temps

## 3. PNJ à position variable dans le temps

- Chaque PNJ significatif peut occuper une position différente d'un jour à l'autre
- La variation reste cohérente avec le rôle du PNJ
- Chaque changement de position renforce l'impression de vie propre

### Implémentation proposée

Un système de **positions alternatives** dans `TownVoices.lua` ou un module
dédié (`TownPositions.lua`) :

```lua
-- Table de positions par PNJ et par jour (modulo DaysPassed)
TownPositions = {
  Kecleon_Green = {
    {x=480, y=360, dir=Direction.Down},  -- position A (étal)
    {x=520, y=400, dir=Direction.Left},  -- position B (place)
    {x=460, y=340, dir=Direction.Right}, -- position C (près du feu)
  },
  -- etc.
}

function TownPositions.Get(npc_name)
  local day = SV.ChapterProgression.DaysPassed or 0
  local positions = TownPositions[npc_name]
  if not positions then return nil end
  return positions[(day % #positions) + 1]
end
```

## 4. Dialogues variables selon les événements récents

- Chaque PNJ a un dialogue différent selon les événements de la trame
- Un événement marquant se répercute sur ce que les PNJ ont à dire
- Cohérent avec la Règle 9 (personnalité, connaissances)

**Déjà implémenté** : le système `TownVoices` / `TownVoicesLate` /
`TownVoicesNight` gère déjà les dialogues par chapitre et par moment
de la journée. L'amélioration porte sur la granularité (événements
spécifiques, pas seulement le numéro de chapitre).

## 5. Metano Town comme ville vivante

- PNJ occupant la ville de façon crédible selon le moment (cycle jour/nuit)
- Scènes de vie courante en arrière-plan
- Cohérence entre position, dialogue et événements récents

## 6. Principe général

Cette liste est un point de départ, pas une limite. Appliquer la même
exigence à tout ce qui peut renforcer l'impression d'un monde vivant.

---

## Auto-questionnement

- [ ] Ce PNJ a-t-il une raison logique d'être à cette position maintenant ?
- [ ] Son dialogue reflète-t-il les événements récents ?
- [ ] Rondoudou et les PNJ de shop sont-ils réellement interactifs ?
- [ ] Le raid respecte-t-il les standards de mise en scène ?
- [ ] Metano Town donne-t-elle l'impression d'un lieu vivant et cohérent ?

Si une case n'est pas cochée, l'élément n'est pas terminé.
