--[[ Bois des Plaintes — arene de cinematique importee 1:1 de pmd-red (reserve, non branchee).
     Casting du boss d'origine CONSERVE (regle Partie 6). Decor material-layer GBA :
     compenser par Background anime / retiling biome au branchement (cf. arene Lugia). ]]
local bois_des_plaintes = {}

function bois_des_plaintes.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_bois_des_plaintes")
  COMMON.RespawnAllies()
end

function bois_des_plaintes.Enter(map)
  GAME:FadeIn(20)
end

function bois_des_plaintes.Update(map, time)
end

return bois_des_plaintes
