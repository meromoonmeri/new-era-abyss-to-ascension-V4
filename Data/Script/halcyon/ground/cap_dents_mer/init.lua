--[[ Cap des Dents de Mer — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE repaire côtier
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local cap_dents_mer = {}

function cap_dents_mer.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_cap_dents_mer")
  COMMON.RespawnAllies()
end

function cap_dents_mer.Enter(map)
  GAME:FadeIn(20)
end

function cap_dents_mer.Update(map, time)
end

return cap_dents_mer
