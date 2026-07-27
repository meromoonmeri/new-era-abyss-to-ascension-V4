--[[ Verger du Bois d'Antan — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch20 Celebi - cinématique
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local bois_antan_verger = {}

function bois_antan_verger.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_bois_antan_verger")
  COMMON.RespawnAllies()
end

function bois_antan_verger.Enter(map)
  GAME:FadeIn(20)
end

function bois_antan_verger.Update(map, time)
end

return bois_antan_verger
