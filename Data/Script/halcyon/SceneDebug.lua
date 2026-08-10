--[[
    SceneDebug.lua — ARMEMENT DES SCENES POUR TEST EN JEU (Chapitres 1 à 6)
]]--
require 'origin.common'

SceneDebug = {}

SceneDebug.scenes = {
  {
    key = 'ruins_camp',
    label = "Ch5 — Camp des Ruines : arrivee",
    chapter = 5, ground = 'cloven_ruins_entrance', entry = 'Main_Entrance_Marker',
    note = "cloven_ruins_entrance/init.lua",
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
    note = "cloven_ruins_entrance/init.lua",
    set = { Chapter5 = {
      PlayTempRuinsScene = true,
      RuinsLastExitReason = 'Died',
      RuinsCampPending = false,
      RuinsCampDone = true,
      RuinsCampNightDone = false,
    }},
  },
  {
    key = 'ruins_morning',
    label = "Ch5 — Camp des Ruines : matin apres le reve",
    chapter = 5, ground = 'cloven_ruins_entrance', entry = 'Main_Entrance_Marker',
    note = "cloven_ruins_entrance/init.lua",
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
    note = "mount_windswept_entrance/init.lua",
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
    note = "mount_windswept_entrance/init.lua",
    set = { Chapter5 = {
      FinishedMountWindsweptIntro = true,
      PlayTempMountScene = true,
      MountLastExitReason = 'Died',
      CampNightWatchDone = false,
    }},
  },
  {
    key = 'dazzling',
    label = "Ch6 — Foret Lugubre : arrivee de la Team Dazzling",
    chapter = 6, ground = 'gloomy_forest_entrance', entry = 'Main_Entrance_Marker',
    note = "gloomy_forest_entrance/init.lua",
    set = { Chapter6 = { FinishedGloomyForestIntro = false }},
  },
  {
    key = 'ch1_intro',
    label = "Ch1 — Forêt des Reliques : arrivée du duo",
    chapter = 1, ground = 'relic_forest', entry = 'Main_Entrance_Marker',
    note = "relic_forest/init.lua",
    set = { Chapter1 = { PlayedIntroCutscene = false, PartnerMetHero = false, PartnerEnteredForest = false, PartnerCompletedForest = false, TeamCompletedForest = false }},
  },
  {
    key = 'ch2_riviere',
    label = "Ch2 — Rivière Lumineuse : arrivée",
    chapter = 2, ground = 'illuminant_riverbed_entrance', entry = 'Main_Entrance_Marker',
    note = "illuminant_riverbed_entrance",
    set = { Chapter2 = { FinishedRiver = false }},
  },
  {
    key = 'ch3_caverne',
    label = "Ch3 — Caverne Tortueuse : arrivée",
    chapter = 3, ground = 'crooked_cavern_entrance', entry = 'Main_Entrance_Marker',
    note = "crooked_cavern_entrance",
    set = { Chapter3 = { FinishedOutlawIntro = false }},
  },
  {
    key = 'ch4_noigrumes',
    label = "Ch4 — Forêt des Noigrumes : arrivée",
    chapter = 4, ground = 'apricorn_grove_entrance', entry = 'Main_Entrance_Marker',
    note = "apricorn_grove_entrance/init.lua",
    set = { Chapter4 = { EnteredGrove = false, FinishedGrove = false, ReachedGlade = false }},
  },
}

function SceneDebug.Find(key)
  for _, sc in ipairs(SceneDebug.scenes) do
    if sc.key == key then return sc end
  end
  return nil
end

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
  return true
end

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

return SceneDebug
