require 'origin.common'
require 'halcyon.PartnerEssentials'
local Voices=require 'halcyon.no_name_village.PokemonVoices';local State=require 'halcyon.no_name_village.VillageState';local VillageMap={};local NPC={'Audino_Guide','Meganium_Herboriste','Bibarel_Charpentier','Decidueye_Chasseur','Komala_Bucheron','Leavanny_Couturiere','Torkoal_Forgeron'}
function VillageMap.Build(asset,season)local M={};local applied=nil
 function M.Init(map)DEBUG.EnableDbgCoro();local s=State.Ensure();s.Season=season;applied=s.TimeOfDay;State.Apply(season,false);COMMON.RespawnAllies(true);PartnerEssentials.InitializePartnerSpawn()end
 function M.Enter(map)local selected=State.SelectedSeason(season);if selected~=season then GAME:FadeOut(false,0);State.EnterSelected('Main_Entrance_Marker');return end;UI:ResetSpeaker();UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(),20);GAME:WaitFrames(30);UI:WaitHideTitle(20);GAME:FadeIn(30)end
 function M.Update(map,time)local s=State.Ensure();if applied~=s.TimeOfDay then applied=s.TimeOfDay;State.Apply(season,false)end end
 function M.GameSave(map)if CH('Teammate1')then PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))end end
 function M.GameLoad(map)if CH('Teammate1')then PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))end;State.Apply(season,false)end
 for _,name in ipairs(NPC)do M[name..'_Action']=function(chara,activator)DEBUG.EnableDbgCoro();Voices.Talk(chara,name)end end
 local function enter(map)return function(obj,activator)DEBUG.EnableDbgCoro();GAME:FadeOut(false,20);GAME:EnterGroundMap(map,'Main_Entrance_Marker')end end
 M.Maison_Joueur_Entree_Touch=enter('no_name_player_house');M.Maison_Bucheron_Entree_Touch=enter('no_name_logger_house');M.Maison_Chasseur_Entree_Touch=enter('no_name_hunter_house');M.Maison_Charpentier_Entree_Touch=enter('no_name_carpenter_house')
 local function border(obj,activator)DEBUG.EnableDbgCoro();UI:ResetSpeaker();UI:WaitShowDialogue("Le sentier continue au-delà des arbres.[pause=15] Sa destination source reste verrouillée tant que la room voisine n’est pas validée.")end
 M.Sortie_Nord_Touch=border;M.Sortie_Sud_Touch=border;M.Sortie_Ouest_Touch=border;M.Sortie_Est_Touch=border;return M end
return VillageMap
