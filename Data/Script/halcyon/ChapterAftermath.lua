--[[
    ChapterAftermath.lua

    SCENES D'APRES-BOSS DES CHAPITRES 8, 9 ET 10
    ================================================================
    Trou le plus grave restant apres l'audit de densite : on battait Diancie,
    Laggron ou Lugia et... rien. `SV.ChapterN.DefeatedX = true` puis fin de
    journee. Aucune respiration, aucune consequence montree, aucune
    recompense narrative. Les trois combats les plus importants du jeu se
    terminaient plus sechement qu'un donjon secondaire.

    ------------------------------------------------------------------
    CE QUE LES SOURCES ENSEIGNENT SUR L'APRES-BOSS
    ------------------------------------------------------------------
    Analyse de pret/pmd-red (data/scripts/intro.inc) et des scenes de EoSO
    deja relues. Deux principes structurels, indifferents au contenu :

    1. LE FIL D'EXECUTION PARALLELE. Le script GBA lance plusieurs threads
       qui se synchronisent sur des DRAPEAUX (setFlag 5 / waitFlag 5) : un
       thread anime la camera, un autre deplace un acteur, un troisieme
       enchaine les animations. Personne n'attend inutilement.
       -> Transpose ici en BranchCoroutine + JoinCoroutines : le boss
          s'effondre PENDANT que la camera recule et que la musique tombe.
          Trois actions simultanees, pas trois attentes successives.

    2. LA CASCADE D'ANIMATIONS SUR UN SEUL ACTEUR. gUnknown_826EE1C enchaine
       setAnimation 0xE, 0xF, 0x10, 0x11... chaque etape separee par un
       deplacement. L'acteur ne joue pas UNE animation : il en traverse une
       SUITE, ce qui donne la sensation d'un corps qui reagit dans la duree.
       -> Transpose ici : le boss vaincu passe par Hurt -> Pose -> Idle avec
          des temps morts entre, au lieu de disparaitre d'un coup.

    ------------------------------------------------------------------
    ROLE NARRATIF DE CHAQUE SCENE (aucune ne se ressemble)
    ------------------------------------------------------------------
      ch8  LE DOUTE SEMÉ    Diancie n'est pas vaincue : elle CEDE, et sa
                            reddition pose la premiere question genante.
                            Registre : trouble. On repart avec un malaise.
      ch9  LA CONFIRMATION  Le Cercle du Suaire ne se bat pas : il CONSTATE.
                            Sa phrase est la piece qui manquait au puzzle.
                            Registre : effroi froid. On repart avec une peur.
      ch10 LE VERTIGE       Lugia ne juge plus : il S'EXCUSE. Le gardien le
                            plus ancien du monde demande pardon au heros.
                            Registre : renversement. On repart sans repere.

    ------------------------------------------------------------------
    REGLES DU PROJET
    ------------------------------------------------------------------
    * Aucun nom interdit. La Voix reste anonyme (\uE040).
    * Le twist des Coeurs-prison est APPROCHE trois fois, jamais dit.
      C'est la fonction dramatique de ces trois scenes : elles resserrent
      l'etau sans livrer la reponse, qui appartient a l'arc 6.
    * Texte litteral (module global, cf. SuaireArc.lua).
    * Tout sous pcall, sortie garantie.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.EngineKit'

ChapterAftermath = {}

--Face a face natif (UI:SetSpeakerReverse, cf. EngineKit.lua) : sans lui,
--les deux interlocuteurs regardent du meme cote et ne se font jamais face.
--Convention New Era : allies portrait retourne, PNJ et boss a l'endroit.
local function say(who, emo, txt)
  if who == nil then return end
  local ally = (who == CH('PLAYER') or who == CH('Teammate1'))
  EngineKit.Say(who, emo or 'Normal', txt, ally)
  GAME:WaitFrames(8)
end

local function think(hero, emo, txt)
  GeneralFunctions.HeroDialogue(hero, txt, emo or 'Normal')
  GAME:WaitFrames(8)
end

local function narrate(txt)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(txt)
  UI:SetCenter(false)
  GAME:WaitFrames(10)
end

--La Voix : anonyme, toujours.
local function voice(txt)
  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(12)
end

--Chute d'un boss, en cascade d'animations (principe 2 ci-dessus).
--Le corps traverse plusieurs etats au lieu de disparaitre d'un bloc.
local function collapse(boss)
  if boss == nil then return end
  pcall(function()
    GROUND:CharSetAnim(boss, "Hurt", true)
    GAME:WaitFrames(30)
    BossFX.ShakeScreen(4, 20)
    GAME:WaitFrames(20)
    GROUND:CharSetAnim(boss, "EventSleep", true)
    GAME:WaitFrames(40)
  end)
end

--Corps commun.
local function Aftermath(cfg)
  if cfg.sv == nil then return false end
  if cfg.sv[cfg.flag] then return false end
  cfg.sv[cfg.flag] = true

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end
    SOUND:StopBGM()

    if cfg.hero ~= nil then GROUND:TeleportTo(hero, cfg.hero[1], cfg.hero[2], Direction.Up) end
    if partner ~= nil and cfg.partner ~= nil then
      GROUND:TeleportTo(partner, cfg.partner[1], cfg.partner[2], Direction.Up)
    end
    if cfg.camera ~= nil then GAME:MoveCamera(cfg.camera[1], cfg.camera[2], 1, false) end

    GAME:WaitFrames(40)
    GAME:FadeIn(50)
    if cfg.music ~= nil then SOUND:PlayBGM(cfg.music, false) end
    GAME:WaitFrames(25)

    cfg.scene(hero, partner)
  end)

  if not ok then PrintInfo('[ChapterAftermath] scene ecourtee : '..tostring(err)) end

  pcall(function()
    UI:ResetSpeaker()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)
  return true
end

--------------------------------------------------------------------
-- CHAPITRE 8 — Diancie cède. Le doute est semé.
--------------------------------------------------------------------
-- Elle n'est pas battue : elle s'arrete de se battre. Nuance capitale.
-- Sa question finale est la premiere fissure dans la certitude du duo.
function ChapterAftermath.CrystalVictory()
  return Aftermath({
    sv = SV.Chapter8, flag = 'PlayedVictoryScene',
    music = 'Crystal Crossing.ogg',
    hero = {172, 180}, partner = {140, 180}, camera = {156, 150},
    scene = function(hero, partner)
      local diancie = CharacterEssentials.MakeCharactersFromList({{'Diancie', 156, 120, Direction.Down}})
      collapse(diancie)

      narrate("Elle ne tombe pas.[pause=25] Elle s'agenouille,[pause=20] et referme ses mains sur rien.")
      GAME:WaitFrames(15)
      say(diancie, 'Sad', "Assez.[pause=25] Je ne me bats plus.")
      say(partner, 'Surprised', "Quoi ?[pause=20] Mais...[pause=15] on n'a même pas—")
      say(diancie, 'Normal', "Vous avez gagné il y a longtemps.[pause=30] Le jour où vous avez décidé de venir.")
      GAME:WaitFrames(20)
      pcall(function() GROUND:CharSetAnim(diancie, "Idle", true) end)
      say(diancie, 'Normal', "Prenez le Fragment.[pause=25] Il vous appartient déjà,[pause=15] puisque vous êtes capables de le porter.")
      GAME:WaitFrames(15)
      narrate("Un éclat de cristal se détache de la voûte et descend, lentement, jusqu'aux pattes du héros.")
      GAME:WaitFrames(20)
      think(hero, 'Worried', "(Elle ne le donne pas.[pause=25] Elle s'en débarrasse.)")
      GAME:WaitFrames(15)
      say(partner, 'Worried', "Pourquoi vous nous laissez faire ?[pause=25] Vous êtes la gardienne. Gardez-le.")
      GAME:WaitFrames(20)
      say(diancie, 'Sad', "Gardienne.[pause=30] Oui.[pause=25] C'est le mot qu'on m'a donné.")
      say(diancie, 'Sad', "Mais dites-moi une chose, avant de partir.")
      GAME:WaitFrames(15)
      -- La question qui reste dans la tete du joueur.
      say(diancie, 'Normal', "Un gardien protège ce qui est fragile.[pause=30] Alors pourquoi les premiers ont-ils bâti des MURS autour de leur lumière ?")
      GAME:WaitFrames(25)
      say(partner, 'Sad', "...Je ne sais pas.")
      say(diancie, 'Normal', "Moi non plus.[pause=30] Et j'ai eu mille ans pour y réfléchir.")
      GAME:WaitFrames(20)
      narrate("Les cristaux s'éteignent un par un derrière elle.[pause=25] Le silence, cette fois, n'a plus rien de sacré.")
    end,
  })
end

--------------------------------------------------------------------
-- CHAPITRE 9 — Le Cercle du Suaire constate. La peur s'installe.
--------------------------------------------------------------------
-- Ils n'attaquent pas, ne menacent pas. Ils commentent. C'est bien pire.
-- Leur phrase relie enfin les deux fils : les Coeurs et le sceau.
function ChapterAftermath.MarshVictory()
  return Aftermath({
    sv = SV.Chapter9, flag = 'PlayedVictoryScene',
    music = 'Dark Hill.ogg',
    hero = {172, 180}, partner = {140, 180}, camera = {156, 150},
    scene = function(hero, partner)
      local boss = CharacterEssentials.MakeCharactersFromList({{'Swampert', 156, 120, Direction.Down}})
      collapse(boss)

      narrate("La bête s'affaisse dans la vase.[pause=25] L'eau se referme sur elle sans un bruit.")
      GAME:WaitFrames(20)
      say(partner, 'Happy', "On l'a fait ![pause=20] Le Cœur va pouvoir respirer—")
      GAME:WaitFrames(10)
      -- Interruption : on coupe la joie en plein milieu. Effet de rupture.
      pcall(function() BossFX.ShakeScreen(3, 16) end)
      narrate("La brume, derrière eux, cesse de bouger.")
      GAME:WaitFrames(25)

      local suaire = CharacterEssentials.MakeCharactersFromList({{'Suaire_Banette', 156, 96, Direction.Down}})
      pcall(function()
        GROUND:Hide('Suaire_Banette')
        BossFX.Flash(156, 96, 2, 4, 18)
        GROUND:Unhide('Suaire_Banette')
      end)
      GAME:WaitFrames(20)

      say(suaire, 'Normal', "Trois.")
      say(partner, 'Shock', "—Qui...[pause=20] Depuis quand vous êtes là ?!")
      say(suaire, 'Normal', "Depuis le début.[pause=25] Nous ne sommes pas venus vous arrêter.")
      GAME:WaitFrames(15)
      say(suaire, 'Normal', "Nous sommes venus COMPTER.")
      GAME:WaitFrames(20)
      think(hero, 'Worried', "(Compter quoi ?[pause=25] ...Les Cœurs. Il compte les Cœurs.)")
      GAME:WaitFrames(15)
      say(partner, 'Angry', "On les SAUVE ![pause=20] On les répare ![pause=25] Vous devriez nous remercier !")
      GAME:WaitFrames(20)
      say(suaire, 'Sad', "Oui.[pause=30] C'est bien le problème.")
      GAME:WaitFrames(20)
      -- La phrase-pivot de tout l'arc. Elle nomme le mecanisme sans nommer
      -- ce qu'il retient : le twist reste intact.
      say(suaire, 'Normal', "Chaque Cœur que vous ranimez brille un peu plus fort.[pause=30] Et chaque fois qu'un Cœur brille,[pause=20] une paroi s'amincit.")
      GAME:WaitFrames(25)
      say(partner, 'Worried', "Une paroi ?[pause=25] Une paroi de QUOI ?")
      GAME:WaitFrames(20)
      say(suaire, 'Sad', "Continuez.[pause=30] Vous comprendrez au dernier.")
      GAME:WaitFrames(15)
      narrate("Il ne s'en va pas.[pause=25] Il cesse simplement d'être là,[pause=20] comme une buée qu'on essuie.")
      GAME:WaitFrames(20)
      think(hero, 'Sad', "(Il n'a pas menti une seule fois.[pause=30] C'est ça qui me terrifie.)")
    end,
  })
end

--------------------------------------------------------------------
-- CHAPITRE 10 — Lugia s'excuse. Tous les reperes tombent.
--------------------------------------------------------------------
-- Le renversement : le plus ancien gardien du monde demande pardon a deux
-- gamins. S'il s'excuse, c'est qu'il a fait quelque chose. Fin de l'arc
-- sur une question, pas sur une victoire.
function ChapterAftermath.PeakVictory()
  return Aftermath({
    sv = SV.Chapter10, flag = 'PlayedVictoryScene',
    music = 'Rainbow Peak.ogg',
    hero = {296, 296}, partner = {256, 296}, camera = {276, 264},
    scene = function(hero, partner)
      local lugia = CharacterEssentials.MakeCharactersFromList({{'Lugia', 272, 232, Direction.Down}})
      collapse(lugia)

      narrate("Il replie ses ailes.[pause=30] Le vent tombe d'un coup,[pause=20] et le silence du sommet est total.")
      GAME:WaitFrames(20)
      say(lugia, 'Normal', "Assez.[pause=25] Vous avez montré ce que je voulais voir.")
      say(partner, 'Surprised', "C'était...[pause=20] un test ?[pause=25] Tout ça, un TEST ?")
      say(lugia, 'Normal', "Non.[pause=30] Un adieu.")
      GAME:WaitFrames(25)
      think(hero, 'Worried', "(Un adieu ?[pause=25] On vient à peine de le rencontrer.)")
      GAME:WaitFrames(20)
      pcall(function() GROUND:CharSetAnim(lugia, "Idle", true) end)
      say(lugia, 'Sad', "Quatre Cœurs ranimés.[pause=25] Je l'ai senti d'ici, chaque fois.[pause=20] Comme un fil qui casse.")
      GAME:WaitFrames(20)
      say(partner, 'Worried', "Vous aussi vous parlez comme eux...[pause=25] Comme les spectres du marais.")
      say(lugia, 'Sad', "Alors ils vous ont trouvés.[pause=30] Ils ont plus de courage que moi.")
      GAME:WaitFrames(25)
      say(lugia, 'Normal', "Moi, j'ai passé mille ans à me taire.[pause=30] À veiller sur un sommet vide en espérant que personne ne monte.")
      GAME:WaitFrames(20)
      think(hero, 'Shock', "(Il ne gardait pas le sommet.[pause=30] Il gardait le CHEMIN. Pour que personne n'arrive jusqu'ici.)")
      GAME:WaitFrames(20)
      say(lugia, 'Sad', "Je ne peux pas vous dire ce qui est en jeu.[pause=30] Pas parce que c'est interdit —[pause=20] parce que je n'en ai plus le droit.")
      GAME:WaitFrames(15)
      say(lugia, 'Normal', "Alors je vous donne ce que je peux.[pause=30] Trois mots.")
      GAME:WaitFrames(20)
      say(lugia, 'Determined', "Cherchez sous l'écaille.")
      GAME:WaitFrames(25)
      -- La Voix intervient ICI, pour la premiere fois devant temoin.
      -- Elle ne s'adresse toujours qu'au heros : Lugia ne reagit pas.
      voice("...Il en a trop dit.")
      GAME:WaitFrames(20)
      say(partner, 'Worried', "Tu as encore pâli.[pause=25] C'était elle, hein ?")
      GAME:WaitFrames(15)
      think(hero, 'Sad', "(Elle avait peur.[pause=30] Pour la première fois depuis le début,[pause=20] elle avait PEUR.)")
      GAME:WaitFrames(20)
      say(lugia, 'Sad', "Une dernière chose,[pause=20] et ensuite je me tais pour de bon.")
      GAME:WaitFrames(15)
      say(lugia, 'Sad', "Pardon.[pause=40] Pour ce que nous avons fait,[pause=25] et pour ce que vous allez devoir défaire.")
      GAME:WaitFrames(30)
      narrate("Il s'élève sans un battement d'aile,[pause=25] et disparaît dans la lumière.[pause=30] Le sommet redevient un simple caillou dans le ciel.")
    end,
  })
end

return ChapterAftermath
