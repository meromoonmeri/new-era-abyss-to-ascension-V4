--[[
    init.lua — Treasure Town / Bourg-Trésor

    Le bourg d'Explorateurs du Ciel, relié au continent par la mer. On n'y
    accède jamais par un menu de voyage : la traversée se fait sur le dos
    de Nessie, la Lokhlass passeuse, depuis la berge d'altere_pond — et le
    retour se fait de la même façon.

    Origine de la carte
    -------------------
    Reprise d'ExplorersOfSkyOrigins (Minemaker0430), remake d'EoS sous
    PMDO, qui cible la même GameVersion 0.8.12 que New Era. Cette version
    est nettement plus complète que celle de PMDO-Explorers-Maps utilisée
    au premier import : 18 PNJ canoniques déjà placés à leur poste réel,
    contre un décor nu de six totems. Crédité dans CREDITS.md.

    Conservé de l'import précédent : Nessie et les deux marqueurs
    d'arrivée. Tout le reste vient d'EOSO.

    Personnages hors champ
    ----------------------
    Plusieurs PNJ sont posés en (0,0) ou en coordonnées négatives. Ce
    n'est pas un défaut de placement : c'est le patron d'EOSO pour un
    acteur de cinématique, caché par GROUND:Hide puis téléporté à sa
    marque au moment voulu. On ne les déplace pas.
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
  --Les figurants de cinématique restent invisibles tant qu'aucune scène
  --ne les convoque. Sans cela ils apparaîtraient empilés au coin
  --supérieur gauche de la carte.
  for _, nom in ipairs({'Seedot', 'Corphish', 'Swellow', 'Wurmple',
                        'Marill', 'Azurill', 'Bidoof', 'Drowzee'}) do
    pcall(function() GROUND:Hide(nom) end)
  end
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
-- Outil de dialogue
-------------------------------
-- StartConversation tourne déjà le PNJ vers le héros (npcTurn = true par
-- défaut, GeneralFunctions.lua:1746) : pas de CharTurnToChar ici.
local function Parle(chara, cle, emo)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara,
    STRINGS:Format(STRINGS.MapStrings[cle]), emo or "Normal")
  GeneralFunctions.EndConversation(chara)
end

-------------------------------
-- Le passeur — retour vers le continent
-------------------------------
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
    GAME:EnterGroundMap("altere_pond", "Main_Entrance_Marker")
  end
end

-------------------------------
-- Commerçants et habitants
-------------------------------
-- Chacun commente le bourg, la mer ou les explorateurs de passage.
-- Aucun n'est un panneau muet.

function treasure_town.Kangaskhan_Action(chara, activator)
  Parle(chara, 'TT_Kangaskhan_001', "Happy")
end

function treasure_town.Kecleon_Action(chara, activator)
  Parle(chara, 'TT_Kecleon_001', "Happy")
end

function treasure_town.PurpleKecleon_Action(chara, activator)
  Parle(chara, 'TT_KecleonP_001', "Normal")
end

function treasure_town.Duskull_Action(chara, activator)
  Parle(chara, 'TT_Duskull_001', "Normal")
end

function treasure_town.Electivire_Action(chara, activator)
  Parle(chara, 'TT_Electivire_001', "Normal")
end

function treasure_town.Xatu_Action(chara, activator)
  Parle(chara, 'TT_Xatu_001', "Normal")
end

function treasure_town.Vigoroth_Action(chara, activator)
  Parle(chara, 'TT_Vigoroth_001', "Determined")
end

function treasure_town.Shuppet_Action(chara, activator)
  Parle(chara, 'TT_Shuppet_001', "Normal")
end

function treasure_town.Murkrow_Action(chara, activator)
  Parle(chara, 'TT_Murkrow_001', "Normal")
end

function treasure_town.Pidgey_Action(chara, activator)
  Parle(chara, 'TT_Pidgey_001', "Happy")
end

-- Figurants de cinématique : cachés par défaut. Si une scène les révèle,
-- ils ont malgré tout une réplique — aucune entité présente ne doit
-- rester sans traitement.
function treasure_town.Seedot_Action(chara, activator)
  Parle(chara, 'TT_Figurant_001', "Normal")
end
function treasure_town.Corphish_Action(chara, activator)
  Parle(chara, 'TT_Corphish_001', "Happy")
end
function treasure_town.Swellow_Action(chara, activator)
  Parle(chara, 'TT_Figurant_001', "Normal")
end
function treasure_town.Wurmple_Action(chara, activator)
  Parle(chara, 'TT_Figurant_001', "Normal")
end
function treasure_town.Marill_Action(chara, activator)
  Parle(chara, 'TT_Marill_001', "Happy")
end
function treasure_town.Azurill_Action(chara, activator)
  Parle(chara, 'TT_Azurill_001', "Happy")
end
function treasure_town.Bidoof_Action(chara, activator)
  Parle(chara, 'TT_Bidoof_001', "Happy")
end
function treasure_town.Drowzee_Action(chara, activator)
  Parle(chara, 'TT_Figurant_001', "Normal")
end

-------------------------------
-- Enseignes et mobilier
-------------------------------
local function Panneau(cle)
  UI:ResetSpeaker()
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[cle]))
end

function treasure_town.SignKecleonShop_Action(obj, activator)
  DEBUG.EnableDbgCoro(); Panneau('TT_Sign_Kecleon')
end
function treasure_town.SignKangaskhan_Action(obj, activator)
  DEBUG.EnableDbgCoro(); Panneau('TT_Sign_Kangaskhan')
end
function treasure_town.SignElectivire_Action(obj, activator)
  DEBUG.EnableDbgCoro(); Panneau('TT_Sign_Electivire')
end
function treasure_town.SignCrossRoads_Action(obj, activator)
  DEBUG.EnableDbgCoro(); Panneau('TT_Sign_CrossRoads')
end
function treasure_town.Shop_Action(obj, activator)
  DEBUG.EnableDbgCoro(); Panneau('TT_Sign_Kecleon')
end
function treasure_town.TM_Action(obj, activator)
  DEBUG.EnableDbgCoro(); Panneau('TT_Sign_Electivire')
end

-------------------------------
-- Sorties vers le reste du hub
-------------------------------
-- Les trois liaisons sont celles de la carte d'origine : le carrefour au
-- nord-est, le dojo au sud-est, la falaise Sharpedo à l'ouest.
local function Sortir(carte, marqueur)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  SOUND:FadeOutBGM(40)
  GAME:FadeOut(false, 40)
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
  SV.partner.Spawn = "Default"
  GAME:EnterGroundMap(carte, marqueur)
end

function treasure_town.CrossRoadsAssemblyEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  Sortir("tt_crossroads_assembly", "Main_Entrance_Marker")
end

function treasure_town.MarowakDojoEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  Sortir("tt_marowak_dojo", "Main_Entrance_Marker")
end

function treasure_town.HabitatSharpedoBluffDayEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  Sortir("tt_sharpedo_bluff", "Main_Entrance_Marker")
end

-- Marqueur d'une scène du chapitre 3 d'EoS, sans équivalent dans New Era.
-- Laissé inerte plutôt que supprimé : il ne coûte rien et servira si une
-- scène de bourg est écrite plus tard à cet endroit.
function treasure_town.CH3AzrullSceneMarker_Touch(obj, activator) end

function treasure_town.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return treasure_town
