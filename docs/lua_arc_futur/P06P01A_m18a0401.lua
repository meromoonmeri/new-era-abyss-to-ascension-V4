--[[
    P06P01A_m18a0401.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P06P01A/m18a0401.ssb
    Généré par tools/ssb_to_lua.py — IR canonique + couche d'adaptation New Era.
    Les dialogues joués sont des clés STRINGS (FUT_*), le texte canonique Sky
    est conservé en commentaire. Les tables anim/SE/effets manquantes sont
    marquées TODO (jamais inventées).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

local m18a0401 = {}

function m18a0401.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        SV.Scenario.Main = 19 -- flag_SetScenario(SCENARIO_MAIN, scenario=19, level=2)
        -- back_SetGround(P06P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        GROUND:MoveToPosition(CH('Teammate1'), 152, 212, false, 2.0)
        GAME:WaitFrames(20)
        GROUND:MoveToPosition(CH('PLAYER'), 128, 236, false, 2.0)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_001')) -- canon:  Huff-huff...[K] We've climbed a long ways up...
        -- case 0: " Huff-huff...[K] We've climbed a\nlong ways up..."
        -- case 1: " Huff-huff...[K] We've been climbing\na long time now..."
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 300, 228, false, 2.0)
        GROUND:MoveToPosition(CH('Teammate1'), 272, 212, false, 2.0)
        GAME:WaitFrames(10)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('PLAYER'), 256, 236, false, 2.0)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.UpRight, 15)
            end,
        })
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO table SE id 8974
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpRight, 15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_002')) -- canon:  Whoa![K] Look at that,  [hero]!
        -- case 3: ' Whoa![K] Look at that, \n[hero]!'
        -- case 4: ' Wow![K] Look at that,\n[hero]!'
        UI:ResetSpeaker()
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 300, 176, false, 1.0)
        GROUND:MoveToPosition(CH('Teammate1'), 316, 148, false, 1.594)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('PLAYER'), 276, 172, false, 1.594)
        GAME:WaitFrames(60)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_003')) -- canon:  It was true...[K] The future really is a world of darkness...
        -- case 6: ' It was true...[K] The future really\nis a world of darkness...'
        -- case 7: ' It was true...[K] The future really\nis a world of darkness...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_004')) -- canon:  ...[K]That cluster of lights...
        -- case 9: ' ...[K]That cluster of lights...'
        -- case 10: ' ...[K]That cluster of lights...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_005')) -- canon:  It's beautiful, but...
        -- case 12: " It's beautiful, but..."
        -- case 13: " It's beautiful, but..."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_006')) -- canon:  Those lights...[K] Isn't that...[K] the stockade?
        -- case 15: " Those lights...[K] Isn't that...[K]\nthe stockade?"
        -- case 16: " Those lights...[K] Isn't that...[K]\nthe stockade?"
        UI:ResetSpeaker()
        GAME:WaitFrames(90)
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_007')) -- canon:  Hey, [hero]...
        UI:SetCenter(false)
        -- case 18: ' Hey, [hero]...'
        -- case 19: ' Hey, [hero]...'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GROUND:CharTurnToChar(CH('PLAYER'), CH('Teammate1'))
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_008')) -- canon:  The great [CS:N]Dusknoir[CR] saved us more than once.
        -- case 21: ' The great [CS:N]Dusknoir[CR] saved us\nmore than once.'
        -- case 22: ' The great [CS:N]Dusknoir[CR] saved us\nmore than once.'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_009')) -- canon:  He taught us many things too.
        -- case 24: ' He taught us many things too.'
        -- case 25: ' He taught us many things too.'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_010')) -- canon:  That's why I...[K]I really looked up to [CS:N]Dusknoir[CR].
        -- case 27: " That's why I...[K]I really looked up\nto [CS:N]Dusknoir[CR]."
        -- case 28: " That's why I...[K]I came to really\nrespect [CS:N]Dusknoir[CR]."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_011')) -- canon:  But was [CS:N]Dusknoir[CR]...[K]deceiving us?
        -- case 30: ' But was [CS:N]Dusknoir[CR]...[K]deceiving us?'
        -- case 31: ' But was [CS:N]Dusknoir[CR]...[K]deceiving us?'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_012')) -- canon:  Even after all this...[K]I still can't believe it.
        -- case 33: " Even after all this...[K]I still can't\nbelieve it."
        -- case 34: " Even after all this...[K]I still can't\nbelieve it."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_013')) -- canon:  I don't know what to believe anymore...
        -- case 36: " I don't know what to believe\nanymore..."
        -- case 37: " I don't know what to believe\nanymore..."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_014')) -- canon:  My head feels all messed up...
        -- case 39: ' My head feels all messed up...'
        -- case 40: " I'm feeling all jumbled up..."
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_015')) -- canon: ([partner]...)
        -- case 42: '([partner]...)'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
        GAME:WaitFrames(15)
        GAME:WaitFrames(60)
        pcall(function() SOUND:PlayBGM('Time Gear Remix.ogg', true) end) -- TimeGearRemix
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_016')) -- canon:  What should we...[K] What should we do now?
        -- case 44: ' What should we...[K] What should\nwe do now?'
        -- case 45: ' What should we...[K] What should\nwe do now?'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_017')) -- canon:  When can we stop running?
        -- case 47: ' When can we stop running?'
        -- case 48: ' How far do we have to run?'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_018')) -- canon:  Can we return to our world?
        -- case 50: ' Can we return to our world?'
        -- case 51: ' How do we go back to our\nown world?'
        UI:ResetSpeaker()
        GAME:WaitFrames(60)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_019')) -- canon:  ..................
        -- case 53: ' ..................'
        -- case 54: ' ..................'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_020')) -- canon:  Everyone at the guild...[K] I wonder how they're doing?
        -- case 56: " Everyone at the guild...[K] I wonder\nhow they're doing?"
        -- case 57: " Everyone at the guild...[K] I wonder\nhow they're doing?"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_021')) -- canon:  Are they worried about us being gone?
        -- case 59: ' Are they worried about us\nbeing gone?'
        -- case 60: ' Are they worried about us?'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_022')) -- canon:  [CS:N]Wigglytuff[CR], [CS:N]Chatot[CR], [CS:N]Bidoof[CR], and everyone else...[K] I wonder if they're doing well?
        -- case 62: " [CS:N]Wigglytuff[CR], [CS:N]Chatot[CR], [CS:N]Bidoof[CR], and\neveryone else...[K] I wonder if they're doing well?"
        -- case 63: " [CS:N]Wigglytuff[CR], [CS:N]Chatot[CR], [CS:N]Bidoof[CR], and\neveryone else...[K] I wonder if they're doing well?"
        UI:ResetSpeaker()
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + -1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 1*8, false, 2.0)
        GAME:WaitFrames(2)
        GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + -1*8, false, 2.0)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('TearyEyed')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_023')) -- canon:  I m-m-miss the guild...[K] I want to see everyone!
        -- case 65: ' I m-m-miss the guild...[K] I want\nto see everyone!'
        -- case 66: ' I m-m-miss the guild...[K] I want\nto see everyone!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_024')) -- canon: ([partner]'s feeling pretty down.)
        -- case 68: "([partner]'s feeling pretty down.)"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_025')) -- canon: (It's only natural.)
        -- case 70: "(It's only natural.)"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_026')) -- canon: (What's happened so far...[K] It's all so hard to believe.)
        -- case 72: "(What's happened so far...[K] It's all so hard\nto believe.)"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_027')) -- canon: (I'm...[K]scared too.)
        -- case 74: "(I'm...[K]scared too.)"
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 15)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_028')) -- canon: (But...[K]I can't give up now.)
        -- case 76: "(But...[K]I can't give up now.)"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_029')) -- canon: (If we don't keep going, those [CS:N]Sableye[CR] will catch us.)
        -- case 78: "(If we don't keep going, those [CS:N]Sableye[CR] will\ncatch us.)"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_030')) -- canon: (I've got to do something to cheer up [partner].)
        -- case 80: "(I've got to do something to cheer up\n[partner].)"
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_031')) -- canon: (But words of support will seem like false comfort right now...)
        -- case 82: '(But words of support will seem like false\ncomfort right now...)'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_032')) -- canon: (If there were something I could say...[K] Something that offers a glimmer of hope...)
        -- case 84: '(If there were something I could say...[K]\nSomething that offers a glimmer of hope...)'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_033')) -- canon: (If only there were some hope, we could work toward it...)
        -- case 86: '(If only there were some hope, we could work\ntoward it...)'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_034')) -- canon: (It could be anything.[K] I just need to think of something!)
        -- case 88: '(It could be anything.[K] I just need to think\nof something!)'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('PLAYER'), 276, 148, false, 1.0)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Right, 15)
        GAME:WaitFrames(20)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8964') end) -- TODO table SE id 8964
        -- SetEffect id 172 : NON CONVERTI (table effets REQUISE)
        -- WaitEffect (les appels GROUND sont bloquants)
        GAME:WaitFrames(10)
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_035')) -- canon:  Huh?
        -- case 90: ' Huh?'
        -- case 91: ' Hmm?'
