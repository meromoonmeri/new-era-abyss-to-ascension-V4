--[[ Sanctuaire du Vœu — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local sanctuaire_voeu = {}

function sanctuaire_voeu.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_sanctuaire_voeu")
  COMMON.RespawnAllies()
end

function sanctuaire_voeu.Enter(map)
  GAME:FadeIn(20)
end

function sanctuaire_voeu.Update(map, time)
end

return sanctuaire_voeu
