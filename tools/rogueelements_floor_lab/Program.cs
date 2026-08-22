// Isolated real-RogueElements floor laboratory.
// It intentionally has no PMDO project dependency: it supplies only the small
// IGenContext / IRoomGridGenContext implementation needed by RogueElements.
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using RogueElements;
using RogueEssence.LevelGen;
using PMDC.LevelGen;

namespace NewEra.RogueElementsFloorLab;

public sealed class LabTile : ITile
{
    public LabTile(int id = 0) => ID = id;
    public int ID { get; set; }
    public ITile Copy() => new LabTile(ID);
    public bool TileEquivalent(ITile other) => other is LabTile tile && tile.ID == ID;
}

public sealed class LabStairsUp : ISpawnable, IEntrance
{
    public Loc Loc { get; set; }
    public ISpawnable Copy() => new LabStairsUp { Loc = Loc };
}

public sealed class LabStairsDown : ISpawnable, IExit
{
    public Loc Loc { get; set; }
    public ISpawnable Copy() => new LabStairsDown { Loc = Loc };
}

public sealed class LabContext : IRoomGridGenContext, IViewPlaceableGenContext<LabStairsUp>, IViewPlaceableGenContext<LabStairsDown>
{
    public const int Wall = 0;
    public const int Floor = 1;
    private LabTile[][]? tiles;
    private readonly List<LabStairsUp> entrances = new();
    private readonly List<LabStairsDown> exits = new();

    public IRandom Rand { get; private set; } = new ReRandom(1);
    public FloorPlan RoomPlan { get; private set; } = new();
    public GridPlan GridPlan { get; private set; } = new();
    public ITile RoomTerrain => new LabTile(Floor);
    public ITile WallTerrain => new LabTile(Wall);
    public int Width => tiles?.Length ?? 0;
    public int Height => tiles?[0].Length ?? 0;
    public bool Wrap => false;
    public bool TilesInitialized => tiles != null;
    public IReadOnlyList<LabStairsUp> Entrances => entrances;
    public IReadOnlyList<LabStairsDown> Exits => exits;

    public void InitSeed(ulong seed) => Rand = new ReRandom(seed);
    public void FinishGen() { }
    public void InitPlan(FloorPlan plan) => RoomPlan = plan;
    public void InitGrid(GridPlan plan) => GridPlan = plan;
    public void CreateNew(int width, int height, bool wrap = false)
    {
        tiles = new LabTile[width][];
        for (int x = 0; x < width; x++)
        {
            tiles[x] = new LabTile[height];
            for (int y = 0; y < height; y++) tiles[x][y] = new LabTile(Wall);
        }
    }
    public ITile GetTile(Loc loc) => tiles![loc.X][loc.Y];
    public bool TileBlocked(Loc loc) => tiles![loc.X][loc.Y].ID == Wall;
    public bool TileBlocked(Loc loc, bool diagonal) => TileBlocked(loc);
    public bool CanSetTile(Loc loc, ITile tile) => !Occupied(loc);
    public bool TrySetTile(Loc loc, ITile tile)
    {
        if (!CanSetTile(loc, tile)) return false;
        tiles![loc.X][loc.Y] = (LabTile)tile.Copy();
        return true;
    }
    public void SetTile(Loc loc, ITile tile)
    {
        if (!TrySetTile(loc, tile)) throw new InvalidOperationException("Cannot place tile");
    }
    private bool Occupied(Loc loc) => entrances.Any(s => s.Loc == loc) || exits.Any(s => s.Loc == loc);
    private List<Loc> OpenTiles(Rect rect)
    {
        var result = new List<Loc>();
        for (int x = Math.Max(0, rect.X); x < Math.Min(Width, rect.Right); x++)
            for (int y = Math.Max(0, rect.Y); y < Math.Min(Height, rect.Bottom); y++)
                if (!TileBlocked(new Loc(x, y)) && !Occupied(new Loc(x, y))) result.Add(new Loc(x, y));
        return result;
    }
    List<Loc> IPlaceableGenContext<LabStairsUp>.GetAllFreeTiles() => OpenTiles(new Rect(0, 0, Width, Height));
    List<Loc> IPlaceableGenContext<LabStairsDown>.GetAllFreeTiles() => OpenTiles(new Rect(0, 0, Width, Height));
    List<Loc> IPlaceableGenContext<LabStairsUp>.GetFreeTiles(Rect rect) => OpenTiles(rect);
    List<Loc> IPlaceableGenContext<LabStairsDown>.GetFreeTiles(Rect rect) => OpenTiles(rect);
    bool IPlaceableGenContext<LabStairsUp>.CanPlaceItem(Loc loc) => !Occupied(loc) && !TileBlocked(loc);
    bool IPlaceableGenContext<LabStairsDown>.CanPlaceItem(Loc loc) => !Occupied(loc) && !TileBlocked(loc);
    void IPlaceableGenContext<LabStairsUp>.PlaceItem(Loc loc, LabStairsUp item) => entrances.Add((LabStairsUp)item.Copy());
    void IPlaceableGenContext<LabStairsDown>.PlaceItem(Loc loc, LabStairsDown item) => exits.Add((LabStairsDown)item.Copy());
    int IViewPlaceableGenContext<LabStairsUp>.Count => entrances.Count;
    int IViewPlaceableGenContext<LabStairsDown>.Count => exits.Count;
    LabStairsUp IViewPlaceableGenContext<LabStairsUp>.GetItem(int index) => entrances[index];
    LabStairsDown IViewPlaceableGenContext<LabStairsDown>.GetItem(int index) => exits[index];
    Loc IViewPlaceableGenContext<LabStairsUp>.GetLoc(int index) => entrances[index].Loc;
    Loc IViewPlaceableGenContext<LabStairsDown>.GetLoc(int index) => exits[index].Loc;

