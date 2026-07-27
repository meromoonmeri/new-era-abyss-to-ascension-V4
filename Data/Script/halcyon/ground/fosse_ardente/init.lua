--[[ Fosse Ardente — arene de cinematique importee 1:1 de pmd-red (reserve, non branchee).
     Casting du boss d'origine CONSERVE (regle Partie 6). Decor material-layer GBA :
     compenser par Background anime / retiling biome au branchement (cf. arene Lugia). ]]
local fosse_ardente = {}

function fosse_ardente.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_fosse_ardente")
  COMMON.RespawnAllies()
end

function fosse_ardente.Enter(map)
  GAME:FadeIn(20)
end

function fosse_ardente.Update(map, time)
end

return fosse_ardente
