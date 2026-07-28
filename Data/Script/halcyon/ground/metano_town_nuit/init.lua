--[[
    metano_town_nuit/init.lua
    BOURG METANO — NUIT

    ================================================================
    METHODE : celle d'EoSO, verifiee dans son depot
    ================================================================
    EoSO ne pose pas un filtre sombre sur la carte de jour : il a de
    VRAIES cartes separees. Verifie dans ExplorersOfSkyOrigins :

        guild_outside.rsground        -> tileset GuildOutside
        guild_outside_dusk.rsground   -> tileset GuildOutsideDusk
        guild_outside_night.rsground  -> GuildOutsideNight + ...NightGate

    Meme geometrie (480x408 pour les trois), AssetName distinct,
    tilesets differents. Et leurs scripts de nuit sont quasi VIDES :
    tout le travail est dans la carte.

    Ici : metano_town_nuit.rsground est un clone au pixel pres de
    metano_town (1512x1512, obstacles identiques verifies), dont les
    14 feuilles de tuiles pointent vers les versions _Night generees
    par tools/tile_night.py.

    ================================================================
    CE QUE CE SCRIPT FAIT, LUI
    ================================================================
    La carte apporte le decor. Le script apporte la VIE :

      * les 12 commercants de jour sont retires — ils sont rentres ;
      * les portes de commerce refusent l'entree avec une replique,
        jamais avec un mur invisible : on ne bloque pas le joueur
        sans le lui dire ;
      * les PNJ nocturnes apparaissent (module TownNight).

    Le joueur SE DEPLACE LIBREMENT. Preuve dans le projet :
    ledian_dojo/init.lua:35 pose GROUND:AddMapStatus("darkness") dans
    Init et le joueur y circule sans CutsceneMode.

    ================================================================
    REGLES DU PROJET
    ================================================================
    * Textes en francais, litteraux (patron des modules globaux).
    * Aucun nom interdit, la Voix ne parle pas en ville.
    * Tout sous pcall : une carte d'exploration ne doit jamais pouvoir
      pieger le joueur.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.TownNight'

local metano_town_nuit = {}

--Les 12 commercants presents sur la carte de jour, herites par le clone.
--La nuit, ils sont chez eux : on les retire de la carte.
local MARCHANDS = {
  'Shop_Owner', 'Bank_Owner', 'Storage_Owner', 'Musician', 'Swap_Owner',
  'Red_Merchant', 'Green_Merchant', 'Appraisal', 'Tutor_Owner',
  'Growlithe', 'TM_Owner', 'Legend_Merchant',
}

function metano_town_nuit.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo('=>> Init_metano_town_nuit <<=')
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()

  --La ville dort : personne derriere les comptoirs.
  for _, n in ipairs(MARCHANDS) do
    pcall(function() GROUND:Hide(n) end)
  end

  --Les habitants de la nuit prennent la place.
  pcall(function() TownNight.Populate() end)
end

function metano_town_nuit.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(30)
  pcall(function() TownNight.Arrival() end)
end

function metano_town_nuit.Exit(map) end
function metano_town_nuit.Update(map, time) end

function metano_town_nuit.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function metano_town_nuit.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

--------------------------------------------------------------------
-- COMMERCES FERMES
--------------------------------------------------------------------
-- On ne bloque jamais le joueur en silence : chaque porte close a sa
-- phrase. C'est aussi une occasion de dire quelque chose de la ville.
local function ferme(txt)
  pcall(function()
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:WaitShowDialogue(txt)
    UI:SetCenter(false)
    UI:ResetSpeaker()
  end)
end

function metano_town_nuit.Shop_Action(obj, activator)
  ferme("Le rideau est tire.[pause=20] Une pancarte : « De retour a l'aube. »")
end

function metano_town_nuit.Bank_Action(obj, activator)
  ferme("Le coffre est ferme pour la nuit.[pause=20] Vos economies dorment aussi.")
end

function metano_town_nuit.Storage_Action(obj, activator)
  ferme("L'entrepot est cadenasse.[pause=25] Quelqu'un a laisse une lanterne allumee au-dessus de la porte.")
end

function metano_town_nuit.Swap_Action(obj, activator)
  ferme("Ferme.[pause=20] Sur le comptoir, un objet oublie que personne n'est venu reclamer.")
end

function metano_town_nuit.TM_Action(obj, activator)
  ferme("Ferme.[pause=20] On entend ronfler a l'interieur.")
end

function metano_town_nuit.Tutor_Action(obj, activator)
  ferme("Le maitre dort.[pause=25] Meme les lecons ont besoin de repos.")
end

function metano_town_nuit.Appraisal_Action(obj, activator)
  ferme("Ferme.[pause=20] Les tresors attendront demain pour reveler leur nom.")
end

--Sortie de la nuit : on revient a la carte de jour, un jour plus tard.
function metano_town_nuit.Guild_Entrance_Touch(obj, activator)
  pcall(function() TownNight.GoHome() end)
end

--Dialogue du partenaire, qui a lui aussi ses phrases nocturnes.
function metano_town_nuit.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if TownNight.PartnerTalk() then return end
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

--Handlers des PNJ nocturnes : delegues au module.
function metano_town_nuit.Nuit_Garde_Action(chara, activator)
  TownNight.Talk('Nuit_Garde')
end

function metano_town_nuit.Nuit_Etoiles_Action(chara, activator)
  TownNight.Talk('Nuit_Etoiles')
end

function metano_town_nuit.Nuit_Insomniaque_Action(chara, activator)
  TownNight.Talk('Nuit_Insomniaque')
end

return metano_town_nuit
