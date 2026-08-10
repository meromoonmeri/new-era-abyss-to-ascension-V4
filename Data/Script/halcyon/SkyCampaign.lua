--[[
    SkyCampaign.lua — Gestionnaire de la Campagne Explorateurs du Ciel (PMD Sky)

    Gère le cycle de vie complet des Explorateurs :
      1. Arrivée à la Plage & Entrée à la Guilde de Grodoudou
      2. Premières explorations (Grotte des Échoués, Falaise Trempée, Mont Bristle)
      3. Expédition de la Guilde (Grotte Cascade, Bois Pommier, Forêt Brumeuse, Grotte Vapeur)
      4. Les Rouages du Temps (Plaines Amp, Grotte des Sables, Grotte Cristal / Grovyle)
      5. Monde du Futur Paralysé (Chasm Cave, Dark Hill, Ruine Scellée / Spiritomb, Forêt des Cimes / Celebi)
      6. Terres Cachées & Ascension de la Tour du Temps
      7. Combat final contre Dialga Primal & Restauration du Temps
      8. Retour triomphal dans le Présent de New Era
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

SkyCampaign = {}

function SkyCampaign.EnsureSV()
  if SV.SkyCampaign == nil then
    SV.SkyCampaign = {
      Chapter = 1,
      BeachCaveDone = false,
      DrenchedBluffDone = false,
      MtBristleDone = false,
      WaterfallCaveDone = false,
      AppleWoodsDone = false,
      FoggyForestDone = false,
      SteamCaveDone = false,
      AmpPlainsDone = false,
      QuicksandCaveDone = false,
      CrystalCaveDone = false,
      FutureArcStarted = false,
      ChasmCaveDone = false,
      DarkHillDone = false,
      SealedRuinDone = false,
      DuskForestDone = false,
      TreeshroudDone = false,
      BrineCaveDone = false,
      HiddenLandDone = false,
      TemporalTowerDone = false,
      DialgaDefeated = false,
      CampaignComplete = false
    }
  end
  return SV.SkyCampaign
end

--------------------------------------------------------------------
-- Début de la Campagne Sky
--------------------------------------------------------------------
function SkyCampaign.StartCampaign()
  local sv = SkyCampaign.EnsureSV()
  PrintInfo("[SkyCampaign] Lancement de la Campagne Explorateurs du Ciel")
  sv.Chapter = 1
  GAME:UnlockDungeon("beach_cave")
  GAME:UnlockDungeon("drenched_bluff")
end

--------------------------------------------------------------------
-- Avancement de l'Histoire
--------------------------------------------------------------------
function SkyCampaign.OnDungeonClear(dungeonID)
  local sv = SkyCampaign.EnsureSV()

  if dungeonID == "beach_cave" then
    sv.BeachCaveDone = true
    sv.Chapter = 2
    GAME:UnlockDungeon("drenched_bluff")
    GAME:UnlockDungeon("mt_bristle")
  elseif dungeonID == "mt_bristle" then
    sv.MtBristleDone = true
    sv.Chapter = 3
    GAME:UnlockDungeon("waterfall_cave")
    GAME:UnlockDungeon("apple_woods")
  elseif dungeonID == "waterfall_cave" or dungeonID == "apple_woods" then
    sv.WaterfallCaveDone = true
    sv.Chapter = 4
    GAME:UnlockDungeon("foggy_forest")
    GAME:UnlockDungeon("steam_cave")
  elseif dungeonID == "steam_cave" then
    sv.SteamCaveDone = true
    sv.Chapter = 5
    GAME:UnlockDungeon("amp_plains")
    GAME:UnlockDungeon("quicksand_cave")
    GAME:UnlockDungeon("crystal_cave")
  elseif dungeonID == "crystal_cave" then
    sv.CrystalCaveDone = true
    sv.Chapter = 6
    sv.FutureArcStarted = true
    GAME:UnlockDungeon("chasm_cave")
    GAME:UnlockDungeon("dark_hill")
  elseif dungeonID == "chasm_cave" then
    sv.ChasmCaveDone = true
    GAME:UnlockDungeon("dark_hill")
  elseif dungeonID == "dark_hill" then
    sv.DarkHillDone = true
    GAME:UnlockDungeon("sealed_ruin")
  elseif dungeonID == "sealed_ruin" then
    sv.SealedRuinDone = true
    GAME:UnlockDungeon("dusk_forest")
    GAME:UnlockDungeon("treeshroud_forest")
  elseif dungeonID == "treeshroud_forest" then
    sv.TreeshroudDone = true
    sv.Chapter = 7
    GAME:UnlockDungeon("brine_cave")
    GAME:UnlockDungeon("hidden_land")
    GAME:UnlockDungeon("temporal_tower")
  elseif dungeonID == "hidden_land" then
    sv.HiddenLandDone = true
    GAME:UnlockDungeon("temporal_tower")
  elseif dungeonID == "temporal_tower" then
    sv.TemporalTowerDone = true
    sv.DialgaDefeated = true
    sv.CampaignComplete = true
    SkyCampaign.EndingAndReturnToNewEra()
  end
end

--------------------------------------------------------------------
-- Climax & Retour dans New Era
--------------------------------------------------------------------
function SkyCampaign.EndingAndReturnToNewEra()
  PrintInfo("[SkyCampaign] Climax achevé : Tour du Temps restaurée !")
  pcall(function()
    GAME:CutsceneMode(true)
    SOUND:PlayBGM("Dialga's Fight To the Finish!.ogg", true)
    GAME:FadeIn(30)
    UI:SetSpeaker(CH('Teammate1'))
    GeneralFunctions.SetEmotion("Joyous")
    UI:WaitShowDialogue("Le cours du temps est rétabli ![pause=20] La planète ne sera pas paralysée !")
    UI:WaitShowDialogue("Et l'anneau de Hoopa résonne...[pause=25] Il nous ramène dans notre époque, à Métano !")
    GAME:WaitFrames(40)
    SOUND:PlayBattleSE("DUN_Portal")
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    GAME:CutsceneMode(false)

    -- Retour dans New Era
    require 'halcyon.HoopaGateway'
    HoopaGateway.WarpToEra(HoopaGateway.ERA_NEW_ERA)
  end)
end

return SkyCampaign
