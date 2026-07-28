require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.LegendZones'
require 'halcyon.ReplayEnding'
require 'halcyon.DazzlingArc'
require 'halcyon.TownNight'
require 'halcyon.TownRaid'

local gloomy_forest = {}

function gloomy_forest.Init(zone)
	DEBUG.EnableDbgCoro()
	PrintInfo("=>> Init_gloomy_forest")
	SV.TemporaryFlags.LastDungeonEntered = 'gloomy_forest'
end

function gloomy_forest.EnterSegment(zone, rescuing, segmentID, mapID)
	-- Rescues allowed in segments 0 and 1, disallowed in the boss fight (segment 2).
	if segmentID == 2 then
		GAME:SetRescueAllowed(false)
	else
		GeneralFunctions.CheckAllowSetRescue(zone.ID)
	end
	if rescuing ~= true then
		COMMON.BeginDungeon(zone.ID, segmentID, mapID)
	end
end

function gloomy_forest.Rescued(zone, name, mail)
	COMMON.Rescued(zone, name, mail)
end

------------------------------------------------------------------
-- ExitSegment
------------------------------------------------------------------
-- Gloomy Forest has 3 segments:
--   0 = normal floors (procedural, "eighteen floors")
--   1 = depth floors  (procedural, "three floors") + Chenipent rescue objective
--   2 = boss (Zarude, LoadGen gloomy_forest_boss.rsmap)
--
-- A mid-dungeon relay "gloomy_forest_midpoint" (master_zone mapID 61) sits between
-- segment 0 and segment 1. Dying in segment 1 or 2 respawns at the relay instead
-- of Metano Town. Faithful mirror of zone/searing_tunnel + zone/crooked_cavern.
-- See docs/audit_checkpoint_crooked_cavern.md (reusable pattern).
------------------------------------------------------------------
--Retour de fin de journee. N'est utilise QUE lorsque l'equipe rentre
--reellement dormir : les morts au-dela du relais de mi-donjon reapparaissent
--au relais (carte 61) et ne declenchent pas la nuit. Le corps de cette fonction vivait ici et a ete
--deplace dans TownNight.EndDay : les 8 autres donjons repetaient la meme
--sequence, la partager evite d'en maintenir neuf copies.
local function EndDayReturn(result)
	TownNight.EndDay(result, true)
end

