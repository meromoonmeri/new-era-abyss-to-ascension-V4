--[[
    init.lua — Cloven Ruins Entrance
    Entree des Ruines Fendues — Chapitre 5, climax de l'expedition
    ---------------------------------------------------------------
    Apres la victoire sur Tornadus, l'expedition etablit un campement
    devant l'entree (cinematique en 6 actes : arrivee, surprise de Plum,
    crise, repas, nuit, comedie), puis reve et matin.
    Architecture conforme au patron valide de mount_windswept_entrance :
    Init pose le noir + CutsceneMode, Enter/GameLoad lancent PlotScripting.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.cloven_ruins_entrance.cloven_ruins_entrance_ch_5'

local cloven_ruins_entrance = {}

function cloven_ruins_entrance.Init(map)
  --LE NOIR ET LE GEL, AVANT TOUT LE RESTE (patron du Mont Windsep).
  --S'execute apres que le moteur a place le joueur et recadre la camera,
  --mais avant le Enter qui lance la cinematique.
  pcall(function() GAME:FadeOut(false, 1) end)
  pcall(function() GAME:CutsceneMode(true) end)
  COMMON.RespawnAllies()
  pcall(function() PartnerEssentials.InitializePartnerSpawn() end)

  -- Si aucune cinematique n'est a venir, on libere la main des
  -- maintenant (sinon le joueur resterait fige sur une carte montee).
  -- Les conditions sont EXACTEMENT celles lues par PlotScripting.
  pcall(function()
    local sceneAVenir = false
    if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5 then
      local c5 = SV.Chapter5
      sceneAVenir = c5.RuinsCampPending
                 or (c5.RuinsCampNightDone and not c5.RuinsCampDone)
                 or c5.PlayTempRuinsScene
    end
    if not sceneAVenir then
      GAME:CutsceneMode(false)
      -- Recentrage sur le joueur (patron des cartes libres).
      GAME:MoveCamera(0, 0, 1, true)
    end
  end)
end

function cloven_ruins_entrance.Enter(map)
  cloven_ruins_entrance.PlotScripting()
end

function cloven_ruins_entrance.Update(map) end

function cloven_ruins_entrance.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function cloven_ruins_entrance.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  -- Patron exact du Mont Windsep : GameLoad lance PlotScripting.
  -- Le joueur existe sur la carte au chargement (MapChar PLAYER
  -- serialise dans la sauvegarde) : les entites sont valides ici.
  cloven_ruins_entrance.PlotScripting()
end

function cloven_ruins_entrance.PlotScripting()
  if SV.ChapterProgression.Chapter ~= 5 then
    --Hors ch5 : entree simple (rejouabilite / autres usages).
    cloven_ruins_entrance_ch_5.SetupGround()
    GAME:FadeIn(20)
    return
  end

  local c5 = SV.Chapter5

  -- RETOUR DU REVE — la veillee est terminee, le reve a ete bascule
  -- vers hero_dream qui renvoie ici (DreamReturn). On rejoue le matin.
  if c5.RuinsCampNightDone and not c5.RuinsCampDone then
    cloven_ruins_entrance_ch_5.ResumeAfterDream()
    return
  end

  -- RETOUR APRES KO / ABANDON DANS LES RUINES — le camp joue la
  -- cinematique de reveil (KODefeatCutscene) ou de repli
  -- (RetreatReturnCutscene).
  if c5.PlayTempRuinsScene then
    if c5.RuinsLastExitReason == 'Retreated' then
      cloven_ruins_entrance_ch_5.SetupGround(false)
      cloven_ruins_entrance_ch_5.RetreatReturnCutscene()
    else
      cloven_ruins_entrance_ch_5.SetupGround(true)
      cloven_ruins_entrance_ch_5.KODefeatCutscene()
    end
    return
  end

  -- ARRIVEE AU CAMP — la cinematique d'entree (6 actes).
  if c5.RuinsCampPending and not c5.RuinsCampDone then
    cloven_ruins_entrance_ch_5.SetupGround(true)
    cloven_ruins_entrance_ch_5.ArrivalCutscene()
    return
  end

  -- ETAT DE CAMP — le joueur est libre (apres la cinematique).
  cloven_ruins_entrance_ch_5.SetupGround(false)
  GAME:FadeIn(20)
end

-- ENTREE DANS LES RUINES FENDUES (donjon final du ch5).
function cloven_ruins_entrance.Dungeon_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("cloven_ruins")
  UI:ResetSpeaker()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Voulez-vous entrer dans les Ruines Fendues ?", true)
  UI:WaitForChoice()
  local yesnoResult = UI:ChoiceResult()
  if yesnoResult then
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    if SV.ChapterProgression.Chapter == 5 and SV.Chapter5 ~= nil then
      SV.Chapter5.RuinsEntered = true
      pcall(function() GAME:UnlockDungeon("cloven_ruins") end)
    end
    SV.partner.Spawn = "Default"
    GAME:EnterDungeon("cloven_ruins", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- Rocher de Kangourex : sauvegarde + stockage.
function cloven_ruins_entrance.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return cloven_ruins_entrance
