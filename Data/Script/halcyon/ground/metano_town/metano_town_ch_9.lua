--[[
    metano_town_ch_9.lua
    Chapitre 9 : Marais de l'Oubli — Mega-Blastoise, Cercle du Suaire
    ~60 fonctions NPC, 6 paliers Ch9State(), 200+ clés RESX MT9_
    Première apparition antagoniste : Banette, Ectoplasma, Nosferalto
    Routines + dispute observable Floatzel/Quagsire
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.npc_routines'
require 'halcyon.TownVoicesLate'
require 'halcyon.TownVoicesArc'
require 'halcyon.SideExpeditions'

metano_town_ch_9 = {}

local function Ch9State()
    if SV.Chapter9.PurifiedMarshCore then return "post_purify"
    elseif SV.Chapter9.DefeatedMegaBlastoise then return "post_boss"
    elseif SV.Chapter9.SawCercleDuSuaire then return "post_suaire"
    elseif SV.Chapter9.ReachedMarshRelay then return "post_relay"
    elseif SV.Chapter9.MissionAccepted then return "during"
    elseif SV.Chapter9.MarshAddressGiven then return "pre"
    else return "early"
    end
end

function metano_town_ch_9.SetupGround()
    -- Boutique d'Échange (Ambipom) ouverte depuis le ch6 : ne plus la cacher.
    GROUND:Unhide('Swap_Owner'); GROUND:Unhide('Swap')
    NPCRoutines.SetupChapter8Ground()
    -- Check for dispute scene
    if SV.Chapter9.PurifiedMarshCore and not SV.Chapter9.FloatzelDisputeResolved then
        NPCRoutines.TriggerFloatzelQuagsireDispute()
    end
    GAME:FadeIn(20)
end

-- ============================================================
-- PNJ PRINCIPAUX — Guilde
-- ============================================================

function metano_town_ch_9.Noctowl_Action(chara, activator)
    local s = Ch9State()
    if s == "early" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Noctowl_001']))
        GeneralFunctions.SetEmotion("Worried"); UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Noctowl_002']))
        GeneralFunctions.SetEmotion("Normal"); UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Noctowl_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Noctowl_004']))
        GeneralFunctions.SetEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Noctowl_005']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Noctowl_006']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Noctowl_007']))
        GeneralFunctions.SetEmotion("Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Noctowl_008']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Noctowl_009']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Noctowl_010']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Noctowl_011']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Noctowl_012']))
        GeneralFunctions.SetEmotion("Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Noctowl_013']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Noctowl_014']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Noctowl_015']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Tropius_Action(chara, activator)
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Tropius_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Tropius_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Tropius_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Tropius_004']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Tropius_005']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Tropius_006']), "Determined")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Tropius_007']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Audino_Action(chara, activator)
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Audino_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Audino_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Audino_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Audino_004']), "Shock")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Audino_005']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Audino_006']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Audino_007']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Snubbull_Action(chara, activator)
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Snubbull_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Snubbull_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Snubbull_003']), "Shock")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Snubbull_004']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Snubbull_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Snubbull_006']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Zigzagoon_Action(chara, activator)
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Zigzagoon_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Zigzagoon_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Zigzagoon_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Zigzagoon_004']), "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- SAGES
-- ============================================================

function metano_town_ch_9.Relicanth_Action(chara, activator)
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Relicanth_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Relicanth_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Relicanth_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Relicanth_004']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Relicanth_005']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Relicanth_006']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Relicanth_007']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Bisharp_Action(chara, activator)
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Bisharp_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Bisharp_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Bisharp_003']), "Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Bisharp_004']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Bisharp_005']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Bisharp_006']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Ledian_Action(chara, activator)
  if SideExpeditions.Talk('Ledian', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Ledian_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Ledian_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Ledian_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Ledian_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- FAMILLE MACHAMP/MEDICHAM — Dispute boîte aux lettres
-- ============================================================

function metano_town_ch_9.Machamp_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Machamp', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Machamp_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Machamp_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Machamp_003']), "Shock")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Machamp_004']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Machamp_005']), "Determined")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Machamp_006']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Medicham_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Medicham', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Medicham_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Medicham_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Medicham_003']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Medicham_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Medicham_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Meditite_Action(chara, activator)
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Meditite_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Meditite_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Meditite_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Meditite_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- FAMILLE NIDO — Nidorina fugue en douce
-- ============================================================

