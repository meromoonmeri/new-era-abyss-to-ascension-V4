--[[
    VeilleurArc.lua

    LES VEILLEURS DU RESEAU DES ANCIENS CHEMINS — APRES-BOSS
    ================================================================
    Constat de tools/audit_boss_cinematics.py :

        histoire     9 scenes · 80.2/100 · 19.9 boites de boss
        reseau      10 scenes · 24.1/100 ·  3.6 boites de boss
        legendaire  38 scenes · 17.3/100 ·  2.0 boites de boss

    Les 10 Veilleurs ont une bonne AMORCE (signal -> irruption -> recul ->
    reveal -> titre -> echange) et une identite deja ecrite, souvent tres
    juste : « Je suis la lampe qu'on a laissee au fond. » Ce qui leur
    manquait n'etait pas l'entree en scene, c'etait la SORTIE :

      * aucun apres-boss. On les battait, le partenaire lachait UNE phrase
        depuis zone/new_era_zone_XX/init.lua, et on rentrait en ville.
      * le Veilleur, lui, ne disait plus rien apres le combat. Il avait
        pose une question au debut et n'y repondait jamais.

    ------------------------------------------------------------------
    LA REGLE DU RESEAU (etablie par docs/reseau_veilleurs_dialogues.md)
    ------------------------------------------------------------------
    Un Veilleur n'est PAS un legendaire : c'est un Pokemon ordinaire que les
    batisseurs ont charge, il y a des siecles, de tenir une porte « jusqu'a
    ce que quelqu'un ait une bonne raison de passer ».

    Consequence dramatique, valable pour les dix : ils ne sont pas vaincus,
    ils sont RELEVES. Le combat n'est pas une conquete, c'est la fin d'une
    faction. Chacun reagit differemment a cette liberation — c'est la que
    se joue leur individualite, et c'est ce qui evite les dix redites.

    ------------------------------------------------------------------
    CE QUI EST REPRIS DES SOURCES
    ------------------------------------------------------------------
    * pmd-red (intro.inc) : cascade d'animations sur un acteur. Le Veilleur
      traverse Hurt -> Idle -> EventSleep avec des temps morts, il ne
      s'eteint pas d'un bloc.
    * Scene du Tunnel Ardent (reference interne, 97/100) : la camera REMONTE
      sur celui qui parle, se RESSERRE sur la phrase-pivot, REDESCEND en
      cadre commun pour la reponse du duo. Et surtout : le vaincu TRANSMET
      quelque chose d'utile au lieu de s'evaporer.

    ------------------------------------------------------------------
    REGLES DU PROJET
    ------------------------------------------------------------------
    * Module GLOBAL -> texte LITTERAL, jamais STRINGS.MapStrings (qui ne
      contient que les cles du ground courant). Patron SuaireArc.lua.
    * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
    * La Voix reste anonyme et ne parle PAS ici : le Reseau est une
      infrastructure oubliee, pas son territoire. Son silence est voulu.
    * Repliques courtes, < 150 caracteres hors balises [pause=N].
    * Tout sous pcall, sortie garantie.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

VeilleurArc = {}

local function say(who, txt, emo)
  if who == nil then return end
  UI:SetSpeaker(who)
  if emo ~= nil then UI:SetSpeakerEmotion(emo) end
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(10)
end

local function narrate(txt)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(txt)
  UI:SetCenter(false)
  GAME:WaitFrames(10)
end

--------------------------------------------------------------------
-- FICHES DES DIX VEILLEURS
--------------------------------------------------------------------
-- Chaque fiche donne : l'instance sur la carte, sa position, un cadrage,
-- et surtout une REACTION PROPRE a sa liberation. Aucune ne se repete :
--   soulagement / deni / curiosite / peur / humour / deuil / colere
--   froide / incomprehension / gratitude / refus de partir.
--
-- `lines` = repliques du Veilleur (registre du personnage).
-- `partner` = ce que repond le partenaire (1 seule, il n'a pas la vedette).
-- `hero` = pensee du heros, facultative.
-- `close` = narration de sortie.
VeilleurArc.LIST = {

  -- ---- Rempart (bastiodon) — encastre dans le pylone depuis des siecles.
  -- Reaction : INCOMPREHENSION. Il ne sait pas quoi faire de sa liberte.
  ['new_era_zone_02'] = {
    inst = 'Rempart', pos = {160, 112}, cam = {160, 130}, wide = {160, 160},
    lines = {
      "Vous êtes passés.[pause=30] ...Et maintenant ?",
      "On m'a dit de tenir.[pause=25] Personne ne m'a dit ce qu'on fait après.",
      "Je crois que je vais rester.[pause=30] Le fer est froid, mais je le connais.",
    },
    partner = "Vous pouvez venir avec nous, vous savez.",
    last = "Peut-être.[pause=30] Demandez-moi encore dans cent ans.",
    close = "Le colosse se rassoit contre le pylône.[pause=25] Le métal résonne, puis se tait.",
  },

  -- ---- Cable-Vif (eelektross) — l'antenne du Grand Orage.
  -- Reaction : SOULAGEMENT BAVARD. Il n'a parle a personne depuis des siecles.
  ['new_era_zone_05'] = {
    inst = 'CableVif', pos = {184, 176}, cam = {184, 194}, wide = {184, 224},
    lines = {
      "Ha !![pause=25] HA ![pause=20] Vous avez tenu le courant !",
      "Savez-vous depuis combien de temps je n'avais parlé à personne ?",
      "Moi non plus.[pause=30] J'ai arrêté de compter les orages.",
    },
    partner = "Vous avez l'air... presque content d'avoir perdu ?",
    last = "Perdu ?[pause=25] J'ai été RELEVÉ, petit.[pause=20] Ce n'est pas pareil.",
    close = "L'antenne cesse de grésiller.[pause=25] Pour la première fois depuis des siècles, la voie est calme.",
  },

  -- ---- Fusible (magmortar) — la cheminee du Reacteur Rouge.
  -- Reaction : COLERE FROIDE. Il en veut a ceux qui l'ont oublie.
  ['new_era_zone_09'] = {
    inst = 'Fusible', pos = {160, 112}, cam = {160, 130}, wide = {160, 160},
    lines = {
      "...Bien.[pause=30] La voie est à vous.",
      "Dites-moi une chose.[pause=25] Là d'où vous venez, on se souvient des bâtisseurs ?",
      "Non.[pause=30] Bien sûr que non.",
    },
    partner = "On ne savait même pas que vous existiez.",
    last = "Ils m'ont posté, puis ils sont partis.[pause=30] Le feu, lui, est resté.",
    close = "La cheminée souffle une dernière fois,[pause=20] et le rouge retombe au fond du conduit.",
  },

  -- ---- Blizzard-Sentinelle (abomasnow) — la Foret du Givre Statique.
  -- Reaction : DEUIL. Il gardait quelque chose qui n'existe plus.
  ['new_era_zone_11'] = {
    inst = 'BlizzardSentinelle', pos = {136, 200}, cam = {136, 218}, wide = {136, 248},
    lines = {
      "Assez.[pause=30] Le givre vous laisse passer.",
      "Il y avait une forêt ici.[pause=25] Une vraie. Avec des choses vivantes dedans.",
      "Je la garde encore.[pause=30] Même s'il ne reste que le froid.",
    },
    partner = "...On est désolés.",
    last = "Ne le soyez pas.[pause=25] Allez voir s'il en reste ailleurs.",
    close = "La neige tombe droit, sans vent.[pause=25] Le Veilleur ne bouge plus.",
  },

  -- ---- Voile-Blanc + Masque-Gel (froslass + glalie) — l'Aiguille du Zero.
  -- Reaction : DUO QUI SE CHAMAILLE. Le seul registre leger des dix.
  ['new_era_zone_13'] = {
    inst = 'VoileBlanc', pos = {104, 152}, cam = {128, 168}, wide = {128, 190},
    inst2 = 'MasqueGel', pos2 = {152, 152},
    lines = {
      "Tu vois ?[pause=20] Je t'avais dit qu'ils passeraient.",
    },
    lines2 = {
      "Tu dis ça à chaque fois.[pause=25] Depuis mille ans.",
      "Et à chaque fois je me trompe.[pause=20] Sauf aujourd'hui.",
    },
    partner = "Vous... vous vous disputez depuis MILLE ANS ?",
    last = "Que voulez-vous.[pause=25] La relève ne venait pas.",
    close = "Les deux Veilleurs recommencent à se chamailler.[pause=25] La voie du Zéro est ouverte.",
  },

  -- ---- Soleil-de-Cendre (volcarona) — le Coeur de la Fournaise-Mere.
  -- Reaction : GRATITUDE. Il attendait qu'on le laisse s'eteindre.
  ['new_era_zone_15'] = {
    inst = 'SoleilDeCendre', pos = {272, 144}, cam = {272, 162}, wide = {272, 192},
    lines = {
      "Vous avez mérité la lumière.[pause=30] Merci.",
      "Une lampe qu'on n'éteint jamais finit par ne plus éclairer.[pause=25] Elle brûle, c'est tout.",
      "Vous venez de me donner le droit de baisser.",
    },
    partner = "Ne vous éteignez pas complètement.[pause=20] On repassera.",
    last = "Alors je garderai une braise.[pause=25] Juste une.",
    close = "Les ailes du Veilleur pâlissent d'un ton.[pause=25] La fosse reste chaude, mais on peut respirer.",
  },

  -- ---- Dechire-Nuages (salamence) — la Tour du Ciel Fracture.
  -- Reaction : DENI. Il refuse d'admettre qu'il a ete releve.
  ['new_era_zone_17'] = {
    inst = 'DechireNuages', pos = {224, 216}, cam = {224, 234}, wide = {224, 264},
    lines = {
      "Ce n'est pas une défaite.[pause=25] C'est une pause.",
      "Je reprendrai mon poste dès que vous serez partis.",
      "...La voie restera ouverte, cela dit.[pause=30] Je ne la refermerai pas.",
    },
    partner = "C'est exactement ce que ferait quelqu'un qui abandonne son poste.",
    last = "Je n'abandonne rien.[pause=25] Je surveille autre chose, désormais.",
    close = "Le Veilleur remonte se poser sur la brèche,[pause=20] et regarde vers le bas pour la première fois.",
  },

  -- ---- Lame-de-Fond (gyarados) — la Mer des Tempetes Sans Fin.
  -- Reaction : PEUR. Il ne gardait pas la voie : il gardait ce qu'il y a
  -- dessous. Le seul qui a peur de ce qu'il surveille.
  ['new_era_zone_19'] = {
    inst = 'LameDeFond', pos = {272, 200}, cam = {272, 218}, wide = {272, 248},
    lines = {
      "Passez.[pause=30] Vite.",
      "Je ne tenais pas cette voie contre vous.[pause=25] Je la tenais contre le fond.",
      "Ne descendez pas.[pause=30] Pas encore. Pas comme ça.",
    },
    partner = "Qu'est-ce qu'il y a en bas ?",
    last = "Quelque chose qui a été mis là.[pause=30] Et qui n'a pas demandé à y être.",
    close = "La mer se referme derrière eux,[pause=20] anormalement calme.",
  },

  -- ---- Lanterne-Noyee + Ancre-Morte (jellicent + dhelmise) — la Fosse d'Argent.
  -- Reaction : DEUX QUI N'ONT PAS LE MEME AVIS. L'un veut parler, l'autre non.
  ['new_era_zone_20'] = {
    inst = 'LanterneNoyee', pos = {248, 296}, cam = {272, 312}, wide = {272, 334},
    inst2 = 'AncreMorte', pos2 = {296, 296},
    lines = {
      "Ils ont traversé toute la fosse.[pause=25] Ils ont le droit de savoir.",
      "Cette fosse n'a pas été creusée.[pause=30] Elle a été REMPLIE, puis vidée.",
    },
    lines2 = {
      "Tais-toi.",
      "...Fais comme tu veux.[pause=25] Moi je ne dirai rien.",
    },
    partner = "Remplie de quoi ?",
    last = "Demandez à quelqu'un de plus courageux que nous.",
    close = "La lanterne s'enfonce dans le noir.[pause=25] L'ancre ne bouge pas d'un pouce.",
  },

  -- ---- Portier-du-Vide (dusknoir) — la Caverne du Silence Occidental.
  -- Reaction : IL ATTENDAIT. Le plus inquietant : il savait qu'ils viendraient.
  -- (Foreshadowing assume, deja pose par le doc du Reseau.)
  ['new_era_zone_23'] = {
    inst = 'PortierDuVide', pos = {160, 240}, cam = {160, 258}, wide = {160, 288},
    lines = {
      "...Enfin.",
      "Trois cent ans que je tiens cette porte,[pause=25] et personne n'a jamais demandé POURQUOI.",
      "Vous non plus, d'ailleurs.[pause=30] Vous vous êtes juste battus.",
    },
    partner = "Alors on demande.[pause=20] Pourquoi ?",
    last = "Trop tôt.[pause=30] Revenez quand la question vous fera peur.",
    close = "Le Portier s'écarte sans un bruit.[pause=25] Il ne quitte pas l'équipe des yeux.",
  },
}

--------------------------------------------------------------------
-- VeilleurArc.Victory(zoneKey)
--------------------------------------------------------------------
-- Appelee depuis zone/new_era_zone_XX/init.lua, dans la branche « Cleared »
-- du segment de l'arene, AVANT EndDungeonRun.
--
-- Idempotente : la scene ne se joue qu'une fois par Veilleur. Un rematch
-- (le joueur y retourne) ne rejoue pas la ceremonie, exactement comme le
-- fait deja l'intro de chaque ground.
function VeilleurArc.Victory(zoneKey)
  local f = VeilleurArc.LIST[zoneKey]
  if f == nil then return false end

  if SV.Reseau == nil then SV.Reseau = {} end
  if SV.Reseau.Adieux == nil then SV.Reseau.Adieux = {} end
  if SV.Reseau.Adieux[zoneKey] then return false end
  SV.Reseau.Adieux[zoneKey] = true

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end

    local v = CharacterEssentials.MakeCharactersFromList({
      { f.inst, f.pos[1], f.pos[2], Direction.Down }
    })
    local v2 = nil
    if f.inst2 ~= nil then
      v2 = CharacterEssentials.MakeCharactersFromList({
        { f.inst2, f.pos2[1], f.pos2[2], Direction.Down }
      })
      pcall(function() AI:DisableCharacterAI(v2) end)
    end
    pcall(function() AI:DisableCharacterAI(v) end)

    GAME:MoveCamera(f.wide[1], f.wide[2], 1, false)
    GAME:FadeIn(40)
    GAME:WaitFrames(30)

    -- Cascade d'animations (pmd-red) : le corps traverse une SUITE d'etats.
    pcall(function()
      GROUND:CharSetAnim(v, "Hurt", true)
      if v2 ~= nil then GROUND:CharSetAnim(v2, "Hurt", true) end
      GAME:WaitFrames(28)
      BossFX.ShakeScreen(4, 18)
      GAME:WaitFrames(18)
      GROUND:CharSetAnim(v, "Idle", true)
      if v2 ~= nil then GROUND:CharSetAnim(v2, "Idle", true) end
    end)
    GAME:WaitFrames(20)

    -- Camera sur le Veilleur qui parle (patron du Tunnel).
    GAME:MoveCamera(f.cam[1], f.cam[2], 40, false)
    GAME:WaitFrames(10)

    -- Duo de Veilleurs : on alterne les deux voix.
    if v2 ~= nil then
      local a, b = f.lines or {}, f.lines2 or {}
      local n = math.max(#a, #b)
      for i = 1, n do
        if a[i] ~= nil then say(v, a[i]) end
        if b[i] ~= nil then say(v2, b[i]) end
      end
    else
      for _, t in ipairs(f.lines or {}) do say(v, t) end
    end
    GAME:WaitFrames(12)

    -- Le duo repond : cadre commun.
    GAME:MoveCamera(f.wide[1], f.wide[2], 40, false)
    if partner ~= nil and f.partner ~= nil then
      say(partner, f.partner, "Worried")
    end
    GAME:WaitFrames(12)

    -- La derniere phrase du Veilleur : plan resserre.
    if f.last ~= nil then
      GAME:MoveCamera(f.cam[1], f.cam[2], 40, false)
      say(v, f.last)
      GAME:WaitFrames(18)
    end

    if f.hero ~= nil then
      GeneralFunctions.HeroDialogue(hero, f.hero, "Normal")
      GAME:WaitFrames(12)
    end

    if f.close ~= nil then
      GAME:MoveCamera(f.wide[1], f.wide[2], 40, false)
      narrate(f.close)
    end
    GAME:WaitFrames(20)
  end)

  if not ok then PrintInfo('[VeilleurArc] scene ecourtee : '..tostring(err)) end

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

return VeilleurArc
