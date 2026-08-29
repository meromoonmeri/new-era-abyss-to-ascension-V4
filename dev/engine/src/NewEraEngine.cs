// NewEra.Engine — primitives de génération ROM-exactes pour PMDO.
// Compilé IN-PROCESS par Roslyn (bundle PMDO 0.8.12) via le service
// engine_loader ; chargé par Assembly.LoadFrom AVANT toute désérialisation
// de zone, donc utilisable dans les JSON avec $type "..., NewEra.Engine".
//
// SOURCES ROM (traçabilité, aucune invention) :
//  - MonsterHouseRomStep : pret pmd-red SpawnEnemies (l.4494+ : mobs =
//    RandRange(70%,80% des tuiles libres), cap = base*3/2 ; base GBA 12 /
//    NDS 30 ; empty = 3) et dungeon-eos l.3175-3218 (items+pièges =
//    max(6, RandRange(50%,80%)) cap 7, split 50/50, pièges seulement si
//    dungeon_id >= MH_MIN_TRAP_DUNGEON(28) — porté via AllowTraps).
//  - RoomGenMaze : pret GenerateMaze/GenerateMazeLine (marches aléatoires
//    cardinales à pas de 2 depuis les bords impairs + remplissage interne
//    stride 2) — mécanique présente dans les 2 moteurs (dormante dans les
//    données) ; exposée pour les zones New Era qui la veulent.
//  - ImperfectRoomStep : pret GenerateRoomImperfections (60 % de chance,
//    (w+h)/4 itérations, grignotage des coins en 2 passes, garde-fou
//    "pas de couloir adjacent à 2 cases").
//  - IslandRoomStep : pret GenerateSecondaryStructure SECONDARY_STRUCTURE_ISLAND
//    (salle >=6x6 : douve d'eau 2 anneaux du centre, île 2x2 au centre
//    avec items + piège avertisseur + warp).
using System;
using System.Collections.Generic;
using RogueElements;
using RogueEssence;
using RogueEssence.Data;
using RogueEssence.Dungeon;
using RogueEssence.LevelGen;
using PMDC.LevelGen;
using PMDC.Dungeon;

namespace NewEra.LevelGen
{
    [Serializable]
    public class EngineProbe
    {
        public static string Version() { return "NEWERA_ENGINE_V1"; }
    }

    /// <summary>
    /// R4.4/R4.5 ROM-exact : Monster House dont le nombre de monstres est
    /// proportionnel aux tuiles libres de la salle (70-80 %), plafonné au
    /// cap ROM, et dont les items/pièges suivent la loi 50/50 EoS.
    /// Étend MonsterHouseBaseStep (même data : Items/ItemThemes/Mobs/MobThemes)
    /// pour rester interchangeable avec MonsterHouseStep dans SpreadHouseZoneStep.
    /// </summary>
    [Serializable]
    public class MonsterHouseRomStep<T> : MonsterHouseBaseStep<T> where T : ListMapGenContext
    {
        /// <summary>Cap ROM de monstres AVANT le x3/2 (GBA 12, NDS 30).</summary>
        public int MobCap;

        /// <summary>Cap ROM d'items+pièges (GBA/NDS : 7).</summary>
        public int ItemTrapCap;

        /// <summary>Pièges autorisés (EoS : dungeon_id >= 28 ou free mode).</summary>
        public bool AllowTraps;

        /// <summary>Pièges candidats ; si vide, tire dans map.TileSpawns.</summary>
        public SpawnList<EffectTile> Traps;

        public List<BaseRoomFilter> Filters { get; set; }

        public MonsterHouseRomStep() : base()
        {
            Filters = new List<BaseRoomFilter>();
            Traps = new SpawnList<EffectTile>();
            MobCap = 30;
            ItemTrapCap = 7;
            AllowTraps = true;
        }

        public MonsterHouseRomStep(MonsterHouseRomStep<T> other) : base(other)
        {
            Filters = new List<BaseRoomFilter>();
            Filters.AddRange(other.Filters);
            Traps = (SpawnList<EffectTile>)other.Traps.CopyState();
            MobCap = other.MobCap;
            ItemTrapCap = other.ItemTrapCap;
            AllowTraps = other.AllowTraps;
        }

