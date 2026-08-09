--[[
    D21P41A_m18b1201.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/D21P41A/m18b1201.ssb
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

local m18b1201 = {}

function m18b1201.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
        -- PARTIEL : back_SetDungeonBanner [31, 0] (bannière)
        GAME:FadeIn(16)
        GAME:WaitFrames(60)
        GAME:FadeOut(false, 16)
        GAME:WaitFrames(15)
        -- back_SetGround(D21P41A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        GROUND:CharSetAnim(CH('Grovyle'), 'Float', false) -- param 29 = anim 20 (Float)
        -- SetOutputAttribute [2] : PARTIEL
        -- object 61 (d21p41a1) : contexte objet
        local obj_61 = OBJ('d21p41a1') -- objet 61
        GROUND:ObjectSetAnim(obj_61, 1, 0, 3, Direction.Down, 1) -- anim 1 (table REQUISE)
        pcall(function() SOUND:PlayBGM('Planet\'s Paralysis.ogg', true) end) -- PlanetsParalysis
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Spiritomb'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(' HEE-hee...HEE-hee...! Back again?') -- FUT_M18B1201_001 (FR optionnel)
        UI:WaitShowDialogue(' None shall be forgiven for\nTRESPASSING here!') -- FUT_M18B1201_002 (FR optionnel)
        UI:WaitShowDialogue(' HEE-hee...HEE-hee... PREPARE to\ntake your punishment!') -- FUT_M18B1201_003 (FR optionnel)
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
  if not ok then PrintInfo('[m18b1201] scène interrompue : '..tostring(err)) end
end

return m18b1201
