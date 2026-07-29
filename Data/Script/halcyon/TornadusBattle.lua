--[[
    TornadusBattle.lua

    MÉCANIQUE DE COMBAT — Courants de vent de Boréas (Tornadus)
    ================================================================
    Système de phases de combat déclenchées aux seuils de PV de Tornadus.
    Chaque phase ajoute des effets visuels, des dialogues et des mécaniques.

    PHASES :
      1 (75% PV) — Vent léger : MapStatus blowing_wind + dialogue
      2 (50% PV) — Vent fort : clouds_overhead + particules + dialogue
      3 (25% PV) — Tempête : PointWarp repousse + dialogue
      4 (10% PV) — Ouragan : tous les effets + dialogue final

    TECHNIQUE :
      - _DUNGEON:AddMapStatus pour les effets visuels
      - _DUNGEON:PointWarp pour le déplacement forcé (phase 3+)
      - BattleScriptEvent pour les dialogues
      - SV.TornadusBattle pour le suivi des phases

    STABILITÉ :
      Tout sous pcall. Si PointWarp échoue, fallback sur AddStatusEffect
      (flinch) pour simuler la perte de contrôle.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

TornadusBattle = {}

--------------------------------------------------------------------
-- HELPERS
--------------------------------------------------------------------

local function addStatus(statusName)
  pcall(function()
    local idx = _DATA:GetMapStatus(statusName)
    if idx ~= nil then
      local status = RogueEssence.Dungeon.MapStatus(idx)
      TASK:WaitTask(_DUNGEON:AddMapStatus(status))
    end
  end)
end

local function removeStatus(statusName)
  pcall(function()
    local idx = _DATA:GetMapStatus(statusName)
    if idx ~= nil then
      TASK:WaitTask(_DUNGEON:RemoveMapStatus(idx, false))
    end
  end)
end

local function windPushback(chara, distance)
  -- Tente PointWarp pour repousser le personnage.
  -- Fallback sur AddStatusEffect("flinch") si PointWarp échoue.
  if chara == nil then return end
  local ok = pcall(function()
    -- Calcule la position repoussée (loin de Tornadus au centre)
    local cx = chara.CharLoc.X
    local cy = chara.CharLoc.Y
    -- Direction : loin du centre de l'arène (estimé à 20,14)
    local dx = cx - 20
    local dy = cy - 14
    local len = math.max(1, math.sqrt(dx*dx + dy*dy))
    local nx = math.floor(cx + (dx / len) * distance)
    local ny = math.floor(cy + (dy / len) * distance)
    -- Clamp dans les limites de la carte
    nx = math.max(1, math.min(38, nx))
    ny = math.max(1, math.min(28, ny))
    TASK:WaitTask(_DUNGEON:PointWarp(chara, RogueElements.Loc(nx, ny), false))
  end)
  if not ok then
    -- Fallback : flinch (immobilisation temporaire)
    pcall(function()
      local flinch = RogueEssence.Dungeon.StatusEffect("flinch")
      flinch:LoadFromData()
      TASK:WaitTask(chara:AddStatusEffect(nil, flinch, true))
    end)
  end
end

local function showDialogue(key)
  pcall(function()
    local evt = RogueEssence.Dungeon.BattleScriptEvent(key)
    TASK:WaitTask(_DUNGEON:ProcessBattleFX(nil, nil, evt))
  end)
end

--------------------------------------------------------------------
-- PHASE 1 — VENT LÉGER (75% PV)
--------------------------------------------------------------------
function TornadusBattle.Phase1_WindRise()
  -- MapStatus : vent constant
  addStatus("blowing_wind")

  -- Dialogue
  showDialogue("TornadusPhase1")

  -- Effet visuel léger : petites rafales
  pcall(function()
    local player = _DUNGEON:GetPlayerChar()
    if player ~= nil then
      TASK:WaitTask(_DUNGEON:ProcessBattleFX(player, player, _DATA.SendHomeFX))
    end
  end)
end

--------------------------------------------------------------------
-- PHASE 2 — VENT FORT (50% PV)
--------------------------------------------------------------------
function TornadusBattle.Phase2_WindStorm()
  -- MapStatus : nuages menaçants
  addStatus("clouds_overhead")

  -- Dialogue
  showDialogue("TornadusPhase2")

  -- Effet visuel : particules de vent
  pcall(function()
    local player = _DUNGEON:GetPlayerChar()
    if player ~= nil then
      TASK:WaitTask(_DUNGEON:ProcessBattleFX(player, player, _DATA.SendHomeFX))
    end
  end)
end

--------------------------------------------------------------------
-- PHASE 3 — TEMPÊTE (25% PV)
--------------------------------------------------------------------
function TornadusBattle.Phase3_Tempest()
  -- Dialogue
  showDialogue("TornadusPhase3")

  -- Repousse tous les personnages de l'équipe
  pcall(function()
    local player = _DUNGEON:GetPlayerChar()
    if player ~= nil then
      windPushback(player, 3)
    end
  end)

  pcall(function()
    for i = 0, 3 do
      local ally = _DUNGEON:GetPlayerPartyMember(i)
      if ally ~= nil then
        windPushback(ally, 2)
      end
    end
  end)
end

--------------------------------------------------------------------
-- PHASE 4 — OURAGAN (10% PV)
--------------------------------------------------------------------
function TornadusBattle.Phase4_LastBreath()
  -- Dialogue final
  showDialogue("TornadusPhase4")

  -- Repousse maximale
  pcall(function()
    local player = _DUNGEON:GetPlayerChar()
    if player ~= nil then
      windPushback(player, 5)
    end
  end)

  pcall(function()
    for i = 0, 3 do
      local ally = _DUNGEON:GetPlayerPartyMember(i)
      if ally ~= nil then
        windPushback(ally, 4)
      end
    end
  end)

  -- Effet visuel final : flash
  pcall(function()
    local player = _DUNGEON:GetPlayerChar()
    if player ~= nil then
      TASK:WaitTask(_DUNGEON:ProcessBattleFX(player, player, _DATA.SendHomeFX))
    end
  end)
end

--------------------------------------------------------------------
-- HOOK PRINCIPAL — appelé depuis event_battle.lua
--------------------------------------------------------------------
function TornadusBattle.CheckPhase(target)
  if target == nil then return end
  pcall(function()
    -- Vérifie que c'est bien Tornadus
    if target.BaseForm.Species ~= "tornadus" then return end

    local ratio = target.HP * 100 // target.MaxHP

    -- Phase 1 (75%)
    if ratio <= 75 and not SV.TornadusBattle.Phase1Done then
      SV.TornadusBattle.Phase1Done = true
      TornadusBattle.Phase1_WindRise()
    -- Phase 2 (50%)
    elseif ratio <= 50 and not SV.TornadusBattle.Phase2Done then
      SV.TornadusBattle.Phase2Done = true
      TornadusBattle.Phase2_WindStorm()
    -- Phase 3 (25%)
    elseif ratio <= 25 and not SV.TornadusBattle.Phase3Done then
      SV.TornadusBattle.Phase3Done = true
      TornadusBattle.Phase3_Tempest()
    -- Phase 4 (10%)
    elseif ratio <= 10 and not SV.TornadusBattle.Phase4Done then
      SV.TornadusBattle.Phase4Done = true
      TornadusBattle.Phase4_LastBreath()
    end
  end)
end

--------------------------------------------------------------------
-- RESET — appelé au début du combat contre Tornadus
--------------------------------------------------------------------
function TornadusBattle.Reset()
  SV.TornadusBattle = {
    Phase1Done = false,
    Phase2Done = false,
    Phase3Done = false,
    Phase4Done = false,
  }
  -- Retire les MapStatus de vent s'ils persistent d'un combat précédent
  removeStatus("blowing_wind")
  removeStatus("clouds_overhead")
end

return TornadusBattle