function metano_town_ch_9.Nidoqueen_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Nidoqueen', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Nidoqueen_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Nidoqueen_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Nidoqueen_003']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Nidoqueen_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Nidoqueen_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Nidoking_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Nidoking', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Nidoking_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Nidoking_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Nidoking_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Nidoking_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Nidorina_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Nidorina', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Nidorina_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Nidorina_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Nidorina_003']), "Determined")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Nidorina_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Nidoran_Male_Action(chara, activator)
  if TownVoicesArc.Talk('Nidoran_Male', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_NidoranM_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_NidoranM_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- NUMEL & CAMERUPT — Numel veut s'entraîner
-- ============================================================

function metano_town_ch_9.Numel_Action(chara, activator)
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Numel_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Numel_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Numel_003']), "Determined")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Numel_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Camerupt_Action(chara, activator)
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Camerupt_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Camerupt_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Camerupt_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Camerupt_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- DISPUTE FLOATEZEL/QUAGSIRE — observable par le joueur
-- ============================================================

function metano_town_ch_9.Floatzel_Action(chara, activator)
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Floatzel_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Floatzel_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Floatzel_003']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Floatzel_004']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Floatzel_005']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Floatzel_006']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Quagsire_Action(chara, activator)
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Quagsire_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Quagsire_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Quagsire_003']), "Sad")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Quagsire_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- MAWILE — Scoop sur le Cercle du Suaire
-- ============================================================

function metano_town_ch_9.Mawile_Action(chara, activator)
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Mawile_001']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Mawile_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Mawile_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Mawile_004']), "Shock")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Mawile_005']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Mawile_006']), "Surprised")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Mawile_007']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- ELECTRIKE — Sent la présence spectrale
-- ============================================================

function metano_town_ch_9.Electrike_Action(chara, activator)
    local s = Ch9State()
    if s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Electrike_001']), "Shock")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Electrike_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Electrike_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Electrike_004']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Electrike_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Manectric_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Manectric', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Manectric_001']), "Normal")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Manectric_002']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Manectric_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- LUXRAY — Première mention Escouade Fulgur
-- ============================================================

function metano_town_ch_9.Luxray_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Luxray', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Luxray_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Luxray_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Luxray_003']), "Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Luxray_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Luxray_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- VILLAGEOIS — Réactions au marais + corruption
-- ============================================================

function metano_town_ch_9.Vileplume_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Vileplume', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Vileplume_001']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Vileplume_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Vileplume_003']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Vileplume_004']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Bellossom_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Bellossom', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Bellossom_001']), "Joyous")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Bellossom_002']), "Sad")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Bellossom_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Gloom_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Gloom', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Gloom_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Gloom_002']), "Sad")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Gloom_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Oddish_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Oddish', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Oddish_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Oddish_002']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Oddish_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- FURET & AMIS
-- ============================================================

function metano_town_ch_9.Furret_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Furret', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Furret_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Furret_002']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Furret_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Linoone_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Linoone', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Linoone_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Linoone_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Linoone_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Sentret_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Sentret', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Sentret_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Sentret_002']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Sentret_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- WOOPERS
-- ============================================================

function metano_town_ch_9.Wooper_Girl_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Wooper_Girl', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_WooperG_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_WooperG_002']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_WooperG_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Wooper_Boy_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Wooper_Boy', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_WooperB_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_WooperB_002']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_WooperB_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- CAFÉ & AUTRES
-- ============================================================

