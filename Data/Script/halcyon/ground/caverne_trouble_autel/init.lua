--[[ Autel de la Caverne Trouble — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local caverne_trouble_autel = {}

function caverne_trouble_autel.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_caverne_trouble_autel")
  COMMON.RespawnAllies()
end

function caverne_trouble_autel.Enter(map)
  GAME:FadeIn(20)
end

function caverne_trouble_autel.Update(map, time)
end

return caverne_trouble_autel
