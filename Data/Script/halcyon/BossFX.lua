--[[
    BossFX.lua
    Bibliotheque d'effets pour les apparitions de boss.

    Toutes les animations referencees ici ont ete VERIFIEES comme existantes :
      - BGAnimData(nom)  -> attend un dossier Content/BG/<nom>.dir
      - AnimData(nom, t) -> attend un dossier Content/Particle/<nom>.dir
    Melanger les deux fait echouer l'effet en silence (aucune erreur Lua).

    API moteur utilisee :
      GROUND:PlayVFX(emitter, x, y)                 Screen Effects
      GROUND:MoveScreen(ScreenMover(min,max,duree)) tremblement d'ecran reel
      GROUND:CharSetDrawEffect(chara, DrawEffect.Trembling)
      RogueEssence.Ground.HopGroundAction(...)      recul/sursaut
]]--

require 'origin.common'

BossFX = {}

--------------------------------------------------------------------
-- Briques de base
--------------------------------------------------------------------

--Particule ponctuelle (Content/Particle). frames = duree d'une image.
function BossFX.Particle(anim, x, y, frames, layer)
    frames = frames or 3
    local e = RogueEssence.Content.SingleEmitter(
        RogueEssence.Content.AnimData(anim, frames))
    e.Layer = layer or DrawLayer.Front
    GROUND:PlayVFX(e, x, y)
end

--Nappe plein ecran (Content/BG) : brume, eclair, lumiere...
function BossFX.Overlay(anim, x, y, fadeIn, hold, fadeOut, layer, moveX, moveY)
    local o = RogueEssence.Content.FiniteOverlayEmitter()
    o.FadeIn = fadeIn or 10
    o.TotalTime = hold or 60
    o.FadeOut = fadeOut or 20
    o.Layer = layer or DrawLayer.Top
    o.RepeatX = true
    o.RepeatY = true
    if moveX or moveY then
        o.Movement = RogueElements.Loc(moveX or 0, moveY or 0)
    end
    o.Anim = RogueEssence.Content.BGAnimData(anim, 0)
    GROUND:PlayVFX(o, x or 0, y or 0)
    return o
end

--Flash blanc. "White" est un BG verifie present.
function BossFX.Flash(x, y, fadeIn, hold, fadeOut)
    local f = RogueEssence.Content.FlashEmitter()
    f.FadeInTime = fadeIn or 2
    f.HoldTime = hold or 4
    f.FadeOutTime = fadeOut or 24
    f.StartColor = Color(255, 255, 255, 0)
    f.Layer = DrawLayer.Top
    f.Anim = RogueEssence.Content.BGAnimData("White", 0)
    GROUND:PlayVFX(f, x, y)
    SOUND:PlayBattleSE("EVT_Battle_Flash")
end

--Tremblement d'ecran reel (et non un simple sursaut de sprite).
function BossFX.ShakeScreen(power, duration)
    power = power or 6
    duration = duration or 30
    GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, power, duration))
end

--------------------------------------------------------------------
-- Impact : le souffle repousse TOUT LE MONDE
--------------------------------------------------------------------

--Repousse un personnage : sursaut + tremblement + emote de choc.
function BossFX.Knockback(chara, height, duration, emote)
    if chara == nil then return end
    height = height or 10
    duration = duration or 12
    if emote ~= false then
        GROUND:CharSetEmote(chara, "shock", 1)
    end
    local animId = RogueEssence.Content.GraphicsManager.GetAnimIndex("Hurt")
    GROUND:CharSetAction(chara,
        RogueEssence.Ground.HopGroundAction(chara.Position, chara.Direction,
                                            animId, height, duration))
end

