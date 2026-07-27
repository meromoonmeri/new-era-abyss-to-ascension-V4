--[[ Plaines Brûlées — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Entei ch22 (alt. cinématique)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local plaines_brulees = {}

function plaines_brulees.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_plaines_brulees")
  COMMON.RespawnAllies()
end

function plaines_brulees.Enter(map)
  GAME:FadeIn(20)
end

function plaines_brulees.Update(map, time)
end

return plaines_brulees
