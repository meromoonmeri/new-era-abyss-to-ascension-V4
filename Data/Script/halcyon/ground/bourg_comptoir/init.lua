--[[ Bourg du Comptoir — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE ville 2 (expansion ch11+)
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local bourg_comptoir = {}

function bourg_comptoir.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_bourg_comptoir")
  COMMON.RespawnAllies()
end

function bourg_comptoir.Enter(map)
  GAME:FadeIn(20)
end

function bourg_comptoir.Update(map, time)
end

return bourg_comptoir
