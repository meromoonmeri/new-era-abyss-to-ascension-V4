--[[ Bord du Gouffre Muet — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local gouffre_muet_bord = {}

function gouffre_muet_bord.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_gouffre_muet_bord")
  COMMON.RespawnAllies()
end

function gouffre_muet_bord.Enter(map)
  GAME:FadeIn(20)
end

function gouffre_muet_bord.Update(map, time)
end

return gouffre_muet_bord
