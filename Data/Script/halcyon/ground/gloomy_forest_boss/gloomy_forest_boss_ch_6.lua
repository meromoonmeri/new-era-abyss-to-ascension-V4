--[[
    gloomy_forest_boss_ch_6.lua
    Cœur de la Forêt Lugubre — apparition de ZERAORA (Électrik).

    ------------------------------------------------------------------
    CHANGEMENT 2026-08-04 — ZERAORA REMPLACE ZARUDE
    ------------------------------------------------------------------
    Décision auteur. Ce n'est pas un simple échange d'espèce : la mise
    en scène d'un gardien Ténèbres/Plante ne convient pas à un coureur
    Électrik.

    Ce qui a été retiré, et pourquoi :
      * BossFX.EmergeShadow / Dark_Pulse / Leaf_Storm  -> signatures
        Ténèbres et Plante, sans objet pour un Électrik.
      * BossFX.Voice('GF6B_012') — RÈGLE PROJET : BossFX.Voice est
        réservé à la Voix anonyme (\uE040). L'employer pour un boss
        nommé est interdit. Les deux lignes solennelles sont désormais
        de simples boîtes centrées sans locuteur : on ne sait pas encore
        QUI parle, ce qui est justement l'effet recherché.
      * UI:SetSpeaker(hero) puis WaitShowDialogue — le héros NE PARLE
        JAMAIS à voix haute. Remplacé par GeneralFunctions.HeroDialogue,
        pensée entre parenthèses.

    ------------------------------------------------------------------
    GÉOMÉTRIE — la carte a changé de taille
    ------------------------------------------------------------------
    L'arène est repeinte avec « Arene Zeraora.png » : elle passe de
    600x600 à 360x312 px. L'ancienne scène plaçait le duo en y=416 et
    le boss en y=208 — sur 312 de haut, y=416 est HORS CARTE.

    Positions vérifiées libres case par case contre obstacles[] (les 4
    cases de 8 px de chaque boîte 16x16) :
        plateau praticable   x 0..344   y 120..296
        duo au départ        (184,272) / (160,272)
        halte                (184,240) / (160,244)
        Zeraora              (176,176)  — 24 px de marge tout autour
    Distance halte -> Zeraora : 64 px, les deux tiennent dans le cadre
    caméra (320x240).

    ------------------------------------------------------------------
    STRUCTURE
    ------------------------------------------------------------------
      1. montée réelle du duo vers le nord, caméra qui glisse
      2. LA VOIX SANS SOURCE les arrête — « Hé. Halte-là, vous deux. »
      3. ils cherchent : gauche, droite, en haut. Personne.
      4. la caméra monte SEULE : le joueur voit avant les personnages
      5. les deux lignes solennelles, puis l'irruption électrique
      6. l'échange : il a le Chenipan, mais il veut sa course
]]--

require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

gloomy_forest_boss_ch_6 = {}

-- Éclair de fond : MapStatus 'thunderclouds' posé puis retiré. Ce sont
-- ses fondus (FadeIn 2 / FadeOut 8) qui font le flash, pas une boucle.
local function Eclair(court)
  pcall(function() GROUND:AddMapStatus("thunderclouds") end)
  GAME:WaitFrames(court and 4 or 7)
  pcall(function() GROUND:RemoveMapStatus("thunderclouds") end)
end

function gloomy_forest_boss_ch_6.CoupDeTonnerre(avecSon)
  pcall(function()
    Eclair(true)
    GAME:WaitFrames(5)
    Eclair(false)
    if avecSon then SOUND:PlayBattleSE("DUN_Shock_Wave") end
  end)
end

function gloomy_forest_boss_ch_6.FirstBossScene()
  -- SORTIE GARANTIE : sans ce pcall, une scène qui lève avant son
  -- FadeIn laisse le joueur sur un écran noir, manette inerte.
  local ok, err = pcall(gloomy_forest_boss_ch_6.FirstBossSceneBody)
  if not ok then
    PrintInfo('[gloomy_forest_boss] scène interrompue : ' .. tostring(err))
    pcall(function() SV.Chapter6.GloomyBossEncountered = true end)
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:FadeIn(20) end)
  end
end

