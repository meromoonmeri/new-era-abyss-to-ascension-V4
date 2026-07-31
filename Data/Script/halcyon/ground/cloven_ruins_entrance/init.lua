--[[
    init.lua — Cloven Ruins Entrance
    Chapitre 5 — Campement d'entrée de l'expédition des Ruines Fendues
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.ground.cloven_ruins_entrance.cloven_ruins_entrance_ch_5'

local cloven_ruins_entrance = {}

function cloven_ruins_entrance.Init(map)
    COMMON.RespawnAllies()
    PartnerEssentials.InitializePartnerSpawn()
end

function cloven_ruins_entrance.Enter(map)
    cloven_ruins_entrance.PlotScripting()
end

function cloven_ruins_entrance.Update(map)
end

function cloven_ruins_entrance.GameSave(map)
    PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function cloven_ruins_entrance.GameLoad(map)
    PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
    cloven_ruins_entrance.PlotScripting()
end

function cloven_ruins_entrance.PlotScripting()
    if SV.ChapterProgression.Chapter == 5 then
        if not SV.Chapter5.ReachedClovenRuins then
            cloven_ruins_entrance_ch_5.ArrivalCutscene()
        elseif SV.TemporaryFlags.MorningAddress then
            cloven_ruins_entrance_ch_5.MorningCutscene()
        else
            cloven_ruins_entrance_ch_5.SetupGround()
            GAME:FadeIn(20)
        end
    else
        GAME:FadeIn(20)
    end
end

function cloven_ruins_entrance.Dungeon_Entrance_Touch(obj, activator)
    UI:ResetSpeaker(false); UI:SetCenter(true)
    local partner = CH('Teammate1'); partner.IsInteracting = true
    GROUND:CharSetAnim(partner, 'None', true); GROUND:CharSetAnim(CH('PLAYER'), 'None', true)
    UI:ChoiceMenuYesNo("Entrer dans les Ruines Tordues ?", true); UI:WaitForChoice()
    if UI:ChoiceResult() then
        GAME:FadeOut(false, 60); partner.IsInteracting = false
        GROUND:CharEndAnim(partner); GROUND:CharEndAnim(CH('PLAYER'))
        GAME:EnterDungeon("cloven_ruins", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
        return
    end
    partner.IsInteracting = false; GROUND:CharEndAnim(partner); GROUND:CharEndAnim(CH('PLAYER'))
end

function cloven_ruins_entrance.Kangaskhan_Rock_Action(obj, activator)
    GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function cloven_ruins_entrance.Teammate1_Action(chara, activator)
    PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function cloven_ruins_entrance.Tropius_Action(chara, activator)
    GeneralFunctions.ChapterDispatch("cloven_ruins_entrance_ch_", "Tropius_Action", chara, activator)
end

function cloven_ruins_entrance.Noctowl_Action(chara, activator)
    GeneralFunctions.ChapterDispatch("cloven_ruins_entrance_ch_", "Noctowl_Action", chara, activator)
end

function cloven_ruins_entrance.Flygon_Action(chara, activator)
    GeneralFunctions.ChapterDispatch("cloven_ruins_entrance_ch_", "Flygon_Action", chara, activator)
end

return cloven_ruins_entrance
