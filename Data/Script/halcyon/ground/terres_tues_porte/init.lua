--[[ Porte des Terres Tues — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch30 Zygarde - entrée Ciel Suspendu
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local terres_tues_porte = {}

function terres_tues_porte.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_terres_tues_porte")
  COMMON.RespawnAllies()
end

function terres_tues_porte.Enter(map)
  GAME:FadeIn(20)
end

function terres_tues_porte.Update(map, time)
end

return terres_tues_porte
