--[[ Parvis Céleste — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local parvis_celeste = {}

function parvis_celeste.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_parvis_celeste")
  COMMON.RespawnAllies()
end

function parvis_celeste.Enter(map)
  GAME:FadeIn(20)
end

function parvis_celeste.Update(map, time)
end

return parvis_celeste