--Souffle d'impact complet : ecran + heros + partenaire + tous les allies
--presents (Teammate2/3 s'ils existent). C'est la difference avec l'ancien
--code, qui ne repoussait que le partenaire.
function BossFX.Impact(power, extras)
    power = power or 10
    BossFX.ShakeScreen(math.max(4, power // 2), 28)
    SOUND:PlayBattleSE("EVT_Emote_Startled")

    local targets = { CH('PLAYER'), CH('Teammate1') }
    --Les coequipiers 2 et 3 ne sont pas toujours sur la carte : on protege.
    for _, name in ipairs({ 'Teammate2', 'Teammate3' }) do
        local ok, c = pcall(function() return CH(name) end)
        if ok and c ~= nil then table.insert(targets, c) end
    end
    if extras ~= nil then
        for _, c in ipairs(extras) do table.insert(targets, c) end
    end

    for i, c in ipairs(targets) do
        local h = power
        if i > 2 then h = math.max(4, power - 4) end   --allies : recul moindre
        pcall(function() BossFX.Knockback(c, h, 12) end)
    end
    GAME:WaitFrames(16)
    for _, c in ipairs(targets) do
        pcall(function() GROUND:CharSetEmote(c, "", 0) end)
    end
end

--Grondement montant : le sol tremble avant que quoi que ce soit apparaisse.
function BossFX.Rumble(chars, cycles)
    cycles = cycles or 3
    for _ = 1, cycles do
        BossFX.ShakeScreen(3, 14)
        for _, c in ipairs(chars or {}) do
            pcall(function() GROUND:CharSetDrawEffect(c, DrawEffect.Trembling) end)
        end
        GAME:WaitFrames(14)
    end
    for _, c in ipairs(chars or {}) do
        pcall(function() GROUND:CharEndDrawEffect(c, DrawEffect.Trembling) end)
    end
end

--------------------------------------------------------------------
-- Signatures de type
-- Chaque fonction est la marque visuelle propre a un type. Aucune
-- apparition ne doit etre interchangeable avec celle d'un autre boss.
--------------------------------------------------------------------

--SOL : le sol se fissure, gerbes de terre, le Pokemon jaillit facon Fouille.
function BossFX.EmergeGround(chara, x, y)
    BossFX.Rumble({ CH('PLAYER'), CH('Teammate1') }, 3)
    BossFX.Particle("Dig", x, y, 3)
    SOUND:PlayBattleSE("DUN_Dig")
    GAME:WaitFrames(10)
    --gerbes de terre de part et d'autre
    BossFX.Particle("Mud", x - 20, y + 8, 3)
    BossFX.Particle("Mud", x + 20, y + 8, 3)
    BossFX.Particle("Earth_Power_Eruption", x, y, 2)
    BossFX.ShakeScreen(8, 24)
    if chara ~= nil then
        GROUND:Unhide(chara.EntName)
        --le boss surgit du sol : il monte depuis sous la surface
        GROUND:CharSetAction(chara, RogueEssence.Ground.HopGroundAction(
            chara.Position, chara.Direction,
            RogueEssence.Content.GraphicsManager.GetAnimIndex("Idle"), 24, 20))
    end
    GAME:WaitFrames(20)
    BossFX.Particle("Rock_Pieces", x, y + 10, 3)
end

--VOL : descente depuis les cieux, battements d'ailes, impact au sol.
function BossFX.DescendSky(chara, x, y, height)
    height = height or 160
    if chara == nil then return end
    GROUND:Unhide(chara.EntName)
    GROUND:TeleportTo(chara, x, y - height, Direction.Down)
    BossFX.Particle("Gust_Wind", x, y - height + 20, 3)
    SOUND:PlayBattleSE("DUN_Wind")
    --descente verticale reelle, pas une apparition sur place
    GROUND:MoveToPosition(chara, x, y, false, 6)
    BossFX.Particle("Feather", x - 16, y - 30, 4)
    BossFX.Particle("Feather", x + 16, y - 24, 4)
    --impact
    SOUND:PlayBattleSE("DUN_Rollout")
    BossFX.Particle("Rock_Slide_Front", x, y + 8, 3)
    BossFX.Flash(x, y)
    BossFX.Impact(12)
end

--FEU : vapeur sous pression puis emergence depuis la lave.
function BossFX.EmergeFire(chara, x, y)
    BossFX.Overlay("Heat_Wave", 0, 0, 20, 70, 25, DrawLayer.Bottom)
    SOUND:PlayBattleSE("DUN_Fire_Spin")
    BossFX.Particle("Lava_Plume_Smoke", x, y + 6, 4)
    GAME:WaitFrames(16)
    BossFX.Particle("Lava_Plume_Fire", x, y, 3)
    BossFX.Particle("Ember", x - 18, y, 4)
    BossFX.Particle("Ember", x + 18, y, 4)
    BossFX.ShakeScreen(6, 20)
    if chara ~= nil then
        GROUND:Unhide(chara.EntName)
        GROUND:CharSetAction(chara, RogueEssence.Ground.HopGroundAction(
            chara.Position, chara.Direction,
            RogueEssence.Content.GraphicsManager.GetAnimIndex("Idle"), 18, 18))
    end
    GAME:WaitFrames(18)
end

--TENEBRES / PLANTE : l'ombre s'etire, les lianes s'ecartent, le boss en sort.
function BossFX.EmergeShadow(chara, x, y)
    BossFX.Overlay("Ominous_Wind", 0, 0, 25, 80, 25, DrawLayer.Bottom)
    SOUND:PlayBattleSE("DUN_Shadow_Force")
    BossFX.Particle("Dark_Pulse_Particle", x, y + 4, 4)
    GAME:WaitFrames(14)
    --les lianes s'ecartent
    BossFX.Particle("Leaf_Storm_Leaf_Rotating", x - 22, y, 3)
    BossFX.Particle("Leaf_Storm_Leaf_Rotating", x + 22, y, 3)
    BossFX.Particle("Grass_Knot_Grass_Front", x, y + 8, 3)
    GAME:WaitFrames(10)
    BossFX.Particle("Shadow_Ball", x, y, 3)
    if chara ~= nil then
        GROUND:Unhide(chara.EntName)
        GROUND:CharSetEmote(chara, "angry", 1)
    end
    BossFX.ShakeScreen(7, 22)
    GAME:WaitFrames(16)
end

--ROCHE : eboulement, blocs qui degringolent.
function BossFX.RockFall(x, y)
    BossFX.Particle("Rock_Slide_Back", x - 30, y - 40, 3)
    BossFX.Particle("Rock_Slide_Front", x + 30, y - 30, 3)
    BossFX.Particle("Rock_Piece_Rotating", x, y - 10, 3)
    SOUND:PlayBattleSE("DUN_Rock_Slide")
    BossFX.ShakeScreen(9, 26)
end

--NORMAL / spectral : la brume se condense et la silhouette se materialise.
function BossFX.EmergeMist(chara, x, y)
    BossFX.Overlay("Fog", 0, 0, 30, 90, 30, DrawLayer.Bottom, -1, 0)
    SOUND:PlayBattleSE("DUN_Mist")
    GAME:WaitFrames(20)
    BossFX.Overlay("Silver_Wind", 0, 0, 12, 40, 18, DrawLayer.Top)
    if chara ~= nil then
        GROUND:Unhide(chara.EntName)
        GROUND:CharSetEmote(chara, "glowing", 1)
    end
    GAME:WaitFrames(16)
end

--EAU : clapotis anormal, gerbe d'eau, le boss jaillit de la surface.
--Sequence A.3 du cahier des charges : signal discret -> irruption -> recul du groupe.
function BossFX.EmergeWater(chara, x, y)
    --1. signal discret : rides a la surface, tension
    BossFX.Particle("Wave_Circle_Blue", x, y + 6, 4)
    SOUND:PlayBattleSE("DUN_Water_Sport")
    GAME:WaitFrames(30)
    BossFX.Particle("Wave_Circle_Blue", x, y + 6, 3)
    GAME:WaitFrames(20)
    --2. irruption : gerbe d'eau
    SOUND:PlayBattleSE("DUN_Surf")
    BossFX.Particle("Water_Spout_Up", x, y, 2)
    BossFX.Particle("Water_Spout_Splash", x - 16, y + 4, 3)
    BossFX.Particle("Water_Spout_Splash", x + 16, y + 4, 3)
    BossFX.ShakeScreen(7, 22)
    if chara ~= nil then
        GROUND:Unhide(chara.EntName)
        GROUND:CharSetAction(chara, RogueEssence.Ground.HopGroundAction(
            chara.Position, chara.Direction,
            RogueEssence.Content.GraphicsManager.GetAnimIndex("Idle"), 22, 20))
    end
    GAME:WaitFrames(14)
    BossFX.Particle("Water_Spout_Drop", x, y - 20, 3)
    BossFX.Particle("Bubbles_Blue", x, y + 8, 4)
end

--GLACE/CRISTAL : resonance cristalline, eclat de lumiere, activation.
--Style "ruines/temple" : pas de surgissement physique, une revelation par activation.
function BossFX.AwakenCrystal(chara, x, y)
    BossFX.Particle("Power_Gem_Charge", x, y, 4)
    SOUND:PlayBattleSE("DUN_Power_Gem")
    GAME:WaitFrames(24)
    BossFX.Particle("Flash_Cannon_Sparkle", x - 18, y - 8, 3)
    BossFX.Particle("Flash_Cannon_Sparkle", x + 18, y - 8, 3)
    GAME:WaitFrames(12)
    BossFX.Particle("Power_Gem_Hit", x, y, 2)
    if chara ~= nil then
        GROUND:Unhide(chara.EntName)
        GROUND:CharSetEmote(chara, "glowing", 1)
    end
    BossFX.ShakeScreen(5, 16)
    GAME:WaitFrames(16)
end

--Recul du groupe : onde de choc qui repousse les personnages (A.3 etape 3).
--Chaque membre est anime en "Hurt" dans la direction opposee au point d'emergence.
function BossFX.PushBack(chars, awayFromDir)
    for _, c in ipairs(chars) do
        if c ~= nil then
            GROUND:AnimateInDirection(c, "Hurt", c.Direction, awayFromDir, 8, 2, 1)
        end
    end
    GAME:WaitFrames(10)
end

--------------------------------------------------------------------
-- La Voix de l'Abysse : toujours AVANT l'apparition.
--------------------------------------------------------------------
-- Le heros est le SEUL a entendre cette voix, et l'entendre lui coute :
-- l'ecran tangue et il a un haut-le-coeur avant chaque phrase. Les autres
-- personnages presents ne reagissent pas — pour eux, il ne s'est rien passe.
-- Un seul point de passage ici couvre toutes les scenes de boss du mod.
function BossFX.Voice(key, mapStrings)
    pcall(function()
        local hero = CH('PLAYER')
        if hero ~= nil then
            GROUND:CharSetEmote(hero, "shock", 1)
            GROUND:CharSetAnim(hero, "Hurt", true)
        end
        -- Vertige : amplitude faible, duree longue. Ce n'est pas un choc,
        -- c'est un malaise.
        GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 5, 26))
        GAME:WaitFrames(26)
    end)

    SOUND:PlayBattleSE('EVT_Emote_Shock_2')
    UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "",
                  RogueEssence.Data.Gender.Unknown)
    UI:WaitShowDialogue(STRINGS:Format((mapStrings or STRINGS.MapStrings)[key]))

    pcall(function()
        local hero = CH('PLAYER')
        if hero ~= nil then
            GROUND:CharSetEmote(hero, "", 0)
            GROUND:CharSetAnim(hero, "Idle", true)
        end
    end)
end

return BossFX
