require 'origin.common'
local S={};local SEASONS={'spring','summer','autumn','winter'};local PARTICLES={spring='sakura_drift',autumn='autumn_leaves',winter='winter_snow'};local LIGHT={[0]='dusk',[2]='dusk',[3]='darkness'}
local MUSIC={spring={[0]='Berry Grove.ogg',[1]='Berry Grove.ogg',[2]='On the Beach at Dusk.ogg',[3]='Goodnight.ogg'},summer={[0]='Apple Woods.ogg',[1]='Apple Woods.ogg',[2]='On the Beach at Dusk.ogg',[3]='Goodnight.ogg'},autumn={[0]='Bramble Woods.ogg',[1]='Bramble Woods.ogg',[2]='On the Beach at Dusk.ogg',[3]='Goodnight.ogg'},winter={[0]='Frosty Forest.ogg',[1]='Frosty Forest.ogg',[2]='On the Beach at Dusk.ogg',[3]='Goodnight.ogg'}}
function S.Ensure()SV.NoNameVillage=SV.NoNameVillage or{};local s=SV.NoNameVillage;if s.Season==nil then s.Season='spring'end;if s.TimeOfDay==nil then s.TimeOfDay=0 end;if s.SourceStage==nil then s.SourceStage=false end;return s end
-- Bornes exactes de scrseasonmap/objstage dans la VM source.
function S.SeasonFromSourceStage(stage)if type(stage)~='number'then return nil end;if stage<2 then return'spring'elseif stage<3 then return'summer'elseif stage<4 then return'autumn'elseif stage<8 then return'winter'end;return nil end
function S.SelectedSeason(fallback)local s=S.Ensure();local proven=S.SeasonFromSourceStage(s.SourceStage);if proven then return proven end;for _,v in ipairs(SEASONS)do if s.Season==v then return v end end;return fallback or'spring'end
function S.SetSourceStage(stage)local s=S.Ensure();s.SourceStage=stage;local v=S.SeasonFromSourceStage(stage);if v then s.Season=v end;return v end
function S.SetTimeOfDay(v)local s=S.Ensure();if v==0 or v==1 or v==2 or v==3 then s.TimeOfDay=v end;return s.TimeOfDay end
local function clear()for _,v in ipairs({'sakura_drift','autumn_leaves','winter_snow','dusk','darkness'})do pcall(function()GROUND:RemoveMapStatus(v)end)end end
function S.Apply(season,interior)local s=S.Ensure();s.Season=season or s.Season;clear();if not interior and PARTICLES[s.Season]then pcall(function()GROUND:AddMapStatus(PARTICLES[s.Season])end)end;if LIGHT[s.TimeOfDay]then pcall(function()GROUND:AddMapStatus(LIGHT[s.TimeOfDay])end)end;local music=(MUSIC[s.Season]or MUSIC.spring)[s.TimeOfDay];if music then pcall(function()SOUND:PlayBGM(music,true)end)end;return s end
function S.EnterSelected(marker)GAME:EnterGroundMap('no_name_village_'..S.SelectedSeason('spring'),marker or'Main_Entrance_Marker')end
function S.Clear()clear()end
return S
