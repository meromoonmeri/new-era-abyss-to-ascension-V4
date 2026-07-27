--[[ Laboratoire Décrépit — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Genesect ch22 (Réacteur Enfoui) + Mewtwo lore
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local labo_decrepit = {}

function labo_decrepit.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_labo_decrepit")
  COMMON.RespawnAllies()
end

function labo_decrepit.Enter(map)
  GAME:FadeIn(20)
end

function labo_decrepit.Update(map, time)
end

return labo_decrepit
