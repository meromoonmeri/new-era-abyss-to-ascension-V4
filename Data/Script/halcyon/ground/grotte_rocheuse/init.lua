--[[ Grotte Rocheuse — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve grotte
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local grotte_rocheuse = {}

function grotte_rocheuse.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_grotte_rocheuse")
  COMMON.RespawnAllies()
end

function grotte_rocheuse.Enter(map)
  GAME:FadeIn(20)
end

function grotte_rocheuse.Update(map, time)
end

return grotte_rocheuse
