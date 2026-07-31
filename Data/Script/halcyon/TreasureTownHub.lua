--[[
    TreasureTownHub.lua

    Cablage du bourg d'Explorateurs du Ciel : qui mene ou.

    Pourquoi un module commun
    -------------------------
    Le hub compte 20 cartes reliees entre elles. Ecrire 20 init.lua qui
    repetent chacun la meme sequence de sortie (fondu, reset du partenaire,
    EnterGroundMap) serait 20 occasions de diverger. On centralise ici la
    topologie et la mecanique de passage ; chaque init.lua se contente
    d'appeler TreasureTownHub.Sortie(...).

    Topologie relevee sur les cartes elles-memes
    --------------------------------------------
    Les noms d'objets de sortie viennent d'ExplorersOfSkyOrigins et
    disent explicitement leur destination : CrossRoadsAssemblyEntrance,
    GuildOutsideEntrance, BeachEntrance... On ne devine rien, on branche
    ce que la carte declare deja.

        treasure_town ──┬─ tt_crossroads_assembly ──┬─ guilde_parvis
                        │                            ├─ tt_crossroads_south ─ tt_beach
                        │                            └─ (donjon)
                        ├─ tt_marowak_dojo ─ tt_marowak_dojo_maze
                        ├─ tt_sharpedo_bluff
                        └─ altere_pond   (par Nessie, la traversee)

        guilde_parvis ─ tt_guild_entrance ─ tt_guild_jobboards ──┬─ tt_guild_dining
                                                                  ├─ tt_guild_bedroom
                                                                  ├─ tt_guild_master
                                                                  └─ guilde_sous_sol

    Jour et nuit
    ------------
    Cinq cartes ont une variante nocturne (parvis, sous-sol, chambre,
    refectoire, quartiers du maitre). `Variante` choisit la bonne selon
    SV.TemporaryFlags.Bedtime, le meme drapeau qui pilote deja la bascule
    jour/nuit de Metano. Une carte sans variante renvoie son nom tel quel.
]]--

require 'origin.common'

TreasureTownHub = {}

--Cartes qui possedent une version nocturne.
local NUIT = {
  guilde_parvis        = 'guilde_parvis_nuit',
  guilde_sous_sol      = 'guilde_sous_sol_nuit',
  tt_guild_bedroom     = 'tt_guild_bedroom_nuit',
  tt_guild_dining      = 'tt_guild_dining_nuit',
  tt_guild_master      = 'tt_guild_master_nuit',
  tt_beach             = 'tt_beach_dusk',
}

--Renvoie la carte a charger pour l'heure courante.
function TreasureTownHub.Variante(carte)
  local nuit = false
  pcall(function()
    nuit = SV.TemporaryFlags ~= nil and SV.TemporaryFlags.Bedtime == true
  end)
  if nuit and NUIT[carte] ~= nil then return NUIT[carte] end
  return carte
end

--Passage d'une carte du hub a une autre.
--On rend la main au partenaire AVANT le fondu : sans cela il reste fige
--dans son animation d'interaction sur la carte d'arrivee.
function TreasureTownHub.Sortie(carte, marqueur)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  if partner ~= nil then
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
  end
  if hero ~= nil then GROUND:CharEndAnim(hero) end

  SOUND:FadeOutBGM(40)
  GAME:FadeOut(false, 40)
  SV.partner.Spawn = "Default"
  GAME:EnterGroundMap(TreasureTownHub.Variante(carte),
                      marqueur or "Main_Entrance_Marker")
end

--Callbacks de carte partages. Toutes les cartes du hub ont le meme
--comportement d'entree/sortie ; seule la musique change.
function TreasureTownHub.Init(map)
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()
end

function TreasureTownHub.Enter(map, musique)
  if musique ~= nil then SOUND:PlayBGM(musique, true) end
  GAME:FadeIn(20)
end

function TreasureTownHub.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function TreasureTownHub.GameLoad(map, musique)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  if musique ~= nil then SOUND:PlayBGM(musique, true) end
  GAME:FadeIn(20)
end

--Dialogue court d'un PNJ ou d'un panneau.
--StartConversation oriente deja le PNJ vers le heros (npcTurn par
--defaut, GeneralFunctions.lua:1746) : pas de CharTurnToChar en plus.
function TreasureTownHub.Parle(chara, cle, emo)
  GeneralFunctions.StartConversation(chara,
    STRINGS:Format(STRINGS.MapStrings[cle]), emo or "Normal")
  GeneralFunctions.EndConversation(chara)
end

function TreasureTownHub.Panneau(cle)
  UI:ResetSpeaker()
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[cle]))
end

return TreasureTownHub
