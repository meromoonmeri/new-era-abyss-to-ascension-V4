--[[ Fond de la Grotte Lazuli — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local grotte_lazuli_fond = {}

function grotte_lazuli_fond.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_grotte_lazuli_fond")
  COMMON.RespawnAllies()
end

function grotte_lazuli_fond.Enter(map)
  GAME:FadeIn(20)
end

function grotte_lazuli_fond.Update(map, time)
end

return grotte_lazuli_fond