UI:SetSpeaker(CH('Teammate1'))
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_036')) -- canon:  What's up, [hero]?
        -- case 93: " What's up, [hero]?"
        -- case 94: ' What is it, [hero]?'
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO table SE id 8974
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_037')) -- canon:  What?![K] You want to go after [CS:N]Grovyle[CR]?
        -- case 98: ' What?![K] You want to go after\n[CS:N]Grovyle[CR]?'
        -- case 99: ' What?![K] You want to go after\n[CS:N]Grovyle[CR]?'
UI:SetSpeaker(CH('Teammate1'))
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_038')) -- canon:  Wh-why?!
        -- case 101: ' Wh-why?!'
        -- case 102: ' Wh-why?!'
        -- Jump (structurel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO table SE id 8974
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_039')) -- canon:  Huh?![K] Let's return to our world?
        -- case 104: " Huh?![K] Let's return to our world?"
        -- case 105: " What?![K] Let's return to\nour world?"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_040')) -- canon:  How are we supposed to return?
        -- case 107: ' How are we supposed to return?'
        -- case 108: ' How are we supposed to return?'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_041')) -- canon:  Well, sure, it would be great if we could go back to our world...
        -- case 110: ' Well, sure, it would be great if\nwe could go back to our world...'
        -- case 111: ' Well, sure, it would be great if\nwe could go back to our world...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_042')) -- canon:  But...how?
        -- case 113: ' But...how?'
        -- case 114: ' But...how?'
        UI:ResetSpeaker()
        -- ExecuteCommon(EXPLANATION_FUNC_SERIES) : gestuelle parallèle à implémenter
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8962') end) -- TODO table SE id 8962
        GROUND:CharSetEmote(CH('Teammate1'), 'question', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_043')) -- canon:  Huh?[K] We're going to first find [CS:N]Grovyle[CR]?
        -- case 116: " Huh?[K] We're going to first find\n[CS:N]Grovyle[CR]?"
        -- case 117: " What?[K] We're going to first find\n[CS:N]Grovyle[CR]?"
UI:SetSpeaker(CH('Teammate1'))
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_044')) -- canon:  So we find [CS:N]Grovyle[CR]...[K] Then what?
        -- case 119: ' So we find [CS:N]Grovyle[CR]...[K]\nThen what?'
        -- case 120: ' So if we do find [CS:N]Grovyle[CR]...[K]\nThen what?'
        -- Jump (structurel)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_045')) -- canon:  Ask him something?
        -- case 124: ' Ask him something?'
        -- case 125: ' Ask him something?'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_046')) -- canon:  Oh...[K]right...
        -- case 127: ' Oh...[K]right...'
        -- case 128: ' Oh...[K]I see...'
        -- Jump (structurel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_047')) -- canon:  You wanted to know something?
        -- case 130: ' You wanted to know something?'
        -- case 131: ' You wanted to know something?'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_048')) -- canon:  Oh...[K]right...
        -- case 133: ' Oh...[K]right...'
        -- case 134: ' Oh...[K]I see...'
        -- Jump (structurel)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_049')) -- canon:  [CS:N]Grovyle[CR] went to our world from here the first time.
        -- case 136: ' [CS:N]Grovyle[CR] went to our world from\nhere the first time.'
        -- case 137: ' [CS:N]Grovyle[CR] went to our world from\nhere the first time.'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_050')) -- canon:  So [CS:N]Grovyle[CR] should know how to go to our world.
        -- case 139: ' So [CS:N]Grovyle[CR] should know how\nto go to our world.'
        -- case 140: ' So [CS:N]Grovyle[CR] should know how\nto travel to our world.'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_051')) -- canon:  But...[K]isn't [CS:N]Grovyle[CR] a bad Pokémon?
        -- case 142: " But...[K]isn't [CS:N]Grovyle[CR] a bad\nPokémon?"
        -- case 143: " But...[K]isn't [CS:N]Grovyle[CR] a bad\nPokémon?"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_052')) -- canon:  Didn't he...[K]come to our world to steal the Time Gears?
        -- case 145: " Didn't he...[K]come to our world to\nsteal the Time Gears?"
        -- case 146: " Didn't he...[K]come to our world to\nsteal the Time Gears?"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_053')) -- canon:  How could I trust anything that he'd say?
        -- case 148: " How could I trust anything that\nhe'd say?"
        -- case 149: ' How could I trust anything he\nwould say?'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_054')) -- canon:  What about you, [hero]?
        -- case 151: ' What about you, [hero]?'
        -- case 152: ' What about you, [hero]?'
UI:SetSpeaker(CH('Teammate1'))
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_055')) -- canon:  Do you trust [CS:N]Grovyle[CR], [hero]?
        -- case 154: ' Do you trust [CS:N]Grovyle[CR],\n[hero]?'
        -- case 155: ' Do you trust [CS:N]Grovyle[CR],\n[hero]?'
        -- Jump (structurel)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        -- message_SwitchMenu/CaseMenu : menu de choix (adaptation)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_056')) -- canon:  Well...[K]I can't trust him!
        -- case 159: " Well...[K]I can't trust him!"
        -- case 160: " Well...[K]I can't trust him!"
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8971') end) -- TODO table SE id 8971
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_057')) -- canon:  A Pokémon like that? Never!
        UI:SetCenter(false)
        -- case 162: ' A Pokémon like that? Never!'
        -- case 163: ' A Pokémon like that? Never!'
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_058')) -- canon:  There's no way that I can trust him!
        UI:SetCenter(false)
        -- case 165: " There's no way that I can\ntrust him!"
        -- case 166: " There's no way that I can\ntrust him!"
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_059')) -- canon:  There's just no way! But...
        UI:SetCenter(false)
        -- case 168: " There's just no way! But..."
        -- case 169: " There's just no way! But..."
        UI:ResetSpeaker()
        GAME:WaitFrames(45)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_060')) -- canon:  But...[K]I understand, [hero].
        -- case 171: ' But...[K]I understand, [hero].'
        -- case 172: ' But...[K]I understand, [hero].'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_061')) -- canon:  I don't know why, but [CS:N]Dusknoir[CR] wants to get rid of us.
        -- case 174: " I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us."
        -- case 175: " I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_062')) -- canon:  That means the only other Pokémon we know here in the future...
        -- case 177: ' That means the only other\nPokémon we know here in the future...'
        -- case 178: ' That means the only other\nPokémon we know here in the future...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_063')) -- canon:  That leaves only [CS:N]Grovyle[CR]...
        -- case 180: ' That leaves only [CS:N]Grovyle[CR]...'
        -- case 181: ' That leaves only [CS:N]Grovyle[CR]...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_064')) -- canon:  We don't have any choice.[K] We must rely on [CS:N]Grovyle[CR].
        -- case 183: " We don't have any choice.[K]\nWe must rely on [CS:N]Grovyle[CR]."
        -- case 184: ' We have no choice.[K] We must pin\nour hopes on [CS:N]Grovyle[CR].'
        UI:ResetSpeaker()
        -- Jump (structurel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_065')) -- canon:  And you don't know either, do you, [hero]?
        -- case 186: " And you don't know either,\ndo you, [hero]?"
        -- case 187: " And you don't know either,\ndo you, [hero]?"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_066')) -- canon:  But you still want to catch up to [CS:N]Grovyle[CR] and talk to him?
        -- case 189: ' But you still want to catch up to\n[CS:N]Grovyle[CR] and talk to him?'
        -- case 190: ' But you still insist on catching\nup to [CS:N]Grovyle[CR] so you can talk to him?'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_067')) -- canon:  And then trust what he says?
        -- case 192: ' And then trust what he says?'
        -- case 193: ' And then trust what he says?'
        UI:ResetSpeaker()
        -- SetAnimation id 71 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(15)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Determined')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_068')) -- canon:  Well...[K]I hate this idea!
        -- case 195: ' Well...[K]I hate this idea!'
        -- case 196: ' Well...[K]I hate this idea!'
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8971') end) -- TODO table SE id 8971
        -- ExecuteCommon(JUMP_ANGRY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_069')) -- canon:  Trust a Pokémon like that?[K] Never!
        UI:SetCenter(false)
        -- case 198: ' Trust a Pokémon like that?[K]\nNever!'
        -- case 199: ' Trust a Pokémon like that?[K]\nNever!'
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_070')) -- canon:  That bad Pokémon![K] Trust that...
        UI:SetCenter(false)
        -- case 201: ' That bad Pokémon![K] Trust that...'
        -- case 202: ' That bad Pokémon![K] Trust that...'
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_071')) -- canon:  I don't want to...[K] But...
        -- case 204: " I don't want to...[K] But..."
        -- case 205: " I don't want to...[K] But..."
        UI:ResetSpeaker()
        GAME:WaitFrames(45)
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_072')) -- canon:  But...[K]maybe we don't have any other choice...
        UI:SetCenter(false)
        -- case 207: " But...[K]maybe we don't have any\nother choice..."
        -- case 208: " But...[K]maybe we don't have any\nother choice..."
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_073')) -- canon:  I don't know why, but [CS:N]Dusknoir[CR] wants to get rid of us.
        UI:SetCenter(false)
        -- case 210: " I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us."
        -- case 211: " I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us."
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_074')) -- canon:  That means the only other Pokémon we know here in the future...
        UI:SetCenter(false)
        -- case 213: ' That means the only other\nPokémon we know here in the future...'
        -- case 214: ' That means the only other\nPokémon we know here in the future...'
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_075')) -- canon:  That leaves only [CS:N]Grovyle[CR]...
        UI:SetCenter(false)
        -- case 216: ' That leaves only [CS:N]Grovyle[CR]...'
        -- case 217: ' That leaves only [CS:N]Grovyle[CR]...'
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_076')) -- canon:  We don't have any choice.[K] We must rely on [CS:N]Grovyle[CR].
        UI:SetCenter(false)
        -- case 219: " We don't have any choice.[K]\nWe must rely on [CS:N]Grovyle[CR]."
        -- case 220: ' We have no choice.[K] We must pin\nour hopes on [CS:N]Grovyle[CR].'
        UI:ResetSpeaker()
        -- Jump (structurel)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
        SOUND:FadeOutBGM(160)
        GAME:WaitFrames(180)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_077')) -- canon:  Well then...[K]all right.
        -- case 222: ' Well then...[K]all right.'
        -- case 223: ' Well then...[K]OK.'
        UI:ResetSpeaker()
        GROUND:CharTurnToChar(CH('Teammate1'), CH('PLAYER'))
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_078')) -- canon:  All right, [hero].[K] Let's chase after [CS:N]Grovyle[CR]!
        UI:SetCenter(false)
        -- case 225: " All right, [hero].[K]\nLet's chase after [CS:N]Grovyle[CR]!"
        -- case 226: " OK, [hero].[K] Let's track\ndown [CS:N]Grovyle[CR]!"
        UI:SetCenter(true)
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_079')) -- canon:  Let's meet with [CS:N]Grovyle[CR] and ask him how to get back to our world!
        UI:SetCenter(false)
        -- case 228: " Let's meet with [CS:N]Grovyle[CR] and ask\nhim how to get back to our world!"
        -- case 229: " Let's meet with [CS:N]Grovyle[CR] and ask\nhim how we can return to our world!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Inspired')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_080')) -- canon: ([partner]!)
        -- case 231: '([partner]!)'
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_081')) -- canon:  Let's go, [hero]!
        -- case 233: " Let's go, [hero]!"
        -- case 234: " Let's go, [hero]!"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_082')) -- canon:  Let's go after [CS:N]Grovyle[CR]!
        -- case 236: " Let's go after [CS:N]Grovyle[CR]!"
        -- case 237: " Let's go after [CS:N]Grovyle[CR]!"
        UI:ResetSpeaker()
        -- SetAnimation id 71 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation id 71 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(45)
        GROUND:MoveToPosition(CH('PLAYER'), 376, 180, false, 1.594)
        GAME:WaitFrames(30)
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), 360, 176, false, 1.594)
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownRight, 15)
        pcall(function() SOUND:PlayBGM('In the Hands of Fate.ogg', true) end) -- InTheHandsOfFate
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_083')) -- canon:  [hero], thanks.
        -- case 239: ' [hero], thanks.'
        -- case 240: ' [hero], thank you.'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpLeft, 15)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Sad')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_084')) -- canon:  You were worried about me for being so down.
        -- case 242: ' You were worried about me for\nbeing so down.'
        -- case 243: ' You tried to pick me up because\nI was feeling down.'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_085')) -- canon:  Even though you should be just  as scared as I am, [hero]...[K] I'm sorry.
        -- case 245: " Even though you should be just \nas scared as I am, [hero]...[K] I'm sorry."
        -- case 246: " Even though you should be just \nas scared as I am, [hero]...[K] I'm sorry."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_086')) -- canon:  Even though I have my closest and most precious friend with me...
        -- case 248: ' Even though I have my closest\nand most precious friend with me...'
        -- case 249: ' Even though I have my closest\nand most precious friend with me...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_087')) -- canon:  I worried all alone...
        -- case 251: ' I worried all alone...'
        -- case 252: ' I worried all alone...'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_088')) -- canon:  And almost gave up alone.
        -- case 254: ' And almost gave up alone.'
        -- case 255: ' And almost gave up alone.'
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_089')) -- canon:  When, in fact, I'm not alone.
        -- case 257: " When, in fact, I'm not alone."
        -- case 258: " When, in fact, I'm not alone."
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Teammate1'), 340, 180, false, 1.594)
        GAME:WaitFrames(15)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Left, 15)
            end,
            function()
                GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 15)
            end,
        })
        GAME:WaitFrames(10)
        -- ExecuteCommon(JUMP_HAPPY_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_090')) -- canon:  I won't give up anymore.
        -- case 260: " I won't give up anymore."
        -- case 261: " I won't give up anymore."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_091')) -- canon:  Because you're by my side, I can be brave, [hero].
        -- case 263: " Because you're by my side, I can\nbe brave, [hero]."
        -- case 264: " Because you're by my side, I can\nbe brave, [hero]."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_092')) -- canon:  I'm going to be fine now.
        -- case 266: " I'm going to be fine now."
        -- case 267: " I'm going to be fine now."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_093')) -- canon:  So let's keep going, [hero].
        -- case 269: " So let's keep going,\n[hero]."
        -- case 270: " So let's keep going,\n[hero]."
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M18A0401_094')) -- canon:  Let's get back to our world...[K] together!
        -- case 272: " Let's get back to our world...[K]\ntogether!"
        -- case 273: " Let's get back to our world...[K]\ntogether!"
        UI:ResetSpeaker()
        -- SetAnimation id 71 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation id 71 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        pcall(function() GROUND:CharWaitAnim(CH('PLAYER')) end)
        -- SetAnimation id 2 : table anim REQUISE (non inventée)
        pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
        GAME:WaitFrames(45)
        SOUND:FadeOutBGM(180)
        GROUND:MoveToPosition(CH('PLAYER'), 488, 204, false, 2.0)
        GAME:WaitFrames(10)
        GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 24*8, false, 2.0)
        GROUND:MoveToPosition(CH('Teammate1'), 468, 204, false, 2.0)
        GAME:WaitFrames(30)
        GAME:FadeOut(false, 60)
        -- WaitBgm : PARTIEL
        GAME:WaitFrames(90)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m18a0401] scène interrompue : '..tostring(err)) end
end

return m18a0401
