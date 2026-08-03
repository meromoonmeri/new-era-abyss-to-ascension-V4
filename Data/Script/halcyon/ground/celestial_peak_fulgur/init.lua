--[[ Tour Celeste — Aire des Dragons (segment 3).

     RECASTE le 2026-08-04. Cet etage portait une « Escouade Fulgur »
     electrique (Luxray / Lucario / Heliolisk) au milieu d'une tour de
     dragons, sur la route de Rayquaza. Le trio est desormais
     Vertevire (Dracolosse), Bregonde (Drattak) et Nubila (Altaria).

     L'Escouade Fulgur n'est PAS supprimee du jeu : elle reste l'equipe
     rivale de l'arc du Suaire (SuaireArc.lua), ou sa presence a du sens.
     Seul cet etage change de casting.

     Les positions de cinematique sont conservees telles quelles : elles
     etaient deja calees sur la geometrie du ground. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ReplayEnding'
local celestial_peak_fulgur = {}
function celestial_peak_fulgur.Init(map) DEBUG.EnableDbgCoro() end
function celestial_peak_fulgur.Enter(map)
  DEBUG.EnableDbgCoro()

  -- Rejouabilite : le trio a deja ete ecarte. Il ne campe pas la corniche en
  -- permanence. On constate, puis on continue vers le Sommet Sacre
  -- (segment 4) — ce n'est PAS une fin de donjon.
  if ReplayEnding.IsReplay('celestial_peak', 10) then
    ReplayEnding.PlayEmptyScene({
      hero = {172, 180}, partner = {140, 180},
      camera = {156, 156}, look = {156, 132},
      walk = 40, title = true, music = 'Rainbow Peak.ogg',
      lines = {
        { spk='partner', emo='Normal', key='CPF_R01', wait=10 },
        { spk='hero',    emo='Normal', key='CPF_R02', wait=10 },
        { spk='partner', emo='Happy',  key='CPF_R03' },
      },
    })
    -- On rejoint le relais, comme le ferait une victoire sur le trio au
    -- chapitre 10 : le joueur y retrouve son rocher Kangourex avant le sommet.
    -- Le relais lit SV.Chapter10.OutranEscouadeFulgur (deja vrai) pour viser
    -- le segment 4 en sortie nord.
    SV.Chapter10.ReplayPastFulgur = true
    GAME:EnterGroundMap('celestial_peak_relay', 'Main_Entrance_Marker')
    return
  end

  GAME:FadeIn(40)
  SOUND:PlayBGM("Boss Battle!.ogg", false)
  -- Le meneur au centre, les deux ailes de part et d'autre : meme
  -- disposition que dans l'arene qui suit (Dracolosse en 7,4 ; Drattak a
  -- gauche en 5,5 ; Altaria a droite en 9,5).
  local salamence = CharacterEssentials.MakeCharactersFromList({{'Wyrm_Salamence', 120, 140, Direction.Down}})
  local dragonite = CharacterEssentials.MakeCharactersFromList({{'Wyrm_Dragonite', 156, 140, Direction.Down}})
  local altaria   = CharacterEssentials.MakeCharactersFromList({{'Wyrm_Altaria',   192, 140, Direction.Down}})
  UI:SetSpeaker(dragonite)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPF_001']))
  UI:SetSpeaker(altaria)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPF_002']))
  UI:SetSpeaker(salamence)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPF_003']))
  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("celestial_peak", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
function celestial_peak_fulgur.Update(map, time) end
function celestial_peak_fulgur.GameSave(map) end
function celestial_peak_fulgur.GameLoad(map) end
return celestial_peak_fulgur