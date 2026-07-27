--[[ Champ du Vent Boréal — arene de cinematique importee 1:1 de pmd-red (reserve, non branchee).
     Casting du boss d'origine CONSERVE (regle Partie 6). Decor material-layer GBA :
     compenser par Background anime / retiling biome au branchement (cf. arene Lugia). ]]
local champ_vent_boreal = {}

function champ_vent_boreal.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_champ_vent_boreal")
  COMMON.RespawnAllies()
end

function champ_vent_boreal.Enter(map)
  GAME:FadeIn(20)
end

function champ_vent_boreal.Update(map, time)
end

return champ_vent_boreal
