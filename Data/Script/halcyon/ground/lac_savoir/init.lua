--[[ Lac du Savoir — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch13 Créhelf - cinématique Sentier du Savoir
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local lac_savoir = {}

function lac_savoir.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_lac_savoir")
  COMMON.RespawnAllies()
end

function lac_savoir.Enter(map)
  GAME:FadeIn(20)
end

function lac_savoir.Update(map, time)
end

return lac_savoir
