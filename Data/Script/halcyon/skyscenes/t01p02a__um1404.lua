-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/um1404.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_yadon = SkySceneKit.spawn_npc("slowpoke", 288, 256, Direction.DownRight, "NPC_YADON")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yadon, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="We've been away from Treasure\nTown for some time...", french="On a quitté Bourg-Trésor\nquelque temps...", german="Nach einiger Zeit sind wir\nmal wieder in Schatzstadt.", italian="Siamo stati via da Borgo Tesoro\nper un po' di tempo...", spanish="Hacía tiempo que no veníamos\npor Aldea Tesoro."})
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english=" I like it here. It's so laid back.", french="J'aime bien cet endroit. C'est\ntellement relax.", german="Mir gefällt es hier. Es ist so\nlocker hier.", italian="Mi piace qui.\nÈ rilassante.", spanish="Me gusta estar aquí. Es bastante\nrelajado."})
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="Oh...[K] My motivation's\nslipping already...", french="Oh...[K] Voilà que ma motivation\ndécline déjà...", german="Oh...[K] Meine Motivation schwindet\nbereits...", italian="Oh...[K] La mia motivazione\nsi sta... dissolvendo...", spanish="¡Uf![K] Ya empiezo a\ndesmotivarme."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yadon, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="First time I come here, and\nthe place is empty...", french="C'est la première fois que je\nviens ici et il n'y a personne...", german="Das ist das erste Mal, dass ich\nhierherkomme und dieser Ort leer ist...", italian="Vengo qui per la prima volta e\nil posto è deserto...", spanish="Es la primera vez que vengo y\nme encuentro con que el sitio está vacío..."})
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english=" This shop is lacking drive.", french=" Ce magasin manque d'animation.", german=" Diesem Laden fehlt der Schwung!", italian="Questo negozio non è gestito\nbene.", spanish=" A este local le falta ambiente."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
