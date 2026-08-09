--[[
    P05P04A_m17a0401.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P05P04A/m17a0401.ssb
    Généré par tools/ssb_to_lua.py — IR canonique + couche d'adaptation New Era.
    Les dialogues joués sont des clés STRINGS (FUT_*), le texte canonique Sky
    est conservé en commentaire. Les tables anim/SE/effets manquantes sont
    marquées TODO (jamais inventées).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

local m17a0401 = {}

function m17a0401.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7193') end) -- TODO table SE id 7193
        GAME:WaitFrames(90)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0401_001')) -- canon:  Come on! This way![K] We need to keep running until we hit the exit!
        UI:ResetSpeaker()
        GAME:WaitFrames(90)
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0401_002')) -- canon:  Come on! Faster! Pick it up!
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Shouting')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0401_003')) -- canon:  This is the fastest I can go!
        -- case 2: ' This is the fastest I can go!'
        -- case 3: ' This is the fastest I can go!'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0401_004')) -- canon:  Quit ordering me around!
        -- case 5: ' Quit ordering me around!'
        -- case 6: ' Quit ordering me around!'
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0401_005')) -- canon:  Anyway, [CS:N]Grovyle[CR]...!
        -- case 8: ' Anyway, [CS:N]Grovyle[CR]...!'
        -- case 9: ' Anyway, [CS:N]Grovyle[CR]...!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0401_006')) -- canon:  What?
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0401_007')) -- canon:  Is this...[K]the future?
        -- case 12: ' Is this...[K]the future?'
        -- case 13: ' Is this...[K]the future?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0401_008')) -- canon:  That's right.[K] You catch on fast.
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0401_009')) -- canon:  Urk! So it is, after all...
        -- case 16: ' Urk! So it is, after all...'
        -- case 17: ' Urk! So it is, after all...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0401_010')) -- canon:  Are we...[K] Are we going to be able to get back to our world?
        -- case 19: ' Are we...[K] Are we going to be\nable to get back to our world?'
        -- case 20: ' Are we...[K] Are we going to be\nable to get back to our world?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0401_011')) -- canon:  Who knows?[K] We just need to get away for now.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0401_012')) -- canon:  If we get caught, returning home will be the least of your worries.[K] Run faster!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0401_013')) -- canon:  I can't![K] I'm exhausted...[K] Huff-huff...
        -- case 24: " I can't![K] I'm exhausted...[K]\nHuff-huff..."
        -- case 25: " I can't![K] I'm exhausted...[K]\nHuff-huff..."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0401_014')) -- canon:  We're almost there![K] Look! The exit is right there!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0401_015')) -- canon:  Huff-huff...[K] Huff-huff...
        -- case 28: ' Huff-huff...[K] Huff-huff...'
        -- case 29: ' Huff-huff...[K] Huff-huff...'
        UI:ResetSpeaker()
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0401_016')) -- canon:  We did it![K] We're...[K]outside!
        -- case 31: " We did it![K] We're...[K]outside!"
        -- case 32: " We did it![K] We're...[K]outside!"
        UI:ResetSpeaker()
        -- PARTIEL : se_FadeOut [7193, 30]
        -- PARTIEL : WaitSe [7193]
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7187') end) -- TODO table SE id 7187
        GAME:WaitFrames(60)
        -- back_SetGround(P05P04A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        -- supervision_cting layer [1] (structurel)
        GAME:WaitFrames(1)
        GROUND:MoveToPosition(CH('Grovyle'), 272, 172, false, 3.0)
        GAME:WaitFrames(15)
        -- supervision_cting layer [2] (structurel)
        GAME:WaitFrames(1)
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1.5*8, CH('PLAYER').Position.Y + 32*8, false, 3.0)
        GAME:WaitFrames(20)
        -- supervision_cting layer [3] (structurel)
        GAME:WaitFrames(1)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Teammate1'), 200, 172, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('PLAYER'), 236, 188, false, 3.0)
            end,
        })
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0401_017')) -- canon:  Wah! What...[K]what is this?!
        -- case 34: ' Wah! What...[K]what is this?!'
        -- case 35: ' Wah! What...[K]what is this?!'
        UI:ResetSpeaker()
        GAME:FadeOut(false, 30)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m17a0401] scène interrompue : '..tostring(err)) end
end

return m17a0401
