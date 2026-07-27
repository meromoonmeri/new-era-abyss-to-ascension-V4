--[[ Carrefour de l'Assemblée — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local carrefour_assemblee = {}

function carrefour_assemblee.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_carrefour_assemblee")
  COMMON.RespawnAllies()
end

function carrefour_assemblee.Enter(map)
  GAME:FadeIn(20)
end

function carrefour_assemblee.Update(map, time)
end

return carrefour_assemblee