function gloomy_forest_boss_ch_6.FirstBossSceneBody()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  GROUND:TeleportTo(hero, 184, 272, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 160, 272, Direction.Up) end
  local zeraora = CharacterEssentials.MakeCharactersFromList({
    {'Zeraora', 176, 176, Direction.Down}
  })
  GROUND:Hide('Zeraora')
  if zeraora ~= nil then AI:DisableCharacterAI(zeraora) end

  GAME:MoveCamera(176, 250, 1, false)
  GAME:FadeIn(40)
  SOUND:PlayBGM('Mystifying Forest.ogg', true)
  GAME:WaitFrames(30)

  -- ============================================================
  -- 1. LA MONTÉE — marche réelle, jamais de téléportation
  -- ============================================================
  local montee = {}
  montee[1] = TASK:BranchCoroutine(function()
    pcall(function() GROUND:MoveToPosition(hero, 184, 240, false, 1) end)
  end)
  montee[2] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    if partner ~= nil then
      pcall(function() GROUND:MoveToPosition(partner, 160, 244, false, 1) end)
    end
  end)
  montee[3] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    pcall(function() GAME:MoveCamera(176, 228, 90, false) end)
  end)
  pcall(function() TASK:JoinCoroutines(montee) end)
  GAME:WaitFrames(10)

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_001']))
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_002']))
  end
  GAME:WaitFrames(8)
  -- Le héros pense, il ne parle pas.
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GF6B_003']), "Normal")
  GAME:WaitFrames(10)

  -- L'air change avant que rien n'arrive.
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_011']))
  end
  gloomy_forest_boss_ch_6.CoupDeTonnerre(false)
  GAME:WaitFrames(16)

  -- ============================================================
  -- 2. LA VOIX SANS SOURCE — locuteur VIDE, texte centré.
  --    Ce n'est PAS la Voix (\uE040) : c'est Zeraora hors champ,
  --    sans portrait ni nom. On ne le sait pas encore.
  -- ============================================================
  SOUND:PlayBattleSE("EVT_Emote_Exclaim")
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_004']))
  UI:SetCenter(false)
  GAME:WaitFrames(8)

  -- Sursaut en cascade, emotes DIFFÉRENTES et décalées.
  local sursaut = {}
  sursaut[1] = TASK:BranchCoroutine(function()
    pcall(function() GeneralFunctions.EmoteAndPause(hero, "Shock", true) end)
  end)
  sursaut[2] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    if partner ~= nil then
      pcall(function() GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
    end
  end)
  pcall(function() TASK:JoinCoroutines(sursaut) end)
  GAME:WaitFrames(12)

  -- ============================================================
  -- 3. ILS CHERCHENT — gauche, droite, puis en haut. Personne.
  -- ============================================================
  pcall(function()
    GROUND:CharAnimateTurnTo(hero, Direction.Left, 5)
    if partner ~= nil then GROUND:CharAnimateTurnTo(partner, Direction.Right, 5) end
  end)
  GAME:WaitFrames(20)
  pcall(function()
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 5)
    if partner ~= nil then GROUND:CharAnimateTurnTo(partner, Direction.Up, 5) end
  end)
  GAME:WaitFrames(10)

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_005']))
  end
  GAME:WaitFrames(10)

  -- ============================================================
  -- 4. LA CAMÉRA MONTE SEULE — le joueur voit avant les héros.
  -- ============================================================
  pcall(function() GAME:MoveCamera(176, 190, 70, false) end)
  GAME:WaitFrames(20)

  -- Les deux lignes solennelles. Boîtes centrées SANS locuteur —
  -- BossFX.Voice est réservé à la Voix anonyme, pas à un boss nommé.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_012']))
  GAME:WaitFrames(16)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_013']))
  UI:SetCenter(false)
  GAME:WaitFrames(20)

  -- ============================================================
  -- 5. L'IRRUPTION ÉLECTRIQUE — la décharge précède le corps.
  -- ============================================================
  SOUND:FadeOutBGM(30)
  pcall(function() BossFX.StrikeThunder(zeraora, 176, 176) end)
  pcall(function() BossFX.PushBack({hero, partner}, Direction.Down) end)
  GAME:WaitFrames(10)

  GROUND:Unhide('Zeraora')
  gloomy_forest_boss_ch_6.CoupDeTonnerre(true)
  GROUND:CharSetAnim(zeraora, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(zeraora, "Idle", true)
  SOUND:PlayBGM('Rising Fear.ogg', true)

  UI:WaitShowTitle("Zeraora, le Courant Sauvage", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- Le duo se tourne vers lui.
  pcall(function()
    GROUND:CharTurnToCharAnimated(hero, zeraora, 4)
    if partner ~= nil then GROUND:CharTurnToCharAnimated(partner, zeraora, 4) end
  end)
  GAME:WaitFrames(12)

  -- ============================================================
  -- 6. L'ÉCHANGE — il a le Chenipan, mais il veut sa course.
  -- ============================================================
  UI:SetSpeaker(zeraora)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_006']))

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Angry")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_007']))
  end
  GAME:WaitFrames(8)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GF6B_008']), "Worried")
  GAME:WaitFrames(10)

  UI:SetSpeaker(zeraora)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_009']))
  pcall(function() GROUND:CharSetEmote(zeraora, "glowing", 1) end)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_010']))
  pcall(function() GROUND:CharSetEmote(zeraora, "", 0) end)

  SV.Chapter6.GloomyBossEncountered = true
  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("gloomy_forest", 4, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

return gloomy_forest_boss_ch_6
