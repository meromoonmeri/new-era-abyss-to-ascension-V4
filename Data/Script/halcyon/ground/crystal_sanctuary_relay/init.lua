--[[
    init.lua — crystal_sanctuary_relay
    Relais du Sanctuaire de Cristal — Chapitre 8
    VERSION UNIQUE BIOME 2026-07-30 — Exigence unicité totale.

    IDENTITÉ UNIQUE — La Chambre où les Cristaux se Taisent :
    - Position exacte : charnière galeries chantantes (seg0) → salle glyphes silencieuse (seg2)
      Exact : chambre où cristaux cessent de chanter — silence respectueux, seul endroit où
      on entend son propre souffle. Transition bruit → silence.
    - Élément distinctif 1 : Cristaux muets — Anima_Core éteints Core_Deactivation au centre,
      alors que précédents segments avaient Core_Activation lumineux. Contraste fort.
      Aucun autre relais n'a cristaux muets.
    - Élément distinctif 2 : Sol gelé partiel + reflets bleutés Genesis_Cores BG, reflets
      arc-en-ciel au sol quand lumière passe. Tiles glace fine.
    - Élément distinctif 3 : Écho — plafond haut, SE léger écho quand marche. Ici le silence
      n'est pas vide, c'est un silence qui retient son souffle (dialogue partenaire).
    - Élément distinctif 4 : Statue Kangourex qui capte lumière et la brise en arcs-en-ciel
      (prismes). La lumière la traverse — seule statue translucide.
    - Disposition ADAPTÉE topo : cercle autour cristaux muets (respect), feu petit au bord
      (peur de faire fondre glace), sacs à l'écart reflets pour pas briser, Kangaskhan à
      l'écart reflets mais visible, entrée sud via cascade sans bruit (Crystal Crossing),
      sortie nord via fente où lumière bat.
    - Faune : Carbink inoffensif endormi sur glace + Snom qui fait cercle, non agressifs,
      cohérents cristal/neige. Particules Leaf_Fall bleutées lentes.

    FONCTIONS GAMEPLAY : PP + ventre via Kangaskhan, faune inoffensive cristal.
    TRACE : Diancie, réserve d'Anima cristallisée, pureté.

    Base : final_stop (600x648 SnowCamp) → enrichi cristaux muets + reflets
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.RelayScenes'
require 'halcyon.BossFX'

local crystal_sanctuary_relay = {}

function crystal_sanctuary_relay.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_crystal_sanctuary_relay UNIQ 2026-07-30 <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()

  pcall(function()
    local obj = RogueEssence.Content.ObjAnimData('Core_Deactivation', 4)
    GAME:GetCurrentGround().Decorations[0].Anims:Add(
      RogueEssence.Ground.GroundAnim(obj, RogueElements.Loc(300, 560)))
    local obj2 = RogueEssence.Content.ObjAnimData('Anima_Core', 4)
    GAME:GetCurrentGround().Decorations[0].Anims:Add(
      RogueEssence.Ground.GroundAnim(obj2, RogueElements.Loc(284, 576)))
  end)
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
      RelayScenes.DuoArrival({
        hero = {308, 628}, partner = {276, 628}, camera = {292, 540},
        walk = 56, title = true, music = 'Snow Camp.ogg',
        lines = {
          { spk='partner', emo='Surprised', txt="...Chut.[pause=20] Écoute.", wait=15 },
          { spk='partner', emo='Normal', txt="Les cristaux ont cessé de chanter. C'est la première fois depuis la cascade silencieuse qu'ils se taisent. Le silence n'est pas vide — il retient son souffle.", wait=12 },
          { spk='hero', emo='Worried', txt="(Les Anima Cores au centre... éteints. Core_Deactivation. Partout ailleurs ils brillaient Core_Activation. Ici, ils sont muets. Comme éteints exprès.)", wait=12 },
          { spk='partner', emo='Normal', txt="Et le sol gelé partiel — regarde les reflets bleutés, les arcs-en-ciel qui traversent la statue de Kangourex. La lumière la traverse et se brise. Elle veille sur cette chambre sans chanter.", wait=10 },
          { spk='partner', emo='Worried', txt="La gardienne dont parlait la mission — Diancie — ne doit plus être loin. Chaque galerie était plus lumineuse, ici c'est le foyer éteint. On approche du cœur où la lumière dort.", wait=10 },
          { spk='partner', emo='Determined', txt="Restaurons-nous — PP, ventre, stockage au Kangourex translucide. Face à quelqu'un capable de faire taire la pierre, je préfère qu'on soit prêts à tout, en silence.", wait=10 },
        },
      })
    else
      RelayScenes.DuoArrival({
        hero = {308, 628}, partner = {276, 628}, camera = {292, 540},
        walk = 56, title = true, music = 'Snow Camp.ogg',
        lines = {
          { spk='partner', emo='Normal', txt="La Chambre où les Cristaux se Taisent... même vide, elle impose ce silence respectueux. Les Cores muets au centre et le Kangourex d'arc-en-ciel qui veille.", wait=10 },
          { spk='partner', emo='Happy', txt="Les Carbink dorment encore sur la glace fine, les Snom tournent en cercle bleu. C'est le seul relais où le froid berce au lieu de mordre. Reposons-nous.", wait=10 },
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
  UI:ChoiceMenuYesNo("Continuer par la fente où la lumière bleue bat,\nvers la salle des glyphes de Diancie ?", true)
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
  UI:ChoiceMenuYesNo("Revenir à la cascade sans bruit\nqui marque l'entrée du Sanctuaire ?", true)
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
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Les cristaux muets au centre...[pause=10] Core_Deactivation, éteints exprès.[pause=0] Partout ailleurs ils chantaient, ici ils se taisent.[pause=10] Comme si le sanctuaire retenait son souffle avant Diancie.", "Worried")
  UI:WaitShowDialogue("Et le Kangourex translucide qui brise la lumière en arcs-en-ciel...[pause=10] PP et ventre restaurés ici, mais doucement. On ne brise pas ce silence, on le respecte.")
  GeneralFunctions.EndConversation(chara)
end

function crystal_sanctuary_relay.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Carbink dorment sur la glace,[pause=10] inoffensifs.[pause=0] Ils rêvent de la lumière qui bat derrière la fente nord.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function crystal_sanctuary_relay.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Le sol gelé partiel reflète nos visages bleutés...[pause=10] On dirait que le sanctuaire nous observe en silence.", "Worried")
  GeneralFunctions.EndConversation(chara)
end

function crystal_sanctuary_relay.WipedCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

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
  UI:SetSpeakerEmotion("Pain")
  UI:WaitShowDialogue("Les cristaux muets... ils chantaient encore quand tout est devenu noir dans la Chambre qui se tait.")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("C'est la gardienne Diancie qui a ramené la lumière bleue autour de nous.[pause=10] Dans la chambre où les cristaux se taisent, je crois qu'elle nous OBSERVE, {0}.", CH('PLAYER'):GetDisplayName()))
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Alors on va lui montrer qui nous sommes, sous les arcs-en-ciel du Kangourex translucide. Debout. Le Sanctuaire aux cristaux muets attend.")
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
