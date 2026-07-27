--[[ Lac du Courage — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch13 Créfadet - cinématique Sentier du Courage
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local lac_courage = {}

function lac_courage.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_lac_courage")
  COMMON.RespawnAllies()
end

function lac_courage.Enter(map)
  GAME:FadeIn(20)
end

function lac_courage.Update(map, time)
end

return lac_courage
