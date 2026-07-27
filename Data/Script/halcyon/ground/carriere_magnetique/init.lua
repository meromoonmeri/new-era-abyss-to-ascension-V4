--[[ Carrière Magnétique — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Magearna ch24 (alt.) / Melmetal
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local carriere_magnetique = {}

function carriere_magnetique.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_carriere_magnetique")
  COMMON.RespawnAllies()
end

function carriere_magnetique.Enter(map)
  GAME:FadeIn(20)
end

function carriere_magnetique.Update(map, time)
end

return carriere_magnetique
