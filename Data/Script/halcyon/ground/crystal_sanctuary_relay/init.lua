--[[
    init.lua — waterfall_pond_relay
    Relais mi-donjon (patron searing_tunnel_midpoint) : Statue Kangourex,
    sortie avant vers le segment suivant, sortie arrière vers l'entrée.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.RelayScenes'
require 'halcyon.MidpointTemplate'

local waterfall_pond_relay = {}

--------------------------------------------------------------------
-- HABILLAGE DU POINT MEDIAN — Sanctuaire de Cristal (600x648)
--
-- STRUCTURE : halcyon.MidpointTemplate, commune a tous les relais.
-- HABILLAGE : propre a ce biome, jamais recopie tel quel ailleurs.
--
--   Biome     : salle de cristal sous la roche. Le calme y vient de la
--               PIERRE CHANTANTE : les prismes cessent de vibrer, et
--               c'est ce silence-la qui signale le palier.
--   Ambiance  : 'winter_snow' — poussiere de cristal en suspension, propre
--               a ce sanctuaire. Aucun autre relais ne l'emploie.
--   Musique   : 'Snow Camp.ogg', deja utilisee par l'arrivee de ce relais.
--
-- Positions reprises de l'arrivee existante (deja verifiees).
--------------------------------------------------------------------
local RELAY_SKIN = {
  music     = 'Snow Camp.ogg',
  wakeMusic = 'Heartwarming.ogg',
  status    = 'winter_snow',
  hero      = {308, 628},
  partner   = {276, 628},
  camera    = {292, 560},
  walk      = 56,
}

function waterfall_pond_relay.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_waterfall_pond_relay <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function waterfall_pond_relay.Enter(map)
  if SV.Chapter8.SanctuaryMidState == 'DeathArrival' then
    SV.Chapter8.SanctuaryMidState = nil
    waterfall_pond_relay.WipedCutscene()
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
  elseif SV.Chapter8.SanctuaryMidReturn then
    --ETAT « RepeatArrival » DU TEMPLATE — retour a l'amiable
    --(repli volontaire, ou reprise d'une sauvegarde faite ici).
    --Ce relais ne connaissait que l'arrivee et le reveil apres KO :
    --revenir sur ses pas ne donnait qu'un fondu muet.
    SV.Chapter8.SanctuaryMidReturn = false
    local partner = CH('Teammate1')
    MidpointTemplate.RepeatArrival({
      skin = RELAY_SKIN,
      lines = {
        { who = partner, spk = 'partner', emo = 'Normal',
          txt = "Les cristaux se sont tus de nouveau.[pause=0] On est revenus au bon endroit.", wait = 10 },
        { who = partner, spk = 'partner', emo = 'Normal',
          txt = "La statue n'a pas bougé.[pause=0] Sauvegardons avant de repartir vers la gardienne." },
      },
    })
  else
    GAME:FadeIn(20)
  end
end

function waterfall_pond_relay.Update(map, time) end

function waterfall_pond_relay.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

-- Reprise d'une sauvegarde faite AU relais : sortie a l'amiable.
-- On arme le retour sobre du template plutot qu'un fondu muet.
function waterfall_pond_relay.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  if SV.Chapter8.PlayedSanctuaryRelayIntro and SV.Chapter8.SanctuaryMidState ~= 'DeathArrival' then
    SV.Chapter8.SanctuaryMidReturn = true
  end
  waterfall_pond_relay.Enter(map)
end

function waterfall_pond_relay.North_Exit_Touch(obj, activator)
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
    GAME:EnterDungeon("waterfall_pond", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function waterfall_pond_relay.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("waterfall_pond")
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous revenir\nà l'entrée de " .. zone:GetColoredName() .. " ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    SV.adventure.Thief = false
    --Repli VOLONTAIRE : sortie a l'amiable, on arme le retour sobre
    --du template pour la prochaine venue au relais.
    SV.Chapter8.SanctuaryMidReturn = true
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:WaitFrames(60)
    GAME:EnterGroundMap("metano_town", "Main_Entrance_Marker")
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function waterfall_pond_relay.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function waterfall_pond_relay.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function waterfall_pond_relay.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end

function waterfall_pond_relay.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.GroundInteract(activator, chara)
end



--------------------------------------------------------------------
-- Réveil après une défaite au-delà du checkpoint (vague 8).
-- Le duo revient à lui près du Terminal, ranimé par ses réserves.
--------------------------------------------------------------------
function waterfall_pond_relay.WipedCutscene()

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

return waterfall_pond_relay
