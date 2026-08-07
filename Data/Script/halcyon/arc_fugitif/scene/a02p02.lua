--- Scene: a02p02
local a02p02 = {}
function a02p02.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Rising Fear.ogg', true)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P02_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P02_002"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P02_003"))
  SOUND:FadeOutBGM(120)
  -- GROUND:CharSetAction(ent, 2)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P02_004"))
  -- GROUND:CharSetAction(ent, 2)
  GAME:CutsceneMode(false)
end
return a02p02
