--[[
    guild_heros_room_ch_6.lua
    Chapter 6 hero room scenes: Title Card
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_6 = {}


function guild_heros_room_ch_6.ShowTitleCard()
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(CH('Teammate1'))
  UI:ResetSpeaker()
  SOUND:StopBGM()
  GAME:WaitFrames(60)
  local coro1 = TASK:BranchCoroutine(function()
    UI:WaitShowTitle("Chapitre 6\n\nLa Forêt Lugubre\n", 20)
    GAME:WaitFrames(180)
    UI:WaitHideTitle(20)
  end)
  --FOND DEDIE AU CHAPITRE 6.
  --Il affichait « Chapter_4 » : le ch6 empruntait l'image du Bosquet
  --Apricorn, alors que la regle impose une image propre a chaque chapitre
  --(« pas de reutilisation d'un meme visuel generique d'un chapitre a
  --l'autre »). Chapter_6 est un rendu de la clairiere de la Foret Lugubre,
  --produit par tools/make_chapter_bg.py depuis les tuiles reelles du jeu
  --et assombri a la meme luminance que les fonds Chapter_1 a 4.
  local coro2 = TASK:BranchCoroutine(function()
    UI:WaitShowBG("Chapter_6", 180, 20)
    GAME:WaitFrames(180)
    UI:WaitHideBG(20)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(120)
  SV.Chapter6.ShowedTitleCard = true
  guild_heros_room_helper.Morning(true)
end


return guild_heros_room_ch_6
