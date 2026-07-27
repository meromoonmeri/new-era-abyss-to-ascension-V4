--[[ Porte des Plaines de Foudre — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch17 Électhor - entrée Mont Grondant
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local porte_plaines_foudre = {}

function porte_plaines_foudre.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_porte_plaines_foudre")
  COMMON.RespawnAllies()
end

function porte_plaines_foudre.Enter(map)
  GAME:FadeIn(20)
end

function porte_plaines_foudre.Update(map, time)
end

return porte_plaines_foudre
