--[[ Vigie du Stratos — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Rayquaza ch27 (alt.) / Escouade Fulgur ch10
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local vigie_stratos = {}

function vigie_stratos.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_vigie_stratos")
  COMMON.RespawnAllies()
end

function vigie_stratos.Enter(map)
  GAME:FadeIn(20)
end

function vigie_stratos.Update(map, time)
end

return vigie_stratos