    public string Render()
    {
        var sb = new StringBuilder();
        for (int y = 0; y < Height; y++)
        {
            for (int x = 0; x < Width; x++)
            {
                var loc = new Loc(x, y);
                sb.Append(entrances.Any(s => s.Loc == loc) ? '<' : exits.Any(s => s.Loc == loc) ? '>' : TileBlocked(loc) ? '#' : '.');
            }
            sb.Append('\n');
        }
        return sb.ToString();
    }
}

public static class Program
{
    private sealed record Result(string Profile, ulong Seed, int Rooms, int Halls, int Connections, int DeadEnds, int Branches, int Loops, int RoomMinArea, int RoomMaxArea, int Distance, bool Reachable, string Hash, string Layout);

    private static SpawnList<RoomGen<LabContext>> Rooms() => new()
    {
        { new RoomGenSquare<LabContext>(new RandRange(4, 10), new RandRange(4, 10)), 45 },
        { new RoomGenRound<LabContext>(new RandRange(5, 11), new RandRange(5, 11)), 25 },
        { new RoomGenCave<LabContext>(new RandRange(6, 12), new RandRange(6, 12)), 30 },
    };
    private static SpawnList<PermissiveRoomGen<LabContext>> Halls() => new()
    {
        { new RoomGenAngledHall<LabContext>(55, new RandRange(1, 3), new RandRange(1, 3)), 100 },
    };

    private static MapGen<LabContext> Build(string profile)
    {
        var layout = new MapGen<LabContext>();
        layout.GenSteps.Add(-5, new InitGridPlanStep<LabContext>(2) { CellX = 6, CellY = 5, CellWidth = 10, CellHeight = 9, Wrap = false });
        var rooms = Rooms();
        var halls = Halls();
        switch (profile)
        {
            case "branch":
                layout.GenSteps.Add(-4, new GridPathBranch<LabContext> { GenericRooms = rooms, GenericHalls = halls, RoomRatio = new RandRange(65, 88), BranchRatio = new RandRange(75, 160), NoForcedBranches = false });
                layout.GenSteps.Add(-4, new ConnectGridBranchStep<LabContext> { ConnectPercent = 55, GenericHalls = halls });
                break;
            case "circle":
                layout.GenSteps.Add(-4, new GridPathCircle<LabContext> { GenericRooms = rooms, GenericHalls = halls, CircleRoomRatio = new RandRange(55, 90), Paths = new RandRange(2, 5) });
                break;
            case "cross":
                layout.GenSteps.Add(-4, new GridPathCross<LabContext> { GenericRooms = rooms, GenericHalls = halls });
                break;
            case "two_sides":
                layout.GenSteps.Add(-4, new GridPathTwoSides<LabContext> { GenericRooms = rooms, GenericHalls = halls, GapAxis = Axis4.Horiz });
                break;
            case "tiered":
                layout.GenSteps.Add(-4, new GridPathTiered<LabContext> { GenericRooms = rooms, GenericHalls = halls, TierAxis = Axis4.Horiz, TierConnections = new RandRange(2, 5) });
                break;
            case "treads":
                layout.GenSteps.Add(-4, new GridPathTreads<LabContext> { GenericRooms = rooms, GenericHalls = halls, Vertical = false, RoomPercent = new RandRange(45, 75), ConnectPercent = new RandRange(35, 80) });
                break;
            default: throw new ArgumentException(profile);
        }
        layout.GenSteps.Add(-3, new DrawGridToFloorStep<LabContext>());
        // Verify post-grid additions and floor-plan connections rather than only grid paths.
        if (profile == "branch")
        {
            layout.GenSteps.Add(-2, new AddConnectedRoomsRandStep<LabContext>(rooms, halls) { Amount = new RandRange(2, 5), HallPercent = 80 });
            layout.GenSteps.Add(-2, new ConnectRoomStep<LabContext>(halls) { ConnectFactor = new RandRange(60, 120) });
        }
        layout.GenSteps.Add(-1, new DrawFloorToTileStep<LabContext>(2));
        layout.GenSteps.Add(0, new UnbreakableBorderStep<LabContext>(1));
        layout.GenSteps.Add(2, new FloorStairsStep<LabContext, LabStairsUp, LabStairsDown>(12, new LabStairsUp(), new LabStairsDown()));
        return layout;
    }

