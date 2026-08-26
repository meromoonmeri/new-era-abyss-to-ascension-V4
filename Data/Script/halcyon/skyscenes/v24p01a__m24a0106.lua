-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V24P01A/m24a0106.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_V24P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="That's how you met [CS:N]Wigglytuff[CR],\n[CS:N]Lapras[CR]?", french="C'est comme ça que tu as connu\n[CS:N]Grodoudou[CR], [CS:N]Lokhlass[CR]?", german="So hast du also [CS:N]Knuddeluff[CR]\nkennengelernt, [CS:N]Lapras[CR]?", italian="È così che hai conosciuto\n[CS:N]Wigglytuff[CR], [CS:N]Lapras[CR]?", spanish="¿Así es como conociste a\n[CS:N]Wigglytuff[CR], [CS:N]Lapras[CR]?"}) -- SwitchTalk: branche default (canon générique)
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Yes.[K] I didn't intend to reveal\nmyself at all...", french="C'est bien ça.[K] Au début,\nje n'avais pas du tout prévu de me montrer...", german="Ja.[K] Ich hatte überhaupt nicht\nvorgehabt, mich zu erkennen zu geben.", italian="Sì.[K] Non avevo nessuna\nintenzione di mostrarmi...", spanish="Así es.[K] No pensaba dejarme\nver..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="But I changed my mind the\ninstant I saw [CS:N]Chatot[CR] on the ground.", french="Mais j'ai changé d'avis dès que\nj'ai vu [CS:N]Pijako[CR] à terre.", german="Aber ich änderte meine Meinung\nin der Sekunde, als ich [CS:N]Plaudagei[CR] auf dem\nBoden liegen sah.", italian="Ma appena ho visto [CS:N]Chatot[CR] a\nterra ho cambiato idea.", spanish="Pero cambié de opinión en\ncuanto vi a [CS:N]Chatot[CR] en el suelo."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" I simply had to help.", french=" Il fallait que j'intervienne.", german=" Ich musste einfach helfen.", italian=" Dovevo aiutarlo.", spanish=" Tenía que ayudarles."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Afterward...", french=" Par la suite...", german=" Später...", italian=" In seguito...", spanish=" Después de eso..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="I made [CS:N]Wigglytuff[CR] promise me\nsomething.", french="... j'ai conclu un pacte avec\n[CS:N]Grodoudou[CR].", german="Später rang ich [CS:N]Knuddeluff[CR] ein\nVersprechen ab.", italian="... ho stretto un patto con\n[CS:N]Wigglytuff[CR].", spanish="Le pedí a [CS:N]Wigglytuff[CR] que me\nhiciera una promesa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english=" A promise?", french=" Un pacte?", german=" Ein Versprechen?", italian=" Un patto?", spanish=" ¿Una promesa?"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Yes.", french=" Oui.", german=" Ja.", italian=" Sì.", spanish=" Sí."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 30)
end
