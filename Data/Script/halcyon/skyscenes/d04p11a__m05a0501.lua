-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D04P11A/m05a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D04P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_RAIN2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ready? Let's go, [hero]!", french=" On y va, [hero]!", german=" Fertig? Los, [hero]!", italian="Tutto pronto?\nAndiamo, [hero]!", spanish="¿Todo listo?\n¡Vamos, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ready? Let's go, [hero]!", french=" On y va, [hero]!", german=" Fertig? Los, [hero]!", italian="Tutto pronto?\nAndiamo, [hero]!", spanish="¿Todo listo?\n¡Vamos, [hero]!"})
  else
  SkySceneKit.say({english=" Ready? Let's go, [hero]!", french=" On y va, [hero]!", german=" Fertig? Los, [hero]!", italian="Tutto pronto?\nAndiamo, [hero]!", spanish="¿Todo listo?\n¡Vamos, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Three...[K] Two...[K] One...[K] Now!", french=" Trois...[K] deux...[K] un...[K] Maintenant!", german=" Drei...[K] Zwei...[K] Eins...[K] Jetzt!", italian=" Tre...[K] Due...[K] Uno...[K] Adesso!", spanish=" Tres...[K] Dos...[K] Uno...[K] ¡Ya!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Three...[K] Two...[K] One...[K] Now!", french=" Trois...[K] deux...[K] un...[K] Maintenant!", german=" Drei...[K] Zwei...[K] Eins...[K] Jetzt!", italian=" Tre...[K] Due...[K] Uno...[K] Adesso!", spanish=" Tres...[K] Dos...[K] Uno...[K] ¡Ya!"})
  else
  SkySceneKit.say({english=" Three...[K] Two...[K] One...[K] Now!", french=" Trois...[K] deux...[K] un...[K] Maintenant!", german=" Drei...[K] Zwei...[K] Eins...[K] Jetzt!", italian=" Tre...[K] Due...[K] Uno...[K] Adesso!", spanish=" Tres...[K] Dos...[K] Uno...[K] ¡Ya!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_Close
  -- Move2PositionOffset 0 [cible sans placement SSA zone: déplacement non joué]
  GROUND:MoveToPosition(hero, 268, 196, false, 2)
  GROUND:MoveToPosition(partner, 236, 196, false, 2)
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GROUND:MoveToPosition(hero, 268, 164, false, 2)
  GROUND:MoveToPosition(partner, 236, 164, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6675) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(true, 15) -- screen_WhiteOut
  GAME:WaitFrames(2) -- join WaitSe
end
