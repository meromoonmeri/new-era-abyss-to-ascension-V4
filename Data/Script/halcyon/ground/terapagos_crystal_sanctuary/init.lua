require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'
local M={}
local function say(c,emotion,text)
 UI:SetSpeaker(c);GeneralFunctions.SetEmotion(emotion or 'Normal');UI:WaitShowDialogue(text)
end
local function pause(n) UI:ResetSpeaker();GAME:WaitFrames(n or 20) end
local function face(c,t) if c and t then pcall(function() GROUND:CharTurnToCharAnimated(c,t,4) end) end end
local function emote(c,e) if c then pcall(function() GROUND:CharSetEmote(c,e,1) end) end end
local function crystal_aura(x,y)
 local ring={{0,-36},{18,-30},{32,-18},{38,0},{32,18},{18,30},{0,36},{-18,30},{-32,18},{-38,0},{-32,-18},{-18,-30}}
 for _,p in ipairs(ring) do BossFX.Particle('Power_Gem_Charge',x+p[1],y+p[2],3,DrawLayer.Front);GAME:WaitFrames(3) end
 BossFX.Particle('Wave_Circle_Blue',x,y+6,3,DrawLayer.Front);GAME:WaitFrames(8)
 BossFX.Particle('Power_Gem_Charge',x,y,2,DrawLayer.Top)
