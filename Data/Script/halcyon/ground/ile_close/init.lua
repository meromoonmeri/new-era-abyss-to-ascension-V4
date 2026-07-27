--[[ Île Close — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Necrozma ch32 (Sentier Éteint) - cinématique
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local ile_close = {}

function ile_close.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_ile_close")
  COMMON.RespawnAllies()
end

function ile_close.Enter(map)
  GAME:FadeIn(20)
end

function ile_close.Update(map, time)
end

return ile_close
