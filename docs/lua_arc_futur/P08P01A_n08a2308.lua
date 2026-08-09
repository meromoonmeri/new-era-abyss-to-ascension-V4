--[[
    P08P01A_n08a2308.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P08P01A/n08a2308.ssb
    Généré par tools/ssb_to_lua.py — IR canonique + couche d'adaptation New Era.
    Les dialogues joués sont des clés STRINGS (FUT_*), le texte canonique Sky
    est conservé en commentaire. Les tables anim/SE/effets manquantes sont
    marquées TODO (jamais inventées).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

local n08a2308 = {}

function n08a2308.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        SV.Scenario.Side = 47 -- flag_SetScenario(SCENARIO_SIDE, scenario=47, level=10)
        -- PARTIEL : back_SetDungeonBanner [140, 0] (bannière)
        GAME:FadeIn(16)
        GAME:WaitFrames(60)
        GAME:FadeOut(false, 16)
        GAME:WaitFrames(15)
        -- back_SetGround(P08P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        GAME:WaitFrames(30)
        -- (parallèle) NPC_YONOWAARU_N8, PLAYER_FUTURE
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('HeroFuture'), 296, 308, false, 2.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Dusknoir'), 252, 340, false, 2.0)
            end,
        })
        GAME:WaitFrames(15)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(20)
        GROUND:CharTurnToChar(CH('Dusknoir'), CH('HeroFuture'))
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_001')) -- canon:  Is this it, [CS:Y]Grovyle[CR]?
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_002')) -- canon:  The place you met [CS:N]Celebi[CR]?
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('HeroFuture'), CH('Dusknoir'))
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_003')) -- canon:  Yeah, that's right.
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_004')) -- canon:  ...[K]It's quiet...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_005')) -- canon:  Was she already captured...[K] Was she already taken away...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_006')) -- canon:  Or maybe she sensed danger and ran away from here...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_007')) -- canon:  It's possible she outwitted them...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_008')) -- canon:  Maybe she's still hiding somewhere nearby...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_009')) -- canon:  Could be any one of those...
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_010')) -- canon:  ...[K] (There's something strange about the air here...)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_011')) -- canon:  ([CS:N]Celebi[CR]...[K] She probably left already...)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(30)
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_012')) -- canon: [CS:N]Sableye[CR]: Wheh-heh-heh!
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        -- (parallèle) NPC_YONOWAARU_N8, PLAYER_FUTURE
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('HeroFuture'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Dusknoir'), 'exclaim', 3)
            end,
        })
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.Up, 15)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Down, 15)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_6420') end) -- TODO table SE id 6420
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Sableye_1'), 224, 292, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_2'), 276, 268, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_3'), 332, 292, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_4'), 224, 348, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_5'), 276, 372, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Sableye_6'), 332, 348, false, 3.0)
            end,
        })
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBGM('Oh No!.ogg', true) end) -- OhNo
        -- SetAnimation id 5 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('HeroFuture'), 'Idle', true) end) -- placeholder sûr
        GROUND:AnimateToPosition(CH('HeroFuture'), 276, 308, false, 2.0)
        GAME:WaitFrames(5)
        -- SetAnimation id 5 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
        GROUND:AnimateToPosition(CH('Dusknoir'), 276, 340, false, 2.0)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('HeroFuture'), 'Idle', true) end) -- placeholder sûr
        GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.Up, 15)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YONOWAARU_N8
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
                GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_3'), Direction.DownLeft, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_4'), Direction.UpRight, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_1'), Direction.DownRight, 15)
            end,
        })
        -- PARTIEL : se_FadeOut [6420, 30]
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_6'), Direction.UpLeft, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_2'), Direction.Down, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Sableye_5'), Direction.Up, 15)
            end,
        })
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_013')) -- canon:  I knew it...
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_014')) -- canon:  They brought me right into their trap!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_015')) -- canon:  Humph. [CS:N]Dusknoir[CR]![K] [CS:N]Dialga[CR]'s new henchman...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_016')) -- canon:  Is just as crafty and wicked as you are!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_017')) -- canon:  I am Master [CS:N]Dialga[CR]'s only henchman!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_018')) -- canon:  I can't allow anyone to take my place!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_019')) -- canon:  Here they come!
        UI:ResetSpeaker()
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(10)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
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
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2308_020')) -- canon: [CS:N]Sableye[CR]: Wheh-heh-heh!
        pcall(function() GROUND:CharWaitAnim(CH('Sableye_6')) end)
        -- (parallèle) NPC_YAMIRAMI, NPC_YAMIRAMI2, NPC_YAMIRAMI3, NPC_YAMIRAMI4, NPC_YAMIRAMI5, NPC_YAMIRAMI6
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
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
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 17 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
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
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 4 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
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
                pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        UI:ResetSpeaker()
        -- SetAnimation id 12 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Sableye_1'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(2)
        -- (parallèle) NPC_YAMIRAMI2, NPC_YAMIRAMI3
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 12 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_2'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 12 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_3'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(2)
        -- (parallèle) NPC_YAMIRAMI4, NPC_YAMIRAMI5
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 12 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_4'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 12 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Sableye_5'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        GAME:WaitFrames(2)
        -- SetAnimation id 12 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Sableye_6'), 'Idle', true) end) -- placeholder sûr
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5143') end) -- TODO table SE id 5143
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        GAME:WaitFrames(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_5143') end) -- TODO table SE id 5143
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        -- PARTIEL : WaitSe [5143]
        SOUND:FadeOutBGM(30)
        -- CallCommon(BOSS_WIPE_FUNC) : helper à implémenter
        -- main_EnterDungeon(140) : entrée donjon (mapping id REQUIS)
        -- main_EnterDungeon(32767) : entrée donjon (mapping id REQUIS)
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[n08a2308] scène interrompue : '..tostring(err)) end
end

return n08a2308
