--[[
    init.lua — celestial_peak_relay
    Relais du Pic Céleste — Chapitre 10
    VERSION UNIQUE BIOME 2026-07-30 — Exigence unicité totale.

    IDENTITÉ UNIQUE — La Corniche au-dessus de la Mer de Nuages :
    - Position exacte : charnière contreforts avec course Fulgur (seg0-2) → arènes
      Fulgur + Lugia (seg4-6). Exact : corniche au-dessus mer de nuages, réutilisée
      post-Fulgur seg4. Dernier relais avant arène boss doit porter tension approche finale (prompt §6).
    - Élément distinctif 1 : Mer de nuages visible en bas carte — BG Genesis_Fade + Steam,
      tiles nuages sud, vide sous pieds. On comprend qu'on est au-dessus nuages.
      Aucun autre relais n'a mer de nuages. Compatible cinématique arrivée ch10 (vent).
    - Élément distinctif 2 : Autel venteux — formation roche plate face vents, utilisée comme
      table vent, drapeau Fulgur arraché trace rivaux. Socle pour jugement Lugia.
    - Élément distinctif 3 : Traces Escouade Fulgur — empreintes griffes Luxray sur roche,
      éclair sur roche jauni bs_plant.8.png + trace brûlure. Preuve course.
    - Élément distinctif 4 : Vent permanent SE5_Wind_Background + Snow_Fall dévié vent,
      particules traversent écran droite→gauche. Ici vent porte voix Fulgur.
    - Disposition ADAPTÉE topo : camp en ligne contre paroi nord (abri vent sud), feu ancré
      vent (pierre lourde autour), sacs alignés paroi, Kangaskhan face vide (regarde nuages
      + mer), entrée sud large (arrivée contreforts), sortie nord étroite corniche (tension
      §6 : dernier relais avant arène doit annoncer combat à venir).
    - Faune : Swablu + Wingull emportés vent mais luttent, Drifloon lointain ciel,
      inoffensifs, cohérents ciel. Nichés derrière autel vent.

    FONCTIONS : PP + ventre via Kangaskhan face nuages, faune ciel.
    TRACE : course Escouade Fulgur, Lugia juge légitimité, vision Necrozma.
    Dernier relais avant arène : porte tension approche finale par vide sous pieds + vent.

    Base : guildmaster_summit (408x384 Summit) → enrichi mer nuages + autel vent + traces Fulgur
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.RelayScenes'
require 'halcyon.BossFX'
require 'halcyon.ReplayEnding'

local celestial_peak_relay = {}

function celestial_peak_relay.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_celestial_peak_relay UNIQ 2026-07-30 <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()

  pcall(function()
    BossFX.Overlay('SE5_Wind_Background', 0, 0, 20, 600, 60, 1, -180, 0)
  end)
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
      RelayScenes.DuoArrival({
        hero = {212, 304}, partner = {180, 304}, camera = {196, 200},
        walk = 48, title = true, music = 'Summit.ogg',
        lines = {
          { spk='partner', emo='Surprised', txt="On est... au-dessus des nuages... Regarde la mer de brume en bas, jusqu'à l'horizon. Metano doit être quelque part là-dessous, sous cette nappe blanche.", wait=12 },
          { spk='partner', emo='Normal', txt="Une statue de Kangourex plantée face aux vents, face au vide. Qui a bien pu la hisser jusqu'à cette corniche au-dessus de la mer de nuages ?", wait=10 },
          { spk='hero', emo='Worried', txt="(L'autel venteux au centre — roche plate face aux vents, et ce drapeau déchiré jaune accroché. Traces de griffes Luxray... L'Escouade Fulgur est passée ici. Et ce jaune brûlé sur la roche ?)", wait=12 },
          { spk='partner', emo='Worried', txt="Tu as entendu leurs cris tout à l'heure, plus haut sur la paroi ? Ils grimpent vite. Trop vite. Comme s'ils savaient exactement où est la mer de nuages et l'autel que Lugia jugera.", wait=10 },
          { spk='partner', emo='Normal', txt="Le camp est en ligne contre la paroi nord, abrité du vent sud qui porte la voix. Feu ancré avec pierres lourdes, sinon il s'envole. Intelligent. Dernier abri avant le ciel.", wait=10 },
          { spk='partner', emo='Determined', txt="Alors pas de temps à perdre. PP, ventre restaurés au Kangourex face aux nuages, puis on part maintenant par la corniche étroite nord. Dernière ligne droite avant Lugia. Le vide sous nos pieds porte la tension du combat à venir.", wait=10 },
        },
      })
    else
      RelayScenes.DuoArrival({
        hero = {212, 304}, partner = {180, 304}, camera = {196, 200},
        walk = 48, title = true, music = 'Summit.ogg',
        lines = {
          { spk='partner', emo='Normal', txt="La Corniche au-dessus de la Mer de Nuages... même apaisée, elle garde ce vide sous les pieds et ce vent qui porte les voix de Fulgur.", wait=10 },
          { spk='partner', emo='Normal', txt="L'autel venteux, les traces de Luxray, le drapeau déchiré... et le Kangourex face aux nuages qui veille. On s'y restaure, en ligne contre la paroi nord.", wait=10 },
        },
      })
    end
  else
    GAME:FadeIn(20)
  end
end

function celestial_peak_relay.Update(map) end

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
  UI:ChoiceMenuYesNo("Passer la corniche étroite nord par-delà\nla mer de nuages, vers l'arène de Lugia ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:EnterDungeon("celestial_peak", 4, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
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
  UI:ChoiceMenuYesNo("Redescendre vers les contreforts\nsous la mer de nuages ?", true)
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
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "La Corniche au-dessus de la Mer de Nuages...[pause=10] Vide sous les pieds, vent qui porte voix Fulgur, autel venteux avec traces Luxray et drapeau déchiré.[pause=0] Dernière marche avant Lugia.", "Worried")
  UI:WaitShowDialogue("Le camp en ligne contre paroi nord, feu ancré pierres lourdes, Kangourex face au vide qui brise lumière — PP, ventre restaurés ici, en regardant la mer de nuages. C'est magnifique et terrifiant à la fois. Exactement comme doit être un dernier relais avant boss final.")
  GeneralFunctions.EndConversation(chara)
end

function celestial_peak_relay.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Swablu luttent contre vent fissure,[pause=10] inoffensifs.[pause=0] Ils nichent derrière autel venteux, comme nous.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function celestial_peak_relay.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "La mer de nuages en bas...[pause=10] On dirait qu'on marche au ciel. Lugia nous jugera-t-il dignes de ce ciel ?", "Worried")
  GeneralFunctions.EndConversation(chara)
end

function celestial_peak_relay.WipedCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

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
  UI:WaitShowDialogue("La mer de nuages...[pause=20] on a failli y tomber depuis la corniche étroite north...")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("L'autel venteux nous a retenus... le vent de la fissure nous a rabattus vers la paroi nord. Le camp en ligne a tenu. Le Kangourex face aux nuages aussi.")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Dernier relais avant Lugia. On ne tombe pas maintenant. On restaure PP et ventre face au vide, puis on repart par la corniche étroite. Le ciel nous attend.")
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
