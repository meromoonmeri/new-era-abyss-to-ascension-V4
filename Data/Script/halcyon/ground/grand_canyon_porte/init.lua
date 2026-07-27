--[[ La Voie du Grand Canyon — scene "ouverture de la voie" (Reseau des Anciens Chemins).
     Ground pmd-red importe 1:1 ; geometrie intouchee, dialogues New Era.
     Jouee UNE SEULE FOIS a la premiere victoire (SV.Reseau.VoiesOuvertes).
     Sortie garantie en fin de scene ET en cas de rejeu : jamais de blocage. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

local grand_canyon_porte = {}

local function sortie()
  GAME:FadeOut(false, 40)
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 1, 0, true, true)
end

function grand_canyon_porte.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_grand_canyon_porte")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function grand_canyon_porte.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 224, 224, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 192, 224, Direction.Up) end
  GAME:MoveCamera(208, 208, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if partner ~= nil then
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Quelle vue...[pause=20] On voit le canyon sur des lieues.")
  end
  GAME:WaitFrames(12)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("Le vent s'engouffre entre les parois sans produire le moindre écho.")
  UI:SetCenter(false)
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Les voix se sont éteintes ici.[pause=20] Un canyon devrait renvoyer chaque mot.")
  end
  GAME:WaitFrames(12)
  -- Le mecanisme des batisseurs se rallume.
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  BossFX.Flash(208, 208, 4, 6, 24)
  GAME:WaitFrames(24)
  GAME:WaitFrames(12)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("Deux piliers taillés dans la roche s'éveillent de part et d'autre du passage.")
  UI:SetCenter(false)
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Surprised")
    UI:WaitShowDialogue("Une porte ![pause=20] Ces piliers, c'est une porte, pas une décoration !")
  end
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Le Réseau ne traverse pas le canyon...[pause=20] il le franchit.")
  end
  GAME:WaitFrames(12)
  GeneralFunctions.HeroDialogue(hero, "Et la porte vient de reconnaître quelqu'un.", "Normal")
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Inspired")
    UI:WaitShowDialogue("Nous.[pause=20] Une voie de plus.")
  end
  GAME:WaitFrames(12)
  GAME:WaitFrames(20)
  GAME:CutsceneMode(false)
  sortie()
end

function grand_canyon_porte.Update(map, time) end
function grand_canyon_porte.GameSave(map) end
function grand_canyon_porte.GameLoad(map) end

return grand_canyon_porte
