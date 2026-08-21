require 'origin.common'
local d06p02={}
function d06p02.Init(map) DEBUG.EnableDbgCoro(); COMMON.RespawnAllies(true) end
function d06p02.Enter(map)
  GAME:CutsceneMode(true)
  local hero,partner=CH('PLAYER'),CH('Teammate1')
  GROUND:TeleportTo(hero,272,336,Direction.Up)
  if partner then GROUND:TeleportTo(partner,248,336,Direction.Up) end
  GAME:MoveCamera(272,280,1,false)
  SOUND:PlayBGM('PMD Red EU - Mt Thunder Peak.ogg',true)
  GAME:FadeIn(30); GAME:WaitFrames(20)
  UI:ResetSpeaker(false); UI:WaitShowDialogue('La foudre frappe sans relâche au-dessus du sommet...')
  if partner then UI:SetSpeaker(partner); UI:WaitShowDialogue('Électhor nous attend. Restons ensemble !') end
  GAME:FadeOut(false,30); GAME:CutsceneMode(false)
  SV.CanonicalDungeons.Pending=nil
  GAME:EnterDungeon('mt_thunder',2,0,0,RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,false)
end
function d06p02.Update(map) end
return d06p02
