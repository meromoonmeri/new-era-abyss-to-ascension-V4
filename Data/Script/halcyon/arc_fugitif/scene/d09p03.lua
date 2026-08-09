--[[ d09p03 — Sommet du Mont Ardent : SULFURA (canon PMD Red gs197).
     Le duo entre dans l'arène du sommet. Sulfura (Moltres) se dresse dans
     les flammes (apparition progressive, EmergeFire), juge le duo, exige
     une promesse, puis laisse passer. Mise en scène : déplacement du duo,
     caméra, dialogue canonique (clés SCENE_D09P03_*). ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

local d09p03 = {}

function d09p03.Cutscene()
  DEBUG.EnableDbgCoro()
  GAME:CutsceneMode(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- Positions canoniques (markers d09p03) : héros (296,208), boss (272,176)
  pcall(function() GROUND:TeleportTo(hero, 296, 208, Direction.Up) end)
  if partner then pcall(function() GROUND:TeleportTo(partner, 264, 208, Direction.Up) end) end
  GAME:MoveCamera(272, 192, 1, false)
  GAME:FadeIn(25)

  -- Le duo avance vers le cœur de l'arène
  if partner then GeneralFunctions.MoveCharAndCamera(partner, 264, 184, false, 12, 35) end
  if hero then GeneralFunctions.MoveCharAndCamera(hero, 296, 184, false, 12, 35) end
  GAME:WaitFrames(30)

  -- SULFURA se dresse dans les flammes (apparition progressive)
  local moltres = CharacterEssentials.MakeCharactersFromList({{'Moltres', 272, 176, Direction.Down}})
  if moltres then
    pcall(function() GROUND:Hide('Moltres') end)
    BossFX.EmergeFire(moltres, 272, 176)
    BossFX.Flash(272, 176, 3, 6, 30)
    BossFX.ShakeScreen(5, 25)
  end

  -- SULFURA parle
  if moltres then UI:SetSpeaker(moltres) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_002"))
  if partner then pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_004"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_005"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_006"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_007"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_008"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_009"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_010"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_011"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_012"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_013"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_014"))

  -- Le duo accepte
  if partner then UI:SetSpeaker(partner) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_015"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_016"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_017"))
  if moltres then UI:SetSpeaker(moltres) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_018"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_019"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_020"))
  UI:SetSpeaker(hero)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_021"))
  if moltres then
    UI:SetSpeaker(moltres)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_022"))
  end
  if partner then UI:SetSpeaker(partner) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_023"))

  -- Réflexion du duo + décision
  UI:SetSpeaker(hero)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_024"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_025"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_026"))
  if partner then UI:SetSpeaker(partner) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_027"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D09P03_028"))

  GAME:CutsceneMode(false)
end

return d09p03
