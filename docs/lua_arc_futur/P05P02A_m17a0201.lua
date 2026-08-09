--[[
    P05P02A_m17a0201.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P05P02A/m17a0201.ssb
    Généré par tools/ssb_to_lua.py — IR canonique + couche d'adaptation New Era.
    Les dialogues joués sont des clés STRINGS (FUT_*), le texte canonique Sky
    est conservé en commentaire. Les tables anim/SE/effets manquantes sont
    marquées TODO (jamais inventées).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

local m17a0201 = {}

function m17a0201.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        pcall(function() SOUND:PlayBGM('In the Future.ogg', true) end) -- InTheFuture
        SV.Scenario.Main = 18 -- flag_SetScenario(SCENARIO_MAIN, scenario=18, level=2)
        -- (parallèle) ATTENDANT1, PLAYER
        TASK:JoinCoroutines({
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('PLAYER'), 'Idle', true) end) -- placeholder sûr
            end,
            function()
                -- SetAnimation id 2 : table anim REQUISE (non inventée)
                pcall(function() GROUND:CharSetAnim(CH('Teammate1'), 'Idle', true) end) -- placeholder sûr
            end,
        })
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        -- NON CONVERTI : message_Mail (courrier absent de PMDO)
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('PLAYER'))
        GeneralFunctions.SetEmotion('Worried')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0201_001')) -- canon: (It's no good.[K] Like [partner] said, these doors won't open.)
        -- case 2: "(It's no good.[K] Like [partner] said, these\ndoors won't open.)"
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_M17A0201_002')) -- canon: (It sure looks like we've been locked up!)
        -- case 4: "(It sure looks like we've been locked up!)"
        UI:ResetSpeaker()
        -- End : fin de scène

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[m17a0201] scène interrompue : '..tostring(err)) end
end

return m17a0201