        public override MonsterHouseBaseStep<T> CreateNew() { return new MonsterHouseRomStep<T>(this); }

        public override void Apply(T map)
        {
            if (!ItemThemes.CanPick || !MobThemes.CanPick)
                return;

            // choix de salle : identique à MonsterHouseStep (équiprobable,
            // filtres, jamais l'entrée/sortie)
            List<int> possibleRooms = new List<int>();
            for (int ii = 0; ii < map.RoomPlan.RoomCount; ii++)
            {
                if (!BaseRoomFilter.PassesAllFilters(map.RoomPlan.GetRoomPlan(ii), this.Filters))
                    continue;
                Rect curRoom = map.RoomPlan.GetRoom(ii).Draw;
                bool skipRoom = false;
                foreach (MapGenEntrance entrance in map.GenEntrances)
                {
                    if (curRoom.Contains(entrance.Loc)) { skipRoom = true; break; }
                }
                foreach (MapGenExit exit in map.GenExits)
                {
                    if (curRoom.Contains(exit.Loc)) { skipRoom = true; break; }
                }
                if (!skipRoom)
                    possibleRooms.Add(ii);
            }
            if (possibleRooms.Count == 0)
                return;

            IRoomGen room = map.RoomPlan.GetRoom(possibleRooms[map.Rand.Next(possibleRooms.Count)]);

            // tuiles libres (loi ROM : open terrain, sans effet/item/mob)
            List<Loc> freeTiles = new List<Loc>();
            for (int x = room.Draw.X; x < room.Draw.X + room.Draw.Size.X; x++)
            {
                for (int y = room.Draw.Y; y < room.Draw.Y + room.Draw.Size.Y; y++)
                {
                    Loc testLoc = new Loc(x, y);
                    if (map.TileBlocked(testLoc))
                        continue;
                    if (map.HasTileEffect(testLoc))
                        continue;
                    if ((map.GetPostProc(testLoc).Status & (PostProcType.Panel | PostProcType.Item)) != PostProcType.None)
                        continue;
                    bool occupied = false;
                    foreach (MapItem item in map.Items)
                    {
                        if (item.TileLoc == testLoc) { occupied = true; break; }
                    }
                    if (!occupied)
                        freeTiles.Add(testLoc);
                }
            }
            if (freeTiles.Count == 0)
                return;

            // ---- MONSTRES : RandRange(70 %, 80 %) des tuiles, min 1, cap ROM*3/2
            int mobHardCap = MobCap * 3 / 2;
            int lo = freeTiles.Count * 7 / 10;
            int hi = freeTiles.Count * 8 / 10;
            int mobCount = (hi > lo) ? (lo + map.Rand.Next(hi - lo)) : lo;
            if (mobCount < 1) mobCount = 1;
            if (mobCount > mobHardCap) mobCount = mobHardCap;
            // limite physique : 1 monstre par tuile libre (les items en enlèvent)
            if (mobCount > freeTiles.Count) mobCount = freeTiles.Count;

            // ---- ITEMS + PIÈGES : max(6, RandRange(50 %, 80 %)) cap ROM(7), 50/50
            int itLo = freeTiles.Count / 2;
            int itHi = freeTiles.Count * 8 / 10;
            int itemTrapCount = (itHi > itLo) ? (itLo + map.Rand.Next(itHi - itLo)) : itLo;
            if (itemTrapCount < 6) itemTrapCount = 6;
            if (itemTrapCount > ItemTrapCap) itemTrapCount = ItemTrapCap;

            ItemTheme chosenItemTheme = ItemThemes.Pick(map.Rand);
            List<MapItem> chosenItems = chosenItemTheme.GenerateItems(map, Items);
            int itemIdx = 0;

            List<Loc> placeTiles = new List<Loc>(freeTiles);
            for (int ii = 0; ii < itemTrapCount && placeTiles.Count > 0; ii++)
            {
                int randIndex = map.Rand.Next(placeTiles.Count);
                Loc loc = placeTiles[randIndex];
                placeTiles.RemoveAt(randIndex);
                bool placeTrap = AllowTraps && (map.Rand.Next(2) == 1);
                if (placeTrap)
                {
                    EffectTile trap = null;
                    if (Traps.CanPick)
                        trap = new EffectTile(Traps.Pick(map.Rand), loc);
                    else if (map.TileSpawns.CanPick)
                        trap = new EffectTile(map.TileSpawns.Pick(map.Rand), loc);
                    if (trap != null)
                    {
                        ((IPlaceableGenContext<EffectTile>)map).PlaceItem(loc, trap);
                        continue;
                    }
                }
                if (itemIdx < chosenItems.Count)
                {
                    MapItem item = new MapItem(chosenItems[itemIdx]);
                    itemIdx++;
                    ((IPlaceableGenContext<MapItem>)map).PlaceItem(loc, item);
                }
            }

            // ---- THÈME DE MONSTRES : la liste vient du thème, la TAILLE
            // vient de la salle (le thème est requêté avec Amount=mobCount).
            MobTheme chosenMobTheme = MobThemes.Pick(map.Rand).Copy();
            chosenMobTheme.Amount = new RandRange(mobCount);
            List<MobSpawn> chosenMobs = chosenMobTheme.GenerateMobs(map, Mobs);

            CheckIntrudeBoundsEvent check = new CheckIntrudeBoundsEvent();
            check.Bounds = room.Draw;
            {
                MonsterHouseMapEvent house = new MonsterHouseMapEvent();
                house.Bounds = room.Draw;
                MonsterHouseTableState mhtable = DataManager.Instance.UniversalEvent.UniversalStates.GetWithDefault<MonsterHouseTableState>();
                if (mhtable != null && mhtable.MonsterHouseWarningTile != null)
                {
                    for (int xx = house.Bounds.X; xx < house.Bounds.X + house.Bounds.Size.X; xx++)
                    {
                        for (int yy = house.Bounds.Y; yy < house.Bounds.Y + house.Bounds.Size.Y; yy++)
                        {
                            Loc loc = new Loc(xx, yy);
                            Tile tile = map.Map.Tiles[xx][yy];
                            TerrainData data = (TerrainData)tile.Data.GetData();
                            if (data.BlockType == TerrainData.Mobility.Passable && !map.HasTileEffect(loc))
                                ((IPlaceableGenContext<EffectTile>)map).PlaceItem(loc, new EffectTile(mhtable.MonsterHouseWarningTile, true));
                        }
                    }
                }
                foreach (MobSpawn mob in chosenMobs)
                {
                    MobSpawn copyMob = mob.Copy();
                    if (map.Rand.Next(ALT_COLOR_ODDS) == 0)
                    {
                        SkinTableState table = DataManager.Instance.UniversalEvent.UniversalStates.GetWithDefault<SkinTableState>();
                        copyMob.BaseForm.Skin = table.AltColor;
                    }
                    house.Mobs.Add(copyMob);
                }
                check.Effects.Add(house);
            }
            AddIntrudeStep(map, check);
        }

