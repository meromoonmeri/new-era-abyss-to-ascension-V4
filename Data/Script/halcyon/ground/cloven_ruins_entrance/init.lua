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
                 or c5.PlayTempRuinsScene
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

  -- RETOUR APRES KO / ABANDON DANS LES RUINES — le camp joue la
  -- cinematique de reveil (KODefeatCutscene) ou de repli
  -- (RetreatReturnCutscene). Passe AVANT l'arrivee : on ne rejoue pas
  -- le briefing, on se releve au camp.
  --  - KO : SetupGround(true) — Kino/Reinier sont la, ce sont EUX qui
  --    ont ramene l'equipe vaincue depuis les Ruines.
  --  - Abandon : SetupGround(false) — Kino/Reinier sont restes dans
  --    les Ruines (reconnaissance), seuls ceux du camp accueillent.
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

  -- ARRIVEE AU CAMP — la cinematique d'entree (briefing + nuit + reve).
  -- Kino/Reinier sont presents (ils sont arrives la veille).
  if c5.RuinsCampPending and not c5.RuinsCampDone then
    cloven_ruins_entrance_ch_5.SetupGround(true)
    cloven_ruins_entrance_ch_5.ArrivalCutscene()
    return
  end

  -- ETAT DE CAMP — le joueur est libre (apres la cinematique).
  -- Kino/Reinier sont partis en reconnaissance : seule la base
  -- logistique reste (Penticus, Phileas, Rin, Coco, Hyko, Almotz).
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
  --Apres le camp (briefing + nuit + reve), le partenaire a un mot
  --personnel : il se souvient de la soiree et de ce qui l'attend.
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "Cette nuit,[pause=10] autour du feu...[pause=15] Je crois que c'est la première fois que toute l'expédition s'est vraiment parlé.[pause=0] Pas juste des ordres,[pause=10] des craintes,[pause=10] des espoirs.[pause=10] Tout ça.[pause=15] Ça compte,[pause=10] tu sais.", "Normal")
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue("Et ce rêve...[pause=15] Peu importe ce qu'il voulait dire.[pause=10] On est là,[pause=10] maintenant.[pause=0] Et on entre dans les Ruines Fendues.[pause=10] Ensemble.[pause=10] Comme toujours.")
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue("Regarde le camp.[pause=10] Chacun fait sa part :[pause=0] Hyko veille,[pause=10] Rin prépare,[pause=10] Coco nourrit tout le monde,[pause=10] et Kino et Reinier balisent déjà la route.[pause=15] On n'est pas seuls,[pause=10] {0}.[pause=0] On ne l'a jamais été.", chara:GetDisplayName())
    GeneralFunctions.EndConversation(chara)
    return
  end
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function cloven_ruins_entrance.Tropius_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  --Apres la nuit : reference au briefing et a la decision.
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "La nuit a porté conseil,[pause=10] comme toujours.[pause=15] Ce que nous avons dit autour du feu,[pause=10] chaque membre l'emporte avec lui.[pause=0] C'est ça,[pause=10] une expédition :[pause=10] on part avec tout le monde,[pause=10] ou on ne part pas.", "Normal")
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue("Entrez quand vous serez prêts.[pause=10] Nous serons là,[pause=10] devant les Ruines,[pause=10] à vous attendre.")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Kino et Reinier sont déjà à l'intérieur.[pause=15] Si quelque chose tourne mal,[pause=10] ce sont eux qui le verront les premiers.[pause=0] Et ils reviendront nous le dire avant d'y toucher.")
  else
    GeneralFunctions.StartConversation(chara, "Le camp est prêt.[pause=10] Et nous aussi.[pause=0] Les Ruines Fendues nous attendent depuis trop longtemps.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Noctowl_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "Vous avez bien fait de relier les veines de Tornadus à la chaleur du Creuset.[pause=15] C'est la première fois que toutes les pièces s'alignent ainsi.[pause=0] Les anciens appelaient ça «[pause=5] entendre la terre[pause=5] ».[pause=10] Vous l'avez entendue,[pause=10] cette nuit.", "Normal")
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Et la remarque de Ganlon sur les pierres chaudes...[pause=15] elle ne me quitte pas.[pause=0] J'aimerais avoir tort,[pause=10] mais je ne crois pas.")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("J'ai confié une copie de mes notes à Reinier avant son départ.[pause=15] S'il trouve quelque chose d'anormal,[pause=10] il saura où regarder.[pause=0] Un érudit se doit de préparer ses successeurs.")
  else
    GeneralFunctions.StartConversation(chara, "J'ai passé la nuit à relire mes notes.[pause=10] Les veines,[pause=10] la chaleur,[pause=10] l'orage...[pause=0] Tout converge ici.[pause=10] Ce n'est pas un hasard.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Breloom_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "Je n'ai pas beaucoup dormi,[pause=10] entre nous.[pause=15] Repenser à ce qu'on a dit autour du feu,[pause=10] à ce qui pulse sous la pierre...[pause=0] La dernière fois que j'ai senti ça,[pause=10] c'était la première fois que j'entrais.[pause=10] Et je n'en suis ressorti qu'au matin.", "Worried")
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue("Mais cette fois,[pause=10] vous êtes avec moi.[pause=0] Et c'est tout ce qui change.")
  else
    GeneralFunctions.StartConversation(chara, "Ces ruines,[pause=10] je les connais par cœur.[pause=0] Et je n'y comprends toujours rien.[pause=10] Peut-être que vous,[pause=10] vous verrez ce que nous,[pause=10] on a manqué.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Girafarig_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "Mon arrière-tête n'a pas dormi de la nuit.[pause=15] Il n'arrête pas de tourner autour de ce que vous avez dit :[pause=0] «[pause=5] une forme sous le monde[pause=5] ».[pause=15] Il pense que vous avez visé juste.[pause=0] Et ça,[pause=10] ça ne lui arrive presque jamais.", "Worried")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Gardez les yeux ouverts,[pause=10] là-dedans.[pause=0] Et si quelque chose bouge dans les murs...[pause=10] ne supposez pas que c'est un écho.")
  else
    GeneralFunctions.StartConversation(chara, "Mon arrière-tête n'aime pas ces ruines.[pause=10] Il dit qu'elles ont été creusées autour de quelque chose.[pause=0] Et que ça,[pause=10] ça n'a jamais été ouvert.[pause=10] Jusqu'à maintenant.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Snubbull_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "J'ai pas fermé l'œil,[pause=10] moi non plus.[pause=15] Entre le briefing de Phileas et Ganlon qui ronflait,[pause=10] c'était une sacrée soirée.[pause=0] Mais je vais vous dire :[pause=10] je crois qu'on tient quelque chose,[pause=10] cette fois.[pause=10] Je le sens.", "Normal")
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue("Alors allez-y.[pause=10] Et ramenez-nous une bonne raison de fêter ça,[pause=10] au retour.")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Moi je tiens le ravitaillement.[pause=10] Personne ne part en expédition sans avoir mangé,[pause=10] c'est la règle.[pause=0] Hyko garde,[pause=10] Rin soigne,[pause=10] et moi je remplis les gamelles.[pause=10] Chacun son poste.")
  else
    GeneralFunctions.StartConversation(chara, "Des ruines de plus.[pause=10] Celle-ci a intérêt à valoir le déplacement,[pause=0] après tout ce chemin.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Audino_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "J'ai refait les sacs de tout le monde ce matin.[pause=15] Baies,[pause=10] bandages,[pause=10] un peu d'herbe amère pour le mal des ruines.[pause=0] On ne sait jamais ce qu'on trouvera au fond.[pause=10] Mais on y ira prêts.", "Normal")
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue("Revenez-moi entiers,[pause=10] tous les deux.[pause=0] C'est tout ce que je demande.[pause=10] Et si la pierre vous blesse,[pause=10] je serai là,[pause=10] au camp,[pause=10] avec de quoi soigner.")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Kino a insisté pour emporter des bandages de secours.[pause=15] Il connaît les ruines :[pause=10] il sait qu'on y saigne.[pause=0] J'espère ne pas en avoir besoin pour lui.[pause=10] Ni pour vous.")
  else
    GeneralFunctions.StartConversation(chara, "J'ai préparé des baies pour tout le monde.[pause=10] On ne sait jamais,[pause=0] là-dedans.[pause=10] Revenez-moi entiers,[pause=10] c'est tout ce que je demande.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Growlithe_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "Ronde du matin effectuée,[pause=10] wouf.[pause=15] Les ruines n'ont pas bougé d'un pouce depuis hier soir.[pause=0] Mais je vous jure que je les ai entendues respirer,[pause=10] une fois.[pause=10] Peut-être,[pause=10] le vent.[pause=0] Peut-être pas.", "Normal")
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue("Je garde le camp.[pause=10] Comptez sur moi.[pause=0] Et revenez-nous entiers,[pause=10] wouf.")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("J'ai relevé le périmètre trois fois depuis l'aube.[pause=15] Rien à signaler,[pause=10] à part les ruines qui... respirent.[pause=0] Je le mets sur le compte du vent.[pause=10] Pour l'instant.")
  else
    GeneralFunctions.StartConversation(chara, "J'ai relevé les gardes trois fois cette nuit,[pause=10] wouf.[pause=0] Les ruines n'ont pas bougé.[pause=10] Elles attendent,[pause=10] comme nous.", "Normal")
  end
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance.Zigzagoon_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5
     and SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone then
    GeneralFunctions.StartConversation(chara, "J'ai écrit à ma mère,[pause=10] cette nuit,[pause=15] avec un bout de charbon du feu.[pause=0] «[pause=5] Les ruines bougent,[pause=10] mais on est ensemble.[pause=5] »[pause=15] Elle va se demander ce que ça veut dire.[pause=10] Moi aussi,[pause=10] un peu.", "Happy")
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue("Mais on le saura bientôt,[pause=10] pas vrai ?[pause=0] Allez.[pause=10] Et rapportez-moi une histoire qui vaut le détour.")
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Si Reinier et Kino reviennent avant vous,[pause=10] je leur ferai du thé.[pause=15] Et si vous revenez avant eux,[pause=10] je vous ferai du thé aussi.[pause=0] Tout le monde gagne.[pause=10] C'est ma philosophie.")
  else
    GeneralFunctions.StartConversation(chara, "Ma mère m'a dit : «[pause=5] Ne reviens pas sans une bonne histoire.[pause=5] »[pause=10] Les Ruines Fendues,[pause=10] ça fera largement l'affaire.", "Happy")
  end
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
