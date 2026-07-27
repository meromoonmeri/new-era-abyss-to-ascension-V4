--[[ Fosse Argentée — arene de cinematique importee 1:1 de pmd-red (reserve, non branchee).
     Casting du boss d'origine CONSERVE (regle Partie 6). Decor material-layer GBA :
     compenser par Background anime / retiling biome au branchement (cf. arene Lugia). ]]
local fosse_argentee = {}

function fosse_argentee.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_fosse_argentee")
  COMMON.RespawnAllies()
end

function fosse_argentee.Enter(map)
  GAME:FadeIn(20)
end

function fosse_argentee.Update(map, time)
end

return fosse_argentee
