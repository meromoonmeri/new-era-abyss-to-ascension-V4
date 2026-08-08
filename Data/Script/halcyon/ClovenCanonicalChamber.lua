require 'origin.common'
require 'halcyon.PartnerEssentials'
local C={}
function C.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies(true);PartnerEssentials.InitializePartnerSpawn() end
function C.Enter(map) GAME:CutsceneMode(false);GAME:FadeIn(20) end
function C.Exit(map) end
function C.Update(map,time) end
function C.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function C.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'));GAME:CutsceneMode(false);GAME:FadeIn(20) end
function C.Teammate1_Action(c,a) PartnerEssentials.GetPartnerDialogue(c) end
function C.Teammate2_Action(c,a) PartnerEssentials.GetPartnerDialogue(c) end
function C.Teammate3_Action(c,a) PartnerEssentials.GetPartnerDialogue(c) end
return C
