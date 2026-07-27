--[[ Pied du Mont Grondant — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local mont_grondant_pied = {}

function mont_grondant_pied.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mont_grondant_pied")
  COMMON.RespawnAllies()
end

function mont_grondant_pied.Enter(map)
  GAME:FadeIn(20)
end

function mont_grondant_pied.Update(map, time)
end

return mont_grondant_pied
