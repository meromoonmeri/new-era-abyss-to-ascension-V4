--[[
    metano_town_ch_7.lua
    Chapitre 7 : Dialogues PNJ — post-expedition, Ruines Tordues, Genese, Reve Necrozma
    ~50 fonctions, 6 paliers Ch7State(), 37 cles MT7_077-113 + cles nommees
    Densite alignee sur Ch6 (815 lignes, 51 fonctions)
]]

require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.TownVoicesLate'

metano_town_ch_7 = {}

-- ============================================================
-- Helper : 6 paliers de progression Chapitre 7
-- ============================================================
local function Ch7State()
    if SV.Chapter7.HadFirstDream then return "post_dream"
    elseif SV.Chapter7.HeardGenesisTale then return "post_genesis"
    elseif SV.Chapter7.DefeatedRuinsBoss then return "post_boss"
    elseif SV.Chapter7.EnteredRuins then return "during"
    elseif SV.Chapter7.RuinsAddressGiven then return "pre"
    else return "early"
    end
end

-- ============================================================
-- PNJ PRINCIPAUX — Guilde (enrichis)
-- ============================================================

-- Phileas (Noctowl) : raconte la Genese si le joueur a vu le Coeur corrompu
function metano_town_ch_7.Noctowl_Action(chara, activator)
    if SV.Chapter7.SawAnimaCoreCorruption and not SV.Chapter7.HeardGenesisTale then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_001']))
        GeneralFunctions.SetEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_002']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_003']))
        GeneralFunctions.EndConversation(chara)
        GAME:EnterGroundMap('genesis_vision', 'Main_Entrance_Marker')
    elseif SV.Chapter7.HeardGenesisTale and not SV.Chapter7.HadFirstDream then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_004']))
        GeneralFunctions.SetEmotion("Sad")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_005']))
        GeneralFunctions.EndConversation(chara)
    elseif SV.Chapter7.DefeatedRuinsBoss then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Noctowl_006']))
        GeneralFunctions.SetEmotion("Normal")
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
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Tropius_001']))
        GeneralFunctions.SetEmotion("Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Tropius_002']))
        GeneralFunctions.SetEmotion("Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Tropius_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Tropius_004']))
        GeneralFunctions.SetEmotion("Normal")
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
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_109']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_095']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Audino_001']))
        GeneralFunctions.SetEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Audino_002']))
        GeneralFunctions.SetEmotion("Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Audino_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Audino_004']))
        GeneralFunctions.SetEmotion("Worried")
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
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_111']), "Shock")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Snubbull_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_101']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_096']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Snubbull_001']))
        GeneralFunctions.SetEmotion("Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Snubbull_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Snubbull_003']))
        GeneralFunctions.SetEmotion("Normal")
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
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Zigzagoon_001']))
        GeneralFunctions.SetEmotion("Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Zigzagoon_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Zigzagoon_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- PNJ SECONDAIRES — Village (enrichis)
-- ============================================================

-- Relicanth (Erleuchtet) : sagesse ancienne sur les Coeurs
function metano_town_ch_7.Relicanth_Action(chara, activator)
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_106']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_003']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Relicanth_004']))
        GeneralFunctions.SetEmotion("Worried")
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
    local s = Ch7State()
    if s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_104']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Bisharp_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Bisharp_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Bisharp_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Bisharp_003']))
        GeneralFunctions.SetEmotion("Determined")
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
    local s = Ch7State()
    if s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_102']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Ledian_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Ledian_001']))
        GeneralFunctions.SetEmotion("Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Ledian_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Ledian_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- PNJ MINEURS — Enrichis avec les nouveaux paliers
-- ============================================================

-- Vileplume (Bogen) : fleuriste, s'inquiete pour ses plantes
function metano_town_ch_7.Vileplume_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Vileplume', 7) then return end
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_112']), "Worried")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_090']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Vileplume_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Vileplume_001']))
        GeneralFunctions.SetEmotion("Worried")
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
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Gulpin', 7) then return end
    local s = Ch7State()
    if s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_100']), "Surprised")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Gulpin_001']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_081']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Gulpin_002']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Lickitung (Urgil) : gourmet, interesse par le cafe
