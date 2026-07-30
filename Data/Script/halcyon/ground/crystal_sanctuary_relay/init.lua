--[[
    init.lua — crystal_sanctuary_relay
    Relais mi-donjon (patron searing_tunnel_midpoint) : Statue Kangourex,
    sortie avant vers le segment suivant, sortie arrière vers l'entrée.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.RelayScenes'

local crystal_sanctuary_relay = {}

function crystal_sanctuary_relay.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_crystal_sanctuary_relay <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function crystal_sanctuary_relay.Enter(map)
  if SV.Chapter8.SanctuaryMidState == 'DeathArrival' then
    SV.Chapter8.SanctuaryMidState = nil
    crystal_sanctuary_relay.WipedCutscene()
    return
  end
  if not SV.Chapter8.PlayedSanctuaryRelayIntro then
    SV.Chapter8.PlayedSanctuaryRelayIntro = true
    if SV.ChapterProgression.Chapter == 8 then
      -- Première halte pendant l'expédition du chapitre 8 : arrivée jouée.
      RelayScenes.DuoArrival({
        hero = {308, 628}, partner = {276, 628}, camera = {292, 560},
        walk = 56, title = true, music = 'Snow Camp.ogg',
        lines = {
          { spk='partner', emo='Normal', txt="Écoute...[pause=20] Les cristaux ont cessé de chanter.[pause=0] C'est la première fois depuis l'entrée qu'ils se taisent.", wait=10 },
          { spk='partner', emo='Normal', txt="Une statue de Kangourex,[pause=10] ici...[pause=0] La lumière la traverse et se brise en petits arcs-en-ciel.[pause=10] On dirait qu'elle veille sur cette salle." },
          { spk='hero', emo='Normal', txt="(Ce silence n'est pas vide.[pause=0] C'est un silence... respectueux.[pause=10] Comme si le sanctuaire retenait son souffle.)", wait=10 },
          { spk='partner', emo='Worried', txt="La gardienne dont parlait la mission ne doit plus être loin.[pause=0] Chaque galerie était plus lumineuse que la précédente...[pause=10] On approche du foyer de cette lumière." },
          { spk='partner', emo='Determined', txt="Sauvegardons et trions le sac.[pause=0] Face à quelqu'un capable de faire chanter la pierre,[pause=10] je préfère qu'on soit prêts à tout." },
        },
      })
    else
      -- Visite libre : le sanctuaire est apaisé.
      RelayScenes.DuoArrival({
        hero = {308, 628}, partner = {276, 628}, camera = {292, 560},
        walk = 56, title = true, music = 'Snow Camp.ogg',
        lines = {
          { spk='partner', emo='Normal', txt="Cette salle n'a pas changé.[pause=0] La statue,[pause=10] les prismes,[pause=10] ce calme presque sacré..." },
          { spk='partner', emo='Happy', txt="C'est fou comme on respire mieux ici.[pause=0] Reposons-nous un instant avant de continuer." },
        },
      })
    end
  else
    GAME:FadeIn(20)
  end
end

function crystal_sanctuary_relay.Update(map, time) end

function crystal_sanctuary_relay.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function crystal_sanctuary_relay.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

function crystal_sanctuary_relay.North_Exit_Touch(obj, activator)
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
    GAME:EnterDungeon("crystal_sanctuary", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function crystal_sanctuary_relay.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crystal_sanctuary")
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
    GAME:EnterGroundMap("crystal_sanctuary_entrance", "Main_Entrance_Marker")
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function crystal_sanctuary_relay.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function crystal_sanctuary_relay.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function crystal_sanctuary_relay.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end

function crystal_sanctuary_relay.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end



--------------------------------------------------------------------
-- Réveil après une défaite au-delà du checkpoint (vague 8).
-- Le duo revient à lui près du Terminal, ranimé par ses réserves.
--------------------------------------------------------------------
function crystal_sanctuary_relay.WipedCutscene()

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
  GROUND:TeleportTo(hero, 408, 152, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, 440, 152, Direction.Right) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  GAME:MoveCamera(424, 144, 1, false)

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
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue("Les cristaux...[pause=20] ils chantaient encore quand tout est devenu noir.")
  GAME:WaitFrames(14)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("C'est la gardienne qui a ramené la lumière autour de nous.[pause=10] Je crois...[pause=20] je crois qu'elle nous OBSERVE, {0}.", CH('PLAYER'):GetDisplayName()))
  GAME:WaitFrames(14)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue("Alors on va lui montrer qui nous sommes.[pause=20] Debout.[pause=10] Le Sanctuaire attend.")
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

return crystal_sanctuary_relay
