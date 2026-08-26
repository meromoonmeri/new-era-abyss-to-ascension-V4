-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D31P31A/s01p0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(45, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D31P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(partner, 216, 300, false, 2)
  GROUND:MoveToPosition(hero, 240, 300, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  SkySceneKit.say({english="We can move on if we avoid\nfalling in.", french="Si on l'évite, on pourra\nprogresser.", german="Wir können weiterkommen, wenn\nwir vermeiden, dort herunterzufallen.", italian="Possiamo continuare se non\nrifacciamo lo stesso errore.", spanish=" Esta vez pasaremos de largo..."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  SkySceneKit.say({english="But there may be other pitfalls.\nLet's watch our step carefully.", french="Mais il pourrait y en avoir\nd'autres. On doit avancer avec beaucoup\nde précaution.", german="Es könnte dort allerdings noch\nandere Gruben-Fallen geben. Wir müssen\naufpassen, wo wir hintreten.", italian="Ma potrebbero esserci altre\ntrappole. Dobbiamo avanzare con cautela.", spanish="Aunque tendremos que movernos\ncon mucho cuidado, ya que podría haber más."}) -- SwitchTalk: branche default (canon générique)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 232, 424, Direction.Up, "NPC_PUKURIN")
  GROUND:MoveToPosition(npc_npc_pukurin, 228, 308, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(7942) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-28), 11, false) end) -- MovePositionOffset performer/caméra
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-28), false, 2) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-28), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:FadeOut(false, 5)
  -- GAP: se_Play(7938) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaah!", german=" Uaaaah!", italian=" Aaaaah!", spanish=" ¡Aaaah!"}) -- SwitchTalk: branche default (canon générique)
  -- message_CloseEnforce
  -- GAP: se_Play(7939) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  SkySceneKit.say({english=" Owowow...", french=" Ouh là là...", german=" Oh, oh, oh...", italian=" Ahiahiahi...", spanish=" Ay, ay, ay..."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.cleanup_npcs()
end
