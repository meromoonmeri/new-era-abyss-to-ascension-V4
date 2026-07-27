--[[ Orée de la Forêt Tendre — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local foret_tendre_oree = {}

function foret_tendre_oree.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_foret_tendre_oree")
  COMMON.RespawnAllies()
end

function foret_tendre_oree.Enter(map)
  GAME:FadeIn(20)
end

function foret_tendre_oree.Update(map, time)
end

return foret_tendre_oree
