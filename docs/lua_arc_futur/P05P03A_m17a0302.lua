--[[
    P05P03A_m17a0302.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P05P03A/m17a0302.ssb
    Généré par tools/ssb_to_lua.py — IR canonique + couche d'adaptation New Era.
    Les dialogues joués sont des clés STRINGS (FUT_*), le texte canonique Sky
    est conservé en commentaire. Les tables anim/SE/effets manquantes sont
    marquées TODO (jamais inventées).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

local m17a0302 = {}

function m17a0302.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- back_SetGround(P05P03A) : ground courant déjà posé
        -- supervision_tationCommon layer [0] (structurel)
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Struggle', true) end) -- id 78 (ligoté)
        GAME:FadeIn(120)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8964') end) -- TODO table SE id 8964
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_001')) -- canon:  Wh-where is this?!
        -- case 0: ' Wh-where is this?!'
        -- case 1: ' Wh-where is this?!'
        UI:ResetSpeaker()
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + -1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + -1*8, false, 2.0)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_002')) -- canon:  They have me trussed up. I can't move...
        -- case 3: " They have me trussed up.\nI can't move..."
        -- case 4: " They have me trussed up.\nI can't move..."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_003')) -- canon:  Wh-why is this happening?
        -- case 6: ' Wh-why is this happening?'
        -- case 7: ' Wh-why is this happening?'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8711') end) -- TODO table SE id 8711
        -- supervision_emoveActing layer [0] (structurel)
        -- supervision_cting layer [1] (structurel)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Struggle', true) end) -- id 78 (ligoté)
            end,
            function()
                pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Struggle', true) end) -- id 78 (ligoté)
            end,
        })
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_004')) -- canon:  Hey!
        -- case 9: ' Hey!'
        -- case 10: ' Hey!'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8964') end) -- TODO table SE id 8964
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownRight, 15)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_005')) -- canon: ([partner]!)
        -- case 12: '([partner]!)'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_006')) -- canon:  Am I glad to see you![K] You're OK, right?
        -- case 14: " Am I glad to see you![K]\nYou're OK, right?"
        -- case 15: " Am I glad to see you![K]\nYou're OK, right?"
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_007')) -- canon:  Humph!
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_008')) -- canon:  You're clueless about what's going to happen...
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_009')) -- canon:  I guess you can afford to be nonchalant about it.
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8964') end) -- TODO table SE id 8964
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_010')) -- canon:  Huh?!
        -- case 20: ' Huh?!'
        -- case 21: ' Huh?!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_011')) -- canon: (That voice came from over there...)
        -- case 23: '(That voice came from over there...)'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8711') end) -- TODO table SE id 8711
        -- supervision_emoveActing layer [1] (structurel)
        -- supervision_cting layer [2] (structurel)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Struggle', true) end) -- id 78 (ligoté)
            end,
            function()
                pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Struggle', true) end) -- id 78 (ligoté)
            end,
            function()
                -- SetAnimation id 34 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_012')) -- canon:  [CS:N]Grovyle[CR]!
        -- case 25: ' [CS:N]Grovyle[CR]!'
        -- case 26: ' [CS:N]Grovyle[CR]!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_013')) -- canon:  You two...[K] Do you have any inkling about where you are?
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_014')) -- canon:  N-no...
        -- case 29: ' N-no...'
        -- case 30: ' N-no...'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_015')) -- canon:  This is a stockade...[K] They're preparing to get rid of us for good.
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_016')) -- canon:  What?![K] G-get rid of us?!
        -- case 33: ' What?![K] G-get rid of us?!'
        -- case 34: ' What?![K] G-get rid of us?!'
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_017')) -- canon:  Wait a second.
        -- case 36: ' Wait a second.'
        -- case 37: ' Wait a second.'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_018')) -- canon:  I can understand why they want to get rid of you, [CS:N]Grovyle[CR].
        -- case 39: ' I can understand why they want\nto get rid of you, [CS:N]Grovyle[CR].'
        -- case 40: " It's easy to understand why\nthey'd want to get rid of you, [CS:N]Grovyle[CR]."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_019')) -- canon:  But why us?!
        -- case 42: ' But why us?!'
        -- case 43: ' But why us?!'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_020')) -- canon:  We haven't done anything wrong!
        -- case 45: " We haven't done anything wrong!"
        -- case 46: " We haven't done anything wrong!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_021')) -- canon:  Humph![K] I couldn't care less.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_022')) -- canon:  You must have done something they can't tolerate.
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8971') end) -- TODO table SE id 8971
        GROUND:CharSetEmote(CH('Teammate1'), 'angry', 3)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Angry')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_023')) -- canon:  What?!
        -- case 50: ' What?!'
        -- case 51: ' What?!'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_024')) -- canon:  We haven't done anything bad!
        -- case 53: " We haven't done anything bad!"
        -- case 54: " We haven't done anything bad!"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_025')) -- canon:  Don't think that we're like you!
        -- case 56: " Don't think that we're like you!"
        -- case 57: " Don't think that we're like you!"
        UI:ResetSpeaker()
        -- SetEffect 0 (aucun) : pas d'effet
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_026')) -- canon:  I don't care.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_027')) -- canon:  You're wasting time losing your cool. Meanwhile, look...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_028')) -- canon:  Here they come.
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7187') end) -- TODO table SE id 7187
        GAME:WaitFrames(30)
        -- supervision_emoveActing layer [2] (structurel)
        -- supervision_cting layer [3] (structurel)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Struggle', true) end) -- id 78 (ligoté)
            end,
            function()
                pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Struggle', true) end) -- id 78 (ligoté)
            end,
            function()
                -- SetAnimation id 34 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:WaitFrames(60)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 772, false, 2.0)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_1'), 208, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_1'), 164, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.Up, 15)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), 244, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_2'), 292, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.Up, 15)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), 208, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_3'), 188, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Up, 15)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), 244, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_4'), 268, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Up, 15)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), 208, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_5'), 212, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Up, 15)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), 244, 788, false, 3.0)
                GROUND:MoveToPosition(CH('Sableye_6'), 244, 728, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Up, 15)
            end,
        })
        GAME:WaitFrames(45)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Down, 15)
            end,
        })
        GAME:WaitFrames(45)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7188') end) -- TODO table SE id 7188
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end,
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(45)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Up, 15)
            end,
        })
        GAME:WaitFrames(10)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 712, false, 3.0)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_029')) -- canon:  Waah! Who are they?!
        -- case 62: ' Waah! Who are they?!'
        -- case 63: ' Waah! Who are they?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_030')) -- canon:  They're the jailers who do all the dirty work around here.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_031')) -- canon:  They also happen to be [CS:N]Dusknoir[CR]'s underlings.
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
            end,
        })
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8973') end) -- TODO table SE id 8973
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_032')) -- canon:  What?![K] The great [CS:N]Dusknoir[CR]'s?!
        -- case 67: " What?![K] The great [CS:N]Dusknoir[CR]'s?!"
        -- case 68: " What?![K] The great [CS:N]Dusknoir[CR]'s?!"
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 772, false, 2.0)
        -- supervision_cting layer [4] (structurel)
        GAME:WaitFrames(1)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6, NPC_YONOWAARU
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Dusknoir'), 228, 788, false, 2.0)
            end,
            function()
                GROUND:CharTurnToChar(CH('Sableye_1'), CH('Dusknoir'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Sableye_2'), CH('Dusknoir'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Sableye_3'), CH('Dusknoir'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Sableye_4'), CH('Dusknoir'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Sableye_5'), CH('Dusknoir'))
            end,
            function()
                GROUND:CharTurnToChar(CH('Sableye_6'), CH('Dusknoir'))
            end,
        })
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
            end,
        })
        SOUND:FadeOutBGM(160)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_033')) -- canon:  Hey! It's [CS:N]Dusknoir[CR]!
        -- case 70: " Hey! It's [CS:N]Dusknoir[CR]!"
        -- case 71: " Hey! It's [CS:N]Dusknoir[CR]!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_034')) -- canon:  Lord [CS:N]Dusknoir[CR].[K] The three have been tied to the stakes.
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_035')) -- canon:  Good.
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_036')) -- canon:  [CS:N]Dusknoir[CR], sir![K] It's me, [partner]!
        -- case 75: " [CS:N]Dusknoir[CR], sir![K]\nIt's me, [partner]!"
        -- case 76: " [CS:N]Dusknoir[CR], sir![K]\nIt's me, [partner]!"
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Dusknoir'), 228, 768, false, 1.0)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_037')) -- canon:  Very well. [CS:N]Sableye[CR].
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_038')) -- canon:  Those three... We need to be rid of them.
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('Oh No!.ogg', true) end) -- OhNo
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_039')) -- canon:  What?!
        -- case 80: ' What?!'
        -- case 81: ' What?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_040')) -- canon:  Pay them no heed.[K] You may get ready.
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_041')) -- canon: [CS:N]Sableye[CR]: Wheh-heh-heh!
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end,
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7188') end) -- TODO table SE id 7188
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end,
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(45)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 676, false, 3.0)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_1'), 156, 696, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.UpRight, 15)
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), 300, 696, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.UpLeft, 15)
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), 180, 704, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Up, 15)
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), 276, 704, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Up, 15)
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), 212, 704, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Up, 15)
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), 244, 704, false, 2.398)
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Up, 15)
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_042')) -- canon:  W-wait a minute! [CS:N]Dusknoir[CR], sir!
        -- case 85: ' W-wait a minute! [CS:N]Dusknoir[CR], sir!'
        -- case 86: ' W-wait a minute! [CS:N]Dusknoir[CR], sir!'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_043')) -- canon:  What's wrong with you?!
        -- case 88: " What's wrong with you?!"
        -- case 89: " What's wrong with you?!"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_044')) -- canon:  Why are you doing this to us?!
        -- case 91: ' Why are you doing this to us?!'
        -- case 92: ' Why are you doing this to us?!'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownRight, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_045')) -- canon:  Don't waste your breath...[K] Instead...shhhh...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_046')) -- canon:  ...Keep your voices down so they can't hear you...
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_047')) -- canon:  Urk...! Keep...my voice down?
        -- case 96: ' Urk...! Keep...my voice down?'
        -- case 97: ' Urk...! Keep...my voice down?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_048')) -- canon:  You two...[K] If you want to get away...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_049')) -- canon:  ...give me your full cooperation.
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_050')) -- canon:  What...?[K] Help you, [CS:N]Grovyle[CR]...?
        -- case 101: ' What...?[K] Help you, [CS:N]Grovyle[CR]...?'
        -- case 102: ' What...?[K] Help you, [CS:N]Grovyle[CR]...?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_051')) -- canon:  There's no time to think...[K] or would you prefer to stick around for them?
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_052')) -- canon:  Psst...hey! You there...
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8978') end) -- TODO table SE id 8978
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_053')) -- canon: (...!)
        -- case 106: '(...!)'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_054')) -- canon:  ...Tell me...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_055')) -- canon:  ...What can you do right now?
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_056')) -- canon: (What?[K] What can I do?)
        -- case 110: '(What?[K] What can I do?)'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_057')) -- canon: (You ask me that out of nowhere...![K] Umm...)
        -- case 112: '(You ask me that out of nowhere...![K] Umm...)'
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_058')) -- canon: (Wh-what to do...?)
        -- case 114: '(Wh-what to do...?)'
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_059')) -- canon:  ...No. An item's no good...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_060')) -- canon:  ...We're tied up...and unable to move...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_061')) -- canon:  ...It should be something you can do instantaneously...
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_062')) -- canon: (Urk...! That's easy for you to say...[K] Ummm...)
        -- case 122: "(Urk...! That's easy for you to say...[K] Ummm...)"
        -- Jump (structurel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_063')) -- canon:  ...A move...?[K] That could work, but...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_064')) -- canon:  ...No! That's no good...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_065')) -- canon:  ...We're trussed up...so we can't move...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_066')) -- canon:  ...It has to be something you can do instantaneously...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_067')) -- canon:  ...It doesn't need to be flashy... Can't you do anything more basic...?
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_068')) -- canon: (Urk...! You're not helping...[K] Ummm...)
        -- case 129: "(Urk...! You're not helping...[K] Ummm...)"
        -- Jump (structurel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8965') end) -- TODO table SE id 8965
        GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_069')) -- canon:  ...! That's it... That'll do...
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_070')) -- canon:  ...If it's just a regular attack, I can help too...
        -- case 132: " ...If it's just a regular attack,\nI can help too..."
        -- case 133: " ...If it's just a regular attack,\nI can help too..."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_071')) -- canon:  ...Good.
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Down, 15)
            end,
        })
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 772, false, 3.0)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharTurnToChar(CH('Sableye_1'), CH('Dusknoir'))
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharTurnToChar(CH('Sableye_2'), CH('Dusknoir'))
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharTurnToChar(CH('Sableye_3'), CH('Dusknoir'))
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharTurnToChar(CH('Sableye_4'), CH('Dusknoir'))
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharTurnToChar(CH('Sableye_5'), CH('Dusknoir'))
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharTurnToChar(CH('Sableye_6'), CH('Dusknoir'))
            end,
        })
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_072')) -- canon:  Then we are ready to begin!
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7196') end) -- TODO table SE id 7196
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 23 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 23 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 23 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 23 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 23 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 23 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end,
        })
        -- PARTIEL : se_Stop [7196]
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_073')) -- canon:  Very well.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_074')) -- canon:  But be vigilant to the end. Don't take your eyes off them.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_075')) -- canon:  Especially that [CS:N]Grovyle[CR].
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_076')) -- canon: [CS:N]Sableye[CR]: Wheh-heh-heh!
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end,
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7188') end) -- TODO table SE id 7188
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 22 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end,
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(45)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Up, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.Up, 15)
            end,
        })
        GROUND:MoveToPosition(CH('Dusknoir'), CH('Dusknoir').Position.X + 0.5*8, CH('Dusknoir').Position.Y + 0*8, false, 1.0)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Up, 15)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_077')) -- canon:  Commence...[K]now!
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 676, false, 3.0)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_078')) -- canon: [CS:N]Sableye[CR]: Wheh-heh-heh!
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end,
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 0*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 0*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 0*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.UpRight, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.UpLeft, 15)
            end,
        })
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_079')) -- canon:  ...! They're coming...
        -- case 143: " ...! They're coming..."
        -- case 144: " ...! They're coming..."
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownRight, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_080')) -- canon:  ...Listen carefully...
        UI:ResetSpeaker()
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
            end,
        })
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_081')) -- canon:  ...[CS:N]Sableye[CR] use claws to strike...
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_082')) -- canon:  ...! Yikes...that sounds scary!
        -- case 148: ' ...! Yikes...that sounds scary!'
        -- case 149: ' ...! Yikes...that sounds scary!'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 0*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 0*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 0*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.UpRight, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.UpLeft, 15)
            end,
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_083')) -- canon:  ...And that might just open one avenue for escape...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_084')) -- canon:  ...The [CS:N]Sableye[CR] will unleash their [CS:M]Fury Swipes[CR] in a frenzy...[K] That's our chance.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_085')) -- canon:  ...If even one of their attacks were to hit the ropes binding us...
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8978') end) -- TODO table SE id 8978
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_086')) -- canon:  ...Oh, right...![K] The ropes might come loose!
        -- case 154: ' ...Oh, right...![K] The ropes might\ncome loose!'
        -- case 155: ' ...Oh, right...![K] The ropes might\ncome loose!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_087')) -- canon:  ...Exactly...[K]and if that happens, lash out with an attack, then flee!
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 8*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + -8*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 0*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 0*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.UpRight, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.UpLeft, 15)
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_088')) -- canon:  ...B-b-but...
        -- case 158: ' ...B-b-but...'
        -- case 159: ' ...B-b-but...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_089')) -- canon:  ...What if their [CS:M]Fury Swipes[CR] don't slash the ropes...?
        -- case 161: " ...What if their [CS:M]Fury Swipes[CR]\ndon't slash the ropes...?"
        -- case 162: " ...What if their [CS:M]Fury Swipes[CR]\ndon't slash the ropes...?"
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 0.5*8, CH('Sableye_1').Position.Y + 0*8, false, 1.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 0.5*8, CH('Sableye_2').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 0.5*8, CH('Sableye_3').Position.Y + 0*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 0.5*8, CH('Sableye_4').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.5*8, CH('Sableye_5').Position.Y + 0*8, false, 1.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 0.5*8, CH('Sableye_6').Position.Y + 0*8, false, 1.0)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.UpRight, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.UpLeft, 15)
            end,
        })
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_090')) -- canon:  ...And what if...[K] What if the [CS:N]Sableye[CR] don't use [CS:M]Fury Swipes[CR] at all...?
        UI:SetCenter(false)
        -- case 164: " ...And what if...[K] What if the\n[CS:N]Sableye[CR] don't use [CS:M]Fury Swipes[CR] at all...?"
        -- case 165: " ...And what if...[K] What if the\n[CS:N]Sableye[CR] don't use [CS:M]Fury Swipes[CR] at all...?"
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7194') end) -- TODO table SE id 7194
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 24 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 24 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 24 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 24 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 24 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 24 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end,
        })
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_091')) -- canon: [CS:N]Sableye[CR]: Wheh-heh-heh!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_092')) -- canon:  If that happens...[K]don't even think about it.
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7196') end) -- TODO table SE id 7196
        -- supervision_cting layer [8] (structurel)
        -- object 138 (p05p03a2) : contexte objet
        local obj_138 = OBJ('p05p03a2') -- objet 138
        GROUND:ObjectSetAnim(obj_138, 1, 0, 3, Direction.Down, 1) -- anim 1 (table REQUISE)
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 45 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 45 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 45 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 45 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 45 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 45 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Left, 15)
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
                GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Left, 15)
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Shouting')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_093')) -- canon:  WAAAAAAH!
        -- case 169: ' WAAAAAAH!'
        -- case 170: ' WAAAAAAH!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_094')) -- canon: (Urggh!)
        -- case 172: '(Urggh!)'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_095')) -- canon:  En...en...endure it![K] Wait for your chance!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_096')) -- canon:  But if they keep going...
        -- case 175: ' But if they keep going...'
        -- case 176: ' But if they keep going...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_097')) -- canon:  We'll be down before our chance comes!
        -- case 178: " We'll be down before our\nchance comes!"
        -- case 179: " We'll be finished before our\nchance comes!"
        UI:ResetSpeaker()
        -- object 136 (p05p03a1) : contexte objet
        local obj_136 = OBJ('p05p03a1') -- objet 136
        GROUND:ObjectSetAnim(obj_136, 18, 0, 3, Direction.Down, 1) -- anim 18 (table REQUISE)
        GROUND:TeleportTo(CH('PLAYER'), CH('PLAYER').Position.X + 0*8, CH('PLAYER').Position.Y + 2*8)
        -- object 136 (p05p03a1) : contexte objet
        -- WaitAnimation sur objet p05p03a1 : PARTIEL
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_098')) -- canon:  Hey!
        -- case 181: ' Hey!'
        -- case 182: ' Hey!'
        UI:ResetSpeaker()
        -- object 135 (p05p03a1) : contexte objet
        local obj_135 = OBJ('p05p03a1') -- objet 135
        GROUND:ObjectSetAnim(obj_135, 18, 0, 3, Direction.Down, 1) -- anim 18 (table REQUISE)
        GROUND:TeleportTo(CH('Teammate1'), CH('Teammate1').Position.X + 0*8, CH('Teammate1').Position.Y + 2*8)
        -- object 135 (p05p03a1) : contexte objet
        -- WaitAnimation sur objet p05p03a1 : PARTIEL
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_099')) -- canon: (There's a break in the rope!)
        -- case 184: "(There's a break in the rope!)"
        UI:ResetSpeaker()
        -- object 137 (p05p03a1) : contexte objet
        local obj_137 = OBJ('p05p03a1') -- objet 137
        GROUND:ObjectSetAnim(obj_137, 18, 0, 3, Direction.Down, 1) -- anim 18 (table REQUISE)
        GROUND:TeleportTo(CH('Grovyle'), CH('Grovyle').Position.X + 0*8, CH('Grovyle').Position.Y + 2*8)
        -- object 137 (p05p03a1) : contexte objet
        -- WaitAnimation sur objet p05p03a1 : PARTIEL
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Down, 15)
        GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_100')) -- canon:  Now![K] Attack!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_101')) -- canon:  Go!
        -- case 187: ' Go!'
        -- case 188: ' Go!'
        UI:ResetSpeaker()
        -- PARTIEL : se_FadeOut [7196, 10]
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        -- object 138 (p05p03a2) : contexte objet
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_6')) end)
        -- object 136 (p05p03a1) : contexte objet
        local obj_136 = OBJ('p05p03a1') -- objet 136
        GROUND:ObjectSetAnim(obj_136, 19, 0, 3, Direction.Down, 1) -- anim 19 (table REQUISE)
        -- object 137 (p05p03a1) : contexte objet
        local obj_137 = OBJ('p05p03a1') -- objet 137
        GROUND:ObjectSetAnim(obj_137, 19, 0, 3, Direction.Down, 1) -- anim 19 (table REQUISE)
        -- object 135 (p05p03a1) : contexte objet
        local obj_135 = OBJ('p05p03a1') -- objet 135
        GROUND:ObjectSetAnim(obj_135, 19, 0, 3, Direction.Down, 1) -- anim 19 (table REQUISE)
        -- object 135 (p05p03a1) : contexte objet
        -- WaitAnimation sur objet p05p03a1 : PARTIEL
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('PLAYER'), 228, 668, false, 5.0)
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('Teammate1'), 276, 668, false, 5.0)
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('Grovyle'), 180, 668, false, 5.0)
            end,
        })
        -- object 135 (p05p03a1) : contexte objet
        local obj_135 = OBJ('p05p03a1') -- objet 135
        GROUND:ObjectSetAnim(obj_135, 12, 0, 3, Direction.Down, 1) -- anim 12 (table REQUISE)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5126') end) -- TODO table SE id 5126
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 13 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 13 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 12 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_102')) -- canon:  Gwah!
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 712, false, 6.0)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Sableye_1'), 'shock', 3)
                -- SetAnimation id 14 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 3*8, CH('Sableye_1').Position.Y + -8*8, false, 6.0)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_2'), 'shock', 3)
                -- SetAnimation id 14 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 3*8, CH('Sableye_2').Position.Y + 8*8, false, 6.0)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_3'), 'shock', 3)
                -- SetAnimation id 14 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 3*8, CH('Sableye_3').Position.Y + 0*8, false, 6.0)
            end,
        })
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Sableye_4'), 'shock', 3)
                -- SetAnimation id 14 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 3*8, CH('Sableye_4').Position.Y + 0*8, false, 6.0)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_5'), 'shock', 3)
                -- SetAnimation id 14 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 3*8, CH('Sableye_5').Position.Y + 0*8, false, 6.0)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_6'), 'shock', 3)
                -- SetAnimation id 14 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                GROUND:AnimateToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 3*8, CH('Sableye_6').Position.Y + 0*8, false, 6.0)
            end,
        })
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 776, false, 4.0)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        GROUND:CharSetEmote(CH('Dusknoir'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_103')) -- canon:  Wh-what is this?!
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 712, false, 4.0)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_104')) -- canon:  There!
        UI:ResetSpeaker()
        SOUND:StopBGM()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7191') end) -- TODO table SE id 7191
        -- SetAnimation id 27 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('Grovyle')) end)
        GAME:FadeOut(true, 5)
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_105')) -- canon:  Gaaaah!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_106')) -- canon:  We can't see!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_107')) -- canon:  Compose yourselves![K] It's only a [CS:I]Luminous Orb[CR]!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_108')) -- canon:  Its effect wears off quickly!
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        pcall(function() GROUND:RemoveCharacter(CH('PLAYER')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Teammate1')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Grovyle')) end)
        GAME:FadeIn(60)
        GAME:WaitFrames(15)
        -- PARTIEL : WaitSe [7191]
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Sableye_1'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_2'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_3'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_4'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_5'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_6'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end,
        })
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(7)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(2)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(3)
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(5)
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(4)
        -- ExecuteCommon(LOOK_AROUND_DOWN_FUNC_SERIES) : gestuelle parallèle à implémenter
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 776, false, 3.0)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8973') end) -- TODO table SE id 8973
        GROUND:CharSetEmote(CH('Dusknoir'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_109')) -- canon:  B-blast it!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_110')) -- canon:  That [CS:N]Grovyle[CR]![K] He fled using the flash from that [CS:I]Luminous Orb[CR] as cover!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_111')) -- canon:  They won't get away with this! Come!
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_112')) -- canon: [CS:N]Sableye[CR]: Wheh-heh-heh!
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
            end,
        })
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Dusknoir'), 228, 932, false, 3.0)
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('Sableye_6'), 244, 916, false, 4.0)
            end,
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('Sableye_5'), 212, 916, false, 4.0)
            end,
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI3, NPC_YAMIRAMI4
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('Sableye_4'), 244, 916, false, 4.0)
            end,
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('Sableye_3'), 212, 916, false, 4.0)
            end,
        })
        GAME:WaitFrames(8)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('Sableye_2'), 244, 916, false, 4.0)
            end,
            function()
                -- SetAnimation id 5 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
                GROUND:MoveToPosition(CH('Sableye_1'), 212, 916, false, 4.0)
            end,
        })
        pcall(function() GROUND:RemoveCharacter(CH('Dusknoir')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_6')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_5')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_4')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_3')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_2')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_1')) end)
        GAME:WaitFrames(60)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 712, false, 2.0)
        GAME:WaitFrames(60)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7192') end) -- TODO table SE id 7192
        -- supervision_cting layer [5] (structurel)
        -- performer 4
        -- SetEffect [54, 3] : performer 4 non mappé (PARTIEL)
        -- SetAnimation id 28 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('Grovyle')) end)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Grovyle'), 'Idle', true) end) -- placeholder sûr
        -- performer 4
        -- SetEffect [0, 3] : performer 4 non mappé (PARTIEL)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7192') end) -- TODO table SE id 7192
        -- supervision_cting layer [6] (structurel)
        -- performer 5
        -- SetEffect [54, 3] : performer 5 non mappé (PARTIEL)
        -- performer 5
        -- WaitEffect [] : performer 5 non mappé (PARTIEL)
        -- performer 5
        -- SetEffect [0, 3] : performer 5 non mappé (PARTIEL)
        -- performer 5
        -- SetEffect [100, 3] : performer 5 non mappé (PARTIEL)
        -- performer 5
        -- WaitEffect [] : performer 5 non mappé (PARTIEL)
        -- performer 5
        -- SetEffect [0, 3] : performer 5 non mappé (PARTIEL)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7192') end) -- TODO table SE id 7192
        -- supervision_cting layer [7] (structurel)
        -- performer 6
        -- SetEffect [54, 3] : performer 6 non mappé (PARTIEL)
        -- performer 6
        -- WaitEffect [] : performer 6 non mappé (PARTIEL)
        -- performer 6
        -- SetEffect [0, 3] : performer 6 non mappé (PARTIEL)
        -- performer 6
        -- SetEffect [100, 3] : performer 6 non mappé (PARTIEL)
        -- performer 6
        -- WaitEffect [] : performer 6 non mappé (PARTIEL)
        -- performer 6
        -- SetEffect [0, 3] : performer 6 non mappé (PARTIEL)
        GAME:WaitFrames(60)
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_113')) -- canon:  Blecch! I got dirt in my mouth...
        -- case 201: ' Blecch! I got dirt in my mouth...'
        -- case 202: ' Blecch! I got dirt in my mouth...'
        UI:ResetSpeaker()
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBGM('In the Depths of the Pit.ogg', true) end) -- InTheDepthsOfThePit
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_114')) -- canon: (We're...[K] We're safe...)
        -- case 204: "(We're...[K] We're safe...)"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_115')) -- canon: (So [CS:N]Grovyle[CR] can use [CS:M]Dig[CR]?)
        -- case 206: '(So [CS:N]Grovyle[CR] can use [CS:M]Dig[CR]?)'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_116')) -- canon: (He sure knows many moves.)
        -- case 208: '(He sure knows many moves.)'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.UpRight, 15)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
            end,
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_117')) -- canon:  We got out of that scrape...[K] But we're not out of the woods yet.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0302_118')) -- canon:  Let's get out of here, and fast.
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 228, 832, false, 2.0)
        GROUND:MoveToPosition(CH('Grovyle'), 192, 796, false, 2.0)
        GAME:WaitFrames(5)
        GROUND:MoveToPosition(CH('Teammate1'), 264, 796, false, 2.0)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('PLAYER'), 264, 772, false, 2.0)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownRight, 15)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownLeft, 15)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Down, 15)
        GAME:WaitFrames(20)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Down, 15)
        GAME:WaitFrames(30)
        SOUND:FadeOutBGM(180)
        GROUND:MoveToPosition(CH('Grovyle'), 228, 932, false, 2.398)
        GAME:WaitFrames(20)
        GROUND:MoveToPosition(CH('Teammate1'), 228, 932, false, 2.398)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('PLAYER'), 228, 932, false, 2.398)
        GAME:WaitFrames(30)
        GAME:FadeOut(false, 60)
        GAME:WaitFrames(80)
        -- flag_CalcBit(SCENARIO_MAIN_BIT_FLAG, 8, 1) : opérations bit (adaptation)
        SV.Scenario.CompulsorySavePoint = 14 -- flag_Set(COMPULSORY_SAVE_POINT)
        -- HANYOU_SAVE_FUNC : point de sauvegarde obligatoire (à brancher)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m17a0302] scène interrompue : '..tostring(err)) end
end

return m17a0302
