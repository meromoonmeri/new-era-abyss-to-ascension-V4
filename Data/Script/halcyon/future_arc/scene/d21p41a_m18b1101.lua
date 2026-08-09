--[[
    D21P41A_m18b1101.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D21P41A/m18b1101.ssb
    Généré par tools/ssb_to_lua.py — IR canonique + couche d'adaptation New Era.
    Chorégraphie 1:1 (déplacements, positions, timings, animations, caméra,
    fades, SFX, BGM, transitions, flags, embranchements). Seul le CAST change :
    Dusknoir/Grovyle (alliés), Sableye (sbires de Necrozma), Celebi, héros/
    partenaire ; le maître du futur = Necrozma (Dialga absent). Les dialogues
    canoniques sont joués (cast appliqué), la clé FUT_* en commentaire sert
    d'éventuelle passe FR. Les tables anim/SE/effets manquantes sont marquées
    TODO (jamais inventées).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

local m18b1101 = {}

function m18b1101.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- PARTIEL : back_SetDungeonBanner [31, 0] (bannière)
        GAME:FadeIn(16)
        GAME:WaitFrames(60)
        GAME:FadeOut(false, 16)
        GAME:WaitFrames(15)
        SV.Scenario.Main = 19 -- flag_SetScenario(SCENARIO_MAIN, scenario=19, level=4)
        -- back_SetGround(D21P41A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GROUND:CharSetAnim(CH('Grovyle'), 'Float', false) -- param 29 = anim 20 (Float)
        -- SetOutputAttribute [2] : PARTIEL
        -- object 61 (d21p41a1) : contexte objet
        local obj_61 = OBJ('d21p41a1') -- objet 61
        GROUND:ObjectSetAnim(obj_61, 1, 0, 3, Direction.Down, 1) -- anim 1 (table REQUISE)
        -- bgm_PlayFadeIn [112, 0, 256] : BGM StaticNoise non mappé
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:MoveToPosition(CH('Teammate1'), 296, 220, false, 3.0)
            end,
            function()
                GROUND:MoveToPosition(CH('PLAYER'), 272, 244, false, 3.0)
            end,
        })
        SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') -- SE 8967 (SE_NUM_EVENT_SIGN_NOTICE_04)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharSetEmote(CH('PLAYER'), 'exclaim', 3)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Hey!\n There\'s Grovyle!') -- FUT_M18B1101_001 (FR optionnel)
        -- case 0: " Hey![K] There's [CS:N]Grovyle[CR]!"
        -- case 1: " Hey![K] There's [CS:N]Grovyle[CR]!"
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' Urggh...\n You two...') -- FUT_M18B1101_002 (FR optionnel)
        UI:ResetSpeaker()
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' G-Grovyle! Are you all right?!') -- FUT_M18B1101_003 (FR optionnel)
        -- case 4: ' [CS:N]G-Grovyle[CR]! Are you all right?!'
        -- case 5: ' [CS:N]G-Grovyle[CR]! Are you all right?!'
        UI:ResetSpeaker()
        GROUND:MoveToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 1*8, CH('Teammate1').Position.Y + 28*8, false, 2.0)
        GAME:WaitFrames(5)
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 1*8, CH('PLAYER').Position.Y + 24*8, false, 2.0)
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' S-stay back!') -- FUT_M18B1101_004 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Huh?\n Wh-why?!') -- FUT_M18B1101_005 (FR optionnel)
        -- case 8: ' Huh?[K] Wh-why?!'
        -- case 9: ' What?[K] Wh-why?!'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' Careful!\n An enemy lurks nearby!') -- FUT_M18B1101_006 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8974') end) -- TODO SE 8974 (SE_NUM_EVENT_MOTION_JUNP_01)
        -- ExecuteCommon(JUMP_SURPRISE_FUNC_SERIES) : gestuelle parallèle à implémenter
        GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
        -- ExecuteCommon(LOOK_AROUND_RIGHT_FUNC_SERIES) : gestuelle parallèle à implémenter
        GAME:WaitFrames(12)
        -- ExecuteCommon(LOOK_AROUND_FUNC_SERIES) : gestuelle parallèle à implémenter
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' What?!\n Wh-where?') -- FUT_M18B1101_007 (FR optionnel)
        -- case 12: ' What?![K] Wh-where?'
        -- case 13: ' What?![K] Wh-where?'
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' It\'s right...\nbeside you!') -- FUT_M18B1101_008 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_8972') end) -- TODO SE 8972 (SE_NUM_EVENT_SIGN_TENSION_01)
        GROUND:CharSetEmote(CH('Teammate1'), 'sweatdrop', 3)
        -- WaitEffect (les appels GROUND sont bloquants)
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Next to me...?') -- FUT_M18B1101_009 (FR optionnel)
        -- case 16: ' Next to me...?'
        -- case 17: ' Next to me...?'
        UI:ResetSpeaker()
        GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 15)
        GAME:WaitFrames(5)
        GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.UpRight, 15)
        UI:SetCenter(true)
        UI:WaitShowDialogue(' It can\'t be this...') -- FUT_M18B1101_010 (FR optionnel)
        UI:SetCenter(false)
        -- case 19: " It can't be this..."
        -- case 20: " It can't be this..."
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(10)
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7426') end) -- TODO SE 7426 (None)
        -- object 64 (d21p41a2) : contexte objet
        local obj_64 = OBJ('d21p41a2') -- objet 64
        GROUND:ObjectSetAnim(obj_64, 18, 0, 3, Direction.Down, 1) -- anim 18 (table REQUISE)
        -- object 64 (d21p41a2) : contexte objet
        -- WaitAnimation sur objet d21p41a2 : PARTIEL
        -- object 64 (d21p41a2) : contexte objet
        local obj_64 = OBJ('d21p41a2') -- objet 64
        GROUND:ObjectSetAnim(obj_64, 9, 0, 3, Direction.Down, 1) -- anim 9 (table REQUISE)
        GAME:WaitFrames(15)
        -- PARTIEL : WaitSe [7426]
        SOUND:PlayBattleSE('EVT_Emote_Shock_2') -- SE 8968 (SE_NUM_EVENT_SIGN_SHOCK_01)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetEmote(CH('Teammate1'), 'shock', 3)
            end,
            function()
                GROUND:CharSetEmote(CH('PLAYER'), 'shock', 3)
            end,
        })
        -- performer 0
        GROUND:MoveToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 2.5*8, CH('PLAYER').Position.Y + 0*8, false, 5.0)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                GROUND:CharSetAnim(CH('PLAYER'), 'Walk', true) -- param 5 = anim 0 (Walk)
                GROUND:AnimateToPosition(CH('PLAYER'), CH('PLAYER').Position.X + 2.5*8, CH('PLAYER').Position.Y + 0*8, false, 5.0)
            end,
            function()
                GROUND:CharSetAnim(CH('Teammate1'), 'Walk', true) -- param 5 = anim 0 (Walk)
                GROUND:AnimateToPosition(CH('Teammate1'), CH('Teammate1').Position.X + 2.5*8, CH('Teammate1').Position.Y + 0*8, false, 5.0)
            end,
        })
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Shouting')
        UI:WaitShowDialogue(' Waaah!') -- FUT_M18B1101_011 (FR optionnel)
        -- case 22: ' Waaah!'
        -- case 23: ' Waaah!'
        -- SetAnimation 2 (spécial : boucle anim courante)
        -- SetAnimation 2 (spécial : boucle anim courante)
        UI:ResetSpeaker()
        GAME:WaitFrames(30)
        pcall(function() SOUND:PlayBGM('Planet\'s Paralysis.ogg', true) end) -- PlanetsParalysis
