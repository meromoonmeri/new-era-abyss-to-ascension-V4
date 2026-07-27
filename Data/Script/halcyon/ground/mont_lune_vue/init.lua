--[[ Mont Vue-de-Lune — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Cresselia ch23 (Cour du Clair de Lune)
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local mont_lune_vue = {}

function mont_lune_vue.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mont_lune_vue")
  COMMON.RespawnAllies()
end

function mont_lune_vue.Enter(map)
  GAME:FadeIn(20)
end

function mont_lune_vue.Update(map, time)
end

return mont_lune_vue
