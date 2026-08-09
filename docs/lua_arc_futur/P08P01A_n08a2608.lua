--[[
    P08P01A_n08a2608.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P08P01A/n08a2608.ssb
    Généré par tools/ssb_to_lua.py — IR canonique + couche d'adaptation New Era.
    Les dialogues joués sont des clés STRINGS (FUT_*), le texte canonique Sky
    est conservé en commentaire. Les tables anim/SE/effets manquantes sont
    marquées TODO (jamais inventées).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

local n08a2608 = {}

function n08a2608.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- back_SetGround(P08P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        -- SetAnimation id 12 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('Dusknoir')) end)
        GAME:WaitFrames(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5121') end) -- TODO table SE id 5121
        GAME:FadeOut(true, 2)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 2.5*8, CH('PLAYER').Position.Y + 0*8, false, 5.0)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Sableye_4'), 'shock', 3)
                -- SetAnimation id 29 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
                CH('Sableye_4').Direction = Direction.UpRight
                GROUND:AnimateToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 2.5*8, CH('Sableye_4').Position.Y + -24*8, false, 5.0)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_5'), 'shock', 3)
                -- SetAnimation id 29 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
                CH('Sableye_5').Direction = Direction.UpRight
                GROUND:AnimateToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 2.5*8, CH('Sableye_5').Position.Y + 0*8, false, 5.0)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_6'), 'shock', 3)
                -- SetAnimation id 29 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
                CH('Sableye_6').Direction = Direction.UpRight
                GROUND:AnimateToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 2.5*8, CH('Sableye_6').Position.Y + 24*8, false, 5.0)
            end,
        })
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Sigh')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_001')) -- canon:  Gwah!
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Sableye_1'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Sableye_2'), 'shock', 3)
            end,
        })
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Sableye_3'), 'shock', 3)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
        UI:ResetSpeaker()
        CH('Sableye_4').Direction = Direction.Up
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_4')) end)
        GAME:WaitFrames(7)
        CH('Sableye_6').Direction = Direction.Up
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
        GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.UpRight, 15)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
        GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.UpLeft, 15)
        GROUND:MoveToPosition(CH('Dusknoir'), CH('Dusknoir').Position.X + 0.5*8, CH('Dusknoir').Position.Y + 0*8, false, 1.0)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Sableye_2'), 'sweatdrop', 3)
        GAME:WaitFrames(5)
        GROUND:CharSetEmote(CH('Sableye_4'), 'sweatdrop', 3)
        GAME:WaitFrames(4)
        GROUND:CharSetEmote(CH('Sableye_6'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Sigh')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_002')) -- canon:  Wheh-heh-heh...[K] Eeee...[K]eeeeeeeek!
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7430') end) -- TODO table SE id 7430
        GROUND:MoveToPosition(CH('Sableye_2'), CH('Sableye_2').Position.X + 2.5*8, CH('Sableye_2').Position.Y + 0*8, false, 5.0)
        GAME:WaitFrames(2)
        GROUND:MoveToPosition(CH('Sableye_1'), CH('Sableye_1').Position.X + 2.5*8, CH('Sableye_1').Position.Y + -80*8, false, 5.0)
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI3, NPC_YAMIRAMI4
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), CH('Sableye_3').Position.X + 2.5*8, CH('Sableye_3').Position.Y + 80*8, false, 5.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), CH('Sableye_4').Position.X + 2.5*8, CH('Sableye_4').Position.Y + 16*8, false, 5.0)
            end,
        })
        GAME:WaitFrames(5)
        -- (parallèle) NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), CH('Sableye_6').Position.X + 2.5*8, CH('Sableye_6').Position.Y + -16*8, false, 5.0)
            end,
            function()
                CH('Sableye_5').Direction = Direction.Up
                pcall(function() GROUND:CharWaitAnim(CH('Sableye_5')) end)
            end,
        })
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(15)
        -- ExecuteCommon(LOOK_AROUND_FAST_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Sableye_5'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Down, 15)
        -- (parallèle) NPC_YAMIRAMI5, PLAYER_FUTURE
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Sableye_5'), 'shock', 3)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.Down, 15)
            end,
        })
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_003')) -- canon:  Wait!
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 0*8, false, 2.0)
        GROUND:MoveToPosition(CH('Dusknoir'), CH('Dusknoir').Position.X + 2*8, CH('Dusknoir').Position.Y + 0*8, false, 4.0)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 0.7969*8, CH('Sableye_5').Position.Y + 0*8, false, 1.594)
        -- SetAnimation id 28 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('Dusknoir')) end)
        GAME:WaitFrames(15)
        -- SetAnimation id 11 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7943') end) -- TODO table SE id 7943
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Sigh')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_004')) -- canon:  Ooogh...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_005')) -- canon:  Ugh...[K] You're squishing me...
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        GROUND:MoveToPosition(CH('HeroFuture'), 316, 392, false, 2.0)
        GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.Left, 15)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_006')) -- canon:  Tell us!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_007')) -- canon:  What happened to [CS:N]Celebi[CR]?!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_008')) -- canon:  Where's [CS:N]Dialga[CR]?!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Sigh')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_009')) -- canon:  Ugh...[K] M...[K]Master [CS:N]Dialga[CR]...[K] Ran off in pursuit of [CS:N]Celebi[CR]...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_010')) -- canon:  T-to...[K][CS:P]Frozen Island[CR]...
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_011')) -- canon:  [CS:P]Frozen Island[CR]?
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_012')) -- canon:  That solitary island to the south of here!?
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_013')) -- canon:  Is that right?!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Sigh')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_014')) -- canon:  Y...[K]yeah![K] That's right...
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI5, NPC_YONOWAARU_N8
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 40 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                GROUND:AnimateToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 4*8, CH('Sableye_5').Position.Y + 0*8, false, 8.0)
            end,
        })
        GAME:WaitFrames(15)
        GROUND:AnimateToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 4*8, CH('Sableye_5').Position.Y + 0*8, false, 8.0)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5121') end) -- TODO table SE id 5121
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        -- (parallèle) NPC_YAMIRAMI5, NPC_YONOWAARU_N8, PLAYER_FUTURE
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 27 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
                CH('Sableye_5').Direction = Direction.DownRight
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.DownLeft, 15)
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GROUND:CharSetEmote(CH('Sableye_5'), 'shock', 3)
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Sigh')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_015')) -- canon:  Gwah!
        UI:ResetSpeaker()
        GROUND:AnimateToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 1*8, CH('Sableye_5').Position.Y + -1*8, false, 2.0)
        GAME:WaitFrames(3)
        GROUND:AnimateToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 1*8, CH('Sableye_5').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(3)
        GROUND:AnimateToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 1*8, CH('Sableye_5').Position.Y + -1*8, false, 2.0)
        GAME:WaitFrames(3)
        GROUND:AnimateToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 1*8, CH('Sableye_5').Position.Y + 1*8, false, 2.0)
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Sigh')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_016')) -- canon:  Ooogh...[K] Ahem...
        UI:ResetSpeaker()
        CH('Sableye_5').Direction = Direction.Down
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_5')) end)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(15)
        GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Up, 15)
        GAME:WaitFrames(15)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Sableye_5'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_017')) -- canon:  Beat it!
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Sableye_1'))
        GeneralFunctions.SetEmotion('Sigh')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_018')) -- canon:  Eeee...[K]eeeeeek!
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(120)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_4')) end)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_6')) end)
        GROUND:MoveToPosition(CH('Sableye_5'), CH('Sableye_5').Position.X + 2.5*8, CH('Sableye_5').Position.Y + 0*8, false, 5.0)
        pcall(function() GROUND:RemoveCharacter(CH('Sableye_5')) end)
        GAME:WaitFrames(150)
        GROUND:CharTurnToChar(CH('HeroFuture'), CH('Dusknoir'))
        GROUND:CharTurnToChar(CH('Dusknoir'), CH('HeroFuture'))
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_019')) -- canon:  [CS:P]Frozen Island[CR]...[K] Is it a different land?
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_020')) -- canon:  That's right.[K] We'll have to move across space.
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_021')) -- canon:  How do we do that?
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_022')) -- canon:  Don't worry.
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Down, 15)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_023')) -- canon:  If we follow the cliff south from here...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_024')) -- canon:  The [CS:N]Porygon[CR] there will send us across space.
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.DownRight, 15)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_025')) -- canon:  Let's go.
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 0.5*8, CH('PLAYER').Position.Y + 0*8, false, 1.0)
        -- (parallèle) NPC_YONOWAARU_N8, PLAYER_FUTURE
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Dusknoir'), CH('Dusknoir').Position.X + 0.7969*8, CH('Dusknoir').Position.Y + 0*8, false, 1.594)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.DownLeft, 15)
            end,
        })
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8978') end) -- TODO table SE id 8978
        -- SetEffect id 172 : NON CONVERTI (table effets REQUISE)
        -- WaitEffect (les appels GROUND sont bloquants)
        -- SetAnimation id 41 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('Dusknoir')) end)
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8964') end) -- TODO table SE id 8964
        -- SetEffect id 172 : NON CONVERTI (table effets REQUISE)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_026')) -- canon:  What is it?
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('On the Ceiling.ogg', true) end) -- OnTheCeiling
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_027')) -- canon:  Oh, it's nothing...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_028')) -- canon:  It's just...[K]my arms...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_029')) -- canon:  I feel like I've regained the strength in my arms.
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('HeroFuture'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_030')) -- canon:  ...! (Now that you mention it...)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_031')) -- canon:  (Earlier, when he was pushing around the [CS:N]Sableye[CR], that incredible power...)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_032')) -- canon:  (There's no mistaking it...)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_033')) -- canon:  ([CS:N]Dusknoir[CR]'s power is growing stronger than ever before...)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_034')) -- canon:  (I wonder if his wounds have significantly healed...)
        UI:ResetSpeaker()
        -- MoveHeight [1, 2] : LocHeight (table alt. REQUISE)
        GAME:WaitFrames(1)
        -- MoveHeight [1, 0] : LocHeight (table alt. REQUISE)
        GAME:WaitFrames(7)
        -- MoveHeight [1, 2] : LocHeight (table alt. REQUISE)
        GAME:WaitFrames(1)
        -- MoveHeight [1, 0] : LocHeight (table alt. REQUISE)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_035')) -- canon:  Heh-heh-heh... My strength...[K] My strength is returning...
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2608_036')) -- canon:  .........
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(120)
        GAME:FadeOut(false, 90)
        GAME:WaitFrames(60)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[n08a2608] scène interrompue : '..tostring(err)) end
end

return n08a2608
