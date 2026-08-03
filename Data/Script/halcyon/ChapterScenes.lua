--[[
    ChapterScenes.lua

    SCENES D'ARRIVEE DES CHAPITRES 8, 9 ET 10
    ================================================================
    Ces trois chapitres avaient leur donjon, leurs dialogues de ville et leur
    veillee — mais AUCUNE mise en scene a l'arrivee devant le donjon. On y
    entrait par un simple menu oui/non. Mesure a l'appui : ch1-5 totalisent
    633 a 1229 boites de dialogue chacun, ch8/9/10 en ont 71, 52 et 53.

    ------------------------------------------------------------------
    GRAMMAIRE OBSERVEE DANS LES SOURCES (logique reprise, pas le contenu)
    ------------------------------------------------------------------
    Fichiers relus dans Minemaker0430/ExplorersOfSkyOrigins :
      ground/beach/init.lua            arrivee sur un lieu + malaise du heros
      ground/storm_cutscene_a/init.lua vision, eclairs, bascule synchronisee
      ground/chapter_card/init.lua     carton-titre en coroutines paralleles
      ground/guild_bedroom_night/...   veillee, script GBA garde en commentaire
      CharacterActions.lua             DizzyFade, ShakeHead, ScaredJump

    Ce que ces scenes ont en commun, et qu'on reprend :

    1. ON ETABLIT LE LIEU AVANT LES PERSONNAGES.
       Le son d'ambiance monte AVANT le premier mot (beach : FadeInSE puis
       60 frames d'attente puis dialogue). Le joueur entend le lieu, puis le
       voit, puis seulement on lui parle.

    2. LE DIALOGUE EST EN TROIS TEMPS.
       constat sensoriel -> reaction affective -> decision d'avancer.
       Jamais l'inverse. On ne commente pas l'enjeu avant d'avoir decrit ce
       qu'on a sous les yeux.

    3. LA CAMERA CADRE LE LIEU, PAS LES PERSONNAGES.
       Elle part sur le decor, puis redescend sur le duo au moment de la
       decision. Le mouvement accompagne le changement de sujet.

    4. LE DEPART EST UNE COROUTINE JOINTE.
       Marche, fondu et son se terminent ensemble (patron JoinCoroutines de
       storm_cutscene_a). Rien ne "coupe" : tout s'eteint en meme temps.

    ------------------------------------------------------------------
    IDENTITE PROPRE A CHAQUE CHAPITRE (regle : aucune repetition)
    ------------------------------------------------------------------
      ch8  LE SANCTUAIRE   -> l'emerveillement. Silence, lumiere, beaute.
                              Le duo parle bas. Registre : contemplation.
      ch9  LE MARAIS       -> le degout puis la peur. Odeur, vase, presence.
                              Le duo se serre. Registre : malaise physique.
      ch10 LE PIC          -> l'urgence et la rivalite. Vent, course, defi.
                              Le duo est presse. Registre : adrenaline.

    Aucune des trois n'ouvre de la meme facon, ne se termine de la meme
    facon, ni n'emploie le meme registre de langue.

    ------------------------------------------------------------------
    REGLES DU PROJET
    ------------------------------------------------------------------
    * Texte litteral en francais (module global appele depuis plusieurs
      grounds — MapStrings ne resoudrait pas, cf. SuaireArc.lua).
    * Aucun nom interdit. La Voix reste anonyme.
    * Tout sous pcall, sortie garantie : une scene qui casse ne doit jamais
      laisser le joueur bloque devant une entree de donjon.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

ChapterScenes = {}

--Une replique du partenaire.
local function say(partner, emo, txt)
  if partner == nil then return end
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion(emo or 'Normal')
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(8)
end

--Une pensee du heros.
local function think(hero, emo, txt)
  GeneralFunctions.HeroDialogue(hero, txt, emo or 'Normal')
  GAME:WaitFrames(8)
end

--Narration centree, sans locuteur : sert a poser le decor.
local function narrate(txt)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(txt)
  UI:SetCenter(false)
  GAME:WaitFrames(10)
end

--------------------------------------------------------------------
-- Corps commun : arrivee devant un donjon.
--------------------------------------------------------------------
-- cfg = {
--   flag   = 'CrystalArrival',  -- champ SV.ChapterN, joue une seule fois
--   sv     = SV.Chapter8,
--   music  = 'X.ogg',
--   camera = {x, y},            -- cadrage du DECOR au lever de rideau
--   focus  = {x, y},            -- cadrage du duo au moment de decider
--   scene  = function(hero, partner) ... end,
-- }
local function Arrival(cfg)

	--LE NOIR AVANT TOUT APPEL MOTEUR (correctif d'arrivee, 2026-07-30).
	--Cette scene se joue sous le noir laisse par la carte precedente et ne
	--rallume qu'a son FadeIn final. Mais GAME:FadeOut est BLOQUANT
	--(ScriptGame.cs:1590) et rend la main au moteur : tout appel place
	--avant le premier fondu laisse passer des frames RENDUES, sur une
	--carte chargee mais NON MONTEE (joueur au marqueur par defaut, camera
	--non recadree, decor absent). D'ou l'eclair de zone nue signale en
	--jeu. FadeOut(false,1) sur ecran deja noir = no-op (FadeEffect.cs:63).
	pcall(function() GAME:FadeOut(false, 1) end)
  if cfg.sv == nil then return false end
  if cfg.sv[cfg.flag] then return false end
  cfg.sv[cfg.flag] = true

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end
    SOUND:StopBGM()

    --1. Le lieu d'abord : camera sur le decor, rideau qui se leve lentement.
    if cfg.camera ~= nil then GAME:MoveCamera(cfg.camera[1], cfg.camera[2], 1, false) end
    GAME:FadeIn(50)
    GAME:WaitFrames(30)
    if cfg.music ~= nil then SOUND:PlayBGM(cfg.music, true) end
    GAME:WaitFrames(25)

    --2. La scene propre au chapitre.
    cfg.scene(hero, partner)

    --3. La camera redescend sur le duo : on passe du lieu a la decision.
    if cfg.focus ~= nil then
      GAME:MoveCamera(cfg.focus[1], cfg.focus[2], 60, false)
      GAME:WaitFrames(20)
    end
  end)

  if not ok then PrintInfo('[ChapterScenes] scene ecourtee : '..tostring(err)) end

  --Sortie garantie : le joueur reprend la main quoi qu'il arrive.
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
-- CHAPITRE 8 — Le Sanctuaire de Cristal : l'emerveillement
--------------------------------------------------------------------
-- Registre : contemplation. Ils parlent bas, comme dans une bibliotheque.
-- Le danger n'est pas evoque : c'est la beaute qui inquiete, parce qu'elle
-- est trop parfaite pour etre naturelle.
-- DECOR (mesure sur crystal_sanctuary_entrance.rsground, 2026-08-04) :
-- caverne de cristal 240x312, TexSize 3. Un sentier de pierre claire
-- serpente du bord SUD jusqu'a une arche taillee au NORD (y 104),
-- herissee d'eclats roses et violets. Ce n'est PAS une cascade : le
-- texte precedent decrivait un rideau d'eau qui n'existe pas sur la
-- carte. Corrige.
-- Cadrage : la carte (240 px) est plus etroite que le viewport (320) ;
-- la camera x est donc clampee au centre, seul y compte (120 -> 192).
-- Trajets valides par BFS sur la grille d'obstacles, jamais en ligne
-- droite : le sentier serpente, un deplacement direct traverse la roche.
function ChapterScenes.CrystalArrival()
  return Arrival({
    sv = SV.Chapter8, flag = 'PlayedArrivalScene',
    music = 'Crystal Crossing.ogg',
    camera = {120, 192}, focus = {120, 120},
    scene = function(hero, partner)
      narrate("Aucun écho.[pause=30] Sous terre, une salle de cette taille devrait renvoyer chaque pas.")
      GAME:WaitFrames(20)
      say(partner, 'Surprised', "Écoute...[pause=25] Non. N'écoute pas.[pause=20] Il n'y a RIEN à écouter.")
      say(partner, 'Worried', "Le cristal devrait résonner.[pause=25] On s'entend chuchoter.")
      think(hero, 'Worried', "(Nos pas touchent la pierre.[pause=20] Et le son ne revient pas.)")
      GAME:WaitFrames(20)

      --Le duo remonte le sentier. Waypoints issus du BFS : la marche
      --contourne la roche au lieu de la traverser.
      pcall(function()
        local c1 = TASK:BranchCoroutine(function()
          GROUND:MoveToPosition(hero, 128, 288, false, 1)
          GROUND:MoveToPosition(hero, 128, 232, false, 1)
          GROUND:MoveToPosition(hero, 112, 216, false, 1)
          GROUND:MoveToPosition(hero, 104, 200, false, 1)
        end)
        local c2 = TASK:BranchCoroutine(function()
          GAME:WaitFrames(14)
          GROUND:MoveToPosition(partner, 128, 288, false, 1)
          GROUND:MoveToPosition(partner, 128, 232, false, 1)
          GROUND:MoveToPosition(partner, 120, 232, false, 1)
          GROUND:MoveToPosition(partner, 120, 208, false, 1)
        end)
        TASK:JoinCoroutines({c1, c2})
      end)
      GAME:WaitFrames(15)

      say(partner, 'Normal', "Les cristaux, là-haut...[pause=20] tu vois ?[pause=15] Ils s'allument.[pause=25] Lentement. Comme un souffle.")
      GAME:WaitFrames(15)
      narrate("Une lueur rose parcourt les éclats jusqu'à l'arche, s'éteint, revient.[pause=25] Toujours au même rythme.")
      GAME:WaitFrames(20)
      say(partner, 'Sad', "Phileas a dit que les premiers gardiens avaient écrit leur savoir ici.[pause=30] Moi je ne vois pas une bibliothèque.")
      say(partner, 'Sad', "Je vois un endroit qu'on a fermé.[pause=25] Et le silence, c'est le couvercle.")
      think(hero, 'Normal', "(On ne taille pas une arche pareille pour ranger des livres.[pause=20] On la taille pour garder quelque chose.)")
      GAME:WaitFrames(20)

      --Ils montent jusqu'au seuil : le decor cadre l'arche derriere eux.
      pcall(function()
        local c3 = TASK:BranchCoroutine(function()
          GROUND:MoveToPosition(hero, 104, 152, false, 1)
          GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
        end)
        local c4 = TASK:BranchCoroutine(function()
          GAME:WaitFrames(10)
          GROUND:MoveToPosition(partner, 112, 208, false, 1)
          GROUND:MoveToPosition(partner, 112, 176, false, 1)
          GROUND:MoveToPosition(partner, 128, 176, false, 1)
          GROUND:MoveToPosition(partner, 128, 152, false, 1)
          GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
        end)
        TASK:JoinCoroutines({c3, c4})
      end)
      GAME:WaitFrames(20)

      say(partner, 'Determined', "Bon.[pause=20] On n'est pas venus admirer.[pause=25] On passe sous l'arche et on lit ce qu'ils ont laissé.")
    end,
  })
end

--------------------------------------------------------------------
-- CHAPITRE 9 — Le Marais de l'Oubli : le degout, puis la peur
--------------------------------------------------------------------
-- Registre : malaise physique. Phrases courtes, hachees. Le duo se rapproche
-- au lieu de s'ecarter. On ne montre PAS le Cercle du Suaire : on montre ce
-- qu'il laisse derriere lui. La menace est deja passee par la.
function ChapterScenes.MarshArrival()
  return Arrival({
    sv = SV.Chapter9, flag = 'PlayedArrivalScene',
    music = 'Dark Hill.ogg',
    camera = {160, 96}, focus = {160, 160},
    scene = function(hero, partner)
      narrate("L'odeur arrive avant la vue.[pause=30] Quelque chose de sucré, et de faux.")
      GAME:WaitFrames(20)
      say(partner, 'Pain', "Beurk...[pause=20] Ça sent le...[pause=25] non. Je ne veux pas trouver le mot.")
      think(hero, 'Worried', "(Des fleurs. Ça sent les fleurs.[pause=25] Beaucoup trop de fleurs, pour un marais.)")
      GAME:WaitFrames(20)
      say(partner, 'Worried', "Regarde les roseaux, sur la berge.[pause=25] Ils sont couchés.[pause=20] Tous dans le même sens.")
      say(partner, 'Worried', "Il n'y a pas de vent.[pause=30] Il n'y en a pas eu depuis ce matin.")
      GAME:WaitFrames(15)
      narrate("Quelque chose est passé là. Récemment.[pause=25] Assez lourd pour coucher les roseaux,[pause=15] assez léger pour ne rien casser.")
      GAME:WaitFrames(20)
      -- Le partenaire se rapproche : geste, pas mot. Sky fait beaucoup ca.
      pcall(function()
        if partner ~= nil then
          GROUND:MoveInDirection(partner, Direction.Right, 12, false, 1)
          GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
        end
      end)
      GAME:WaitFrames(15)
      say(partner, 'Sad', "...Je peux rester près de toi ?[pause=30] C'est bête, je sais.")
      think(hero, 'Normal', "(Ce n'est pas bête.[pause=20] Je l'allais le demander.)")
      GAME:WaitFrames(20)
      say(partner, 'Determined', "Bon.[pause=20] Le Cœur est au fond, et il se noie.[pause=25] On n'a pas le luxe d'avoir peur.")
      say(partner, 'Worried', "...On l'aura quand même.[pause=25] Mais on avancera avec.")
    end,
  })
end

--------------------------------------------------------------------
-- CHAPITRE 10 — Le Pic Celeste : l'urgence et la rivalite
--------------------------------------------------------------------
-- Registre : adrenaline. Phrases lancees, coupees. Pas de contemplation :
-- l'Escouade Fulgur a de l'avance et chaque seconde compte. Le vent porte
-- deja leurs voix. On entend les rivaux sans les voir : c'est plus tendu.
function ChapterScenes.PeakArrival()
  return Arrival({
    sv = SV.Chapter10, flag = 'PlayedArrivalScene',
    music = 'Sky Peak Prairie.ogg',
    --Recadrage 2026-08-02 : le ground a ete refait a partir de
    --l'illustration fournie (552x360 au lieu de 240x320). L'ancien
    --cadrage (160,80) tombait dans la falaise, hors de la bande de
    --sable praticable (y 112..240 px). On ouvre desormais sur la
    --gorge et sa grotte, puis on redescend sur le duo.
    camera = {344, 136}, focus = {272, 184},
    scene = function(hero, partner)
      --SE5_Wind_Background : bandeau de 5120x256 (frames 256x256, 20 images),
      --concu pour defiler horizontalement. Il dormait inexploite dans
      --Content/BG. Ici il EST le vent : rafales qui traversent l'ecran de
      --droite a gauche pendant toute la scene.
      pcall(function()
        BossFX.Overlay('SE5_Wind_Background', 0, 0, 20, 600, 60, DrawLayer.Top, -180, 0)
      end)
      narrate("Le vent frappe de côté.[pause=25] Il faut se pencher dedans pour tenir debout.")
      GAME:WaitFrames(15)
      say(partner, 'Surprised', "Là-haut ![pause=15] Sur la deuxième corniche ![pause=20] Trois silhouettes !")
      GAME:WaitFrames(10)
      -- Le vent porte une voix : on ne voit personne, on entend tout.
      narrate("Le vent apporte un éclat de voix.[pause=20] Un rire, peut-être.[pause=25] Puis plus rien.")
      GAME:WaitFrames(15)
      think(hero, 'Shock', "(Ils sont déjà à mi-hauteur.[pause=25] On a perdu deux jours à préparer, et eux sont partis à l'aube.)")
      GAME:WaitFrames(15)
      say(partner, 'Angry', "L'Escouade Fulgur.[pause=20] Évidemment.[pause=25] Ils ne nous ont même pas prévenus.")
      say(partner, 'Worried', "Attends...[pause=25] pourquoi est-ce qu'ils montent SI vite ?[pause=20] Ils ne cherchent pas. Ils SAVENT où aller.")
      GAME:WaitFrames(20)
      think(hero, 'Worried', "(Quelqu'un leur a dit.[pause=30] Ou quelque chose.)")
      GAME:WaitFrames(20)
      say(partner, 'Determined', "On ne les rattrapera pas en montant comme eux.[pause=25] Alors on ne monte pas comme eux.")
      say(partner, 'Happy', "La voie des contreforts.[pause=20] Plus longue, plus dure,[pause=15] et personne ne la prend jamais.")
      think(hero, 'Determined', "(...Ce qui veut dire que personne ne nous y attendra.)")
      GAME:WaitFrames(15)
      say(partner, 'Determined', "Exactement.[pause=25] Accroche-toi.[pause=20] On part maintenant.")

      --ENRICHISSEMENT 2026-08-02 — le decor est desormais l'illustration
      --fournie (552x360). Jusqu'ici la scene etait entierement parlee :
      --deux personnages plantes sur place pendant onze repliques. On lui
      --donne son mouvement, cale sur la geometrie reelle du ground.
      --Positions verifiees libres et accessibles depuis Main_Entrance_Marker.
      pcall(function()
        --Le duo quitte le bas de la gorge et remonte vers l'escalier de
        --pierre qui mene a la grotte. Ils marchent en parlant : la
        --decision est deja prise, on la voit s'executer.
        local m1 = TASK:BranchCoroutine(function()
          GeneralFunctions.EightWayMove(hero, 288, 200, false, 1)
        end)
        local m2 = TASK:BranchCoroutine(function()
          GAME:WaitFrames(10)
          GeneralFunctions.EightWayMove(partner, 272, 208, false, 1)
        end)
        local mc = TASK:BranchCoroutine(function()
          GAME:MoveCamera(280, 200, 90, false)
        end)
        TASK:JoinCoroutines({m1, m2, mc})
        GAME:WaitFrames(15)

        --Le vent redouble au pied de la paroi : on le fait sentir avant
        --la derniere replique, plutot que de le dire.
        SOUND:PlayBattleSE('DUN_Wind')
        pcall(function() BossFX.ShakeScreen(2, 25) end)
        GAME:WaitFrames(20)

        say(partner, 'Worried', "Le vent tourne dans la gorge.[pause=20] Il descend, maintenant.")
        GAME:WaitFrames(12)
        think(hero, 'Determined', "(Il descend parce que quelque chose, la-haut, le pousse vers nous.)")
        GAME:WaitFrames(15)

        --Derniers pas jusqu'au pied de l'escalier, face au nord.
        local s1 = TASK:BranchCoroutine(function()
          GeneralFunctions.EightWayMove(hero, 344, 176, false, 1)
          GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
        end)
        local s2 = TASK:BranchCoroutine(function()
          GAME:WaitFrames(8)
          GeneralFunctions.EightWayMove(partner, 344, 192, false, 1)
          GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
        end)
        local sc = TASK:BranchCoroutine(function()
          GAME:MoveCamera(344, 160, 80, false)
        end)
        TASK:JoinCoroutines({s1, s2, sc})
        GAME:WaitFrames(20)

        narrate("L'escalier taille dans la roche monte vers une ouverture noire.[pause=25] Aucun bruit n'en sort.")
        GAME:WaitFrames(15)
        say(partner, 'Determined', "C'est par la.[pause=20] Apres toi.")
      end)
    end,
  })
end

return ChapterScenes