function metano_town_ch_7.Lickitung_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Lickitung', 7) then return end
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_113']), "Worried")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_101']), "Normal")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_096']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Lickitung_001']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Nidoqueen (Monna) : protege son foyer
function metano_town_ch_7.Nidoqueen_Action(chara, activator)
    local s = Ch7State()
    if s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_104']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Nidoqueen_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Nidoqueen_001']))
        GeneralFunctions.SetEmotion("Worried")
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
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_110']), "Worried")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Mawile_001']))
        GeneralFunctions.SetEmotion("Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Mawile_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_107']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
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
    local s = Ch7State()
    if s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_108']), "Determined")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_098']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_098']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Floatzel_001']))
        GeneralFunctions.SetEmotion("Worried")
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
    local s = Ch7State()
    if s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_103']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_108']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_093']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Quagsire_001']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Nidorina (Dottir) : jeune, admire l'equipe
function metano_town_ch_7.Nidorina_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Nidorina', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Nidorina_001']))
        GeneralFunctions.SetEmotion("Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Nidorina_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Nidorina_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Electrike (Trilec) : sensible aux energies
function metano_town_ch_7.Electrike_Action(chara, activator)
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_112']), "Shock")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_106']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Electrike_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_077']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Electrike_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Electrike_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Electrike_002']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- Machamp (Savran) : fier de la releve
function metano_town_ch_7.Machamp_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Machamp', 7) then return end
    local s = Ch7State()
    if s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_105']), "Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Machamp_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Machamp_001']))
        GeneralFunctions.SetEmotion("Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Machamp_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Machamp_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- Team Dazzling (enrichis)
-- ============================================================
function metano_town_ch_7.Adagio_Action(chara, activator)
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_111']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_099']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_104']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Adagio_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Adagio_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Adagio_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Adagio_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_7.Aria_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Aria_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Aria_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_109']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Aria_002']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Aria_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

function metano_town_ch_7.Sonata_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Sonata_001']))
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_Sonata_002']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_110']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_Sonata_003']))
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- NOUVEAUX PNJ — 30 fonctions additionnelles utilisant MT7_077-113
-- ============================================================

-- Butterfree (Papilusion) : reaction de la guilde
function metano_town_ch_7.Butterfree_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_094']), "Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_089']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_082']), "Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_085']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "L'expedition vous attend.[pause=15] Allez voir Phileas.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Venipede (Chenipent) : le petit sauve de la foret
function metano_town_ch_7.Venipede_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_091']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_113']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Vous allez encore sauver quelqu'un ?[pause=20] Vous etes mes heros !", "Happy")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Luxray
function metano_town_ch_7.Luxray_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Luxray', 7) then return end
    local s = Ch7State()
    if s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_101']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_106']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_099']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Je sens quelque chose.[pause=20] Une ombre.[pause=30] Restez sur vos gardes.", "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Manectric
