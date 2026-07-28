--[[
    SideQuests.lua

    LES REQUETES DE METANO — quetes secondaires OBLIGATOIRES
    ================================================================
    CONSTAT
    ------------------------------------------------------------------
    Le jeu n'a AUCUN contenu optionnel. On enchaine : cinematique de
    ville -> donjon -> boss -> veillee -> chapitre suivant. C'est un
    couloir. Mesure : le chapitre 6 tient en 1 h 20, le 10 en 1 h.

    Ce module ajoute par chapitre 3 requetes qui doivent etre RENDUES
    avant que l'histoire reprenne. Ce ne sont pas des missions du
    comptoir (aleatoires, repetables) : ce sont des demandes ecrites,
    liees a des PNJ nommes, qui ne se presentent qu'une fois.

    POURQUOI OBLIGATOIRES
    ------------------------------------------------------------------
    Demande explicite. Techniquement : le palier de chapitre pose
    DaysToReach ; tant que les 3 requetes du chapitre ne sont pas
    rendues, on repousse ce palier. Le joueur n'est jamais bloque sans
    savoir pourquoi — le tableau des Requetes affiche ce qui manque.

    LE CONTRASTE, PRINCIPE D'ECRITURE
    ------------------------------------------------------------------
    L'arc principal est grave : la Voix, les Coeurs qui s'eteignent, le
    doute. Si TOUT est grave, plus rien ne l'est.

    Ces requetes respirent donc volontairement : un chapardeur de
    petit-dejeuner, une dispute de marchands, un enfant qui veut un
    autographe. Elles sont courtes, chaleureuses, parfois drôles.

    MAIS chacune porte une seconde couche que le joueur attentif
    ramasse : le Sentinelle qui compte les allees et venues, la
    marchande qui n'ose plus aller cueillir au nord, le petit qui
    demande pourquoi les adultes chuchotent depuis quelque temps.
    Le quotidien est le meilleur endroit pour montrer qu'un monde
    va mal — bien meilleur qu'un discours.

    REGLES DU PROJET
      * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
      * La Voix ne parle JAMAIS dans une requete : elle ne s'interesse
        pas au quotidien. Son absence ici la rend plus lourde ailleurs.
      * Module global -> texte litteral (patron SuaireArc / LegendArc).
      * Repliques courtes, < 150 caracteres hors balises [pause=N].
      * Tout sous pcall, sortie garantie.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

SideQuests = {}

--------------------------------------------------------------------
-- ETAT
--------------------------------------------------------------------
function SideQuests.Ensure()
  if SV.SideQuests == nil then SV.SideQuests = {} end
  local s = SV.SideQuests
  if s.Done == nil then s.Done = {} end        -- [id] = true
  if s.Taken == nil then s.Taken = {} end      -- [id] = true
  if s.Step == nil then s.Step = {} end        -- [id] = n (avancement)
  return s
end

--------------------------------------------------------------------
-- LES REQUETES
--------------------------------------------------------------------
-- id       identifiant interne
-- ch       chapitre qui la propose
-- giver    instance du PNJ demandeur (deja sur la carte de Metano)
-- titre    ce qui s'affiche au tableau
-- ask      ce que dit le PNJ quand on l'aborde
-- accept   sa reaction si on accepte
-- refuse   sa reaction si on refuse (jamais vexante : on peut revenir)
-- pending  ce qu'il dit tant que ce n'est pas fait
-- target   instance du PNJ a qui parler pour resoudre
-- solve    l'echange chez la cible
-- done     le remerciement du demandeur
-- undertow la seconde couche : ce que la scene dit du monde
SideQuests.LIST = {

  ---------------------------------------------------------------
  -- CHAPITRE 6 — la ville respire encore
  ---------------------------------------------------------------
  {
    id = 'q6_petitdej', ch = 6, giver = 'Furret', target = 'Zigzagoon',
    titre = "Le chapardeur du petit-déjeuner",
    ask = {
      {'Furret', 'Worried', "Trois matins de suite.[pause=20] Trois."},
      {'Furret', 'Angry',   "Quelqu'un me pique ma part avant que je descende.[pause=20] Je veux un nom."},
      {'Furret', 'Sad',     "Je ne veux pas de punition.[pause=25] Je veux juste savoir."},
    },
    accept = {'Furret', 'Happy', "Merci.[pause=20] Commencez par ceux qui se lèvent tôt."},
    refuse = {'Furret', 'Sad',   "...Bon. Je mangerai plus tôt, alors."},
    pending= {'Furret', 'Worried', "Alors ?[pause=20] Vous avez un nom ?"},
    solve = {
      {'Zigzagoon', 'Surprised', "Moi ?![pause=20] Pourquoi vous me regardez comme ça ?"},
      {'Zigzagoon', 'Sad',       "...Bon. C'est moi.[pause=25] Mais j'ai une raison !"},
      {'Zigzagoon', 'Worried',   "Je pars avant l'aube depuis une semaine.[pause=20] Je surveille la route du nord."},
      {'Zigzagoon', 'Sad',       "Il y a moins de monde qui passe.[pause=25] Beaucoup moins. Ça m'inquiète."},
      {'Zigzagoon', 'Determined',"Alors je pars tôt. Et j'ai faim. Voilà."},
    },
    done = {
      {'Furret', 'Surprised', "Il surveille la route ?[pause=25] Tout seul ? À l'aube ?"},
      {'Furret', 'Sad',       "...Le petit imbécile.[pause=20] Il aurait pu demander."},
      {'Furret', 'Determined',"Dites-lui que je lui mettrai deux parts de côté.[pause=25] Deux."},
    },
    undertow = "moins de voyageurs sur les routes",
  },

  {
    id = 'q6_etal', ch = 6, giver = 'Bellossom', target = 'Roselia',
    titre = "L'étal à moitié vide",
    ask = {
      {'Bellossom', 'Worried', "Mon étal est vide et ce n'est pas la saison qui veut ça."},
      {'Bellossom', 'Sad',     "Ma cueilleuse ne monte plus au nord.[pause=25] Elle ne me dit pas pourquoi."},
      {'Bellossom', 'Normal',  "Vous, elle vous parlera peut-être.[pause=20] Vous n'êtes pas sa patronne."},
    },
    accept = {'Bellossom', 'Normal', "Elle est près des fleurs.[pause=20] Elle y est toujours."},
    refuse = {'Bellossom', 'Sigh',   "Je comprends.[pause=20] Vous avez une forêt à sauver."},
    pending= {'Bellossom', 'Worried', "Vous lui avez parlé ?"},
    solve = {
      {'Roselia', 'Sad',      "Elle vous envoie, c'est ça.[pause=25] Je m'y attendais."},
      {'Roselia', 'Worried',  "Je n'ai pas peur des Pokémon sauvages.[pause=20] J'y vais depuis dix ans."},
      {'Roselia', 'Sad',      "C'est le silence.[pause=30] Là-haut, il n'y a plus un chant d'oiseau."},
      {'Roselia', 'Pain',     "On s'habitue au danger.[pause=25] Pas au silence."},
      {'Roselia', 'Determined',"Dites-lui que j'irai. Mais accompagnée.[pause=20] Plus jamais seule."},
    },
    done = {
      {'Bellossom', 'Surprised', "Le silence...[pause=25] Elle ne m'avait rien dit."},
      {'Bellossom', 'Sad',       "J'ai cru qu'elle devenait paresseuse.[pause=25] J'ai eu honte de le penser."},
      {'Bellossom', 'Determined',"J'irai avec elle demain.[pause=20] L'étal attendra."},
    },
    undertow = "le silence gagne les hauteurs",
  },

  {
    id = 'q6_autographe', ch = 6, giver = 'Marill', target = 'Aria',
    titre = "Un autographe, s'il vous plaît",
    ask = {
      {'Marill', 'Happy',   "Vous êtes des explorateurs ![pause=20] Des VRAIS !"},
      {'Marill', 'Inspired',"J'ai vu passer trois Pokémon magnifiques hier.[pause=20] Une équipe célèbre !"},
      {'Marill', 'Sad',     "J'ai pas osé leur parler.[pause=25] Vous pourriez leur demander un autographe ?"},
    },
    accept = {'Marill', 'Happy', "OUI ![pause=20] Merci merci merci !"},
    refuse = {'Marill', 'Sad',   "Ah...[pause=25] C'est pas grave. Elles font peur, hein ?"},
    pending= {'Marill', 'Happy', "Alors ?[pause=20] Vous leur avez demandé ?"},
    solve = {
      {'Aria', 'Surprised', "Un autographe ?[pause=25] Pour un petit ?"},
      {'Aria', 'Happy',     "Adagio va détester.[pause=20] Donnez-moi ça."},
      {'Aria', 'Normal',    "Voilà.[pause=25] Dites-lui de ne pas devenir explorateur."},
      {'Aria', 'Sad',       "...Non. Ne lui dites pas ça.[pause=25] Dites-lui de bien s'entraîner."},
    },
    done = {
      {'Marill', 'Inspired', "ELLE A SIGNÉ ![pause=20] Elle a VRAIMENT signé !"},
      {'Marill', 'Happy',    "Je vais m'entraîner tous les jours ![pause=20] Tous les jours !"},
      {'Marill', 'Normal',   "...Vous croyez qu'un jour on me demandera un autographe, à moi ?"},
    },
    undertow = "la releve regarde, et decide",
  },
}

--------------------------------------------------------------------
-- OUTILS
--------------------------------------------------------------------
local function say(who, emo, txt)
  if who == nil then return end
  UI:SetSpeaker(who)
  if emo ~= nil then UI:SetSpeakerEmotion(emo) end
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(8)
end

local function line(t)
  local c = CH(t[1])
  if c == nil then return end
  say(c, t[2], t[3])
end

--Requetes d'un chapitre donne.
function SideQuests.OfChapter(ch)
  local out = {}
  for _, q in ipairs(SideQuests.LIST) do
    if q.ch == ch then table.insert(out, q) end
  end
  return out
end

--Combien reste-t-il a rendre ?
function SideQuests.Remaining(ch)
  local s = SideQuests.Ensure()
  local n = 0
  for _, q in ipairs(SideQuests.OfChapter(ch)) do
    if not s.Done[q.id] then n = n + 1 end
  end
  return n
end

--Le chapitre peut-il se cloturer ?
function SideQuests.AllDone(ch)
  return SideQuests.Remaining(ch) == 0
end

local function find(id)
  for _, q in ipairs(SideQuests.LIST) do
    if q.id == id then return q end
  end
end

--------------------------------------------------------------------
-- INTERACTION AVEC LE DEMANDEUR
--------------------------------------------------------------------
-- Renvoie true si le PNJ avait quelque chose a dire (la scene a eu
-- lieu), false sinon — le ground enchaine alors sur son dialogue
-- habituel. Aucun PNJ ne perd sa replique de base.
function SideQuests.TalkGiver(inst, ch)
  local s = SideQuests.Ensure()
  for _, q in ipairs(SideQuests.OfChapter(ch)) do
    if q.giver == inst and not s.Done[q.id] then
      local chara = CH(inst)
      if chara == nil then return false end
      local ok = pcall(function()
        if s.Taken[q.id] then
          line(q.pending)
        else
          for _, t in ipairs(q.ask) do line(t) end
          UI:ChoiceMenuYesNo("Accepter cette requête ?", true)
          UI:WaitForChoice()
          if UI:ChoiceResult() then
            s.Taken[q.id] = true
            line(q.accept)
            UI:ResetSpeaker(false)
            UI:SetCenter(true)
            UI:WaitShowDialogue("Requête acceptée :[pause=10] « " .. q.titre .. " ».")
            UI:SetCenter(false)
          else
            line(q.refuse)
          end
        end
      end)
      pcall(function() UI:ResetSpeaker() end)
      return ok
    end
  end
  return false
end

--------------------------------------------------------------------
-- INTERACTION AVEC LA CIBLE
--------------------------------------------------------------------
function SideQuests.TalkTarget(inst, ch)
  local s = SideQuests.Ensure()
  for _, q in ipairs(SideQuests.OfChapter(ch)) do
    if q.target == inst and s.Taken[q.id] and not s.Done[q.id] and not s.Step[q.id] then
      local chara = CH(inst)
      if chara == nil then return false end
      local ok = pcall(function()
        for _, t in ipairs(q.solve) do line(t) end
        s.Step[q.id] = 1
        UI:ResetSpeaker(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue("Il reste à en rendre compte.")
        UI:SetCenter(false)
      end)
      pcall(function() UI:ResetSpeaker() end)
      return ok
    end
  end
  return false
end

--------------------------------------------------------------------
-- RENDRE LA REQUETE
--------------------------------------------------------------------
function SideQuests.TurnIn(inst, ch)
  local s = SideQuests.Ensure()
  for _, q in ipairs(SideQuests.OfChapter(ch)) do
    if q.giver == inst and s.Step[q.id] and not s.Done[q.id] then
      local chara = CH(inst)
      if chara == nil then return false end
      local ok = pcall(function()
        for _, t in ipairs(q.done) do line(t) end
        s.Done[q.id] = true
        UI:ResetSpeaker(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue("Requête accomplie :[pause=10] « " .. q.titre .. " ».")
        local r = SideQuests.Remaining(ch)
        if r > 0 then
          UI:WaitShowDialogue("Il reste " .. r .. " requête(s) en attente à Metano.")
        else
          UI:WaitShowDialogue("Plus aucune requête en attente.[pause=20] La ville peut souffler.")
        end
        UI:SetCenter(false)
      end)
      pcall(function() UI:ResetSpeaker() end)
      return ok
    end
  end
  return false
end

--------------------------------------------------------------------
-- POINT D'ENTREE UNIQUE POUR LES GROUNDS
--------------------------------------------------------------------
-- Un seul appel a placer en tete du handler d'un PNJ :
--   if SideQuests.Interact('Furret') then return end
-- Il gere l'ordre : rendre > resoudre > proposer.
function SideQuests.Interact(inst, ch)
  ch = ch or (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 0
  if SideQuests.TurnIn(inst, ch) then return true end
  if SideQuests.TalkTarget(inst, ch) then return true end
  if SideQuests.TalkGiver(inst, ch) then return true end
  return false
end

--------------------------------------------------------------------
-- LE TABLEAU DES REQUETES
--------------------------------------------------------------------
-- Le joueur doit TOUJOURS pouvoir savoir ce qui lui manque. Sans cela,
-- une progression bloquee devient une enigme frustrante.
function SideQuests.Board(ch)
  ch = ch or (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 0
  local s = SideQuests.Ensure()
  local list = SideQuests.OfChapter(ch)
  pcall(function()
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    if #list == 0 then
      UI:WaitShowDialogue("Le tableau est vide.[pause=20] Rien à signaler aujourd'hui.")
    else
      UI:WaitShowDialogue("TABLEAU DES REQUÊTES")
      for _, q in ipairs(list) do
        local etat = "à prendre"
        if s.Done[q.id] then etat = "accomplie"
        elseif s.Step[q.id] then etat = "à rendre"
        elseif s.Taken[q.id] then etat = "en cours" end
        UI:WaitShowDialogue("« " .. q.titre .. " » —[pause=10] " .. etat .. ".")
      end
      local r = SideQuests.Remaining(ch)
      if r > 0 then
        UI:WaitShowDialogue("La guilde n'enverra pas de nouvelle expédition[pause=10] tant que Metano a besoin de nous.")
      end
    end
    UI:SetCenter(false)
  end)
  pcall(function() UI:ResetSpeaker() end)
end

return SideQuests
