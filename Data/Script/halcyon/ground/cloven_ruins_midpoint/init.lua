--[[
    init.lua — Cloven Ruins Midpoint (Relais des Ruines Tordues)
    Chapitre 7 — relais mi-donjon type Statue Kangourex.
    Modèle : searing_tunnel_midpoint / vast_steppe_midpoint (patron validé).
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.RelayScenes'

local cloven_ruins_midpoint = {}

function cloven_ruins_midpoint.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_cloven_ruins_midpoint <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function cloven_ruins_midpoint.Enter(map)
  if SV.Chapter7.RuinsMidState == 'DeathArrival' then
    SV.Chapter7.RuinsMidState = nil
    cloven_ruins_midpoint.WipedCutscene()
    return
  end
  if SV.Chapter7.RuinsMidpointState == nil then SV.Chapter7.RuinsMidpointState = 'FirstArrival' end
  if SV.Chapter7.RuinsMidpointState == 'FirstArrival' then
    SV.Chapter7.RuinsMidpointState = 'RepeatArrival'
    if SV.ChapterProgression.Chapter == 7 then
      -- Première halte pendant l'expédition du chapitre 7 : arrivée jouée.
      RelayScenes.DuoArrival({
        hero = {212, 456}, partner = {180, 456}, camera = {196, 400},
        walk = 56, title = true, music = 'In the Depths of the Pit.ogg',
        lines = {
          { spk='partner', emo='Normal', txt="Attends...[pause=10] le sol est plat, ici.[pause=0] Taillé.[pause=10] Quelqu'un a NIVELÉ cette esplanade au milieu des ruines.", wait=10 },
          { spk='partner', emo='Normal', txt="Et là, regarde ![pause=0] Un rocher de Kangourex.[pause=10] Intact.[pause=0] Pas une fissure, alors que tout le reste s'effondre autour." },
          { spk='hero', emo='Worried', txt="(Les bâtisseurs de ces ruines ont voulu que cet endroit survive.[pause=0] Pourquoi celui-ci et pas le reste ?)", wait=10 },
          { spk='partner', emo='Worried', txt="Tu as vu les veines dorées dans la pierre, en descendant ?[pause=0] Elles convergent toutes vers le bas...[pause=10] vers ce que la guilde appelle le Cœur." },
          { spk='partner', emo='Determined', txt="Déposons ce qui nous encombre et sauvegardons.[pause=0] Passé cette esplanade,[pause=10] je crois que les ruines ne nous laisseront plus faire demi-tour aussi facilement." },
        },
      })
    else
      -- Visite libre (rejouabilité) : découverte plus contemplative.
      RelayScenes.DuoArrival({
        hero = {212, 456}, partner = {180, 456}, camera = {196, 400},
        walk = 56, title = true, music = 'In the Depths of the Pit.ogg',
        lines = {
          { spk='partner', emo='Normal', txt="Une esplanade taillée au cordeau,[pause=10] en plein cœur des ruines...[pause=0] Les anciens bâtisseurs savaient ce qu'ils faisaient." },
          { spk='partner', emo='Normal', txt="Le rocher de Kangourex n'a pas bougé.[pause=0] Profitons-en avant de descendre plus bas." },
        },
      })
    end
  else
    GAME:FadeIn(20)
  end
end

function cloven_ruins_midpoint.Update(map)
end

function cloven_ruins_midpoint.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function cloven_ruins_midpoint.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

-- Sortie nord : continuer vers les profondeurs (segment 2)
function cloven_ruins_midpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Descendre dans les profondeurs des ruines ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:EnterDungeon("cloven_ruins", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- Sortie sud : retour à l'entrée des ruines
function cloven_ruins_midpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("cloven_ruins")
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous revenir\nà l'entrée de " .. zone:GetColoredName() .. " ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    SV.adventure.Thief = false
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:WaitFrames(60)
    GAME:EnterGroundMap("cloven_ruins_entrance", "Main_Entrance_Marker")
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- Rocher Kangourex : sauvegarde + stockage
function cloven_ruins_midpoint.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function cloven_ruins_midpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function cloven_ruins_midpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end

function cloven_ruins_midpoint.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end



--------------------------------------------------------------------
-- Réveil après une défaite au-delà du checkpoint (vague 8).
-- Le duo revient à lui près du Terminal, ranimé par ses réserves.
--------------------------------------------------------------------
function cloven_ruins_midpoint.WipedCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  GROUND:TeleportTo(hero, 160, 320, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, 192, 328, Direction.Right) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  GAME:MoveCamera(176, 312, 1, false)

  GAME:FadeIn(60)
  SOUND:PlayBGM('Heartwarming.ogg', true)
  GAME:WaitFrames(110)

  local coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.DoAnimation(hero, 'Wake')
    GAME:WaitFrames(12)
    GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(14)
    if partner ~= nil then
      GeneralFunctions.DoAnimation(partner, 'Wake')
      GAME:WaitFrames(12)
      GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
    end end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Pain")
  UI:WaitShowDialogue("Ces ruines...[pause=20] même le sol semblait vouloir qu'on parte.")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Les veines dorées dans la pierre...[pause=10] elles BRILLAIENT plus fort à mesure qu'on approchait.[pause=20] Comme un avertissement.")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Le Cœur des ruines est tout près, je le sens.[pause=20] Reposons-nous — puis finissons ce qu'on a commencé.")
  GAME:WaitFrames(14)
  GAME:WaitFrames(20)
  if partner ~= nil then AI:EnableCharacterAI(partner) end
  GAME:CutsceneMode(false)
  GAME:FadeIn(1)
end

return cloven_ruins_midpoint
