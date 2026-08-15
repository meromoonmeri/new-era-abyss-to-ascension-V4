-- Dialogues français EU des habitants Pokémon du Village sans Nom.
local Voices={}
local T={
 Audino_Guide={
  spring={"Le village respire de nouveau. Chaque pousse reconnaît les pas de ceux qui reviennent.","Les quatre sentiers gardent la mémoire des saisons. Suis les clochettes roses si tu te perds."},
  summer={"La chaleur rend les parfums plus francs. Même les secrets finissent par mûrir au soleil.","Bois avant de repartir : les Pokémon des clairières deviennent téméraires quand l’orage approche."},
  autumn={"Les feuilles ne tombent pas pour disparaître ; elles montrent au sol la couleur du temps.","Trevenant veille loin d’ici. Écoute ce que la forêt refuse de perdre avant de lever la patte."},
  winter={"La neige étouffe les bruits, jamais les voix. Parle doucement et le village te répondra.","Entre te réchauffer quand tu veux. Une expédition prudente commence par savoir renoncer."}},
 Meganium_Herboriste={
  spring={"Ces jeunes feuilles soulagent les brûlures, mais seulement après la rosée.","Je ne vends pas de miracles : je prépare du temps, de l’attention et une bonne tisane."},
  summer={"La menthe solaire pousse vite. Une feuille suffit, sinon son parfum couvre tout.","Les Baies Oran aiment l’ombre de midi. Même les remèdes ont besoin de repos."},
  autumn={"Je conserve les graines avant les premières pluies. Préparer demain, c’est déjà le soigner.","Apporte-moi les plantes inconnues : une question évite parfois un long détour par l’infirmerie."},
  winter={"Sous la neige, les racines travaillent encore. Le silence n’est pas l’absence.","Ne frotte jamais une gelure. Couvre-la, avance lentement, puis viens me voir."}},
 Bibarel_Charpentier={
  spring={"J’ai remplacé chaque marche abîmée sans déplacer le sentier d’un seul galet.","Une maison solide suit le terrain au lieu de lui ordonner de céder."},
  summer={"Le pont travaille sous la chaleur. Je desserre les assemblages avant qu’ils ne se fendent.","Mes dents coupent droit, mais c’est la mesure qui fait le bon ouvrage."},
  autumn={"Les feuilles bouchent les rigoles. Un petit entretien évite une grande inondation.","J’utilise les chutes pour fabriquer des couchettes Pokémon : rien ne mérite d’être gaspillé."},
  winter={"La neige pèse plus qu’elle n’en a l’air. J’inspecte les toits avant chaque nuit froide.","J’ai sculpté des rebords bas pour les petits Pokémon et des rampes pour ceux qui glissent."}},
 Decidueye_Chasseur={
  spring={"Je ne chasse pas ce qui fuit. Je surveille les pistes pour que prédateurs et voyageurs s’évitent.","Les plumes au nord indiquent un nid, pas un trophée. Contourne la clairière."},
  summer={"Les traces sèchent vite. Observe l’herbe couchée plutôt que la poussière.","Volcarona défend une chaleur ancienne. Entre dans son domaine sans arme levée."},
  autumn={"La forêt change de voix. Les branches mortes révèlent les pas, mais masquent les intentions.","J’ai marqué les détours sûrs avec une plume tournée vers le village."},
  winter={"Dans la neige, ta propre piste peut guider un adversaire. Efface-la près des refuges.","Baxcalibur annonce sa charge par un grondement sourd. Ne reste jamais devant une pente glacée."}},
 Komala_Bucheron={
  spring={"Je coupe seulement les arbres déjà tombés. Les autres ont encore des histoires à porter.","Le bois vert chante dans la scie. Le bois prêt répond d’une voix courte et claire."},
  summer={"Je travaille à l’aube, puis je dors à l’ombre. Une hache fatiguée est dangereuse.","Si tu m’entends ronfler, laisse le panier ici. Je saurai qui l’a apporté… probablement."},
  autumn={"La forêt donne beaucoup ; nous rendons du compost, des graines et du silence.","Ces branches deviendront outils, jouets et nids. Rien ne sera perdu."},
  winter={"Je garde du bois sec pour chaque maison. Personne ne devrait choisir entre manger et se réchauffer.","Un bon feu crépite doucement. S’il rugit, Torkoal dira que j’ai encore trop chargé."}},
 Leavanny_Couturiere={
  spring={"Les nouvelles feuilles sont souples, mais je ne prends que ce que la plante peut offrir.","Ta cape a connu des ronces. Laisse-moi renforcer l’ourlet avant ta prochaine sortie."},
  summer={"Le fil de soie respire mieux que la laine. Le confort protège aussi.","Une couture discrète est belle ; une couture solide sauve parfois une expédition."},
  autumn={"Chaque feuille diffère. Je garde ses irrégularités : elles rendent le vêtement vivant.","Je peux réparer le tissu, pas ce que tu refuses de dire. Pour cela, Audino écoute mieux."},
  winter={"J’ai doublé les capes avec du coton de Cottonee. Elles restent légères sous la neige.","Prends cette écharpe. Rapporte-la simplement quand un autre Pokémon en aura besoin."}},
 Torkoal_Forgeron={
  spring={"La forge reprend doucement. Un métal chauffé trop vite conserve de mauvaises tensions.","Je fabrique surtout des outils : une pelle fiable protège plus de vies qu’une lame brillante."},
  summer={"La chaleur extérieure trompe. Celle de ma carapace reste régulière : voilà le secret.","Pose ton équipement ici. Je vérifierai les rivets pendant que tu bois quelque chose de frais."},
  autumn={"L’humidité attaque les charnières. Une fine huile suffit si l’on agit avant la rouille.","Cette clochette est pour le pavillon. Son timbre portera même dans le brouillard."},
  winter={"Je garde un brasero bas pour les petits Pokémon. La chaleur doit accueillir, pas impressionner.","Les crampons sont prêts : Bibarel a vérifié les sangles et Leavanny les a renforcées."}}
}
Voices.Bosses={Ursaluna={"Je garde cette lisière depuis que les sentiers n’avaient pas de nom.","Montre-moi que ta force sait protéger autant que vaincre."},Volcarona={"Ma lumière nourrit la clairière, mais brûle les volontés avides.","Traverse le cercle de chaleur sans céder à la précipitation."},Trevenant={"Chaque branche arrachée demeure dans la mémoire de mes racines.","Que rendras-tu à la forêt après ton passage ?"},Froslass={"Le blizzard efface les pistes, jamais les promesses.","Si ton cœur reste clair dans le froid, je t’ouvrirai la route."},Baxcalibur={"La glace cède aux pas hésitants et porte ceux qui s’engagent.","Avance. Que la montagne juge ton équilibre."},Darkrai={"Un village sans nom… des rêves qui refusent de disparaître.","Réveille-les, si tu acceptes de voir aussi ce qu’ils craignent."}}
function Voices.Talk(chara,key)local s=(SV.NoNameVillage and SV.NoNameVillage.Season)or'spring';local lines=(T[key]or{})[s]or(T[key]or{}).spring or{"Le village t’écoute."};UI:SetSpeaker(chara);for _,line in ipairs(lines)do UI:WaitShowDialogue(line)end end
return Voices
