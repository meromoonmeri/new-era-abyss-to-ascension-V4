--[[
    TownNight.lua

    LA NUIT A METANO — habitants, ambiance, retour au matin
    ================================================================
    A QUOI CE MODULE SE RACCORDE
    ------------------------------------------------------------------
    Il ne cree AUCUN systeme temporel parallele. Il s'appuie sur ce qui
    existe deja et qui a ete verifie dans le depot :

      * SV.ChapterProgression.DaysPassed, incremente par
        GeneralFunctions.EndOfDay() (GeneralFunctions.lua:63), qui
        appelle ensuite UpdateDailyFlags() -> stocks marchands, cafe,
        et regeneration du job board via MISSION_GEN.ResetBoards().
      * Les 4 drapeaux de fin de journee (Dinnertime, Bedtime,
        MorningWakeup, MorningAddress), poses a 71 endroits du code.
      * La carte metano_town_nuit, clone au pixel pres de metano_town,
        dont les 14 tilesets pointent vers les versions _Night generees
        par tools/tile_night.py (format .tile decode et valide par
        reconstruction bit-a-bit).

    LE SCENARIO GARDE LA PRIORITE
    ------------------------------------------------------------------
    TownNight.Offer() ne propose RIEN si une scene imposee attend. On
    teste les drapeaux existants avant tout : si le chapitre veut un
    diner, une reunion ou une urgence, la scene s'impose comme
    aujourd'hui et le joueur ne voit aucun menu.

    LES TROIS HABITANTS DE LA NUIT
    ------------------------------------------------------------------
    Ce ne sont pas des PNJ de jour deplaces a une autre heure. Ils
    n'existent QUE la nuit, et chacun sait une chose que personne ne
    dit le jour :

      Veilleur de Nuit   il fait sa ronde. Il tient un compte, et son
                         compte ne tombe plus juste depuis un moment.
      Compteuse d'Etoiles elle regarde le ciel toutes les nuits depuis
                         des annees. Elle a remarque quelque chose
                         qu'elle n'ose dire a personne de jour.
      Plume-Grise        il ne dort pas. Il a connu la ville avant, et
                         c'est le seul a pouvoir la comparer.

    La nuit permet des paroles impossibles de jour : on se confie a
    quelqu'un qu'on croise a trois heures du matin comme on ne se
    confie pas a midi.

    REGLES DU PROJET
      * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
      * La Voix ne parle PAS en ville, pas meme la nuit.
      * Texte litteral (module global), francais.
      * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
      * Tout sous pcall, sortie garantie : une carte d'exploration ne
        doit jamais pieger le joueur.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.TownNightScenes'

TownNight = {}

--------------------------------------------------------------------
-- ETAT
--------------------------------------------------------------------
function TownNight.Ensure()
  if SV.TownNight == nil then SV.TownNight = {} end
  local s = SV.TownNight
  if s.Visits == nil then s.Visits = 0 end        -- nuits explorees
  if s.Met == nil then s.Met = {} end             -- [inst] = nb de fois
  if s.SawStars == nil then s.SawStars = false end
  --Cinematiques de nuit (TownNightScenes). Ces deux tables sont indexees
  --par 'ChN' : une scene d'arrivee et une parole de la Voix au plus par
  --chapitre. Declarees ICI et pas seulement a l'usage — le bug des champs
  --GloomyPlayedMidpointIntro/GloomyMidpointState, jamais declares, a deja
  --coute une partie neuve qui arrivait avec nil.
  if s.Seen == nil then s.Seen = {} end           -- [ChN] = arrivee jouee
  if s.VoiceHeard == nil then s.VoiceHeard = {} end -- [ChN] = Voix entendue
  return s
end

--------------------------------------------------------------------
-- LE SCENARIO PASSE AVANT TOUT
--------------------------------------------------------------------
-- Renvoie true si une scene imposee attend le joueur. Dans ce cas, on
-- ne propose aucun choix : le chapitre reprend la main.
--
-- Les drapeaux testes sont ceux DEJA utilises par le mod, pas des
-- inventions : Dinnertime est lu par guild_dining_room.PlotScripting
-- (init.lua:67), Bedtime par guild_heros_room_helper.Bedtime.
function TownNight.StoryLocked()
  local t = SV.TemporaryFlags or {}
  --Une mission rendue impose le passage au 2e etage : on n'interrompt pas.
  if t.MissionCompleted then return true end
  --Un reveil ou une adresse du matin en attente = scene imposee.
  if t.MorningWakeup or t.MorningAddress then return true end
  return false
end

--------------------------------------------------------------------
-- LE CHOIX DE FIN DE JOURNEE
--------------------------------------------------------------------
-- Appele a la place de l'enchainement automatique diner -> nuit.
-- Renvoie :
--   'diner'  le joueur veut la scene de groupe  (comportement actuel)
--   'dormir' il saute au lendemain
--   'ville'  il sort explorer Metano de nuit
--
-- PMDO n'expose pas de menu a 3 entrees dans ce projet (verifie : le
-- seul menu custom est BoardMenu). On enchaine donc deux questions
-- fermees, ce que le moteur sait faire nativement.
function TownNight.Offer()
  if TownNight.StoryLocked() then return 'diner' end

  local res = 'diner'
  local ok = pcall(function()
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:ChoiceMenuYesNo("La journée est finie.[pause=15] Rejoindre les autres pour le dîner ?", true)
    UI:WaitForChoice()
    if UI:ChoiceResult() then
      res = 'diner'
    else
      UI:ChoiceMenuYesNo("Sortir marcher dans Metano avant de dormir ?", false)
      UI:WaitForChoice()
      res = UI:ChoiceResult() and 'ville' or 'dormir'
    end
    UI:SetCenter(false)
  end)
  if not ok then res = 'diner' end
  pcall(function() UI:ResetSpeaker() end)
  return res
end

--Entree dans la ville de nuit. metano_town_nuit est bien dans les
--GroundMaps de master_zone (verifie), donc EnterGroundMap est legal.
function TownNight.Enter()
  pcall(function()
    SOUND:FadeOutBGM(40)
    GAME:FadeOut(false, 40)
    GAME:EnterGroundMap('metano_town_nuit', 'entrance')
  end)
end

--------------------------------------------------------------------
-- PEUPLEMENT
--------------------------------------------------------------------
-- Positions verifiees LIBRES sur les obstacles de la carte
-- (metano_town_nuit.rsground, 1512x1512).
TownNight.SPOTS = {
  { 'Nuit_Garde',       860, 900,  Direction.Down },
  { 'Nuit_Etoiles',    1000, 1200, Direction.Up   },
  { 'Nuit_Insomniaque', 760, 1100, Direction.Right},
}

function TownNight.Populate()
  local s = TownNight.Ensure()
  pcall(function()
    CharacterEssentials.MakeCharactersFromList(TownNight.SPOTS)
  end)
end

--------------------------------------------------------------------
-- ARRIVEE
--------------------------------------------------------------------
-- On etablit le LIEU avant les personnages (patron EoSO/beach) : la
-- ville respire quelques secondes avant qu'on parle.
-- L'arrivee est deleguee a TownNightScenes : chaque chapitre a SA nuit,
-- accrochee a l'etat reel du scenario. Le texte generique d'origine reste
-- en secours dans TownNightScenes.ArrivalGeneric (nuits repetees, ou
-- chapitre sans scene dediee).
function TownNight.Arrival()
  local s = TownNight.Ensure()
  s.Visits = s.Visits + 1
  if not pcall(function() TownNightScenes.Arrival(s.Visits) end) then
    --Filet : si le module de scenes echoue, la nuit s'ouvre quand meme.
    pcall(function()
      SOUND:PlayBGM('Goodnight.ogg', true)
      UI:ResetSpeaker(false)
      UI:SetCenter(true)
      UI:WaitShowDialogue("Metano, la nuit.[pause=25] On n'entend que la rivière.")
      UI:SetCenter(false)
      UI:ResetSpeaker()
    end)
  end
end

--------------------------------------------------------------------
-- LES HABITANTS DE LA NUIT
--------------------------------------------------------------------
-- Chaque PNJ a plusieurs paliers : ce qu'il dit change selon le nombre
-- de fois qu'on lui a deja parle. La nuit recompense l'habitue.
TownNight.LINES = {

  Nuit_Garde = { emo = 'Normal', lines = {
    { "Halte.[pause=20] ...Ah, c'est vous. Circulez, alors.",
      "Je fais le tour six fois par nuit.[pause=25] Ça fait onze ans." },
    { "Vous revoilà.[pause=25] Peu de gens sortent deux nuits de suite.",
      "Je compte les lanternes allumées.[pause=25] C'est une manie. Ça occupe.",
      "Avant, j'en comptais dix-neuf.[pause=30] Cette nuit, quatorze." },
    { "Douze.[pause=30] Cette nuit, douze lanternes.",
      "Les gens se couchent plus tôt.[pause=25] Ils ne le disent pas, mais ils ferment plus tôt.",
      "Ce n'est pas la peur.[pause=30] C'est la fatigue. C'est pire, la fatigue." },
    { "Toujours douze.[pause=25] Au moins ça ne descend plus.",
      "Vous savez ce qui me rassure, vous ?[pause=30] Que quelqu'un d'autre compte aussi." },
  }},

  Nuit_Etoiles = { emo = 'Normal', lines = {
    { "Chut.[pause=20] Levez la tête plutôt que de parler.",
      "Vingt ans que je viens ici.[pause=25] Je connais chaque point de ce ciel." },
    { "Vous êtes revenus.[pause=25] La plupart trouvent ça ennuyeux, le ciel.",
      "Il y a une chose que je n'ai jamais dite à personne.",
      "Depuis quelques saisons, il y a une étoile en moins.[pause=30] Là. Entre les deux autres." },
    { "Je l'ai cherchée cent fois.[pause=25] Elle n'est pas cachée. Elle n'est plus là.",
      "Une étoile ne s'éteint pas en quelques saisons.[pause=30] Ça prend des millions d'années.",
      "Alors soit je me trompe,[pause=20] soit quelque chose va très vite quelque part." },
    { "Je ne veux pas qu'on me croie.[pause=25] Je veux juste que quelqu'un d'autre regarde.",
      "Vous regardez, vous.[pause=30] Ça suffit à me faire dormir mieux." },
  }},

  Nuit_Insomniaque = { emo = 'Normal', lines = {
    { "Je ne dors pas.[pause=25] Ne me demandez pas pourquoi, je n'en sais rien.",
      "Alors je marche.[pause=20] Et je regarde la ville se taire." },
    { "Vous non plus vous ne dormez pas ?[pause=25] Nous voilà deux.",
      "J'habite ici depuis toujours.[pause=25] J'ai vu Metano avant la guilde.",
      "C'était plus petit.[pause=20] Plus bruyant, aussi. Étrangement." },
    { "Vous voulez savoir ce qui a changé ?[pause=30] Les gens rentrent.",
      "Avant, on veillait dehors.[pause=25] On se racontait des choses jusqu'à l'aube.",
      "Maintenant chacun rentre.[pause=30] Personne n'a decide ça. C'est venu tout seul." },
    { "Ça me rassure de vous voir dehors.[pause=25] Vraiment.",
      "Continuez de sortir la nuit.[pause=30] Une ville où plus personne ne veille, ça meurt sans bruit." },
  }},
}

function TownNight.Talk(inst)
  local s = TownNight.Ensure()
  local fiche = TownNight.LINES[inst]
  if fiche == nil then return false end
  local chara = CH(inst)
  if chara == nil then return false end

  s.Met[inst] = (s.Met[inst] or 0) + 1
  local palier = math.min(s.Met[inst], #fiche.lines)
  local bloc = fiche.lines[palier]

  local ok = pcall(function()
    UI:SetSpeaker(chara)
    UI:SetSpeakerEmotion(fiche.emo or 'Normal')
    for _, t in ipairs(bloc) do
      UI:WaitShowDialogue(t)
      GAME:WaitFrames(8)
    end
    UI:ResetSpeaker()
  end)

  --La revelation de la Compteuse est un jalon : on la retient.
  if inst == 'Nuit_Etoiles' and palier >= 2 then s.SawStars = true end
  return ok
end

--Le partenaire commente la nuit, differemment selon ce qu'on a appris.
function TownNight.PartnerTalk()
  local s = TownNight.Ensure()
  local partner = CH('Teammate1')
  if partner == nil then return false end
  local txt
  if s.SawStars then
    txt = "Une étoile en moins...[pause=30] Tu crois qu'elle dit vrai ?"
  elseif s.Visits >= 2 then
    txt = "J'aime bien la ville à cette heure.[pause=25] On entend ce qu'on ne remarque pas le jour."
  else
    txt = "Tout le monde dort.[pause=25] C'est bizarre de marcher là où il y a foule d'habitude."
  end
  return pcall(function()
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion('Normal')
    UI:WaitShowDialogue(txt)
    UI:ResetSpeaker()
  end)
end

--------------------------------------------------------------------
-- RETOUR AU MATIN
--------------------------------------------------------------------
-- On ne reimplemente pas la fin de journee : on repose les drapeaux
-- que le mod utilise deja, puis on rentre a la chambre (carte 2 de
-- master_zone, verifie). EndOfDay est appele par le circuit existant.
function TownNight.GoHome()
  pcall(function()
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:ChoiceMenuYesNo("Rentrer se coucher ?", true)
    UI:WaitForChoice()
    local yes = UI:ChoiceResult()
    UI:SetCenter(false)
    UI:ResetSpeaker()
    if not yes then return end

    --La nuit se FERME. La scene de depart varie selon ce que le joueur a
    --reellement vecu (Voix entendue, Compteuse rencontree, ou rien).
    pcall(function() TownNightScenes.Departure() end)

    SV.TemporaryFlags.Bedtime = true
    SV.TemporaryFlags.MorningWakeup = true
    SV.TemporaryFlags.MorningAddress = true
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    GAME:EnterZone("master_zone", -1, 2, 0)
  end)
end

return TownNight
