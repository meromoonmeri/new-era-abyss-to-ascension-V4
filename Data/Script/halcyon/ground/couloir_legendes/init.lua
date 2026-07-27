--[[ Couloir des Légendes — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch32 Eternatus - antichambre Nervure du Monde
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local couloir_legendes = {}

function couloir_legendes.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_couloir_legendes")
  COMMON.RespawnAllies()
end

function couloir_legendes.Enter(map)
  GAME:FadeIn(20)
end

function couloir_legendes.Update(map, time)
end

return couloir_legendes
