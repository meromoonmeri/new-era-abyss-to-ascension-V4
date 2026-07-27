--[[ Fond du Bois Flétri — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch29 Yveltal - cinématique
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local vallon_malsain_fond = {}

function vallon_malsain_fond.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_vallon_malsain_fond")
  COMMON.RespawnAllies()
end

function vallon_malsain_fond.Enter(map)
  GAME:FadeIn(20)
end

function vallon_malsain_fond.Update(map, time)
end

return vallon_malsain_fond
