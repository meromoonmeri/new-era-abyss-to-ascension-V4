--[[
    SceneDebug.lua — ARMEMENT DES SCENES POUR TEST EN JEU

    -------------------------------------------------------------------
    POURQUOI CE FICHIER
    -------------------------------------------------------------------
    Toutes les cinematiques du mod ne se testent pas de la meme facon,
    et la difference n'est pas documentee. Deux exemples reels :

      Mont Windsep (mount_windswept_entrance/init.lua:163)
          if not SV.Chapter5.FinishedMountWindsweptIntro then
        Condition NEGATIVE. Defaut du drapeau = false, donc `not false`
        = vrai : la scene part toute seule des qu'on arrive sur la
        carte. Testable en mode dev sans rien preparer.

      Camp des Ruines (cloven_ruins_entrance/init.lua:91)
          if c5.RuinsCampPending and not c5.RuinsCampDone then
        Condition POSITIVE. RuinsCampPending vaut false par defaut
        (scriptvars.lua:935) et n'est pose qu'a UN SEUL endroit du mod :
        mount_windswept_guardian_ch_5.lua:858, apres la victoire sur
        Tornadus. En arrivant sur la carte par le mode dev, le drapeau
        est faux, le routeur tombe dans la branche « camp deja visite »
        et la cinematique ne se joue jamais.

    Les deux comportements sont CORRECTS : le camp doit etre arme, sinon
    il se rejouerait en rejouabilite. Mais sans outil, la seule facon de
    voir la scene est de rejouer tout le Mont Venteux, Tornadus compris.

    Ce module arme un etat de scene precis, puis depose le joueur sur la
    carte concernee. Il ne modifie AUCUNE logique de jeu : il se contente
    d'ecrire dans SV exactement ce que la progression normale y ecrirait.

    -------------------------------------------------------------------
    USAGE
    -------------------------------------------------------------------
    Depuis n'importe quel script, ou depuis la console Lua du mode dev :

        require 'halcyon.SceneDebug'
        SceneDebug.Menu()             -- menu de selection
        SceneDebug.Arm('ruins_camp')  -- arme sans se deplacer
        SceneDebug.Go('ruins_camp')   -- arme ET se teleporte

    -------------------------------------------------------------------
    REGLE DE SURETE
    -------------------------------------------------------------------
    Chaque entree pose l'ETAT COMPLET attendu par le routeur de sa carte,
    y compris les drapeaux qui doivent rester FAUX. Sans cela, une
    branche prioritaire (retour de reve, retour apres KO) capterait le
    routage avant la scene visee — c'est le piege principal de ces
    routeurs, qui testent leurs branches dans un ordre fixe.
]]--
require 'origin.common'

SceneDebug = {}

