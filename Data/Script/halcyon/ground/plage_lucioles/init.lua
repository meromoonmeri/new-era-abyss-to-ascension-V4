--[[ Plage des Lucioles — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE cinématique majeure (écho On the Beach at Dusk)
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local plage_lucioles = {}

function plage_lucioles.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_plage_lucioles")
  COMMON.RespawnAllies()
end

function plage_lucioles.Enter(map)
  GAME:FadeIn(20)
end

function plage_lucioles.Update(map, time)
end

return plage_lucioles
