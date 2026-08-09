--[[
    d21p41a — SALLE DU BOSS SPIRITOMB (Sealed Ruin Pit, arc du futur).

    ARCHITECTURE DE COMBAT FIDÈLE AU NDS :
      * Ground d21p41a.rsground (66x81) = salle CINÉMATIQUE :
          m18b1101 — « Urggh... You two... » (entrée dans la salle)
          m18b1201 — SPIRITOMB parle (« HEE-hee...Back again? », « PREPARE to
                     take your punishment! ») puis BOSS_WIPE + main_EnterDungeon(31)
          m18b1301 — retour après le combat : Spiritomb s'effraie et s'enfuit
                     (« Eeep! »), Grovyle révèle qu'il est normalement timide.
      * ARÈNE DE COMBAT = donjon 31 (spiritomb_room) : fixed floor 7 NDS,
        arène 22x17 (Data/Map/spiritomb_arena.rsmap), Spiritomb L51 weight 10000
        à (8,2) = (324,196) px. Le combat est déclenché par BattlePositionEvent.

    BATTLE GROUND FIDELITY :
      CINEMATIC_GROUND = d21p41a.rsground
      BATTLE_GROUND    = spiritomb_arena.rsmap (donjon 31, fixed floor)
      GROUND_IDENTITY  = SAME-NARRATIVE (comme le NDS : scène sur ground,
                         combat dans le donjon 31, retour sur ground)
]]
require 'origin.common'
require 'halcyon.future_arc.FutureCast'
require 'halcyon.future_arc.FutureArc'

local d21p41a = {}

function d21p41a.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d21p41a.Enter(map)
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  -- Retour après le combat Spiritomb (donjon 31) : jouer la scène de fuite
  if SV.FutureArc ~= nil and SV.FutureArc.SpiritombBattleDone then
    SV.FutureArc.SpiritombBattleDone = false
    d21p41a.AfterBattle()
    return
  end
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    -- 1. m18b1101 : entrée dans la salle du boss
    local s1 = require('halcyon.future_arc.scene.d21p41a_m18b1101')
    if s1 ~= nil and s1.Cutscene ~= nil then
      FutureCast.Spawn('D21P41A_m18b1101')
      s1.Cutscene()
    end
    -- 2. m18b1201 : SPIRITOMB parle (intro du combat) sur le ground
    local s2 = require('halcyon.future_arc.scene.d21p41a_m18b1201')
    if s2 ~= nil and s2.Cutscene ~= nil then
      FutureCast.Spawn('D21P41A_m18b1201')
      s2.Cutscene()
    end
    GAME:CutsceneMode(false)
    -- 3. COMBAT : entrée dans le donjon 31 (fixed floor, arène Spiritomb)
    --    (équivalent NDS : main_EnterDungeon(31) + BOSS_WIPE)
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    GAME:EnterDungeon('spiritomb_room', 0, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end)
  if not ok then
    PrintInfo('[d21p41a] scène interrompue : ' .. tostring(err))
    pcall(function() GAME:CutsceneMode(false); GAME:FadeIn(20) end)
  end
end

-- Appelé au retour du donjon (fin du combat) : scène de fuite + Dusk Forest
function d21p41a.AfterBattle()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    -- 4. m18b1301 : SPIRITOMB s'effraie et s'enfuit ; Grovyle explique
    local s3 = require('halcyon.future_arc.scene.d21p41a_m18b1301')
    if s3 ~= nil and s3.Cutscene ~= nil then
      FutureCast.Spawn('D21P41A_m18b1301')
      s3.Cutscene()
    end
    GAME:CutsceneMode(false)
    -- 5. Progression vers Dusk Forest (dungeon 32, D22P11A)
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    GAME:EnterGroundMap('d22p11a', 'Main_Entrance_Marker')
  end)
  if not ok then PrintInfo('[d21p41a] sortie interrompue : ' .. tostring(err)) end
end

function d21p41a.Update(map) end
function d21p41a.GameSave(map) end
function d21p41a.GameLoad(map)
  GAME:FadeIn(20)
end

return d21p41a
