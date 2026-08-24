# ============================================================================
#  New Era: Abyss to Ascension - PowerShell installer
#
#  Invoked by New-Era-Installer.bat. Behaves like a real fangame installer:
#  reassembles the split ZIP parts, verifies SHA-256, detects PMDO, prompts
#  the user for the install directory, extracts the mod, verifies the
#  layout, registers an uninstall entry, and optionally creates a Start
#  Menu / Desktop shortcut that launches PMDO.
#
#  Requires PowerShell 5.1+ (shipped with Windows 10 / Server 2016+, and
#  installable on Windows 7 SP1+). No third-party module required.
# ============================================================================

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$InstallerRoot,

    [string]$InstallDir = "",           # optional, skips the prompt if set
    [switch]$Silent,                    # non-interactive install
    [switch]$Uninstall                  # trigger uninstall path
)

$ErrorActionPreference = "Stop"
$AppName        = "New Era: Abyss to Ascension"
$AppShort       = "New-Era"
$AppVersion     = "0.5.1"
$AppPublisher   = "Minori"
$ExpectedZipSha = "19ff0fade7a45fa23e30ace16fdb01a495966cc1278bcad205363cbfe95e3428"
$ExpectedZipSize= 454104728
$PmdoExeName    = "PMDO.exe"
$RegKey         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\NewEra_AbyssToAscension"


function Write-Section([string]$Msg) {
    Write-Host ""
    Write-Host ("=" * 72) -ForegroundColor Cyan
    Write-Host $Msg -ForegroundColor Cyan
    Write-Host ("=" * 72) -ForegroundColor Cyan
}


function Reassemble-Parts {
    param([string]$SrcDir, [string]$DstFile)

    $parts = Get-ChildItem -Path $SrcDir -Filter "$AppShort.zip.part_*" |
        Sort-Object Name
    if ($parts.Count -lt 2) {
        throw "Expected at least 2 split parts named $AppShort.zip.part_XXX in $SrcDir, found $($parts.Count)."
    }
    Write-Host "Reassembling $($parts.Count) parts into $DstFile ..."

    if (Test-Path $DstFile) { Remove-Item -Force $DstFile }
    $out = [System.IO.File]::Create($DstFile)
    try {
        foreach ($p in $parts) {
            $in = [System.IO.File]::OpenRead($p.FullName)
            try {
                $in.CopyTo($out)
            } finally { $in.Dispose() }
            Write-Host ("  + {0} ({1:N0} bytes)" -f $p.Name, $p.Length)
        }
    } finally { $out.Dispose() }

    $size = (Get-Item $DstFile).Length
    if ($size -ne $ExpectedZipSize) {
        throw "Reassembled size $size does not match expected $ExpectedZipSize."
    }

    Write-Host "Verifying SHA-256 ..."
    $actual = (Get-FileHash -Algorithm SHA256 $DstFile).Hash.ToLower()
    if ($actual -ne $ExpectedZipSha) {
        throw "SHA-256 mismatch. Got $actual, expected $ExpectedZipSha. Aborting install."
    }
    Write-Host "  OK ($actual)" -ForegroundColor Green
}


function Detect-Pmdo {
    # Candidate locations, most specific first.
    $candidates = @()
    foreach ($drive in @("C","D","E","F","G","H")) {
        $candidates += "${drive}:\PMDOSetup\PMDO"
        $candidates += "${drive}:\PMDO"
        $candidates += "${drive}:\Games\PMDO"
        $candidates += "${drive}:\Pokemon\PMDO"
    }
    $candidates += Join-Path $env:LOCALAPPDATA "PMDO"
    $candidates += Join-Path $env:APPDATA      "PMDO"
    $candidates += Join-Path $env:USERPROFILE  "Documents\PMDO"
    $candidates += Join-Path $env:USERPROFILE  "Desktop\PMDO"

    foreach ($c in $candidates) {
        if (Test-Path (Join-Path $c $PmdoExeName)) { return $c }
    }
    return $null
}