function metano_town_ch_7.Manectric_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Manectric', 7) then return end
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_092']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_097']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_087']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Electrike est nerveux.[pause=25] Il sent toujours les choses avant moi.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Bellossom
function metano_town_ch_7.Bellossom_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Bellossom', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_090']), "Joyous")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_078']), "Sad")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "La saison est magnifique ![pause=10] Profitons-en tant que ca dure.", "Happy")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Gloom
function metano_town_ch_7.Gloom_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Gloom', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_089']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_078']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Je bave quand je suis stresse...[pause=30] Et la,[pause=10] je bave beaucoup.", "Sad")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Oddish
function metano_town_ch_7.Oddish_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Oddish', 7) then return end
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_091']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_081']), "Surprised")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "On raconte des choses bizarres sur les ruines.[pause=25] Ca fait peur.", "Worried")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Numel
function metano_town_ch_7.Numel_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_091']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_085']), "Angry")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Pourquoi c'est toujours les memes qui se battent ?[pause=20] C'est pas juste !", "Angry")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Camerupt
function metano_town_ch_7.Camerupt_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_097']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_098']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_087']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Numel est impatient.[pause=20] Il admire les equipes d'aventuriers.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Meditite
function metano_town_ch_7.Meditite_Action(chara, activator)
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_110']), "Worried")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_084']), "Shock")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "La meditation apaise l'esprit.[pause=25] Mais certains reves...[pause=30] resistent.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Medicham
function metano_town_ch_7.Medicham_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Medicham', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_099']), "Normal")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_080']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "L'entrainement est la cle.[pause=25] Surtout avant l'inconnu.", "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Furret
function metano_town_ch_7.Furret_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Furret', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_098']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_083']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "La ville est calme aujourd'hui.[pause=25] Un peu trop calme.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Linoone
function metano_town_ch_7.Linoone_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Linoone', 7) then return end
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_097']), "Normal")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_083']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "J'ai couru jusqu'aux ruines hier.[pause=20] Enfin,[pause=10] presque.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Sentret
function metano_town_ch_7.Sentret_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Sentret', 7) then return end
    local s = Ch7State()
    if s == "post_genesis" or s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_100']), "Surprised")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_102']))
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_091']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Je surveille les alentours ![pause=15] On ne sait jamais.", "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Wooper_Girl (Dun)
function metano_town_ch_7.Wooper_Girl_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Wooper_Girl', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_093']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_088'], CH('PLAYER'):GetDisplayName()), "Inspired")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Dee dit que vous etes les plus forts ![pause=15] Moi aussi je le pense !", "Happy")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Wooper_Boy (Dee)
function metano_town_ch_7.Wooper_Boy_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Wooper_Boy', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_089']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_077']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Je m'entraine tous les jours ![pause=15] Pour etre aussi fort que vous !", "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Nidoran_Male
function metano_town_ch_7.Nidoran_Male_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_091']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Ma soeur dit que vous etes ses heros.[pause=20] Moi aussi je le pense.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Nidoking
function metano_town_ch_7.Nidoking_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Nidoking', 7) then return end
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_092']), "Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT7_097']))
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Protegez les votres.[pause=25] C'est tout ce qui compte.", "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Azumarill (Loaf)
function metano_town_ch_7.Azumarill_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_098']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_086']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Ma tente est toujours ouverte ![pause=15] Pour les voyageurs.", "Happy")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Roselia
function metano_town_ch_7.Roselia_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Roselia', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_090']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_078']), "Sad")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Les roses sont fragiles.[pause=20] Comme la vie.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Spinda (cafe)
function metano_town_ch_7.Spinda_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Spinda', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_096']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_113']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Un jus de Baie Mepris pour vous donner du courage ?[pause=15] Il est offert !", "Happy")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Ludicolo
function metano_town_ch_7.Ludicolo_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Ludicolo', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_089']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "La musique guerit l'ame ![pause=15] Dansez avec moi ?[pause=20] ...Non ?", "Happy")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Jigglypuff
function metano_town_ch_7.Jigglypuff_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Jigglypuff', 7) then return end
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_113']), "Sad")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_084']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Une berceuse ?[pause=15] Pour vous aider a dormir ?[pause=25] ...Non ?", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Marill
function metano_town_ch_7.Marill_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Marill', 7) then return end
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_098']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_086']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "J'aimerais pouvoir vous aider.[pause=25] Mais je suis trop petit.", "Sad")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Spheal
function metano_town_ch_7.Spheal_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_097']), "Happy")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Roulez, roulez ![pause=15] Enfin,[pause=10] pas moi. Vous.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Bagon
function metano_town_ch_7.Bagon_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_091']), "Inspired")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Un jour, je volerai ![pause=15] Et je pourrai vous aider !", "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Doduo
function metano_town_ch_7.Doduo_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_099']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Courir, toujours courir.[pause=20] C'est comme ca qu'on avance.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Metapod
function metano_town_ch_7.Metapod_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Metapod', 7) then return end
    local s = Ch7State()
    if s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_077']), "Normal")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            "...[pause=30] (Metapod semble briller legerement.)", "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "...[pause=40] (Metapod vous fixe sans cligner.)", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Silcoon
function metano_town_ch_7.Silcoon_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Silcoon', 7) then return end
    local s = Ch7State()
    if s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_078']), "Sad")
        GeneralFunctions.EndConversation(chara)
    elseif s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_089']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Papilusion est ma voisine.[pause=20] Elle parle souvent de vous.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Mareep
function metano_town_ch_7.Mareep_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Mareep', 7) then return end
    local s = Ch7State()
    if s == "post_dream" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_110']), "Shock")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_084']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Ma laine fait des etincelles aujourd'hui.[pause=25] C'est bizarre.", "Normal")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Cranidos
