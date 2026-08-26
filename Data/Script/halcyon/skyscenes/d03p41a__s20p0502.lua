-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D03P41A/s20p0502.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D03P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="We won't let you do that![K]\n[CS:N]Drowzee[CR], you bully!", french="On ne te laissera pas t'en sortir\ncomme ça![K] [CS:N]Soporifik[CR], tu n'es qu'un monstre!", german="Das lassen wir nicht zu![K]\n[CS:N]Traumato[CR], du Bösewicht!", italian="Non te lo permetteremo![K]\n[CS:N]Drowzee[CR], brutto scellerato!", spanish="¡No te permitiremos que le\nobligues a hacer eso![K]\n[CS:N]Drowzee[CR], ¡eres un abusón!"}) -- SwitchTalk: branche default (canon générique)
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 352, 272, Direction.Down, "NPC_SURIIPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" H-how did you find this place?!", french="Comment avez-vous fait pour\narriver jusqu'ici?!", german=" W-wie habt ihr uns gefunden?!?", italian="C-Come avete fatto ad arrivare\nqui?!", spanish="¡¿Cómo habéis encontrado\neste sitio?!"})
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
