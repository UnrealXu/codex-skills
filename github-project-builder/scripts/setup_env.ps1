[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectRoot,
    [string]$EnvName,
    [switch]$UseConda
)

if (-not (Test-Path $ProjectRoot)) {
    throw "ProjectRoot not found: $ProjectRoot"
}

if (-not $EnvName) {
    $EnvName = Split-Path $ProjectRoot -Leaf
}

$pyproject = Join-Path $ProjectRoot "pyproject.toml"
$requirements = Join-Path $ProjectRoot "requirements.txt"
$environment = Join-Path $ProjectRoot "environment.yml"

if ($UseConda -or (Test-Path $environment)) {
    if (-not (Get-Command conda -ErrorAction SilentlyContinue)) {
        throw "conda not found in PATH."
    }
    if (Test-Path $environment) {
        & conda env create -f $environment -n $EnvName
    } else {
        & conda create -y -n $EnvName python=3.10
        & conda run -n $EnvName python -m pip install -U pip
        if (Test-Path $requirements) {
            & conda run -n $EnvName python -m pip install -r $requirements
        } elseif (Test-Path $pyproject) {
            & conda run -n $EnvName python -m pip install -e $ProjectRoot
        }
    }
    exit $LASTEXITCODE
}

$venv = Join-Path $ProjectRoot ".venv"
if (-not (Test-Path $venv)) {
    & python -m venv $venv
}

$pip = Join-Path $venv "Scripts/pip.exe"
$python = Join-Path $venv "Scripts/python.exe"
& $python -m pip install -U pip
if (Test-Path $requirements) {
    & $pip install -r $requirements
} elseif (Test-Path $pyproject) {
    & $pip install -e $ProjectRoot
}
