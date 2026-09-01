import sys, os, io
sys.path.insert(0,'dev/tools')
import png2tileset as P
P.ROOT=os.path.abspath('.'); P.TILEDIR=os.path.join(P.ROOT,'Content','Tile')
for name in ['Metano_Town_Objects','Metano_Town_Base','Metano_Town_Fringe']:
    ts,cells = P.lire_planche(name, brut=True)
    # count alpha-opaque vs transparent cells
    opaque=trans=partial=0
    sampletrans=False
    for k,im in list(cells.items())[:]:
        a=im.getchannel('A')
        ex=a.getextrema()
        if ex==(0,0): trans+=1
        elif ex==(255,255): opaque+=1
        else: partial+=1
    print(f"{name}: ts={ts} cells={len(cells)} opaque(fully)={opaque} transparent={trans} partial={partial}")
