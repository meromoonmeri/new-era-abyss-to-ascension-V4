--- Scene: d14p01
local d14p01 = {}
function d14p01.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Theres Trouble', true)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return d14p01
