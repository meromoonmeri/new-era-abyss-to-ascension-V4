require 'origin.common'
require 'halcyon.CharacterEssentials'
require 'halcyon.GeneralFunctions'
local d06p03={}
function d06p03.Init(map) DEBUG.EnableDbgCoro(); COMMON.RespawnAllies(true) end
function d06p03.Enter(map)
  GAME:CutsceneMode(true)
  local hero,partner=CH('PLAYER'),CH('Teammate1')
  GROUND:TeleportTo(hero,288,336,Direction.Up)
  if partner then GROUND:TeleportTo(partner,256,336,Direction.Up) end
  GAME:MoveCamera(272,240,1,false)
  SOUND:PlayBGM('PMD Red EU - Mt Thunder Peak.ogg',true)
  GAME:FadeIn(30); GAME:WaitFrames(20)
  GAME:FadeOut(true,5); GAME:FadeIn(5); SOUND:PlayBattleSE('EVT_Thunder')
  GAME:WaitFrames(20); GAME:FadeOut(true,5); GAME:FadeIn(5)
  local zapdos=CharacterEssentials.MakeCharactersFromList({{'Zapdos',272,176,Direction.Down}})
  pcall(function() GROUND:CharSetAnim(zapdos,'Attack',false) end)
  SOUND:PlayBattleSE('EVT_Roar'); pcall(function() GAME:ScreenShake(4,4,20) end)
  UI:WaitShowTitle('Électhor — Gardien du Mont Foudre',20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
  UI:SetSpeaker(zapdos); GeneralFunctions.SetEmotion('Determined')
  UI:WaitShowDialogue('Qui ose pénétrer au cœur de l’orage ?')
  if partner then UI:SetSpeaker(partner); GeneralFunctions.SetEmotion('Determined'); UI:WaitShowDialogue('Nous sommes venus sauver Tengalice. Nous ne reculerons pas !') end
  COMMON.BossTransition()
  GAME:FadeOut(false,30); pcall(function() GAME:GetCurrentGround():RemoveTempChar(zapdos) end)
  GAME:CutsceneMode(false); SV.CanonicalDungeons.Pending=nil
  GAME:EnterDungeon('mt_thunder',3,0,0,RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,false)
end
function d06p03.Update(map) end
return d06p03
