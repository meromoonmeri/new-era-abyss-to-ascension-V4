--[[
    SideQuests.lua — Requêtes secondaires obligatoires (Chapitre 6)
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

SideQuests = {}

local function say(who, emo, txt)
  UI:SetSpeaker(who)
  if emo then UI:SetSpeakerEmotion(emo) end
  UI:WaitShowDialogue(txt)
end

function SideQuests.Ensure()
  if SV.SideQuests == nil then SV.SideQuests = {} end
  if SV.SideQuests.Done == nil then SV.SideQuests.Done = {} end
  if SV.SideQuests.Accepted == nil then SV.SideQuests.Accepted = {} end
  if SV.SideQuests.PendingPicks == nil then SV.SideQuests.PendingPicks = {} end
  return SV.SideQuests
end

function SideQuests.IsDone(q_id)
  local s = SideQuests.Ensure()
  return s.Done[q_id] == true
end

function SideQuests.IsAccepted(q_id)
  local s = SideQuests.Ensure()
  return s.Accepted[q_id] == true
end

function SideQuests.OfChapter(ch)
  ch = ch or (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 0
  local list = {}
  for _, q in ipairs(SideQuests.LIST) do
    if q.ch == ch then
      list[#list + 1] = q
    end
  end
  return list
end

function SideQuests.AllDone(ch)
  ch = ch or (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 0
  for _, q in ipairs(SideQuests.LIST) do
    if q.ch == ch and not SideQuests.IsDone(q.id) then
      return false
    end
  end
  return true
end

function SideQuests.AllChapterDone(ch)
  return SideQuests.AllDone(ch)
end

function SideQuests.Remaining(ch)
  ch = ch or (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 0
  local r = 0
  for _, q in ipairs(SideQuests.LIST) do
    if q.ch == ch and not SideQuests.IsDone(q.id) then
      r = r + 1
    end
  end
  return r
end

function SideQuests.CountChapterDone(ch)
  ch = ch or (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 0
  local c = 0
  for _, q in ipairs(SideQuests.LIST) do
    if q.ch == ch and SideQuests.IsDone(q.id) then
      c = c + 1
    end
  end
  return c
end

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

function SideQuests.Interact(npcName, ch)
  local s = SideQuests.Ensure()
  ch = ch or (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 0
  
  -- Est-ce une cible d'une quête acceptée ?
  for _, q in ipairs(SideQuests.LIST) do
    if q.target == npcName and q.ch == ch and s.Accepted[q.id] and not s.Done[q.id] and not s.PendingPicks[q.id] then
      local chara = CH(npcName)
      for _, line in ipairs(q.solve) do
        local spk = (line[1] == npcName) and chara or CH(line[1])
        say(spk or chara, line[2], line[3])
      end
      s.PendingPicks[q.id] = true
      UI:ResetSpeaker(false)
      UI:SetCenter(true)
      UI:WaitShowDialogue("Vous avez obtenu ce qu'il fallait ![pause=10] Retournez voir le demandeur.")
      UI:SetCenter(false)
      return true
    end
  end

  -- Est-ce un donneur de quête ?
  for _, q in ipairs(SideQuests.LIST) do
    if q.giver == npcName and q.ch == ch and not s.Done[q.id] then
      local chara = CH(npcName)
      if s.PendingPicks[q.id] then
        for _, line in ipairs(q.done) do
          local spk = (line[1] == npcName) and chara or CH(line[1])
          say(spk or chara, line[2], line[3])
        end
        s.PendingPicks[q.id] = nil
        s.Done[q.id] = true
        UI:ResetSpeaker(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue("Requête accomplie :[pause=10] « " .. q.titre .. " » !")
        UI:SetCenter(false)
        return true
      elseif s.Accepted[q.id] then
        local spk = (q.pending[1] == npcName) and chara or CH(q.pending[1])
        say(spk or chara, q.pending[2], q.pending[3])
        return true
      else
        for _, line in ipairs(q.ask) do
          local spk = (line[1] == npcName) and chara or CH(line[1])
          say(spk or chara, line[2], line[3])
        end
        UI:BeginChoiceMenu("Accepter cette requête ?", {"Oui", "Plus tard"}, 1, 2)
        UI:WaitForChoice()
        local result = UI:ChoiceResult()
        if result == 1 then
          s.Accepted[q.id] = true
          local spk = (q.accept[1] == npcName) and chara or CH(q.accept[1])
          say(spk or chara, q.accept[2], q.accept[3])
        else
          local spk = (q.refuse[1] == npcName) and chara or CH(q.refuse[1])
          say(spk or chara, q.refuse[2], q.refuse[3])
        end
        return true
      end
    end
  end

  return false
end

function SideQuests.Board(ch)
  local list = SideQuests.OfChapter(ch)
  if #list == 0 then
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:WaitShowDialogue("Le tableau des requêtes est vide pour le moment.")
    UI:SetCenter(false)
    return
  end

  local lines = {}
  for _, q in ipairs(list) do
    local st = "[Non acceptée]"
    if SideQuests.IsDone(q.id) then
      st = "[Terminée]"
    elseif SideQuests.IsAccepted(q.id) then
      st = "[En cours]"
    end
    lines[#lines + 1] = string.format("%s %s (%s)", st, q.titre, q.giver)
  end

  UI:BeginMultiPageMenu(24, 24, 240, "Tableau des Requêtes", lines, 6, 1, #lines)
  UI:WaitForChoice()
end

function SideQuests.OnDungeonClear(result, zone)
  if SV.SecondaryJobsCompleted == nil then
    SV.SecondaryJobsCompleted = {}
  end
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    SV.SecondaryJobsCompleted[zone] = true
  end
  return false
end

function SideQuests.PlayRewardCutscene(q_id)
  local s = SideQuests.Ensure()
  for _, q in ipairs(SideQuests.LIST) do
    if q.id == q_id then
      s.Done[q.id] = true
      return true
    end
  end
  return false
end

function SideQuests.PlayJobBoardRewardCutscene(zone_id)
  return true
end

return SideQuests
