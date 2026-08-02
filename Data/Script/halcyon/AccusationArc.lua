--[[
    AccusationArc.lua — Chapitre 11 : « Ceux que l'on accuse »

    Le Cercle du Suaire ne ment pas. C'est toute sa force depuis le ch6 :
    « Il n'a pas menti une seule fois. C'est ca qui me terrifie. »
    Ici, il ne commence pas a mentir — il DEFORME. Il prend une legende
    vraie (celle que Penticus raconte dans metano_town_legend.lua : des
    voyageurs venus d'ailleurs, reveilles dans un corps de Pokemon, qui
    ont sauve le monde) et il en retourne la lecture :

        « Ils ont sauve le monde. D'accord.
          Mais de QUOI l'ont-ils sauve, a chaque fois ? »
        « D'une catastrophe qui a commence le jour ou ils sont arrives. »

    C'est faux comme conclusion, exact comme enumeration. Personne ne
    peut le contredire avec des faits — seulement avec de la confiance.
    D'ou la fracture : ceux qui connaissent le heros n'y croient pas,
    ceux qui ne le connaissent pas y croient.

    STRUCTURE — 10 scenes
      1. Retour au sol           la lueur pourpre a ete vue de partout
      2. La rumeur               les commercants detournent le regard
      3. Le discours du Suaire   la scene longue, sur la place
      4. Plum                    la seule voix qui refuse, et qui ne pese rien
      5. La guilde protege       Penticus ferme les portes
      6. Le boycott              les echoppes closes une a une
      7. La manifestation        devant la guilde, de nuit
      8. Le conseil de la guilde Penticus n'a plus les moyens
      9. La decision             le partenaire choisit, de lui-meme
     10. Le depart               la fuite sous la pluie

    REGLES : le heros ne parle qu'en pensees ; jamais « Abime »,
    « Necrozma », « Eternatus », « prison » ; les personnages des jeux
    d'origine ne sont jamais nommes ; repliques < 150 caracteres hors
    [pause=N] ; aucune narration dans une scene jouee, seulement pour
    ouvrir ou clore un acte, avec fondu ; chaque personnage se reoriente
    depuis SA position ; toute scene sous pcall avec sortie garantie.

    Le mot « humain » est employe ici : il l'est deja dans la trame
    (relic_forest_ch_1, guild_guildmasters_room_ch_1, metano_town_legend)
    et c'est le pivot de l'accusation. Ce qui reste interdit, c'est de
    NOMMER les personnages des jeux d'origine — on n'en nomme aucun.
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

AccusationArc = {}

--------------------------------------------------------------------
-- Etat
--------------------------------------------------------------------
local function sv()
  if SV.AccusationArc == nil then SV.AccusationArc = {} end
  local s = SV.AccusationArc
  if s.Scene == nil then s.Scene = 0 end
  return s
end

--------------------------------------------------------------------
-- Briques de mise en scene
--------------------------------------------------------------------
local function say(who, emo, txt)
  if who == nil then return end
  UI:SetSpeaker(who)
  GeneralFunctions.SetEmotion(emo or 'Normal')
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(10)
end

local function think(hero, emo, txt)
  GeneralFunctions.HeroDialogue(hero, txt, emo or 'Normal')
  GAME:WaitFrames(10)
end

-- Narration : uniquement pour ouvrir ou clore un acte, avec fondu.
local function narrate(txt)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(txt)
  UI:SetCenter(false)
  GAME:WaitFrames(12)
end

-- Une voix dans la foule, sans visage : personne ne l'assume.
local function crowd(txt)
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(10)
end

-- Rumeur : la foule bruisse sans parler. Emotes en cascade, decalees,
-- pour que le groupe ne reagisse pas comme un seul bloc.
local function murmur(chars, emote)
  for i, c in ipairs(chars) do
    if c ~= nil then
      pcall(function() GROUND:CharSetEmote(c, emote or "question", 1) end)
      GAME:WaitFrames(4 + (i % 3) * 3)
    end
  end
  GAME:WaitFrames(15)
end

-- Chacun se tourne vers une cible depuis SA position (regle 5.2).
local function allTurnTo(chars, target)
  for i, c in ipairs(chars) do
    if c ~= nil and target ~= nil then
      pcall(function() GROUND:CharTurnToCharAnimated(c, target, 4) end)
      GAME:WaitFrames(3 + (i % 2) * 2)
    end
  end
end

--------------------------------------------------------------------
-- Positions de la place, relevees sur la grille de collision de
-- metano_town (189x189 cellules de 8 px) et verifiees libres ET
-- reliees a l'entree de la guilde par un parcours en largeur.
--------------------------------------------------------------------
AccusationArc.POS = {
  GUILDE   = {696, 904},
  MENEUR   = {696, 976},
  PNJ_1    = {632, 984},
  PNJ_2    = {664, 1000},
  PNJ_3    = {728, 992},
  PNJ_4    = {736, 984},
  PNJ_5    = {688, 1016},
  PNJ_6    = {720, 1016},
  PLUM     = {616, 952},
  HERO     = {688, 936},
  PARTNER  = {712, 936},
  CAMERA   = {696, 960},
}

--------------------------------------------------------------------
-- SCENE 3 — Le discours du Suaire.
-- Le morceau de bravoure du chapitre. Il ne crie pas, il enumere.
--------------------------------------------------------------------
function AccusationArc.Scene3_Discours(hero, partner)
  local P = AccusationArc.POS

  local suaire = CharacterEssentials.MakeCharactersFromList({
    {'Suaire_Banette', P.MENEUR[1], P.MENEUR[2], Direction.Up}
  })
  local linceul = CharacterEssentials.MakeCharactersFromList({
    {'Suaire_Gengar', P.PNJ_1[1], P.PNJ_1[2], Direction.UpRight}
  })
  local litanie = CharacterEssentials.MakeCharactersFromList({
    {'Suaire_Noivern', P.PNJ_4[1], P.PNJ_4[2], Direction.UpLeft}
  })

  -- Les habitants presents sur la carte servent de foule : on ne
  -- fabrique pas des figurants, on utilise ceux qui vivent la.
  local foule = {}
  for _, n in ipairs({'Red_Merchant', 'Green_Merchant', 'Legend_Merchant',
                      'Shop_Owner', 'Bank_Owner', 'Musician'}) do
    local c = CH(n)
    if c ~= nil then table.insert(foule, c) end
  end

  GAME:MoveCamera(P.CAMERA[1], P.CAMERA[2], 60, false)
  GAME:WaitFrames(20)

  -- Il laisse le silence s'installer avant de parler. (regle 6.2)
  SOUND:FadeOutBGM(60)
  GAME:WaitFrames(45)

  say(suaire, 'Normal', "Je ne suis pas venu me battre.[pause=25] Je viens vous raconter une histoire que vous croyez connaitre.")
  murmur(foule, "question")

  say(suaire, 'Normal', "Il y a trente ans, une etoile est tombee.[pause=20] Qui l'a arretee ?[pause=15] Un voyageur venu d'ailleurs.")
  say(suaire, 'Normal', "Il y a quinze ans, le temps s'est fissure.[pause=20] Qui l'a repare ?[pause=15] Un autre voyageur venu d'ailleurs.")
  GAME:WaitFrames(20)

  say(linceul, 'Normal', "Chaque fois, on les a remercies.[pause=20] Chaque fois, on a grave leur nom.")
  GAME:WaitFrames(15)

  -- Le retournement. Il ne hausse pas la voix.
  say(suaire, 'Normal', "Alors posez-vous la seule question qui compte.[pause=30] De quoi vous ont-ils sauves ?")
  GAME:WaitFrames(25)
  say(suaire, 'Normal', "D'une catastrophe.[pause=25] Qui a commence le jour ou ils sont arrives.")

  murmur(foule, "exclaim")
  crowd("Attendez...[pause=20] c'est vrai que ca tombe toujours en meme temps...")
  GAME:WaitFrames(15)

  say(litanie, 'Normal', "Jamais avant.[pause=25] Jamais apres.[pause=20] Toujours pendant.")
  GAME:WaitFrames(20)

  -- Il se tourne vers le heros. La foule suit son regard.
  pcall(function() GROUND:CharTurnToCharAnimated(suaire, hero, 6) end)
  GAME:WaitFrames(15)
  allTurnTo(foule, hero)
  GAME:WaitFrames(20)

  say(suaire, 'Normal', "Et hier soir, le ciel a brule au-dessus de cette vallee.[pause=25] Qui etait la-haut ?")
  GAME:WaitFrames(25)

  think(hero, 'Worried', "(Il ne dit rien de faux.[pause=30] Pas une seule fois.)")
  GAME:WaitFrames(20)

  say(partner, 'Shouting', "On a EMPECHE ce truc de tomber ![pause=20] Sans nous, il n'y aurait plus de vallee !")
  GAME:WaitFrames(15)

  say(suaire, 'Sad', "Je te crois.[pause=30] C'est ce qu'ils ont tous dit.[pause=25] Et ils disaient vrai, eux aussi.")
  GAME:WaitFrames(25)

  say(suaire, 'Normal', "Je n'accuse personne d'avoir voulu le mal.[pause=30] J'observe que la ou ils passent,[pause=15] le monde manque de finir.")
  GAME:WaitFrames(20)

  crowd("Il a raison...[pause=20] Depuis qu'ils sont arrives, il se passe toujours quelque chose.")
  murmur(foule, "sweatdrop")

  -- La litanie, reprise par la foule. C'est le moment ou ca bascule.
  say(litanie, 'Normal', "Ce qui brille appelle.[pause=20] Ce qui s'eteint oublie.")
  GAME:WaitFrames(15)
  crowd("« Que l'oubli nous couvre tous. »")
  GAME:WaitFrames(25)

  think(hero, 'Sad', "(Ils reprennent ses mots.[pause=30] Ils ne les avaient jamais entendus avant ce soir.)")
  GAME:WaitFrames(20)

  -- Il s'en va sans conclure : il laisse la ville finir a sa place.
  -- Pas de narration ici — la scene est jouee, donc on la JOUE : il
  -- s'efface pendant que la foule, elle, ne bouge pas.
  SOUND:PlayBattleSE('EVT_Emote_Startled_2')
  BossFX.Flash(P.MENEUR[1], P.MENEUR[2], 6, 8, 34)
  for _, c in ipairs({suaire, linceul, litanie}) do
    if c ~= nil then
      pcall(function() GROUND:Hide(c.EntName) end)
      GAME:WaitFrames(8)
    end
  end
  GAME:WaitFrames(25)

  say(partner, 'Surprised', "Ou est-ce qu'ils sont passes ?![pause=25] Ils etaient la, juste la !")
  GAME:WaitFrames(20)
  -- Personne dans la foule ne se retourne pour les chercher.
  think(hero, 'Worried', "(Personne ne les cherche.[pause=30] Ils regardent tous ailleurs.)")
  GAME:WaitFrames(20)

  local s = sv()
  s.HeardAccusation = true
  s.Scene = 3
end

--------------------------------------------------------------------
-- SCENE 4 — Plum.
-- Elle ne demonte pas l'argument : elle refuse de le regarder. C'est
-- une amie, pas une avocate. Et ca ne pese rien face a la foule.
--------------------------------------------------------------------
function AccusationArc.Scene4_Plum(hero, partner)
  local P = AccusationArc.POS
  local plum = CH('Jigglypuff')
  if plum == nil then
    plum = CharacterEssentials.MakeCharactersFromList({
      {'Jigglypuff', P.PLUM[1], P.PLUM[2], Direction.Right}
    })
  else
    GROUND:TeleportTo(plum, P.PLUM[1], P.PLUM[2], Direction.Right)
  end

  pcall(function() GROUND:CharSetEmote(plum, "angry", 1) end)
  GAME:WaitFrames(20)

  say(plum, 'Angry', "N'importe quoi.[pause=25] Voila.[pause=15] C'est tout ce que j'ai a dire.")
  GAME:WaitFrames(15)

  crowd("Plum, tu ne peux pas savoir—")
  say(plum, 'Shouting', "Si ![pause=20] Je sais qui m'a ramenee du Mont Windsep quand personne ne voulait y monter.")
  GAME:WaitFrames(20)

  say(plum, 'Angry', "Vous voulez des dates et des etoiles qui tombent ?[pause=25] Moi j'ai des souvenirs.")
  GAME:WaitFrames(20)

  crowd("...")
  GAME:WaitFrames(20)

  say(plum, 'Sad', "Personne ne dit rien.[pause=30] Vous avez tous quelque chose a dire d'habitude.")
  GAME:WaitFrames(25)

  pcall(function() GROUND:CharTurnToCharAnimated(plum, hero, 4) end)
  say(plum, 'Determined', "Je ne les crois pas.[pause=25] Je voulais que tu l'entendes de quelqu'un.")
  GAME:WaitFrames(20)

  think(hero, 'Sad', "(Une voix.[pause=30] Contre une place entiere.)")
  GAME:WaitFrames(15)

  local s = sv()
  s.PlumDefended = true
  s.Scene = 4
end

--------------------------------------------------------------------
-- SCENE 7 — La manifestation devant la guilde, de nuit.
-- Personne ne force la porte. C'est pire : ils attendent.
--------------------------------------------------------------------
function AccusationArc.Scene7_Manifestation(hero, partner)
  local P = AccusationArc.POS

  -- La foule est faite d'habitants REELS de la ville, deplaces devant la
  -- guilde. On ne duplique pas une meme fiche : chaque entree de
  -- CharacterEssentials porte un `instance` unique, et spawner deux fois
  -- la meme cle donnerait deux entites au meme EntName — CH(), Hide() et
  -- les handlers viseraient alors la mauvaise. Les visages sont donc
  -- ceux que le joueur connait : c'est aussi plus dur a encaisser.
  local rangs = {}
  local ordre = {'MENEUR','PNJ_1','PNJ_2','PNJ_3','PNJ_4','PNJ_5','PNJ_6'}
  local noms  = {'Red_Merchant','Green_Merchant','Shop_Owner',
                 'Bank_Owner','Storage_Owner','Musician','Tutor_Owner'}
  for i, n in ipairs(noms) do
    local c = CH(n)
    local p = P[ordre[i]]
    if c ~= nil and p ~= nil then
      pcall(function() GROUND:TeleportTo(c, p[1], p[2], Direction.Up) end)
      table.insert(rangs, c)
    end
  end

  GAME:MoveCamera(P.CAMERA[1], P.CAMERA[2] + 20, 60, false)
  SOUND:PlayBGM('Growing Anxiety.ogg', true)
  GAME:WaitFrames(40)

  crowd("Qu'ils sortent ![pause=20] On veut juste qu'ils sortent !")
  murmur(rangs, "angry")
  GAME:WaitFrames(20)

  say(partner, 'Worried', "Ils sont la depuis le coucher du soleil.[pause=25] Ils ne frappent meme pas.")
  GAME:WaitFrames(20)

  think(hero, 'Sad', "(Ils attendent.[pause=30] Comme si on allait finir par leur donner raison.)")
  GAME:WaitFrames(25)

  crowd("Mon echoppe est fermee depuis trois jours ![pause=20] Qui va me rembourser ?")
  GAME:WaitFrames(15)
  crowd("Ce n'est pas contre toi, petit ![pause=25] C'est contre ce que tu attires !")
  GAME:WaitFrames(25)

  say(partner, 'Angry', "« Ce n'est pas contre toi. »[pause=25] Ils sont devant chez nous a minuit.")
  GAME:WaitFrames(20)

  local s = sv()
  s.SawProtest = true
  s.Scene = 7
end

--------------------------------------------------------------------
-- SCENE 9 — La decision. Le partenaire choisit de lui-meme.
-- Le heros ne le lui demande pas — il ne peut pas le lui demander.
--------------------------------------------------------------------
function AccusationArc.Scene9_Decision(hero, partner)
  SOUND:FadeOutBGM(60)
  GAME:WaitFrames(40)

  think(hero, 'Sad', "(Si je pars, tout ca s'arrete.[pause=30] La guilde respire.[pause=20] Plum respire.)")
  GAME:WaitFrames(25)

  say(partner, 'Normal', "Tu as ton air de quand tu as deja decide.")
  GAME:WaitFrames(20)

  think(hero, 'Sad', "(...)")
  GAME:WaitFrames(20)

  say(partner, 'Determined', "Alors je le dis avant toi.[pause=25] Je viens.")
  GAME:WaitFrames(20)

  say(partner, 'Normal', "Et non, ce n'est pas pour toi.[pause=25] C'est ma decision, pas un service.")
  GAME:WaitFrames(25)

  say(partner, 'Determined', "Ils ont trente ans d'histoires et pas une preuve.[pause=20] On va leur en chercher une.")
  GAME:WaitFrames(20)

  think(hero, 'Determined', "(Il n'a pas hesite une seconde.[pause=30] Moi j'ai hesite toute la nuit.)")
  GAME:WaitFrames(20)

  local s = sv()
  s.PartnerChose = true
  s.Scene = 9
end

--------------------------------------------------------------------
-- Enveloppe commune : cutscene mode, IA, sortie garantie.
--------------------------------------------------------------------
function AccusationArc.Play(sceneFn, label)
  local hero    = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  local ok, err = pcall(sceneFn, hero, partner)
  if not ok then
    PrintInfo("[AccusationArc] " .. tostring(label) .. " interrompue : " .. tostring(err))
  end

  pcall(function()
    UI:ResetSpeaker()
    GeneralFunctions.RestoreIdleAnim()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)
  return ok
end

return AccusationArc
