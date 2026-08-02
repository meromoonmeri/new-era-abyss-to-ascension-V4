--[[
    metano_town_ch_8.lua
    Chapitre 8 : Sanctuaire de Cristal — Diancie, Fragment de Cristal
    ~60 fonctions NPC, 6 paliers Ch8State(), 100+ clés RESX MT8_
    Routines de déplacement (npc_routines.lua) actives
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.npc_routines'
require 'halcyon.TownVoicesLate'
require 'halcyon.TownVoicesArc'
require 'halcyon.SideExpeditions'

metano_town_ch_8 = {}

local function Ch8State()
    if SV.Chapter8.ObtainedCrystalFragment then return "post_crystal"
    elseif SV.Chapter8.DefeatedDiancie then return "post_boss"
    elseif SV.Chapter8.ReachedCrystalRelay then return "post_relay"
    elseif SV.Chapter8.EnteredSanctuary then return "during"
    elseif SV.Chapter8.MissionAccepted then return "pre"
    else return "early"
    end
end

function metano_town_ch_8.SetupGround()
    GROUND:Unhide('Swap_Owner')
    GROUND:Unhide('Swap')
    NPCRoutines.SetupChapter8Ground()
    if SV.Chapter8.ObtainedCrystalFragment and not SV.Chapter8.SanctuaryMidpointState then
        SV.Chapter8.SanctuaryMidpointState = 'Completed'
    end
    if not SV.Chapter8.PlayedTournamentIntro then
        metano_town_ch_8.PlayTournamentIntro()
    else
        GAME:FadeIn(20)
    end
end

-- ============================================================
-- PNJ PRINCIPAUX — Guilde
-- ============================================================

function metano_town_ch_8.Noctowl_Action(chara, activator)
    local s = Ch8State()
    if s == "early" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_003']))
        GeneralFunctions.SetEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_004']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_005']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_006']))
        GeneralFunctions.SetEmotion("Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_007']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_008']))
        GeneralFunctions.SetEmotion("Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_009']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_010']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Noctowl_011']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Tropius_Action(chara, activator)
    local s = Ch8State()
    if s == "early" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Tropius_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Tropius_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Tropius_003']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Tropius_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Tropius_005']), "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Audino_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Audino_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Audino_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Audino_003']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Audino_004']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Audino_005']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Audino_006']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Audino_007']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Snubbull_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Snubbull_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Snubbull_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Snubbull_003']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Snubbull_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Snubbull_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Zigzagoon_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Zigzagoon_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Zigzagoon_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Zigzagoon_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Zigzagoon_004']), "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- SAGES & GARDIENS
-- ============================================================

function metano_town_ch_8.Relicanth_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Relicanth_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Relicanth_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Relicanth_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Relicanth_004']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Relicanth_005']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Relicanth_006']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Bisharp_Action(chara, activator)
  if SideExpeditions.Talk('Bisharp', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bisharp_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Bisharp_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bisharp_003']), "Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Bisharp_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bisharp_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Ledian_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Ledian_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Ledian_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Ledian_003']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Ledian_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Ledian_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- FAMILLE NIDOKING/NIDOQUEEN
-- ============================================================

function metano_town_ch_8.Nidoqueen_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidoqueen_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Nidoqueen_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidoqueen_003']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Nidoqueen_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidoqueen_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Nidoking_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Nidoking', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidoking_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Nidoking_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidoking_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidoking_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Nidorina_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Nidorina', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidorina_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Nidorina_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidorina_003']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Nidorina_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Nidoran_Male_Action(chara, activator)
  if TownVoicesArc.Talk('Nidoran_Male', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_NidoranM_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_NidoranM_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- FAMILLE FURET (Furret/Linoone/Sentret)
-- ============================================================

function metano_town_ch_8.Furret_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Furret', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Furret_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Furret_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Furret_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Furret_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Linoone_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Linoone', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Linoone_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Linoone_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Linoone_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Linoone_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Sentret_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Sentret', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Sentret_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Sentret_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Sentret_003']), "Determined")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Sentret_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- FAMILLE NUMEL/CAMERUPT
-- ============================================================

function metano_town_ch_8.Numel_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Numel_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Numel_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Numel_003']), "Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Numel_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Numel_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Camerupt_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Camerupt_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Camerupt_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Camerupt_003']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Camerupt_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Camerupt_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- FAMILLE MACHAMP/MEDICHAM
-- ============================================================

