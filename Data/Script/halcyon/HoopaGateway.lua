--[[
    HoopaGateway.lua — Portail Temporel & Gestionnaire de Campagnes Historiques

    Ce module gère le voyage temporel ouvert par Hoopa au Chapitre 7 :
      1. ERA_NEW_ERA     (Présent — Métano, Chapitres 1 à 6)
      2. ERA_RESCUE_TEAM (Passé I — Campagne complète Rescue Team)
      3. ERA_SKY         (Passé II — Campagne complète Explorateurs du Ciel)
      4. RETOUR          (Présent consolidé)
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

HoopaGateway = {}

HoopaGateway.ERA_NEW_ERA     = 0
HoopaGateway.ERA_RESCUE_TEAM = 1
HoopaGateway.ERA_SKY         = 2

function HoopaGateway.EnsureSV()
  if SV.HoopaGateway == nil then
    SV.HoopaGateway = {
      CurrentEra = HoopaGateway.ERA_NEW_ERA,
      HoopaMet = false,
      RescueTeamCompleted = false,
      SkyCompleted = false,
      RiftActive = false
    }
  end
  return SV.HoopaGateway
end

--------------------------------------------------------------------
-- Cinématique d'ouverture : La Faille de Hoopa (Chapitre 7)
--------------------------------------------------------------------
function HoopaGateway.TriggerTemporalRift()
  local sv = HoopaGateway.EnsureSV()
  if sv.HoopaMet then return end
  sv.HoopaMet = true
  sv.RiftActive = true

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  pcall(function()
    GAME:CutsceneMode(true)
    SOUND:FadeOutBGM(30)
    GAME:WaitFrames(30)

    -- Effet de distorsion spatio-temporelle
    BossFX.ShakeScreen(3, 30)
    SOUND:PlayBattleSE("EVT_Roar")
    GAME:FadeOut(true, 15)
    GAME:WaitFrames(20)
    GAME:FadeIn(20)

    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Shock")
    UI:WaitShowDialogue("Qu'est-ce que c'est que cette secousse ?![pause=20] L'air vibre tout autour de nous !")

    GeneralFunctions.HeroDialogue(hero, "(Une faille dorée s'ouvre dans le ciel...[pause=20] Des anneaux flottent dans la brume.)", "Surprised")

    -- Apparition de Hoopa
    local hoopa = CharacterEssentials.MakeCharactersFromList({{'Hoopa', 380, 260, Direction.Down}})[1]
    if hoopa then
      GROUND:CharSetAnim(hoopa, "Idle", true)
      SOUND:PlayBattleSE("DUN_Portal")
      BossFX.Flash(380, 260, 3, 4, 20)
    end

    GAME:WaitFrames(25)
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Surprised")
    UI:WaitShowDialogue("Un Pokémon sort de l'anneau ?![pause=20] Qui es-tu ?")

    if hoopa then
      UI:SetSpeaker(hoopa)
      GeneralFunctions.SetEmotion("Joyous")
      UI:WaitShowDialogue("Hoopa est là ![pause=20] Vous cherchez les réponses sur les temps anciens ?[pause=25] Hoopa peut ouvrir le grand passage !")
      UI:WaitShowDialogue("Les héros du passé ont affronté les premières tempêtes.[pause=20] Venez voir de vos propres yeux !")
    end

    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue("[player]...[pause=20] Si les réponses sur les Cœurs d'Anima dorment dans le passé,[pause=15] nous devons franchir ce portail !")

    GeneralFunctions.HeroDialogue(hero, "(Le temps s'enroule autour de nous...[pause=25] En route vers l'Époque des Secours.)", "Determined")

    -- Téléportation vers l'ère Rescue Team
    SOUND:PlayBattleSE("DUN_Stairs")
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    GAME:CutsceneMode(false)

    HoopaGateway.WarpToEra(HoopaGateway.ERA_RESCUE_TEAM)
  end)
end

--------------------------------------------------------------------
-- Transition entre les ères
--------------------------------------------------------------------
function HoopaGateway.WarpToEra(era)
  local sv = HoopaGateway.EnsureSV()
  sv.CurrentEra = era

  if era == HoopaGateway.ERA_RESCUE_TEAM then
    PrintInfo("[HoopaGateway] Bascule vers l'ère RESCUE TEAM")
    GAME:EnterGroundMap("t01p01", "Main_Entrance_Marker")
  elseif era == HoopaGateway.ERA_SKY then
    PrintInfo("[HoopaGateway] Bascule vers l'ère EXPLORATEURS DU CIEL")
    GAME:EnterGroundMap("sky_p01p01a", "Main_Entrance_Marker")
  else
    PrintInfo("[HoopaGateway] Retour vers NEW ERA (Présent)")
    GAME:EnterGroundMap("metano_town", "Main_Entrance_Marker")
  end
end

return HoopaGateway