UI:SetSpeaker(CH('Spiritomb'))
        UI:WaitShowDialogue(' HEE-hee...HEE-hee...') -- FUT_M18B1101_012 (FR optionnel)
        UI:WaitShowDialogue(' All those who TRESPASS upon\nthis land...') -- FUT_M18B1101_013 (FR optionnel)
        UI:WaitShowDialogue(' None shall be FORGIVEN! None!') -- FUT_M18B1101_014 (FR optionnel)
        UI:WaitShowDialogue(' Not least of all...YOU!') -- FUT_M18B1101_015 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Teammate1'))
        GeneralFunctions.SetEmotion('Surprised')
        UI:WaitShowDialogue(' Who is that?!\n Who are you?!') -- FUT_M18B1101_016 (FR optionnel)
        -- case 29: ' Who is that?![K] Who are you?!'
        -- case 30: ' Who is that?![K] Who are you?!'
        UI:ResetSpeaker()
UI:SetSpeaker(CH('Spiritomb'))
        UI:WaitShowDialogue(' You ask that of US?') -- FUT_M18B1101_017 (FR optionnel)
        UI:WaitShowDialogue(' Our name is...\nSPIRITOMB.') -- FUT_M18B1101_018 (FR optionnel)
        UI:WaitShowDialogue(' We are the manifestation of a\nFUSION of spirits...') -- FUT_M18B1101_019 (FR optionnel)
        UI:ResetSpeaker()
        pcall(function() SOUND:PlayBattleSE('SSB_SE_7427') end) -- TODO SE 7427 (None)
        -- object 64 (d21p41a2) : contexte objet
        pcall(function() GROUND:RemoveCharacter(CH('Teammate1')) end)
        -- supervision_cting layer [1] (structurel)
        GAME:WaitFrames(1)
        GROUND:CharSetAnim(CH('Spiritomb'), 'Wake', false) -- param 23 = anim 14 (Wake)
        pcall(function() GROUND:CharWaitAnim(CH('Spiritomb')) end)
        -- PARTIEL : WaitSe [7427]
        UI:SetSpeaker(CH('Spiritomb'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' One hundred and EIGHT of them!') -- FUT_M18B1101_020 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Grovyle'))
        GeneralFunctions.SetEmotion('Pain')
        UI:WaitShowDialogue(' Be careful, you two!\n\nThat Pokémon is strong!') -- FUT_M18B1101_021 (FR optionnel)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('Spiritomb'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' HEE-hee...HEE-hee... PREPARE to\ntake your punishment!') -- FUT_M18B1101_022 (FR optionnel)
        UI:ResetSpeaker()
        SOUND:FadeOutBGM(30)
        SOUND:PlayBattleSE('EVT_Battle_Flash') -- SE 5143 (SE_NUM_EVENT_EFF_FLASH_HEAVY)
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        GAME:WaitFrames(10)
        SOUND:PlayBattleSE('EVT_Battle_Flash') -- SE 5143 (SE_NUM_EVENT_EFF_FLASH_HEAVY)
        GAME:FadeOut(true, 2)
        GAME:WaitFrames(2)
        GAME:FadeIn(2)
        -- PARTIEL : WaitSe [5143]
        -- CallCommon(BOSS_WIPE_FUNC) : helper à implémenter
        -- main_EnterDungeon(31) : entrée donjon (mapping id REQUIS)
        -- main_EnterDungeon(32767) : entrée donjon (mapping id REQUIS)
        -- Hold : NON CONVERTI (pause maintenue, pas d'équivalent PMDO)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m18b1101] scène interrompue : '..tostring(err)) end
end

return m18b1101
