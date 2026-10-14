# ======================================================================
# Script : launch.ps1
# Source : 2kclient.exe
# Type   : Executable (.exe)
# Author : PsForge
# Built  : 2026-10-14 17:15:00
# Builder: PsForge v1.0.0 — https://psforge.local
#
# Launches the program above as a PowerShell-wrapped process.
# Re-generate anytime in PsForge; this file is self-contained.
# ======================================================================

#requires -Version 5.1
using namespace System.Diagnostics;

# Execution policy for THIS run is set below; the script can be invoked directly.
$ExecutionPolicy = 'Bypass'
try { Set-ExecutionPolicy -Scope Process -ExecutionPolicy $ExecutionPolicy -Force -ErrorAction Stop } catch {}

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# --- Resolve the source program path ---
$SourcePath = '${psEscapeSingle(src)}'
if (-not [System.IO.Path]::IsPathRooted($SourcePath)) {
    $SourcePath = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot $SourcePath))
}
if (-not (Test-Path -LiteralPath $SourcePath)) {
    Write-Host "[PsForge] Source file not found: $SourcePath" -ForegroundColor Red
    exit 2
}

# Working directory defaults to the source file's folder
$WorkingDirectory = (Split-Path -Parent $SourcePath)

# Pass through any args given to this script:  .\launch.ps1 -Args '--foo --bar'
param(
    [string[]] $Args
)
$Arguments = ($Args -join ' ').Trim()

# --- Build the process start info ---
$psi = [ProcessStartInfo]::new()
$psi.FileName = $SourcePath
$psi.WorkingDirectory = $WorkingDirectory
$psi.UseShellExecute = $false
if ($Arguments) { $psi.Arguments = $Arguments }
$psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden

# --- Launch ---
Write-Host "[PsForge] Launching: $SourcePath" -ForegroundColor Cyan
if ($WorkingDirectory) { Write-Host "[PsForge] WorkingDir: $WorkingDirectory" -ForegroundColor DarkGray }

$process = [Process]::new()
$process.StartInfo = $psi
[void]$process.Start()

# Fire-and-forget: do not wait for the program to exit
Write-Host "[PsForge] Launched (PID $($process.Id)). Not waiting for exit." -ForegroundColor Green
exit 0