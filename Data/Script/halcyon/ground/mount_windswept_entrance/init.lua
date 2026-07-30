--[[
    init.lua — Mount Windswept Entrance — Chapitre 5
    VERSION UNIQUE BIOME 2026-07-30 — Avenue en segments camp unique

    IDENTITÉ UNIQUE — L'Avenue en Lacet avec le Drapeau Déchiré :
    - Combinaison : forêt basse → falaise → corniche venteuse avec Épine du Vieux visible
    - Seg1 sud : forêt basse clairière, camp de base 12 paillasses, feu Campfire, sacs Grassy_Bag, océan DuskBeach bordure rows 78-80
    - Seg2 centre : falaise abrupte, drapeaux expédition déchirés Paper_1 + River_Stone_Diamond, lacet x=256 rectiligne praticable rows 50-77 vérifié
    - Seg3 nord : corniche venteuse, Épine du Vieux visible haut, corniche effondrée est, Kangaskhan 176,352 accessible fix Y=-64 bug, Dungeon_Entrance pied paroi
    - Disposition : avenue en lacet serpente pas droite, pas même plan que steppe. Camp 12 membres répartition BEDS table, feu unique pas dupliqué, sac unique
    - Faune : Wingull, Swablu inoffensifs vent
    - Trace : Arcanin père Hyko mort il y a 25 ans sur cette montagne, Penticus mensonge mission routine, WindSecretScene
    - Cinématique CampNightfall : dîner 12 membres, conversations parallèles coroutines, coucher désynchronisé, rêve héros, matin vertige Nausea niveau2

    FONCTIONS : Kangaskhan accessible ouest, PP/ventre, 12 paillasses déployées nuit seulement via DeployBeds (Prompt 6.3)
    Ground officiel : mount_windswept_entrance 63x81 (agrandi), clairière dégagée, 8 touffes Flowers_Town_3, marker sud 256,616
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.ground.mount_windswept_entrance.mount_windswept_entrance_ch_5'
require 'halcyon.BossFX'

local mount_windswept_entrance = {}

function mount_windswept_entrance.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_mount_windswept_entrance UNIQ 2026-07-30 LACET DRAPEAU <<=')
  COMMON.RespawnAllies()
  GROUND:AddMapStatus("blowing_wind")
  PartnerEssentials.InitializePartnerSpawn()

  pcall(function()
    BossFX.Overlay('SE5_Wind_Background', 0, 0, 8, 300, 30, 1, -120, 0)
  end)
end

function mount_windswept_entrance.Enter(map)
  mount_windswept_entrance.PlotScripting()
end

function mount_windswept_entrance.Exit(map) end
function mount_windswept_entrance.Update(map) end

function mount_windswept_entrance.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function mount_windswept_entrance.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  mount_windswept_entrance.PlotScripting()
end

function mount_windswept_entrance.PlotScripting()
  if SV.ChapterProgression.Chapter == 5 then
    if not SV.Chapter5.FinishedMountWindsweptIntro then
      -- Arrivée sud par océan, lacet x=256, camp jour sans paillasses (DeployBeds nuit seulement)
      mount_windswept_entrance_ch_5.ArrivalCutscene()
    elseif SV.Chapter5.PlayTempMountScene then
      mount_windswept_entrance_ch_5.SetupGround()
      if SV.Chapter5.MountLastExitReason == 'Retreated' then
        mount_windswept_entrance_ch_5.RetreatReturnCutscene()
      else
        mount_windswept_entrance_ch_5.KODefeatCutscene()
      end
    elseif SV.Chapter5.MountGuardianDefeated and SV.Chapter5.MountVigilSceneSeen
       and not SV.Chapter5.WindSecretSceneSeen then
      -- Secret Hyko x Penticus — La corniche d'où Arcanin est tombé il y a 25 ans
      mount_windswept_entrance_ch_5.SetupGround()
      mount_windswept_entrance_ch_5.WindSecretScene()
    else
      mount_windswept_entrance_ch_5.SetupGround()
      GAME:FadeIn(20)
    end
  else
    GAME:FadeIn(20)
  end
end

function mount_windswept_entrance.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function mount_windswept_entrance.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression.Chapter == 5 then
    mount_windswept_entrance_ch_5.Growlithe_Action(chara, activator)
  else
    COMMON.GroundInteract(activator, chara, true)
  end
end

function mount_windswept_entrance.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression.Chapter == 5 then
    mount_windswept_entrance_ch_5.Zigzagoon_Action(chara, activator)
  else
    COMMON.GroundInteract(activator, chara, true)
  end
end

function mount_windswept_entrance.Tropius_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  mount_windswept_entrance_ch_5.Tropius_Action(chara, activator)
end

function mount_windswept_entrance.Noctowl_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  mount_windswept_entrance_ch_5.Noctowl_Action(chara, activator)
end

function mount_windswept_entrance.Audino_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  mount_windswept_entrance_ch_5.Audino_Action(chara, activator)
end

function mount_windswept_entrance.Snubbull_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  mount_windswept_entrance_ch_5.Snubbull_Action(chara, activator)
end

function mount_windswept_entrance.Mareep_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  mount_windswept_entrance_ch_5.Mareep_Action(chara, activator)
end

function mount_windswept_entrance.Cranidos_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  mount_windswept_entrance_ch_5.Cranidos_Action(chara, activator)
end

function mount_windswept_entrance.Breloom_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  mount_windswept_entrance_ch_5.Breloom_Action(chara, activator)
end

function mount_windswept_entrance.Girafarig_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  mount_windswept_entrance_ch_5.Girafarig_Action(chara, activator)
end

function mount_windswept_entrance.Kangaskhan_Rock_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  -- Kangaskhan 176,352 accessible fix falaise Y=-64 bug, zone 4x4 libre vérifiée, pas incrusté
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function mount_windswept_entrance.Dungeon_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("mount_windswept")
  UI:ResetSpeaker()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Grimper le lacet x=256 par-delà l'Épine du Vieux et la corniche effondrée,\nvers " .. zone:GetColoredName() .. " ?", true)
  UI:WaitForChoice()
  local yesnoResult = UI:ChoiceResult()
  if yesnoResult then
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    SV.partner.Spawn = "Default"
    GAME:EnterDungeon("mount_windswept", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

return mount_windswept_entrance
