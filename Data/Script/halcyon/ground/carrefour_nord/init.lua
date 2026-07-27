--[[ Carrefour Nord — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE carrefour monde
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local carrefour_nord = {}

function carrefour_nord.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_carrefour_nord")
  COMMON.RespawnAllies()
end

function carrefour_nord.Enter(map)
  GAME:FadeIn(20)
end

function carrefour_nord.Update(map, time)
end

return carrefour_nord
