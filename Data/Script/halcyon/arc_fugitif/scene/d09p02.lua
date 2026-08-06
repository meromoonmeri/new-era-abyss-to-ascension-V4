--- Scene: d09p02
local d09p02 = {}
function d09p02.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Mt Blaze', true)
  SOUND:FadeOutBGM(60)
  SOUND:FadeOutBGM(30)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  SOUND:PlayBGM('Mt Blaze', true)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P02_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P02_002"))
  GAME:CutsceneMode(false)
end
return d09p02
