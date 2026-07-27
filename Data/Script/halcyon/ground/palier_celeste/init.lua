--[[ Palier Céleste — arene de cinematique importee 1:1 de pmd-red (reserve, non branchee).
     Casting du boss d'origine CONSERVE (regle Partie 6). Decor material-layer GBA :
     compenser par Background anime / retiling biome au branchement (cf. arene Lugia). ]]
local palier_celeste = {}

function palier_celeste.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_palier_celeste")
  COMMON.RespawnAllies()
end

function palier_celeste.Enter(map)
  GAME:FadeIn(20)
end

function palier_celeste.Update(map, time)
end

return palier_celeste