function Prompt-InstallDir {
    param([string]$Default)
    Write-Host ""
    Write-Host "Le mod va etre installe dans :"
    Write-Host "    $Default" -ForegroundColor Yellow
    Write-Host ""
    $reply = Read-Host "Appuyez sur ENTREE pour accepter, ou tapez un autre chemin absolu"
    if ([string]::IsNullOrWhiteSpace($reply)) { return $Default }
    return $reply.Trim('"').TrimEnd('\')
}


function Ensure-ParentDir {
    param([string]$Path)
    $parent = Split-Path -Parent $Path
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }
}


function Install-Mod {
    param([string]$ZipPath, [string]$Target)

    if (Test-Path $Target) {
        Write-Host ""
        Write-Host "Le dossier cible existe deja :" -ForegroundColor Yellow
        Write-Host "  $Target"
        if (-not $Silent) {
            $c = Read-Host "L'ecraser ? Toute personnalisation existante sera perdue (o/N)"
            if ($c -notmatch '^[oOyY]') {
                throw "Installation annulee par l'utilisateur."
            }
        }
        Remove-Item -Recurse -Force $Target
    }

    Ensure-ParentDir $Target

    $stage = Join-Path $env:TEMP ("NewEra_stage_" + [Guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Force -Path $stage | Out-Null
    try {
        Write-Host "Extraction vers un dossier temporaire ..."
        Expand-Archive -Path $ZipPath -DestinationPath $stage -Force

        # The zip has a single top-level "New-Era" folder. Guard against
        # a double-nested "New-Era/New-Era".
        $inner = Join-Path $stage $AppShort
        if (-not (Test-Path $inner)) {
            throw "Le zip ne contient pas de dossier racine '$AppShort'."
        }
        $modxml = Join-Path $inner "Mod.xml"
        if (-not (Test-Path $modxml)) {
            throw "Mod.xml introuvable dans $inner. Le zip est peut-etre corrompu."
        }

        Write-Host "Deplacement vers :"
        Write-Host "    $Target"
        Move-Item -Force $inner $Target
    } finally {
        Remove-Item -Recurse -Force $stage -ErrorAction SilentlyContinue
    }

    $installedModxml = Join-Path $Target "Mod.xml"
    if (-not (Test-Path $installedModxml)) {
        throw "Verification post-install echouee : $installedModxml manquant."
    }
    Write-Host "Installation OK." -ForegroundColor Green
}


function Register-Uninstall {
    param([string]$Target, [string]$InstallerPath)

    New-Item -Path $RegKey -Force | Out-Null
    Set-ItemProperty -Path $RegKey -Name "DisplayName"     -Value "$AppName $AppVersion"
    Set-ItemProperty -Path $RegKey -Name "DisplayVersion"  -Value $AppVersion
    Set-ItemProperty -Path $RegKey -Name "Publisher"       -Value $AppPublisher
    Set-ItemProperty -Path $RegKey -Name "InstallLocation" -Value $Target
    Set-ItemProperty -Path $RegKey -Name "NoModify"        -Value 1 -Type DWord
    Set-ItemProperty -Path $RegKey -Name "NoRepair"        -Value 1 -Type DWord
    # UninstallString points back at us with -Uninstall.
    $uninstallCmd = "powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File `"$InstallerPath`" -InstallerRoot `"$(Split-Path -Parent $InstallerPath)`" -Uninstall -InstallDir `"$Target`""
    Set-ItemProperty -Path $RegKey -Name "UninstallString" -Value $uninstallCmd

    Write-Host "Desinstalleur enregistre :"
    Write-Host "    Panneau de configuration -> Programmes -> $AppName $AppVersion"
}


function Create-Shortcuts {
    param([string]$Target)

    $pmdoRoot = Split-Path -Parent (Split-Path -Parent $Target)   # <PMDO>\MODS\New-Era -> <PMDO>
    $pmdoExe  = Join-Path $pmdoRoot $PmdoExeName
    if (-not (Test-Path $pmdoExe)) {
        Write-Host "PMDO.exe introuvable a $pmdoExe, raccourcis non crees."
        return
    }

    if (-not $Silent) {
        $c = Read-Host "Creer un raccourci menu Demarrer 'Jouer a New Era' ? (O/n)"
        if ($c -match '^[nN]') { return }
    }

    $wshell = New-Object -ComObject WScript.Shell
    $startMenu = [Environment]::GetFolderPath('Programs')
    $lnk = Join-Path $startMenu "Jouer a New Era.lnk"
    $shortcut = $wshell.CreateShortcut($lnk)
    $shortcut.TargetPath       = $pmdoExe
    $shortcut.WorkingDirectory = $pmdoRoot
    $shortcut.Description      = "Lance PMDO avec le mod New Era: Abyss to Ascension"
    $shortcut.Save()
    Write-Host "Raccourci Menu Demarrer : $lnk"
}


function Do-Uninstall {
    param([string]$Target)

    Write-Section "Desinstallation de $AppName"

    if (Test-Path $Target) {
        if (-not $Silent) {
            $c = Read-Host "Supprimer definitivement '$Target' ? (o/N)"
            if ($c -notmatch '^[oOyY]') {
                Write-Host "Desinstallation annulee."
                return
            }
        }
        Remove-Item -Recurse -Force $Target
        Write-Host "Dossier supprime."
    } else {
        Write-Host "Dossier '$Target' inexistant, rien a supprimer."
    }

    if (Test-Path $RegKey) {
        Remove-Item -Recurse -Force $RegKey
        Write-Host "Entree de desinstallation retiree du registre."
    }

    $startMenu = [Environment]::GetFolderPath('Programs')
    $lnk = Join-Path $startMenu "Jouer a New Era.lnk"
    if (Test-Path $lnk) { Remove-Item -Force $lnk }

    Write-Host "Desinstallation terminee." -ForegroundColor Green
}


# --------------------------------------------------------- main flow

Write-Section "$AppName $AppVersion - Installateur Windows"

if ($Uninstall) {
    if ([string]::IsNullOrWhiteSpace($InstallDir)) {
        try {
            $InstallDir = (Get-ItemProperty -Path $RegKey -Name InstallLocation `
                          -ErrorAction Stop).InstallLocation
        } catch {
            Write-Host "Aucune installation trouvee dans le registre. Rien a faire."
            exit 0
        }
    }
    Do-Uninstall -Target $InstallDir
    exit 0
}

# 1. Reassemble + verify integrity of the zip.
$tempZip = Join-Path $env:TEMP "New-Era_install.zip"
try {
    Reassemble-Parts -SrcDir $InstallerRoot -DstFile $tempZip

    # 2. Choose install directory.
    if ([string]::IsNullOrWhiteSpace($InstallDir)) {
        $pmdoRoot = Detect-Pmdo
        if ($pmdoRoot) {
            Write-Host "PMDO detecte sous : $pmdoRoot" -ForegroundColor Green
            $default = Join-Path $pmdoRoot "MODS\$AppShort"
        } else {
            Write-Host "PMDO non detecte automatiquement." -ForegroundColor Yellow
            $default = "D:\PMDOSetup\PMDO\MODS\$AppShort"
        }
        if ($Silent) {
            $InstallDir = $default
        } else {
            $InstallDir = Prompt-InstallDir -Default $default
        }
    }

    # 3. Install.
    Install-Mod -ZipPath $tempZip -Target $InstallDir

    # 4. Register uninstall entry + optional shortcuts.
    $installerPs1 = Join-Path $InstallerRoot "New-Era-Installer.ps1"
    Register-Uninstall -Target $InstallDir -InstallerPath $installerPs1
    Create-Shortcuts -Target $InstallDir

    Write-Section "Installation terminee"
    Write-Host "Lancez PMDO puis choisissez 'Special Episodes' -> '$AppName'." -ForegroundColor Green
    exit 0

} finally {
    if (Test-Path $tempZip) { Remove-Item -Force $tempZip -ErrorAction SilentlyContinue }
}
