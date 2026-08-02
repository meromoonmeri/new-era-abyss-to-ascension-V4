--[[
    MeuteArc.lua — LA MEUTE DE CORBOSS

    Fil narratif recurrent des chapitres 8 a 10, demande par
    PLAN_DIRECTEUR_EXPANSION_CH8_10.md, section 2 :

        « Pour materialiser la montee de tension a l'approche de la
          crise climatique et de la fuite, une bande organisee de
          pilleurs opportunistes, la Meute de Corboss (Honchkrow) et
          ses sous-fifres Cornebre (Murkrow), intervient de maniere
          recurrente dans les donjons. Ils profitent du chaos
          environnemental pour detrousser les explorateurs en detresse. »

    ------------------------------------------------------------------
    ETAT AVANT CE MODULE
    ------------------------------------------------------------------
    Le fil n'existait pas. Un seul Cornebre apparaissait, au mini-boss
    de la Foret Lugubre (ch6), sans meute, sans chef et sans suite.
    Aucun chef n'etait declare dans CharacterEssentials.

    ESPECE DU CHEF : le plan ecrit « Honchkrow ». Ce nom n'apparait nulle
    part dans le projet — ni dans Data/Monster, ni dans la liste de
    spawns de mission_gen.lua (461 especes, ordre alphabetique : rien
    entre honedge et hoppip). L'employer serait inventer un asset. On
    retient mandibuzz, atteste dans cette liste : grand rapace
    charognard, plus credible en chef de bande que l'evolution d'un
    simple Cornebre.

    Pire : la fiche `Murkrow` y etait definie DEUX FOIS — Cornebre en
    ligne 458, puis Varko (PNJ nocturne) en ligne 1288. Lua ne garde que
    la derniere : le mini-boss du ch6 invoquait Varko en croyant
    invoquer Cornebre. Corrige en amont de ce module (Cornebre_Boss).

    ------------------------------------------------------------------
    LA STRUCTURE — TROIS RENCONTRES, UNE PROGRESSION
    ------------------------------------------------------------------
    Le plan demande une recurrence, pas trois combats identiques. Chaque
    rencontre change donc de NATURE :

      ch8   LE GUET      — ils observent, ils comptent, ils ne frappent
                           pas. On ne comprend pas encore ce qu'ils font.
      ch9   LE PILLAGE   — ils depouillent une equipe a terre. On arrive
                           trop tard. Premiere confrontation directe.
      ch10  LA BASCULE   — ils fuient comme tout le monde. Le chef parle
                           enfin, et ce qu'il dit vaut mieux qu'un combat.

    LE RENVERSEMENT DU CH10 est le coeur du fil. Corboss n'est pas un
    mechant : c'est un opportuniste lucide qui a compris avant les
    autres que le ciel tournait mal. Sa derniere replique donne au
    joueur une information que personne d'autre ne pouvait lui donner —
    parce que seul un charognard regarde ou les autres detournent les
    yeux.

    ------------------------------------------------------------------
    PLACEMENT
    ------------------------------------------------------------------
    A la sortie d'un donjon d'expedition, pas d'un donjon d'histoire :
    on ne coupe jamais la ligne principale. Patron SuaireArc.PlayAct.
      ch8   carriere_cuivre
      ch9   marais_errants
      ch10  falaises_envol
    Ces trois zones portent deja une expedition (SideExpeditions) : la
    Meute s'y greffe APRES, ce qui donne au joueur une raison de plus
    d'y aller et lie le contenu optionnel au fil rouge.

    REGLES DU PROJET
      * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
      * Aucun nom des jeux d'origine.
      * La Voix n'intervient pas : ce fil est terrestre, humain, sale.
      * Module global -> texte litteral, pas de .resx.
      * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
      * Tout sous pcall, sortie garantie, jamais d'ecran noir.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

MeuteArc = {}

--Donjon -> numero d'acte. Un seul point de verite.
MeuteArc.ACTS = {
  carriere_cuivre = 1,
  marais_errants  = 2,
  falaises_envol  = 3,
}

--------------------------------------------------------------------
-- ETAT
--------------------------------------------------------------------
local function sv()
  if SV.MeuteArc == nil then SV.MeuteArc = {} end
  local s = SV.MeuteArc
  if s.CurrentAct == nil then s.CurrentAct = 1 end
  if s.Act1Done == nil then s.Act1Done = false end
  if s.Act2Done == nil then s.Act2Done = false end
  if s.Act3Done == nil then s.Act3Done = false end
  --Ce que le joueur a compris de la Meute, pour les dialogues de ville.
  if s.Known == nil then s.Known = false end
  return s
end

--------------------------------------------------------------------
-- UTILITAIRES DE SCENE
--------------------------------------------------------------------
local function say(who, emo, txt)
  local c = CH(who)
  if c == nil then return end
  UI:SetSpeaker(c)
  GeneralFunctions.SetEmotion(emo or 'Normal')
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(8)
end

local function narrate(txt)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(txt)
  UI:SetCenter(false)
  GAME:WaitFrames(8)
end

local function think(hero, emo, txt)
  GeneralFunctions.HeroDialogue(hero, txt, emo or 'Normal')
  GAME:WaitFrames(8)
end

--Fait apparaitre la meute sous un flash, patron BossFX du mod.
local function surgir(liste)
  local sortis = {}
  local ok = pcall(function()
    sortis = CharacterEssentials.MakeCharactersFromList(liste, true)
  end)
  if not ok then return nil end
  for _, e in ipairs(liste) do
    pcall(function() GROUND:Hide(e[1]) end)
  end
  SOUND:PlayBattleSE('EVT_Battle_Flash')
  GAME:WaitFrames(10)
  for _, e in ipairs(liste) do
    pcall(function() BossFX.Flash(e[2], e[3], 3, 5, 18) end)
    pcall(function() GROUND:Unhide(e[1]) end)
    GAME:WaitFrames(6)
  end
  return sortis
end

local function disparaitre(noms)
  SOUND:PlayBattleSE('EVT_Battle_Flash')
  for _, n in ipairs(noms) do
    pcall(function() GROUND:Hide(n) end)
  end
  GAME:WaitFrames(15)
end


--------------------------------------------------------------------
-- ACTE I — LE GUET  (ch8, sortie de la Carriere de Cuivre)
--
-- Ils ne font rien. C'est tout l'interet : le joueur les voit compter,
-- noter, repartir. Une menace qui prend son temps inquiete davantage
-- qu'une menace qui frappe.
--------------------------------------------------------------------
function MeuteArc.Act1(hero, partner)
  local s = sv()

  narrate("Vous remontez le boyau de la carrière.[pause=25] Une odeur de plume mouillée flotte près de la sortie.")
  GAME:WaitFrames(12)

  surgir({
    {'Corboss',        240, 200, Direction.Down},
    {'Cornebre_Boss',  208, 216, Direction.Down},
  })
  GAME:WaitFrames(15)

  say('partner', 'Surprised', "Ils étaient là ?[pause=25] Depuis combien de temps ?")
  say('Cornebre_Boss', 'Normal', "Deux. Une équipe de deux.[pause=20] Chef, je note deux.")
  GAME:WaitFrames(10)
  say('Corboss', 'Normal', "Note aussi qu'ils ressortent debout.[pause=25] C'est rare, cette semaine.")
  GAME:WaitFrames(12)

  think(hero, 'Worried', "(Ils ne nous barrent pas la route.[pause=25] Ils nous COMPTENT.)")
  say('partner', 'Angry', "Qu'est-ce que vous faites ?![pause=20] Vous nous espionnez ?")
  GAME:WaitFrames(10)
  say('Corboss', 'Normal', "Nous tenons des comptes.[pause=25] Qui descend. Qui remonte. Combien il en manque.")
  say('Corboss', 'Happy', "Vous seriez surpris du nombre de gens qui ne remontent pas, ces temps-ci.")
  GAME:WaitFrames(15)

  say('partner', 'Worried', "Et vous en faites quoi, de vos comptes ?")
  say('Corboss', 'Normal', "Rien, pour l'instant.[pause=30] On regarde. On attend.")
  GAME:WaitFrames(12)
  say('Corboss', 'Normal', "Un jour, ce qui traîne au fond n'appartiendra plus à personne.[pause=25] Ce jour-là, nous saurons où chercher.")
  GAME:WaitFrames(18)

  disparaitre({'Corboss', 'Cornebre_Boss'})
  narrate("Ils s'envolent sans hâte,[pause=20] comme des gens qui ont tout leur temps.")
  GAME:WaitFrames(12)

  say('partner', 'Angry', "Des charognards.[pause=25] Ils attendent que les autres tombent.")
  think(hero, 'Worried', "(Ils attendent.[pause=25] Mais ils attendent QUOI, exactement ?)")

  s.Act1Done = true
  s.CurrentAct = 2
  s.Known = true
end


--------------------------------------------------------------------
-- ACTE II — LE PILLAGE  (ch9, sortie des Marais Errants)
--
-- On arrive trop tard. La scene ne se joue pas contre la Meute : elle
-- se joue devant ce qu'elle a laisse. La confrontation vient apres,
-- et elle est verbale — Corboss ne se bat pas quand il peut parler.
--------------------------------------------------------------------
function MeuteArc.Act2(hero, partner)
  local s = sv()

  narrate("Au bord du marais, un sac éventré.[pause=25] Des vivres piétinés dans la vase. Personne.")
  GAME:WaitFrames(15)
  say('partner', 'Shock', "Ce sac...[pause=20] c'est celui d'une équipe de la Guilde !")
  GAME:WaitFrames(10)
  think(hero, 'Worried', "(Les provisions sont là.[pause=25] Seules les Orbes ont disparu.)")
  GAME:WaitFrames(12)

  surgir({
    {'Corboss',        272, 184, Direction.Left},
    {'Cornebre_Boss',  304, 200, Direction.Left},
  })
  say('Cornebre_Boss', 'Happy', "Trois Orbes de Voyage, chef ![pause=20] Presque neuves !")
  GAME:WaitFrames(10)
  say('partner', 'Angry', "VOUS ![pause=20] Où sont-ils ?! Qu'est-ce que vous leur avez fait ?!")
  GAME:WaitFrames(12)

  say('Corboss', 'Normal', "Rien.[pause=30] Strictement rien.")
  say('Corboss', 'Normal', "Ils étaient déjà partis quand nous sommes arrivés.[pause=25] Partis en courant, à en juger par le sac.")
  GAME:WaitFrames(15)

  say('partner', 'Angry', "Et vous avez pris ce qui restait.")
  say('Corboss', 'Happy', "Nous avons ramassé ce qui pourrissait dans la boue.[pause=25] Nuance.")
  GAME:WaitFrames(12)

  think(hero, 'Sad', "(Il ment mal.[pause=25] Ou alors il ne ment pas du tout, et c'est pire.)")
  GAME:WaitFrames(10)

  say('Corboss', 'Normal', "Posez-vous la vraie question, petits.[pause=25] Pas « qui a pris les Orbes ».")
  say('Corboss', 'Worried', "« Qu'est-ce qui fait fuir une équipe entière[pause=15] en abandonnant ses vivres ? »")
  GAME:WaitFrames(20)

  say('partner', 'Worried', "...")
  say('Corboss', 'Normal', "Nous, nous partons avant que ça n'arrive.[pause=25] C'est notre métier de savoir quand.")
  GAME:WaitFrames(15)

  disparaitre({'Corboss', 'Cornebre_Boss'})
  narrate("Le marais se referme sur leur envol.[pause=25] Le sac reste là, ouvert.")
  GAME:WaitFrames(12)

  say('partner', 'Sad', "Je déteste l'admettre.[pause=25] Mais sa question est meilleure que la mienne.")
  think(hero, 'Determined', "(Une équipe entière a fui.[pause=25] Il faut savoir devant quoi.)")

  s.Act2Done = true
  s.CurrentAct = 3
end


--------------------------------------------------------------------
-- ACTE III — LA BASCULE  (ch10, sortie des Falaises de l'Envol)
--
-- Le renversement. Corboss ne pille plus : il decampe, et il le dit.
-- Un charognard qui fuit, c'est un signe que rien d'autre ne donne.
-- Il laisse une information, pas par bonte : parce qu'il n'en a plus
-- l'usage.
--------------------------------------------------------------------
function MeuteArc.Act3(hero, partner)
  local s = sv()

  narrate("Les falaises sont vides.[pause=25] Pas un cri, pas une plume dans le vent.")
  GAME:WaitFrames(15)

  surgir({
    {'Corboss',        248, 176, Direction.Down},
  })
  GAME:WaitFrames(12)

  say('partner', 'Surprised', "Vous ?[pause=20] Tout seul ?[pause=25] Où est votre bande ?")
  GAME:WaitFrames(10)
  say('Corboss', 'Worried', "Partis.[pause=30] Je les ai envoyés au sud il y a deux jours.")
  GAME:WaitFrames(15)

  think(hero, 'Shock', "(Il a renvoyé sa propre meute.[pause=25] Un charognard n'abandonne jamais un territoire.)")
  GAME:WaitFrames(12)

  say('partner', 'Worried', "Vous ne pillez plus ?")
  say('Corboss', 'Sad', "Il n'y a plus rien à piller.[pause=25] C'est exactement le problème.")
  GAME:WaitFrames(15)

  say('Corboss', 'Normal', "J'ai compté pendant des mois.[pause=25] Qui descend, qui remonte. Vous vous souvenez ?")
  say('Corboss', 'Worried', "Depuis six jours, plus personne ne descend.[pause=25] Et ceux d'en haut sont partis les premiers.")
  GAME:WaitFrames(18)

  say('partner', 'Shock', "Les Pokémon volants...[pause=25] Ils ont tous quitté les falaises.")
  say('Corboss', 'Normal', "Nous sentons le vent avant vous.[pause=25] C'est le seul avantage d'être ce que nous sommes.")
  GAME:WaitFrames(15)

  --Le don d'information : sec, sans chaleur, et d'autant plus credible.
  say('Corboss', 'Normal', "Alors je vais vous dire une chose,[pause=15] et nous serons quittes.")
  GAME:WaitFrames(10)
  say('Corboss', 'Worried', "Le vent ne descend plus de la montagne.[pause=30] Il y MONTE.")
  GAME:WaitFrames(20)
  say('Corboss', 'Sad', "Quelque chose là-haut respire à l'envers.[pause=25] Et ça aspire tout le reste avec.")
  GAME:WaitFrames(20)

  think(hero, 'Determined', "(Le vent qui monte.[pause=25] Le Veilleur l'avait dit autrement, mais il l'avait dit.)")
  GAME:WaitFrames(12)

  say('partner', 'Worried', "Pourquoi nous dire ça ?[pause=25] Vous ne nous devez rien.")
  GAME:WaitFrames(10)
  say('Corboss', 'Normal', "Parce que vous montez quand même.[pause=30] Et que je n'ai jamais compris les gens comme vous.")
  say('Corboss', 'Happy', "Si vous redescendez,[pause=20] j'aimerais assez être là pour le noter.")
  GAME:WaitFrames(18)

  disparaitre({'Corboss'})
  narrate("Il part vers le sud,[pause=20] dans la direction où sont partis tous les autres.")
  GAME:WaitFrames(15)

  say('partner', 'Determined', "Même les charognards fuient.[pause=25] Nous, on monte.")
  think(hero, 'Determined', "(Le vent monte.[pause=25] Alors on montera plus vite que lui.)")

  s.Act3Done = true
  s.CurrentAct = 4
end


--------------------------------------------------------------------
-- ORDONNANCEMENT
--------------------------------------------------------------------
-- Un acte ne se joue que si le precedent est fait ET si le chapitre
-- courant correspond. On ne rejoue jamais un acte.
--------------------------------------------------------------------
local CH_OF_ACT = { [1] = 8, [2] = 9, [3] = 10 }

function MeuteArc.IsActReady(zoneID)
  local n = MeuteArc.ACTS[zoneID]
  if n == nil then return false end
  local s = sv()
  if s['Act' .. n .. 'Done'] then return false end
  if s.CurrentAct ~= n then return false end

  local ch = 0
  pcall(function() ch = SV.ChapterProgression.Chapter or 0 end)
  if ch < (CH_OF_ACT[n] or 99) then return false end
  return true
end

--------------------------------------------------------------------
-- MeuteArc.PlayAct(zoneID)
--
-- A appeler depuis le ExitSegment de la zone, sur une victoire.
-- Renvoie true si un acte a ete joue (l'appelant doit alors sortir en
-- mode cinematique), false sinon.
--------------------------------------------------------------------
function MeuteArc.PlayAct(zoneID)
  if not MeuteArc.IsActReady(zoneID) then return false end
  local n = MeuteArc.ACTS[zoneID]
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  PrintInfo("[MeuteArc] acte " .. tostring(n) .. " — " .. tostring(zoneID))
  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:PlayBGM('Team_Dazzling.ogg', true)
  GAME:WaitFrames(20)

  local body = ({ MeuteArc.Act1, MeuteArc.Act2, MeuteArc.Act3 })[n]
  local ok, err = pcall(body, hero, partner)
  if not ok then
    --Jamais d'ecran noir : on trace, on marque l'acte fait, on sort.
    PrintInfo("[MeuteArc] ERREUR acte " .. tostring(n) .. " : " .. tostring(err))
    local s = sv()
    s['Act' .. n .. 'Done'] = true
    s.CurrentAct = n + 1
  end

  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetCenter(false) end)
  GAME:WaitFrames(20)
  GAME:FadeOut(false, 40)
  SOUND:FadeOutBGM(40)
  GAME:WaitFrames(30)
  pcall(function()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
  end)
  GAME:CutsceneMode(false)
  return true
end

--Combien d'actes restent a voir ?
function MeuteArc.Remaining()
  local s = sv()
  local n = 0
  for i = 1, 3 do
    if not s['Act' .. i .. 'Done'] then n = n + 1 end
  end
  return n
end

return MeuteArc
