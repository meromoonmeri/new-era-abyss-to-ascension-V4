--[[ Plage du Crépuscule — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE cinématique
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local plage_crepuscule = {}

function plage_crepuscule.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_plage_crepuscule")
  COMMON.RespawnAllies()
end

function plage_crepuscule.Enter(map)
  GAME:FadeIn(20)
end

function plage_crepuscule.Update(map, time)
end

return plage_crepuscule
