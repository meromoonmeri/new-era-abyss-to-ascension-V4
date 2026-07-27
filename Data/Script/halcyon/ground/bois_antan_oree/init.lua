--[[ Orée du Bois d'Antan — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch20 Celebi - entrée
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local bois_antan_oree = {}

function bois_antan_oree.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_bois_antan_oree")
  COMMON.RespawnAllies()
end

function bois_antan_oree.Enter(map)
  GAME:FadeIn(20)
end

function bois_antan_oree.Update(map, time)
end

return bois_antan_oree