        public override string ToString()
        {
            return string.Format("{0}: ROM-exact (cap {1}x3/2, traps {2})", this.GetType().GetFormattedTypeName(), MobCap, AllowTraps);
        }
    }

    /// <summary>
    /// R10 : salle-labyrinthe — algorithme pret GenerateMaze/GenerateMazeLine
    /// exact (marches cardinales à pas de 2, murs posés sur les tuiles
    /// intermédiaires). Connectivité garantie par construction : l'algorithme
    /// ne bouche jamais une tuile ouverte (il ne pose un mur QUE sur le
    /// segment entre la position courante et une tuile ouverte à distance 2,
    /// en s'arrêtant si aucune direction n'est libre).
    /// </summary>
    [Serializable]
    public class RoomGenMaze<T> : PermissiveRoomGen<T>
        where T : ITiledGenContext
    {
        public RandRange Width { get; set; }
        public RandRange Height { get; set; }

        public RoomGenMaze() { }
        public RoomGenMaze(RandRange width, RandRange height) { Width = width; Height = height; }
        protected RoomGenMaze(RoomGenMaze<T> other) { Width = other.Width; Height = other.Height; }
        public override RoomGen<T> Copy() { return new RoomGenMaze<T>(this); }

        public override Loc ProposeSize(IRandom rand)
        {
            // dims impaires (contrainte ROM mazify : les 2 dimensions impaires)
            int w = Width.Pick(rand) | 1;
            int h = Height.Pick(rand) | 1;
            return new Loc(Math.Max(5, w), Math.Max(5, h));
        }

        public override void DrawOnMap(T map)
        {
            // pret GenerateMaze EXACT : ouvrir la salle puis lancer des
            // "wall walks" DEPUIS LES 4 BORDS EXTERIEURS (start-1 / end),
            // positions impaires, pas de 2. Pas de remplissage interne :
            // les murs croissent depuis l'exterieur, le complement reste
            // connexe (couloirs de largeur 1).
            for (int x = 0; x < Draw.Size.X; x++)
            {
                for (int y = 0; y < Draw.Size.Y; y++)
                    map.TrySetTile(new Loc(Draw.X + x, Draw.Y + y), map.RoomTerrain.Copy());
            }

            int sx = Draw.X, sy = Draw.Y;
            int ex = Draw.X + Draw.Size.X, ey = Draw.Y + Draw.Size.Y;

            for (int curX = sx + 1; curX < ex - 1; curX += 2)
                MazeLine(map, curX, sy - 1, sx, sy, ex, ey);      // bord haut (pret start.y-1)
            for (int curY = sy + 1; curY < ey - 1; curY += 2)
                MazeLine(map, ex, curY, sx, sy, ex, ey);          // bord droit (pret end.x)
            for (int curX = sx + 1; curX < ex - 1; curX += 2)
                MazeLine(map, curX, ey, sx, sy, ex, ey);          // bord bas (pret end.y)
            for (int curY = sy + 1; curY < ey - 1; curY += 2)
                MazeLine(map, sx - 1, curY, sx, sy, ex, ey);      // bord gauche (pret start.x-1)

            SetRoomBorders(map);
        }

        private void MazeLine(T map, int x0, int y0, int xMin, int yMin, int xMax, int yMax)
        {
            // pret GenerateMazeLine EXACT (l.3427+) : obstacle sur (x0,y0)
            // si dans la salle, chercher OUVERT a distance 2 (4 directions
            // en rotation), murer l'intermediaire, avancer ; return si rien.
            int guard = (xMax - xMin) * (yMax - yMin) + 16;
            while (guard-- > 0)
            {
                int direction = map.Rand.Next(4);
                int i = 0;
                if (xMin <= x0 && x0 < xMax && yMin <= y0 && y0 < yMax)
                    map.TrySetTile(new Loc(x0, y0), map.WallTerrain.Copy());
                int offX = 0, offY = 0;
                bool found = false;
                while (true)
                {
                    switch (direction & 3)
                    {
                        case 0: offX = 2; offY = 0; break;
                        case 1: offX = 0; offY = -2; break;
                        case 2: offX = -2; offY = 0; break;
                        default: offX = 0; offY = 2; break;
                    }
                    int posX = x0 + offX, posY = y0 + offY;
                    if (xMin <= posX && posX < xMax && yMin <= posY && posY < yMax
                        && IsOpen(map, posX, posY))
                    {
                        found = true;
                        break;
                    }
                    direction++;
                    if (++i >= 4)
                        return;
                }
                int midX = x0 + offX / 2, midY = y0 + offY / 2;
                if (xMin <= midX && midX < xMax && yMin <= midY && midY < yMax)
                    map.TrySetTile(new Loc(midX, midY), map.WallTerrain.Copy());
                x0 += offX;
                y0 += offY;
            }
        }

        private bool IsOpen(T map, int x, int y)
        {
            return map.GetTile(new Loc(x, y)).TileEquivalent(map.RoomTerrain);
        }


        public override string ToString()
        {
            return string.Format("{0}: {1}x{2}", this.GetType().GetFormattedTypeName(), Width, Height);
        }
    }

