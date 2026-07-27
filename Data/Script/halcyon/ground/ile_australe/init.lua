--[[ Île Australe — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Lunala ch31 (Chapelle de la Nuit) - cinématique
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local ile_australe = {}

function ile_australe.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_ile_australe")
  COMMON.RespawnAllies()
end

function ile_australe.Enter(map)
  GAME:FadeIn(20)
end

function ile_australe.Update(map, time)
end

return ile_australe