--------------------------------------------------------------------
-- CATALOGUE DES SCENES
--
-- Chaque entree decrit :
--   label   : intitule affiche dans le menu
--   chapter : chapitre a forcer (nil = ne pas toucher)
--   ground  : carte de destination
--   entry   : nom du marqueur d'entree
--   set     : table SV.Chapter<N> a ecrire, valeurs comprises
--   note    : rappel de la condition lue par le routeur
--
-- Les conditions citees ont ete relevees dans le code, fichier et
-- ligne a l'appui. Si un routeur change, MettreA jour ici aussi.
--------------------------------------------------------------------
SceneDebug.scenes = {
  {
    key = 'ruins_camp',
    label = "Ch5 — Camp des Ruines : arrivee",
    chapter = 5, ground = 'cloven_ruins_entrance', entry = 'Main_Entrance_Marker',
    note = "cloven_ruins_entrance/init.lua:91 — RuinsCampPending and not RuinsCampDone",
    set = { Chapter5 = {
      RuinsCampPending = true,
      RuinsCampDone = false,
      RuinsCampNightDone = false,
      PlayTempRuinsScene = false,
      RuinsLastExitReason = '',
    }},
  },
  {
    key = 'ruins_ko',
    label = "Ch5 — Camp des Ruines : reveil apres KO",
    chapter = 5, ground = 'cloven_ruins_entrance', entry = 'Main_Entrance_Marker',
    note = "cloven_ruins_entrance/init.lua:78 — PlayTempRuinsScene, raison 'Died'",
    set = { Chapter5 = {
      PlayTempRuinsScene = true,
      RuinsLastExitReason = 'Died',
      RuinsCampPending = false,
      RuinsCampDone = true,
      RuinsCampNightDone = false,
    }},
  },
  {
    key = 'ruins_retreat',
    label = "Ch5 — Camp des Ruines : repli volontaire",
    chapter = 5, ground = 'cloven_ruins_entrance', entry = 'Main_Entrance_Marker',
    note = "cloven_ruins_entrance/init.lua:79 — PlayTempRuinsScene, raison 'Retreated'",
    set = { Chapter5 = {
      PlayTempRuinsScene = true,
      RuinsLastExitReason = 'Retreated',
      RuinsCampPending = false,
      RuinsCampDone = true,
      RuinsCampNightDone = false,
    }},
  },
  {
    key = 'ruins_morning',
    label = "Ch5 — Camp des Ruines : matin apres le reve",
    chapter = 5, ground = 'cloven_ruins_entrance', entry = 'Main_Entrance_Marker',
    note = "cloven_ruins_entrance/init.lua:64 — RuinsCampNightDone and not RuinsCampDone",
    set = { Chapter5 = {
      RuinsCampNightDone = true,
      RuinsCampDone = false,
      RuinsCampPending = false,
      PlayTempRuinsScene = false,
    }},
  },
  {
    key = 'mount_intro',
    label = "Ch5 — Mont Windsep : arrivee",
    chapter = 5, ground = 'mount_windswept_entrance', entry = 'Main_Entrance_Marker',
    note = "mount_windswept_entrance/init.lua:163 — not FinishedMountWindsweptIntro",
    set = { Chapter5 = {
      FinishedMountWindsweptIntro = false,
      CampNightWatchDone = false,
      PlayTempMountScene = false,
    }},
  },
  {
    key = 'mount_ko',
    label = "Ch5 — Mont Windsep : retour apres KO",
    chapter = 5, ground = 'mount_windswept_entrance', entry = 'Main_Entrance_Marker',
    note = "mount_windswept_entrance/init.lua:165 — PlayTempMountScene",
    set = { Chapter5 = {
      FinishedMountWindsweptIntro = true,
      PlayTempMountScene = true,
      MountLastExitReason = 'Died',
      CampNightWatchDone = false,
    }},
  },
  {
    key = 'colline_xatu',
    label = "Ch7 — Colline des Anciens : vision de Xatu",
    chapter = 7, ground = 'colline_anciens', entry = 'Main_Entrance_Marker',
    note = "scene jouee inconditionnellement dans colline_anciens.Enter",
    set = { Chapter7 = { VisitedXatu = false }},
  },
  {
    key = 'dazzling',
    label = "Ch6 — Foret Lugubre : arrivee de la Team Dazzling",
    chapter = 6, ground = 'gloomy_forest_entrance', entry = 'Main_Entrance_Marker',
    note = "gloomy_forest_entrance/init.lua:30 — chapitre 6 et not FinishedGloomyForestIntro",
    set = { Chapter6 = { FinishedGloomyForestIntro = false }},
  },
  {
    key = 'kirlia',
    label = "Ch8 — Cafe Spinda : quizz de Kirlia",
    chapter = 8, ground = 'metano_cafe', entry = 'Main_Entrance_Marker',
    note = "metano_cafe.KirliaQuiz — chapitre >= 8 et QuizScore == nil",
    set = { Chapter8 = { QuizScore = nil }},
  },
}


