# Mécanique de combat — Courants de vent de Boréas (Tornadus)

> Analyse technique PMDO + implémentation des zones de vent pendant le combat.
> Basé sur l'audit du système de lave de Heatran et des capacités du moteur.

---

## Analyse technique — Ce qui est possible

### Système de lave de Heatran (référence)

Le système de lave utilise `ObjAnimData` placé comme `GroundAnim` sur
`Decorations[0].Anims`. C'est un système **purement visuel** — les cases
de lave n'ont aucun effet de gameplay (pas de dégâts, pas de poussée).

```lua
-- Système lave (searing_crucible_ch_5.lua)
local lava_pool = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Lava_Pool_Connected', 4)
GAME:GetCurrentGround().Decorations[0].Anims:Add(
    RogueEssence.Ground.GroundAnim(lava_pool, RogueElements.Loc(x, y)))
```

**Limitation** : `GROUND:` fonctions sont en **mode sol** (ground mode).
Pendant un combat de donjon, le jeu est en **mode donjon** (dungeon mode).
Les fonctions `GROUND:` ne fonctionnent PAS pendant les combats.

### Fonctions disponibles pendant les combats de donjon

| Fonction | Effet | Utilisable en combat |
|---|---|---|
| `_DUNGEON:AddMapStatus(status)` | Ajoute un effet visuel sur la carte | ✅ OUI |
| `_DUNGEON:RemoveMapStatus(status)` | Retire un effet visuel | ✅ OUI |
| `chara:AddStatusEffect(nil, status, visible)` | Ajoute un effet de statut | ✅ OUI |
| `_DUNGEON:PointWarp(chara, loc, showMsg)` | Téléporte un personnage | ✅ OUI |
| `_DUNGEON:ProcessBattleFX(chara, target, fx)` | Effet visuel de combat | ✅ OUI |
| `BattleScriptEvent("nom")` | Déclenche un dialogue | ✅ OUI |
| `GROUND:AnimateInDirection` | Pousse un personnage | ❌ NON (ground mode) |
| `GROUND:MoveScreen` | Secousse la caméra | ❌ NON (ground mode) |
| `BossFX.PushBack` | Pousse plusieurs personnages | ❌ NON (utilise GROUND:) |

### Conclusion technique

**Le déplacement forcé de personnages pendant un combat de donjon n'est
pas directement possible** avec les fonctions de poussée directionnelle
(`PushBack`, `AnimateInDirection`). Ces fonctions sont en mode sol.

