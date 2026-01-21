[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectPath,
    [string]$EngineRoot,
    [string]$Target = "Editor",
    [string]$Platform = "Win64",
    [string]$Configuration = "Development",
    [string[]]$ExtraArgs,
    [string]$ArchiveDir,
    [switch]$UseUAT,
    [switch]$DryRun
)

if (-not $EngineRoot) {
    $EngineRoot = $env:UE_ENGINE_ROOT
}
if (-not $EngineRoot -and -not $DryRun) {
    throw "EngineRoot is required. Pass -EngineRoot or set UE_ENGINE_ROOT."
}

$projectName = [IO.Path]::GetFileNameWithoutExtension($ProjectPath)
if ([string]::IsNullOrWhiteSpace($projectName)) {
    throw "ProjectPath must point to a .uproject file."
}

if ($DryRun) {
    $buildBat = "$EngineRoot/Engine/Build/BatchFiles/Build.bat"
    $uatBat = "$EngineRoot/Engine/Build/BatchFiles/RunUAT.bat"
} else {
    $buildBat = Join-Path $EngineRoot "Engine/Build/BatchFiles/Build.bat"
    $uatBat = Join-Path $EngineRoot "Engine/Build/BatchFiles/RunUAT.bat"
}

if (-not $DryRun) {
    if (-not (Test-Path $ProjectPath)) {
        throw "ProjectPath not found: $ProjectPath"
    }
    if (-not (Test-Path $buildBat)) {
        throw "Build.bat not found: $buildBat"
    }
    if ($UseUAT -and -not (Test-Path $uatBat)) {
        throw "RunUAT.bat not found: $uatBat"
    }
}

if ($UseUAT) {
    $tool = $uatBat
    $args = @(
        "BuildCookRun",
        "-project=$ProjectPath",
        "-noP4",
        "-platform=$Platform",
        "-clientconfig=$Configuration",
        "-build",
        "-cook",
        "-stage",
        "-pak",
        "-archive"
    )
    if ($ArchiveDir) {
        $args += "-archivedirectory=$ArchiveDir"
    }
} else {
    $tool = $buildBat
    $targetName = if ($Target -eq "Editor") { "$projectName`Editor" } else { $Target }
    $args = @(
        $targetName,
        $Platform,
        $Configuration,
        "-Project=$ProjectPath",
        "-WaitMutex",
        "-FromMsBuild"
    )
}

if ($ExtraArgs) {
    $args += $ExtraArgs
}

$pretty = "`"$tool`" " + ($args -join " ")
if ($DryRun) {
    Write-Host "[DryRun] $pretty"
    exit 0
}

Write-Host $pretty
& $tool @args
if ($LASTEXITCODE -ne 0) {
    throw "UE build failed with exit code $LASTEXITCODE"
}
