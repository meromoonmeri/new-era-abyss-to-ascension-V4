--[[ Champ des Braises — arene de cinematique importee 1:1 de pmd-red (reserve, non branchee).
     Casting du boss d'origine CONSERVE (regle Partie 6). Decor material-layer GBA :
     compenser par Background anime / retiling biome au branchement (cf. arene Lugia). ]]
local champ_braises = {}

function champ_braises.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_champ_braises")
  COMMON.RespawnAllies()
end

function champ_braises.Enter(map)
  GAME:FadeIn(20)
end

function champ_braises.Update(map, time)
end

return champ_braises
