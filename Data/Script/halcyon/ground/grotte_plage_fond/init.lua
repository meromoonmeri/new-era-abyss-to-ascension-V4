--[[ Fond de la Grotte de la Plage — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE côte
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local grotte_plage_fond = {}

function grotte_plage_fond.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_grotte_plage_fond")
  COMMON.RespawnAllies()
end

function grotte_plage_fond.Enter(map)
  GAME:FadeIn(20)
end

function grotte_plage_fond.Update(map, time)
end

return grotte_plage_fond
