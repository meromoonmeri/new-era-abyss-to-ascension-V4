--[[
    P09P01A_m19b1001.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P09P01A/m19b1001.ssb
    Généré par tools/ssb_to_lua.py — IR canonique + couche d'adaptation New Era.
    Les dialogues joués sont des clés STRINGS (FUT_*), le texte canonique Sky
    est conservé en commentaire. Les tables anim/SE/effets manquantes sont
    marquées TODO (jamais inventées).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

local m19b1001 = {}

function m19b1001.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_001')) -- canon:  Oh![K] I see it now!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_002')) -- canon:  There it is!
        UI:ResetSpeaker()
        GAME:FadeOut(false, 0)
        GAME:FadeIn(0)
        -- back_SetGround(P09P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        -- object 141 (p09p01a1) : contexte objet
        local obj_141 = OBJ('p09p01a1') -- objet 141
        GROUND:ObjectSetAnim(obj_141, 1, 0, 3, Direction.Down, 1) -- anim 1 (table REQUISE)
        -- performer 3
        -- SetEffect [640, 3] : performer 3 non mappé (PARTIEL)
        GAME:FadeIn(30)
        pcall(function() SOUND:PlayBGM('Time Gear Remix.ogg', true) end) -- TimeGearRemix
        GAME:WaitFrames(90)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 300, 416, false, 2.0)
        GROUND:MoveToPosition(CH('Celebi'), 284, 404, false, 2.0)
        GAME:WaitFrames(20)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Grovyle'), 316, 404, false, 2.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Teammate1'), 280, 428, false, 2.0)
            end,
        })
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('PLAYER'), 324, 428, false, 2.0)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_003')) -- canon:  Is that...[K]the Passage of Time?
        -- case 2: ' Is that...[K]the Passage of Time?'
        -- case 3: ' Is that...[K]the Passage of Time?'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Teammate1'))
        -- (parallèle) ATTENDANT1, NPC_SEREBII, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Celebi'), CH('Teammate1'))
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpLeft, 15)
            end,
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_004')) -- canon:  That's right.[K] That's the Passage of Time.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_005')) -- canon:  I went through that to go to the past.
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Celebi'))
        GROUND:CharTurnToChar(CH('Celebi'), CH('Grovyle'))
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_006')) -- canon:  [CS:N]Celebi[CR], only you can open the Passage of Time.
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_007')) -- canon:  Do your thing.
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_008')) -- canon:  Sure.
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Up, 15)
        GROUND:MoveToPosition(CH('Celebi'), CH('Celebi').Position.X + 0.7969*8, CH('Celebi').Position.Y + 0*8, false, 1.594)
        SOUND:FadeOutBGM(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end,
        })
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_009')) -- canon:  Stop there![K] That will do!
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_010')) -- canon:  What...?[K] That voice!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_011')) -- canon:  It... It can't be...
        -- case 12: " It... It can't be..."
        -- case 13: " It... It can't be..."
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_012')) -- canon:  Hello to you all.[K] It's been a while.
        UI:SetCenter(false)
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, NPC_SEREBII, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Up, 15)
            end,
        })
        -- supervision_cting layer [1] (structurel)
        GAME:WaitFrames(1)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 300, 308, false, 3.0)
        pcall(function() SOUND:PlayBGM('The Power of Darkness.ogg', true) end) -- ThePowerOfDarkness
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_013')) -- canon:  [CS:N]D-Dusknoir[CR]!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_014')) -- canon:  [CS:N]Dusknoir[CR]...
        -- case 17: ' [CS:N]Dusknoir[CR]...'
        -- case 18: ' [CS:N]Dusknoir[CR]...'
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 300, 416, false, 1.0)
        GROUND:MoveToPosition(CH('Dusknoir'), 300, 348, false, 1.0)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_015')) -- canon:  Your scurrying carried you far...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_016')) -- canon:  But sad to say...[K] That's all over now.
        UI:ResetSpeaker()
        -- SetAnimation id 5 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Celebi'), 'Idle', true) end) -- placeholder sûr
        GROUND:AnimateToPosition(CH('Celebi'), CH('Celebi').Position.X + 1*8, CH('Celebi').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 1*8, CH('Grovyle').Position.Y + 0*8, false, 2.0)
            end,
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 0*8, false, 2.0)
            end,
        })
        GAME:WaitFrames(5)
        -- SetAnimation id 5 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 0*8, false, 2.0)
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Celebi'), 'Idle', true) end) -- placeholder sûr
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
        -- supervision_cting layer [2] (structurel)
        GAME:WaitFrames(1)
