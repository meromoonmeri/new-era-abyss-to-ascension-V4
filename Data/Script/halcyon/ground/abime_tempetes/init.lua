--[[ Abîme des Tempêtes — arene de cinematique importee 1:1 de pmd-red (reserve, non branchee).
     Casting du boss d'origine CONSERVE (regle Partie 6). Decor material-layer GBA :
     compenser par Background anime / retiling biome au branchement (cf. arene Lugia). ]]
local abime_tempetes = {}

function abime_tempetes.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_abime_tempetes")
  COMMON.RespawnAllies()
end

function abime_tempetes.Enter(map)
  GAME:FadeIn(20)
end

function abime_tempetes.Update(map, time)
end

return abime_tempetes
