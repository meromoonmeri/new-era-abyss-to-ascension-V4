--[[ Champ Sacré — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Shaymin ch15 (Jardin de la Gratitude)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local champ_sacre = {}

function champ_sacre.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_champ_sacre")
  COMMON.RespawnAllies()
end

function champ_sacre.Enter(map)
  GAME:FadeIn(20)
end

function champ_sacre.Update(map, time)
end

return champ_sacre
