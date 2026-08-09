--[[
    P05P01A_n08a2008.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P05P01A/n08a2008.ssb
    Généré par tools/ssb_to_lua.py — IR canonique + couche d'adaptation New Era.
    Les dialogues joués sont des clés STRINGS (FUT_*), le texte canonique Sky
    est conservé en commentaire. Les tables anim/SE/effets manquantes sont
    marquées TODO (jamais inventées).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

local n08a2008 = {}

function n08a2008.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_001')) -- canon:  All right![K] Made it through the dungeon!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_002')) -- canon:  What you see over there is the pinnacle, [CS:Y]Grovyle[CR].
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_003')) -- canon:  Got it![K] Let's go!
        UI:ResetSpeaker()
        -- back_SetGround(P05P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:WaitFrames(1)
        -- (parallèle) NPC_YONOWAARU_N8, PLAYER_FUTURE
        TASK:JoinCoroutines({
            function()
                -- SetOutputAttribute [8] : PARTIEL
            end,
            function()
                -- SetOutputAttribute [8] : PARTIEL
            end,
        })
        -- NON CONVERTI : bgm2_PlayFadeIn (un seul canal BGM dans PMDO)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        GROUND:MoveToPosition(CH('HeroFuture'), 180, 308, false, 2.0)
        GAME:WaitFrames(55)
        GROUND:MoveToPosition(CH('Dusknoir'), 220, 332, false, 2.0)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(50)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Down, 15)
        GAME:WaitFrames(25)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 204, 248, false, 0.5)
        GROUND:MoveToPosition(CH('HeroFuture'), 180, 252, false, 2.0)
        GAME:WaitFrames(20)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.DownRight, 15)
        GAME:WaitFrames(50)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.DownLeft, 15)
        GAME:WaitFrames(10)
        GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.UpRight, 15)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Down, 15)
        GAME:WaitFrames(10)
        -- SetAnimation id 5 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
        GROUND:AnimateToPosition(CH('Dusknoir'), CH('Dusknoir').Position.X + 0.5*8, CH('Dusknoir').Position.Y + 0*8, false, 1.0)
        -- (parallèle) NPC_YONOWAARU_N8, PLAYER_FUTURE
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Dusknoir'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.UpLeft, 15)
            end,
        })
        GAME:WaitFrames(40)
        GROUND:MoveToPosition(CH('Dusknoir'), 220, 252, false, 2.0)
        GAME:WaitFrames(10)
        GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.DownLeft, 15)
        GAME:WaitFrames(50)
        -- (parallèle) NPC_YONOWAARU_N8, PLAYER_FUTURE
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.Left, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Right, 15)
            end,
        })
        GAME:WaitFrames(40)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_004')) -- canon:  ...[K]Nobody's...[K]here, huh...
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Dusknoir'), CH('Dusknoir').Position.X + 0.5*8, CH('Dusknoir').Position.Y + 8*8, false, 1.0)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.UpRight, 15)
        GAME:WaitFrames(40)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.DownRight, 15)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_005')) -- canon:  That's very strange...
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Right, 15)
        GAME:WaitFrames(6)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.UpRight, 15)
        GAME:WaitFrames(6)
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Up, 15)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_006')) -- canon:  Master [CS:N]Dialga[CR] is always over there.
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.Right, 15)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_007')) -- canon:  Why isn't [CS:N]Dialga[CR] there now?
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_008')) -- canon:  [CS:N]Sableye[CR] said that [CS:N]Dialga[CR] would send a final agent.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_009')) -- canon:  But to send another agent back to the past...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_010')) -- canon:  I expect it would take an enormous amount of power.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_011')) -- canon:  To generate that kind of power...[K] [CS:N]Dialga[CR] would have to hold still for some time...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_012')) -- canon:  I thought he was in [CS:P]Temporal Tower[CR]...
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Down, 15)
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_013')) -- canon:  Your guess is correct.[K] I thought so too...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_014')) -- canon:  I thought so...[K] That should be right...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_015')) -- canon:  ...[K]However...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_016')) -- canon:  If he's going to send an agent back to the past...[K]there's another method.
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8978') end) -- TODO table SE id 8978
        GROUND:CharSetEmote(CH('HeroFuture'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_017')) -- canon:  Back to the past...[K] Another method?
        -- NON CONVERTI : bgm2_FadeOut (un seul canal BGM dans PMDO)
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Dusknoir'), Direction.Left, 15)
        pcall(function() SOUND:PlayBGM('Time Gear Remix.ogg', true) end) -- TimeGearRemix
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_018')) -- canon:  That's right...[K] If he needs to send the agent through time...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_019')) -- canon:  [CS:Y]Grovyle[CR]...[K]you should know what method I'm talking about.
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_020')) -- canon:  I-I...[K]should know what method?
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8973') end) -- TODO table SE id 8973
        GROUND:CharSetEmote(CH('HeroFuture'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_021')) -- canon:  N-no...[K] It can't be!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_022')) -- canon:  The Passage of Time!?
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_023')) -- canon:  Yes.[K] The Passage of Time.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_024')) -- canon:  Rather than waiting for Master [CS:N]Dialga[CR] to regenerate...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_025')) -- canon:  They will most likely look for [CS:N]Celebi[CR] and use the Passage of Time to send the agent back to the past.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_026')) -- canon:  I'm sure of it.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_027')) -- canon:  Master [CS:N]Dialga[CR]...[K]probably left here to catch [CS:N]Celebi[CR].
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharSetEmote(CH('HeroFuture'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_028')) -- canon:  [CS:N]D-Dialga[CR]...left to catch [CS:N]Celebi[CR]!?
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.Down, 15)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_029')) -- canon:  B-but...[K] I don't think it will be that easy to catch [CS:N]Celebi[CR]...
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_030')) -- canon:  If it were just the [CS:N]Sableye[CR], you'd be right...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_031')) -- canon:  However, it is a different story if Master [CS:N]Dialga[CR] himself went to catch her.
        -- message_KeyWait (le dialogue bloque déjà)
        SOUND:FadeOutBGM(120)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_032')) -- canon:  And that new henchman...[K] I'm worried about their ability...
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('HeroFuture'), Direction.Right, 15)
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_033')) -- canon:  [CS:P]Dusk Forest[CR]!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2008_034')) -- canon:  I always met [CS:N]Celebi[CR] in [CS:P]Dusk Forest[CR]!
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('HeroFuture'), CH('HeroFuture').Position.X + 1.5*8, CH('HeroFuture').Position.Y + 0*8, false, 3.0)
        GAME:WaitFrames(8)
        GROUND:MoveToPosition(CH('Dusknoir'), CH('Dusknoir').Position.X + 1.5*8, CH('Dusknoir').Position.Y + 0*8, false, 3.0)
        GAME:WaitFrames(30)
        GAME:FadeOut(false, 30)
        GAME:WaitFrames(30)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[n08a2008] scène interrompue : '..tostring(err)) end
end

return n08a2008
