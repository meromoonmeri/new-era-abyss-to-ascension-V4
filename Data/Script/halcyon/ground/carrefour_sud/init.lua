--[[ Carrefour Sud — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local carrefour_sud = {}

function carrefour_sud.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_carrefour_sud")
  COMMON.RespawnAllies()
end

function carrefour_sud.Enter(map)
  GAME:FadeIn(20)
end

function carrefour_sud.Update(map, time)
end

return carrefour_sud
