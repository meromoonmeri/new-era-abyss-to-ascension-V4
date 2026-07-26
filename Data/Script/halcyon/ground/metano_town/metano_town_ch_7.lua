--[[
    metano_town_ch_7.lua
    Chapitre 7 : Dialogues PNJ — post-expedition, Ruines Tordues, Genese
    Extension du pattern existant (ch_2..ch_6)
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_town_ch_7 = {}

-- ============================================================
-- PNJ PRINCIPAUX — Guilde
-- ============================================================

-- Phileas (Noctowl) : raconte la Genese si le joueur a vu le Coeur corrompu
function metano_town_ch_7.Noctowl_Action(chara, activator)
    if SV.Chapter7.SawAnimaCoreCorruption and not SV.Chapter7.HeardGenesisTale then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_001']))
        UI:SetSpeakerEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_002']))
        UI:SetSpeakerEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_003']))
        GeneralFunctions.EndConversation(chara)
        GAME:EnterGroundMap('genesis_vision', 'Main_Entrance_Marker')
    elseif SV.Chapter7.HeardGenesisTale then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_004']))
        UI:SetSpeakerEmotion("Sad")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_005']))
        GeneralFunctions.EndConversation(chara)
    elseif SV.Chapter7.DefeatedRuinsBoss then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_006']))
        UI:SetSpeakerEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_007']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_008']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Penticus (Tropius) : reaction a l'expedition terminee
function metano_town_ch_7.Tropius_Action(chara, activator)
    if SV.Chapter7.DefeatedRuinsBoss then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Tropius_001']))
        UI:SetSpeakerEmotion("Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Tropius_002']))
        UI:SetSpeakerEmotion("Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Tropius_003']))
        GeneralFunctions.EndConversation(chara)
    elseif SV.Chapter5.FinishedExpedition then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Tropius_004']))
        UI:SetSpeakerEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Tropius_005']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Tropius_006']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Rin (Audino) : s'inquiete pour l'equipe
function metano_town_ch_7.Audino_Action(chara, activator)
    if SV.Chapter7.DefeatedRuinsBoss then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Audino_001']))
        UI:SetSpeakerEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Audino_002']))
        UI:SetSpeakerEmotion("Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Audino_003']))
        GeneralFunctions.EndConversation(chara)
    elseif SV.Chapter7.LostRuins then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Audino_004']))
        UI:SetSpeakerEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Audino_005']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Audino_006']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Coco (Snubbull) : rumeurs sur les Ruines
function metano_town_ch_7.Snubbull_Action(chara, activator)
    if SV.Chapter7.SawAnimaCoreCorruption then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Snubbull_001']))
        UI:SetSpeakerEmotion("Shock")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Snubbull_002']))
        GeneralFunctions.EndConversation(chara)
    elseif SV.Chapter7.EnteredRuins then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Snubbull_003']))
        UI:SetSpeakerEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Snubbull_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Snubbull_005']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Almotz (Zigzagoon) : fier de l'equipe
function metano_town_ch_7.Zigzagoon_Action(chara, activator)
    if SV.Chapter7.DefeatedRuinsBoss then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Zigzagoon_001']))
        UI:SetSpeakerEmotion("Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Zigzagoon_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Zigzagoon_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- PNJ SECONDAIRES — Village
-- ============================================================

-- Relicanth (Erleuchtet) : sagesse ancienne sur les Coeurs
function metano_town_ch_7.Relicanth_Action(chara, activator)
    if SV.Chapter7.HeardGenesisTale then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_001']))
        UI:SetSpeakerEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_003']))
        GeneralFunctions.EndConversation(chara)
    elseif SV.Chapter7.SawAnimaCoreCorruption then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_004']))
        UI:SetSpeakerEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_005']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_006']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Zhayn (Bisharp) : le chef de la police s'interesse aux ruines
function metano_town_ch_7.Bisharp_Action(chara, activator)
    if SV.Chapter7.DefeatedRuinsBoss then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Bisharp_001']))
        UI:SetSpeakerEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Bisharp_002']))
        GeneralFunctions.EndConversation(chara)
    elseif SV.Chapter7.EnteredRuins then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Bisharp_003']))
        UI:SetSpeakerEmotion("Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Bisharp_004']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Bisharp_005']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Lotus (Ledian) : entrainement avance
function metano_town_ch_7.Ledian_Action(chara, activator)
    if SV.Chapter7.DefeatedRuinsBoss then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Ledian_001']))
        UI:SetSpeakerEmotion("Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Ledian_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Ledian_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- PNJ MINEURS — Enrichis (etaient mono-chapitre)
-- ============================================================

-- Vileplume (Bogen) : fleuriste, s'inquiete pour ses plantes
function metano_town_ch_7.Vileplume_Action(chara, activator)
    if SV.Chapter7.SawAnimaCoreCorruption then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Vileplume_001']))
        UI:SetSpeakerEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Vileplume_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Vileplume_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Gulpin (Boosmu) : toujours affame, commente les rumeurs
function metano_town_ch_7.Gulpin_Action(chara, activator)
    if SV.Chapter7.DefeatedRuinsBoss then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Gulpin_001']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Gulpin_002']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Lickitung (Urgil) : gourmet, interesse par le cafe
function metano_town_ch_7.Lickitung_Action(chara, activator)
    GeneralFunctions.StartConversation(chara,
        STRINGS:Format(STRINGS.MapStrings['MT7_Lickitung_001']))
    GeneralFunctions.EndConversation(chara)
end

-- Nidoqueen (Monna) : protege son foyer
function metano_town_ch_7.Nidoqueen_Action(chara, activator)
    if SV.Chapter7.EnteredRuins then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Nidoqueen_001']))
        UI:SetSpeakerEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Nidoqueen_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Nidoqueen_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Mawile (Bria) : commere du village
function metano_town_ch_7.Mawile_Action(chara, activator)
    if SV.Chapter7.HeardGenesisTale then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Mawile_001']))
        UI:SetSpeakerEmotion("Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Mawile_002']))
        GeneralFunctions.EndConversation(chara)
    elseif SV.Chapter7.DefeatedRuinsBoss then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Mawile_003']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Mawile_004']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Floatzel (Tweed) : pecheur, a vu des choses etranges
function metano_town_ch_7.Floatzel_Action(chara, activator)
    if SV.Chapter7.SawAnimaCoreCorruption then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Floatzel_001']))
        UI:SetSpeakerEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Floatzel_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Floatzel_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Quagsire (Maris) : calme, rassurante
function metano_town_ch_7.Quagsire_Action(chara, activator)
    GeneralFunctions.StartConversation(chara,
        STRINGS:Format(STRINGS.MapStrings['MT7_Quagsire_001']))
    GeneralFunctions.EndConversation(chara)
end

-- Nidorina (Dottir) : jeune, admire l'equipe
function metano_town_ch_7.Nidorina_Action(chara, activator)
    if SV.Chapter7.DefeatedRuinsBoss then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Nidorina_001']))
        UI:SetSpeakerEmotion("Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Nidorina_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Nidorina_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Electrike (Trilec) : admire les equipes d'expedition
function metano_town_ch_7.Electrike_Action(chara, activator)
    GeneralFunctions.StartConversation(chara,
        STRINGS:Format(STRINGS.MapStrings['MT7_Electrike_001']))
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Electrike_002']))
    GeneralFunctions.EndConversation(chara)
end

-- Machamp (Savran) : fier de la releve
function metano_town_ch_7.Machamp_Action(chara, activator)
    if SV.Chapter7.DefeatedRuinsBoss then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Machamp_001']))
        UI:SetSpeakerEmotion("Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Machamp_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Machamp_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- PNJ Team Dazzling (si reintroduits au chapitre 7)
function metano_town_ch_7.Adagio_Action(chara, activator)
    if SV.Chapter7.DefeatedRuinsBoss then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Adagio_001']))
        UI:SetSpeakerEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Adagio_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Adagio_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_7.Aria_Action(chara, activator)
    if SV.Chapter7.DefeatedRuinsBoss then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Aria_001']))
        UI:SetSpeakerEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Aria_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Aria_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_7.Sonata_Action(chara, activator)
    if SV.Chapter7.DefeatedRuinsBoss then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Sonata_001']))
        UI:SetSpeakerEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Sonata_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Sonata_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- SCENE : Grodoudou commente l'arrivee des Ruines dans son catalogue
-- ============================================================
function metano_town_ch_7.Legend_Merchant_Action(chara, activator)
    -- Default to the main legend merchant handler, augmented with Ch7 flavor
    -- Uses the existing metano_town_legend system
    require 'halcyon.ground.metano_town.metano_town_legend'
    metano_town_legend.Legend_Merchant_Action(chara, activator)
end

return metano_town_ch_7