end
function M.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies(true);PartnerEssentials.InitializePartnerSpawn() end
function M.Enter(map)
 SV.TerapagosSanctuary=SV.TerapagosSanctuary or {}
 local hero,partner=CH('PLAYER'),CH('Teammate1');GAME:CutsceneMode(true)
 GROUND:TeleportTo(hero,300,535,Direction.Up);if partner then GROUND:TeleportTo(partner,366,535,Direction.Up) end
 -- PMDO 0.8.12 ne contient pas l'index Monster 'terapagos'. L'utiliser
 -- fait crasher DrawGame à chaque frame. Diancie sert uniquement de proxy
 -- graphique compatible jusqu'à l'import d'un véritable package Terapagos.
 local mon=RogueEssence.Dungeon.MonsterID('diancie',0,'normal',Gender.Genderless)
 local boss=RogueEssence.Ground.GroundChar(mon,RogueElements.Loc(333,310),Direction.Down,'Terapagos','Terapagos');boss:ReloadEvents();GAME:GetCurrentGround():AddTempChar(boss)
 GAME:MoveCamera(333,350,1,false);GAME:FadeIn(30);GAME:WaitFrames(30)
 local aura=TASK:BranchCoroutine(function() crystal_aura(333,310) end)
 local a=TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero,307,397,false,1) end)
 local b=TASK:BranchCoroutine(function() if partner then GROUND:MoveToPosition(partner,360,397,false,1) end end)
 TASK:JoinCoroutines({a,b,aura});face(hero,boss);face(partner,boss);emote(boss,'notice');GAME:WaitFrames(20)
 if SV.TerapagosSanctuary.IntroSeen then
  say(boss,'Determined','Votre résonance est revenue.[pause=15] Cette fois, les cristaux ne détourneront pas mon jugement.')
 else
  SV.TerapagosSanctuary.IntroSeen=true
  GAME:MoveCamera(333,320,35,false)
  say(boss,'Normal','Le cristal conserve chaque lumière…[pause=18] et chaque promesse.')
  pause(18);BossFX.Particle('Wave_Circle_Blue',333,316,4,DrawLayer.Front)
  say(boss,'Normal','Ce sanctuaire est mon second domaine.[pause=15] Un refuge que je rejoins lorsque mon éclat s’amenuise.')
  say(boss,'Worried','Je suis venu m’y ressourcer.[pause=15] Mais les cristaux m’ont montré autre chose que le repos.')
  pause(22);emote(partner,'notice');face(partner,boss)
  say(boss,'Worried','Des incendies sous la terre.[pause=12] Des vents arrachés à leur cours.[pause=12] Des forêts qui répondent à une pulsation étrangère.')
  say(boss,'Normal','Chaque catastrophe laisse une empreinte.[pause=15] Chaque empreinte traverse la mémoire minérale de ce lieu.')
  GAME:MoveCamera(333,360,30,false);emote(boss,'exclaim')
  say(boss,'Determined','Et au bord de chacune d’elles…[pause=20] les cristaux me montrent vos deux silhouettes.')
  if partner then
   emote(partner,'shock');GAME:WaitFrames(12);say(partner,'Surprised','Nous ?![pause=12] Non, attends—[pause=8] enfin… oui, on était bien là, mais pas comme responsables !')
   say(partner,'Worried','On était au Tunnel Incandescent quand la chaleur s’est emballée…[pause=10] et au Mont Venteux quand le ciel a déraillé…')
   say(partner,'Worried','Et près des Ruines quand le sol a tremblé.[pause=20] Dit comme ça, je reconnais que ça sonne vraiment mal.')
  end
  pause(16);face(boss,partner);emote(boss,'notice')
  say(boss,'Normal','Vous confirmez donc votre présence sur chaque site.')
  if partner then
   emote(partner,'sweatdrop');say(partner,'Pain','Je viens exactement de nous rendre suspects, pas vrai ?')
   GROUND:CharTurnToCharAnimated(partner,hero,4);GAME:WaitFrames(12)
   say(partner,'Worried','Aide-moi…[pause=10] Je crois que chaque réponse que je donne creuse notre propre dossier.')
  end
  face(boss,hero);GAME:MoveCamera(320,382,25,false);emote(hero,'sweatdrop')
  UI:BeginChoiceMenu('Comment répondre à l’accusation de Terapagos ?',{'Montrer les traces recueillies','Expliquer que vous poursuivez la cause','Refuser de céder sous l’accusation'},1,3)
  UI:WaitForChoice();local choice=UI:ChoiceResult() or 1
  GROUND:CharSetAnim(hero,'Idle',true)
  if choice==1 then
   GeneralFunctions.HeroDialogue(hero,'(Les traces précèdent toujours notre arrivée. Les cristaux peuvent-elles en comparer l’âge ?)','Determined')
   if partner then emote(partner,'notice');say(partner,'Inspired','Oui ! Les marques étaient déjà là quand nous sommes arrivés. Tu peux vérifier leur ordre dans la pierre !') end
   say(boss,'Normal','Une défense fondée sur la chronologie.[pause=15] Précise… et vérifiable.')
  elseif choice==2 then
   GeneralFunctions.HeroDialogue(hero,'(Nous ne suivons pas les catastrophes pour les provoquer. Nous cherchons la chose qui les relie.)','Worried')
   if partner then say(partner,'Determined','On arrive après le premier signal, à chaque fois. On essaie d’empêcher le suivant.') end
   say(boss,'Normal','Vous vous présentez comme poursuivants, non comme origine.')
  else
   GeneralFunctions.HeroDialogue(hero,'(Je ne peux pas prouver notre innocence par des mots. Mais je refuse de laisser cette accusation arrêter notre enquête.)','Determined')
   if partner then emote(partner,'shock');say(partner,'Determined','C’est… plus direct que ma méthode.[pause=10] Et probablement beaucoup moins suspect.') end
   say(boss,'Determined','Une réponse sans détour.[pause=12] Elle demande pourtant une preuve.')
  end
  pause(20);GAME:MoveCamera(333,340,35,false);face(partner,boss);face(hero,boss)
  say(boss,'Worried','J’ai interrogé longtemps la mémoire de ce sanctuaire.[pause=15] Elle ne vous montre jamais au commencement du désastre.')
  say(boss,'Normal','Mais elle vous montre toujours au point où son énergie change de direction.')
  if partner then emote(partner,'sweatdrop');say(partner,'Worried','Donc nous ne sommes peut-être pas coupables…[pause=12] seulement incroyablement doués pour nous trouver au pire endroit.') end
  say(boss,'Determined','L’enquête ne peut pas s’arrêter à une hypothèse.[pause=15] Je dois mesurer directement votre résonance.')
  say(boss,'Normal','Si elle porte la même fracture que les catastrophes,[pause=10] les cristaux la révéleront sous la pression.')

  -- Intervention de Spinda : organisateur officiel de l'expédition, mais son
  -- enthousiasme transforme une enquête tendue en intrusion diplomatique.
  SOUND:PlayBattleSE('EVT_Emote_Exclaim')
  UI:ResetSpeaker(false);UI:SetCenter(true);UI:WaitShowDialogue('Attendez ![pause=12] Au nom de la Fédération des Explorateurs !');UI:SetCenter(false);UI:ResetSpeaker()
  SV.TerapagosSanctuary.SpindaMet=true
  local sid=RogueEssence.Dungeon.MonsterID('spinda',0,'normal',Gender.Unknown)
  local spinda=RogueEssence.Ground.GroundChar(sid,RogueElements.Loc(320,535),Direction.Up,'Spinda','Terapagos_Spinda')
  spinda:ReloadEvents();GAME:GetCurrentGround():AddTempChar(spinda)
  GROUND:MoveToPosition(spinda,270,425,false,1.2);emote(spinda,'happy');face(hero,spinda);face(partner,spinda);face(boss,spinda)
  GAME:MoveCamera(300,385,30,false)
  say(spinda,'Inspired','Terapagos ![pause=15] Enfin ![pause=10] Je rêvais de cette rencontre depuis que la Fédération a confirmé l’existence du sanctuaire !')
  say(spinda,'Happy','Spinda, président du Café Spinda,[pause=8] haut représentant de la Fédération des Explorateurs,[pause=8] et organisateur officiel de cette expédition !')
  if partner then emote(partner,'sweatdrop');GROUND:CharTurnToCharAnimated(partner,hero,4);say(partner,'Pain','Il récite vraiment tous ses titres maintenant…') end
  emote(boss,'angry');BossFX.Particle('Power_Gem_Charge',333,310,2,DrawLayer.Top);GAME:MoveScreen(RogueEssence.Content.ScreenMover(0,4,20));GAME:WaitFrames(18)
  say(boss,'Angry','Vous avez organisé leur venue.[pause=15] Vous avez guidé mes suspects jusqu’au cœur de mon domaine pendant mon enquête.')
  emote(spinda,'shock');say(spinda,'Surprised','Suspects ?![pause=10] Eux ?[pause=10] Mais ce sont précisément les explorateurs que j’ai mandatés pour comprendre les catastrophes !')
  say(boss,'Angry','Vous présentez une autorisation après avoir franchi le seuil.[pause=12] Votre Fédération confond-elle toujours découverte et permission ?')
  emote(spinda,'sweatdrop');say(spinda,'Worried','Non.[pause=10] Enfin… pas quand le formulaire de premier contact est disponible.[pause=15] Ce qui, manifestement, n’était pas le cas ici.')
  if partner then say(partner,'Worried','Président…[pause=8] je crois que vous êtes en train d’aggraver notre dossier, vous aussi.') end
  GROUND:CharAnimateTurnTo(spinda,Direction.Up,4);say(spinda,'Determined','Alors j’assume ma part.[pause=12] Leur mission vient de moi. Leur enquête est légitime, et je répondrai de leur conduite devant la Fédération.')
  say(boss,'Determined','Votre rang ne change pas la mémoire des cristaux.[pause=12] Il ajoute seulement un témoin au verdict.')
  emote(spinda,'notice');say(spinda,'Normal','Très bien.[pause=10] Je resterai hors de l’arène.[pause=10] Mais je consignerai chaque détail historique de cette rencontre.')
  GROUND:MoveToPosition(spinda,250,475,false,1);GROUND:CharAnimateTurnTo(spinda,Direction.Up,4)
  GAME:MoveCamera(333,350,30,false);face(hero,boss);face(partner,boss)

  if partner then GROUND:CharTurnToCharAnimated(partner,hero,4);say(partner,'Worried','Il veut nous interroger en nous combattant.[pause=12] Pourquoi les Pokémon antiques choisissent-ils toujours cette méthode ?') end
  GeneralFunctions.HeroDialogue(hero,'(Parce qu’ici, les actes laissent une trace que les mots ne peuvent pas imiter.)','Determined')
  face(partner,boss);face(hero,boss);emote(boss,'exclaim');crystal_aura(333,310)
  say(boss,'Determined','Alors montrez-moi votre vérité.[pause=18] Le Sanctuaire Cristallin rendra son verdict.')
 end
 SV.TerapagosSanctuary.BattleStarted=true
 COMMON.BossTransition();GAME:CutsceneMode(false);GAME:ContinueDungeon('waterfall_pond',5,0,0,RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,false)
end
function M.Exit(map) end function M.Update(map,time) end
function M.GameSave(map) end
function M.GameLoad(map) GAME:CutsceneMode(false);GAME:FadeIn(20) end
return M
