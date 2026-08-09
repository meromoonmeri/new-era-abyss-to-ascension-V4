--[[
    P08P01A_m19a0601.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P08P01A/m19a0601.ssb
    Généré par tools/ssb_to_lua.py — IR canonique + couche d'adaptation New Era.
    Les dialogues joués sont des clés STRINGS (FUT_*), le texte canonique Sky
    est conservé en commentaire. Les tables anim/SE/effets manquantes sont
    marquées TODO (jamais inventées).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

local m19a0601 = {}

function m19a0601.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- PARTIEL : back_SetDungeonBanner [32, 0] (bannière)
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
        -- (parallèle) ATTENDANT1, NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Grovyle'), 276, 248, false, 2.0)
            end,
            function()
                GROUND:MoveToPosition(CH('Teammate1'), 248, 268, false, 2.0)
            end,
            function()
                GROUND:MoveToPosition(CH('PLAYER'), 304, 268, false, 2.0)
            end,
        })
        GAME:WaitFrames(15)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(15)
        GROUND:CharTurnToChar(CH('Teammate1'), CH('Grovyle'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Grovyle'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_001')) -- canon:  Is this...[K] Is this where [CS:N]Celebi[CR]'s supposed to be?
        -- case 0: " Is this...[K] Is this where [CS:N]Celebi[CR]'s\nsupposed to be?"
        -- case 1: ' Is this...[K] Is this where [CS:N]Celebi[CR] is\nsupposed to be?'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownLeft, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_002')) -- canon:  That's right. It was around here that I met her the last time.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_003')) -- canon:  But if Primal [CS:N]Dialga[CR] knows of this place...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_004')) -- canon:  [CS:N]Celebi[CR] will have fled from here.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_005')) -- canon:  If this place isn't known to our pursuers, however...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_006')) -- canon:  Then [CS:N]Celebi[CR] should still be here.
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Up, 15)
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_007')) -- canon:  Hello? [CS:N]Celebi[CR]?
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_008')) -- canon:  It's me! [CS:N]Grovyle[CR]!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_009')) -- canon:  Reveal yourself...if you're here!
        UI:ResetSpeaker()
        GAME:WaitFrames(45)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8963') end) -- TODO table SE id 8963
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_010')) -- canon:  She's...[K]not coming out...
        -- case 11: " She's...[K]not coming out..."
        -- case 12: " She's...[K]not coming out..."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_011')) -- canon:  Did Primal [CS:N]Dialga[CR] chase her off?
        -- case 14: ' Did Primal [CS:N]Dialga[CR] chase her off?'
        -- case 15: ' Did she get frightened off by\nPrimal [CS:N]Dialga[CR]?'
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8973') end) -- TODO table SE id 8973
        GROUND:CharSetEmote(CH('Teammate1'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownLeft, 15)
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_012')) -- canon:  What if...
        -- case 17: ' What if...'
        -- case 18: ' What if...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_013')) -- canon:  What if she's...[K]been captured by Primal [CS:N]Dialga[CR]?
        -- case 20: " What if she's...[K]been captured by\nPrimal [CS:N]Dialga[CR]?"
        -- case 21: " What if she's...[K]been captured by\nPrimal [CS:N]Dialga[CR]?"
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(10)
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_014')) -- canon:  Captured?
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
            end,
        })
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_015')) -- canon:  Whoa! Who said that?!
        -- case 24: ' Whoa! Who said that?!'
        -- case 25: " Wah! Where'd that voice\ncome from?!"
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Up, 15)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8963') end) -- TODO table SE id 8963
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(12)
        -- ExecuteCommon(LOOK_AROUND_LEFT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(45)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
            end,
            function()
                GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
            end,
        })
        GAME:WaitFrames(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8962') end) -- TODO table SE id 8962
        GROUND:CharSetEmote(CH('Teammate1'), 'question', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_016')) -- canon:  But now...[K]I don't hear anything.
        -- case 27: " But now...[K]I don't hear anything."
        -- case 28: " But now...[K]I don't hear anything."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_017')) -- canon:  That voice...[K] Did I imagine it?
        -- case 30: ' That voice...[K] Did I imagine it?'
        -- case 31: ' That voice...[K] Was I just\nhearing things?'
        UI:ResetSpeaker()
        UI:ResetSpeaker()
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_018')) -- canon:  Tee-hee! You didn't imagine it!
        UI:SetCenter(false)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO table SE id 8974
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_019')) -- canon:  Me? Captured?
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_020')) -- canon:  How insulting![K] Captured?!
        UI:SetCenter(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_021')) -- canon:  Impossible, that's for sure! Tee-hee!
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpLeft, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
            end,
        })
        -- performer 3
        -- SetEffect [645, 3] : performer 3 non mappé (PARTIEL)
        -- performer 3
        -- WaitEffect [] : performer 3 non mappé (PARTIEL)
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7433') end) -- TODO table SE id 7433
        GAME:WaitFrames(134)
        -- supervision_cting layer [1] (structurel)
        GAME:WaitFrames(60)
        pcall(function() SOUND:PlayBGM('Welcome to the World of Pokémon!.ogg', true) end) -- WelcomeToTheWorldOfPokemon
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_022')) -- canon:  It's been too long, my dear [CS:N]Grovyle[CR]!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_023')) -- canon:  Yes. It has been a while, [CS:N]Celebi[CR].
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO table SE id 8974
        GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_024')) -- canon:  Huh?![K] This tiny thing is [CS:N]Celebi[CR]?
        -- case 39: ' Huh?![K] This tiny thing is [CS:N]Celebi[CR]?'
        -- case 40: ' What?![K] This tiny thing is [CS:N]Celebi[CR]?'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.DownLeft, 15)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8971') end) -- TODO table SE id 8971
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharSetEmote(CH('Celebi'), 'angry', 3)
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_025')) -- canon:  Now that is downright rude!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_026')) -- canon:  How inappropriate! To poke fun at my petite proportions...
        UI:ResetSpeaker()
        -- SetEffect 0 (aucun) : pas d'effet
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_027')) -- canon:  Uh...[K]I'm sorry.
        -- case 44: " Uh...[K]I'm sorry."
        -- case 45: " Uh...[K]I'm sorry."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_028')) -- canon:  I heard you have the ability to cross time...
        -- case 47: ' I heard you have the ability to\ncross time...'
        -- case 48: ' I heard you have the ability to\ncross time...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_029')) -- canon:  So I was expecting to see some kind of an awesome-looking Pokémon...
        -- case 50: ' So I was expecting to see some\nkind of an awesome-looking Pokémon...'
        -- case 51: ' So I expected you to be some\nawe-inspiring Pokémon...'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_030')) -- canon:  How uncouth![K] Never judge someone by appearance!
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Happy')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_031')) -- canon:  But...[K]I forgive you.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_032')) -- canon:  After all...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_033')) -- canon:  You must find me cuter and more special than you imagined![K] Tee-hee!
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8961') end) -- TODO table SE id 8961
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'sweatdrop', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_034')) -- canon:  Uh, yeah...
        -- case 57: ' Uh, yeah...'
        -- case 58: ' Um, yes.'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 0.5*8, CH('Grovyle').Position.Y + 0*8, false, 1.0)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_035')) -- canon:  [CS:N]Celebi[CR].[K] I need your help again.
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Celebi'), CH('Grovyle'))
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_036')) -- canon:  I know.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_037')) -- canon:  Seeing you back here, my dear [CS:N]Grovyle[CR], tells me everything I need to know.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_038')) -- canon:  You're back because you failed in your mission in the past, yes?
        UI:ResetSpeaker()
        GROUND:CharSetEmote(CH('Grovyle'), 'sweatdrop', 3)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_039')) -- canon:  Urk...[K] Yes, it's true.
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_040')) -- canon:  I hope you manage this time.[K] I've quite had enough of this.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_041')) -- canon:  Living in this dark and dreary world is so depressing.
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_042')) -- canon:  Sorry, no time to chat...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_043')) -- canon:  The [CS:N]Sableye[CR] are tracking us.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_044')) -- canon:  If we don't leave soon, we'll have brought trouble to you.
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_045')) -- canon:  Tee-hee![K] It's quite fine. There is no need to be worried.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_046')) -- canon:  Let those [CS:N]Sableye[CR] come. They're of no concern to me.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_047')) -- canon:  Besides, if you would be so kind as to prevent the planet's paralysis...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_048')) -- canon:  We'll finally be spared the agony of this world of darkness.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_049')) -- canon:  My dear [CS:N]Grovyle[CR], I will devote my whole life to achieve that end!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_050')) -- canon:  All right...[K] Where is the Passage of Time?
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_051')) -- canon:  It's ready.[K] It is nearby.
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Up, 15)
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_052')) -- canon:  The Passage of Time is on a plateau above this forest.
        UI:SetCenter(false)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_053')) -- canon:  That's good.[K] Can you guide us?
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Celebi'), CH('Grovyle'))
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Happy')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_054')) -- canon:  Yes!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_055')) -- canon:  Are all three of you taking the Passage of Time?
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_056')) -- canon:  Yeah. That's right.
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.DownRight, 15)
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8964') end) -- TODO table SE id 8964
        GROUND:CharSetEmote(CH('Celebi'), 'exclaim', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_057')) -- canon:  Oh?! What's...[K]this? Your friend!
        SOUND:FadeOutBGM(180)
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('Grovyle'), CH('PLAYER'))
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_058')) -- canon: (What...?[K] What...?)
        -- case 83: '(What...?[K] What...?)'
        UI:ResetSpeaker()
        GAME:WaitFrames(60)
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_059')) -- canon:  ........................
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_060')) -- canon:  No...[K] That can't be...
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Celebi'))
        GAME:WaitFrames(45)
        GROUND:CharTurnToChar(CH('Grovyle'), CH('PLAYER'))
        GAME:WaitFrames(45)
        GROUND:CharTurnToChar(CH('Grovyle'), CH('Celebi'))
        GAME:WaitFrames(45)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_061')) -- canon:  Is something the matter, [CS:N]Celebi[CR]?
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Celebi'), CH('Grovyle'))
        GROUND:CharTurnToChar(CH('Teammate1'), CH('Celebi'))
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_062')) -- canon:  No...[K] It's nothing.
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.DownLeft, 15)
        GAME:WaitFrames(60)
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.DownRight, 15)
        GAME:WaitFrames(60)
        GROUND:CharAnimateTurnTo(CH('Celebi'), Direction.Down, 15)
        GAME:WaitFrames(30)
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19A0601_063')) -- canon:  Well then.[K] Shall we? Off to the Passage of Time.
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Celebi'), CH('Celebi').Position.X + 1*8, CH('Celebi').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 1*8, CH('Grovyle').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(15)
        GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(5)
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 0*8, false, 2.0)
        GAME:WaitFrames(30)
        GAME:FadeOut(false, 60)
        GAME:WaitFrames(80)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m19a0601] scène interrompue : '..tostring(err)) end
end

return m19a0601
