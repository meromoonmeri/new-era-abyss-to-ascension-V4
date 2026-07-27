--[[ Antre de l’Occident — arene de cinematique importee 1:1 de pmd-red (reserve, non branchee).
     Casting du boss d'origine CONSERVE (regle Partie 6). Decor material-layer GBA :
     compenser par Background anime / retiling biome au branchement (cf. arene Lugia). ]]
local antre_occident = {}

function antre_occident.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_antre_occident")
  COMMON.RespawnAllies()
end

function antre_occident.Enter(map)
  GAME:FadeIn(20)
end

function antre_occident.Update(map, time)
end

return antre_occident
