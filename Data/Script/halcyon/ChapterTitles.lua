--[[
    ChapterTitles.lua

    ECRANS D'OUVERTURE DE CHAPITRE
    ================================================================
    Chaque chapitre s'ouvre sur un écran de présentation dédié :
    - Fond plein écran (image représentative du chapitre)
    - Filtre assombrissant pour la lisibilité
    - Titre du chapitre en français

    USAGE
    ------------------------------------------------------------------
    Dans le Enter() d'un ground d'entrée de chapitre :

      ChapterTitles.Show(6)

    Ou avec fondu personnalisé :

      ChapterTitles.Show(8, {fadeIn=60, hold=120, fadeOut=40})

    IMAGES DE FOND
    ------------------------------------------------------------------
    Chaque chapitre a sa propre image dans Content/BG/ :
      ChapterBG_1.png  ->  "Un Autre Commencement"
      ChapterBG_2.png  ->  "La Première Mission"
      ChapterBG_3.png  ->  "Rivaux"
      ChapterBG_4.png  ->  "Une Vraie Aventure"
      ChapterBG_5.png  ->  "L'Expédition"
      ChapterBG_6.png  ->  "La Forêt Lugubre"
      ...

    Si l'image n'existe pas, le système utilise un fond noir avec
    le titre seul (fallback gracieux, pas de crash).

    REGLES
    ------------------------------------------------------------------
    * Titre en français idiomatique, jamais traduit littéralement
    * Filtre assombrissant : overlay noir alpha 160/255
    * Timing : fondu entrée (40f) -> maintien (120f) -> fondu sortie (40f)
    * Musique : la musique du chapitre démarre PENDANT l'écran titre
    * Tout sous pcall : un écran titre qui casse ne bloque jamais le jeu
]]

require 'origin.common'

ChapterTitles = {}

--------------------------------------------------------------------
-- TITRES DES CHAPITRES (français idiomatique)
--------------------------------------------------------------------
ChapterTitles.Titles = {
  [1]  = "Chapitre 1 — Un Autre Commencement",
  [2]  = "Chapitre 2 — La Première Mission",
  [3]  = "Chapitre 3 — Rivaux",
  [4]  = "Chapitre 4 — Une Vraie Aventure",
  [5]  = "Chapitre 5 — L'Expédition",
  [6]  = "Chapitre 6 — La Forêt Lugubre",
  [7]  = "Chapitre 7 — Les Ruines Tordues",
  [8]  = "Chapitre 8 — Le Sanctuaire de Cristal",
  [9]  = "Chapitre 9 — Le Marais de l'Oubli",
  [10] = "Chapitre 10 — Le Pic Céleste",
  [11] = "Chapitre 11 — La Caldeira Endormie",
  [12] = "Chapitre 12 — Les Eaux Inexplorées",
  [13] = "Chapitre 13 — Les Trois Lacs",
  [14] = "Chapitre 14 — L'Île de Lave",
  [15] = "Chapitre 15 — Le Jardin de la Gratitude",
  [16] = "Chapitre 16 — Berceau des Mers",
  [17] = "Chapitre 17 — Les Oiseaux Légendaires",
  [18] = "Chapitre 18 — La Tour Sacrée",
  [19] = "Chapitre 19 — La Fosse des Abysses",
  [20] = "Chapitre 20 — Le Verger du Temps",
  [21] = "Chapitre 21 — La Forteresse Abandonnée",
  [22] = "Chapitre 22 — Les Plaines Brûlées",
  [23] = "Chapitre 23 — Le Mont Lunaire",
  [24] = "Chapitre 24 — Les Crêtes Boréales",
  [25] = "Chapitre 25 — La Forêt Hurlante",
  [26] = "Chapitre 26 — La Clairière Secrète",
  [27] = "Chapitre 27 — La Vigie Stratos",
  [28] = "Chapitre 28 — Les Dragons Créateurs",
  [29] = "Chapitre 29 — La Grotte Inversée",
  [30] = "Chapitre 30 — Les Terres Tues",
  [31] = "Chapitre 31 — Les Îles du Conte",
  [32] = "Chapitre 32 — L'Abîme",
}

-- Timings par défaut
local DEFAULT_TIMING = {
  fadeIn  = 40,   -- frames pour le fondu d'entrée
  hold    = 120,  -- frames de maintien à plein
  fadeOut = 40,   -- frames pour le fondu de sortie
}

--------------------------------------------------------------------
-- API PRINCIPALE
--------------------------------------------------------------------

