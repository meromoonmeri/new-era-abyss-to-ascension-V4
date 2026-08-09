--[[ a03p03 — Route du blizzard : la voix de Feunard (canon PMD Red gs170).
     Le héros marche dans le blizzard, épuisé. Une VOIX invisible lui parle :
     Feunard (Ninetales) ne se montre pas — « Je ne suis visible que de vous ».
     Apparition de la voix : jamais instantanée — silence, puis parole.
     Mise en scène : héros seul au centre, partenaire épuisé à l'arrière,
     la voix (ResetSpeaker, sans portrait) guide vers le Mont Gelé. ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local a03p03 = {}

function a03p03.Cutscene()
  DEBUG.EnableDbgCoro()
  GAME:CutsceneMode(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- Entrée par le Main_Entrance_Marker (460,124) sur 960x288
  pcall(function() GROUND:TeleportTo(hero, 460, 124, Direction.Up) end)
  if partner then pcall(function() GROUND:TeleportTo(partner, 428, 124, Direction.Up) end) end
  GAME:MoveCamera(444, 110, 1, false)
  GAME:FadeIn(25)

  -- Marche lente, épuisée (canon : le chemin semble ne jamais finir)
  if partner then GeneralFunctions.MoveCharAndCamera(partner, 428, 76, false, 10, 45) end
  if hero then GeneralFunctions.MoveCharAndCamera(hero, 460, 76, false, 10, 45) end
  GAME:WaitFrames(30)

  -- Pensées du héros (épuisement, doute, confiance)
  UI:SetSpeaker(hero)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_002"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_004"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_005"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_006"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_007"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_008"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_009"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_010"))

  -- UNE PRÉSENCE : le héros s'arrête, alerté (silence avant la voix)
  if hero then
    pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_011"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_012"))
  end

  -- LA VOIX DE FEUNARD — invisible (ResetSpeaker, pas de portrait)
  GAME:WaitFrames(30)
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_013"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_014"))

  -- Réactions intérieures du héros
  UI:SetSpeaker(hero)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_015"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_016"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_017"))

  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_018"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_019"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_020"))

  UI:SetSpeaker(hero)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_021"))

  -- La voix révèle le chemin (Mont Gelé / Feunard)
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_022"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_023"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_024"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_025"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_026"))

  UI:SetSpeaker(hero)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_027"))

  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_028"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_029"))

  -- La voix s'évanouit
  UI:SetSpeaker(hero)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_030"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_031"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_032"))

  -- Décision : aller voir Feunard au Mont Gelé
  if partner then
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_033"))
  end
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_034"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_035"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_036"))
  if partner then
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_037"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_038"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_039"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P03_040"))
  end

  -- Sortie nord, tête haute
  if hero then GeneralFunctions.MoveCharAndCamera(hero, 460, 40, false, 12, 30) end
  if partner then GeneralFunctions.MoveCharAndCamera(partner, 428, 40, false, 12, 30) end
  GAME:WaitFrames(20)
  GAME:CutsceneMode(false)
end

return a03p03
