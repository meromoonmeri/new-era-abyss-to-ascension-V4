--[[
    RescueTeamCampaign.lua — Gestionnaire de la Campagne Rescue Team (PMD Rouge / Bleu)

    Gère le cycle de vie complet de l'Équipe de Secours :
      1. Arrivée à la Place Pokémon & Base de Sauvetage
      2. Premières missions (Petit Bois, Bois Foudre, Mont Acier)
      3. Rivalité avec l'Équipe Roublard (Bois Sinistres)
      4. Expédition du Mont Foudre & Grand Canyon (Xatu)
      5. L'Arc Fugitif (La Traque, Mont Brasier, Forêt Givrée, Mont Gelé, Feunard)
      6. Climax Magma & Groudon
      7. Finale Tour Céleste, Rayquaza & Destruction de la Météorite
      8. Transition vers l'Ère des Explorateurs du Ciel
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

RescueTeamCampaign = {}

function RescueTeamCampaign.EnsureSV()
  if SV.RescueTeam == nil then
    SV.RescueTeam = {
      Chapter = 1,
      BaseLevel = 1,
      TinyWoodsDone = false,
      ThunderwaveDone = false,
      MtSteelDone = false,
      SinisterWoodsDone = false,
      MtThunderDone = false,
      GreatCanyonDone = false,
      FugitiveArcStarted = false,
      LapisCaveDone = false,
      MtBlazeDone = false,
      FrostyForestDone = false,
      MtFreezeDone = false,
      NinetalesTalkDone = false,
      MagmaCavernDone = false,
      SkyTowerDone = false,
      CampaignComplete = false
    }
  end
  return SV.RescueTeam
end

--------------------------------------------------------------------
-- Début de la Campagne Rescue Team
--------------------------------------------------------------------
function RescueTeamCampaign.StartCampaign()
  local sv = RescueTeamCampaign.EnsureSV()
  PrintInfo("[RescueTeamCampaign] Lancement de la Campagne Rescue Team")
  sv.Chapter = 1
  GAME:UnlockDungeon("tiny_woods")
  GAME:UnlockDungeon("thunderwave_cave")
end

--------------------------------------------------------------------
-- Avancement de l'Histoire
--------------------------------------------------------------------
function RescueTeamCampaign.OnDungeonClear(dungeonID)
  local sv = RescueTeamCampaign.EnsureSV()

  if dungeonID == "tiny_woods" then
    sv.TinyWoodsDone = true
    sv.Chapter = 2
    GAME:UnlockDungeon("thunderwave_cave")
  elseif dungeonID == "thunderwave_cave" then
    sv.ThunderwaveDone = true
    sv.Chapter = 3
    GAME:UnlockDungeon("mt_steel")
  elseif dungeonID == "mt_steel" then
    sv.MtSteelDone = true
    sv.Chapter = 4
    GAME:UnlockDungeon("sinister_woods")
  elseif dungeonID == "sinister_woods" then
    sv.SinisterWoodsDone = true
    sv.Chapter = 5
    GAME:UnlockDungeon("silent_chasm")
    GAME:UnlockDungeon("mt_thunder")
  elseif dungeonID == "mt_thunder" then
    sv.MtThunderDone = true
    sv.Chapter = 6
    GAME:UnlockDungeon("great_canyon")
  elseif dungeonID == "great_canyon" then
    sv.GreatCanyonDone = true
    sv.Chapter = 7
    sv.FugitiveArcStarted = true
    GAME:UnlockDungeon("lapis_cave")
    GAME:UnlockDungeon("mt_blaze")
  elseif dungeonID == "lapis_cave" then
    sv.LapisCaveDone = true
    GAME:UnlockDungeon("mt_blaze")
  elseif dungeonID == "mt_blaze" then
    sv.MtBlazeDone = true
    GAME:UnlockDungeon("frosty_forest")
  elseif dungeonID == "frosty_forest" then
    sv.FrostyForestDone = true
    GAME:UnlockDungeon("mt_freeze")
  elseif dungeonID == "mt_freeze" then
    sv.MtFreezeDone = true
    sv.NinetalesTalkDone = true
    sv.Chapter = 8
    GAME:UnlockDungeon("magma_cavern")
  elseif dungeonID == "magma_cavern" then
    sv.MagmaCavernDone = true
    sv.Chapter = 9
    GAME:UnlockDungeon("sky_tower")
  elseif dungeonID == "sky_tower" then
    sv.SkyTowerDone = true
    sv.CampaignComplete = true
    RescueTeamCampaign.EndingAndTransition()
  end
end

--------------------------------------------------------------------
-- Climax & Transition vers Sky
--------------------------------------------------------------------
function RescueTeamCampaign.EndingAndTransition()
  PrintInfo("[RescueTeamCampaign] Climax achevé : Météorite détruite !")
  pcall(function()
    GAME:CutsceneMode(true)
    SOUND:PlayBGM("Time Restored.ogg", true)
    GAME:FadeIn(30)
    UI:SetSpeaker(CH('Teammate1'))
    GeneralFunctions.SetEmotion("Joyous")
    UI:WaitShowDialogue("Nous avons réussi ![pause=20] La météorite est détruite et le monde des secours est sauvé !")
    UI:WaitShowDialogue("Mais regarde...[pause=20] L'anneau de Hoopa s'ouvre à nouveau au-dessus de la Tour Céleste !")
    GAME:WaitFrames(30)
    SOUND:PlayBattleSE("DUN_Portal")
    GAME:FadeOut(false, 50)
    GAME:CutsceneMode(false)

    -- Bascule vers l'ère Explorateurs du Ciel
    require 'halcyon.HoopaGateway'
    HoopaGateway.WarpToEra(HoopaGateway.ERA_SKY)
  end)
end

return RescueTeamCampaign