UI:SetSpeaker(CH('Sableye_1'))
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_017')) -- canon:  Wheh-heh-heh!
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- (parallèle) NPC_JUPUTORU, NPC_SEREBII, NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Celebi'), 'shock', 3)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_1'), 216, 364, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), 384, 364, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), 204, 396, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), 396, 396, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), 208, 428, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), 392, 428, false, 3.0)
            end,
        })
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(12)
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(7)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(5)
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_018')) -- canon:  The [CS:N]Sableye[CR] too...
        -- case 23: ' The [CS:N]Sableye[CR] too...'
        -- case 24: ' The [CS:N]Sableye[CR] too...'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_019')) -- canon:  Humph.[K] That's crafty, [CS:N]Dusknoir[CR].
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_020')) -- canon:  You allowed us to roam free, but you kept your eye on us the whole time...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_021')) -- canon:  So you could capture [CS:N]Celebi[CR] as well as us.
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8973') end) -- TODO table SE id 8973
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_022')) -- canon:  What?![K] So you mean we were...
        -- case 29: ' What?![K] So you mean we were...'
        -- case 30: ' What?![K] So you mean we were...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_023')) -- canon:  followed the whole time?!
        -- case 32: ' followed the whole time?!'
        -- case 33: ' followed the whole time?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_024')) -- canon:  Humph. I didn't see this coming.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_025')) -- canon:  It's all my fault, [CS:N]Celebi[CR].
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_026')) -- canon:  Oh?[K] Apologies don't suit your style, my dear [CS:N]Grovyle[CR]!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_027')) -- canon:  And do you honestly think that I can be caught? Tee-hee!
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 8*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + -8*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 8*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + -8*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 8*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_JUPUTORU, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + -8*8, false, 1.0)
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Left, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Right, 15)
            end,
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 0.5*8, CH('Grovyle').Position.Y + -8*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_SEREBII, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Celebi'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Celebi'), CH('Celebi').Position.X + 0.5*8, CH('Celebi').Position.Y + 8*8, false, 1.0)
            end,
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 0.5*8, CH('PLAYER').Position.Y + -8*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- SetAnimation id 5 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 0.5*8, CH('Teammate1').Position.Y + 8*8, false, 1.0)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
        -- (parallèle) NPC_SEREBII, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Celebi'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(10)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_028')) -- canon:  Everyone![K] Are you ready to fight?!
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8964') end) -- TODO table SE id 8964
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_029')) -- canon:  Huh?![K] You bet I am!
        -- case 40: ' Huh?![K] You bet I am!'
        -- case 41: ' What?![K] Of course!'
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_030')) -- canon:  We're going to power our way through!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_031')) -- canon:  We'll push them aside...[K] Then dive into the Passage of Time!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_032')) -- canon:  G-got it!
        -- case 45: ' G-got it!'
        -- case 46: ' G-got it!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Right, 15)
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_033')) -- canon:  Ha! So you'll resist?
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_034')) -- canon:  Spare yourself the effort.[K] You have no chance of succeeding.
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 8*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + -8*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 8*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + -8*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 8*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + -8*8, false, 1.0)
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_035')) -- canon:  We won't know for sure...[K]until we try!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_036')) -- canon:  [CS:N]Dusknoir[CR]![K] You and me! Now!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_037')) -- canon:  [CS:N]Grovyle[CR].[K] Are you really such a fool to think that I'd come alone?
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Up, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_038')) -- canon:  Wh-what?!
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
        GAME:WaitFrames(5)
        -- (parallèle) ATTENDANT1, NPC_SEREBII, NPC_YONOWAARU
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Up, 15)
            end,
        })
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_039')) -- canon:  Now, Master [CS:N]Dialga[CR]!
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7434') end) -- TODO table SE id 7434
        GAME:FadeOut(false, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_040')) -- canon:  Whoa![K] It turned pitch black!
        -- case 55: ' Whoa![K] It turned pitch black!'
        -- case 56: ' Waah![K] It turned pitch black!'
        UI:ResetSpeaker()
        -- PARTIEL : WaitSe [7434]
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5143') end) -- TODO table SE id 5143
        GAME:FadeIn(5)
        GAME:WaitFrames(2)
        GAME:FadeOut(false, 5)
        GAME:WaitFrames(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5143') end) -- TODO table SE id 5143
        GAME:FadeIn(5)
        GAME:WaitFrames(2)
        GAME:FadeOut(false, 5)
        GAME:WaitFrames(30)
        -- PARTIEL : WaitSe [5143]
        pcall(function() SOUND:PlayBattleSE('SSB_SE_6930') end) -- TODO table SE id 6930
        -- message_ImitationSound : PARTIEL
        -- PARTIEL : WaitSe [6930]
        UI:ResetSpeaker()
        -- PARTIEL : back2_SetMode [4]
        -- back2_SetGround(V12P01A) : couche décor (overlay scène, adaptation)
        -- PARTIEL : back2_SetEffect [7, 0]
        -- camera2_SetPositionMark [2, 2, 19, 15] : PARTIEL
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7431') end) -- TODO table SE id 7431
        -- screen2_FadeIn [1, 30] : couche décor (overlay scène, adaptation)
        GAME:WaitFrames(15)
        -- camera2_SetPositionMark [2, 2, 58, 15] : PARTIEL
        GAME:WaitFrames(4)
        -- camera2_SetPositionMark [2, 2, 97, 15] : PARTIEL
        GAME:WaitFrames(90)
        -- PARTIEL : WaitSe [7431]
        -- screen2_FadeOut [1, 30] : couche décor (overlay scène, adaptation)
        GAME:WaitFrames(30)
        -- back2_SetGround(V13P01A) : couche décor (overlay scène, adaptation)
        -- camera2_SetPositionMark [2, 2, 19, 17] : PARTIEL
        -- supervision_cting layer [3] (structurel)
        pcall(function() SOUND:PlayBGM('Planet\'s Paralysis.ogg', true) end) -- PlanetsParalysis
        -- screen2_FadeIn [1, 30] : couche décor (overlay scène, adaptation)
        GAME:WaitFrames(30)
        GAME:WaitFrames(60)
        -- object 265 (v15p01a2) : contexte objet
        local obj_265 = OBJ('v15p01a2') -- objet 265
        GROUND:ObjectSetAnim(obj_265, 18, 0, 3, Direction.Down, 1) -- anim 18 (table REQUISE)
        -- object 265 (v15p01a2) : contexte objet
        -- WaitAnimation sur objet v15p01a2 : PARTIEL
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        -- object 265 (v15p01a2) : contexte objet
        local obj_265 = OBJ('v15p01a2') -- objet 265
        GROUND:ObjectSetAnim(obj_265, 3, 0, 3, Direction.Down, 1) -- anim 3 (table REQUISE)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_6930') end) -- TODO table SE id 6930
        -- message_ImitationSound : PARTIEL
        GAME:WaitFrames(90)
        -- screen2_FadeOut [1, 60] : couche décor (overlay scène, adaptation)
        UI:ResetSpeaker()
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0, 0))
        GAME:WaitFrames(30)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 1))
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 0, 0))
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_041')) -- canon:  Waaah!
        -- case 60: ' Waaah!'
        -- case 61: ' Waaah!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_042')) -- canon:  That...[K] That's...!
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_043')) -- canon:  [CS:N]Grovyle[CR]![K] What is it?! What is that thing?!
        -- case 64: ' [CS:N]Grovyle[CR]![K] What is it?! What is\nthat thing?!'
        -- case 65: ' [CS:N]Grovyle[CR]![K] What is it?! What is\nthat?!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Down, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_044')) -- canon:  That's...[K]Primal...[K][CS:N]Dialga[CR]...
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8973') end) -- TODO table SE id 8973
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_045')) -- canon:  What!?![K] That is?!
        -- case 68: ' What!?![K] That is?!'
        -- case 69: ' What!?![K] That is?!'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_046')) -- canon:  That's Primal [CS:N]Dialga[CR]?!
        -- case 71: " That's Primal [CS:N]Dialga[CR]?!"
        -- case 72: " That's Primal [CS:N]Dialga[CR]?!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_047')) -- canon:  What's wrong, [CS:N]Grovyle[CR]?[K] Where's your bravado now?
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_048')) -- canon:  Gah...
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Celebi'), CH('Grovyle'))
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_049')) -- canon:  My dear [CS:N]Grovyle[CR]...
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharTurnToChar(CH('PLAYER'), CH('Grovyle'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
            end,
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_050')) -- canon:  Urf...[K] This...[K]is it for us...
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO table SE id 8974
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharSetEmote(CH('Celebi'), 'shock', 3)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_051')) -- canon:  Huh?! Why?!
        -- case 78: ' Huh?! Why?!'
        -- case 79: ' What?! Why?!'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_052')) -- canon:  Aren't we going to fight?!
        -- case 81: " Aren't we going to fight?!"
        -- case 82: " Aren't we going to fight?!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_053')) -- canon:  It's hopeless...[K] [CS:N]Dusknoir[CR] on his own is one thing...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_054')) -- canon:  But we don't stand a chance against [CS:N]Dialga[CR].
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_055')) -- canon:  You two have kept up so well...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_056')) -- canon:  I'm sorry to let you down.[K] This is where it ends.
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_057')) -- canon:  But...
        -- case 88: ' But...'
        -- case 89: ' But...'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Up, 15)
        GAME:WaitFrames(30)
        -- (parallèle) NPC_JUPUTORU, NPC_SEREBII
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 0.5*8, CH('Grovyle').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.UpRight, 15)
            end,
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_058')) -- canon:  I surrender, [CS:N]Dusknoir[CR].
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_059')) -- canon:  Do with me...as you will.
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        GROUND:CharSetEmote(CH('Celebi'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_060')) -- canon:  My d-d-dear [CS:N]Grovyle[CR]!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_061')) -- canon:  What's the matter, [CS:N]Grovyle[CR]?
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_062')) -- canon:  It's not like you to give up so easily.
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_063')) -- canon:  Yes.[K] I am giving up.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_064')) -- canon:  But...[K]hope is still alive.
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Celebi'))
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_065')) -- canon:  [CS:N]Celebi[CR], you remember...
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Dusknoir'))
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_066')) -- canon:  That last time...[K]when I traveled back in time to prevent the planet's paralysis...
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_067')) -- canon:  I wasn't alone.[K] There was another.
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_068')) -- canon:  What?![K] [CS:N]Grovyle[CR], you didn't come to our world by yourself?!
        -- case 101: " What?![K] [CS:N]Grovyle[CR], you didn't come\nto our world by yourself?!"
        -- case 102: " What?![K] [CS:N]Grovyle[CR], you didn't come\nto our world alone?!"
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Teammate1'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Grovyle'))
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_069')) -- canon:  That's right.[K] I had a partner.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_070')) -- canon:  We headed to the past together.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_071')) -- canon:  But when we were going through the Passage of Time, we had trouble...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_072')) -- canon:  We became separated.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_073')) -- canon:  My partner should still be back in the world of the past.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_074')) -- canon:  Even if I am eliminated...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_075')) -- canon:  My partner will see our mission through to the end.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_076')) -- canon:  My partner will prevent the planet's paralysis.
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(180)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_077')) -- canon:  .....................
        -- message_KeyWait (le dialogue bloque déjà)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_078')) -- canon:  Ha![K] Ha-ha-ha! Hoo-hoo-ha!
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8964') end) -- TODO table SE id 8964
        GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Dusknoir'))
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('Dusknoir'))
            end,
            function()
                GROUND:CharTurnToChar(CH('PLAYER'), CH('Dusknoir'))
            end,
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_079')) -- canon:  What's...[K] What's so funny?
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_080')) -- canon:  Ha![K] So you claim someone went to the past with you...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_081')) -- canon:  Incidentally, what's the name of your partner?
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_082')) -- canon:  Go on. Say the name.
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_083')) -- canon:  Why ask such a thing?
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_084')) -- canon:  Can't tell me?
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_085')) -- canon:  No, that's not true.[K] My partner's name is [hero].
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_086')) -- canon:  My best friend...
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_087')) -- canon: (What?!)
        -- case 122: '(What?!)'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_088')) -- canon:  Uh...what?!
        -- case 124: ' Uh...what?!'
        -- case 125: ' Wh-what?!'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_089')) -- canon:  [CS:N]Grovyle[CR]![K] You said [hero]?!
        -- case 127: ' [CS:N]Grovyle[CR]![K] You said\n[hero]?!'
        -- case 128: ' [CS:N]Grovyle[CR]![K] Did you say\n[hero]?!'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8971') end) -- TODO table SE id 8971
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_090')) -- canon:  Well, this is [hero] right here!
        UI:SetCenter(false)
        -- case 130: ' Well, this is [hero]\nright here!'
        -- case 131: ' Well, this is [hero]\nright here!'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        -- (parallèle) NPC_JUPUTORU, NPC_SEREBII
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Celebi'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end,
        })
        GROUND:CharTurnToChar(CH('Grovyle'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('Celebi'), CH('PLAYER'))
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_091')) -- canon:  What?!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_092')) -- canon:  You're...[K][hero]?
        UI:ResetSpeaker()
        GAME:WaitFrames(45)
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_093')) -- canon:  ...[K]No...[K]it can't be. It isn't.
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_094')) -- canon:  The [hero] I know isn't a Pokémon.
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Teammate1'))
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_095')) -- canon:  The [hero] that I know...[K]is a human.
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_096')) -- canon:  What?!
        -- case 138: ' What?!'
        -- case 139: ' What?!'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('Hidden Highland.ogg', true) end) -- HiddenHighland
        -- SetAnimation id 49 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_097')) -- canon:  Hoo-hoo-ha![K] Precisely!
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharTurnToChar(CH('PLAYER'), CH('Dusknoir'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('Dusknoir'))
            end,
        })
        -- (parallèle) NPC_JUPUTORU, NPC_SEREBII
        TASK:JoinCoroutines({
            function()
                GROUND:CharTurnToChar(CH('Grovyle'), CH('Dusknoir'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Celebi'), CH('Dusknoir'))
            end,
        })
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_098')) -- canon:  My good fellow! [CS:N]Grovyle[CR], that is unmistakably your friend [hero]!
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_099')) -- canon:  What?!
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('PLAYER'))
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_100')) -- canon:  That Pokémon you see was once a human!
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8973') end) -- TODO table SE id 8973
        GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Dusknoir'))
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_101')) -- canon:  Wh-what?!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_102')) -- canon:  Master [CS:N]Dialga[CR] had given me a mission...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_103')) -- canon:  It was to get rid of you, [CS:N]Grovyle[CR], and [hero]. Because you fled to the past.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_104')) -- canon:  I traveled through time in pursuit of you both.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19B1001_105')) -- canon:  In the past, I gathered intelligence that might help me find you.
        UI:ResetSpeaker()
        GAME:FadeOut(true, 30)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m19b1001] scène interrompue : '..tostring(err)) end
end

return m19b1001
