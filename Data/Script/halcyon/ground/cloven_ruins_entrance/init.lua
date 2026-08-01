--[[
    init.lua — Cloven Ruins Entrance
    Entree des Ruines Fendues (ch5, finale de l'expedition) /
    Ruines Tordues (ch7). Routeur modulaire : la cinematique de
    campement se joue une seule fois, adaptee au chapitre.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.ground.cloven_ruins_entrance.cloven_ruins_entrance_ch_5'

local cloven_ruins_entrance = {}

function cloven_ruins_entrance.Init(map)
    DEBUG.EnableDbgCoro()
    print('=>> Init_cloven_ruins_entrance <<=')
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

--ROUTEUR MODULAIRE. La scene de campement se joue UNE SEULE FOIS
--(SV.Chapter5.ReachedClovenRuins), que le joueur arrive au ch5
--(finale de l'expedition) ou au ch7 (entree des Ruines Tordues).
--Au ch7, ReachedClovenRuins est deja vrai (pose par la trame ch5) :
--le joueur arrive donc sur un camp deja etabli, sans rejouer l'arrivee.
function cloven_ruins_entrance.PlotScripting()
    if SV.ChapterProgression.Chapter == 5 then
        if not SV.Chapter5.ReachedClovenRuins then
            --L'ARRIVEE : le lieu, le duo, puis la veillee complete
            --(repas -> coucher -> nuit) enchaine dans ArrivalCutscene.
            cloven_ruins_entrance_ch_5.ArrivalCutscene()
        elseif SV.TemporaryFlags.MorningAddress then
            --Le lendemain : briefing matinal avant la descente.
            cloven_ruins_entrance_ch_5.MorningCutscene()
        else
            --Campement etabli : le joueur se deplace librement,
            --le feu brille au centre du camp.
            cloven_ruins_entrance_ch_5.SetupGround()
            cloven_ruins_entrance_ch_5.BuildCampDay()
            GAME:FadeIn(20)
        end
    elseif SV.ChapterProgression.Chapter == 7 then
        --Entree des Ruines Tordues : le camp est deja la (trame ch5),
        --on ne rejoue pas la cinematique. Simple etat de camp.
        cloven_ruins_entrance_ch_5.SetupGround()
        cloven_ruins_entrance_ch_5.BuildCampDay()
        GAME:FadeIn(20)
    else
        GAME:FadeIn(20)
    end
end

function cloven_ruins_entrance.Dungeon_Entrance_Touch(obj, activator)
    UI:ResetSpeaker(false); UI:SetCenter(true)
    local partner = CH('Teammate1'); partner.IsInteracting = true
    GROUND:CharSetAnim(partner, 'None', true); GROUND:CharSetAnim(CH('PLAYER'), 'None', true)
    UI:ChoiceMenuYesNo("Entrer dans les Ruines ?", true); UI:WaitForChoice()
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
