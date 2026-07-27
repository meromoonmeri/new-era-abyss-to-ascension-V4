--[[ Orée de la Forêt Givrée — ground importe 1:1 (reserve, non branche a une zone pour l'instant).
     Squelette standard : a completer lors du branchement (cf. document maitre). ]]
local foret_givree_oree = {}

function foret_givree_oree.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_foret_givree_oree")
  COMMON.RespawnAllies()
end

function foret_givree_oree.Enter(map)
  GAME:FadeIn(20)
end

function foret_givree_oree.Update(map, time)
end

return foret_givree_oree
