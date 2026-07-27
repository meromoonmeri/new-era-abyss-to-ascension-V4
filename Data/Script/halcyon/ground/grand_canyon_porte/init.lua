--[[ Porte du Grand Canyon — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local grand_canyon_porte = {}

function grand_canyon_porte.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_grand_canyon_porte")
  COMMON.RespawnAllies()
end

function grand_canyon_porte.Enter(map)
  GAME:FadeIn(20)
end

function grand_canyon_porte.Update(map, time)
end

return grand_canyon_porte
