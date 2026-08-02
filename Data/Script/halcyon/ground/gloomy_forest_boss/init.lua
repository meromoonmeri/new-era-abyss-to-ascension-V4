require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ReplayEnding'
require 'halcyon.DazzlingArc'
require 'halcyon.ground.gloomy_forest_boss.gloomy_forest_boss_ch_6'

local gloomy_forest_boss = {}

function gloomy_forest_boss.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_gloomy_forest_boss <<=')
	COMMON.RespawnAllies(true)
	PartnerEssentials.InitializePartnerSpawn()
end

function gloomy_forest_boss.Enter(map)
	gloomy_forest_boss.PlotScripting()
end

function gloomy_forest_boss.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	gloomy_forest_boss.PlotScripting()
end

function gloomy_forest_boss.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function gloomy_forest_boss.PlotScripting()
	-- L'Epreuve des Trois : on arrive ici depuis le relais, apres avoir
	-- accepte le defi d'Adagio. Ce test passe AVANT la rejouabilite et
	-- avant Zeraora — la clairiere sert alors de terrain de duel, pas
	-- d'arene de boss.
	if SV.Chapter6.DazzlingTrialOffered and not SV.Chapter6.DazzlingTrialCleared
	   and SV.Chapter6.DefeatedGloomyBoss then
		DazzlingArc.TrialIntro()
		GAME:ContinueDungeon("gloomy_forest", 7, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
		return
	end

	-- Rejouabilite : Zeraora a ete vaincu, la clairiere est vide. La revanche
	-- volontaire passe par le segment 5 (zone-amie « Serment Verdoyant » achetee
	-- chez Grodoudou), pas par ce ground.
	if ReplayEnding.IsReplay('gloomy_forest', 6) then
		ReplayEnding.EmptyArena({
			--Coordonnees recalees sur la carte repeinte (360x312). Les
			--anciennes (y=340) etaient HORS CARTE depuis la conversion.
			hero = {184, 272}, partner = {160, 272},
			camera = {176, 250}, look = {176, 176},
			walk = 40, title = true, music = 'Mystifying Forest.ogg',
			lines = {
				{ spk='partner', emo='Normal', key='GF6B_R01', wait=10 },
				{ spk='hero',    emo='Normal', key='GF6B_R02', wait=10 },
				{ spk='partner', emo='Happy',  key='GF6B_R03' },
				{ spk='narrator',              key='GF6B_R04' },
			},
		})
		return
	end
	if SV.ChapterProgression.Chapter == 6 and not SV.Chapter6.GloomyBossEncountered then
		gloomy_forest_boss_ch_6.FirstBossScene()
	elseif SV.ChapterProgression.Chapter == 6 and not SV.Chapter6.DefeatedGloomyBoss then
		--Le joueur revient apres avoir perdu contre Zeraora : GloomyBossEncountered est
		--deja vrai, donc la premiere scene ne rejouera pas. Sans cette branche la carte
		--n'a aucune sortie et le joueur reste bloque. On relance directement le combat.
		GAME:FadeIn(20)
		GAME:WaitFrames(20)
		COMMON.BossTransition()
		GAME:CutsceneMode(false)
		-- Segment 4 : l'arene de Zeraora (decalee de 2 -> 4 par le mini-boss).
		GAME:ContinueDungeon("gloomy_forest", 4, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	else
		GAME:FadeIn(20)
	end
end

function gloomy_forest_boss.Teammate1_Action(chara, activator)
	PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

--Renomme avec l'espece : le handler doit porter le nom de l'entite
--posee par MakeCharactersFromList, sinon l'interaction est muette.
function gloomy_forest_boss.Zeraora_Action(chara, activator)
	COMMON.GroundInteract(activator, chara, true)
end

return gloomy_forest_boss