function metano_town_ch_8.Machamp_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Machamp', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Machamp_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Machamp_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Machamp_003']), "Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Machamp_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Machamp_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Medicham_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Medicham', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Medicham_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Medicham_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Medicham_003']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Medicham_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Medicham_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Meditite_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Meditite_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Meditite_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Meditite_003']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Meditite_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Meditite_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- VILLAGEOIS
-- ============================================================

function metano_town_ch_8.Mawile_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Mawile_001']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Mawile_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Mawile_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Mawile_004']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Mawile_005']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Mawile_006']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Floatzel_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Floatzel_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Floatzel_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Floatzel_003']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Floatzel_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Floatzel_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Quagsire_Action(chara, activator)
  if SideExpeditions.Talk('Quagsire', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Quagsire_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Quagsire_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Quagsire_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- ENFANTS & JEUNES
-- ============================================================

function metano_town_ch_8.Wooper_Girl_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Wooper_Girl', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_WooperG_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_WooperG_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_WooperG_003']), "Determined")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_WooperG_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Wooper_Boy_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Wooper_Boy', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_WooperB_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_WooperB_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_WooperB_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_WooperB_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Electrike_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Electrike_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Electrike_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Electrike_003']), "Shock")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Electrike_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Electrike_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- PLANTES
-- ============================================================

function metano_town_ch_8.Vileplume_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Vileplume', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Vileplume_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Vileplume_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Vileplume_003']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Vileplume_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Vileplume_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Bellossom_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Bellossom', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bellossom_001']), "Joyous")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Bellossom_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bellossom_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bellossom_004']), "Happy")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Gloom_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Gloom', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Gloom_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Gloom_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Gloom_003']), "Sad")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Gloom_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Oddish_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Oddish', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Oddish_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Oddish_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Oddish_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Oddish_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- CAFÉ & BOUTIQUES
-- ============================================================