function gloomy_forest.ExitSegment(zone, result, rescue, segmentID, mapID)
	GeneralFunctions.RestoreIdleAnim()
	DEBUG.EnableDbgCoro()
	PrintInfo("=>> ExitSegment_gloomy_forest result " .. tostring(result) .. " segment " .. tostring(segmentID))

	local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
	SV.adventure.Thief = false
	if exited == true then return end
  if segmentID == 4 then
    -- Annexe de la Toupie (etage mystere) : on ressort simplement de la salle,
    -- l'exploration du donjon reprend au meme titre qu'un etage traverse.
    GAME:WaitFrames(10)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
    return
  end

  -- PILLARDS DE METANO (segments 6, 7, 8). Ces trois arenes ne sont pas des
  -- etages de la Foret : ce sont les vagues de raid nocturne, hebergees ici
  -- parce qu'un segment doit appartenir a une zone existante. On rentre donc
  -- a la VILLE DE NUIT, pas au donjon.
  if segmentID >= 6 and segmentID <= 8 then
    GAME:WaitFrames(20)
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      -- Victoire : retour a la nuit. TownRaid.Pending est encore vrai, donc
      -- metano_town_nuit.Enter enchaine sur TownRaid.Victory().
      GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
      GAME:WaitFrames(20)
      TownNight.Enter()
    else
      -- Defaite : la ville a ete pillee. On se reveille dans sa chambre, et
      -- la journee suivante commence normalement.
      pcall(function() TownRaid.Defeat() end)
      SV.TemporaryFlags.Bedtime = true
      SV.TemporaryFlags.MorningWakeup = true
      SV.TemporaryFlags.MorningAddress = true
      GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 2, 0, true, true)
    end
    return
  end

	if segmentID == 0 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
		-- *** CHECKPOINT (NEW) *** : stop at the relay instead of flowing directly
		-- into the depth floors. The relay's North exit starts segment 1.
		-- (Original was: GAME:ContinueDungeon("gloomy_forest", 1, 0, 0, ...).)
		SV.Chapter6.GloomyMidpointState = 'FirstArrival'
		GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 61, 0, false, false) --gloomy_forest_midpoint (mapID 61)
		return
	end

	if segmentID == 1 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
		-- Rejouabilite : l'objectif de sauvetage du ch6 est deja accompli, le coeur
		-- de la foret n'a plus de raison de rester ferme.
		if SV.Chapter6.ChenipentFound or ReplayEnding.IsCleared('gloomy_forest') then
			GAME:EnterGroundMap('gloomy_forest_boss', 'Main_Entrance_Marker')
		else
			-- The rescue objective is required before the heart of the forest opens.
			SV.Chapter6.MissionAccepted = false
			EndDayReturn(result)
		end
		return
	end

	if segmentID == 1 and result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
		-- *** CHECKPOINT (NEW) *** : died/escaped in the depth floors.
		if result == RogueEssence.Data.GameProgress.ResultType.Escaped then
			-- Escaped: leave to the entrance, NOT the relay (mirrors Searing Tunnel).
			GAME:WaitFrames(20)
			SV.Chapter6.MissionAccepted = false
			--Fuite volontaire : l'equipe abandonne pour aujourd'hui et rentre dormir.
			EndDayReturn(result)
		else
			-- Died: respawn at the relay.
			SV.GloomyForest.DiedPastCheckpoint = true
			SV.Chapter6.GloomyMidpointState = 'DeathArrival'
			GAME:WaitFrames(20)
			GAME:EndDungeonRun(result, "master_zone", -1, 61, 0, true, true) --relay (mapID 61)
			GAME:WaitFrames(20)
			GAME:EnterZone("master_zone", -1, 61, 0)
		end
		return
	end

	if segmentID == 2 then
		if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
			SV.Chapter6.GloomyBossEncountered = true
			SV.Chapter6.DefeatedGloomyBoss = true
			SV.Chapter6.MissionComplete = true
			SV.Chapter6.DefeatedByZarude = false
			SV.Chapter6.MissionAccepted = false
			--Scene d'apres-boss : la consequence se joue AVANT le retour en
			--ville, exactement comme aux chapitres 8, 9 et 10
			--(ChapterAftermath). Sans elle, le seul boss « personnage » du
			--chapitre s'eteignait sur un fondu au noir.
			DazzlingArc.GloomyVictory()
			--Le duel des Trois est desormais propose au relais : elles ont
			--suivi l'equipe et attendent au coeur de la clairiere.
			SV.Chapter6.DazzlingTrialOffered = true
			-- Beat the boss: return to town (UNCHANGED).
			GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
		else
			-- *** CHECKPOINT (NEW) *** : died/escaped to the boss (Zarude) -> respawn at
			-- the relay (previously returned to town, mapID 1). GloomyBossEncountered
			-- stays true so the next gloomy_forest_boss visit plays the retry scene.
			SV.GloomyForest.DiedPastCheckpoint = true
			SV.Chapter6.GloomyMidpointState = 'DeathArrival'
			SV.Chapter6.DefeatedByZarude = true
			SV.Chapter6.DiedToGloomyBoss = true
			SV.Chapter6.MissionAccepted = false
			GAME:EndDungeonRun(result, "master_zone", -1, 61, 0, true, true) --relay (mapID 61)
			GAME:WaitFrames(20)
			GAME:EnterZone("master_zone", -1, 61, 0)
		end
		return
	end

	------------------------------------------------------------------
	-- Segment 3 : arene de revanche Zarude (zone "Serment Verdoyant").
	-- Accessible uniquement via le stand de Grodoudou, apres achat de la
	-- zone, et seulement si l'histoire a deja fait vaincre Zarude
	-- (SV.Chapter6.DefeatedGloomyBoss). Ce n'est pas une rencontre
	-- aleatoire : c'est un retour volontaire sur les lieux.
	-- Ici le Zarude n'est PAS Unrecruitable : le vaincre peut donc le
	-- faire rejoindre l'equipe selon les regles de recrutement normales.
	------------------------------------------------------------------
	------------------------------------------------------------------
	-- Segment 5 : le duel de la Team Dazzling (« L'Epreuve des Trois »).
	-- Combat SANS ENJEU : ni Coeur, ni fragment, ni progression de
	-- chapitre. Victoire comme defaite, on ressort au relais (carte 61)
	-- et la journee n'avance pas — c'est un match, pas une expedition.
	-- Les trois rivales sont Unrecruitable : ce sont des personnages
	-- d'histoire, elles ne rejoignent pas l'equipe.
	------------------------------------------------------------------
	if segmentID == 5 then
		if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
			SV.Chapter6.DazzlingTrialCleared = true
			DazzlingArc.TrialVictory()
		else
			DazzlingArc.TrialDefeat()
		end
		--Le duel ne se represente pas : gagne ou perdu, il a eu lieu.
		SV.Chapter6.DazzlingTrialOffered = false
		GAME:WaitFrames(20)
		GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 61, 0, false, false)
		return
	end

	if segmentID == 3 then
		if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
			LegendZones.SetDefeated('verdant_oath')
		end
		-- Victoire comme defaite, on ressort en ville : aucune progression
		-- d'histoire n'est en jeu, et la journee n'avance pas.
		GAME:WaitFrames(20)
		GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
		return
	end

	-- Defaite ou fuite au segment 0 : l'equipe rentre a la guilde pour la fin de
	-- journee (diner -> nuit -> lendemain), comme dans les 7 autres donjons de
	-- l'histoire. Auparavant on ressortait carte 1 (Metano Town) en plein jour,
	-- sans diner ni nuit, et DaysPassed n'avancait pas.
	if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
		GAME:WaitFrames(20)
	end
	SV.Chapter6.MissionAccepted = false
	EndDayReturn(result)
end

return gloomy_forest
