--[[ Île Légendaire — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Solgaleo ch31 (Le Conte Sans Fin)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local ile_legendaire = {}

function ile_legendaire.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_ile_legendaire")
  COMMON.RespawnAllies()
end

function ile_legendaire.Enter(map)
  GAME:FadeIn(20)
end

function ile_legendaire.Update(map, time)
end

return ile_legendaire
