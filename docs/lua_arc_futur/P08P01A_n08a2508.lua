--[[
    P08P01A_n08a2508.lua — ARC DU FUTUR (adaptation New Era)
    Source canonique : pret/pmd-sky files/language-specific/US/SCRIPT/P08P01A/n08a2508.ssb
    Généré par tools/ssb_to_lua.py — IR canonique + couche d'adaptation New Era.
    Les dialogues joués sont des clés STRINGS (FUT_*), le texte canonique Sky
    est conservé en commentaire. Les tables anim/SE/effets manquantes sont
    marquées TODO (jamais inventées).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

local n08a2508 = {}

function n08a2508.Cutscene()
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)

        -- PARTIEL : sound_Stop []
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
        pcall(function() SOUND:PlayBGM('Oh No!.ogg', true) end) -- OhNo
        GAME:WaitFrames(30)
        UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
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
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2508_001')) -- canon: [CS:N]Sableye[CR]: Wheh-heh-heh!
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
        UI:SetSpeaker(CH('Dusknoir'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2508_002')) -- canon:  [CS:Y]Grovyle[CR]![K] You can't fail this time!
        UI:ResetSpeaker()
        UI:SetSpeaker(CH('HeroFuture'))
        GeneralFunctions.SetEmotion('Normal')
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2508_003')) -- canon:  Humph![K] I should say the same thing!
        UI:WaitShowDialogue(STRINGS:FormatKey('FUT_N08A2508_004')) -- canon:  Let's go!
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
  if not ok then PrintInfo('[n08a2508] scène interrompue : '..tostring(err)) end
end

return n08a2508
