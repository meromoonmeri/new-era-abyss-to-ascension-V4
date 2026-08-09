--[[
    D21P41A_m18b0902.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D21P41A/m18b0902.ssb
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

local m18b0902 = {}

function m18b0902.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

UI:SetSpeaker(CH('Grovyle'))
        UI:WaitShowDialogue(' I\'ve gone quite deep.\n There\'s not\nmuch farther now.') -- FUT_M18B0902_001 (FR optionnel)
        UI:ResetSpeaker()
        -- back_SetGround(D21P41A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        GROUND:MoveToPosition(CH('Grovyle'), 288, 236, false, 2.0)
        GAME:WaitFrames(15)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' If I get through here...') -- FUT_M18B0902_002 (FR optionnel)
        UI:WaitShowDialogue(' I should be at the forest.') -- FUT_M18B0902_003 (FR optionnel)
        UI:WaitShowDialogue(' The Sableye are coming.\n\nThere\'s no time to waste.') -- FUT_M18B0902_004 (FR optionnel)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Left, 15)
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' That reminds me...\n I wonder\nhow those two are doing?') -- FUT_M18B0902_005 (FR optionnel)
        UI:WaitShowDialogue(' Have they eluded the Sableye?') -- FUT_M18B0902_006 (FR optionnel)
        UI:ResetSpeaker()
        -- ExecuteCommon(HEAD_SHAKE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Oh, forget it. This isn\'t the time!') -- FUT_M18B0902_007 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I have to give priority to my\nown mission no matter what!') -- FUT_M18B0902_008 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' I vowed to complete it even if\nit means making sacrifices!') -- FUT_M18B0902_009 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Time to go.') -- FUT_M18B0902_010 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), 324, 236, false, 2.0)
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(' You there! STOP!') -- FUT_M18B0902_011 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Hmm?') -- FUT_M18B0902_012 (FR optionnel)
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_DOWN_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Who\'s there?!') -- FUT_M18B0902_013 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- message_KeyWait (le dialogue bloque déjà)
        pcall(function() SOUND:PlayBGM('Planet\'s Paralysis.ogg', true) end) -- PlanetsParalysis
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(' You INVADE this place with no warning!') -- FUT_M18B0902_014 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Then you DISTURB our slumber!') -- FUT_M18B0902_015 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' Then, without APOLOGY, you try to leave?') -- FUT_M18B0902_016 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Who\'s there?!\n Who are you?!') -- FUT_M18B0902_017 (FR optionnel)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(' You DARE to anger us!') -- FUT_M18B0902_018 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We expect you to PAY for these insults!') -- FUT_M18B0902_019 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' Where are you?!\n Quit hiding and\nreveal yourself!') -- FUT_M18B0902_020 (FR optionnel)
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(' You ACCUSE us of hiding?') -- FUT_M18B0902_021 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We do NOT hide.') -- FUT_M18B0902_022 (FR optionnel)
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We are...\n We are HERE!') -- FUT_M18B0902_023 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_6925') end) -- TODO SE 6925 (None)
        GAME:FadeOut(false, 15)
        -- PARTIEL : WaitSe [6925]
        UI:SetCenter(true)
        UI:WaitShowDialogue(' We are SPIRITOMB!') -- FUT_M18B0902_024 (FR optionnel)
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Spiritomb'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' There is NO MERCY for those\nwho transgress against us!') -- FUT_M18B0902_025 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7425') end) -- TODO SE 7425 (None)
        SOUND:FadeOutBGM(160)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' Gaaaah!') -- FUT_M18B0902_026 (FR optionnel)
        GAME:WaitFrames(15)
        GAME:FadeOut(false, 90)
        UI:ResetSpeaker()
        -- CallCommon(FADE_OUT_ALL_AFTER) : helper à implémenter
        -- WaitBgm : PARTIEL
        -- main_EnterDungeon(30) : entrée donjon (mapping id REQUIS)
        -- main_EnterDungeon(32767) : entrée donjon (mapping id REQUIS)
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m18b0902] scène interrompue : '..tostring(err)) end
end

return m18b0902
