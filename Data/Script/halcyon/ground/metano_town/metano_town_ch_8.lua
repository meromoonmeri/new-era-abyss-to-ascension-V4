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
    -- Boutique d'Échange (Ambipom) ouverte depuis le ch6 : ne plus la cacher.
    GROUND:Unhide('Swap_Owner')
    GROUND:Unhide('Swap')
    NPCRoutines.SetupChapter8Ground()
    if SV.Chapter8.ObtainedCrystalFragment and not SV.Chapter8.SanctuaryMidpointState then
        SV.Chapter8.SanctuaryMidpointState = 'Completed'
    end
    GAME:FadeIn(20)
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
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Spinda', 8) then return end
    local s = Ch8State()
    if s == "post_crystal" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Spinda_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT8_Spinda_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_8.Ludicolo_Action(chara, activator)
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
-- ÉPREUVE II DU TOURNOI : LE QUIZZ DE KIRLIA
-- ============================================================
function metano_town_ch_8.Kirlia_Action(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  
  GeneralFunctions.StartConversation(chara, "Bienvenue, explorateurs ![pause=15] Je suis Kirlia, l'érudite de la Guilde.", "Normal")
  
  if SV.Chapter8.QuizScore ~= nil then
    if SV.Chapter8.QuizScore == "Perfect" then
      UI:WaitShowDialogue("Vous avez obtenu un score parfait de 3 sur 3 ![pause=15] Vous êtes de brillants esprits !")
    else
      UI:WaitShowDialogue("Votre score est déjà enregistré.[pause=15] Préparez-vous bien pour l'épreuve de combat !")
    end
    GeneralFunctions.EndConversation(chara)
    return
  end
  
  UI:WaitShowDialogue("Le moment est venu de passer l'Épreuve II du Grand Tournoi Inter-Guilde :[pause=10] le Quizz Théorique d'Exploration !")
  UI:WaitShowDialogue("Je vais vous poser trois questions fondamentales. Êtes-vous prêts à relever le défi ?")
  
  UI:ChoiceMenuYesNo("Commencer le Quizz de Kirlia ?", true)
  UI:WaitForChoice()
  
  if not UI:ChoiceResult() then
    UI:WaitShowDialogue("Revenez me voir quand vous vous sentirez prêts ![pause=15] À bientôt.")
    GeneralFunctions.EndConversation(chara)
    return
  end
  
  local score = 0
  
  -- QUESTION 1 : Affinités de Types
  UI:WaitShowDialogue("Question 1 :[pause=10] Quel type de capacité est super efficace contre un Pokémon de type Acier et Spectre comme Exagide ?")
  local q1_choices = {"Type Combat", "Type Feu", "Type Normal", "Type Psy"}
  UI:BeginChoiceMenu("Choisissez votre réponse :", q1_choices, 1, 4)
  UI:WaitForChoice()
  if UI:ChoiceResult() == 2 then
    score = score + 1
    SOUND:PlaySE("DUN_Hit_Weak")
    UI:WaitShowDialogue("Exact ! Le type Feu fait fondre l'Acier. Très bonne analyse de type.")
  else
    SOUND:PlaySE("DUN_Worry_Seed")
    UI:WaitShowDialogue("Hélas non ! L'Acier résiste au Psy, et le type Spectre est immunisé contre le Combat et le Normal.")
  end
  
  -- QUESTION 2 : Histoire des Donjons
  GAME:WaitFrames(20)
  UI:WaitShowDialogue("Question 2 :[pause=10] Qui est le gardien ancestral qui veille au sommet de la Tour Céleste ?")
  local q2_choices = {"Lugia", "Rayquaza", "Dialga", "Ho-Oh"}
  UI:BeginChoiceMenu("Choisissez votre réponse :", q2_choices, 1, 4)
  UI:WaitForChoice()
  if UI:ChoiceResult() == 2 then
    score = score + 1
    SOUND:PlaySE("DUN_Hit_Weak")
    UI:WaitShowDialogue("Parfait ! Rayquaza, le régulateur de l'atmosphère, veille sur la Tour Céleste.")
  else
    SOUND:PlaySE("DUN_Worry_Seed")
    UI:WaitShowDialogue("Faux. C'est Rayquaza qui réside au sommet de la Tour Céleste.")
  end
  
  -- QUESTION 3 : Survie en Donjon
  GAME:WaitFrames(20)
  UI:WaitShowDialogue("Question 3 :[pause=10] Quel objet dissipe instantanément toutes les altérations de statut de votre équipe au sein d'un étage ?")
  local q3_choices = {"La Graine Guérison", "L'Orbe Échappée", "L'Orbe Purge", "Le Ruban Statut"}
  UI:BeginChoiceMenu("Choisissez votre réponse :", q3_choices, 1, 4)
  UI:WaitForChoice()
  if UI:ChoiceResult() == 3 then
    score = score + 1
    SOUND:PlaySE("DUN_Hit_Weak")
    UI:WaitShowDialogue("Magnifique ! L'Orbe Purge rétablit l'ensemble des membres de votre équipe.")
  else
    SOUND:PlaySE("DUN_Worry_Seed")
    UI:WaitShowDialogue("Non ! C'est l'Orbe Purge qui possède cette fabuleuse propriété curative.")
  end
  
  -- ÉVALUATION DU SCORE
  GAME:WaitFrames(30)
  UI:WaitShowDialogue("L'épreuve théorique est terminée ![pause=15] Passons au verdict...")
  
  if score == 3 then
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue("Incroyable ! Un score parfait de 3 sur 3 ! Kirlia est impressionnée par votre érudition !")
    SV.Chapter8.QuizScore = "Perfect"
  elseif score >= 1 then
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Vous avez obtenu " .. score .. " point(s) sur 3. C'est suffisant pour vous qualifier, mais restez sur vos gardes !")
    SV.Chapter8.QuizScore = "Pass"
  else
    GeneralFunctions.SetEmotion("Sad")
    UI:WaitShowDialogue("Zéro point... Quelle déception. Je vous conseille de relire vos manuels d'exploration d'urgence.")
    SV.Chapter8.QuizScore = "Fail"
  end
  
  GeneralFunctions.EndConversation(chara)
end

return metano_town_ch_8
