--[[
    init.lua — forgotten_marsh_entrance
    Entrée de donjon (patron cloven_ruins_entrance) : Dungeon_Entrance (Touch),
    rocher Kangourex (Action), spawners équipiers.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'

local forgotten_marsh_entrance = {}

function forgotten_marsh_entrance.Init(map)
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()
end

function forgotten_marsh_entrance.Enter(map)
  GAME:FadeIn(20)
end

function forgotten_marsh_entrance.Update(map) end

function forgotten_marsh_entrance.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function forgotten_marsh_entrance.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

function forgotten_marsh_entrance.Dungeon_Entrance_Touch(obj, activator)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(CH('PLAYER'), 'None', true)
  UI:ChoiceMenuYesNo("Entrer dans le Marais de l'Oubli ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(CH('PLAYER'))
    GAME:EnterDungeon("forgotten_marsh", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(CH('PLAYER'))
end

function forgotten_marsh_entrance.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function forgotten_marsh_entrance.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function forgotten_marsh_entrance.Teammate2_Action(chara, activator)
  GeneralFunctions.GroundInteract(activator, chara)
end

function forgotten_marsh_entrance.Teammate3_Action(chara, activator)
  GeneralFunctions.GroundInteract(activator, chara)
end

return forgotten_marsh_entrance
