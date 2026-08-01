--[[
    init.lua — Cloven Ruins Entrance
    Entree des Ruines Fendues — Chapitre 5, climax de l'expedition
    ---------------------------------------------------------------
    Apres la victoire sur Tornadus, l'expedition etablit un campement
    devant l'entree (briefing strategique autour du feu, nuit, reve de
    Gardevoir, puis matin et entree dans le donjon final du ch5).
    La cinematique vit dans cloven_ruins_entrance_ch_5.lua (4 actes,
    gabarit valide du campement du Mont Venteux).
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.cloven_ruins_entrance.cloven_ruins_entrance_ch_5'

local cloven_ruins_entrance = {}

function cloven_ruins_entrance.Init(map)
  pcall(function() GAME:FadeOut(false, 1) end)
  pcall(function() GAME:CutsceneMode(true) end)
  COMMON.RespawnAllies()
  pcall(function() PartnerEssentials.InitializePartnerSpawn() end)
  -- Si aucune cinematique n'est a venir, on libere la main des
  -- maintenant (sinon le joueur resterait fige sur une carte montee).
  pcall(function()
    local sceneAVenir = false
    if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5 then
      local c5 = SV.Chapter5
      sceneAVenir = c5.RuinsCampPending
                 or (c5.RuinsCampNightDone and not c5.RuinsCampDone)
    end
    if not sceneAVenir then GAME:CutsceneMode(false) end
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

  -- ARRIVEE AU CAMP — la cinematique d'entree (briefing + nuit + reve).
  if c5.RuinsCampPending and not c5.RuinsCampDone then
    cloven_ruins_entrance_ch_5.SetupGround()
    cloven_ruins_entrance_ch_5.ArrivalCutscene()
    return
  end

  -- ETAT DE CAMP — le joueur est libre (apres la cinematique).
  cloven_ruins_entrance_ch_5.SetupGround()
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
  UI:ChoiceMenuYesNo("Voulez-vous entrer dans " .. zone:GetColoredName() .. " ?", true)
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
      --Le donjon final du ch5 doit etre debloque des l'entree depuis le
      --camp (l'Unlock historique se fait en ch6->ch7, trop tard ici).
      pcall(function() GAME:UnlockDungeon("cloven_ruins") end)
    end
    SV.partner.Spawn = "Default"
    GAME:EnterDungeon("cloven_ruins", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- Rocher de Kangourex : sauvegarde + stockage (inchangé).
function cloven_ruins_entrance.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

-- Actions des membres du camp (interactifs apres la cinematique).
function cloven_ruins_entrance.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function cloven_ruins_entrance.Tropius_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara, "Le camp est prêt.[pause=10] Et nous aussi.[pause=0] Les Ruines Fendues nous attendent depuis trop longtemps.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Noctowl_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara, "J'ai passé la nuit à relire mes notes.[pause=10] Les veines,[pause=10] la chaleur,[pause=10] l'orage...[pause=0] Tout converge ici.[pause=10] Ce n'est pas un hasard.", "Worried")
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Breloom_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara, "Ces ruines,[pause=10] je les connais par cœur.[pause=0] Et je n'y comprends toujours rien.[pause=10] Peut-être que vous,[pause=10] vous verrez ce que nous,[pause=10] on a manqué.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Girafarig_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara, "Mon arrière-tête n'aime pas ces ruines.[pause=10] Il dit qu'elles ont été creusées autour de quelque chose.[pause=0] Et que ça,[pause=10] ça n'a jamais été ouvert.[pause=10] Jusqu'à maintenant.", "Worried")
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Snubbull_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara, "Des ruines de plus.[pause=10] Celle-ci a intérêt à valoir le déplacement,[pause=0] après tout ce chemin.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Audino_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara, "J'ai préparé des baies pour tout le monde.[pause=10] On ne sait jamais,[pause=0] là-dedans.[pause=10] Revenez-moi entiers,[pause=10] c'est tout ce que je demande.", "Worried")
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Growlithe_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara, "J'ai relevé les gardes trois fois cette nuit,[pause=10] wouf.[pause=0] Les ruines n'ont pas bougé.[pause=10] Elles attendent,[pause=10] comme nous.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Zigzagoon_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara, "Ma mère m'a dit : «[pause=5] Ne reviens pas sans une bonne histoire.[pause=5] »[pause=10] Les Ruines Fendues,[pause=10] ça fera largement l'affaire.", "Happy")
  GeneralFunctions.EndConversation(chara)
end

-- Ganlon / Shuca : via l'IA d'equipe (talkToTeammate par espece).
function cloven_ruins_entrance.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  local who = nil
  pcall(function() who = LTBL(chara).Importance end)
  if who == nil or who == '' then
    pcall(function() who = chara.CurrentForm.Species end)
    if who == 'cranidos' then who = 'Cranidos'
    elseif who == 'mareep' then who = 'Mareep' end
  end
  if who == 'Cranidos' then
    GeneralFunctions.StartConversation(chara, "Mouais.[pause=10] Des ruines pleines de veines qui pulsent.[pause=0] On a connu mieux comme dernier camp,[pause=10] mais on est là.[pause=10] Alors on y va.", "Normal")
    GeneralFunctions.EndConversation(chara)
  else
    COMMON.GroundInteract(activator, chara, true)
  end
end

function cloven_ruins_entrance.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  local who = nil
  pcall(function() who = LTBL(chara).Importance end)
  if who == nil or who == '' then
    pcall(function() who = chara.CurrentForm.Species end)
    if who == 'cranidos' then who = 'Cranidos'
    elseif who == 'mareep' then who = 'Mareep' end
  end
  if who == 'Mareep' then
    GeneralFunctions.StartConversation(chara, "Regarde la lumière sur la pierre,[pause=10] le matin ![pause=0] On dirait que les ruines se réveillent avec nous.[pause=10] C'est bon signe,[pause=10] j'en suis sûre.", "Happy")
    GeneralFunctions.EndConversation(chara)
  else
    COMMON.GroundInteract(activator, chara, true)
  end
end

return cloven_ruins_entrance
