--[[
    P08P01A_m19d0612.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P08P01A/m19d0612.ssb
    Généré par tools/ssb_to_lua.py — IR canonique + couche d'adaptation New Era.
    Les dialogues joués sont des clés STRINGS (FUT_*), le texte canonique Sky
    est conservé en commentaire. Les tables anim/SE/effets manquantes sont
    marquées TODO (jamais inventées).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

local m19d0612 = {}

function m19d0612.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- back_SetGround(P08P01A) : ground courant déjà posé
        -- supervision_cting layer [0] (structurel)
        -- performer 0
        -- camera_SetMyself : la caméra suit le héros (défaut PMDO)
        -- screen_FlushOut [1, 0, 8, 0, 0, 0] : fondu coloré (FlashEmitter, adaptation)
        GAME:FadeIn(30)
        GAME:WaitFrames(30)
        UI:SetSpeaker(CH('Celebi'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19D0612_001')) -- canon:  Besides, if you would be so kind as to prevent the planet's paralysis...
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19D0612_002')) -- canon:  We'll finally be spared the agony of this world of darkness.
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M19D0612_003')) -- canon:  My dear [CS:N]Grovyle[CR], I will devote my whole life to achieve that end!
        UI:ResetSpeaker()
        GAME:FadeOut(false, 30)
        -- screen_FlushIn [1, 0, 1, 0, 0, 0] : fondu coloré (FlashEmitter, adaptation)
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m19d0612] scène interrompue : '..tostring(err)) end
end

return m19d0612
