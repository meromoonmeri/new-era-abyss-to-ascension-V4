--[[ Autel du Gué du Poulain — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch18 Keldeo - cinématique pré-boss
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local gue_poulain_autel = {}

function gue_poulain_autel.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_gue_poulain_autel")
  COMMON.RespawnAllies()
end

function gue_poulain_autel.Enter(map)
  GAME:FadeIn(20)
end

function gue_poulain_autel.Update(map, time)
end

return gue_poulain_autel