--- Affiche l'écran d'ouverture d'un chapitre.
-- @param chapter number : numéro du chapitre (1-32)
-- @param opts table optionnel : {fadeIn, hold, fadeOut, bgm}
function ChapterTitles.Show(chapter, opts)
  local ok, err = pcall(ChapterTitles._ShowBody, chapter, opts)
  if not ok then
    PrintInfo('[ChapterTitles] ERREUR ch'..tostring(chapter)..': '..tostring(err))
    -- Fallback : fondu noir simple, le jeu continue
    pcall(function()
      GAME:FadeOut(false, 20)
      GAME:WaitFrames(40)
      GAME:FadeIn(20)
    end)
  end
end

--- Vérifie si un chapitre a déjà été affiché (éviter les répétitions).
function ChapterTitles.HasBeenShown(chapter)
  if not SV or not SV.ChapterTitles then return false end
  return SV.ChapterTitles['ch'..tostring(chapter)] == true
end

--- Marque un chapitre comme affiché.
function ChapterTitles.MarkShown(chapter)
  if not SV then return end
  if not SV.ChapterTitles then SV.ChapterTitles = {} end
  SV.ChapterTitles['ch'..tostring(chapter)] = true
end

--------------------------------------------------------------------
-- IMPLEMENTATION
--------------------------------------------------------------------

function ChapterTitles._ShowBody(chapter, opts)
  opts = opts or {}
  local fadeIn  = opts.fadeIn  or DEFAULT_TIMING.fadeIn
  local hold    = opts.hold    or DEFAULT_TIMING.hold
  local fadeOut = opts.fadeOut or DEFAULT_TIMING.fadeOut

  local title = ChapterTitles.Titles[chapter]
  if not title then
    PrintInfo('[ChapterTitles] Pas de titre pour le chapitre '..tostring(chapter))
    return
  end

  -- Ne pas réafficher si déjà vu dans cette sauvegarde
  if ChapterTitles.HasBeenShown(chapter) then
    return
  end

  -- 1. NOIR COMPLET
  GAME:FadeOut(false, 1)
  GAME:WaitFrames(10)

  -- 2. MUSIQUE DU CHAPITRE (si spécifiée)
  if opts.bgm then
    SOUND:PlayBGM(opts.bgm, false)
  end

  -- 3. IMAGE DE FOND + FILTRE ASSOMBRISSANT
  -- Le BG est affiché via un FiniteOverlayEmitter si l'asset existe.
  -- Fallback : fond noir avec le titre seul.
  local bgName = 'ChapterBG_'..tostring(chapter)
  local bgShown = false
  pcall(function()
    local bg = RogueEssence.Content.FiniteOverlayEmitter()
    bg.FadeIn = fadeIn
    bg.TotalTime = fadeIn + hold + fadeOut
    bg.Layer = DrawLayer.Top
    bg.Anim = RogueEssence.Content.BGAnimData(bgName, 0)
    GROUND:PlayVFX(bg, 160, 120)  -- centré sur l'écran 320x240
    bgShown = true
  end)

  if not bgShown then
    -- Fallback : overlay noir semi-transparent comme filtre
    pcall(function()
      local dark = RogueEssence.Content.FiniteOverlayEmitter()
      dark.FadeIn = fadeIn
      dark.TotalTime = fadeIn + hold + fadeOut
      dark.Layer = DrawLayer.Top
      dark.Anim = RogueEssence.Content.BGAnimData("Black", 0)
      GROUND:PlayVFX(dark, 160, 120)
    end)
  end

  GAME:WaitFrames(fadeIn)

  -- 4. TITRE DU CHAPITRE (centré, texte blanc sur fond sombre)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  -- Le titre est affiché via WaitShowDialogue en mode centré.
  -- Le texte est en français, pas de clé MapStrings pour les titres
  -- (texte fixe, pas de localisation multiple nécessaire).
  UI:WaitShowTimedDialogue(title, fadeIn + hold)
  UI:SetCenter(false)
  UI:ResetSpeaker()

  GAME:WaitFrames(fadeOut)

  -- 5. MARQUER COMME VU
  ChapterTitles.MarkShown(chapter)
end

--------------------------------------------------------------------
-- INTEGRATION — appeler depuis les grounds d'entrée de chapitre
--------------------------------------------------------------------
-- Exemple d'intégration dans un Enter() de ground :
--
--   function my_ground.Enter(map)
--     if not ChapterTitles.HasBeenShown(6) then
--       ChapterTitles.Show(6, {bgm='Mystifying Forest.ogg'})
--     end
--     GAME:FadeIn(20)
--     -- ... suite de la scène
--   end

return ChapterTitles
