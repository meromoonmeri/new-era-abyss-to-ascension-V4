--[[
    init.lua — celestial_peak_relay
    Relais mi-donjon (patron searing_tunnel_midpoint) : Statue Kangourex,
    sortie avant vers le segment suivant, sortie arrière vers l'entrée.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.RelayScenes'
require 'halcyon.ReplayEnding'

local celestial_peak_relay = {}

function celestial_peak_relay.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_celestial_peak_relay <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function celestial_peak_relay.Enter(map)
  if SV.Chapter10.PeakMidState == 'DeathArrival' then
    SV.Chapter10.PeakMidState = nil
    celestial_peak_relay.WipedCutscene()
    return
  end
  if not SV.Chapter10.PlayedPeakRelayIntro then
    SV.Chapter10.PlayedPeakRelayIntro = true
    if SV.ChapterProgression.Chapter == 10 then
      -- Première halte pendant l'ascension du chapitre 10 : arrivée jouée.
      RelayScenes.DuoArrival({
        hero = {212, 304}, partner = {180, 304}, camera = {196, 250},
        walk = 48, title = true, music = 'Summit.ogg',
        lines = {
          { spk='partner', emo='Normal', txt="On est au-dessus des nuages...[pause=20] Regarde,[pause=10] la mer de brume s'étend jusqu'à l'horizon.[pause=0] Metano doit être quelque part là-dessous.", wait=10 },
          { spk='partner', emo='Normal', txt="Une statue de Kangourex,[pause=10] plantée face aux vents.[pause=0] Qui a bien pu la hisser jusqu'ici ?" },
          { spk='hero', emo='Worried', txt="(L'air se raréfie.[pause=0] Chaque pas coûtera plus cher là-haut...[pause=10] et l'Escouade Fulgur ne nous attendra pas.)", wait=10 },
          { spk='partner', emo='Worried', txt="Tu as entendu leurs cris tout à l'heure, plus haut sur la paroi ?[pause=0] Ils grimpent vite.[pause=10] Trop vite.[pause=0] Comme s'ils savaient exactement ce qui les attend au sommet." },
          { spk='partner', emo='Determined', txt="Alors pas de temps à perdre — mais pas d'imprudence non plus.[pause=0] On sauvegarde,[pause=10] on souffle un coup,[pause=10] et on va montrer à ce pic ce qu'on vaut." },
        },
      })
    else
      -- Visite libre : le pic est redevenu silencieux.
      RelayScenes.DuoArrival({
        hero = {212, 304}, partner = {180, 304}, camera = {196, 250},
        walk = 48, title = true, music = 'Summit.ogg',
        lines = {
          { spk='partner', emo='Normal', txt="Le relais des nuages...[pause=0] La vue me coupe le souffle à chaque fois." },
          { spk='partner', emo='Happy', txt="Le vent est presque doux aujourd'hui.[pause=0] Reprenons des forces avant l'ascension." },
        },
      })
    end
  else
    GAME:FadeIn(20)
  end
end

function celestial_peak_relay.Update(map, time) end

function celestial_peak_relay.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function celestial_peak_relay.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

function celestial_peak_relay.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous continuer ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    -- Le relais sert deux fois : avant la Mer de Nuages (segment 2),
    -- puis après la course contre l'Escouade Fulgur (segment 4, Sommet Sacré).
    local nextSegment = 2
    if ReplayEnding.IsReplay('celestial_peak', 10) then
      -- Rejouabilite : OutranEscouadeFulgur est vrai pour toujours, il ne peut
      -- donc plus servir de reperage. Sans ce cas, le relais sautait droit au
      -- segment 4 et la Mer de Nuages (segment 2) devenait injouable.
      -- On suit un compteur de passage propre a la partie rejouee.
      if SV.Chapter10.ReplayPastFulgur then nextSegment = 4 else nextSegment = 2 end
    elseif SV.Chapter10.OutranEscouadeFulgur then
      nextSegment = 4
    end
    GAME:EnterDungeon("celestial_peak", nextSegment, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function celestial_peak_relay.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("celestial_peak")
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
    GAME:EnterGroundMap("celestial_peak_entrance", "Main_Entrance_Marker")
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function celestial_peak_relay.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function celestial_peak_relay.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function celestial_peak_relay.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end

function celestial_peak_relay.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end



--------------------------------------------------------------------
-- Réveil après une défaite au-delà du checkpoint (vague 8).
-- Le duo revient à lui près du Terminal, ranimé par ses réserves.
--------------------------------------------------------------------
function celestial_peak_relay.WipedCutscene()

	--LE NOIR AVANT TOUTE MISE EN PLACE (correctif de retour de boss,
	--2026-07-30). Cette scene est jouee juste apres un EndSegment /
	--EnterZone : le moteur a pose le noir, mais rien ne le REPOSE ici.
	--Elle enchaine pourtant plusieurs appels moteur (creation de PNJ,
	--TeleportTo, MoveCamera, StopBGM) avant son FadeIn. GAME:FadeOut
	--etant bloquant (ScriptGame.cs:1590) et FadeInternal rendant la
	--main a chaque frame (FadeEffect.cs:30-42), ces appels laissent
	--passer des frames RENDUES sur une carte en cours de montage —
	--c'est l'apercu de zone signale en jeu. FadeOut(false,1) sur un
	--ecran deja noir est un no-op (FadeEffect.cs:63) : gratuit si le
	--noir a tenu, salvateur sinon.
	pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

    -- Fix audit 2026-07-27 : l'ancienne position du partenaire chevauchait le
  -- collider du rocher Kangourex. Positions libres verifiees (flood-check).
  GROUND:TeleportTo(hero, 88, 272, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, 120, 272, Direction.Right) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  GAME:MoveCamera(104, 264, 1, false)

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
  UI:WaitShowDialogue("L'air...[pause=10] il n'y a presque plus d'air, là-haut...")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("On est retombés jusqu'à la corniche.[pause=20] Le Pic nous a repoussés — pas par méchanceté...[pause=10] on n'était juste pas prêts.")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format("Alors on se prépare.[pause=20] Respire, {0}.[pause=10] Le ciel, lui, ne bouge pas.", CH('PLAYER'):GetDisplayName()))
  GAME:WaitFrames(14)
  GAME:WaitFrames(20)
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
    PartnerEssentials.SaveGamePartnerPosition(partner)
  end
  GAME:CutsceneMode(false)
  GAME:FadeIn(1)
end

return celestial_peak_relay