function metano_town_ch_8.Gulpin_Action(chara, activator)
  if TownVoicesArc.Talk('Gulpin', 8) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Gulpin', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Gulpin_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Gulpin_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Gulpin_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Gulpin_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Lickitung_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Lickitung', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Lickitung_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Lickitung_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Lickitung_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Lickitung_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Spinda_Action(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  
  if not SV.Chapter8.PlayedTournamentIntro then
    metano_town_ch_8.PlayTournamentIntro()
    return
  end

  local stage = SV.Chapter8.TournamentStage or 1
  GeneralFunctions.StartConversation(chara, "Bonjour " .. hero:GetDisplayName() .. " ![pause=15] Prêts pour la suite du Tournoi ?", "Happy")

  if stage == 1 then
    -- Épreuve I active
    UI:WaitShowDialogue("L'Épreuve I est en cours : vous devez vaincre les gardiens de Zorua/Zoroark et capturer Zorua dans la Forêt Embuscade !")
    
    local choices = {
      "Mont Tonnerre (Raichu & Pichu)",
      "Forêt Givrée (Blizzaroi)",
      "Croisée de Cristal (Évolitions)",
      "Forêt Embuscade (Capture de Zorua & Embuscade finale)",
      "Quitter"
    }
    UI:BeginChoiceMenu("Quelle destination pour l'Épreuve I ?", choices, 1, 5)
    UI:WaitForChoice()
    local result = UI:ChoiceResult()
    
    if result == 1 then
      UI:WaitShowDialogue("En route pour le Mont Tonnerre ! Battez Raichu !")
      GAME:FadeOut(false, 20)
      SV.Chapter8.DefeatedRaichu = true -- Marque comme battu pour simplifier la démo
      GAME:FadeIn(20)
      UI:WaitShowDialogue("Raichu et son groupe ont été maîtrisés avec succès !")
    elseif result == 2 then
      UI:WaitShowDialogue("En route pour la Forêt Givrée ! Délogez Blizzaroi !")
      GAME:FadeOut(false, 20)
      SV.Chapter8.DefeatedBlizzaroi = true
      GAME:FadeIn(20)
      UI:WaitShowDialogue("Blizzaroi a été calmé avec succès !")
    elseif result == 3 then
      UI:WaitShowDialogue("En route pour la Croisée de Cristal ! Défiez la famille Évoli !")
      GAME:FadeOut(false, 20)
      SV.Chapter8.DefeatedEevee = true
      GAME:FadeIn(20)
      UI:WaitShowDialogue("La famille Évoli a reconnu votre valeur avec honneur !")
    elseif result == 4 then
      if not (SV.Chapter8.DefeatedRaichu and SV.Chapter8.DefeatedBlizzaroi and SV.Chapter8.DefeatedEevee) then
        UI:WaitShowDialogue("Vous devez d'abord vaincre les 3 premiers lieutenants avant d'accéder au repaire de Zorua !")
      else
        UI:WaitShowDialogue("Zorua est localisé dans la Forêt Embuscade ! En route pour la capture !")
        GAME:FadeOut(false, 40)
        GAME:CutsceneMode(false)
        -- Téléporte vers la carte de combat finale d'embuscade
        GAME:EnterGroundMap("foret_embuscade_boss", "Main_Entrance_Marker", true)
        return
      end
    else
      UI:WaitShowDialogue("Préparez-vous bien avant de vous lancer !")
    end

  elseif stage == 2 then
    -- Épreuve I terminée, attente de 3 jours
    local days = SV.Chapter8.DaysSinceLastTrial or 0
    if days < 3 then
      UI:WaitShowDialogue("Félicitations pour la capture de Zorua ![pause=15] Reposez-vous et accomplissez d'autres missions libres pendant 3 jours.")
      UI:WaitShowDialogue("Jours d'attente restants : " .. (3 - days) .. " jour(s).")
    else
      UI:WaitShowDialogue("Les 3 jours se sont écoulés ![pause=15] L'Épreuve II (le quizz théorique de Kirlia) est désormais prête !")
      SV.Chapter8.TournamentStage = 3
    end

  elseif stage == 3 then
    -- Épreuve II active
    UI:WaitShowDialogue("L'Épreuve II est ouverte ![pause=15] Allez voir Kirlia au Café de la ville pour répondre à ses questions théoriques !")

  elseif stage == 4 then
    -- Épreuve II terminée, attente de 3 jours
    local days = SV.Chapter8.DaysSinceLastTrial or 0
    if days < 3 then
      UI:WaitShowDialogue("Excellent travail pour l'épreuve théorique ! Accomplissez des missions pendant 3 jours avant la grande épreuve finale de combat.")
      UI:WaitShowDialogue("Jours d'attente restants : " .. (3 - days) .. " jour(s).")
    else
      UI:WaitShowDialogue("Les 3 jours sont passés ![pause=15] L'Épreuve III (le combat en arène) est désormais prête !")
      SV.Chapter8.TournamentStage = 5
    end

  elseif stage == 5 then
    -- Épreuve III active : les matches
    UI:WaitShowDialogue("Bienvenue dans la phase de combat en arène de l'Épreuve III !")
    
    local choices = {
      "Quart de finale : vs. Guilde du Glacier (Dimoret)",
      "Demi-finale : vs. Team Dazzling",
      "Grande Finale : vs. Team Alakazam",
      "Quitter"
    }
    UI:BeginChoiceMenu("Quel match lancer ?", choices, 1, 4)
    UI:WaitForChoice()
    local result = UI:ChoiceResult()
    
    if result == 1 then
      UI:WaitShowDialogue("Début du Quart de finale contre la Guilde du Glacier !")
      GAME:FadeOut(false, 20)
      SV.Chapter8.WinQuarters = true
      GAME:FadeIn(20)
      UI:WaitShowDialogue("Victoire ! Vous vous qualifiez pour les demi-finales !")
    elseif result == 2 then
      if not SV.Chapter8.WinQuarters then
        UI:WaitShowDialogue("Vous devez d'abord gagner le quart de finale !")
      else
        UI:WaitShowDialogue("Début de la Demi-finale contre la Team Dazzling !")
        GAME:FadeOut(false, 20)
        SV.Chapter8.WinSemis = true
        GAME:FadeIn(20)
        UI:WaitShowDialogue("Victoire éclatante face à la Team Dazzling !")
      end
    elseif result == 3 then
      if not SV.Chapter8.WinSemis then
        UI:WaitShowDialogue("Vous devez d'abord gagner la demi-finale !")
      else
        UI:WaitShowDialogue("C'est l'heure de la grande finale contre la légendaire Team Alakazam !!")
        metano_town_ch_8.PlayFinalTournamentScene()
        return
      end
    else
      UI:WaitShowDialogue("Entraînez-vous bien avant de monter sur l'arène !")
    end

  elseif stage == 6 then
    -- Tournoi remporté
    UI:WaitShowDialogue("Vous êtes les champions du Grand Tournoi Inter-Guilde ![pause=15] La foule vous acclame !")
    UI:WaitShowDialogue("À présent, vous pouvez partir explorer le Sanctuaire de Cristal pour percer le secret du fragment.")
    SV.Chapter8.MissionAccepted = true -- Ouvre le Sanctuaire de Cristal
  end

  GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_8.Ludicolo_Action(chara, activator)
  if TownVoicesArc.Talk('Ludicolo', 8) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Ludicolo', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Ludicolo_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Ludicolo_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- AUTRES PNJ
-- ============================================================

function metano_town_ch_8.Luxray_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Luxray', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Luxray_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Luxray_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Luxray_003']), "Determined")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Luxray_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Manectric_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Manectric', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Manectric_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Manectric_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Manectric_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Manectric_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Azumarill_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Azumarill_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Azumarill_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Azumarill_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Azumarill_004']), "Happy")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Roselia_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Roselia', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Roselia_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Roselia_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Roselia_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Jigglypuff_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Jigglypuff', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Jigglypuff_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Jigglypuff_002']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Jigglypuff_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Marill_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Marill', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Marill_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Marill_002']), "Sad")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Marill_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Spheal_Action(chara, activator)
  if TownVoicesArc.Talk('Spheal', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Spheal_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Spheal_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Bagon_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bagon_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Bagon_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bagon_003']), "Determined")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Bagon_004']), "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Doduo_Action(chara, activator)
  if TownVoicesArc.Talk('Doduo', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Doduo_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Doduo_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Metapod_Action(chara, activator)
  if TownVoicesArc.Talk('Metapod', 8) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Metapod', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Metapod_001']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Metapod_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Silcoon_Action(chara, activator)
  if TownVoicesArc.Talk('Silcoon', 8) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Silcoon', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Silcoon_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Silcoon_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Mareep_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Mareep', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Mareep_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Mareep_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Mareep_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Mareep_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Cranidos_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Cranidos', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Cranidos_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Cranidos_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Cranidos_003']), "Determined")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Cranidos_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- TEAM DAZZLING & INVITÉS
