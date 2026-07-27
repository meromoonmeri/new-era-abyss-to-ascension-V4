--[[ Arène des Hautes Plaines — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch16 Raikou - cinématique Crête Voilée
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local arene_hautes_plaines = {}

function arene_hautes_plaines.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_arene_hautes_plaines")
  COMMON.RespawnAllies()
end

function arene_hautes_plaines.Enter(map)
  GAME:FadeIn(20)
end

function arene_hautes_plaines.Update(map, time)
end

return arene_hautes_plaines
