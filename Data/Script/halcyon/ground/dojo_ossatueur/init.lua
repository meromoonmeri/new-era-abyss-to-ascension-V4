--[[ Dojo de l'Ossatueur — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE extension dojo Ledian
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local dojo_ossatueur = {}

function dojo_ossatueur.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_dojo_ossatueur")
  COMMON.RespawnAllies()
end

function dojo_ossatueur.Enter(map)
  GAME:FadeIn(20)
end

function dojo_ossatueur.Update(map, time)
end

return dojo_ossatueur
