--[[ Colline Sans Lumière — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch32 Necrozma - approche
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local colline_sans_lumiere = {}

function colline_sans_lumiere.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_colline_sans_lumiere")
  COMMON.RespawnAllies()
end

function colline_sans_lumiere.Enter(map)
  GAME:FadeIn(20)
end

function colline_sans_lumiere.Update(map, time)
end

return colline_sans_lumiere
