--[[
    init.lua — Cloven Ruins Entrance
    Chapter 7 — Entree des Ruines Tordues
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ChapterScenes'
require 'halcyon.ground.cloven_ruins_entrance.cloven_ruins_entrance_ch_7'

local cloven_ruins_entrance = {}
function cloven_ruins_entrance.Init(map) COMMON.RespawnAllies(); PartnerEssentials.InitializePartnerSpawn() end
function cloven_ruins_entrance.Enter(map)
  -- Scene d'arrivee ch7 : jouee une seule fois
  if SV.ChapterProgression.Chapter == 7 and not SV.Chapter7.ClovenEntrancePlayed then
    SV.Chapter7.ClovenEntrancePlayed = true
    cloven_ruins_entrance_ch_7.ArrivalCutscene()
  else
    GAME:FadeIn(20)
  end
end
function cloven_ruins_entrance.Update(map) end
function cloven_ruins_entrance.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function cloven_ruins_entrance.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1')); GAME:FadeIn(20) end
function cloven_ruins_entrance.Dungeon_Entrance_Touch(obj, activator)
    UI:ResetSpeaker(false); UI:SetCenter(true)
    local partner = CH('Teammate1'); partner.IsInteracting = true
    GROUND:CharSetAnim(partner, 'None', true); GROUND:CharSetAnim(CH('PLAYER'), 'None', true)
    UI:ChoiceMenuYesNo("Entrer dans les Ruines Tordues ?", true); UI:WaitForChoice()
    if UI:ChoiceResult() then GAME:FadeOut(false, 60); partner.IsInteracting = false
        GROUND:CharEndAnim(partner); GROUND:CharEndAnim(CH('PLAYER'))
        GAME:EnterDungeon("cloven_ruins", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    end
    partner.IsInteracting = false; GROUND:CharEndAnim(partner); GROUND:CharEndAnim(CH('PLAYER'))
end
function cloven_ruins_entrance.Kangaskhan_Rock_Action(obj, activator) GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator) end
function cloven_ruins_entrance.Teammate1_Action(chara, activator)
  if SV.ChapterProgression.Chapter == 7 then
    cloven_ruins_entrance_ch_7.Partner_Action(chara, activator)
  else
    PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
  end
end
-- Ganlon (Teammate2) — dialogue ch7 specifique
function cloven_ruins_entrance.Teammate2_Action(chara, activator)
  if SV.ChapterProgression.Chapter == 7 then
    cloven_ruins_entrance_ch_7.Ganlon_Action(chara, activator)
  else
    GeneralFunctions.GroundInteract(activator, chara)
  end
end
-- Shuca (Teammate3) — dialogue ch7 specifique
function cloven_ruins_entrance.Teammate3_Action(chara, activator)
  if SV.ChapterProgression.Chapter == 7 then
    cloven_ruins_entrance_ch_7.Shuca_Action(chara, activator)
  else
    GeneralFunctions.GroundInteract(activator, chara)
  end
end
return cloven_ruins_entrance
