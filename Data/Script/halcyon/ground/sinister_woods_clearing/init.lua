-- [dungeon_builder] recâblage : scène du gardien puis combat sur l'étage d'arène du segment 2 de gloomy_forest : cinématique et combat au même endroit
-- D04P02 — clairière finale canonique de Sinister Woods, casting New Era.
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.gloomy_forest_entrance.gloomy_forest_entrance_ch_6'

local sinister_woods_clearing = {}

function sinister_woods_clearing.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function sinister_woods_clearing.Enter(map)
  local ok, err = pcall(function()
    if SV.ChapterProgression.Chapter == 6
       and not SV.Chapter6.FinishedGloomyForestIntro then
      gloomy_forest_entrance_ch_6.DazzlingClearingCutscene()
    else
      GAME:ContinueDungeon('gloomy_forest', 2, 0, 0,
        RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    end
  end)
  if not ok then
    PrintInfo('[sinister_woods_clearing] scène interrompue : '..tostring(err))
    GAME:CutsceneMode(false)
    GAME:FadeIn(20)
  end
end

function sinister_woods_clearing.Update(map) end
function sinister_woods_clearing.GameSave(map) end
function sinister_woods_clearing.GameLoad(map) sinister_woods_clearing.Enter(map) end

return sinister_woods_clearing
