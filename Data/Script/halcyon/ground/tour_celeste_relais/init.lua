--[[
  tour_celeste_relais/init.lua
  Tour Céleste — Relais (D13P02) — PMD Red authentique
  Source: PMD-5/Data/Ground/palier_celeste.rsground (57x57) + PMDRed D13P02
  Preserve integrite: 57x57, Sheet PalierCeleste_Base, 1 Spawner TEAMMATE_1, 2 Markers
  Fonction: checkpoint avant sommet, soigne PP/ventre, dialogue partenaire
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local relais = {}

function relais.Init(map)
  pcall(function() GAME:FadeOut(false, 1) end)
end

function relais.Enter(map)
  pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  if partner then AI:DisableCharacterAI(partner) end
  GAME:MoveCamera(228, 228, 1, false) -- centre 57*8/2
  GAME:CutsceneMode(true)
  GAME:WaitFrames(20)
  UI:ResetSpeaker()
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Sky Tower.ogg", true) end)
  GAME:WaitFrames(20)
  -- D13P02 : 2 anims, relais calme avant tempête
  if partner then
    GeneralFunctions.StartConversation(partner, STRINGS:Format(STRINGS.MapStrings['TCR_001']), "Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCR_002']))
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCR_003']))
    GeneralFunctions.EndConversation(partner)
  end
  -- Soigne silencieusement (comme tout relais)
  pcall(function()
    for i=0, GAME:GetPlayerPartyCount()-1 do
      local p = GAME:GetPlayerPartyMember(i)
      if p then p:RestoreAll() end
    end
  end)
  GAME:CutsceneMode(false)
  if partner then AI:EnableCharacterAI(partner) end
end

function relais.Update(map) end
function relais.GameSave(map) end
function relais.GameLoad(map) GAME:FadeIn(20) end

return relais
