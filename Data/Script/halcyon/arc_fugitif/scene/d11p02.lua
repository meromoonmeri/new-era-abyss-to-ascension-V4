--- Scene: d11p02
local d11p02 = {}
function d11p02.Cutscene()
  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Snow Camp.ogg', true)
  SOUND:FadeOutBGM(60)
  SOUND:FadeOutBGM(30)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  -- GROUND:CharSetAction(ent, 2)
  SOUND:PlayBGM('Snow Camp.ogg', true)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P02_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P02_002"))
  GAME:CutsceneMode(false)
end
return d11p02
