-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V38P08A/n09a2213.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for object OBJECT_V38P08B1_502
    -- SetOutputAttribute(1024) [neutre/état moteur]
    -- MovePositionOffset OBJECT_V38P08B1_502 [cible sans placement SSA zone: déplacement non joué]
    -- SetPositionOffset(120, -400) [routine décor sans sujet résolu]
    -- MovePositionOffset OBJECT_V38P08B1_502 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 2 for object OBJECT_V38P08C2_505
    -- SetOutputAttribute(1024) [neutre/état moteur]
    -- MovePositionOffset OBJECT_V38P08C2_505 [cible sans placement SSA zone: déplacement non joué]
    -- SetAnimation(19) [anim idle native]
    GAME:WaitFrames(2) -- join WaitAnimation
    -- SetPositionOffset(0, -400) [routine décor sans sujet résolu]
    -- MovePositionOffset OBJECT_V38P08C2_505 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 3 for object OBJECT_V38P08C5_508
    -- SetOutputAttribute(1024) [neutre/état moteur]
    -- MovePositionOffset OBJECT_V38P08C5_508 [cible sans placement SSA zone: déplacement non joué]
    -- SetAnimation(21) [anim idle native]
    GAME:WaitFrames(2) -- join WaitAnimation
    -- SetPositionOffset(0, -400) [routine décor sans sujet résolu]
    -- MovePositionOffset OBJECT_V38P08C5_508 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 4 for object OBJECT_V38P08C3_506
    -- SetOutputAttribute(1024) [neutre/état moteur]
    GAME:WaitFrames(45)
    -- MovePositionOffset OBJECT_V38P08C3_506 [cible sans placement SSA zone: déplacement non joué]
    -- SetAnimation(19) [anim idle native]
    GAME:WaitFrames(2) -- join WaitAnimation
    -- SetPositionOffset(0, -400) [routine décor sans sujet résolu]
    -- MovePositionOffset OBJECT_V38P08C3_506 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 5 for object OBJECT_V38P08C4_507
    -- SetOutputAttribute(1024) [neutre/état moteur]
    GAME:WaitFrames(20)
    -- MovePositionOffset OBJECT_V38P08C4_507 [cible sans placement SSA zone: déplacement non joué]
    -- SetAnimation(21) [anim idle native]
    GAME:WaitFrames(2) -- join WaitAnimation
    -- SetPositionOffset(0, -400) [routine décor sans sujet résolu]
    -- MovePositionOffset OBJECT_V38P08C4_507 [cible sans placement SSA zone: déplacement non joué]
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 6 for object OBJECT_V38P08D4_513
    -- SetAnimation(2) [anim idle native]
    -- SetOutputAttribute(1024) [neutre/état moteur]
    -- @label_0 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    -- SlidePositionOffset OBJECT_V38P08D4_513 [cible sans placement SSA zone: déplacement non joué]
    -- SetPositionOffset(0, -400) [routine décor sans sujet résolu]
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  SkySceneKit.run_routine(function() -- def 7 for object OBJECT_V38P08D5_514
    -- SetAnimation(2) [anim idle native]
    -- SetOutputAttribute(1024) [neutre/état moteur]
    -- @label_1 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    -- SlidePositionOffset OBJECT_V38P08D5_514 [cible sans placement SSA zone: déplacement non joué]
    -- SetPositionOffset(0, -400) [routine décor sans sujet résolu]
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  SkySceneKit.run_routine(function() -- def 8 for object OBJECT_V38P08D1_510
    -- SetAnimation(2) [anim idle native]
    -- SetOutputAttribute(1024) [neutre/état moteur]
    GAME:WaitFrames(30)
    -- @label_2 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    -- SlidePositionOffset OBJECT_V38P08D1_510 [cible sans placement SSA zone: déplacement non joué]
    -- SetPositionOffset(0, -400) [routine décor sans sujet résolu]
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back_SetGround(LEVEL_V38P08A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '1', '0')
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  GAME:WaitFrames(1)
  GAME:FadeIn(30)
  -- MovePositionOffset<object OBJECT_V38P08C1_504> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V38P08C6_509> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V38P08D2_511> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V38P08B2_503> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V38P08A1_501> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V38P08D3_512> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V38P08D6_515> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(180)
  GAME:FadeOut(false, 30)
  -- camera_SetEffect(0): arrêt d'effet caméra
  SkySceneKit.join_routines()
end
