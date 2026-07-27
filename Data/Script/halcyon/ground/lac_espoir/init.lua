--[[ Lac de l'Espoir — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch13 Créfollet - cinématique Sentier de l'Espoir
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local lac_espoir = {}

function lac_espoir.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_lac_espoir")
  COMMON.RespawnAllies()
end

function lac_espoir.Enter(map)
  GAME:FadeIn(20)
end

function lac_espoir.Update(map, time)
end

return lac_espoir
