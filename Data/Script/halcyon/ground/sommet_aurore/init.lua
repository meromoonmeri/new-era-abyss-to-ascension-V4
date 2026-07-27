--[[ Sommet de l’Aurore — arene de cinematique importee 1:1 de pmd-red (reserve, non branchee).
     Casting du boss d'origine CONSERVE (regle Partie 6). Decor material-layer GBA :
     compenser par Background anime / retiling biome au branchement (cf. arene Lugia). ]]
local sommet_aurore = {}

function sommet_aurore.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_sommet_aurore")
  COMMON.RespawnAllies()
end

function sommet_aurore.Enter(map)
  GAME:FadeIn(20)
end

function sommet_aurore.Update(map, time)
end

return sommet_aurore
