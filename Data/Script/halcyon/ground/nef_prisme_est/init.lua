--[[ Nef du Prisme — Est — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch30 Xerneas - cinématique Îles Prismatiques
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local nef_prisme_est = {}

function nef_prisme_est.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_nef_prisme_est")
  COMMON.RespawnAllies()
end

function nef_prisme_est.Enter(map)
  GAME:FadeIn(20)
end

function nef_prisme_est.Update(map, time)
end

return nef_prisme_est
