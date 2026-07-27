--[[ Chambre des Âges II — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : réserve reliques
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local chambre_agee_o = {}

function chambre_agee_o.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_chambre_agee_o")
  COMMON.RespawnAllies()
end

function chambre_agee_o.Enter(map)
  GAME:FadeIn(20)
end

function chambre_agee_o.Update(map, time)
end

return chambre_agee_o
