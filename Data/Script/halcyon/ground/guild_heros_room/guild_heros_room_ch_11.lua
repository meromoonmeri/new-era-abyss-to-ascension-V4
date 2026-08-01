--[[
    guild_heros_room_ch_11.lua
    Chambre du Héros — Chapitre 11 : L'Autre Continent
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'

guild_heros_room_ch_11 = {}

function guild_heros_room_ch_11.ShowTitleCard()
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(CH('Teammate1'))
  UI:ResetSpeaker()
  SOUND:StopBGM()
  GAME:WaitFrames(60)

  local coro1 = TASK:BranchCoroutine(function()
    UI:WaitShowTitle("Chapitre 11\nL'Autre Continent\n", 20)
    GAME:WaitFrames(180)
    UI:WaitHideTitle(20)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    UI:WaitShowBG("Chapter_1", 180, 20) -- Utilise le BG du chapitre 1 comme fallback esthétique pour la traversée
    GAME:WaitFrames(180)
    UI:WaitHideBG(20)
  end)
  TASK:JoinCoroutines({coro1, coro2})
  
  GAME:WaitFrames(120)
  SV.Chapter11.ShowedTitleCard = true
  
  -- Le matin se lève
  guild_heros_room_helper.Morning(true)
end

return guild_heros_room_ch_11
