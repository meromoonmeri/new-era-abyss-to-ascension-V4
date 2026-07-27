--[[ Escalier de l'Origine — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch32 Arceus - approche Tour de l'Origine
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local escalier_origine = {}

function escalier_origine.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_escalier_origine")
  COMMON.RespawnAllies()
end

function escalier_origine.Enter(map)
  GAME:FadeIn(20)
end

function escalier_origine.Update(map, time)
end

return escalier_origine
