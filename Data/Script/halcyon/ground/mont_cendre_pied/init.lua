--[[ Pied du Mont Cendré — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local mont_cendre_pied = {}

function mont_cendre_pied.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mont_cendre_pied")
  COMMON.RespawnAllies()
end

function mont_cendre_pied.Enter(map)
  GAME:FadeIn(20)
end

function mont_cendre_pied.Update(map, time)
end

return mont_cendre_pied
