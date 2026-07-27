--[[ Fosse Scellée des Ombres — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch26 Marshadow - cinématique
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local creux_ombres_scelle = {}

function creux_ombres_scelle.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_creux_ombres_scelle")
  COMMON.RespawnAllies()
end

function creux_ombres_scelle.Enter(map)
  GAME:FadeIn(20)
end

function creux_ombres_scelle.Update(map, time)
end

return creux_ombres_scelle
