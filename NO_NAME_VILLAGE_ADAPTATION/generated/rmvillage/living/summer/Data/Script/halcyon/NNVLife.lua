-- Native Pokémon life layer for rmvillage. Candidate until four-season runtime passes.
require 'origin.common'
require 'halcyon.LivingWorld'
require 'halcyon.TownLife'
require 'halcyon.TownPlace'
require 'halcyon.TownNight'
local Life={tick=0,phase=0}
Life.SOCIAL={
 NNV_Carpenter={role='charpentier',lines={"Je vérifie les charpentes avant que le vent se lève.","Le bois travaille différemment à chaque saison."}},
 NNV_Logger={role='bûcheron',lines={"Je ne coupe que les arbres marqués. La forêt doit pouvoir repousser.","Les sentiers sont encombrés après chaque tempête."}},
 NNV_Hunter={role='éclaireur',lines={"Je surveille les traces autour du village.","Les Pokémon sauvages changent de territoire avec les saisons."}},
 NNV_Herbalist={role='herboriste',lines={"Les plantes du sous-bois suffisent à soigner bien des blessures.","Certaines feuilles ne se récoltent qu'au lever du jour."}},
 NNV_Seamstress={role='couturière',lines={"Je répare les sacs avec des fibres de la forêt.","Le fil végétal résiste mieux quand l'air est humide."}},
}
local function numbered(prefix,count)local result={} for index=1,count do result[#result+1]=prefix..tostring(index) end return result end
Life.GROUPS={
 source_birds={names=numbered('NNV_SourceBird_',12),behavior='flying_social',radius=320},
 source_butterflies={names=numbered('NNV_SourceButterfly_',19),behavior='flying_social',radius=240},
 flock={names={'NNV_Wild_Fletchling_1','NNV_Wild_Fletchling_2'},behavior='timid',radius=96},
 colony_scatterbug={names={'NNV_Wild_Scatterbug_1','NNV_Wild_Scatterbug_2','NNV_Wild_Scatterbug_3'},behavior='timid',radius=72},
 colony_caterpie={names={'NNV_Wild_Caterpie_1','NNV_Wild_Caterpie_2'},behavior='timid',radius=72},
 drift={names={'NNV_Wild_Hoppip_1','NNV_Wild_Hoppip_2','NNV_Wild_Hoppip_3'},behavior='social',radius=112},
 patch={names={'NNV_Wild_Oddish_1','NNV_Wild_Oddish_2'},behavior='nocturnal',radius=64},
 territory={names={'NNV_Wild_Deerling_1'},behavior='territorial',radius=128},
}
local function distance(a,b)local dx=a.Position.X-b.Position.X;local dy=a.Position.Y-b.Position.Y;return math.sqrt(dx*dx+dy*dy) end
local function visible(name,value)if value then pcall(function()GROUND:Unhide(name)end)else pcall(function()GROUND:Hide(name)end)end end
function Life.Setup()
 local context=LivingWorld.Context('no_name_village','rmvillage');Life.context=context;Life.tick=0
 for name,_ in pairs(Life.SOCIAL) do local ch=CH(name);if ch then AI:SetCharacterAI(ch,'halcyon.ai.ground_default',RogueElements.Loc(ch.Position.X-32,ch.Position.Y-32),RogueElements.Loc(64,64),1,16,32,60,180);visible(name,context.Time~='night') end end
 for _,group in pairs(Life.GROUPS) do
  local first=CH(group.names[1]);if first then group.anchor=RogueElements.Loc(first.Position.X,first.Position.Y) end
  for _,name in ipairs(group.names) do local ch=CH(name);if ch and group.anchor then AI:SetCharacterAI(ch,'halcyon.ai.ground_default',RogueElements.Loc(group.anchor.X-group.radius,group.anchor.Y-group.radius),RogueElements.Loc(group.radius*2,group.radius*2),1,16,40,40,140) end end
 end
 for _,name in ipairs(Life.GROUPS.patch.names) do visible(name,context.Time=='night') end
 for _,name in ipairs(Life.GROUPS.flock.names) do visible(name,context.Time~='night') end
 return context
end
function Life.Update()
 Life.tick=Life.tick+1;if Life.tick%60~=0 then return end
 local hero=CH('PLAYER');if not hero then return end
 for _,group in pairs(Life.GROUPS) do
  for index,name in ipairs(group.names) do local ch=CH(name)
   if ch and distance(ch,hero)<96 then
    if group.behavior=='timid' then
     local dx=ch.Position.X-hero.Position.X;local dy=ch.Position.Y-hero.Position.Y;local mag=math.max(1,math.sqrt(dx*dx+dy*dy));local tx=ch.Position.X+math.floor(dx/mag*48);local ty=ch.Position.Y+math.floor(dy/mag*48)
     TASK:StartEntityTask(ch,function()GROUND:MoveToPosition(ch,tx,ty,false,2)end)
    elseif group.behavior=='territorial' then GROUND:EntTurn(ch,GAME:VectorToDirection(hero.Position.X-ch.Position.X,hero.Position.Y-ch.Position.Y)) end
   elseif ch and group.anchor and Life.tick%180==0 then
    local angle=((Life.phase+index)*2)%8;local offsets={{0,24},{16,16},{24,0},{16,-16},{0,-24},{-16,-16},{-24,0},{-16,16}};local o=offsets[angle+1]
    TASK:StartEntityTask(ch,function()GROUND:MoveToPosition(ch,group.anchor.X+o[1],group.anchor.Y+o[2],false,1)end)
   end
  end
 end
 if Life.tick%180==0 then Life.phase=(Life.phase+1)%8 end
end
function Life.Talk(name)local cfg=Life.SOCIAL[name];local ch=CH(name);if not cfg or not ch then return false end;UI:SetSpeaker(ch);UI:WaitShowDialogue(cfg.lines[(TownLife.Today()%#cfg.lines)+1]);return true end
function Life.WildTalk(name)
 local ch=CH(name);if not ch then return false end;local text="Le Pokémon sauvage vous observe, puis reprend son activité."
 for _,group in pairs(Life.GROUPS) do for _,member in ipairs(group.names) do if member==name then if group.behavior=='timid' then text="Le Pokémon sauvage recule et cherche son groupe." elseif group.behavior=='territorial' then text="Le Pokémon sauvage garde sa position et vous surveille." elseif group.behavior=='nocturnal' then text="Le Pokémon sauvage remue doucement parmi les herbes." elseif group.behavior=='flying_social' then text="Le Pokémon volant décrit un cercle avant de rejoindre les siens." end end end end
 UI:SetSpeaker(ch);UI:WaitShowDialogue(text);return true
end
return Life
