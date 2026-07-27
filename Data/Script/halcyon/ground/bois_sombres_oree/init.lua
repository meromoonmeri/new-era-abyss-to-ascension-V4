--[[ Orée des Bois Sombres — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local bois_sombres_oree = {}

function bois_sombres_oree.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_bois_sombres_oree")
  COMMON.RespawnAllies()
end

function bois_sombres_oree.Enter(map)
  GAME:FadeIn(20)
end

function bois_sombres_oree.Update(map, time)
end

return bois_sombres_oree