-- ============================================================

function metano_town_ch_8.Butterfree_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Butterfree_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Butterfree_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Butterfree_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Butterfree_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Venipede_Action(chara, activator)
  if TownVoicesArc.Talk('Venipede', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Venipede_001']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Venipede_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Adagio_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Adagio_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Adagio_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Adagio_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Aria_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Aria_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Aria_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Aria_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Sonata_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Sonata_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Sonata_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Sonata_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Growlithe_Desk_Action(chara, activator)
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Growlithe_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT8_Growlithe_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Growlithe_003']), "Determined")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Growlithe_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- SCÈNE D'INTRO DU TOURNOI : SPINDA, QULBUTOKÉ, OKÉOKÉ & GUILDES
-- ============================================================
function metano_town_ch_8.PlayTournamentIntro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  
  GAME:CutsceneMode(true)
  SOUND:PlayBGM("Spinda's Cafe.ogg", true)
  GAME:MoveCamera(1184, 1160, 1, false) -- Cadre sur le bar de Spinda
  GAME:FadeIn(40)
  GAME:WaitFrames(30)
  
  -- Spinda s'adresse à la foule réunie sur la place
  local spinda = CH('Spinda')
  UI:SetSpeaker(spinda)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue("Laaaah ![pause=10] Approchez tous, explorateurs et habitants de Metano Town !")
  UI:WaitShowDialogue("Pour dissiper la tristesse et l'inquiétude de ces séismes, nous organisons... le GRAND TOURNOI INTER-GUILDE !")
  
  -- Spawn temporaire de Qulbutoké, Okéoké, et Grodoudou (Treasure Town)
  local wobbuffet = CharacterEssentials.MakeCharactersFromList({{'Wobbuffet', 1150, 1160, Direction.Right}}, true)
  local wynaut = CharacterEssentials.MakeCharactersFromList({{'Wynaut', 1150, 1180, Direction.Right}}, true)
  local wigglytuff = CharacterEssentials.MakeCharactersFromList({{'Wigglytuff', 1220, 1180, Direction.Left}}, true)
  
  SOUND:PlayBattleSE("DUN_Shock_Wave") -- Effet comique pour Wobbuffet
  UI:SetSpeaker(wobbuffet)
  UI:WaitShowDialogue("QUL-BU-TO-KÉ !!!")
  
  UI:SetSpeaker(wynaut)
  UI:WaitShowDialogue("O-KÉ-O-KÉ !!!")
  
  UI:SetSpeaker(wigglytuff)
  UI:WaitShowDialogue("YAAAHAAA ![pause=15] C'est super joyeux ! Un grand tournoi avec plein d'amis et de Pommes Parfaites !")
  
  -- Le partenaire réagit avec enthousiasme
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Inspired")
  UI:WaitShowDialogue("Oh ! La Guilde de Grodoudou est venue de Treasure Town pour participer ? C'est fantastique !")
  
  UI:SetSpeaker(spinda)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Et ce n'est pas tout ! 10 autres guildes du monde entier ont envoyé leurs meilleurs combattants !")
  UI:WaitShowDialogue("L'Épreuve I commence aujourd'hui : nous devons traquer et capturer Zorua, le voleur légendaire de Kecleon !")
  UI:WaitShowDialogue("Venez me parler au stand pour choisir votre donjon de traque. Bonne chance à tous !")
  
  -- Nettoyage des personnages temporaires
  GAME:GetCurrentGround():RemoveTempChar(wobbuffet)
  GAME:GetCurrentGround():RemoveTempChar(wynaut)
  GAME:GetCurrentGround():RemoveTempChar(wigglytuff)
  
  SV.Chapter8.PlayedTournamentIntro = true
  SV.Chapter8.TournamentStage = 1
  
  GAME:CutsceneMode(false)
end

-- ============================================================
-- SCÈNE FINALE DU TOURNOI : GRANDE FINALE VS. TEAM ALAKAZAM
-- ============================================================
function metano_town_ch_8.PlayFinalTournamentScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local spinda = CH('Spinda')
  
  GAME:CutsceneMode(true)
  GAME:FadeOut(false, 20)
  
  -- Téléportation dans l'arène de combat décorée
  GAME:MoveCamera(176, 220, 1, false)
  
  -- Spawn de l'équipe Alakazam
  local alakazam = CharacterEssentials.MakeCharactersFromList({{'Alakazam', 176, 170, Direction.Down}}, true)
  local tyranitar = CharacterEssentials.MakeCharactersFromList({{'Tyranitar', 140, 150, Direction.Down}}, true)
  local charizard = CharacterEssentials.MakeCharactersFromList({{'Charizard', 212, 150, Direction.Down}}, true)
  
  GROUND:TeleportTo(hero, 160, 270, Direction.Up)
  GROUND:TeleportTo(partner, 192, 270, Direction.Up)
  
  SOUND:PlayBGM("Battle - Final Boss.ogg", true) -- Musique de finale ultra intense !
  GAME:FadeIn(40)
  GAME:WaitFrames(30)
  
  UI:SetSpeaker(spinda)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue("Laaah ![pause=10] Nous y sommes enfin ! La GRANDE FINALE du tournoi inter-guilde !")
  UI:WaitShowDialogue("D'un côté, nos héros locaux, vainqueurs de la Meute et du quizz ! De l'autre, la légendaire TEAM ALAKAZAM !")
  
  UI:SetSpeaker(alakazam)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Votre progression est impressionnante, " .. hero:GetDisplayName() .. ". Vos exploits face à Zorua ont retenti jusqu'à nous.")
  UI:WaitShowDialogue("Mais sur cette arène, nous ne retiendrons pas nos coups. Montrez-moi l'étendue de votre lien !")
  
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue("On a surmonté toutes les épreuves, et on ne flanchera pas si près du but ! C'est parti, héraut !")
  
  -- Effets visuels de préparation au combat
  SOUND:PlaySE("DUN_Attack_Boost")
  pcall(function() BossFX.Flash(176, 220, 3, 5, 20) end)
  GAME:WaitFrames(30)
  
  -- Combat de finale
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue("La finale commence ! Victoire éclatante des protagonistes après un duel d'anthologie !")
  UI:SetCenter(false)
  
  -- Couronnement
  UI:SetSpeaker(spinda)
  GeneralFunctions.SetEmotion("Joyous")
  UI:WaitShowDialogue("Et c'est la VICTOIRE !!! Nos héros remportent le trophée du Grand Tournoi sous les acclamations ! LA-LAAAH !")
  
  -- Nettoyage
  GAME:GetCurrentGround():RemoveTempChar(alakazam)
  GAME:GetCurrentGround():RemoveTempChar(tyranitar)
  GAME:GetCurrentGround():RemoveTempChar(charizard)
  
  SV.Chapter8.TournamentStage = 6 -- Débloque l'accès au Sanctuaire de Cristal !
  
  GAME:FadeOut(false, 40)
  GAME:WaitFrames(40)
  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("metano_town", "Main_Entrance_Marker", true)
end

return metano_town_ch_8
