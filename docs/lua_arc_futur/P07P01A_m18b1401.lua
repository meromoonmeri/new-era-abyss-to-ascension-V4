--[[
    P07P01A_m18b1401.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P07P01A/m18b1401.ssb
    Généré par tools/ssb_to_lua.py — IR canonique + couche d'adaptation New Era.
    Les dialogues joués sont des clés STRINGS (FUT_*), le texte canonique Sky
    est conservé en commentaire. Les tables anim/SE/effets manquantes sont
    marquées TODO (jamais inventées).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

local m18b1401 = {}

function m18b1401.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- PARTIEL : back_SetBanner2 [367, 0, 256, 152, 15, 0] (bannière)
        GAME:FadeIn(45)
        GAME:WaitFrames(160)
        GAME:FadeOut(false, 45)
        GAME:WaitFrames(15)
        -- PARTIEL : back2_SetMode [4]
        -- back2_SetGround(V09P04A) : couche décor (overlay scène, adaptation)
        -- back_SetGround(P07P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- camera2_SetPositionMark [0, 2, 21, 21] : PARTIEL
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        -- screen2_FadeIn [0, 30] : couche décor (overlay scène, adaptation)
        GAME:FadeIn(30)
        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        GAME:WaitFrames(80)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 180, 316, false, 2.0)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 180, 380, false, 2.0)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownLeft, 15)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Left, 15)
        GAME:WaitFrames(45)
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownLeft, 15)
        GAME:WaitFrames(30)
        GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 1*8, CH('Grovyle').Position.Y + 24*8, false, 2.0)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_001')) -- canon:  Good.[K] This will do.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_002')) -- canon:  Those [CS:N]Sableye[CR] won't be able to spot us easily here.
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_003')) -- canon:  Tell us, [CS:N]Grovyle[CR].
        -- case 3: ' Tell us, [CS:N]Grovyle[CR].'
        -- case 4: ' Tell us, [CS:N]Grovyle[CR].'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_004')) -- canon:  In the future...[K] Why did the planet become paralyzed?
        -- case 6: ' In the future...[K] Why did the\nplanet become paralyzed?'
        -- case 7: " In the future...[K] Why did the\nplanet's paralysis take place?"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_005')) -- canon:  The cause of the planet's paralysis...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_006')) -- canon:  That dates back to your time. In the world of the past.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_007')) -- canon:  The planet's paralysis started with the collapse of [CS:P]Temporal Tower[CR], which was governed by [CS:N]Dialga[CR].
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_008')) -- canon:  [CS:N]D-Dialga[CR]?[K] Who is that?
        -- case 12: ' [CS:N]D-Dialga[CR]?[K] Who is that?'
        -- case 13: ' [CS:N]D-Dialga[CR]?[K] Who is that?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_009')) -- canon:  He is the legendary Pokémon that controls time.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_010')) -- canon:  [CS:N]Dialga[CR] ensured the proper flow of time from [CS:P]Temporal Tower[CR].
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_011')) -- canon:  But when [CS:P]Temporal Tower[CR] collapsed...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_012')) -- canon:  Time gradually got out of control...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_013')) -- canon:  And eventually, the planet fell into paralysis.
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_014')) -- canon:  What...[K]what happened to [CS:N]Dialga[CR]?
        -- case 20: ' What...[K]what happened to [CS:N]Dialga[CR]?'
        -- case 21: ' What...[K]what happened to [CS:N]Dialga[CR]?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_015')) -- canon:  When time went out of whack, [CS:N]Dialga[CR] also lost control.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_016')) -- canon:  Now, here in your future, the planet has become fully paralyzed.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_017')) -- canon:  And thus [CS:N]Dialga[CR] has lost almost all his reason...[K]and is governed by darkness.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_018')) -- canon:  [CS:N]Dialga[CR] is now beyond recognition.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_019')) -- canon:  He has become an entirely different entity...[K] Yes...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_020')) -- canon:  He has been transformed into Primal [CS:N]Dialga[CR], a primordial presence.
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_021')) -- canon:  OK... Urf...
        -- case 29: ' OK... Urf...'
        -- case 30: ' OK... Urf...'
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_022')) -- canon:  Primal [CS:N]Dialga[CR] feels no emotion.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_023')) -- canon:  He seeks only self-preservation, so he prevents history from changing.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_024')) -- canon:  That's why [CS:N]Dialga[CR] wants me gone.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_025')) -- canon:  Because I tried to change history.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_026')) -- canon:  Because I tried to stop the planet's paralysis.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_027')) -- canon:  Because I traveled back in time to your world from this place...your future.
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_028')) -- canon:  What?!
        -- case 38: ' What?!'
        -- case 39: ' What?!'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_029')) -- canon:  [CS:N]Grovyle[CR], you're saying that you came back to our world...
        -- case 41: " [CS:N]Grovyle[CR], you're saying that you\ncame back to our world..."
        -- case 42: " [CS:N]Grovyle[CR], you're saying that you\ncame back to our world..."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_030')) -- canon:  So you could prevent the planet's paralysis?!
        -- case 44: " So you could prevent the planet's\nparalysis?!"
        -- case 45: " So you could prevent the planet's\nparalysis?!"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_031')) -- canon:  But that's...[K]completely the opposite of what we were told!
        -- case 47: " But that's...[K]completely the\nopposite of what we were told!"
        -- case 48: " But that's...[K]completely the\nopposite of what we were told!"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_032')) -- canon:  [CS:N]Grovyle[CR], you came back to our world to paralyze the planet...didn't you?!
        -- case 50: " [CS:N]Grovyle[CR], you came back to our\nworld to paralyze the planet...didn't you?!"
        -- case 51: " [CS:N]Grovyle[CR], you came back to our\nworld to paralyze the planet...didn't you?!"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_033')) -- canon:  And, [CS:N]Grovyle[CR]...[K]weren't you the one stealing the Time Gears?!
        -- case 53: " And, [CS:N]Grovyle[CR]...[K]weren't you the\none stealing the Time Gears?!"
        -- case 54: " And, [CS:N]Grovyle[CR]...[K]weren't you the\none stealing the Time Gears?!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_034')) -- canon:  You've got to be joking!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_035')) -- canon:  I was collecting Time Gears...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_036')) -- canon:  Because they were needed for preventing the planet's paralysis.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_037')) -- canon:  I needed to take them to [CS:P]Temporal Tower[CR] and put them in place.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_038')) -- canon:  That would have reversed the collapse of [CS:P]Temporal Tower[CR], which was fully under way in your time.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_039')) -- canon:  While it is true that removing a Time Gear from a specific place causes time to stop in that area...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_040')) -- canon:  That's only temporary. After the Time Gears are put into [CS:P]Temporal Tower[CR]...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_041')) -- canon:  Time would have been fully restored to normal everywhere.
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_042')) -- canon:  Urf...[K] But then, what about all the things [CS:N]Dusknoir[CR] said about you?
        -- case 64: ' Urf...[K] But then, what about all\nthe things [CS:N]Dusknoir[CR] said about you?'
        -- case 65: ' Urf...[K] But then, what about all\nthe things [CS:N]Dusknoir[CR] said about you?'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_043')) -- canon:  Like how he said you were a wanted outlaw in the future.
        -- case 67: ' Like how he said you were a\nwanted outlaw in the future.'
        -- case 68: ' Like how he said you were a\nwanted outlaw in the future.'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_044')) -- canon:  And how you escaped from the future...
        -- case 70: ' And how you escaped from\nthe future...'
        -- case 71: ' And how you escaped from\nthe future...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_045')) -- canon:  then fled to our world in the past.
        -- case 73: ' then fled to our world in\nthe past.'
        -- case 74: ' then fled to our world in\nthe past.'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_046')) -- canon:  So you're saying all that was just a bunch of lies?
        -- case 76: " So you're saying all that was\njust a bunch of lies?"
        -- case 77: " So you're claiming all that was\njust a bunch of lies?"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_047')) -- canon:  What else could it be?
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_048')) -- canon:  Because [CS:N]Dusknoir[CR] really is...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_049')) -- canon:  an agent sent from this future by Primal [CS:N]Dialga[CR]...[K]to get rid of me.
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_050')) -- canon:  What?![K] [CS:N]Dusknoir[CR] was...[K]an agent sent to get rid of you?!
        -- case 82: ' What?![K] [CS:N]Dusknoir[CR] was...[K]an agent\nsent to get rid of you?!'
        -- case 83: ' What?![K] [CS:N]Dusknoir[CR] was...[K]an agent\nsent to get rid of you?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_051')) -- canon:  That's right.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_052')) -- canon:  I have said that Primal [CS:N]Dialga[CR]...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_053')) -- canon:  will try to thwart any attempt to alter the course of history.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_054')) -- canon:  That's why, when he learned that I traveled through time...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_055')) -- canon:  He sent [CS:N]Dusknoir[CR] after me.
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_056')) -- canon:  The great...[K][CS:N]Dusknoir[CR]...?[K] It can't be!
        -- case 90: " The great...[K][CS:N]Dusknoir[CR]...?[K]\nIt can't be!"
        -- case 91: " The great...[K][CS:N]Dusknoir[CR]...?[K]\nIt can't be!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_057')) -- canon:  It's hard for you to believe, I know...
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8971') end) -- TODO table SE id 8971
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_058')) -- canon:  I can't believe it at all!
        -- case 94: " I can't believe it at all!"
        -- case 95: " I can't believe it at all!"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_059')) -- canon:  You're saying all this about the great [CS:N]Dusknoir[CR]?!
        -- case 97: " You're saying all this about\nthe great [CS:N]Dusknoir[CR]?!"
        -- case 98: " You're saying all this about\nthe great [CS:N]Dusknoir[CR]?!"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_060')) -- canon:  I don't understand why [CS:N]Dusknoir[CR] is acting this way here, but...
        -- case 100: " I don't understand why [CS:N]Dusknoir[CR]\nis acting this way here, but..."
        -- case 101: " I don't understand why [CS:N]Dusknoir[CR]\nis acting this way here, but..."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_061')) -- canon:  But I admired...[K][CS:N]Dusknoir[CR]...
        -- case 103: ' But I admired...[K][CS:N]Dusknoir[CR]...'
        -- case 104: ' But I respected...[K][CS:N]Dusknoir[CR]...'
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('TearyEyed')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_062')) -- canon:  I can't...[K] I can't believe you...
        -- case 106: " I can't...[K] I can't believe you..."
        -- case 107: " I can't...[K] I can't believe you..."
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBGM('Time Gear.ogg', true) end) -- TimeGear
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_063')) -- canon: (It is hard to accept, but...)
        -- case 109: '(It is hard to accept, but...)'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_064')) -- canon: (Looking back over what we've been through in this future world...)
        -- case 111: "(Looking back over what we've been through in\nthis future world...)"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_065')) -- canon: (What [CS:N]Grovyle[CR] said is reasonable.[K] It makes perfect sense.)
        -- case 113: '(What [CS:N]Grovyle[CR] said is reasonable.[K] It makes\nperfect sense.)'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_066')) -- canon: (And [partner] knows it.)
        -- case 115: '(And [partner] knows it.)'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_067')) -- canon: ([partner] knows deep down that what [CS:N]Grovyle[CR] says is true.)
        -- case 117: '([partner] knows deep down that what\n[CS:N]Grovyle[CR] says is true.)'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_068')) -- canon: (But knowing that makes it that much harder to accept...)
        -- case 119: '(But knowing that makes it that much harder\nto accept...)'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_069')) -- canon: (But...)
        -- case 121: '(But...)'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Teammate1'), 120, 396, false, 2.0)
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8967') end) -- TODO table SE id 8967
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownLeft, 15)
            end,
            function()
                GROUND:CharSetEmote(CH('Grovyle'), 'exclaim', 3)
                GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.DownLeft, 15)
            end,
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_070')) -- canon:  Hey! Where are you going?
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_071')) -- canon:  I'm going to see [CS:N]Dusknoir[CR].
        -- case 124: " I'm going to see [CS:N]Dusknoir[CR]."
        -- case 125: " I'm going to see [CS:N]Dusknoir[CR]."
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8968') end) -- TODO table SE id 8968
        -- (parallèle) NPC_JUPUTORU, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('Grovyle'), 'shock', 3)
                -- WaitEffect (les appels GROUND sont bloquants)
            end,
        })
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_072')) -- canon:  What?!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_073')) -- canon:  I want to see [CS:N]Dusknoir[CR].[K] I'm going to find out if what you said is true or not.
        -- case 128: " I want to see [CS:N]Dusknoir[CR].[K]\nI'm going to find out if what you said is true\nor not."
        -- case 129: " I want to see [CS:N]Dusknoir[CR].[K]\nI'm going to find out if what you said is true\nor not."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_074')) -- canon:  What's the point of that?!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_075')) -- canon:  You'll only be making it easy for them to get rid of you!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_076')) -- canon:  You don't stand a chance against them!
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_077')) -- canon:  Then...[K]what am I supposed to do?!
        -- case 134: ' Then...[K]what am I supposed\nto do?!'
        -- case 135: ' Then...[K]what am I supposed\nto do?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_078')) -- canon:  What are you supposed to do?!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_079')) -- canon:  Didn't you wonder this earlier?!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_080')) -- canon:  And you decided...that you would decide for yourself!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_081')) -- canon:  You insisted that, because you don't know what to believe...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_082')) -- canon:  you wouldn't accept words for their face value...[K]and you'd think for yourself!
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_083')) -- canon:  Urk...
        -- case 142: ' Urk...'
        -- case 143: ' Urk...'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_084')) -- canon:  It's times like this, when things are tough, that you have to be strong.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_085')) -- canon:  Think for yourself, then act as you deem right.
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), 208, 396, false, 1.594)
        GAME:WaitFrames(20)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
        GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 0.7969*8, CH('Teammate1').Position.Y + 28*8, false, 1.594)
        GAME:WaitFrames(30)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Down, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_086')) -- canon:  [CS:N]Grovyle[CR]...[K] What are you going to do now?
        -- case 147: ' [CS:N]Grovyle[CR]...[K] What are you going\nto do now?'
        -- case 148: ' [CS:N]Grovyle[CR]...[K] What are you going\nto do now?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_087')) -- canon:  I'm going back to the past again to stop the planet's paralysis.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_088')) -- canon:  To do that...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_089')) -- canon:  I need to find [CS:N]Celebi[CR].
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_090')) -- canon:  [CS:N]Cel[CR]...[K][CS:N]Celebi[CR]?
        -- case 153: ' [CS:N]Cel[CR]...[K][CS:N]Celebi[CR]?'
        -- case 154: ' [CS:N]Cel[CR]...[K][CS:N]Celebi[CR]?'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Grovyle'), Direction.Left, 15)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_091')) -- canon:  That's right.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_092')) -- canon:  You can come with me or not. It's your choice.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_093')) -- canon:  You two decide on your own course of action.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_094')) -- canon:  I'm off.
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Grovyle'), CH('Grovyle').Position.X + 1*8, CH('Grovyle').Position.Y + 160*8, false, 2.0)
        GAME:WaitFrames(20)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownRight, 15)
        GAME:WaitFrames(60)
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO table SE id 8972
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_095')) -- canon:  Urk...
        -- case 160: ' Urk...'
        -- case 161: ' Urk...'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_096')) -- canon: (...............)
        -- case 163: '(...............)'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_097')) -- canon: (I don't know what I should believe either.)
        -- case 165: "(I don't know what I should believe either.)"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_098')) -- canon: (But...[K]there is one thing I can say with certainty.)
        -- case 167: '(But...[K]there is one thing I can say with\ncertainty.)'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_099')) -- canon: (In this future world of darkness...)
        -- case 169: '(In this future world of darkness...)'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_100')) -- canon: (The planet is paralyzed.)
        -- case 171: '(The planet is paralyzed.)'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_101')) -- canon: (And the paralysis of the planet...[K] It happened back in our world.)
        -- case 173: '(And the paralysis of the planet...[K] It happened\nback in our world.)'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_102')) -- canon: (That's why, to stop that from happening...)
        -- case 175: "(That's why, to stop that from happening...)"
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_103')) -- canon: (We have to get back to the past!)
        -- case 177: '(We have to get back to the past!)'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_104')) -- canon: (We have to get back![K] Back to our world!)
        -- case 179: '(We have to get back![K] Back to our world!)'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('PLAYER'), 208, 396, false, 2.0)
        GAME:WaitFrames(45)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Right, 15)
            end,
        })
        GAME:WaitFrames(80)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Left, 15)
        GAME:WaitFrames(45)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_105')) -- canon:  [hero]...
        -- case 181: ' [hero]...'
        -- case 182: ' [hero]...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_106')) -- canon:  Yup...[K] I know...
        -- case 184: ' Yup...[K] I know...'
        -- case 185: ' Yes...[K] I know...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_107')) -- canon:  What [CS:N]Grovyle[CR] said...[K] [CS:N]Grovyle[CR] is right...
        -- case 187: ' What [CS:N]Grovyle[CR] said...[K] [CS:N]Grovyle[CR] is\nright...'
        -- case 188: ' What [CS:N]Grovyle[CR] said...[K] [CS:N]Grovyle[CR] is\nright...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_108')) -- canon:  Things are very tough now...[K] That's why we have to be strong.
        -- case 190: " Things are very tough now...[K]\nThat's why we have to be strong."
        -- case 191: " Things are very tough now...[K]\nThat's why we have to be strong."
        UI:ResetSpeaker()
        GAME:WaitFrames(45)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_109')) -- canon:  I'm all right now...[K] Let's go.
        -- case 193: " I'm all right now...[K] Let's go."
        -- case 194: " I'm all right now...[K] Let's go."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_110')) -- canon:  Let's catch up to [CS:N]Grovyle[CR].
        -- case 196: " Let's catch up to [CS:N]Grovyle[CR]."
        -- case 197: " Let's catch up to [CS:N]Grovyle[CR]."
        UI:ResetSpeaker()
        -- SetAnimation id 71 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(30)
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 0.7969*8, CH('PLAYER').Position.Y + 24*8, false, 1.594)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_111')) -- canon:  [hero].
        -- case 199: ' [hero].'
        -- case 200: ' [hero].'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_112')) -- canon:  We have to...[K] We have to get back!
        -- case 202: ' We have to...[K] We have to\nget back!'
        -- case 203: ' We have to...[K] We have to\nget back!'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18B1401_113')) -- canon:  Back to our own world!
        -- case 205: ' Back to our own world!'
        -- case 206: ' Back to our own world!'
        UI:ResetSpeaker()
        -- SetAnimation id 71 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation id 71 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(30)
        GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 160*8, false, 2.0)
        GAME:WaitFrames(45)
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 160*8, false, 2.0)
        GAME:WaitFrames(30)
        SOUND:FadeOutBGM(180)
        -- screen2_FadeOut [0, 60] : couche décor (overlay scène, adaptation)
        GAME:FadeOut(false, 60)
        -- PARTIEL : back2_SetMode [0]
        -- WaitBgm : PARTIEL
        GAME:WaitFrames(30)
        SV.Scenario.Main = 20 -- flag_SetScenario(SCENARIO_MAIN, scenario=20, level=0)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m18b1401] scène interrompue : '..tostring(err)) end
end

return m18b1401