**L'alternative stable** : utiliser `_DUNGEON:PointWarp` pour déplacer
les personnages à des positions spécifiques (simulant l'effet du vent),
combiné avec `AddMapStatus` pour les effets visuels de vent.

---

## Mécanique implémentée — Courants de vent de Boréas

### Principe

Les courants de vent sont représentés par :
1. **MapStatus visuels** ajoutés pendant le combat (vent, particules)
2. **Déclenchement aux seuils de PV** via `BattleScriptEvent`
3. **Dialogues de Tornadus** à chaque phase
4. **Effets visuels** via `ProcessBattleFX` et `AddMapStatus`

### Phases de combat

| Phase | PV Tornadus | Effet | Dialogue |
|---|---|---|---|
| 1 — Domination | 100-75% | Vent léger (MapStatus blowing_wind) | MWG_080 |
| 2 — Reconnaissance | 75-50% | Vent fort + ScreenShake via BattleFX | MWG_081 |
| 3 — Défi | 50-25% | Tempête + PointWarp (repousse héros) | MWG_082 |
| 4 — Dernier souffle | 25-0% | Ouragan + tous les effets combinés | MWG_083 |

### Implémentation dans event_battle.lua

Le système utilise le pattern existant de vérification de PV :
```lua
local ratio = target.HP * 100 // target.MaxHP
```

À chaque seuil (75%, 50%, 25%), un `BattleScriptEvent` est déclenché
qui appelle la fonction correspondante dans un nouveau module
`TornadusBattle.lua`.

---

## Module TornadusBattle.lua

### Fonctions principales

```lua
TornadusBattle = {}

-- Phase 1 (75% PV) : vent léger
function TornadusBattle.Phase1_WindRise()
  -- Ajoute MapStatus blowing_wind
  -- Dialogue MWG_080
  -- Effet visuel léger
end

-- Phase 2 (50% PV) : vent fort
function TornadusBattle.Phase2_WindStorm()
  -- Ajoute MapStatus clouds_overhead
  -- Dialogue MWG_081
  -- Effet visuel + particules
end

-- Phase 3 (25% PV) : tempête + repousse
function TornadusBattle.Phase3_Tempest()
  -- PointWarp des personnages (repoussés par le vent)
  -- Dialogue MWG_082
  -- Effets visuels intenses
end

-- Phase 4 (10% PV) : dernier souffle
function TornadusBattle.Phase4_LastBreath()
  -- Tous les effets combinés
  -- Dialogue MWG_083
  -- Écran tremble (via BattleFX)
end
```

### Hook dans event_battle.lua

Le hook est ajouté dans la fonction qui gère les dégâts au boss :
```lua
-- Dans la fonction de dégâts au boss Tornadus
if target.BaseForm.Species == "tornadus" then
    local ratio = target.HP * 100 // target.MaxHP
    if ratio <= 75 and not SV.TornadusBattle.Phase1Done then
        SV.TornadusBattle.Phase1Done = true
        TornadusBattle.Phase1_WindRise()
    elseif ratio <= 50 and not SV.TornadusBattle.Phase2Done then
        SV.TornadusBattle.Phase2Done = true
        TornadusBattle.Phase2_WindStorm()
    elseif ratio <= 25 and not SV.TornadusBattle.Phase3Done then
        SV.TornadusBattle.Phase3Done = true
        TornadusBattle.Phase3_Tempest()
    elseif ratio <= 10 and not SV.TornadusBattle.Phase4Done then
        SV.TornadusBattle.Phase4Done = true
        TornadusBattle.Phase4_LastBreath()
    end
end
```

---

## Effets visuels par phase

### Phase 1 — Vent léger
- `AddMapStatus("blowing_wind")` — vent constant sur la carte
- `ProcessBattleFX` avec `Gust_Wind` — petites rafales
- SE : `EVT_Emote_Exclaim` — surprise légère

### Phase 2 — Vent fort
- `AddMapStatus("clouds_overhead")` — nuages menaçants
- `ProcessBattleFX` avec `Ominous_Wind` — vent sombre
- SE : `EVT_Tower_Quake` — grondement
- Particules : `Feather` — plumes emportées

### Phase 3 — Tempête
- `PointWarp` sur les personnages — repoussés de 3-4 cases
- `ProcessBattleFX` avec `Sandstorm` — poussière
- SE : `EVT_Emote_Shock_2` — choc
- Écran : secousse via `ProcessBattleFX`

### Phase 4 — Ouragan
- Tous les MapStatus combinés
- `PointWarp` sur tous les personnages — repoussés au maximum
- `ProcessBattleFX` avec `Ominous_Wind` + `Sandstorm`
- SE : `EVT_Battle_Flash` + `EVT_Tower_Quake`
- Dialogue final : "Ce vent... est tout ce qui me reste."

---

## Stabilité et alternatives

### Si PointWarp ne fonctionne pas comme prévu

Alternative 1 : Utiliser `AddStatusEffect("flinch")` pour immobiliser
les personnages temporairement (simulant la perte de contrôle).

Alternative 2 : Utiliser les capacités de Tornadus dans le combat
(Hurricane, Air Slash) qui ont naturellement des effets de déplacement
dans le moteur PMDO.

Alternative 3 : Effets purement visuels (MapStatus + dialogue) sans
déplacement forcé. Le joueur ressent la puissance par l'ambiance plutôt
que par la mécanique.

### Règle de stabilité

**Ne jamais forcer une implémentation instable.** Si une fonction ne
marche pas comme prévu pendant les tests en jeu, utiliser l'alternative
la plus proche. L'objectif est un combat mémorable, pas un effet
technique qui crash le jeu.
