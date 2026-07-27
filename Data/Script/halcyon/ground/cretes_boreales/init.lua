--[[ Crêtes Boréales — arene de cinematique importee 1:1 de pmd-red (reserve, non branchee).
     Casting du boss d'origine CONSERVE (regle Partie 6). Decor material-layer GBA :
     compenser par Background anime / retiling biome au branchement (cf. arene Lugia). ]]
local cretes_boreales = {}

function cretes_boreales.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_cretes_boreales")
  COMMON.RespawnAllies()
end

function cretes_boreales.Enter(map)
  GAME:FadeIn(20)
end

function cretes_boreales.Update(map, time)
end

return cretes_boreales
