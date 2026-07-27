--[[ Vallon Perdu — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local vallon_perdu = {}

function vallon_perdu.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_vallon_perdu")
  COMMON.RespawnAllies()
end

function vallon_perdu.Enter(map)
  GAME:FadeIn(20)
end

function vallon_perdu.Update(map, time)
end

return vallon_perdu