--------------------------------------------------------------------
-- Recherche d'une scene par sa cle.
--------------------------------------------------------------------
function SceneDebug.Find(key)
  for _, sc in ipairs(SceneDebug.scenes) do
    if sc.key == key then return sc end
  end
  return nil
end


--------------------------------------------------------------------
-- Ecrit l'etat SV d'une scene, SANS deplacer le joueur.
-- Retourne true si l'armement a reussi.
--------------------------------------------------------------------
function SceneDebug.Arm(key)
  local sc = SceneDebug.Find(key)
  if sc == nil then
    PrintInfo('[SceneDebug] cle inconnue : ' .. tostring(key))
    return false
  end

  local ok, err = pcall(function()
    if sc.chapter ~= nil then
      SV.ChapterProgression.Chapter = sc.chapter
    end
    for tableName, fields in pairs(sc.set) do
      if SV[tableName] == nil then SV[tableName] = {} end
      for field, value in pairs(fields) do
        SV[tableName][field] = value
      end
    end
  end)

  if not ok then
    PrintInfo('[SceneDebug] armement echoue (' .. tostring(key) .. ') : ' .. tostring(err))
    return false
  end

  PrintInfo('[SceneDebug] arme : ' .. sc.label)
  PrintInfo('[SceneDebug]   condition visee : ' .. tostring(sc.note))
  return true
end


--------------------------------------------------------------------
-- Arme puis depose le joueur sur la carte de la scene.
--------------------------------------------------------------------
function SceneDebug.Go(key)
  local sc = SceneDebug.Find(key)
  if sc == nil then
    PrintInfo('[SceneDebug] cle inconnue : ' .. tostring(key))
    return
  end
  if not SceneDebug.Arm(key) then return end

  pcall(function() GAME:FadeOut(false, 20) end)
  GAME:EnterGroundMap(sc.ground, sc.entry)
end


--------------------------------------------------------------------
-- Menu de selection. A appeler depuis un PNJ ou objet de debug.
--------------------------------------------------------------------
function SceneDebug.Menu()
  local labels = {}
  for _, sc in ipairs(SceneDebug.scenes) do
    labels[#labels + 1] = sc.label
  end
  labels[#labels + 1] = "(annuler)"

  UI:BeginMultiPageMenu(24, 24, 232, "Armer une scene", labels, 8, 1, #labels)
  UI:WaitForChoice()
  local pick = UI:ChoiceResult()

  if pick == nil or pick > #SceneDebug.scenes then return end
  SceneDebug.Go(SceneDebug.scenes[pick].key)
end


--------------------------------------------------------------------
-- Diagnostic : affiche l'etat actuel des drapeaux d'une scene, pour
-- comprendre POURQUOI une cinematique ne part pas.
--------------------------------------------------------------------
function SceneDebug.Why(key)
  local sc = SceneDebug.Find(key)
  if sc == nil then
    PrintInfo('[SceneDebug] cle inconnue : ' .. tostring(key))
    return
  end

  PrintInfo('[SceneDebug] === ' .. sc.label .. ' ===')
  PrintInfo('[SceneDebug] condition : ' .. tostring(sc.note))
  if sc.chapter ~= nil then
    local cur = SV.ChapterProgression.Chapter
    PrintInfo(string.format('[SceneDebug] chapitre : actuel=%s attendu=%s %s',
      tostring(cur), tostring(sc.chapter),
      (cur == sc.chapter) and 'OK' or '<-- BLOQUANT'))
  end
  for tableName, fields in pairs(sc.set) do
    for field, expected in pairs(fields) do
      local actual = nil
      pcall(function() actual = SV[tableName][field] end)
      local match = (actual == expected)
      PrintInfo(string.format('[SceneDebug] SV.%s.%s : actuel=%s attendu=%s %s',
        tableName, field, tostring(actual), tostring(expected),
        match and 'OK' or '<-- A CORRIGER'))
    end
  end
end

return SceneDebug
