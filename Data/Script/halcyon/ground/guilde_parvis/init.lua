--[[ Parvis de la Guilde — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local guilde_parvis = {}

function guilde_parvis.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_guilde_parvis")
  COMMON.RespawnAllies()
end

function guilde_parvis.Enter(map)
  GAME:FadeIn(20)
end

function guilde_parvis.Update(map, time)
end

return guilde_parvis
