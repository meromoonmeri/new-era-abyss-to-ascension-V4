require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

gloomy_forest_entrance_ch_6 = {}

function gloomy_forest_entrance_ch_6.SetupGround()
	local butterfree = CharacterEssentials.MakeCharactersFromList({
		{'Butterfree', 244, 240, Direction.DownRight}
	})
	AI:SetCharacterAI(butterfree, "halcyon.ai.ground_default", RogueElements.Loc(224, 224), RogueElements.Loc(48, 48), 1, 16, 32, 40, 180)
end

function gloomy_forest_entrance_ch_6.ArrivalCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	--BUTTERFREE ETAIT PLANTE DANS UN MUR.
	--Sa position d'origine (244,240) et son point d'avance (276,216) ont
	--ete confrontes a la grille de collision (tools/nea_map.py) : les
	--DEUX sont bloques. Il apparaissait donc dans le decor, et son
	--MoveToPosition ne pouvait pas aboutir.
	--Nouvelles positions verifiees libres en boite 20x20 : il attend en
	--(280,264), au bord du couloir, et vient au-devant du duo en
	--(296,264) — deux cases praticables, dans le champ de la camera.
	local butterfree = CharacterEssentials.MakeCharactersFromList({
		{'Butterfree', 280, 264, Direction.Down}
	})

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	AI:DisableCharacterAI(butterfree)
	GAME:MoveCamera(276, 232, 1, false)
	GAME:FadeOut(false, 1)

	--LE COULOIR SE RESSERRE A MI-PARCOURS.
	--Le trajet d'origine (276,416 -> 276,288) a ete teste : il BUTE en
	--(276,377). A hauteur y=360, la seule bande praticable est
	--x=296..328. Le duo remonte donc par x=312/328, puis s'ouvre en
	--eventail une fois le goulot passe. Trajets valides de bout en bout.
	GROUND:TeleportTo(hero, 312, 408, Direction.Up)
	GROUND:TeleportTo(partner, 328, 408, Direction.Up)
	GAME:FadeIn(40)
	SOUND:PlayBGM('Mystifying Forest.ogg', true)

	local coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(hero, 312, 360, false, 1)
		GeneralFunctions.EightWayMove(hero, 296, 288, false, 1)
	end)
	local coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GeneralFunctions.EightWayMove(partner, 328, 360, false, 1)
		GeneralFunctions.EightWayMove(partner, 328, 288, false, 1)
	end)
	--BUTTERFREE LES A ENTENDUS ARRIVER. Il ne les attend pas immobile :
	--il tourne la tete vers le bruit AVANT qu'ils soient a sa hauteur —
	--le corps parle avant la bouche, regle de mise en scene du projet.
	local coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(30)
		pcall(function()
			GROUND:CharTurnToCharAnimated(butterfree, hero, 4)
			GeneralFunctions.EmoteAndPause(butterfree, "Notice", true)
		end)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(12)

	--LE DUO SE TOURNE VERS LUI. Le defaut releve a l'audit : Butterfree
	--enchainait six repliques sans qu'un seul personnage le regarde.
	local t1 = TASK:BranchCoroutine(function()
		GROUND:CharTurnToCharAnimated(hero, butterfree, 4)
	end)
	local t2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(6)
		GROUND:CharTurnToCharAnimated(partner, butterfree, 4)
	end)
	TASK:JoinCoroutines({t1, t2})

	--IL VIENT AU-DEVANT D'EUX plutot que de parler a distance.
	pcall(function() GeneralFunctions.EightWayMove(butterfree, 296, 264, false, 1) end)
	pcall(function() GROUND:CharTurnToCharAnimated(butterfree, hero, 4) end)
	GAME:WaitFrames(10)

	UI:SetSpeaker(butterfree)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_002']))
	GAME:WaitFrames(16)

	--LE PARTENAIRE PREND LA PAROLE : Butterfree et le heros se tournent
	--vers lui. Le foyer d'attention change, les orientations suivent.
	local p1 = TASK:BranchCoroutine(function()
		GROUND:CharTurnToCharAnimated(butterfree, partner, 4)
	end)
	local p2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(5)
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
	end)
	TASK:JoinCoroutines({p1, p2})

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_003']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_004']))
	GAME:WaitFrames(10)

	--AU TOUR DU HEROS. Meme regle : on regarde qui parle.
	local h1 = TASK:BranchCoroutine(function()
		GROUND:CharTurnToCharAnimated(butterfree, hero, 4)
	end)
	local h2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(5)
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
	end)
	TASK:JoinCoroutines({h1, h2})

	UI:SetSpeaker(hero)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_005']))

	UI:SetSpeaker(butterfree)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_006']))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_007']))

	--QUELQUE CHOSE ATTIRE SON REGARD VERS LE NORD.
	--MoveToPosition(276,216) visait une case DANS UN MUR : le deplacement
	--ne pouvait pas aboutir. Butterfree se contente desormais de se
	--tourner et de reculer d'une case vers le couloir — (296,264) est
	--verifiee libre. Le duo suit son regard : c'est ce qui rend la
	--menace credible avant qu'elle soit nommee.
	GROUND:CharAnimateTurnTo(butterfree, Direction.Up, 4)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	pcall(function() GeneralFunctions.EmoteAndPause(butterfree, "Exclaim", false) end)
	GAME:WaitFrames(8)

	local r1 = TASK:BranchCoroutine(function()
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	end)
	local r2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(6)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
		pcall(function() GeneralFunctions.EmoteAndPause(partner, "Shock", false) end)
	end)
	local r3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		pcall(function() GAME:MoveCamera(296, 208, 40, false) end)
	end)
	TASK:JoinCoroutines({r1, r2, r3})
	GAME:WaitFrames(14)

	UI:SetSpeaker(butterfree)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_009']))

	--Le partenaire se tourne vers Butterfree pour lui repondre, puis
	--reporte les yeux vers le nord : deux mouvements, deux intentions.
	pcall(function() GROUND:CharTurnToCharAnimated(partner, butterfree, 4) end)
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_010']))
	GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_011']))

	--LE HEROS TRANCHE. Les deux autres se tournent vers lui : c'est le
	--moment ou la decision se prend, la mise en scene doit le marquer.
	local d1 = TASK:BranchCoroutine(function()
		GROUND:CharTurnToCharAnimated(butterfree, hero, 4)
	end)
	local d2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(5)
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
	end)
	TASK:JoinCoroutines({d1, d2})

	UI:SetSpeaker(hero)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_012']))
	GAME:WaitFrames(10)

	--Le partenaire acquiesce pendant que Butterfree reprend : deux
	--acteurs, un seul temps — c'est ce qui manquait le plus a la scene.
	local n1 = TASK:BranchCoroutine(function()
		pcall(function() GeneralFunctions.DoAnimation(partner, 'Nod') end)
	end)
	local n2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		UI:SetSpeaker(butterfree)
		GeneralFunctions.SetEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_013']))
	end)
	TASK:JoinCoroutines({n1, n2})
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_014']))
	GAME:MoveCamera(296, 232, 40, false)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_015']))
	UI:SetSpeaker(hero)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_016']))
	UI:SetSpeaker(butterfree)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_017']))
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_018']))

	--LE DUO SE TOURNE VERS LA FORET : le depart est joue par le corps
	--avant d'etre dit. Butterfree les regarde partir, et c'est sur ce
	--regard que la scene se ferme.
	local f1 = TASK:BranchCoroutine(function()
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	end)
	local f2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(6)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	end)
	TASK:JoinCoroutines({f1, f2})
	GAME:WaitFrames(10)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_019']))

	pcall(function() GROUND:CharTurnToCharAnimated(butterfree, hero, 4) end)
	UI:SetSpeaker(butterfree)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_020']))
	GAME:WaitFrames(16)

	SV.Chapter6.FinishedGloomyForestIntro = true
	GAME:WaitFrames(20)
	GAME:FadeOut(false, 40)
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(40)
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:FadeIn(40)
	SOUND:PlayBGM('Mystifying Forest.ogg', true)
end

function gloomy_forest_entrance_ch_6.Butterfree_Action(chara, activator)
	if SV.Chapter6.MissionAccepted then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['GF6E_008']), "Worried")
		GeneralFunctions.EndConversation(chara)
	end
end

return gloomy_forest_entrance_ch_6
