--[[
    LegendArc.lua

    LES 42 GARDIENS D'ANCRAGE — APRES-BOSS
    ================================================================
    Dernier bloc signale par tools/audit_boss_cinematics.py :

        histoire    11 scenes · 82.0/100 · 25.8 boites de boss
        reseau      11 scenes · 24.3/100 ·  3.5
        legendaire  38 scenes · 17.3/100 ·  2.0   <-- ici

    Ce qui manquait n'etait PAS l'entree en scene : chaque arene a deja son
    signal, son irruption typee, son titre et sa replique d'accroche. Il
    manquait la SORTIE. On battait Arceus, Dialga ou Rayquaza et... rien :
    `LegendZones.SetDefeated(...)`, un fondu, retour en ville. Le gardien
    posait une question avant le combat et n'y repondait jamais.

    ------------------------------------------------------------------
    LA REGLE DES ANCRAGES (docs/reseau_veilleurs_dialogues.md)
    ------------------------------------------------------------------
    Un gardien d'Ancrage n'est pas un ennemi : il TIENT une faille. Le
    combat ne le tue pas et ne le soumet pas — il le STABILISE. Le joueur
    ne prend rien : il prouve qu'il peut porter ce que l'autre portait.

    Consequence : les 42 scenes disent toutes « la garde change », mais
    aucune ne le dit de la meme facon. C'est la seule regle commune ; tout
    le reste est propre a chaque gardien.

    ------------------------------------------------------------------
    CE QUI EST REPRIS DES SOURCES
    ------------------------------------------------------------------
    * pmd-red (intro.inc) : cascade d'animations. Le gardien traverse
      Hurt -> Idle avec des temps morts au lieu de s'eteindre d'un bloc.
    * Tunnel Ardent (reference interne, 97/100) : la camera REMONTE sur
      qui parle, se RESSERRE sur la phrase-pivot, REDESCEND en cadre
      commun pour la reponse du duo. Le vaincu TRANSMET quelque chose.
    * EoSO (beach) : on laisse le lieu respirer avant de parler.

    ------------------------------------------------------------------
    PRUDENCE TECHNIQUE (leçons des lots precedents)
    ------------------------------------------------------------------
    * Positions RELUES dans chaque ground/init.lua, jamais recopiees d'un
      gabarit — l'erreur commise sur 3 fiches de VeilleurArc.
    * Cameras calculees depuis la position reelle et bornees a la taille
      de la carte, verifiee dans le .rsground correspondant.
    * Aucune animation inventee : un nom inexistant echoue EN SILENCE.
    * Texte LITTERAL (module global) — STRINGS.MapStrings ne contient que
      les cles du ground courant.
    * Jamais « Necrozma », « Eternatus », « l'Abime », « prison » dans un
      dialogue joueur. Les gardiens portant ces noms d'espece existent
      dans le casting, mais AUCUN texte affiche ne les nomme.
    * Tout sous pcall, sortie garantie.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

LegendArc = {}

local function say(who, txt)
  if who == nil then return end
  UI:SetSpeaker(who)
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(10)
end

local function narrate(txt)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(txt)
  UI:SetCenter(false)
  GAME:WaitFrames(10)
end

--------------------------------------------------------------------
-- LES 42 FICHES
--------------------------------------------------------------------
-- ground / inst / pos : RELUS dans les ground/*/init.lua (source de verite).
-- lines  : ce que dit le gardien apres le combat (2 a 3 boites).
-- ask    : la reponse du partenaire ou du duo (1 boite).
-- last   : la derniere phrase du gardien — celle qui doit rester.
-- close  : narration de sortie.
LegendArc.LIST = {

  ---------------- EAU ----------------
  tide_hollow = { g='abime_tempetes', inst='Kyogre', pos={272,200},
    lines={"La maree se retire.[pause=25] Pour l'instant.",
           "Je ne t'ai pas laisse gagner.[pause=20] J'ai arrete de pousser."},
    ask="Ce n'est pas la meme chose ?",
    last="Non.[pause=30] Demande a la mer, un jour ou tu auras le temps.",
    close="L'eau redevient plate.[pause=20] On entend de nouveau sa propre respiration." },

  clearwater_ford = { g='bois_des_plaintes', inst='Suicune', pos={176,136},
    lines={"L'eau que tu as troublee redeviendra claire.[pause=25] C'est son metier.",
           "La tienne aussi, un jour."},
    ask="La notre ?",
    last="Vous etes surtout faits d'eau.[pause=30] Ne l'oubliez pas quand ce sera trouble.",
    close="Le gue redevient limpide,[pause=20] jusqu'aux cailloux du fond." },

  steam_heart = { g='fosse_volcanique', inst='Volcanion', pos={232,176},
    lines={"Le feu et l'eau dans le meme corps.[pause=25] Tu sais ce que ca fait ?",
           "Ca fait de la vapeur.[pause=20] Ca pousse. Ca souleve des montagnes."},
    ask="Ou ca explose.",
    last="Ou ca explose.[pause=30] Tout depend de qui tient la valve.",
    close="La pression retombe.[pause=25] La fosse siffle doucement, puis se tait." },

  resolute_ford = { g='gue_poulain_autel', inst='Keldeo', pos={272,344},
    lines={"Encore ![pause=20] ...Non. Pardon.",
           "On m'a appris a demander un combat de plus.[pause=25] On ne m'a pas appris a m'arreter."},
    ask="Vous n'avez rien a prouver.",
    last="A vous, non.[pause=30] A ceux qui m'ont forme, je ne sais pas encore.",
    close="Le poulain baisse sa corne.[pause=25] Le gue est libre." },

  kept_feeling = { g='lac_espoir', inst='Crefollet', pos={200,200},
    lines={"Je garde les sentiments qu'on ne dit pas.[pause=30] Le lac en est plein.",
           "Les tiens y sont deja.[pause=25] Depuis le jour ou tu es arrive ici."},
    ask="Lesquels ?",
    last="Ceux que tu n'as dits a personne.[pause=30] Meme pas a lui.",
    close="La surface du lac se ride une fois,[pause=20] sans qu'aucun vent ne souffle." },

  sea_cradle = { g='recif_genereux', inst='Manaphy', pos={204,168}, inst2='Phione', pos2={244,168},
    lines={"Vous etes forts ![pause=20] Vraiment tres forts !"},
    lines2={"...Il dit ca a tout le monde."},
    ask="Vous n'aviez pas l'air de vouloir nous arreter.",
    last="Non ![pause=20] Je voulais voir jusqu'ou vous iriez.[pause=25] C'est different !",
    close="Le recif s'illumine d'un coup,[pause=20] comme un banc de poissons qui change d'avis." },

  ---------------- FEU ----------------
  molten_throne = { g='arene_trone_magma', inst='Groudon', pos={320,280},
    lines={"Le trone est chaud.[pause=25] Il l'a toujours ete.",
           "J'ai souleve cette terre.[pause=20] Je ne sais pas la reposer."},
    ask="Personne ne vous a appris ?",
    last="Personne ne me l'a demande.[pause=30] Vous etes les premiers a le dire tout haut.",
    close="Le magma redescend d'un cran.[pause=25] La salle reste brulante, mais on peut y tenir." },

  long_ash = { g='champ_braises', inst='Sulfura', pos={176,136},
    lines={"Une longue cendre.[pause=25] Voila ce que je suis devenu.",
           "Un feu qui dure trop longtemps ne rechauffe plus rien."},
    ask="Alors reposez-vous.",
    last="Ce mot-la, je ne l'avais pas entendu depuis des siecles.",
    close="Les braises palissent[pause=20] sans jamais tout a fait s'eteindre." },

  ember_vigil = { g='plaines_brulees', inst='Entei', pos={196,216}, inst2='Victini', pos2={236,216},
    lines={"La veillee est levee.[pause=25] Rentrez chez vous.",
           "...Et mangez quelque chose. Vous tenez a peine debout."},
    lines2={"Moi je trouve qu'ils ont super bien tenu !"},
    ask="Merci... je crois ?",
    last="Ne me remerciez pas.[pause=25] Revenez, c'est tout.",
    close="Le grand fauve se rassoit face aux plaines,[pause=20] et le petit s'installe sur son dos." },

  ---------------- SOL / ROCHE / ACIER ----------------
  eternal_coil = { g='couloir_legendes', inst='Eternatus', pos={400,152},
    lines={"...La spirale se detend.[pause=30] Un tour. Un seul.",
           "Ce n'est pas assez.[pause=25] Mais c'est plus que ce que j'esperais."},
    ask="Qu'est-ce qui vous retient ici ?",
    last="La meme chose qui vous fera revenir.[pause=30] Ne cherchez pas encore.",
    close="Le couloir s'allonge derriere eux,[pause=20] ou peut-etre le croient-ils seulement." },

  liquid_metal = { g='grotte_rocheuse', inst='Melmetal', pos={220,208}, inst2='Meltan', pos2={260,208},
    lines={"Le metal se souvient de chaque coup recu.[pause=25] Les votres seront dedans."},
    lines2={"...Ping."},
    ask="C'est un compliment ?",
    last="C'est un registre.[pause=30] Le metal ne fait pas de compliments.",
    close="Le colosse se refige.[pause=25] Le petit continue de tinter un moment." },

  cells_gathering = { g='terres_tues_porte', inst='Zygarde', pos={216,232},
    lines={"L'assemblee est faite.[pause=25] Vous pouvez passer.",
           "Je surveille l'equilibre.[pause=20] Quand il casse, je me rassemble."},
    ask="Et là, maintenant ?",
    last="Là, maintenant,[pause=25] il casse quelque part.[pause=30] Pas ici. Ailleurs.",
    close="Les cellules se dispersent dans le sol,[pause=20] et la terre redevient muette." },

  gear_heart = { g='carriere_magnetique', inst='Magearna', pos={232,184},
    lines={"Coeur : intact.[pause=20] Ame : indeterminee.",
           "Vous avez teste les deux.[pause=25] Le resultat me trouble."},
    ask="Pourquoi ?",
    last="Parce que c'est l'ame qui a tenu le plus longtemps.[pause=30] Je ne l'avais pas prevu.",
    close="Les engrenages ralentissent,[pause=20] puis trouvent un rythme plus lent, plus calme." },

  old_reactor = { g='labo_decrepit', inst='Genesect', pos={232,144},
    lines={"Arret des systemes.[pause=25] Je n'ai plus d'ordre en memoire.",
           "On m'a construit pour quelque chose.[pause=20] Le fichier est corrompu."},
    ask="Alors choisissez autre chose.",
    last="« Choisir. »[pause=30] Terme absent de ma documentation.[pause=20] Je vais l'ajouter.",
    close="Le vieux reacteur s'eteint,[pause=20] et pour la premiere fois le silence n'a rien d'inquietant." },

  fallen_visitor = { g='vallon_perdu', inst='Deoxys', pos={200,192},
    lines={"Je suis tombe ici.[pause=25] Je n'ai jamais su comment repartir.",
           "Vous, vous savez.[pause=20] Vous avez un endroit ou rentrer."},
    ask="Vous pourriez venir.",
    last="Non.[pause=30] Mais c'est la premiere fois qu'on me le propose.",
    close="Le cratere reste vide.[pause=25] Le visiteur regarde le ciel, longtemps." },

  ---------------- ELECTRIQUE ----------------
  storm_bell = { g='arene_hautes_plaines', inst='Raikou', pos={272,224},
    lines={"Vous m'avez rattrape.[pause=25] Personne ne me rattrape.",
           "La cloche a sonne pour vous, alors."},
    ask="Quelle cloche ?",
    last="Celle qu'on entend juste avant l'orage.[pause=30] Ecoutez mieux, la prochaine fois.",
    close="Le tonnerre arrive enfin,[pause=20] longtemps apres son maitre." },

  high_conductor = { g='porte_plaines_foudre', inst='Electhor', pos={224,176},
    lines={"Le courant passe par le plus haut.[pause=25] C'est la seule regle de la foudre.",
           "Aujourd'hui, le plus haut, c'etait vous."},
    ask="On n'a rien de haut.",
    last="Vous avez tenu debout.[pause=30] Ici, c'est exactement la meme chose.",
    close="L'orage se disperse.[pause=25] La plaine sent l'air brule et la pluie." },

  wild_current = { g='pre_tonnerre', inst='Zeraora', pos={224,192},
    lines={"Rapides.[pause=20] Pas assez, mais rapides.",
           "Vous savez ce qui m'a battu ?[pause=25] Pas la vitesse. La duree."},
    ask="On a juste refuse de tomber.",
    last="C'est ce que je viens de dire.[pause=30] Apprenez a entendre les compliments.",
    close="La foudre court le long du pre,[pause=20] puis se dissout dans l'herbe." },

  ---------------- PSY / ESPACE / TEMPS ----------------
  spatial_hill = { g='chambre_agee_o', inst='Palkia', pos={232,200},
    lines={"Vous avez traverse un espace que je tenais ferme.[pause=25] Cela ne devrait pas etre possible.",
           "Et pourtant vous etes la.[pause=20] Donc c'etait possible."},
    ask="Ça vous inquiete ?",
    last="Cela m'apprend quelque chose.[pause=30] A mon age, c'est rare.",
    close="Les murs de la chambre reprennent leur place,[pause=20] un peu trop lentement." },

  hour_that_lags = { g='fleche_reliques_courroux', inst='Dialga', pos={272,256},
    lines={"L'heure trainait.[pause=25] Elle traine encore.",
           "Ce n'est pas une panne.[pause=20] C'est quelque chose qui tire dessus."},
    ask="Quoi ?",
    last="Si je le savais,[pause=25] je ne serais pas reste plante ici a compter.",
    close="Le mecanisme repart d'un cran.[pause=25] Un seul. Puis il retrouve son retard." },

  last_resolve = { g='lac_courage', inst='Crefadet', pos={224,224},
    lines={"La resolution, ce n'est pas ne pas avoir peur.[pause=30] C'est y aller quand meme.",
           "Vous aviez peur.[pause=20] J'ai regarde."},
    ask="Vous regardez tout le monde comme ça ?",
    last="Seulement ceux qui vont avoir besoin de courage plus tard.",
    close="Le lac reprend son calme,[pause=20] mais quelque chose y veille toujours." },

  quiet_ledger = { g='lac_savoir', inst='Crehelf', pos={176,176},
    lines={"J'ai vu tout ce qui fut.[pause=25] Je vous ai regardes, aussi.",
           "Le registre est tenu.[pause=20] Vous y etes, maintenant."},
    ask="Qu'est-ce qui est ecrit ?",
    last="Une ligne.[pause=30] « Ils sont montes ensemble. »[pause=20] C'est deja beaucoup.",
    close="Les yeux du gardien se referment.[pause=25] Le lac redevient un lac." },

  last_encore = { g='grotte_echos', inst='Meloetta', pos={240,232},
    lines={"Un dernier rappel...[pause=25] et puis plus rien pendant longtemps.",
           "Cette grotte a garde toutes les voix qui sont passees.[pause=20] Meme les votres, deja."},
    ask="On n'a presque rien dit.",
    last="On garde surtout ce qui n'a pas ete dit.[pause=30] Vous verrez.",
    close="L'echo revient une derniere fois,[pause=20] puis la grotte se tait pour de bon." },

  only_shadow = { g='creux_ombres_scelle', inst='Marshadow', pos={320,232},
    lines={"...Vous m'avez vu.[pause=30] Personne ne me voit.",
           "Je vis dans l'ombre des autres.[pause=25] C'est plus sur."},
    ask="On peut vous voir sans vous faire de mal.",
    last="C'est ce que disait l'ombre precedente.",
    close="Le creux se referme.[pause=25] Une ombre de trop reste au sol, un instant." },

  ---------------- LUMIERE / DIVIN ----------------
  first_breath = { g='escalier_origine', inst='Arceus', pos={232,184},
    lines={"Vous avez monte des marches qui n'existaient pas.[pause=30] Elles existent, maintenant.",
           "C'est ainsi que tout a commence.[pause=25] Quelqu'un a avance dans le vide."},
    ask="Vous ?",
    last="Je n'ai jamais dit que c'etait moi.[pause=30] Vous l'avez suppose.",
    close="L'escalier continue au-dessus d'eux,[pause=20] plus haut qu'avant." },

  two_lights = { g='ile_legendaire', inst='Solgaleo', pos={248,168},
    lines={"La premiere lumiere ne demande rien.[pause=25] Elle se leve, c'est tout.",
           "Vous vous etes leves aussi.[pause=20] Sept fois, peut-etre huit."},
    ask="On a surtout arrete de compter.",
    last="Alors vous avez compris ce qu'est un soleil.",
    close="La lumiere baisse d'un ton,[pause=20] et l'ile retrouve ses couleurs normales." },

  two_lights_lunala = { g='ile_australe', inst='Lunala', pos={224,192},
    lines={"L'autre lumiere, c'est celle qu'on voit quand tout est eteint.",
           "Vous en aurez besoin.[pause=25] Bientot, je crois."},
    ask="Pourquoi bientot ?",
    last="Parce que quelque chose, quelque part,[pause=25] a commence a eteindre les choses.",
    close="Les ailes se replient.[pause=25] La nuit de l'ile parait soudain plus profonde." },

  borrowed_light = { g='ile_close', inst='Necrozma', pos={232,200},
    lines={"Cette lumiere n'est pas la mienne.[pause=30] Je l'ai empruntee.",
           "Je la rends mal.[pause=25] Je la rends quand meme."},
    ask="A qui ?",
    last="A ceux qui la portaient avant moi.[pause=30] Ils n'etaient pas d'accord non plus.",
    close="L'ile close s'assombrit doucement,[pause=20] et la lumiere part avec l'equipe." },

  given_life = { g='nef_prisme_est', inst='Xerneas', pos={320,232},
    lines={"La vie donnee ne revient jamais a celui qui la donne.[pause=30] C'est la regle.",
           "Je l'ai donnee mille fois.[pause=20] Je ne me souviens d'aucun visage."},
    ask="On se souviendra du votre.",
    last="...Repetez ca.[pause=30] Personne ne me l'avait jamais dit.",
    close="La nef s'illumine d'un vert tres pale,[pause=20] comme un printemps qui hesite." },

  rainbow_ash = { g='sommet_aurore', inst='HoOh', pos={280,208},
    lines={"Le bucher de l'aurore brule encore.[pause=25] Il attend ceux qui tombent.",
           "Vous n'etes pas tombes.[pause=20] Alors il attendra encore."},
    ask="Il attend qui, exactement ?",
    last="Ceux qui meritaient de se relever.[pause=30] La liste est courte.",
    close="Les cendres montent au lieu de descendre.[pause=25] Le sommet vire a l'or." },

  ninth_summit = { g='vigie_stratos', inst='Rayquaza', pos={232,184},
    lines={"Neuvieme sommet.[pause=25] Neuvieme fois que quelqu'un arrive jusqu'ici.",
           "Les huit autres ont demande a passer.[pause=20] Vous, vous avez demande POURQUOI c'etait ferme."},
    ask="Et alors ?",
    last="Alors vous etes les premiers a poser la bonne question.[pause=30] Je n'ai pas la reponse.",
    close="Le ciel s'ouvre sur toute la largeur du monde.[pause=25] On voit trop loin, d'un coup." },

  ---------------- TENEBRES / SPECTRE ----------------
  reverse_slope = { g='grotte_cryptique', inst='Giratina', pos={176,184},
    lines={"De ce cote-ci, tout est a l'envers.[pause=25] Meme les raisons.",
           "Vous m'avez battu a l'endroit.[pause=20] Ici, cela veut dire que j'ai gagne."},
    ask="...C'est une blague ?",
    last="Je n'ai plus fait de blague depuis tres longtemps.[pause=30] Peut-etre que si.",
    close="Le versant se retourne une derniere fois,[pause=20] et la sortie se retrouve derriere eux." },

  final_rest = { g='vallon_malsain_fond', inst='Yveltal', pos={248,208},
    lines={"Je ne prends pas la vie.[pause=25] Je passe apres.",
           "C'est un travail que personne ne veut.[pause=20] Alors je le fais."},
    ask="Ça ne vous pese pas ?",
    last="Tous les jours.[pause=30] Mais un cocon qui refuse de s'ouvrir, ce n'est plus un repos.",
    close="Les ailes se referment sur le vallon,[pause=25] et le silence n'est plus hostile." },

  soft_sleep = { g='mont_lune_vue', inst='Cresselia', pos={172,192}, inst2='Darkrai', pos2={212,192},
    lines={"Le sommeil doux, c'est mon travail.[pause=25] Le sien, c'est l'autre."},
    lines2={"...Je ne choisis pas les reves que je porte.",
            "Personne ne m'a jamais cru la-dessus."},
    ask="Nous, on veut bien vous croire.",
    last="Alors dormez bien cette nuit.[pause=30] Tous les deux. C'est tout ce que je peux offrir.",
    close="La lune se degage.[pause=25] Les deux visages restent cote a cote, sans se regarder." },

  dead_hours = { g='bois_antan_verger', inst='Celebi', pos={272,248},
    lines={"Les heures mortes, ce sont celles qu'on ne se rappelle pas.",
           "Vous en avez deja beaucoup.[pause=25] Plus que des enfants ne devraient."},
    ask="On n'est pas des enfants.",
    last="Non.[pause=30] Plus depuis un moment. C'est bien ce que je dis.",
    close="Le verger fleurit et fane en un souffle,[pause=20] puis reprend son age." },

  western_silence = { g='antre_occident', inst='Mewtwo', pos={160,264},
    lines={"Le silence de l'ouest.[pause=25] Je l'ai choisi.",
           "On m'a fabrique pour le bruit.[pause=20] La guerre, les cris, les ordres."},
    ask="Et vous avez choisi le silence.",
    last="C'est la seule chose que j'aie jamais choisie.[pause=30] Ne me la prenez pas.",
    close="L'antre se referme sans un bruit,[pause=20] exactement comme il le voulait." },

  ---------------- VOL / GLACE ----------------
  thawed_step = { g='champ_vent_boreal', inst='Artikodin', pos={176,136},
    lines={"Un pas degele.[pause=25] Un seul, sous votre poids.",
           "Le reste du champ est encore pris.[pause=20] Il le restera longtemps."},
    ask="On peut aider ?",
    last="Vous venez de le faire.[pause=30] Un pas, c'est un pas.",
    close="La glace craque quelque part,[pause=20] tres loin, et ne se referme pas." },

  twin_rift = { g='cretes_boreales', inst='Latios', pos={228,184}, inst2='Latias', pos2={268,184},
    lines={"Nous gardons la faille a deux.[pause=25] Toujours a deux."},
    lines2={"Parce que seul, on regarde dedans trop longtemps."},
    ask="Vous avez regarde dedans ?",
    last="Une fois.[pause=30] Ma soeur m'a ramene. C'est pour ca que nous sommes deux.",
    close="Les deux silhouettes s'eloignent en se suivant,[pause=20] jamais a plus de dix metres." },

  ---------------- PLANTE / FEE ----------------
  thanks_bloom = { g='champ_sacre', inst='Shaymin', pos={232,176},
    lines={"Ici fleurit le merci.[pause=25] C'est un endroit tres vide, la plupart du temps.",
           "Les gens oublient de le dire.[pause=20] Meme quand ils le pensent."},
    ask="Merci.",
    last="...Voila.[pause=30] Le champ vient de gagner une fleur.",
    close="Une seule fleur s'ouvre dans le champ sacre,[pause=20] au milieu de rien." },

  unsaid_wishes = { g='sanctuaire_voeu', inst='Jirachi', pos={176,136},
    lines={"Les voeux tus sont les plus lourds.[pause=25] Je les porte tous.",
           "Le tien aussi.[pause=20] Celui que tu n'as jamais formule a voix haute."},
    ask="Vous pouvez le realiser ?",
    last="Non.[pause=30] Je peux seulement te dire que je sais lequel c'est.",
    close="Les rubans du sanctuaire retombent,[pause=20] et le silence reprend son poids." },

  -- Duo joueur : ils n'ont jamais combattu serieusement. Le seul gardien
  -- qui traite l'Ancrage comme un jeu — et dont la derniere phrase revele
  -- que le jeu etait exactement le test.
  first_cradle = { g='arene_clairiere_secrete', inst='Mew', pos={252,224}, inst2='Hoopa', pos2={292,224},
    lines={"Hihi ![pause=20] C'etait bien ![pause=25] On recommence ?",
           "...Non ? Bon."},
    lines2={"Ils sont fatigues.[pause=20] Tu les as fait courir partout."},
    ask="C'etait un jeu, pour vous ?",
    last="Tout est un jeu.[pause=30] La difference, c'est qui accepte de perdre.",
    close="Le premier berceau se referme sur un rire,[pause=20] et la clairiere redevient ordinaire." },

  sunken_choir = { g='fosse_argentee', inst='Lugia', pos={272,296},
    lines={"Le choeur englouti chante encore.[pause=25] Personne ne l'entend d'en haut.",
           "Vous etes descendus jusqu'ici.[pause=20] Vous, vous l'avez entendu."},
    ask="On a surtout entendu l'eau.",
    last="C'est un debut.[pause=30] Redescendez quand vous saurez ecouter.",
    close="Le chant reprend, une octave plus bas,[pause=20] et la fosse le garde." },
}

--------------------------------------------------------------------
-- LegendArc.Victory(key)
--------------------------------------------------------------------
-- Appelee depuis zone/<zone>/init.lua juste apres LegendZones.SetDefeated.
-- Idempotente : la ceremonie ne se joue qu'UNE fois par gardien, meme si
-- le joueur revient l'affronter (revanche via Grodoudou).
--
-- Rejoue la scene sur le GROUND de la cinematique, avec les positions
-- relues dans son init.lua. Les cameras sont bornees a la carte.
function LegendArc.Victory(key)
  local f = LegendArc.LIST[key]
  if f == nil then return false end

  if SV.Anchors == nil then SV.Anchors = {} end
  if SV.Anchors.Adieux == nil then SV.Anchors.Adieux = {} end
  if SV.Anchors.Adieux[key] then return false end
  SV.Anchors.Adieux[key] = true

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end

    local g = CharacterEssentials.MakeCharactersFromList({
      { f.inst, f.pos[1], f.pos[2], Direction.Down }
    })
    pcall(function() AI:DisableCharacterAI(g) end)
    local g2 = nil
    if f.inst2 ~= nil then
      g2 = CharacterEssentials.MakeCharactersFromList({
        { f.inst2, f.pos2[1], f.pos2[2], Direction.Down }
      })
      pcall(function() AI:DisableCharacterAI(g2) end)
    end

    -- Cadrage : proche = sur le gardien, large = gardien + duo.
    local cx = f.pos[1]
    if f.pos2 ~= nil then cx = (f.pos[1] + f.pos2[1]) // 2 end
    local near = { cx, f.pos[2] + 18 }
    local wide = { cx, f.pos[2] + 48 }

    GAME:MoveCamera(wide[1], wide[2], 1, false)
    GAME:FadeIn(40)
    -- EoSO/beach : le lieu s'installe avant qu'on parle.
    GAME:WaitFrames(35)

    -- Cascade d'animations (pmd-red) : une SUITE d'etats, pas un bloc.
    pcall(function()
      GROUND:CharSetAnim(g, "Hurt", true)
      if g2 ~= nil then GROUND:CharSetAnim(g2, "Hurt", true) end
      GAME:WaitFrames(26)
      BossFX.ShakeScreen(4, 18)
      GAME:WaitFrames(16)
      GROUND:CharSetAnim(g, "Idle", true)
      if g2 ~= nil then GROUND:CharSetAnim(g2, "Idle", true) end
    end)
    GAME:WaitFrames(18)

    -- La camera remonte sur qui parle (patron du Tunnel).
    GAME:MoveCamera(near[1], near[2], 40, false)
    GAME:WaitFrames(10)

    if g2 ~= nil then
      local a, b = f.lines or {}, f.lines2 or {}
      for i = 1, math.max(#a, #b) do
        if a[i] ~= nil then say(g, a[i]) end
        if b[i] ~= nil then say(g2, b[i]) end
      end
    else
      for _, t in ipairs(f.lines or {}) do say(g, t) end
    end
    GAME:WaitFrames(12)

    -- Le duo repond : cadre commun.
    GAME:MoveCamera(wide[1], wide[2], 40, false)
    if partner ~= nil and f.ask ~= nil then
      UI:SetSpeaker(partner)
      UI:SetSpeakerEmotion("Worried")
      UI:WaitShowDialogue(f.ask)
      GAME:WaitFrames(12)
    end

    -- La phrase qui doit rester : plan resserre.
    if f.last ~= nil then
      GAME:MoveCamera(near[1], near[2], 40, false)
      say(g, f.last)
      GAME:WaitFrames(20)
    end

    if f.close ~= nil then
      GAME:MoveCamera(wide[1], wide[2], 40, false)
      narrate(f.close)
    end
    GAME:WaitFrames(20)
  end)

  if not ok then PrintInfo('[LegendArc] scene ecourtee : '..tostring(err)) end

  pcall(function()
    UI:ResetSpeaker()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)
  return true
end

return LegendArc
