--[[ Grotte Cryptique — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Giratina ch29 (Labyrinthe des Perdus)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local grotte_cryptique = {}

function grotte_cryptique.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_grotte_cryptique")
  COMMON.RespawnAllies()
end

function grotte_cryptique.Enter(map)
  GAME:FadeIn(20)
end

function grotte_cryptique.Update(map, time)
end

return grotte_cryptique
