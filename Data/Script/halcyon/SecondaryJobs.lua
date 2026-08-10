--[[
    SecondaryJobs.lua — Contrats des donjons secondaires (Chapitre 6)
    pour le Tableau des Missions de Guilde (Job Bulletin Board).
]]
require 'origin.common'

SecondaryJobs = {}

SecondaryJobs.CONTRACTS = {
  -- === CHAPITRE 6 (Rang 30-33, Difficulté C) ===
  {
    client = 'sandshrew', client_gender = RogueEssence.Data.Gender.Male,
    target = 'sandshrew', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'C', reward = 'money',
    title = "Les mirages qui n'en sont pas",
    flavor = "Les sables mouvants du désert ont englouti notre cargaison d'herbes médicinales.\nNous avons besoin d'une équipe solide pour retrouver notre piste avant la tempête.",
    chapter = 6, zone = 'desert_oublies', segment = 0, floor = 3
  },
  {
    client = 'carbink', client_gender = RogueEssence.Data.Gender.Female,
    target = 'carbink', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'C', reward = 'money',
    title = "L'écho des quartz brisés",
    flavor = "Des roches scintillantes se détachent du plafond de notre caverne sans raison apparente.\nUne mission d'inspection s'impose pour sécuriser les galeries.",
    chapter = 6, zone = 'crevasse_geode', segment = 0, floor = 3
  },
}

function SecondaryJobs.EnsureSV()
  if SV.SecondaryJobsCompleted == nil then
    SV.SecondaryJobsCompleted = {}
  end
end

function SecondaryJobs.CleanCompleted()
  SecondaryJobs.EnsureSV()
  if SV.MissionBoard == nil then return end
  
  local clean = {}
  for _, slot in ipairs(SV.MissionBoard) do
    if slot.Zone and not SV.SecondaryJobsCompleted[slot.Zone] then
      table.insert(clean, slot)
    end
  end
  SV.MissionBoard = clean
end

function SecondaryJobs.PinToBoard()
  SecondaryJobs.EnsureSV()
  if SV.MissionBoard == nil then
    SV.MissionBoard = {}
  end

  local current_ch = 6
  if SV.ChapterProgression and SV.ChapterProgression.Chapter then
    current_ch = SV.ChapterProgression.Chapter
  end

  for _, c in ipairs(SecondaryJobs.CONTRACTS) do
    if c.chapter == current_ch and not SV.SecondaryJobsCompleted[c.zone] then
      local job = {
        Client = c.client,
        ClientGender = c.client_gender,
        Target = c.target,
        TargetGender = c.target_gender,
        Flavor = c.flavor,
        Title = c.title,
        Zone = c.zone,
        Segment = c.segment,
        Floor = c.floor,
        Reward = 0,
        Type = 0,
        Completion = 0,
        Taken = false,
        Difficulty = c.difficulty,
        Item = "",
        Special = "",
        BonusReward = ""
      }
      table.insert(SV.MissionBoard, job)
    end
  end
end

return SecondaryJobs
