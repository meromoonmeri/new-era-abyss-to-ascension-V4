--[[
    songe_source_ch_5.lua
    LE SONGE DE LA SOURCE — le rêve du héros, nuit de la veillée du Mont
    Venteux (chapitre 5).

    ================================================================
    DIRECTION (docs/BRIEF_REVE_GARDEVOIR.md + docs/CARTE_BLANCHE_CUTSCENES.md)
    ================================================================
    Reconstruction ENTIERE de l'ancien rêve sur écran noir (section 10 de
    CampNightfall, démolie). Règle 6 du mode opératoire : le héros dort
    et rêve — il est PHYSIQUEMENT présent, au centre du rêve.

      * lieu : la Source Lumière revisitée en rêve (clone de
        luminous_spring, mesurée au pixel — docs/CONCEPTION_songe_source.md) ;
        le héros y est allé au chapitre 2 (luminous_spring_ch_2), c'est un
        souvenir, pas une carte inconnue ;
      * ciel : dream parallax du test de personnalité (configuration copiée
        de personality_test.rsground) qui défile sans fin autour de la
        clairière, dans tout le vide de la map ;
      * musique : celle du test de personnalité
        ('Welcome to the World of Pokémon!.ogg', personality_test/init.lua:141).
        Elle ENTRE DANS LE NOIR, avant l'image — le son, puis l'image,
        puis le mot ;
      * apparition de Gardevoir : silence temporaire, pulsations de lumière
        de la source, brume + vent d'argent (signature spectrale attestée de
        BossFX.EmergeMist), puis SCINTILLEMENT PROGRESSIF du sprite (3
        battements décroissants au son de cristal), jamais instantané ;
      * dialogue héros ↔ Gardevoir APRÈS stabilisation : douce, mystérieuse,
        ancienne — speaker anonyme E040 (c'est la Voix qui prend corps ;
        elle ne se nomme pas). Le héros porte surprise, peur, curiosité,
        émerveillement ;
      * elle s'efface en battements inverses, comme elle est venue.

    Continuité narrative : ses répliques remettent en scène les anciens
    textes de la Voix du rêve noir (clés supprimées des resx de l'entrée,
    reprises dans REVE5_003/008/010/011/013) — mêmes mots, même
    « petit écho », mais incarnés.

    COMPOSITION (mesurée sur docs/renders/luminous_spring.png)
      * clairière : y 310-525 ; rive sableuse au bord de la source : y 285-305 ;
      * glow de la source : ~(390,205) ; axe unique source/elle/héros en x=390 ;
      * caméras : veille (390,315) — le halo de la source entre dans le
        plan d'intro (205 > 315-120=195) ; la caméra accompagne la marche
        jusqu'à (390,300) ; apparition (390,285) ; dialogue (390,315) ;
        dissolution (390,330) — la source et les deux personnages restent
        cadrés à chaque beat (pas d'action hors champ), conformes à la DA
        de docs/CONCEPTION_songe_source.md.

    REGLES DU PROJET RESPECTEES
      * Speaker anonyme E040 (deux backslashes dans la source, patron
        VoiceVisions) ; aucun nom interdit affiché.
      * Textes en strings.resx / strings.fr.resx (cles REVE5_*), rien en dur.
      * Tout sous pcall, sortie GARANTIE hors du pcall : jamais de carte
        sans sortie (filet = init.PlotScripting, patron personality_test).
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.VoiceVisions'

songe_source_ch_5 = {}

function songe_source_ch_5.PlayDream()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local tm2, tm3 = nil, nil
	pcall(function() tm2 = CH('Teammate2') end)
	pcall(function() tm3 = CH('Teammate3') end)

	--Les petales flottent en permanence : points fixes (deterministe),
	--arret propre par drapeau, patron 'stopTalking' du Tunnel.
	local stopPetales = false

	local ok, err = pcall(function()
		GAME:CutsceneMode(true)
		if partner ~= nil then AI:DisableCharacterAI(partner) end
		SOUND:StopBGM()
		GAME:FadeOut(false, 1)

		--Le heros reve SEUL : le partenaire et les coequipiers n'ont pas
		--franchi le seuil (ils existent sur la carte, on les masque).
		for _, c in ipairs({partner, tm2, tm3}) do
			if c ~= nil then pcall(function() GROUND:Hide(c.EntName) end) end
		end

		--Elle est posee sur la rive, invisible : creation cachee, jamais
		--un sprite simplement pose (battements plus bas).
		local elle = CharacterEssentials.MakeCharactersFromList({
			{'Gardevoir', 390, 297, Direction.Down} })
		GROUND:Hide(elle.EntName)

		--Le heros, endormi, au centre de la clairiere. Camera d'intro en
		--(390,315) : le halo de la source (y~205) ENTRE dans le plan de
		--decouverte (bord haut 195) ET les pieds du heros restent cadres
		--(bord bas 435, marge 5 px) — alignement sur la DA du doc de
		--conception (l'ancienne 360 rognait la source du premier plan).
		GROUND:TeleportTo(hero, 390, 430, Direction.Up)
		GROUND:CharSetAnim(hero, "EventSleep", true)
		GAME:MoveCamera(390, 315, 1, false)

		--Les petales du songe, suspendus au-dessus de la prairie.
		local coroP = TASK:BranchCoroutine(function()
			local spots = {{330, 360}, {430, 340}, {370, 420}, {450, 380}, {340, 320}}
			local i = 0
			while not stopPetales do
				i = i % #spots + 1
				pcall(function() BossFX.Particle('Sakura_Fall', spots[i][1], spots[i][2], 4) end)
				GAME:WaitFrames(64)
			end
		end)

		--LA MUSIQUE ENTRE DANS LE NOIR. Le son, puis l'image, puis le mot.
		SOUND:PlayBGM('Welcome to the World of Pokémon!.ogg', true)
		GAME:WaitFrames(90)

		--Deux voix seulement : la sienne (anonyme E040, c'est la Voix qui
		--prend corps) et les pensees du heros (pattern du camp, MWE5_085).
		local function elle_dit(key)
			UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
		end
		local function pensee(key, emotion)
			UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
			if emotion ~= nil then UI:SetSpeakerEmotion(emotion) end
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
			UI:ResetSpeaker()
		end

		---------------------------------------------------------------
		-- ACTE 1 — L'EVEIL DANS LE SONGE (introduction : le lieu, l'immensite)
		---------------------------------------------------------------
		GAME:FadeIn(100)
		GAME:WaitFrames(60)
		GeneralFunctions.Shake(hero)
		GAME:WaitFrames(12)
		GeneralFunctions.DoAnimation(hero, 'Wake')
		GAME:WaitFrames(24)
		GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Up)
		GAME:WaitFrames(10)
		pensee('REVE5_001', 'Worried')
		GAME:WaitFrames(18)

		--Attire par la lueur : quelques pas vers la source, puis l'arret.
		--C'est son SEUL trajet libre : il reconnait l'endroit. La camera
		--accompagne la marche (315 -> 300) : elle aussi est attiree.
		local coro1 = TASK:BranchCoroutine(function()
			GROUND:MoveToPosition(hero, 390, 382, false, 1)
		end)
		local coro2 = TASK:BranchCoroutine(function()
			GAME:MoveCamera(390, 300, 60, false)
		end)
		TASK:JoinCoroutines({coro1, coro2})
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
		GAME:WaitFrames(10)
		pensee('REVE5_002', 'Worried')
		GAME:WaitFrames(30)

		---------------------------------------------------------------
		-- ACTE 2 — L'APPARITION (silence temporaire, lumiere etrange,
		-- scintillement progressif — jamais instantane)
		---------------------------------------------------------------
		--La musique se retire : le silence est l'effet. La camera est
		--attiree vers la rive (300 -> 285) : elle aussi retient son souffle.
		SOUND:FadeOutBGM(120)
		GAME:MoveCamera(390, 285, 110, false)
		GAME:WaitFrames(110)

		--La source pulse deux fois : quelque chose la traverse.
		pcall(function() SOUND:PlayBattleSE('DUN_Power_Gem') end)
		pcall(function() BossFX.Flash(390, 205, 26, 34, 46) end)
		GAME:WaitFrames(80)
		pcall(function() SOUND:PlayBattleSE('DUN_Power_Gem') end)
		pcall(function() BossFX.Flash(390, 240, 20, 26, 40) end)
		GAME:WaitFrames(60)

		--Brume et vent d'argent : la matiere du reve se rassemble.
		--Signature spectrale attestee de BossFX (EmergeMist) — appelee
		--SANS cible : l'apparition du sprite reste sous notre controle
		--(scintillement progressif, ci-dessous).
		pcall(function() BossFX.EmergeMist(nil, 0, 0) end)
		GAME:WaitFrames(20)

		--LE SCINTILLEMENT : trois battements decroissants, le son de cristal
		--a chaque apparition. Elle se stabilise AU TROISIEME, pas avant.
		local battements = {{6, 20}, {10, 14}, {16, 10}}
		for i, b in ipairs(battements) do
			GROUND:Unhide(elle.EntName)
			pcall(function() SOUND:PlayBattleSE('DUN_Power_Gem') end)
			GAME:WaitFrames(b[1])
			if i < #battements then
				GROUND:Hide(elle.EntName)
				GAME:WaitFrames(b[2])
			end
		end
		pcall(function() BossFX.Flash(390, 297, 14, 18, 34) end)
		GROUND:CharSetEmote(elle, "glowing", 1)
		GAME:WaitFrames(24)

		--Elle est la. Le dialogue ne commence QU'APRES la stabilisation.
		elle_dit('REVE5_003')
		GAME:WaitFrames(25)

		---------------------------------------------------------------
		-- ACTE 3 — LE DIALOGUE (montee emotionnelle, rapprochement)
		---------------------------------------------------------------
		--La musique revient, douce : le silence n'etait que pour elle.
		SOUND:PlayBGM('Welcome to the World of Pokémon!.ogg', true)
		GAME:MoveCamera(390, 315, 70, false)

		--Le choc : il la reconnait. La voix a un visage.
		pcall(function() SOUND:PlayBattleSE('EVT_Emote_Startled') end)
		GROUND:CharSetEmote(hero, "shock", 1)
		GAME:WaitFrames(16)
		pensee('REVE5_004', 'Shouting')
		GAME:WaitFrames(15)

		--Elle apaise : douceur ancienne, pas d'explication.
		elle_dit('REVE5_005')
		GAME:WaitFrames(18)

		--Il s'approche de deux pas : attire, plus effraye. Justification
		--narrative du deplacement — et elle l'accueille en se tournant
		--pleinement vers lui.
		GROUND:MoveToPosition(hero, 390, 350, false, 1)
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 2)
		GROUND:CharTurnToCharAnimated(elle, hero, 2)
		GAME:WaitFrames(12)
		pensee('REVE5_006', 'Worried')
		GAME:WaitFrames(12)
		elle_dit('REVE5_007')
		GAME:WaitFrames(30)

		---------------------------------------------------------------
		-- ACTE 4 — LA REVELATION (le moment fort)
		---------------------------------------------------------------
		--Silence mesure : la phrase arrive apres le calme, pas dedans.
		elle_dit('REVE5_008')
		GAME:WaitFrames(15)

		--Le vertige : ses mots le traversent physiquement (bareme 1,
		--sans voile — la montagne « appuie », bareme NAUSEA verifie).
		--La source pulse fort, en echo a « tu l'as deja vue bruler ».
		pcall(function() VoiceVisions.Nausea(hero, 1) end)
		pcall(function() BossFX.Flash(390, 205, 30, 40, 60) end)
		GAME:WaitFrames(20)
		pcall(function() VoiceVisions.Recover(hero) end)
		pensee('REVE5_009', 'Shouting')
		GAME:WaitFrames(18)
		elle_dit('REVE5_010')
		GAME:WaitFrames(30)

		---------------------------------------------------------------
		-- ACTE 5 — LA DISSOLUTION (conclusion)
		---------------------------------------------------------------
		SOUND:FadeOutBGM(150)
		GAME:MoveCamera(390, 330, 120, false)
		GAME:WaitFrames(20)
		elle_dit('REVE5_011')
		GAME:WaitFrames(12)

		--Il proteste : il veut comprendre. C'est sa premiere COLERE du reve.
		GROUND:CharSetEmote(hero, "exclaim", 1)
		pensee('REVE5_012', 'Shouting')
		GAME:WaitFrames(10)

		--Sa derniere reponse, donnee pendant que le reve la reprend.
		elle_dit('REVE5_013')
		--Battements inverses : elle s'estompe comme elle est venue.
		local estompe = {{16, 8}, {10, 12}, {6, 18}}
		for i, b in ipairs(estompe) do
			GAME:WaitFrames(b[1])
			GROUND:Hide(elle.EntName)
			GAME:WaitFrames(b[2])
			if i < #estompe then
				GROUND:Unhide(elle.EntName)
				pcall(function() SOUND:PlayBattleSE('DUN_Power_Gem') end)
			end
		end
		--La brume reprend ce qui lui revenait (meme signature spectrale).
		pcall(function() BossFX.EmergeMist(nil, 0, 0) end)
		GAME:WaitFrames(40)

		--Elle n'est plus la. Le songe s'effrite autour de lui :
		--la nausee reprend (bareme 2, voile des Cris Temporels).
		GAME:WaitFrames(30)
		pcall(function() VoiceVisions.Nausea(hero, 2) end)
		pcall(function() VoiceVisions.Recover(hero) end)
		GAME:WaitFrames(20)
		GAME:FadeOut(false, 90)
		GAME:WaitFrames(90)
	end)

	if not ok then PrintInfo('[Songe] scene ecourtee : '..tostring(err)) end

	--SORTIE GARANTIE, hors du pcall : jamais de joueur sur un ecran noir.
	stopPetales = true
	pcall(function()
		UI:ResetSpeaker()
		GAME:FadeOut(false, 90)
		GAME:WaitFrames(100)
	end)
	SV.Chapter5.MountDreamPending = false
	SV.Chapter5.MountDreamDone = true
	pcall(function() GAME:CutsceneMode(false) end)
	GAME:EnterGroundMap('mount_windswept_entrance', 'Main_Entrance_Marker')
end

return songe_source_ch_5
