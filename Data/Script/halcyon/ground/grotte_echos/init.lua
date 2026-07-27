--[[ Grotte des Échos — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Meloetta ch20 (alt. acoustique)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local grotte_echos = {}

function grotte_echos.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_grotte_echos")
  COMMON.RespawnAllies()
end

function grotte_echos.Enter(map)
  GAME:FadeIn(20)
end

function grotte_echos.Update(map, time)
end

return grotte_echos
