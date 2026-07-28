--[[ Celestial Peak — Escouade Fulgur ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ReplayEnding'
local celestial_peak_fulgur = {}
function celestial_peak_fulgur.Init(map) DEBUG.EnableDbgCoro() end
function celestial_peak_fulgur.Enter(map)
  DEBUG.EnableDbgCoro()

  -- Rejouabilite : la course contre l'Escouade Fulgur a deja eu lieu. Ils ne
  -- campent pas la corniche en permanence. On constate, puis on continue vers
  -- le Sommet Sacre (segment 4) — ce n'est PAS une fin de donjon.
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
    -- On rejoint le relais, comme le ferait une victoire sur l'Escouade au
    -- chapitre 10 : le joueur y retrouve son rocher Kangourex avant le sommet.
    -- Le relais lit SV.Chapter10.OutranEscouadeFulgur (deja vrai) pour viser
    -- le segment 4 en sortie nord.
    SV.Chapter10.ReplayPastFulgur = true
    GAME:EnterGroundMap('celestial_peak_relay', 'Main_Entrance_Marker')
    return
  end

  GAME:FadeIn(40)
  SOUND:PlayBGM("Boss Battle!.ogg", false)
  local luxray = CharacterEssentials.MakeCharactersFromList({{'Fulgur_Luxray', 120, 140, Direction.Down}})
  local lucario = CharacterEssentials.MakeCharactersFromList({{'Fulgur_Lucario', 156, 140, Direction.Down}})
  local heliolisk = CharacterEssentials.MakeCharactersFromList({{'Fulgur_Heliolisk', 192, 140, Direction.Down}})
  UI:SetSpeaker(luxray)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPF_001']))
  UI:SetSpeaker(lucario)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPF_002']))
  UI:SetSpeaker(heliolisk)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPF_003']))
  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("celestial_peak", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
function celestial_peak_fulgur.Update(map, time) end
function celestial_peak_fulgur.GameSave(map) end
function celestial_peak_fulgur.GameLoad(map) end
return celestial_peak_fulgur