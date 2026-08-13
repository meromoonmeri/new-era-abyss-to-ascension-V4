-- Generated Smart Dungeon midpoint relay; deterministic and promotion-ready.
require 'origin.common'
require 'halcyon.GeneralFunctions'

local sanctuaire_des_echos_relais_01 = {}

function sanctuaire_des_echos_relais_01.Init(map)
  DEBUG.EnableDbgCoro()
end

function sanctuaire_des_echos_relais_01.Enter(map)
  GAME:FadeIn(20)
end

function sanctuaire_des_echos_relais_01.Update(map) end

local function enter_segment(segment)
  GAME:FadeOut(false, 40)
  if _ZONE.CurrentZoneID == 'sanctuaire_des_echos' then
    GAME:ContinueDungeon('sanctuaire_des_echos', segment, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  else
    GAME:EnterDungeon('sanctuaire_des_echos', segment, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end

-- Chemin avant : seconde partie du donjon.
function sanctuaire_des_echos_relais_01.North_Exit_Touch(obj, activator)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo('Continuer vers la partie suivante du donjon ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then enter_segment(1) end
end

-- Chemin arrière : première partie du donjon.
function sanctuaire_des_echos_relais_01.South_Exit_Touch(obj, activator)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo('Revenir vers la partie précédente du donjon ?', true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then enter_segment(0) end
end

-- Statue de Kangourex : soin, stockage et sauvegarde natifs du projet.
function sanctuaire_des_echos_relais_01.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return sanctuaire_des_echos_relais_01
