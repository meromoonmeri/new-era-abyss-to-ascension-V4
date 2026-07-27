--[[ Flèche des Reliques — Courroux — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch28 Dialga - cinématique pré-boss
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local fleche_reliques_courroux = {}

function fleche_reliques_courroux.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_fleche_reliques_courroux")
  COMMON.RespawnAllies()
end

function fleche_reliques_courroux.Enter(map)
  GAME:FadeIn(20)
end

function fleche_reliques_courroux.Update(map, time)
end

return fleche_reliques_courroux
