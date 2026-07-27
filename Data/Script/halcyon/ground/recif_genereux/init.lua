--[[ Récif Généreux — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Manaphy/Phione ch16 (Berceau des Mers)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local recif_genereux = {}

function recif_genereux.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_recif_genereux")
  COMMON.RespawnAllies()
end

function recif_genereux.Enter(map)
  GAME:FadeIn(20)
end

function recif_genereux.Update(map, time)
end

return recif_genereux
