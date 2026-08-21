-- Chapter 6 guild life: contextual preparation, return and aftermath dialogue.
require 'origin.common'
require 'halcyon.GeneralFunctions'
local Lifecycle = require 'halcyon.SinisterWoodsLifecycle'
guild_second_floor_ch_6 = {}

local function line(chara, before, during, after)
  local phase=Lifecycle.Phase(); local text=before
  if phase=='exploration' or phase=='checkpoint' or phase=='retry' then text=during
  elseif phase=='guild_report' or phase=='bedtime' or phase=='guild_routine' or phase=='town_consequences' then text=after end
  GeneralFunctions.StartConversation(chara,text,'Normal'); GeneralFunctions.EndConversation(chara)
end
function guild_second_floor_ch_6.SetupGround() GAME:FadeIn(20) end
function guild_second_floor_ch_6.Briefing()
  local s=Lifecycle.Ensure(); if s.BriefingSeen then return false end
  s.BriefingSeen=true; GAME:CutsceneMode(true); GAME:FadeIn(20)
  local noctowl=CH('Noctowl'); local partner=CH('Teammate1')
  if noctowl then UI:SetSpeaker(noctowl); UI:WaitShowDialogue('La mission de la Forêt Sinistre est prioritaire.[pause=20] Préparez vos objets et parlez à la guilde avant le départ.') end
  if partner then UI:SetSpeaker(partner); UI:WaitShowDialogue('On vérifie notre sac, on écoute les conseils de tout le monde,[pause=15] puis on part ensemble.') end
  GAME:CutsceneMode(false); return true
end
local names={'Cleffa','Aggron','Zigzagoon','Audino','Marill','Spheal','Jigglypuff','Cranidos','Mareep','Snubbull','Seviper','Zangoose','Bagon','Doduo','Noctowl','Camerupt','Metapod','Silcoon','Roselia','Ludicolo','Spinda'}
for _,name in ipairs(names) do
  guild_second_floor_ch_6[name..'_Action']=function(chara,activator)
    line(chara,
      'La Forêt Sinistre ne pardonne pas l’improvisation.[pause=15] Préparez-vous avant de partir.',
      'Vous voilà revenus.[pause=15] Reprenez votre souffle et adaptez votre équipement avant une nouvelle tentative.',
      'Toute la guilde parle de votre retour de la Forêt Sinistre.[pause=15] Ce soir, reposez-vous vraiment.')
  end
end
return guild_second_floor_ch_6
