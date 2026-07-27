--[[ Arène du Trône de Magma — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch11 Groudon - cinématique Caldeira Endormie
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local arene_trone_magma = {}

function arene_trone_magma.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_arene_trone_magma")
  COMMON.RespawnAllies()
end

function arene_trone_magma.Enter(map)
  GAME:FadeIn(20)
end

function arene_trone_magma.Update(map, time)
end

return arene_trone_magma
