--[[
    D22P11A_m19a0201.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D22P11A/m19a0201.ssb
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

local m19a0201 = {}

function m19a0201.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- back_SetGround(D22P11A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- NON CONVERTI : supervision_LoadStation [50, 0]
        -- NON CONVERTI : supervision_Station [1]
        -- supervision_cting layer [0] (structurel)
        -- NON CONVERTI : SetPositionInitial []
        -- SetAnimation 2 (spécial : boucle anim courante)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Grovyle'), 276, 228, false, 2.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Teammate1'), 260, 260, false, 2.0)
            end,
            function()
                GROUND:MoveToPosition(CH('PLAYER'), 292, 260, false, 2.0)
            end,
        })
        GAME:WaitFrames(15)
        SOUND:PlayBattleSE('EVT_Emote_Exclaim') -- SE 8964 (SE_NUM_EVENT_SIGN_NOTICE_01)
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue('(...!)') -- FUT_M19A0201_001 (FR optionnel)
        -- case 1: '(...!)'
        UI:WaitShowDialogue('(Wh-what...?)') -- FUT_M19A0201_002 (FR optionnel)
        -- case 3: '(Wh-what...?)'
        UI:WaitShowDialogue('(What was that...\nstrange sensation?)') -- FUT_M19A0201_003 (FR optionnel)
        -- case 5: '(What was that...[K]strange sensation?)'
        UI:WaitShowDialogue('(I\'ve had that strange sensation before...)') -- FUT_M19A0201_004 (FR optionnel)
        -- case 7: "(I've had that strange sensation before...)"
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Where...\n Where are we?') -- FUT_M19A0201_005 (FR optionnel)
        -- case 9: ' Where...[K] Where are we?'
        -- case 10: ' Where...[K] Where are we?'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Teammate1'))
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' This is Dusk Forest.\n Its name\ncomes from the dark fog that perpetually\nshrouds it.') -- FUT_M19A0201_006 (FR optionnel)
        UI:WaitShowDialogue(' Deep in this forest...') -- FUT_M19A0201_007 (FR optionnel)
        UI:WaitShowDialogue(' We should find Celebi.') -- FUT_M19A0201_008 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(' Hey, Grovyle.\n You mentioned\nthe name before, but...') -- FUT_M19A0201_009 (FR optionnel)
        -- case 15: ' Hey, [CS:N]Grovyle[CR].[K] You mentioned\nthe name before, but...'
        -- case 16: ' Hey, [CS:N]Grovyle[CR].[K] You mentioned\nthe name before, but...'
        UI:WaitShowDialogue(' Who is Celebi?') -- FUT_M19A0201_010 (FR optionnel)
        -- case 18: ' Who is [CS:N]Celebi[CR]?'
        -- case 19: ' Who is [CS:N]Celebi[CR]?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Celebi is the legendary Time\nTravel Pokémon.') -- FUT_M19A0201_011 (FR optionnel)
        UI:WaitShowDialogue(' She has the ability to\ncross time.') -- FUT_M19A0201_012 (FR optionnel)
        UI:WaitShowDialogue(' But...\n Well, she\'s a little odd...') -- FUT_M19A0201_013 (FR optionnel)
        UI:WaitShowDialogue(' But anyway...\nCelebi\'s ability enabled \nme to go to the past.') -- FUT_M19A0201_014 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' So if we find Celebi...') -- FUT_M19A0201_015 (FR optionnel)
        -- case 25: ' So if we find [CS:N]Celebi[CR]...'
        -- case 26: ' So if we find [CS:N]Celebi[CR]...'
        UI:WaitShowDialogue(' Does that mean we can get back\nto our world?') -- FUT_M19A0201_016 (FR optionnel)
        -- case 28: ' Does that mean we can get back\nto our world?'
        -- case 29: ' Can we return to our world?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Yes, you can go back.\n But...') -- FUT_M19A0201_017 (FR optionnel)
        UI:WaitShowDialogue(' Celebi is the Pokémon that sent\nme to the past.') -- FUT_M19A0201_018 (FR optionnel)
        UI:WaitShowDialogue(' That means Celebi has lent her\nsupport to reshaping history.') -- FUT_M19A0201_019 (FR optionnel)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Wait a second...\n Does that mean\nCelebi\'s in trouble too?') -- FUT_M19A0201_020 (FR optionnel)
        -- case 34: " Wait a second...[K] Does that mean\n[CS:N]Celebi[CR]'s in trouble too?"
        -- case 35: " Wait...[K] Are you saying that\n[CS:N]Celebi[CR]'s in trouble too?"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' That\'s right.\n Primal Necrozma is\nalso targeting Celebi.') -- FUT_M19A0201_021 (FR optionnel)
        UI:WaitShowDialogue(' So there\'s no time to waste.') -- FUT_M19A0201_022 (FR optionnel)
        UI:WaitShowDialogue(' Get ready soon. We have to find\nCelebi.') -- FUT_M19A0201_023 (FR optionnel)
        UI:ResetSpeaker()
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m19a0201] scène interrompue : '..tostring(err)) end
end

return m19a0201
