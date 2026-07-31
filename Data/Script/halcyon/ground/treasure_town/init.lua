--[[
    init.lua — Treasure Town / Bourg-Trésor

    Le bourg d'Explorateurs du Ciel, relié à Metano par la mer. On n'y
    accède jamais par un menu de voyage : la traversée se fait sur le dos
    de Nessie, la Lokhlass passeuse, depuis la plage de Metano
    (metano_altere_transition) — et le retour se fait de la même façon,
    depuis la berge sud du bourg.

    Origine de la carte
    -------------------
    `Data/Ground/treasure_town.rsground` provient de PMDO-Explorers-Maps
    (slothplaysnecro), dépôt qui autorise explicitement la réutilisation
    (« Feel free to use these in your own projects »). Assets d'origine
    issus d'ExplorersOfSkyOrigins. Crédité dans CREDITS.md.

    La carte importée est un DÉCOR NU : elle ne contenait que six totems
    en GroundObjects, aucun personnage. Les neuf PNJ ci-dessous ont été
    placés à la main devant leur devanture réelle, puis vérifiés contre
    la grille d'obstacles (tools/audit_spatial.py : 0 entité murée, 0
    isolée, 0 hors carte).

    Les tenanciers gardent leur RÔLE canonique — marché, banque,
    entrepôt, dojo, échange — mais portent un nom propre, comme tous les
    PNJ du projet (convention de CharacterEssentials : Kecleon = Lars,
    Shuckle = Dion).
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

local treasure_town = {}

-------------------------------
-- Callbacks de carte
-------------------------------
function treasure_town.Init(map)
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()
end

function treasure_town.Enter(map)
  SOUND:PlayBGM('Treasure Town.ogg', true)
  GAME:FadeIn(20)
end

function treasure_town.Update(map) end

function treasure_town.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function treasure_town.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  SOUND:PlayBGM('Treasure Town.ogg', true)
  GAME:FadeIn(20)
end

-------------------------------
-- Le passeur — retour vers Metano
-------------------------------
-- Nessie fait la liaison dans les deux sens. Elle est le SEUL moyen de
-- quitter le bourg : pas de sortie de carte, pas de menu de voyage.
function treasure_town.Lapras_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)

  GeneralFunctions.StartConversation(chara,
    STRINGS:Format(STRINGS.MapStrings['TT_Lapras_001']), "Normal")
  GeneralFunctions.EndConversation(chara)

  UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['TT_Lapras_002']), true)
  UI:WaitForChoice()
  local partir = UI:ChoiceResult()

  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)

  if partir then
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    SV.partner.Spawn = "Default"
    --Retour a la plage de Metano. metano_altere_transition est la carte
    --de liaison cote continent : c'est de la qu'on est parti.
    GAME:EnterGroundMap("metano_altere_transition", "Main_Entrance_Marker")
  end
end

-------------------------------
-- Commerçants
-------------------------------
-- Chaque tenancier a une réplique d'accueil et une réplique de service.
-- Aucun n'est un simple panneau : ils commentent le bourg, la mer, les
-- explorateurs de passage.

local function SimpleTalk(chara, cle, emo)
  DEBUG.EnableDbgCoro()
  --StartConversation tourne deja le PNJ vers le heros (npcTurn = true
  --par defaut, GeneralFunctions.lua:1746) : pas de CharTurnToChar ici,
  --il ferait pivoter deux fois.
  GeneralFunctions.StartConversation(chara,
    STRINGS:Format(STRINGS.MapStrings[cle]), emo or "Normal")
  GeneralFunctions.EndConversation(chara)
end

--Le marché Kecleon. Les deux frères tiennent le même étal, l'un les
--objets courants, l'autre les objets rares.
function treasure_town.Kecleon_Action(chara, activator)
  SimpleTalk(chara, 'TT_Kecleon_001', "Happy")
end

function treasure_town.Kecleon_Purple_Action(chara, activator)
  SimpleTalk(chara, 'TT_KecleonP_001', "Normal")
end

--Carilla tient le lieu de rassemblement : elle sait qui est en ville.
function treasure_town.Chimecho_Action(chara, activator)
  SimpleTalk(chara, 'TT_Chimecho_001', "Happy")
end

--Osselin garde les dépôts. Il compte, il ne juge pas.
function treasure_town.Duskull_Action(chara, activator)
  SimpleTalk(chara, 'TT_Duskull_001', "Normal")
end

--Tibo entraîne. Il regarde les nouveaux venus comme des élèves.
function treasure_town.Marowak_Action(chara, activator)
  SimpleTalk(chara, 'TT_Marowak_001', "Determined")
end

--Vasco échange. Sourire commercial, œil qui évalue.
function treasure_town.Croagunk_Action(chara, activator)
  SimpleTalk(chara, 'TT_Croagunk_001', "Normal")
end

--Castorin, apprenti de la guilde locale. Franc, un peu lent.
function treasure_town.Bidoof_Action(chara, activator)
  SimpleTalk(chara, 'TT_Bidoof_001', "Happy")
end

--Grodou, le maître de guilde du bourg. Chaleureux, insondable.
function treasure_town.Wigglytuff_Action(chara, activator)
  SimpleTalk(chara, 'TT_Wigglytuff_001', "Happy")
end

function treasure_town.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return treasure_town
