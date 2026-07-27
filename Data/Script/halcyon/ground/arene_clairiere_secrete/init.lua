--[[ Arène de la Clairière Secrète — ground importe (format RogueEssence natif, vague 4).
     Assignation : ch26 Mew - cinématique Bois Enchevêtrés
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local arene_clairiere_secrete = {}

function arene_clairiere_secrete.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_arene_clairiere_secrete")
  COMMON.RespawnAllies()
end

function arene_clairiere_secrete.Enter(map)
  GAME:FadeIn(20)
end

function arene_clairiere_secrete.Update(map, time)
end

return arene_clairiere_secrete
