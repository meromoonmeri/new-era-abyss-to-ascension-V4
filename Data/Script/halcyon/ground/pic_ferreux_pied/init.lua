--[[ Pied du Pic Ferreux — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local pic_ferreux_pied = {}

function pic_ferreux_pied.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_pic_ferreux_pied")
  COMMON.RespawnAllies()
end

function pic_ferreux_pied.Enter(map)
  GAME:FadeIn(20)
end

function pic_ferreux_pied.Update(map, time)
end

return pic_ferreux_pied
