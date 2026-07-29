--[[
    HeroDreams.lua

    RÊVES RÉCURRENTS DU HÉROS — 20 rêves planifiés (ch1→ch32)
    ================================================================
    Extension de HeroVisions.lua. Chaque rêve est une cinématique
    complète jouée sur la carte hero_dream (parallaxe Dream_Back/
    Dream_Front). La voix inconnue devient progressivement Gardevoir.

    SYSTÈME
    ------------------------------------------------------------------
    HeroDreams.TryNightlyDream() est appelé par guild_heros_room au
    coucher. Il vérifie quel rêve est dû selon le chapitre et les
    flags, puis le joue si les conditions sont remplies.

    GARDEVOIR — PROGRESSION
    ------------------------------------------------------------------
    Phase 1 (ch1-4)   : voix sans visage, murmures
    Phase 2 (ch5-8)   : silhouette lumineuse, paroles claires
    Phase 3 (ch9-14)  : dialogue direct, émotions partagées
    Phase 4 (ch15-20) : Gardevoir se montre pleinement
    Phase 5 (ch21-28) : guide vers les Cœurs
    Phase 6 (ch29-32) : sacrifice, révélation finale

    Cette Gardevoir est DISTINCTE de la Gardevoir chromatique de
    Team Charm. Jamais confondues visuellement ni narrativement.

    GRAMMAIRE DES RÊVES (inspirée de PMD Explorers du Ciel)
    ------------------------------------------------------------------
    1. Le son d'abord : musique de rêve monte AVANT l'image
    2. Voix off centrée : pas de boîte de dialogue standard
    3. Planches narratives : BG fixes avec texte superposé
    4. Gardevoir : absente (phase 1-2), silhouette (3), visible (4+)
    5. Réveil en sursaut : toujours après le dernier mot
    6. Réaction du partenaire : inquiet, réconfortant

    RÈGLES
    ------------------------------------------------------------------
    * Pas de répétition : chaque rêve apporte du nouveau
    * Gardevoir n'est JAMAIS nommée avant la phase 4 (ch15+)
    * La Voix utilise le speaker anonyme \uE040 (comme dans ch5-7)
    * Cresselia intervient uniquement ch15-25 (communications divines)
    * Arceus intervient uniquement ch30-32 (end game)
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.VoiceVisions'
require 'halcyon.CharacterEssentials'

HeroDreams = {}

--------------------------------------------------------------------
-- TABLE DES RÊVES
--------------------------------------------------------------------
-- Chaque rêve a :
--   ch       : chapitre minimum requis
--   phase    : phase de Gardevoir (1-6)
--   music    : musique d'ambiance
--   plates   : planches narratives {bg, hold, lines[]}
--   lastWord : dernière phrase (voix off, après silence)
--   heroLine : pensée du héros au réveil
--   partnerLine : réplique du partenaire après le réveil

HeroDreams.DREAMS = {
  ------------------------------------------------------------------
  -- PHASE 1 — VOIX (ch1-4)
  ------------------------------------------------------------------
  dream_01_murmure = {
    ch = 1, phase = 1,
    music = 'Goodnight.ogg',
    plates = {
      { bg='Genesis_Void', hold=200, lines={
        "Le noir.[pause=30] Pas le noir de la nuit — un noir plus ancien.",
        "Quelque chose respire, très loin.[pause=25] Quelque chose qui attend." } },
      { bg='Genesis_Fade', hold=180, lines={
        "Une voix, sans visage et sans direction.[pause=30] Elle ne parle pas — elle résonne.",
        "« ...Tu n'es pas venu ici par hasard. »" } },
    },
    lastWord = "« ...Pas encore. Mais bientôt. »",
    heroLine = "(Une voix...[pause=25] Dans mon rêve.[pause=20] Elle me connaissait.)",
    partnerLine = "Hé...[pause=20] Tu parlais dans ton sommeil.[pause=25] Tout va bien ?",
  },

  dream_02_reflet = {
    ch = 2, phase = 1,
    music = 'Goodnight.ogg',
    plates = {
      { bg='Genesis_Life', hold=200, dreamSky=true, lines={
        "Un miroir d'eau, parfaitement immobile.[pause=30] Le ciel s'y reflète.",
        "Quelqu'un se penche pour regarder.[pause=25] Ce n'est pas ton reflet." } },
      { bg='Genesis_Fade', hold=180, lines={
        "Le visage dans l'eau est différent.[pause=30] Plus grand.[pause=20] Plus... ancien.",
        "Il te regarde comme s'il te reconnaissait." } },
    },
    lastWord = "« ...Tu te souviendras. En temps voulu. »",
    heroLine = "(J'ai vu un visage qui n'était pas le mien.[pause=25] Mais je l'ai reconnu.)",
    partnerLine = "Tu es tout pâle ce matin.[pause=20] Tu as mal dormi ?",
  },

  dream_03_chasse = {
    ch = 3, phase = 1,
    music = 'Team Skull.ogg',
    plates = {
      { bg='Wanted_Poster', hold=220, lines={
        "Une affiche, clouée sur un arbre.[pause=25] Un visage dessiné à la hâte.",
        "En dessous, un seul mot revient, écrit trop gros :[pause=20] COUPABLE." } },
      { bg='Chapter_3', hold=200, shake=5, lines={
        "Ils sont quatre à le poursuivre.[pause=20] Des secouristes. Les meilleurs de leur temps.",
        "Ils ne le haïssent pas.[pause=25] Ils croient sincèrement bien faire.[pause=20] C'est pire." } },
    },
    lastWord = "« ...Ils ne m'ont jamais laissé m'expliquer. »",
    heroLine = "(Je ne connais pas ce visage.[pause=20] Alors pourquoi j'ai envie de courir ?)",
    partnerLine = "Hé...[pause=15] Tu es tout pâle.[pause=20] Tu t'es arrêté d'un coup, là.",
  },

  dream_04_fleurs = {
    ch = 4, phase = 1,
    music = 'Goodnight.ogg',
    plates = {
      { bg='Genesis_Life', hold=200, dreamSky=true, lines={
        "Un jardin immense.[pause=30] Des milliers de fleurs, toutes différentes.",
        "L'une après l'autre, elles fanent.[pause=25] Comme si quelque chose buvait leur lumière." } },
      { bg='Genesis_Fade', hold=180, lines={
        "La voix est plus proche maintenant.[pause=30] Triste.",
        "« ...Chaque fleur est un souvenir.[pause=25] Et quelqu'un les efface. »" } },
    },
    lastWord = "« ...Aide-moi à les protéger. S'il te plaît. »",
    heroLine = "(Elle pleurait.[pause=25] La voix pleurait.[pause=20] Et je voulais l'aider.)",
    partnerLine = "Tu as les yeux rouges.[pause=20] Tu as pleuré en dormant ?",
  },

  ------------------------------------------------------------------
  -- PHASE 2 — SILHOUETTE (ch5-8)
  ------------------------------------------------------------------
  dream_05_meteore = {
    ch = 5, phase = 2,
    music = 'Sky Tower.ogg',
    plates = {
      { bg='Chapter_2', hold=200, lines={
        "Le ciel est rouge.[pause=25] Une pierre énorme descend, lentement.",
        "En bas, un monde entier a cessé de respirer." } },
      { bg='Genesis_Void', hold=220, shake=9, lines={
        "Quelque chose monte à sa rencontre.[pause=20] Vert. Immense. Furieux.",
        "L'impact fait un bruit que personne n'oubliera." } },
    },
    lastWord = "« ...Il a payé pour nous, et nous ne savons même pas son nom. »",
    heroLine = "(J'ai senti la chaleur.[pause=25] Sur ma peau. Comment c'est possible ?)",
    partnerLine = "Tu trembles...[pause=20] Tu veux qu'on s'arrête un moment ?",
  },

  dream_06_foret = {
    ch = 6, phase = 2,
    music = 'Dark Hill.ogg',
    plates = {
      { bg='Genesis_Cores', hold=200, lines={
        "Une forêt qui pleure.[pause=30] Les arbres suintent une sève noire.",
        "Au centre, un cœur bat — mais pas droit.[pause=25] Il souffre." } },
      { bg='Genesis_Fade', hold=180, lines={
        "La silhouette apparaît pour la première fois.[pause=30] Lumineuse. Lointaine.",
        "Elle tend la main vers le cœur malade.[pause=25] Elle essaie de le guérir." } },
    },
    lastWord = "« ...Je ne peux pas les sauver seule. Pas cette fois. »",
    heroLine = "(Elle était là.[pause=25] Dans la lumière.[pause=20] Je l'ai presque vue.)",
    partnerLine = "Tu as crié.[pause=20] Cette fois, tu as vraiment crié.",
  },

  dream_07_rouage = {
    ch = 7, phase = 2,
    music = 'Time Gear Remix.ogg',
    plates = {
      { bg='Genesis_Cores', hold=210, lines={
        "Des rouages tournent dans le vide.[pause=25] Lents. Réguliers.",
        "Puis un s'arrête.[pause=20] Et tout ce qui dépendait de lui s'arrête avec." } },
      { bg='Dusknoir', hold=200, shake=4, lines={
        "Un fleuve figé en pleine chute.[pause=25] Des oiseaux immobiles en plein ciel.",
        "Un monde sans soleil, où plus rien ne pousse et plus rien ne meurt." } },
    },
    lastWord = "« ...Le temps ne s'est pas arrêté. Il a été retenu. »",
    heroLine = "(Un monde où le temps s'est arrêté...[pause=25] Ce n'est pas une histoire. Je l'ai VU.)",
    partnerLine = "Tu as encore eu un malaise ?[pause=25] Ça fait trois fois cette semaine.",
  },

  dream_08_cristal = {
    ch = 8, phase = 2,
    music = 'Goodnight.ogg',
    plates = {
      { bg='Genesis_Life', hold=200, dreamSky=true, lines={
        "Un cristal immense, suspendu dans le vide.[pause=30] Il chante.",
        "Chaque note est un souvenir — des millions de souvenirs." } },
      { bg='Genesis_Fade', hold=180, lines={
        "La silhouette est plus proche.[pause=30] Tu vois ses contours maintenant.",
        "Fine. Élégante.[pause=25] Les bras tendus vers le cristal." } },
    },
    lastWord = "« ...Écoute. Chaque cristal est une vie qui refuse d'être oubliée. »",
    heroLine = "(Elle chantait avec le cristal.[pause=25] Et le cristal lui répondait.)",
    partnerLine = "Tu souriais en dormant.[pause=20] C'est la première fois.",
  },

  ------------------------------------------------------------------
  -- PHASE 3 — PRÉSENCE (ch9-14)
  -- Les rêves suivants seront ajoutés quand les chapitres 9-14
  -- seront produits. Structure identique, Gardevoir dialogue
  -- directement avec le héros.
  ------------------------------------------------------------------

  -- dream_09_marais    (ch9)  — le Cercle du Suaire
  -- dream_10_effacement (ch10) — la disparition (réprise HeroVisions.effacement)
  -- dream_11_dialogue (ch12) — première conversation claire
  -- dream_12_souvenir (ch14) — elle montre le monde ancien

  ------------------------------------------------------------------
  -- PHASE 4 — RÉVÉLATION (ch15-20)
  -- Gardevoir se montre pleinement.
  ------------------------------------------------------------------

  -- dream_13_nom      (ch16) — elle dit le nom humain du héros
  -- dream_14_silhouette (ch18) — forme visible dans la lumière
  -- dream_15_revelation (ch20) — « Je t'ai appelé. Pardonne-moi. »

  ------------------------------------------------------------------
  -- PHASE 5 — ALLIANCE (ch21-28)
  ------------------------------------------------------------------

  -- dream_16_lien     (ch22) — pourquoi le héros est là
  -- dream_17_choix    (ch24) — retour au monde humain proposé
  -- dream_18_promesse (ch26) — il choisit de rester

  ------------------------------------------------------------------
  -- PHASE 6 — SACRIFICE (ch29-32)
  ------------------------------------------------------------------

  -- dream_19_sceau    (ch30) — Eternatus s'éveille, Gardevoir faiblit
  -- dream_20_ascension (ch32) — Arceus, restauration
}

--------------------------------------------------------------------
-- API
--------------------------------------------------------------------

--- Initialise les variables de sauvegarde
function HeroDreams.EnsureSV()
  if not SV.HeroDreams then
    SV.HeroDreams = {
      DreamsSeen = {},
      GardevoirPhase = 0,
      TotalDreams = 0,
      LastDreamChapter = 0,
    }
  end
  if not SV.HeroDreams.DreamsSeen then SV.HeroDreams.DreamsSeen = {} end
  if not SV.HeroDreams.GardevoirPhase then SV.HeroDreams.GardevoirPhase = 0 end
  if not SV.HeroDreams.TotalDreams then SV.HeroDreams.TotalDreams = 0 end
  if not SV.HeroDreams.LastDreamChapter then SV.HeroDreams.LastDreamChapter = 0 end
end

--- Retourne la phase actuelle de Gardevoir (1-6)
function HeroDreams.GardevoirPhase()
  HeroDreams.EnsureSV()
  local ch = 0
  pcall(function() ch = SV.ChapterProgression.Chapter or 0 end)
  if ch < 5 then return 1
  elseif ch < 9 then return 2
  elseif ch < 15 then return 3
  elseif ch < 21 then return 4
  elseif ch < 29 then return 5
  else return 6
  end
end

--- Tente de déclencher le rêve dû pour le chapitre actuel.
-- Appelé par guild_heros_room au coucher, après les DreamCutscene de chapitre.
-- Retourne true si un rêve a été joué.
function HeroDreams.TryNightlyDream()
  HeroDreams.EnsureSV()
  local ch = 0
  pcall(function() ch = SV.ChapterProgression.Chapter or 0 end)

  -- Ne pas rejouer un rêve déjà vu
  -- Ne pas jouer plus d'un rêve par nuit
  if SV.HeroDreams.LastDreamChapter == ch then return false end

  -- Chercher le rêve dû
  local dreamId = nil
  local dreamData = nil
  for id, dream in pairs(HeroDreams.DREAMS) do
    if dream.ch <= ch
       and not SV.HeroDreams.DreamsSeen[id]
       and (dreamData == nil or dream.ch > dreamData.ch) then
      dreamId = id
      dreamData = dream
    end
  end

  if dreamId == nil then return false end

  -- Jouer le rêve
  HeroDreams.PlayDream(dreamId, dreamData)
  return true
end

--- Joue un rêve spécifique
function HeroDreams.PlayDream(id, dream)
  local ok, err = pcall(function()
    HeroDreams.EnsureSV()
    local hero = CH('PLAYER')
    local partner = CH('Teammate1')

    -- Transition vers hero_dream
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(80)

    -- Musique de rêve
    pcall(function() SOUND:PlayBGM(dream.music, true) end)
    GAME:WaitFrames(30)

    -- Parallaxe de rêve (VoiceVisions.DreamSky)
    pcall(function() VoiceVisions.DreamSky(400) end)
    GAME:WaitFrames(20)

    -- Planches narratives
    for _, plate in ipairs(dream.plates or {}) do
      pcall(function()
        -- Fond
        if plate.bg then
          UI:WaitShowBG(plate.bg, plate.hold or 180, 20)
        end
        -- Tremblement si shake
        if plate.shake then
          pcall(function()
            GROUND:MoveScreen(RogueEssence.Content.ScreenMover(
              plate.shake, plate.shake * 3, plate.hold or 40))
          end)
        end
        -- Voix off (texte centré, sans speaker)
        UI:ResetSpeaker(false)
        UI:SetCenter(true)
        for _, line in ipairs(plate.lines or {}) do
          UI:WaitShowDialogue(line)
          GAME:WaitFrames(10)
        end
        UI:SetCenter(false)
        UI:ResetSpeaker()
        GAME:WaitFrames(20)
      end)
    end

    -- Silence avant le dernier mot
    GAME:WaitFrames(60)

    -- Dernier mot
    if dream.lastWord then
      UI:ResetSpeaker(false)
      UI:SetCenter(true)
      UI:WaitShowDialogue(dream.lastWord)
      UI:SetCenter(false)
      UI:ResetSpeaker()
    end
    GAME:WaitFrames(60)

    -- Fondu de sortie
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(80)

    -- Marquer comme vu
    SV.HeroDreams.DreamsSeen[id] = true
    SV.HeroDreams.TotalDreams = SV.HeroDreams.TotalDreams + 1
    SV.HeroDreams.LastDreamChapter = ch
    SV.HeroDreams.GardevoirPhase = dream.phase

    -- Réveil
    GAME:CutsceneMode(false)
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
    end
    GAME:FadeIn(20)
    GAME:WaitFrames(30)

    -- Pensée du héros
    if dream.heroLine then
      GeneralFunctions.HeroDialogue(hero, dream.heroLine, "Worried")
      GAME:WaitFrames(20)
    end

    -- Réaction du partenaire
    if dream.partnerLine and partner ~= nil then
      GROUND:CharTurnToCharAnimated(partner, hero, 4)
      GAME:WaitFrames(6)
      UI:SetSpeaker(partner)
      UI:SetSpeakerEmotion("Worried")
      UI:WaitShowDialogue(dream.partnerLine)
      GAME:WaitFrames(20)
    end
  end)

  if not ok then
    PrintInfo('[HeroDreams] dream '..tostring(id)..' error: '..tostring(err))
    -- Sortie garantie
    pcall(function()
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end)
  end
end

return HeroDreams
