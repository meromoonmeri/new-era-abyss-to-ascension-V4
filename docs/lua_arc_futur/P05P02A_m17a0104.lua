--[[
    P05P02A_m17a0104.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P05P02A/m17a0104.ssb
    Généré par tools/ssb_to_lua.py — IR canonique + couche d'adaptation New Era.
    Les dialogues joués sont des clés STRINGS (FUT_*), le texte canonique Sky
    est conservé en commentaire. Les tables anim/SE/effets manquantes sont
    marquées TODO (jamais inventées).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

local m17a0104 = {}

function m17a0104.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0104_001')) -- canon:  Hey...[K][hero]...
        -- case 0: ' Hey...[K][hero]...'
        -- case 1: ' Hey...[K][hero]...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0104_002')) -- canon:  Wake up, [hero]!
        -- case 3: ' Wake up, [hero]!'
        -- case 4: ' Wake up, [hero]!'
        UI:ResetSpeaker()
        -- back_SetGround(P05P02A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        -- SetAnimation id 76 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        GAME:FadeIn(60)
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        GAME:WaitFrames(30)
        GROUND:AnimateToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + -1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + -1*8, false, 2.0)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0104_003')) -- canon: (Ugh...)
        -- case 6: '(Ugh...)'
        UI:ResetSpeaker()
        -- SetAnimation id 63 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8978') end) -- TODO table SE id 8978
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        -- ExecuteCommon(HEAD_SHAKE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0104_004')) -- canon: (Wh-where...?)
        -- case 8: '(Wh-where...?)'
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0104_005')) -- canon:  You're awake!
        -- case 10: " You're awake!"
        -- case 11: " You're awake!"
        UI:ResetSpeaker()
        -- SetAnimation id 5 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + -16*8, false, 2.0)
        GAME:WaitFrames(5)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0104_006')) -- canon:  This place... I think it's a jail.
        -- case 13: " This place... I think it's a jail."
        -- case 14: " This place... I think it's a jail."
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0104_007')) -- canon: (J-jail?!)
        -- case 16: '(J-jail?!)'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0104_008')) -- canon:  I just woke up a while ago, so I'm not sure what's going on.
        -- case 18: " I just woke up a while ago, so\nI'm not sure what's going on."
        -- case 19: " I just woke up a while ago, so\nI'm not sure what's going on."
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0104_009')) -- canon:  I tried opening the doors, but they're locked.
        -- case 21: " I tried opening the doors, but\nthey're locked."
        -- case 22: " I tried the doors, but they're\nlocked."
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0104_010')) -- canon:  There doesn't seem to be any other way out.
        -- case 24: " There doesn't seem to be any\nother way out."
        -- case 25: ' There seems to be no other\nway out.'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0104_011')) -- canon:  I think that we've been locked up...[K] Ugh...
        -- case 27: " I think that we've been locked\nup...[K] Ugh..."
        -- case 28: " I think that we've been locked\nup...[K] Ugh..."
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpLeft, 15)
        GAME:WaitFrames(30)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0104_012')) -- canon: (Wh-what's going on?)
        -- case 30: "(Wh-what's going on?)"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0104_013')) -- canon: (We're locked up?)
        -- case 32: "(We're locked up?)"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0104_014')) -- canon: (I don't know what's going on either, but I may as well investigate...)
        -- case 34: "(I don't know what's going on either, but I may\nas well investigate...)"
        UI:ResetSpeaker()
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m17a0104] scène interrompue : '..tostring(err)) end
end

return m17a0104
