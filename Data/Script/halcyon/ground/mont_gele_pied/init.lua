--[[ Pied du Mont Gelé — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local mont_gele_pied = {}

function mont_gele_pied.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mont_gele_pied")
  COMMON.RespawnAllies()
end

function mont_gele_pied.Enter(map)
  GAME:FadeIn(20)
end

function mont_gele_pied.Update(map, time)
end

return mont_gele_pied
