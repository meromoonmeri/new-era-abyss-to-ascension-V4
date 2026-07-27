--[[ Seuil de la Grotte Statique — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local grotte_statique_seuil = {}

function grotte_statique_seuil.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_grotte_statique_seuil")
  COMMON.RespawnAllies()
end

function grotte_statique_seuil.Enter(map)
  GAME:FadeIn(20)
end

function grotte_statique_seuil.Update(map, time)
end

return grotte_statique_seuil
