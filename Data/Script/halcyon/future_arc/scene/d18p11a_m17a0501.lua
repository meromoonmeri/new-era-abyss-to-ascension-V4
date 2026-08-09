--[[
    D18P11A_m17a0501.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D18P11A/m17a0501.ssb
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

local m17a0501 = {}

function m17a0501.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        GAME:WaitFrames(60)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' ...Huff-huff.\n Huff-huff...') -- FUT_M17A0501_001 (FR optionnel)
        -- case 0: ' ...Huff-huff.[K] Huff-huff...'
        -- case 1: ' ...Huff-huff.[K] Huff-huff...'
        UI:WaitShowDialogue(' Hey, Grovyle. I\'m beat.') -- FUT_M17A0501_002 (FR optionnel)
        -- case 3: " Hey, [CS:N]Grovyle[CR]. I'm beat."
        -- case 4: " Listen, [CS:N]Grovyle[CR]. I'm exhausted."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' There\'s no time to rest!') -- FUT_M17A0501_003 (FR optionnel)
        UI:WaitShowDialogue(' If they catch us, we\'re done!\n\nTough it out and run!') -- FUT_M17A0501_004 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' That\'s easy for you to say...\nHuff-huff...') -- FUT_M17A0501_005 (FR optionnel)
        -- case 8: " That's easy for you to say...\nHuff-huff..."
        -- case 9: " That's easy for you to say...\nHuff-huff..."
        UI:WaitShowDialogue(' I can\'t.\n I have to rest.') -- FUT_M17A0501_006 (FR optionnel)
        -- case 11: " I can't.[K] I have to rest."
        -- case 12: " I can't.[K] I have to rest."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' All right.') -- FUT_M17A0501_007 (FR optionnel)
        UI:ResetSpeaker()
        -- back_SetGround(D18P11A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        GAME:WaitFrames(1)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Grovyle'), 312, 196, false, 2.398)
                GROUND:MoveToPosition(CH('Grovyle'), 336, 176, false, 3.0)
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownLeft, 15)
            end,
            function()
                GROUND:MoveToPosition(CH('PLAYER'), 280, 212, false, 2.398)
                GROUND:MoveToPosition(CH('PLAYER'), 312, 156, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
            end,
            function()
                GROUND:MoveToPosition(CH('Teammate1'), 264, 196, false, 2.398)
                GROUND:MoveToPosition(CH('Teammate1'), 280, 180, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
            end,
        })
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' Huff-huff...\n Huff-huff...') -- FUT_M17A0501_008 (FR optionnel)
        -- case 15: ' Huff-huff...[K] Huff-huff...'
        -- case 16: ' Huff-huff...[K] Huff-huff...'
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Left, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' This forms a natural alcove.') -- FUT_M17A0501_009 (FR optionnel)
        UI:WaitShowDialogue(' This should shield us from view.') -- FUT_M17A0501_010 (FR optionnel)
        UI:WaitShowDialogue(' After a quick rest, we\'ll have to\nget moving again.') -- FUT_M17A0501_011 (FR optionnel)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8971 (SE_NUM_EVENT_SIGN_ANGER_02)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' W-wait a minute.') -- FUT_M17A0501_012 (FR optionnel)
        -- case 21: ' W-wait a minute.'
        -- case 22: ' W-wait a minute.'
        UI:WaitShowDialogue(' When we escaped from the\nstockade, we cooperated with you because we\nhad to...') -- FUT_M17A0501_013 (FR optionnel)
        -- case 24: ' When we escaped from the\nstockade, we cooperated with you because we\nhad to...'
        -- case 25: ' When we escaped from the\nstockade, we cooperated with you because we\nhad no other choice...'
        UI:WaitShowDialogue(' But we never promised we\'d go\nwith you afterward!') -- FUT_M17A0501_014 (FR optionnel)
        -- case 27: " But we never promised we'd go\nwith you afterward!"
        -- case 28: " But we didn't promise we'd go\nwith you afterward!"
        UI:WaitShowDialogue(' A bad Pokémon like you...\n\nI\'m not about to trust you with anything.') -- FUT_M17A0501_015 (FR optionnel)
        -- case 30: " A bad Pokémon like you...[K]\nI'm not about to trust you with anything."
        -- case 31: " A bad Pokémon like you...[K]\nYou're not worth trusting."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue('([partner]...)') -- FUT_M17A0501_016 (FR optionnel)
        -- case 33: '([partner]...)'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Humph!') -- FUT_M17A0501_017 (FR optionnel)
        UI:WaitShowDialogue(' So I\'m the bad guy...\n And that\nDusknoir is the good guy?') -- FUT_M17A0501_018 (FR optionnel)
        UI:WaitShowDialogue(' Then how about explaining\nDusknoir\'s actions earlier?') -- FUT_M17A0501_019 (FR optionnel)
        UI:WaitShowDialogue(' It wasn\'t just me...\n They wanted\nyou gone too!') -- FUT_M17A0501_020 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' Urk...') -- FUT_M17A0501_021 (FR optionnel)
        -- case 39: ' Urk...'
        -- case 40: ' Urk...'
        UI:WaitShowDialogue(' But...\n That doesn\'t mean I should\nbe trusting you, Grovyle...') -- FUT_M17A0501_022 (FR optionnel)
        -- case 42: " But...[K] That doesn't mean I should\nbe trusting you, [CS:N]Grovyle[CR]..."
        -- case 43: " But...[K] That doesn't mean I should\nput my faith in you, [CS:N]Grovyle[CR]..."
        UI:ResetSpeaker()
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Earning your trust isn\'t an easy\ntask, it seems.') -- FUT_M17A0501_023 (FR optionnel)
        UI:WaitShowDialogue(' I thought that having allies\nwould help, but...') -- FUT_M17A0501_024 (FR optionnel)
        UI:WaitShowDialogue(' There\'s no point continuing\ntogether without trust.') -- FUT_M17A0501_025 (FR optionnel)
        UI:WaitShowDialogue(' We\'ll go our separate ways.') -- FUT_M17A0501_026 (FR optionnel)
        UI:WaitShowDialogue(' I\'m staying on the move.\n\nYou two should get moving as soon as possible.') -- FUT_M17A0501_027 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Right, 15)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownRight, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Good luck.') -- FUT_M17A0501_028 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), 368, 176, false, 1.0)
        GAME:WaitFrames(15)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(' Wait a second!') -- FUT_M17A0501_029 (FR optionnel)
        -- case 51: ' Wait a second!'
        -- case 52: ' Wait a second!'
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' You say to leave soon, but...') -- FUT_M17A0501_030 (FR optionnel)
        UI:SetCenter(false)
        -- case 54: ' You say to leave soon, but...'
        -- case 55: ' You tell us to leave soon, but...'
        UI:SetCenter(true)
        UI:WaitShowDialogue(' It\'s dark out now. It\'s tough to\nsee where we\'re going.') -- FUT_M17A0501_031 (FR optionnel)
        UI:SetCenter(false)
        -- case 57: " It's dark out now. It's tough to\nsee where we're going."
        -- case 58: " It's dark out now. It's hard to\nsee where we're going."
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Instead of staying on the move\nright now, why not wait for morning?') -- FUT_M17A0501_032 (FR optionnel)
        UI:SetCenter(false)
        -- case 60: ' Instead of staying on the move\nright now, why not wait for morning?'
        -- case 61: " Instead of setting off again\nright away, shouldn't we wait for morning?"
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Can\'t we wait to leave until it\ngets light out?') -- FUT_M17A0501_033 (FR optionnel)
        UI:SetCenter(false)
        -- case 63: " Can't we wait to leave until it\ngets light out?"
        -- case 64: " Wouldn't it be better to leave\nwhen it gets light out?"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' That isn\'t possible.') -- FUT_M17A0501_034 (FR optionnel)
        UI:WaitShowDialogue(' I hate to say it, but...\nmorning\nnever comes.') -- FUT_M17A0501_035 (FR optionnel)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8964 (SE_NUM_EVENT_SIGN_NOTICE_01)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end,
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Huh?!') -- FUT_M17A0501_036 (FR optionnel)
        -- case 68: ' Huh?!'
        -- case 69: ' What?!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Left, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' This world... Your future...\nIt\'s a world of perpetual darkness.') -- FUT_M17A0501_037 (FR optionnel)
        UI:WaitShowDialogue(' The sun never rises.\n So morning\nnever comes.') -- FUT_M17A0501_038 (FR optionnel)
        UI:WaitShowDialogue(' The darkness persists forever.') -- FUT_M17A0501_039 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Wh-why?') -- FUT_M17A0501_040 (FR optionnel)
        -- case 74: ' Wh-why?'
        -- case 75: ' Wh-why?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Because...\nthe planet has been\nparalyzed.') -- FUT_M17A0501_041 (FR optionnel)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Startled') -- SE 8962 (SE_NUM_EVENT_SIGN_HATENA_02)
        GROUND:CharSetEmote(CH('Teammate1'), 'question', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(' The planet is...\nparalyzed?') -- FUT_M17A0501_042 (FR optionnel)
        -- case 78: ' The planet is...[K]paralyzed?'
        -- case 79: ' The planet is...[K]paralyzed?'
        UI:WaitShowDialogue(' The planet\'s paralysis...') -- FUT_M17A0501_043 (FR optionnel)
        -- case 81: " The planet's paralysis..."
        -- case 82: " The planet's paralysis..."
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' ...The planet\'s paralysis!\n\nThat\'s right! I remember now!') -- FUT_M17A0501_044 (FR optionnel)
        -- case 84: " ...The planet's paralysis![K]\nThat's right! I remember now!"
        -- case 85: " ...The planet's paralysis![K]\nThat's right! I remember now!"
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Dusknoir described the\nplanet\'s paralysis before...') -- FUT_M17A0501_045 (FR optionnel)
        UI:SetCenter(false)
        -- case 87: " [CS:N]Dusknoir[CR] described the\nplanet's paralysis before..."
        -- case 88: " [CS:N]Dusknoir[CR] described the\nplanet's paralysis before..."
        UI:ResetSpeaker()
        GAME:FadeOut(false, 30)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m17a0501] scène interrompue : '..tostring(err)) end
end

return m17a0501