function metano_town_ch_7.Cranidos_Action(chara, activator)
  --LA VILLE REAGIT A L'AVANCEMENT (TownVoicesLate). Quatre paliers
  --lus sur l'etat reel du chapitre. Rend la main aussitot si le PNJ
  --n'a pas de fiche : aucun dialogue existant n'est perdu.
  if TownVoicesLate.Talk('Cranidos', 7) then return end
    local s = Ch7State()
    if s == "post_boss" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_092']), "Normal")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "Je vais m'entrainer plus fort ![pause=15] Vous allez voir !", "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- Growlithe_Desk (accueil guilde)
function metano_town_ch_7.Growlithe_Desk_Action(chara, activator)
    local s = Ch7State()
    if s == "post_boss" or s == "post_genesis" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_094']), "Happy")
        GeneralFunctions.EndConversation(chara)
    elseif s == "pre" or s == "during" then
        GeneralFunctions.StartConversation(chara,
            STRINGS:Format(STRINGS.MapStrings['MT7_079']), "Worried")
        GeneralFunctions.EndConversation(chara)
    else
        GeneralFunctions.StartConversation(chara,
            "La guilde vous soutient.[pause=15] Toujours. N'oubliez jamais ca.", "Determined")
        GeneralFunctions.EndConversation(chara)
    end
end

-- ============================================================
-- SCENE : Grodoudou commente l'arrivee des Ruines dans son catalogue
-- ============================================================
function metano_town_ch_7.Legend_Merchant_Action(chara, activator)
    require 'halcyon.ground.metano_town.metano_town_legend'
    metano_town_legend.Legend_Merchant_Action(chara, activator)
end

