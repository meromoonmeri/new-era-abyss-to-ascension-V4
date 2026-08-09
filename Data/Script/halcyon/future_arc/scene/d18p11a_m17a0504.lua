--[[
    D18P11A_m17a0504.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D18P11A/m17a0504.ssb
    Généré par tools/ssb_to_lua.py — IR canonique + couche d'adaptation New Era.
    Chorégraphie 1:1 (déplacements, positions, timings, animations, caméra,
    fades, SFX, BGM, transitions, flags, embranchements). Seul le CAST change :
    Dusknoir/Grovyle (alliés), Sableye (sbires de Necrozma), Celebi, héros/
    partenaire ; le maître du futur = Necrozma (Dialga absent). Les dialogues
    canoniques sont joués (cast appliqué), la clé FUT_* en commentaire sert
    d'éventuelle passe FR. Les tables anim/SE/effets manquantes sont marquées
    TODO (jamais inventées).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

local m17a0504 = {}

function m17a0504.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        SV.Scenario.Main = 18 -- flag_SetScenario(SCENARIO_MAIN, scenario=18, level=3)
        -- back_SetGround(D18P11A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' The planet\'s paralysis...') -- FUT_M17A0504_001 (FR optionnel)
        -- case 0: " The planet's paralysis..."
        -- case 1: " The planet's paralysis..."
        UI:WaitShowDialogue(' It\'s true that this place appears\njust like Dusknoir described it.') -- FUT_M17A0504_002 (FR optionnel)
        -- case 3: " It's true that this place appears\njust like [CS:N]Dusknoir[CR] described it."
        -- case 4: " Sure, this place resembles\n[CS:N]Dusknoir[CR]'s description."
        UI:WaitShowDialogue(' But even then...') -- FUT_M17A0504_003 (FR optionnel)
        -- case 6: ' But even then...'
        -- case 7: ' But even then...'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
        GAME:WaitFrames(15)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(15)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' It\'s hard to understand how the\nplanet has been paralyzed in the future.') -- FUT_M17A0504_004 (FR optionnel)
        UI:SetCenter(false)
        -- case 9: " It's hard to understand how the\nplanet has been paralyzed in the future."
        -- case 10: " It's hard to understand how the\nplanet has been paralyzed in the future."
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownRight, 15)
            end,
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' You\'re free to believe...or\nreject...what I\'m telling you.') -- FUT_M17A0504_005 (FR optionnel)
        UI:WaitShowDialogue(' Either way, I suggest you leave\nhere as soon as you can.') -- FUT_M17A0504_006 (FR optionnel)
        UI:WaitShowDialogue(' I\'m going.\n Don\'t let those Sableye\ncatch you.') -- FUT_M17A0504_007 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), 388, 140, false, 1.594)
        GAME:WaitFrames(10)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Right, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
            end,
        })
        pcall(function() GROUND:RemoveCharacter(CH('Grovyle')) end)
        GAME:WaitFrames(60)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' Urk... [hero].') -- FUT_M17A0504_008 (FR optionnel)
        -- case 15: ' Urk... [hero].'
        -- case 16: ' Urk... [hero].'
        UI:WaitShowDialogue(' I don\'t know what to think\nanymore.') -- FUT_M17A0504_009 (FR optionnel)
        -- case 18: " I don't know what to think\nanymore."
        -- case 19: " I don't know what to think\nanymore."
        UI:WaitShowDialogue(' Wasn\'t the planet\'s paralysis\nsupposed to be caused by all those Time Gears\ngoing missing?') -- FUT_M17A0504_010 (FR optionnel)
        -- case 21: " Wasn't the planet's paralysis\nsupposed to be caused by all those Time Gears\ngoing missing?"
        -- case 22: " Wasn't the planet's paralysis\nsupposed to be caused by all those Time Gears\ngoing missing?"
        UI:WaitShowDialogue(' That\'s why we all tried to stop\nGrovyle from stealing the Time Gears.') -- FUT_M17A0504_011 (FR optionnel)
        -- case 24: " That's why we all tried to stop\n[CS:N]Grovyle[CR] from stealing the Time Gears."
        -- case 25: " That's why we all tried to stop\n[CS:N]Grovyle[CR] from stealing the Time Gears."
        UI:WaitShowDialogue(' We did everything we were\nsupposed to, right?') -- FUT_M17A0504_012 (FR optionnel)
        -- case 27: ' We did everything we were\nsupposed to, right?'
        -- case 28: ' We did everything we were\nsupposed to, right?'
        UI:WaitShowDialogue(' Uxie and the others said they\'d\nreturn the Time Gears to their rightful places.') -- FUT_M17A0504_013 (FR optionnel)
        -- case 30: " [CS:N]Uxie[CR] and the others said they'd\nreturn the Time Gears to their rightful places."
        -- case 31: ' [CS:N]Uxie[CR] and the others said they\nwould return the recaptured Time Gears to\ntheir rightful places.'
        UI:WaitShowDialogue(' That was supposed to prevent\nthe planet\'s paralysis!') -- FUT_M17A0504_014 (FR optionnel)
        -- case 33: " That was supposed to prevent\nthe planet's paralysis!"
        -- case 34: " That should have prevented the\nplanet's paralysis!"
        UI:WaitShowDialogue(' But despite all our efforts...') -- FUT_M17A0504_015 (FR optionnel)
        -- case 36: ' But despite all our efforts...'
        -- case 37: ' But despite all our efforts...'
        UI:WaitShowDialogue(' Why is the planet still\nparalyzed...\nin our future?') -- FUT_M17A0504_016 (FR optionnel)
        -- case 39: ' Why is the planet still\nparalyzed...[K]in our future?'
        -- case 40: ' Why is the planet still\nparalyzed...[K]in our future?'
        UI:ResetSpeaker()
        -- ExecuteCommon(HEAD_SHAKE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' Arrgh! I don\'t know who or what\nto believe anymore!') -- FUT_M17A0504_017 (FR optionnel)
        -- case 42: " Arrgh! I don't know who or what\nto believe anymore!"
        -- case 43: " Arrgh! I don't know who or what\nto believe anymore!"
        UI:ResetSpeaker()
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue(' Wheh-heh-heh!') -- FUT_M17A0504_018 (FR optionnel)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(30)
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
            end,
        })
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Waah! The Sableye!') -- FUT_M17A0504_019 (FR optionnel)
        -- case 46: ' Waah! The [CS:N]Sableye[CR]!'
        -- case 47: ' Waah! The [CS:N]Sableye[CR]!'
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' We can\'t stick around here,\n[hero]!') -- FUT_M17A0504_020 (FR optionnel)
        -- case 49: " We can't stick around here,\n[hero]!"
        -- case 50: " We can't stay here,\n[hero]!"
        UI:WaitShowDialogue(' Let\'s get ready quickly so we\ncan get rolling!') -- FUT_M17A0504_021 (FR optionnel)
        -- case 52: " Let's get ready quickly so we\ncan get rolling!"
        -- case 53: " Let's get ready quickly so we\ncan get moving!"
        UI:ResetSpeaker()
        -- bgm_PlayFadeIn [39, 0, 256] : BGM ChasmCave non mappé
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m17a0504] scène interrompue : '..tostring(err)) end
end

return m17a0504
