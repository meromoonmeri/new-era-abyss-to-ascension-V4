--[[
    init.lua
    Pic Celeste (Celestial Peak) — Chapitre 10
    22 etages en 6 segments : 8 contreforts + relais + 6 nuages + Escouade Fulgur + 4 sommet + boss Lugia
    Course contre l'Escouade Fulgur (Luxray, Lucario, Heliolisk)
    Premiere vision de Necrozma
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.ChapterAftermath'
require 'halcyon.ReplayEnding'

local celestial_peak = {}

function celestial_peak.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_celestial_peak")
  SV.TemporaryFlags.LastDungeonEntered = 'celestial_peak'
  -- Rejouabilite : jalon interne au parcours rejoue (voir celestial_peak_relay).
  -- Remis a zero a chaque entree dans le donjon, pour que la Mer de Nuages
  -- (segment 2) soit bien retraversee avant le Sommet Sacre (segment 4).
  if ReplayEnding.IsReplay('celestial_peak', 10) then
    SV.Chapter10.ReplayPastFulgur = false
  end
end

function celestial_peak.EnterSegment(zone, rescuing, segmentID, mapID)
    GeneralFunctions.CheckAllowSetRescue(zone.ID)
    if rescuing ~= true then
        COMMON.BeginDungeon(zone.ID, segmentID, mapID)
    end
end

function celestial_peak.Rescued(zone, name, mail)
    COMMON.Rescued(zone, name, mail)
end

function celestial_peak.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_celestial_peak result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
      return
  end
  if segmentID == 6 then
    -- Annexe de la Toupie (etage mystere) : sortie douce.
    GAME:WaitFrames(10)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
    return
  end

  if segmentID == 0 then
      -- Contreforts Venteux : 8 etages
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('celestial_peak', 10) then
          SV.Chapter10.ReachedCloudRelay = true
          GAME:EnterGroundMap('celestial_peak_relay', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter10.LostFoothills = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              GAME:EndDungeonRun(result, "master_zone", -1, 46, 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
                  "Le vent...[pause=0] il est trop fort...[pause=20] on ne peut plus avancer...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, 46, 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 46, 0, true, true)
          end
      end
  elseif segmentID == 1 then
      -- Relais — corniche nuageuse
      if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:EnterGroundMap('celestial_peak_relay', 'Main_Entrance_Marker')
      end
  elseif segmentID == 2 then
      -- Mer de Nuages : 6 etages
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('celestial_peak', 10) then
          SV.Chapter10.ReachedFulgurEncounter = true
          GAME:EnterGroundMap('celestial_peak_fulgur', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter10.LostCloudSea = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              SV.Chapter10.PeakMidState = 'DeathArrival'
              GAME:EndDungeonRun(result, "master_zone", -1, 75, 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
                  "Les nuages...[pause=0] on est tombes...[pause=25] a travers le ciel...", "Shock")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, 75, 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 75, 0, true, true)
          end
      end
  elseif segmentID == 3 then
      -- Escouade Fulgur
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Chapter10.OutranEscouadeFulgur = true
          GAME:EnterGroundMap('celestial_peak_relay', 'Main_Entrance_Marker')
      else
          SV.Chapter10.FulgurReachedSummitFirst = true
          SV.Chapter10.PeakMidState = 'DeathArrival'
              GAME:EndDungeonRun(result, "master_zone", -1, 75, 0, true, true)
          GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
              "L'Escouade Fulgur...[pause=0] ils nous ont devances...[pause=20] trop rapides...", "Pain")
          GAME:WaitFrames(20)
          GAME:EnterZone("master_zone", -1, 75, 0)
      end
  elseif segmentID == 4 then
      -- Sommet Sacre : 4 etages
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('celestial_peak', 10) then
          SV.Chapter10.ReachedLugiaAltar = true
          -- CORRECTIF 2026-08-04 — les DEUX actes se jouent desormais sur
          -- tour_ciel_sommet. Le commentaire d'origine disait deja que
          -- l'Autel etait Sky Tower Summit importe de pmd-red, mais la
          -- carte porte le tileset Autel_Celeste_Base et la musique
          -- Rainbow Peak.ogg. tour_ciel_sommet est converti directement
          -- depuis Sky_Tower_summit_RTRB.png et porte Sky Tower.ogg.
          -- Rebrancher ICI aussi est indispensable : sinon l'acte 1 se
          -- jouerait a l'Autel et l'acte 2 a la Tour — deux decors
          -- differents dans la meme sequence, exactement le defaut
          -- corrige le 02/08 entre Lugia et Rayquaza.
          GAME:EnterGroundMap('tour_ciel_sommet', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter10.LostSummit = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              SV.Chapter10.PeakMidState = 'DeathArrival'
              GAME:EndDungeonRun(result, "master_zone", -1, 75, 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
                  "Le sommet...[pause=0] si proche...[pause=30] et pourtant...", "Sad")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, 75, 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 75, 0, true, true)
          end
      end
  elseif segmentID == 5 then
      -- Boss Lugia
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Chapter10.DefeatedLugia = true
          SV.Chapter10.CelestialPeakComplete = true
          --------------------------------------------------------------
          -- CORRECTIF 2026-08-02 — le climax n'etait jamais joue.
          --
          -- Le commit a8f2362 (01/08) a ecrit la scene Rayquaza dans
          -- autel_celeste (meteorite, lueur pourpre, bascule ch11) mais
          -- n'a touche QUE ce fichier et ses deux .resx. Il n'a jamais
          -- debranche l'ancienne sortie ci-dessous.
          --
          -- Resultat en jeu : on voyait APPARAITRE Rayquaza, on le
          -- combattait, puis LUGIA repliait ses ailes — deux boss
          -- differents dans la meme sequence. Et comme
          -- SV.ChapterProgression.Chapter = 11 n'existe QUE dans la scene
          -- morte, le chapitre 11 etait inatteignable.
          --
          -- Enchainement retabli, en deux actes sur la meme carte :
          --   ACTE 1  PeakVictory() — la longue discussion. Lugia reste
          --           apres sa defaite et renseigne le heros
          --           (« Cherchez sous l'ecaille »). Il finit epuise,
          --           incapable de se relever.
          --   ACTE 2  autel_celeste.PlayPostVictoryScene — la meteorite
          --           tombe, Lugia ne PEUT plus rien, Rayquaza fend les
          --           nuages. Le climax comble une incapacite etablie
          --           trente secondes plus tot : ce n'est pas un deus ex
          --           machina. Cette scene pose Chapter = 11.
          --
          -- On ne retourne donc PAS a la guilde ici : on revient a
          -- l'Autel, ou l'acte 2 attend. C'est PlayPostVictoryScene qui
          -- clot le chapitre et enchaine sur la chambre.
          --------------------------------------------------------------
          -- CORRECTIF 2026-08-04 — Rayquaza passe au SOMMET DE LA TOUR.
          -- Canoniquement (Rescue Team) Rayquaza se combat au sommet de
          -- Sky Tower, pas sur un pic. autel_celeste est bati sur les
          -- tilesets Mount_Windswept_* : c'est un pic. tour_ciel_sommet
          -- est converti depuis Sky_Tower_summit_RTRB.png.
          -- La scene n'est PAS reecrite : elle est transposee telle
          -- quelle (memes cles CPB_001..CPB_017, memes effets), seules
          -- les coordonnees changent. L'acte 2 y attend, arme par la
          -- meme condition qu'a l'Autel (CelestialPeakComplete +
          -- PlayedLugiaTalk + not PlayedVictoryScene).
          ChapterAftermath.PeakVictory()
          GAME:WaitFrames(30)
          GAME:EnterGroundMap('tour_ciel_sommet', 'Main_Entrance_Marker')
      else
          SV.Chapter10.DiedToLugia = true
          SV.Chapter10.PeakMidState = 'DeathArrival'
              GAME:EndDungeonRun(result, "master_zone", -1, 75, 0, true, true)
          GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
              "Lugia...[pause=0] le Gardien des Cieux...[pause=20] nous a juges...", "Pain")
          GAME:WaitFrames(20)
          GAME:EnterZone("master_zone", -1, 75, 0)
      end
  end
end

return celestial_peak