    /// <summary>
    /// R7 : imperfections de salles — post-process pret
    /// GenerateRoomImperfections exact : pour chaque salle filtrée, 60 % de
    /// chance d'être grignotée ; (w+h)/4 itérations ; à chaque itération 2
    /// passes depuis un coin aléatoire (sens horaire/anti-horaire), jusqu'à
    /// 10 tuiles remplacées par du mur, en refusant toute tuile adjacente
    /// (8 dirs) à un couloir.
    /// </summary>
    [Serializable]
    public class ImperfectRoomStep<T> : GenStep<T> where T : ListMapGenContext
    {
        /// <summary>% de salles flaggées imparfaites (ROM : toutes les salles
        /// candidates le sont quand roomFlags&4 ; ici data-driven).</summary>
        public int RoomPercent;

        public List<BaseRoomFilter> Filters { get; set; }

        public ImperfectRoomStep() { Filters = new List<BaseRoomFilter>(); RoomPercent = 100; }

        public override void Apply(T map)
        {
            for (int ii = 0; ii < map.RoomPlan.RoomCount; ii++)
            {
                if (!BaseRoomFilter.PassesAllFilters(map.RoomPlan.GetRoomPlan(ii), this.Filters))
                    continue;
                if (map.Rand.Next(100) >= RoomPercent)
                    continue;
                // ROM : 40 % de chance de PAS avoir d'imperfections
                if (map.Rand.Next(100) < 40)
                    continue;
                Rect draw = map.RoomPlan.GetRoom(ii).Draw;
                int length = (draw.Size.X + draw.Size.Y) / 4;
                if (length == 0) length = 1;
                for (int counter = 0; counter < length; counter++)
                {
                    for (int i = 0; i < 2; i++)
                    {
                        int corner = map.Rand.Next(4);
                        int ptX, ptY, moveX, moveY;
                        switch (corner)
                        {
                            case 0: default:
                                ptX = draw.X; ptY = draw.Y;
                                if (i != 0) { moveX = 1; moveY = 0; } else { moveX = 0; moveY = 1; }
                                break;
                            case 1:
                                ptX = draw.End.X - 1; ptY = draw.Y;
                                if (i != 0) { moveX = 0; moveY = 1; } else { moveX = -1; moveY = 0; }
                                break;
                            case 2:
                                ptX = draw.End.X - 1; ptY = draw.End.Y - 1;
                                if (i != 0) { moveX = -1; moveY = 0; } else { moveX = 0; moveY = -1; }
                                break;
                            case 3:
                                ptX = draw.X; ptY = draw.End.Y - 1;
                                if (i != 0) { moveX = 0; moveY = -1; } else { moveX = 1; moveY = 0; }
                                break;
                        }
                        for (int v = 0; v < 10; v++)
                        {
                            if (ptX < draw.X || ptX >= draw.End.X) break;
                            if (ptY < draw.Y || ptY >= draw.End.Y) break;
                            Loc loc = new Loc(ptX, ptY);
                            if (map.GetTile(loc).TileEquivalent(map.RoomTerrain) && !map.HasTileEffect(loc))
                            {
                                // garde ROM : pas de couloir dans les 8 cases adjacentes
                                bool nearHall = false;
                                foreach (Dir8 dir in DirExt.VALID_DIR8)
                                {
                                    Loc adj = loc + dir.GetLoc();
                                    if (!Collision.InBounds(map.Width, map.Height, adj))
                                        continue;
                                    if (!map.GetTile(adj).TileEquivalent(map.RoomTerrain))
                                        continue;
                                    if (!map.RoomPlan.InBounds(draw, adj))
                                    {
                                        nearHall = true;
                                        break;
                                    }
                                }
                                if (!nearHall)
                                {
                                    map.TrySetTile(loc, map.WallTerrain.Copy());
                                    break;
                                }
                            }
                            ptX += moveX; ptY += moveY;
                        }
                    }
                }
            }
        }

