--[[ Pré du Tonnerre — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Zeraora ch25 (Piste Fulgurante)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local pre_tonnerre = {}

function pre_tonnerre.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_pre_tonnerre")
  COMMON.RespawnAllies()
end

function pre_tonnerre.Enter(map)
  GAME:FadeIn(20)
end

function pre_tonnerre.Update(map, time)
end

return pre_tonnerre
