--[[ Fosse Volcanique — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Volcanion ch23 (Forge de Vapeur)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local fosse_volcanique = {}

function fosse_volcanique.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_fosse_volcanique")
  COMMON.RespawnAllies()
end

function fosse_volcanique.Enter(map)
  GAME:FadeIn(20)
end

function fosse_volcanique.Update(map, time)
end

return fosse_volcanique
