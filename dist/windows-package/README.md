# New-Era.zip — Windows-safe distributable package

Because GitHub Release assets could not be uploaded from this environment
(the `uploads.github.com` endpoint is unreachable from the build sandbox),
the archive is checked into the repository as **5 split parts** under
`dist/windows-package/`. Each part is ≤ 85 MiB (Git's per-blob limit is
100 MiB). Reassembly is byte-identical to the archive that
`tools/package_windows.py` produced.

## Facts

| Field | Value |
| --- | --- |
| Full archive | `New-Era.zip` |
| Full size | 436 572 852 bytes (416.35 MiB) |
| Full SHA-256 | `543972a8c2bec962f41e375e1208a6dd51065278bebd49756a6ea5445f09cf3c` |
| Files inside | 3 700 |
| Longest relative path | 93 chars (Windows-safe) |
| Source commit | [`4f78df3b`](../../commit/4f78df3b) |
| Packager | [`tools/package_windows.py`](../../tools/package_windows.py) |
| Report | [`docs/dungeon_builder/packaging/PACKAGE_REPORT.json`](../../docs/dungeon_builder/packaging/PACKAGE_REPORT.json) |
| Layout reference | [Palikadude/Halcyon](https://github.com/Palikadude/Halcyon) |

Per-part hashes: see [`MANIFEST.json`](MANIFEST.json).

## Download and reassemble — Windows (PowerShell)

Fastest: download each part from the GitHub file viewer (click the
`Download raw file` button on each `New-Era.zip.part_00N` page under
`dist/windows-package/`), save them all into the same folder, then:

```powershell
cd <folder-where-you-saved-the-parts>

# Reassemble
cmd /c "copy /b New-Era.zip.part_001 + New-Era.zip.part_002 + New-Era.zip.part_003 + New-Era.zip.part_004 + New-Era.zip.part_005 New-Era.zip"

# Verify integrity (must match the SHA-256 above)
Get-FileHash -Algorithm SHA256 New-Era.zip

# Extract to a SHORT root path (recommended: C:\NE\ or your PMDO MODS folder)
Expand-Archive -Path New-Era.zip -DestinationPath C:\NE\ -Force

# Move the extracted New-Era folder into PMDO's MODS directory
Move-Item C:\NE\New-Era D:\PMDOSetup\PMDO\MODS\
```

## Download and reassemble — Linux / macOS / WSL

```bash
# Grab all 5 parts (raw file download URL on each part page in GitHub)
# Then reassemble:
cat New-Era.zip.part_001 New-Era.zip.part_002 New-Era.zip.part_003 \
    New-Era.zip.part_004 New-Era.zip.part_005 > New-Era.zip

# Verify (must match)
sha256sum New-Era.zip
# 543972a8c2bec962f41e375e1208a6dd51065278bebd49756a6ea5445f09cf3c  New-Era.zip

# Extract
unzip New-Era.zip
```

## Alternative: `curl` one-liner via raw file URLs

If you prefer scripting on Linux/macOS/WSL:

```bash
BASE="https://raw.githubusercontent.com/meromoonmeri/new-era-abyss-to-ascension-V4/arena/01a0337b-new-era-abyss-to-ascension-v4/dist/windows-package"
for n in 001 002 003 004 005; do
  curl -LO "${BASE}/New-Era.zip.part_${n}"
done
cat New-Era.zip.part_* > New-Era.zip
sha256sum New-Era.zip  # must show 543972a8c2bec962f41e375e1208a6dd51065278bebd49756a6ea5445f09cf3c
```

## Final on-disk layout

Once extracted and placed under your PMDO MODS folder:

```
D:\PMDOSetup\PMDO\MODS\New-Era\Mod.xml
D:\PMDOSetup\PMDO\MODS\New-Era\Data\
D:\PMDOSetup\PMDO\MODS\New-Era\Content\
D:\PMDOSetup\PMDO\MODS\New-Era\Strings\
D:\PMDOSetup\PMDO\MODS\New-Era\CONVERSION\
```

`Mod.xml` must be directly under `New-Era\`, not `New-Era\New-Era\`.

Launch PMDO and select **New Era** from **Special Episodes**.