        public override string ToString()
        {
            return string.Format("{0}: {1}%", this.GetType().GetFormattedTypeName(), RoomPercent);
        }
    }

    /// <summary>
    /// R8-ISLAND : pret GenerateSecondaryStructure case ISLAND exact —
    /// dans une salle >= 6x6 : douve d'eau (anneau à distance 2 du centre),
    /// île 2x2 au centre portant items + piège + warp. Générique (Amount
    /// de salles, terrain/tuiles/items data-driven).
    /// </summary>
    [Serializable]
    public class IslandRoomStep<T> : GenStep<T> where T : ListMapGenContext
    {
        public RandRange Amount;
        public List<BaseRoomFilter> Filters { get; set; }
        /// <summary>Terrain de la douve (eau/lave).</summary>
        public ITile Terrain { get; set; }
        /// <summary>Items déposés sur l'île (ROM : 4 items).</summary>
        public SpawnList<MapItem> Items;
        /// <summary>Tuile piège/warp du centre (ROM : warp + piège).</summary>
        public SpawnList<EffectTile> Tiles;

        public IslandRoomStep()
        {
            Filters = new List<BaseRoomFilter>();
            Items = new SpawnList<MapItem>();
            Tiles = new SpawnList<EffectTile>();
        }

        public override void Apply(T map)
        {
            int amount = Amount.Pick(map.Rand);
            List<int> candidates = new List<int>();
            for (int ii = 0; ii < map.RoomPlan.RoomCount; ii++)
            {
                if (!BaseRoomFilter.PassesAllFilters(map.RoomPlan.GetRoomPlan(ii), this.Filters))
                    continue;
                Rect draw = map.RoomPlan.GetRoom(ii).Draw;
                if (draw.Size.X >= 6 && draw.Size.Y >= 6)
                    candidates.Add(ii);
            }
            for (int n = 0; n < amount && candidates.Count > 0; n++)
            {
                int pick = map.Rand.Next(candidates.Count);
                Rect draw = map.RoomPlan.GetRoom(candidates[pick]).Draw;
                candidates.RemoveAt(pick);
                int cx = draw.X + draw.Size.X / 2 - 1;
                int cy = draw.Y + draw.Size.Y / 2 - 1;
                // douve : anneau 4x4 autour de l'île 2x2 (ROM : moat à
                // distance 2 du centre)
                for (int x = cx - 2; x <= cx + 3; x++)
                {
                    for (int y = cy - 2; y <= cy + 3; y++)
                    {
                        bool inIsland = (x >= cx && x <= cx + 1 && y >= cy && y <= cy + 1);
                        if (inIsland)
                            continue;
                        Loc loc = new Loc(x, y);
                        if (!Collision.InBounds(map.Width, map.Height, loc))
                            continue;
                        if (!map.RoomPlan.InBounds(draw, loc))
                            continue;
                        if (map.GetTile(loc).TileEquivalent(map.RoomTerrain) && !map.HasTileEffect(loc))
                            map.TrySetTile(loc, Terrain.Copy());
                    }
                }
                // île : items + tuiles (warp/piège)
                Loc[] islandLocs = new Loc[]
                {
                    new Loc(cx, cy), new Loc(cx + 1, cy),
                    new Loc(cx, cy + 1), new Loc(cx + 1, cy + 1),
                };
                int tileIdx = 0;
                foreach (Loc loc in islandLocs)
                {
                    if (!Collision.InBounds(map.Width, map.Height, loc))
                        continue;
                    if (tileIdx == 0 && Tiles.CanPick)
                    {
                        EffectTile eff = new EffectTile(Tiles.Pick(map.Rand), loc);
                        ((IPlaceableGenContext<EffectTile>)map).PlaceItem(loc, eff);
                    }
                    else if (Items.CanPick)
                    {
                        MapItem item = new MapItem(Items.Pick(map.Rand));
                        ((IPlaceableGenContext<MapItem>)map).PlaceItem(loc, item);
                    }
                    tileIdx++;
                }
            }
        }

        public override string ToString()
        {
            return string.Format("{0}: {1}", this.GetType().GetFormattedTypeName(), Amount);
        }
    }
}
