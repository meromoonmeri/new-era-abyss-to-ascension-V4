--[[
    HeroVisions.lua — Visions du passé du héros (Chapitres 1 à 6)
]]
require 'origin.common'
require 'halcyon.VoiceVisions'

HeroVisions = {}

HeroVisions.LIST = {
  ------------------------------------------------------------------
  -- 1. LA CHASSE — chapitre 3
  ------------------------------------------------------------------
  chasse = {
    ch = 3,
    music = 'Team Skull.ogg',
    level = 2,
    plates = {
      { bg='Wanted_Poster', hold=220, lines={
          "Une affiche, clouée sur un arbre.[pause=25] Un visage dessiné à la hâte.",
          "En dessous, un seul mot revient, écrit trop gros :[pause=20] COUPABLE." } },
      { bg='Chapter_3', hold=200, shake=5, lines={
          "Ils sont quatre à le poursuivre.[pause=20] Des secouristes. Les meilleurs de leur temps.",
          "Ils ne le haïssent pas.[pause=25] Ils croient sincèrement bien faire.[pause=20] C'est pire." } },
      { bg='Genesis_Fade', hold=180, lines={
          "Le fugitif ne se défend pas.[pause=25] Il court, et il pleure,[pause=15] et personne ne l'écoute." } },
    },
    lastWord = "« ...Ils ne m'ont jamais laissé m'expliquer. »",
    heroLine = "(Je ne connais pas ce visage.[pause=20] Alors pourquoi j'ai envie de courir ?)",
    witnessLine = "Hé...[pause=15] Tu es tout pâle.[pause=20] Tu t'es arrêté d'un coup, là.",
  },

  ------------------------------------------------------------------
  -- 2. LA METEORE — chapitre 5
  ------------------------------------------------------------------
  meteore = {
    ch = 5,
    music = 'Sky Tower.ogg',
    level = 3,
    plates = {
      { bg='Chapter_2', hold=200, lines={
          "Le ciel est rouge.[pause=25] Une pierre énorme descend, lentement, comme si elle avait tout son temps.",
          "En bas, un monde entier a cessé de respirer." } },
      { bg='Genesis_Void', hold=220, shake=9, lines={
          "Quelque chose monte à sa rencontre.[pause=20] Vert. Immense. Furieux.",
          "L'impact fait un bruit que personne n'oubliera.[pause=30] La pierre se fend en deux." } },
      { bg='Genesis_Fade', hold=180, lines={
          "Des éclats retombent en pluie de feu.[pause=25] Le monde est sauvé.[pause=20] Pour cette fois." } },
    },
    lastWord = "« ...Il a payé pour nous, et nous ne savons même pas son nom. »",
    heroLine = "(J'ai senti la chaleur.[pause=25] Sur ma peau. Maintenant. Comment c'est possible ?)",
    witnessLine = "Tu trembles...[pause=20] Tu veux qu'on s'arrête un moment ?",
  },
}

function HeroVisions.TryTrigger(id, witness)
  local v = HeroVisions.LIST[id]
  if v == nil then
    PrintInfo('[HeroVisions] vision inconnue : '..tostring(id))
    return false
  end
  if VoiceVisions.HasSeen(id) then return false end

  local chapter = 0
  pcall(function() chapter = SV.ChapterProgression.Chapter or 0 end)
  if chapter < v.ch then return false end

  return VoiceVisions.PlayOnce(id, {
    literal      = true,
    level        = v.level,
    music        = v.music,
    witness      = witness,
    plates       = v.plates,
    heroLine     = v.heroLine,
    lastWord     = v.lastWord,
    witnessLines = { v.witnessLine },
  })
end

function HeroVisions.Count()
  VoiceVisions.EnsureSV()
  return SV.Visions.Count or 0
end

return HeroVisions
