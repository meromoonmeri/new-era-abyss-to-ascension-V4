@ECHO OFF
REM ============================================================================
REM  New Era: Abyss to Ascension - Windows installer (self-contained)
REM
REM  Double-click this .bat to install the mod. It bootstraps a PowerShell
REM  installer stored right next to it (New-Era-Installer.ps1) and forwards
REM  every argument. No Inno Setup, no third-party runtime; only the
REM  PowerShell shipped with Windows 7 SP1 and later is required.
REM
REM  What it does when the user double-clicks:
REM    1. Reassembles the split .zip parts (New-Era.zip.part_001..006)
REM       located in this same folder into a single New-Era.zip in %TEMP%,
REM       verifies SHA-256, aborts on mismatch.
REM    2. Detects the local PMDO installation (registry + drive heuristics).
REM    3. Prompts the user for the install directory (default
REM       <PMDO>\MODS\New-Era or D:\PMDOSetup\PMDO\MODS\New-Era if not found).
REM    4. Extracts the zip to a temp staging directory, verifies Mod.xml is
REM       directly at the root (guards against double-nesting bug), then
REM       moves the New-Era\ folder into place. Refuses to overwrite an
REM       existing New-Era\ without confirmation.
REM    5. Registers an entry in the Windows uninstall list (registry key
REM       HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall) so the
REM       user can uninstall from Control Panel > Programs.
REM    6. Offers to create a Start Menu shortcut ("Play New Era") that
REM       launches PMDO.exe from the detected PMDO root.
REM ============================================================================

SETLOCAL EnableExtensions

SET "SCRIPT_DIR=%~dp0"
IF "%SCRIPT_DIR:~-1%"=="\" SET "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

SET "PS_FILE=%SCRIPT_DIR%\New-Era-Installer.ps1"

IF NOT EXIST "%PS_FILE%" (
    ECHO.
    ECHO [ERROR] New-Era-Installer.ps1 introuvable a cote de ce .bat.
    ECHO         Attendu :   %PS_FILE%
    ECHO         Assurez-vous d'avoir extrait dist\windows-installer\
    ECHO         en entier avant de lancer l'installateur.
    ECHO.
    PAUSE
    EXIT /B 1
)

REM Try to elevate; if the user declines, run without elevation. Registry
REM entries are written under HKCU so admin rights are not strictly required,
REM but PowerShell execution policy sometimes needs -ExecutionPolicy Bypass
REM regardless of elevation.

powershell -NoLogo -NoProfile -ExecutionPolicy Bypass ^
    -File "%PS_FILE%" -InstallerRoot "%SCRIPT_DIR%" %*
SET RET=%ERRORLEVEL%

IF NOT "%RET%"=="0" (
    ECHO.
    ECHO L'installateur a retourne le code d'erreur : %RET%
    PAUSE
)

ENDLOCAL & EXIT /B %RET%
