--[[
    init.lua — forgotten_marsh_relay
    Relais du Marais de l'Oubli — Chapitre 9
    VERSION UNIQUE BIOME 2026-07-30 — Exigence unicité totale.

    IDENTITÉ UNIQUE — L'Îlot aux Racines que la Brume n'ose pas :
    - Position exacte : charnière berges vaseuses avec roseaux couchés même sens sans vent (seg0)
      → abysses vaseux (seg2). Exact : îlot de terre ferme que brume n'ose pas entrer,
      seul endroit sec du marais.
    - Élément distinctif 1 : Îlot aux Racines — racines émergées formant berceau ovalaire,
      terre ferme au milieu eau croupie. Formation naturelle berceau. Unique.
    - Élément distinctif 2 : Eau croupie autour avec bulles lentes ps_bubble.7.png,
      odeur sucrée fausse, fleurs qui fanent d'un seul côté (Gloom). Eau morte.
    - Élément distinctif 3 : Roseaux couchés tous même sens autour îlot — décor orienté,
      même sens sans vent, trace passage lourd léger (Cercle Suaire). Orientés vers îlot.
    - Élément distinctif 4 : Empreintes qui s'arrêtent au bord îlot — traces Cercle Suaire
      (Banette/Ectoplasma/Nostenfer) qui évitent îlot, n'osent pas entrer. Preuve respect/peur.
    - Disposition ADAPTÉE topo : ovalaire suivant racines berceau, camp sur îlot central,
      Kangaskhan au centre îlot (seul endroit sûr), feu surélevé sur pierre (pas dans vase),
      entrée sud par sentier vaseux qui s'assèche vers îlot, sortie nord via racines.
    - Faune : Croagunk inoffensif patauge vase + Toxel lointain + Grimer qui évite îlot,
      cohérents marais. Non agressifs. Rangent bulle.

    FONCTIONS : PP + ventre via Kangaskhan centre îlot, faune marais.
    TRACE : Gloom brume trois silhouettes + fleurs fanent un côté → ce relais matérialise
    Cercle Suaire qui cherche fragments. Odeur encens froid.

    Base : end_ambush_forest (408x432) → enrichi îlot racines + bulles + roseaux orientés
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.RelayScenes'
require 'halcyon.BossFX'

local forgotten_marsh_relay = {}

function forgotten_marsh_relay.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_forgotten_marsh_relay UNIQ 2026-07-30 <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()

  pcall(function()
    local obj = RogueEssence.Content.ObjAnimData('Anima_Root', 4)
    GAME:GetCurrentGround().Decorations[0].Anims:Add(
      RogueEssence.Ground.GroundAnim(obj, RogueElements.Loc(196, 340)))
  end)
end

function forgotten_marsh_relay.Enter(map)
  if SV.Chapter9.MarshMidState == 'DeathArrival' then
    SV.Chapter9.MarshMidState = nil
    forgotten_marsh_relay.WipedCutscene()
    return
  end
  if not SV.Chapter9.PlayedMarshRelayIntro then
    SV.Chapter9.PlayedMarshRelayIntro = true
    if SV.ChapterProgression.Chapter == 9 then
      RelayScenes.DuoArrival({
        hero = {212, 408}, partner = {180, 408}, camera = {196, 330},
        walk = 56, title = true, music = 'Cave Camp.ogg',
        lines = {
          { spk='partner', emo='Worried', txt="L'odeur...[pause=10] sucrée et fausse... elle s'écarte enfin.[pause=0] Depuis les berges elle nous collait aux épaules.", wait=12 },
          { spk='partner', emo='Surprised', txt="Un îlot... de terre ferme au milieu de l'eau morte. Les racines émergées forment un berceau, un abri ovalaire. Même la brume n'ose pas entrer dedans.", wait=12 },
          { spk='hero', emo='Worried', txt="(Les roseaux couchés autour... tous dans le même sens, vers l'îlot. Sans vent. Quelque chose est passé là, lourd et léger à la fois, et a évité l'îlot. Les empreintes s'arrêtent au bord.)", wait=12 },
          { spk='partner', emo='Worried', txt="Tu penses au Cercle, toi aussi ? Banette, Ectoplasma, Nostenfer... ils marchent dans la vase sans laisser d'empreinte, sauf autour de cet îlot qu'ils n'osent pas fouler. Ça me glace.", wait=12 },
          { spk='partner', emo='Normal', txt="Une statue de Kangourex au centre du berceau, surélevée sur pierre — seul endroit sûr. Et l'eau croupie qui bulle lentement tout autour. Même les Grimer évitent l'îlot.", wait=10 },
          { spk='partner', emo='Determined', txt="Raison de plus pour ne rien laisser au hasard. Sauvegarde au centre, PP et ventre restaurés, et on avance par les racines nord quand on sera prêts. Ce berceau nous protège.", wait=10 },
        },
      })
    else
      RelayScenes.DuoArrival({
        hero = {212, 408}, partner = {180, 408}, camera = {196, 330},
        walk = 56, title = true, music = 'Cave Camp.ogg',
        lines = {
          { spk='partner', emo='Normal', txt="L'Îlot aux Racines que la brume n'ose pas... même apaisé, il garde ce berceau ovalaire, ces bulles lentes, ces roseaux couchés vers lui.", wait=10 },
          { spk='partner', emo='Normal', txt="Le Kangourex au centre sur pierre, les Croagunk qui pataugent inoffensifs dans la vase. Seul endroit sec du marais. On s'y restaure bien.", wait=10 },
        },
      })
    end
  else
    GAME:FadeIn(20)
  end
end

function forgotten_marsh_relay.Update(map) end

function forgotten_marsh_relay.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function forgotten_marsh_relay.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

function forgotten_marsh_relay.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Quitter le berceau de racines par le nord,\nvers les abysses vaseux où le Cercle rôde ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:EnterDungeon("forgotten_marsh", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function forgotten_marsh_relay.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("forgotten_marsh")
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Revenir aux berges vaseuses par le sentier\nqui s'assèche vers le sud ?", true)
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
    GAME:EnterGroundMap("forgotten_marsh_entrance", "Main_Entrance_Marker")
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function forgotten_marsh_relay.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function forgotten_marsh_relay.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "L'Îlot aux Racines...[pause=10] berceau ovalaire de racines émergées,[pause=10] seul endroit sec. La brume ne franchit pas les racines, même les empreintes s'arrêtent au bord.", "Worried")
  UI:WaitShowDialogue("Les roseaux couchés tous même sens vers l'îlot,[pause=10] l'eau croupie qui bulle,[pause=10] les fleurs qui fanent d'un seul côté — tout ce que Gloom disait au bourg se retrouve ici, mais autour, pas dedans. Le Kangourex centre sur pierre nous restaure — PP, ventre — à l'abri.")
  GeneralFunctions.EndConversation(chara)
end

function forgotten_marsh_relay.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Croagunk patauge inoffensif,[pause=10] il évite le berceau.[pause=0] Même les Grimer ont peur de cet îlot. Il y a quelque chose ici que le marais respecte.", "Worried")
  GeneralFunctions.EndConversation(chara)
end

function forgotten_marsh_relay.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "L'odeur sucrée fausse vient de l'eau qui bulle,[pause=10] mais pas du berceau.[pause=0] Le berceau sent la terre sèche, la racine. C'est le seul endroit qui sent vrai ici.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function forgotten_marsh_relay.WipedCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  GROUND:TeleportTo(hero, 136, 224, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, 168, 224, Direction.Right) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  GAME:MoveCamera(152, 216, 1, false)

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
  UI:WaitShowDialogue("Le marais...[pause=20] il nous a avalés par les berges vaseuses... l'eau croupie...")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Mais l'Îlot aux Racines... le berceau a tenu. Les racines émergées nous ont empêchés de sombrer. Les Croagunk nous ont poussés vers le centre.")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Le Cercle rôde hors du berceau, mais pas dedans. On est en sécurité sur l'îlot sec. Reposons-nous au Kangourex sur pierre — PP, ventre — puis on repart par les racines nord.")
  GAME:WaitFrames(20)
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
    PartnerEssentials.SaveGamePartnerPosition(partner)
  end
  GAME:CutsceneMode(false)
  GAME:FadeIn(1)
end

return forgotten_marsh_relay
