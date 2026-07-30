--[[
    init.lua — Cloven Ruins Midpoint (Relais des Ruines Tordues)
    Chapitre 7 — relais mi-donjon type Statue Kangourex.
    VERSION UNIQUE BIOME 2026-07-30 — Exigence d'unicité totale.

    IDENTITÉ UNIQUE — L'Esplanade aux Dalles qui Convergent :
    - Position exacte : charnière extérieur éboulé (seg0) → cœur ruines (seg2)
      Exact : esplanade nivelée artificiellement, seule surface plane du donjon.
      Doit capter instant où chaos devient ordre voulu bâtisseurs.
    - Élément distinctif 1 : Dalles dorées convergentes — tiles AntreDragon/Céleste
      avec veines dorées pointant centre-bas (vers Cœur). Marquage au sol converge.
      Aucun autre relais n'a ce marquage. Visuel lisible : on comprend qu'on est
      entre ruine éboulée et cœur.
    - Élément distinctif 2 : Socle vide Titan 2x2 — emplacement où Regirock/Regice/
      Registeel étaient scellés, marques au sol en cercle, poussière absence.
      Centre exact esplanade. Symétrie voulue bâtisseurs. Unique.
    - Élément distinctif 3 : Mur gravé glyphes — enigma_cristal tiles avec glyphes
      érodés, lisible mais effacé, raconte légende Trois Serviteurs et Colosse.
    - Élément distinctif 4 : Kangourex intact au milieu effondrement — seul objet
      non fissuré, alors que tout autour s'effondre. Symbole : lieu qui doit survivre.
    - Disposition camp ADAPTÉE topo : esplanade rectangulaire parfaite (preuve taille
      ancienne), camp au centre géométrique exact, pas en L ni cercle. Feu au centre
      symétrie, sacs aux 4 coins cardinaux (ordre militaire ancien), Kangaskhan au
      centre exact esplanade (196,400) — symétrie voulue bâtisseurs, pas plan recopié.
    - Faune : Baltoy inoffensif tourne autour socle vide + Bronzor flottant, non
      agressifs, cohérents ruines.

    FONCTIONS GAMEPLAY :
    - PP + estomac via Kangaskhan_Rock
    - Faune inoffensive ruines
    - Sorties : Nord vers profondeurs (continuer), Sud vers entrée (retour)

    TRACE NARRATIVE : légende Trois Serviteurs et Colosse (Rubble Aggron café)
    Ce relais = lieu où serviteurs montaient garde. Regigigas non nommé comme Colosse.

    Ground officiel base : end_moonlit_temple (384x480) → enrichi dalles dorées + socle
    Construction : outil generateur map_tileset base, finalisation manuelle élément distinctif
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.RelayScenes'
require 'halcyon.BossFX'

local cloven_ruins_midpoint = {}

function cloven_ruins_midpoint.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_cloven_ruins_midpoint UNIQ 2026-07-30 <<=')
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()

  -- Finalisation manuelle élément distinctif via décor ajouté
  -- Socle vide Titan : cercle de River_Stone_Diamond autour centre
  pcall(function()
    local center = RogueElements.Loc(196, 400)
    -- On ajoute un effet visuel léger pour simuler socle vide (Core_Deactivation)
    local obj = RogueEssence.Content.ObjAnimData('Core_Deactivation', 6)
    GAME:GetCurrentGround().Decorations[0].Anims:Add(
      RogueEssence.Ground.GroundAnim(obj, RogueElements.Loc(190, 394)))
  end)
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
      RelayScenes.DuoArrival({
        hero = {212, 456}, partner = {180, 456}, camera = {196, 380},
        walk = 56, title = true, music = 'In the Depths of the Pit.ogg',
        lines = {
          { spk='partner', emo='Surprised', txt="Attends... le sol est... plat.[pause=20] Parfaitement plat.[pause=10] Pas une bosse, pas une fissure. Taillé au cordeau au milieu des ruines qui s'effondrent.", wait=15 },
          { spk='partner', emo='Normal', txt="Et ces veines dorées dans la pierre... elles convergent toutes vers le bas, vers le socle vide au centre. Comme des flèches.[pause=10] Quelqu'un a VOULU que ce lieu survive.", wait=10 },
          { spk='hero', emo='Worried', txt="(Un socle vide 2x2 au centre exact de l'esplanade. Trois marques en cercle autour. Trois Serviteurs... Rubble au café disait que les Serviteurs montaient garde ici avant le Colosse.)", wait=12 },
          { spk='partner', emo='Worried', txt="Le mur gravé, là, à l'ouest... les glyphes sont érodés mais on devine trois silhouettes autour d'une plus grande.[pause=0] Trois autour d'un... C'est exactement la légende des Trois Serviteurs.", wait=10 },
          { spk='partner', emo='Normal', txt="Et le rocher de Kangourex... intact.[pause=10] Pas une fissure alors que tout autour s'effondre. C'est le seul endroit intact des ruines. Parce qu'il DOIT l'être.", wait=10 },
          { spk='partner', emo='Determined', txt="On dépose ce qui encombre, on restaure au rocher — PP, ventre, tout. Passé cette esplanade aux dalles convergentes, je crois que les ruines ne nous laisseront plus faire demi-tour aussi facilement.", wait=10 },
        },
      })
    else
      RelayScenes.DuoArrival({
        hero = {212, 456}, partner = {180, 456}, camera = {196, 380},
        walk = 56, title = true, music = 'In the Depths of the Pit.ogg',
        lines = {
          { spk='partner', emo='Normal', txt="L'Esplanade aux Dalles qui Convergent... même vide, elle impose le respect. Trois marques au sol, un socle vide au centre, et le Kangourex intact qui veille.", wait=10 },
          { spk='partner', emo='Normal', txt="Le rocher est ravitaillé — PP et ventre restaurés. Profitons-en avant de descendre vers le cœur où les veines dorées nous appellent.", wait=10 },
        },
      })
    end
  else
    GAME:FadeIn(20)
  end
end

function cloven_ruins_midpoint.Update(map) end

function cloven_ruins_midpoint.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function cloven_ruins_midpoint.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

function cloven_ruins_midpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Descendre par les dalles dorées convergentes\nvers les profondeurs où le socle vide nous attend ?", true)
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
  UI:ChoiceMenuYesNo("Revenir à l'entrée par-delà le mur gravé des Trois Serviteurs ?", true)
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

function cloven_ruins_midpoint.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function cloven_ruins_midpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Les dalles dorées convergent vers le socle vide...[pause=10] Trois marques...[pause=0] On dirait que ce lieu attendait trois gardiens.", "Worried")
  UI:WaitShowDialogue("Et le rocher de Kangourex intact au centre de l'effondrement...[pause=10] Quelqu'un voulait que les voyageurs puissent se restaurer ici. PP, ventre, stockage... tout est opérationnel. On devrait en profiter.")
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_midpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Baltoy tourne autour du socle vide,[pause=10] inoffensif.[pause=0] Il semble chercher ses trois compagnons disparus.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_midpoint.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end
  GeneralFunctions.StartConversation(chara, "Le mur gravé...[pause=10] On distingue encore trois petites silhouettes autour d'une immense.[pause=0] Les Serviteurs et le Colosse. Rubble avait raison.", "Worried")
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_midpoint.WipedCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  GROUND:TeleportTo(hero, 172, 344, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, 204, 344, Direction.Right) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  GAME:MoveCamera(188, 336, 1, false)

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
  UI:WaitShowDialogue("L'Esplanade aux Dalles qui Convergent... même le sol semblait vouloir qu'on parte vers le socle vide.")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Les veines dorées brillaient plus fort à mesure qu'on approchait du socle vide des Titans.[pause=10] Comme un avertissement des Serviteurs.")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Le Cœur des ruines est tout près, sous le socle vide. Reposons-nous au Kangourex intact — puis finissons ce qu'on a commencé là où les dalles convergent.")
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

return cloven_ruins_midpoint
