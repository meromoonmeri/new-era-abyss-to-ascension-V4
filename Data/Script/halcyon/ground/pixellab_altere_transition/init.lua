-- Ground Script for Altere Transition (PixelLab Native)
-- Generated via SkyTemple & PixelLab Map Pipeline

require 'origin.common'

local pixellab_altere_transition = {}

function pixellab_altere_transition.Init(map)
  DEBUG.EnableLogs(false)
end

function pixellab_altere_transition.Enter(map)
  SOUND:PlayBGM("Treasure Town.ogg", true)
  GAME:FadeIn(20)
end

function pixellab_altere_transition.Update(map, time)
  -- River flowing animation update
end

function pixellab_altere_transition.Exit(map)
  GAME:FadeOut(20)
end

function pixellab_altere_transition.Exit_AlterePond_Touch(obj, activator)
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Approaching the tranquil waters of Altere Pond...")
  GAME:EnterGroundMap("altere_pond", "Entry_South")
end

function pixellab_altere_transition.Entry_Metano_Touch(obj, activator)
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Returning to Metano Town...")
  GAME:EnterGroundMap("metano_town", "Exit_North")
end

return pixellab_altere_transition