-- ============================================================
-- SCENE : Arrivée et enquête de la légendaire Team Alakazam (Chapitre 7)
-- ============================================================
function metano_town_ch_7.AlakazamScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  -- Positionner l'équipe au sud de la place, face au nord
  GROUND:TeleportTo(hero, 540, 1040, Direction.UpRight)
  if partner ~= nil then GROUND:TeleportTo(partner, 500, 1040, Direction.UpRight) end
  GAME:MoveCamera(640, 980, 1, false)

  -- Spawner le Doyen (Tropius), Phileas (Noctowl) et la foule
  local tropius, noctowl, sentret, wooper = CharacterEssentials.MakeCharactersFromList({
    {'Tropius', 660, 930, Direction.Down},
    {'Noctowl', 610, 930, Direction.Down},
    {'Sentret', 580, 960, Direction.Right},
    {'Wooper_Boy', 700, 960, Direction.Left}
  })

  -- Spawner la légendaire Team Alakazam
  local alakazam, tyranitar, charizard = CharacterEssentials.MakeCharactersFromList({
    {'Alakazam', 640, 970, Direction.Down},
    {'Tyranitar', 600, 1000, Direction.Right},
    {'Charizard', 680, 1000, Direction.Left}
  })

  GROUND:CharSetAnim(alakazam, "Idle", true)
  GROUND:CharSetAnim(tyranitar, "Idle", true)
  GROUND:CharSetAnim(charizard, "Idle", true)

  -- L'écran s'éclaire sur le grand rassemblement de la place de Metano Town
  GAME:FadeIn(40)
  SOUND:PlayBGM('Mt. Travail.ogg', true)
  GAME:WaitFrames(40)

  -- Le duo avance vers la foule et s'arrête en retrait
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(hero, 570, 1010, false, 1)
    GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    if partner ~= nil then
      GROUND:MoveToPosition(partner, 530, 1010, false, 1)
      GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
    end
  end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(20)

  -- Dialogue d'introduction par Penticus
  UI:SetSpeaker(tropius)
  UI:WaitShowDialogue("...Voici l'état actuel de nos relevés, Doyen d'Alakazam.[pause=15] La fissure du nord s'accentue après chaque séisme.")
  GAME:WaitFrames(15)

  UI:SetSpeaker(alakazam)
  UI:WaitShowDialogue("Mmm...[pause=10] Je ressens les vibrations telluriques d'ici. L'énergie du noyau terrestre s'échappe par cette faille.")
  UI:WaitShowDialogue("Les flux d'énergie convergent tous vers les Ruines Fendues. Quelque chose là-bas cherche à s'éveiller.")
  GAME:WaitFrames(15)

  -- Tyranocif intervient
  UI:SetSpeaker(tyranitar)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue("S'il le faut, je briserai la roche de mes propres mains ![pause=15] Groudon n'a pas à faire trembler nos continents.")
  GAME:WaitFrames(15)

  -- Dracaufeu approuve
  UI:SetSpeaker(charizard)
  UI:WaitShowDialogue("Et je réduirai en cendres toute obstruction.[pause=15] L'équilibre volcanique du Tunnel Ardent doit être restauré.")
  GAME:WaitFrames(15)

  -- Penticus remercie
  UI:SetSpeaker(tropius)
  UI:WaitShowDialogue("Votre assistance est inestimable, ô légendaire Team Alakazam. Nous préparons un Grand Tournoi de la Fédération ici-même pour évaluer et entraîner nos équipes locales.")
  UI:WaitShowDialogue("Nous devons être prêts pour l'expédition ultime.")
  GAME:WaitFrames(15)

  -- Alakazam se tourne vers le héros et le partenaire
  GROUND:CharAnimateTurnTo(alakazam, Direction.DownLeft, 4)
  GAME:WaitFrames(10)
  
  UI:SetSpeaker(alakazam)
  UI:WaitShowDialogue("Vous...[pause=20] Je ressens une double aura en toi, jeune héros.[pause=15] Une harmonie singulière qui n'appartient pas à ce monde.")
  GAME:WaitFrames(15)

  UI:SetSpeaker(partner)
  pcall(function()
    GROUND:CharSetEmote(partner, "shock", 1)
    GROUND:CharTurnToCharAnimated(partner, hero, 4)
  end)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue("(Une double aura ?! Comment est-ce qu'il peut ressentir cela ?!)")
  GAME:WaitFrames(15)

  GROUND:CharTurnToCharAnimated(partner, alakazam, 4)
  UI:SetSpeaker(alakazam)
  UI:WaitShowDialogue("Restez forts.[pause=15] Le chemin qui s'ouvre devant vous sera semé d'embûches, mais votre volonté peut surmonter le désastre.")
  UI:WaitShowDialogue("Nous partons vers le nord pour sécuriser le périmètre avant le début du tournoi.[pause=20] Bonne chance, petits.")
  GAME:WaitFrames(20)

  -- Team Alakazam se met en marche et s'en va vers le nord
  local depart1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(alakazam, Direction.Up, 150, false, 1)
    pcall(function() GAME:GetCurrentGround():RemoveTempChar(alakazam) end)
  end)
  local depart2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:MoveInDirection(tyranitar, Direction.Up, 150, false, 1)
    pcall(function() GAME:GetCurrentGround():RemoveTempChar(tyranitar) end)
  end)
  local depart3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(14)
    GROUND:MoveInDirection(charizard, Direction.Up, 150, false, 1)
    pcall(function() GAME:GetCurrentGround():RemoveTempChar(charizard) end)
  end)
  local camera_final = TASK:BranchCoroutine(function()
    GAME:MoveCamera(640, 920, 130, false)
  end)
  TASK:JoinCoroutines({depart1, depart2, depart3, camera_final})
  GAME:WaitFrames(20)

  -- Nettoyage des PNJ temporaires
  pcall(function()
    GAME:GetCurrentGround():RemoveTempChar(tropius)
    GAME:GetCurrentGround():RemoveTempChar(noctowl)
    GAME:GetCurrentGround():RemoveTempChar(sentret)
    GAME:GetCurrentGround():RemoveTempChar(wooper)
  end)

  -- Dialogue final de l'équipe
  UI:SetSpeaker(partner)
  pcall(function()
    GROUND:CharTurnToCharAnimated(partner, hero, 4)
    GROUND:CharTurnToCharAnimated(hero, partner, 4)
  end)
  GeneralFunctions.SetEmotion("Inspired")
  UI:WaitShowDialogue("Ouah...[pause=10] C'était la légendaire Team Alakazam en personne ! Ils sont tellement imposants !")
  UI:WaitShowDialogue("Et ce Grand Tournoi...[pause=15] Nous devons nous entraîner dur pour être dignes de leur faire face. C'est notre moment, {0} !", hero:GetDisplayName())
  GAME:WaitFrames(20)

  -- Sauvegarder l'état
  SV.Chapter7.AlakazamScenePlayed = true
  
  -- Fin de la cinématique
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
  pcall(function()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)
  GAME:FadeIn(20)
end

return metano_town_ch_7