function metano_town_ch_9.Gulpin_Action(chara, activator)
  if TownVoicesArc.Talk('Gulpin', 9) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Gulpin', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Gulpin_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Gulpin_002']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Gulpin_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Lickitung_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Lickitung', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Lickitung_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Lickitung_002']), "Sad")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Lickitung_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Spinda_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Spinda', 9) then return end
    GeneralFunctions.StartConversation(chara,
        STRINGS:Format(STRINGS.MapStrings['MT9_Spinda_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_9.Ludicolo_Action(chara, activator)
  if TownVoicesArc.Talk('Ludicolo', 9) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Ludicolo', 9) then return end
    GeneralFunctions.StartConversation(chara,
        STRINGS:Format(STRINGS.MapStrings['MT9_Ludicolo_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_9.Azumarill_Action(chara, activator)
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Azumarill_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Azumarill_002']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Azumarill_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Roselia_Action(chara, activator)
  if SideExpeditions.Talk('Roselia', 9) then return end
  if TownVoicesArc.Talk('Roselia', 9) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Roselia', 9) then return end
    GeneralFunctions.StartConversation(chara,
        STRINGS:Format(STRINGS.MapStrings['MT9_Roselia_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end

-- ============================================================
-- MINEURS
-- ============================================================

function metano_town_ch_9.Jigglypuff_Action(chara, activator)
  if TownVoicesArc.Talk('Jigglypuff', 9) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Jigglypuff', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Jigglypuff_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Jigglypuff_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Marill_Action(chara, activator)
  if TownVoicesArc.Talk('Marill', 9) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Marill', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Marill_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Marill_002']), "Sad")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Spheal_Action(chara, activator)
  if TownVoicesArc.Talk('Spheal', 9) then return end
    GeneralFunctions.StartConversation(chara,
        STRINGS:Format(STRINGS.MapStrings['MT9_Spheal_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_9.Bagon_Action(chara, activator)
  if TownVoicesArc.Talk('Bagon', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Bagon_001']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Bagon_002']), "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Doduo_Action(chara, activator)
  if TownVoicesArc.Talk('Doduo', 9) then return end
    GeneralFunctions.StartConversation(chara,
        STRINGS:Format(STRINGS.MapStrings['MT9_Doduo_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_9.Metapod_Action(chara, activator)
  if TownVoicesArc.Talk('Metapod', 9) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Metapod', 9) then return end
    GeneralFunctions.StartConversation(chara,
        STRINGS:Format(STRINGS.MapStrings['MT9_Metapod_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_9.Silcoon_Action(chara, activator)
  if TownVoicesArc.Talk('Silcoon', 9) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Silcoon', 9) then return end
    GeneralFunctions.StartConversation(chara,
        STRINGS:Format(STRINGS.MapStrings['MT9_Silcoon_001']), "Normal")
    GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_9.Mareep_Action(chara, activator)
  if TownVoicesArc.Talk('Mareep', 9) then return end
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Mareep', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Mareep_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Mareep_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Cranidos_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Cranidos', 9) then return end
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Cranidos_001']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Cranidos_002']), "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- TEAM DAZZLING & INVITÉS
-- ============================================================

function metano_town_ch_9.Butterfree_Action(chara, activator)
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Butterfree_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Butterfree_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Venipede_Action(chara, activator)
    GeneralFunctions.StartConversation(chara,
        STRINGS:Format(STRINGS.MapStrings['MT9_Venipede_001']), "Happy")
    GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_9.Adagio_Action(chara, activator)
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Adagio_001']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Adagio_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Adagio_003']), "Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT9_Adagio_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Adagio_005']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Aria_Action(chara, activator)
    local s = Ch9State()
    if s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Aria_001']), "Shock")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Aria_002']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Aria_003']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Sonata_Action(chara, activator)
    local s = Ch9State()
    if s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Sonata_001']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Sonata_002']), "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_9.Growlithe_Desk_Action(chara, activator)
    local s = Ch9State()
    if s == "post_purify" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Growlithe_001']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_suaire" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Growlithe_002']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT9_Growlithe_003']), "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end



-- =========================================================================
-- EXPANSION NARRATIVE DU RÉALISATEUR : VIE QUOTIDIENNE À METANO TOWN (CH9)
-- Thème : Marais de l'Oubli (Laggron, Marais, Expédition)
-- Respect respiration Chunsoft ([pause=10..30]), mémoire des chapitres précédents
-- =========================================================================
local metano_town_ch_9_lore_expansion = {
  Kangaskhan = {
    early = "Oh, bonjour vous deux ![pause=15] La réserve des coffres est bien organisée aujourd'hui.[pause=20] J'ai entendu dire que les rumeurs sur le Marais de l'Oubli agitent toute la guilde.",
    pre   = "Vous partez en mission vers le Marais de l'Oubli ?[pause=15] Prenez des Résurgences ![pause=20] On ne sait jamais quelles surprises vous attendent là-bas.",
    during= "Soyez prudents au Marais de l'Oubli.[pause=15] Je garde vos trésors ici avec le plus grand soin.",
    post  = "Vous êtes de retour du Marais de l'Oubli ![pause=15] Venez me raconter vos exploits après avoir déposé vos sacs."
  },
  Kecleon1 = {
    early = "Bienvenue, explorateurs ![pause=15] Nos pommes sont fraîches et cueillies du matin.[pause=20] Un bon esprit d'exploration commence par un ventre plein !",
    pre   = "En route vers le Marais de l'Oubli ?[pause=15] J'ai des Orbes Météo et des Graines Lumise en promotion ![pause=20] N'hésitez pas à vous équiper !",
    during= "Le Marais de l'Oubli est exigeant.[pause=15] Seuls les explorateurs bien préparés en viennent à bout.",
    post  = "Quel retour triomphal ![pause=15] Vos exploits font parler tout le marché de Metano aujourd'hui !"
  },
  Kecleon2 = {
    early = "Des CT ! Des Orbes de toute rareté ![pause=15] Jetez un œil à notre étalage ![pause=20] Même la Team Dazzling s'est arrêtée ce matin, mais elles ont trouvé ça trop cher, hihi !",
    pre   = "Pour le Marais de l'Oubli, je vous conseille une CT Attaque à distance.[pause=15] Ça change la vie dans les couloirs étroits !",
    during= "J'espère que notre matériel vous sert bien dans les épreuves du Marais de l'Oubli...",
    post  = "Vous avez survécu au Marais de l'Oubli ![pause=15] Vous allez devenir des clients VIP à ce rythme !"
  },
  Duskull = {
    early = "Hihihi... La Banque Skelénox ne dort jamais.[pause=15] Vos Pokés sont à l'abri des fantômes...[pause=20] puisque je suis là pour les garder, hihi !",
    pre   = "Avant d'affronter le Marais de l'Oubli, déposez vos économies ![pause=15] Ce serait dommage de tout semer en chemin, hihi !",
    during= "Les coffres sont silencieux...[pause=15] L'or attend votre retour du Marais de l'Oubli.",
    post  = "Hihihi ! Votre compte en banque grandit à chaque expédition ![pause=15] Vous êtes de vrais pros !"
  },
  Ambipom = {
    early = "Aip-aip ! Bienvenue au Comptoir d'Échange ![pause=15] Vous avez des objets en double ?[pause=20] Faisons affaire !",
    pre   = "Un objet spécial pour votre quête au Marais de l'Oubli ?[pause=15] J'ai exactement ce qu'il vous faut dans mes tiroirs !",
    during= "Le Marais de l'Oubli... Aip ! J'aimerais y aller rien que pour collectionner des curiosités !",
    post  = "Quel trésor avez-vous rapporté du Marais de l'Oubli ?[pause=15] Montrez-moi vos trouvailles !"
  },
  Spinda = {
    early = "Tournicoti... Tournicoton...[pause=15] Le Café Spinda est le cœur battant de la convivialité ![pause=20] Prenez une boisson pour vous requinquer !",
    pre   = "Un smoothie spécial avant le Marais de l'Oubli ?[pause=15] Ça donne du courage et ça clarifie l'esprit !",
    during= "Je touille... je touille...[pause=15] En espérant que vous reveniez vite boire un thé !",
    post  = "Tournicoti ! Toute la clientèle parle de vos aventures au Marais de l'Oubli ![pause=15] Tournée générale !"
  },
  Wynaut = {
    early = "Oki-oki ![pause=15] Bienvenue au Guichet de Recyclage ![pause=20] Ne jetez rien, tout sert !",
    pre   = "Oki ! Prêts pour le Marais de l'Oubli ?[pause=15] Recyclez vos vieilles graines avant de partir !",
    during= "Oki-oki... On attend les explorateurs pour faire de jolis lots !",
    post  = "Oki !!! Vous avez réussi au Marais de l'Oubli ![pause=15] C'est la fête du recyclage !"
  },
  Wobbuffet = {
    early = "Qulbuuuu !!![pause=15] (Il acquiesce avec conviction en montrant le panneau de recyclage.)",
    pre   = "Qulbuuuu !!![pause=15] (Il fait un salut militaire pour vous encourager avant le Marais de l'Oubli.)",
    during= "Qulbuuu...[pause=15] (Il regarde le ciel avec patience en attendant votre retour.)",
    post  = "QULBUUUU !!![pause=20] (Il saute de joie en vous voyant revenir victorieux !)"
  },
  Marowak = {
    early = "Le Dojô Ossatueur est ouvert ![pause=15] L'entraînement est la seule clé de la survie en donjon.[pause=20] Pas de raccourci !",
    pre   = "Le Marais de l'Oubli ne pardonne pas le manque de discipline.[pause=15] Avez-vous révisé vos synergies de capacités ?",
    during= "La discipline se forge dans l'épreuve du Marais de l'Oubli...[pause=15] Gardez votre garde haute.",
    post  = "Je vois dans vos yeux que le Marais de l'Oubli vous a rendus plus forts.[pause=15] Beau travail d'équipe."
  },
  Xatu = {
    early = "Le vent du nord apporte des échos anciens...[pause=15] Les destins se croisent en silence sur la place de Metano.",
    pre   = "Le Marais de l'Oubli abrite des secrets gravés dans la roche.[pause=15] Oubliez la peur, suivez votre lumière intérieure.",
    during= "Mon regard se porte au-delà de l'horizon...[pause=15] Je veille sur votre progression au Marais de l'Oubli.",
    post  = "Les vérités se dévoilent peu à peu...[pause=15] Votre épreuve au Marais de l'Oubli n'est qu'une marche vers le sommet."
  }
}

-- Fonction d'expansion appelée lors des interactions PNJ
function metano_town_ch_9.GetExpandedDialogue(npc_name, state)
  local data = metano_town_ch_9_lore_expansion[npc_name]
  if not data then return nil end
  return data[state] or data.early
end

-- =========================================================================

return metano_town_ch_9