    private static int Distance(LabContext context)
    {
        if (context.Entrances.Count != 1 || context.Exits.Count != 1) return -1;
        var start = context.Entrances[0].Loc;
        var goal = context.Exits[0].Loc;
        var queue = new Queue<Loc>();
        var distance = new Dictionary<Loc, int> { [start] = 0 };
        queue.Enqueue(start);
        while (queue.Count > 0)
        {
            var current = queue.Dequeue();
            if (current == goal) return distance[current];
            foreach (var dir in DirExt.VALID_DIR4)
            {
                var next = current + dir.GetLoc();
                if (next.X < 0 || next.Y < 0 || next.X >= context.Width || next.Y >= context.Height || context.TileBlocked(next) || distance.ContainsKey(next)) continue;
                distance[next] = distance[current] + 1;
                queue.Enqueue(next);
            }
        }
        return -1;
    }

    private static Result Measure(string profile, ulong seed)
    {
        var context = Build(profile).GenMap(seed);
        var plan = context.RoomPlan;
        int vertices = plan.RoomCount + plan.HallCount;
        int degreeSum = 0;
        int deadEnds = 0;
        int branches = 0;
        int minArea = int.MaxValue;
        int maxArea = 0;
        for (int i = 0; i < plan.RoomCount; i++)
        {
            var room = plan.GetRoomPlan(i);
            int degree = room.Adjacents.Count;
            degreeSum += degree;
            if (degree == 1) deadEnds++;
            if (degree >= 3) branches++;
            int area = room.RoomGen.Draw.Area;
            minArea = Math.Min(minArea, area);
            maxArea = Math.Max(maxArea, area);
        }
        for (int i = 0; i < plan.HallCount; i++) degreeSum += plan.GetHallPlan(i).Adjacents.Count;
        int edges = degreeSum / 2;
        int distance = Distance(context);
        string layout = context.Render();
        string hash = Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(layout))).ToLowerInvariant()[..16];
        return new Result(profile, seed, plan.RoomCount, plan.HallCount, edges, deadEnds, branches, Math.Max(0, edges - vertices + 1), minArea, maxArea, distance, distance >= 0, hash, layout);
    }

    public static int Main(string[] args)
    {
        string output = args.Length > 0 ? args[0] : "rogueelements_floor_lab.json";
        var seeds = new ulong[] { 0x0012345678UL, 0x1020304050UL, 0x0F1E2D3C4BUL, 0x9988776655UL, 0xCAFEBABEUL, 0xDEADBEEFUL, 0x123456789ABCUL, 0xFEDCBA987654UL, 0x111122223333UL, 0xABCD1234EFUL };
        var profiles = new[] { "branch", "circle", "cross", "two_sides", "tiered", "treads" };
        var results = new List<Result>();
        foreach (var profile in profiles)
            foreach (var seed in seeds)
                results.Add(Measure(profile, seed));

        var summary = results.GroupBy(result => result.Profile).Select(group => new {
            profile = group.Key,
            runs = group.Count(),
            unique_layouts = group.Select(result => result.Hash).Distinct().Count(),
            reachable = group.Count(result => result.Reachable),
            rooms = new { min = group.Min(result => result.Rooms), max = group.Max(result => result.Rooms) },
            halls = new { min = group.Min(result => result.Halls), max = group.Max(result => result.Halls) },
            loops = new { min = group.Min(result => result.Loops), max = group.Max(result => result.Loops) },
            dead_ends = new { min = group.Min(result => result.DeadEnds), max = group.Max(result => result.DeadEnds) },
            distance = new { min = group.Min(result => result.Distance), max = group.Max(result => result.Distance) },
        });
        var payload = new { engine = "RogueElements", profiles = summary, runs = results };
        File.WriteAllText(output, JsonSerializer.Serialize(payload, new JsonSerializerOptions { WriteIndented = true }));
        foreach (var result in results.Where(result => result.Seed == seeds[0]))
            File.WriteAllText(Path.ChangeExtension(output, $"{result.Profile}.txt"), result.Layout);
        Console.WriteLine(JsonSerializer.Serialize(payload.profiles, new JsonSerializerOptions { WriteIndented = true }));
        if (results.Any(result => !result.Reachable) || summary.Any(profile => profile.unique_layouts < 5)) return 1;
        return 0;
    }
}
