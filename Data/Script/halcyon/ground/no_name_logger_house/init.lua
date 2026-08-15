require 'origin.common'
require 'halcyon.PartnerEssentials'
local State=require 'halcyon.no_name_village.VillageState';local M={}
function M.Init(map)DEBUG.EnableDbgCoro();local s=State.Ensure();State.Apply(s.Season,true);COMMON.RespawnAllies(true);PartnerEssentials.InitializePartnerSpawn()end
function M.Enter(map)GAME:FadeIn(20)end
function M.Update(map,time)end
function M.GameSave(map)if CH('Teammate1')then PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))end end
function M.GameLoad(map)if CH('Teammate1')then PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))end;local s=State.Ensure();State.Apply(s.Season,true)end
function M.Village_Exit_Touch(obj,activator)GAME:FadeOut(false,20);State.EnterSelected('Retour_Maison_Bucheron')end
return M
