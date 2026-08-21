-- Chapter 6 campaign cadence around canonical Sinister Woods.
-- The legacy zone ID gloomy_forest remains save-compatible; every player-facing
-- name and progression beat is Sinister Woods / Forêt Sinistre.
local L = {}

local function c6()
  SV.Chapter6 = SV.Chapter6 or {}
  SV.Chapter6.SinisterLifecycle = SV.Chapter6.SinisterLifecycle or {
    Phase = 'guild_preparation', Attempt = 0, Day = 1,
  }
  return SV.Chapter6.SinisterLifecycle
end

function L.Ensure() return c6() end
function L.Prepare()
  local s=c6(); s.Phase='guild_preparation'; return s
end
function L.StartExpedition()
  local s=c6(); s.Attempt=(s.Attempt or 0)+1; s.Phase='exploration'; s.LastOutcome=nil
end
function L.Checkpoint()
  local s=c6(); s.Phase='checkpoint'; s.CheckpointReached=true
end
function L.Retry(reason)
  local s=c6(); s.Phase='retry'; s.LastOutcome=reason or 'defeat'
end
function L.ReturnToGuild(reason)
  local s=c6(); s.Phase='guild_report'; s.LastOutcome=reason or 'abandon'
  SV.TemporaryFlags.MissionCompleted=true
  SV.TemporaryFlags.Dinnertime=true
  SV.TemporaryFlags.PostJobsGround=''
end
function L.Victory()
  local s=c6(); s.Phase='town_consequences'; s.LastOutcome='victory'; s.ForestCleared=true
end
function L.AfterTownConsequences()
  local s=c6(); s.Phase='guild_report'; s.ConsequencesSeen=true
  SV.TemporaryFlags.MissionCompleted=true
  SV.TemporaryFlags.Dinnertime=true
  SV.TemporaryFlags.PostJobsGround=''
end
function L.AfterDinner()
  local s=c6(); s.Phase='bedtime'; s.DinnerSeen=true
  SV.TemporaryFlags.Bedtime=true
  SV.TemporaryFlags.MorningWakeup=false
end
function L.AfterEveningTalk()
  local s=c6(); s.EveningTalkSeen=true; s.Phase='sleep'
end
function L.AfterWake()
  local s=c6(); s.Day=(s.Day or 1)+1; s.Phase='guild_routine'; s.MorningTalkSeen=true
end
function L.Phase() return c6().Phase end
return L
