<#
.SYNOPSIS
    Clone (and optionally install) the whole dsh-qq-suite family.

.DESCRIPTION
    - Default: git clone every repo into .\repos\<name>
    - -Tools:  also `npm install` where node_modules are needed, and
               `npm i -g github:whatxin7/<repo>` for the six CLI tools.

    It does NOT touch config files, PATH, or system services.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File install.ps1
    powershell -ExecutionPolicy Bypass -File install.ps1 -Tools
    powershell -ExecutionPolicy Bypass -File install.ps1 -Tools -Dir D:\tools
#>
[CmdletBinding()]
param(
    [switch]$Tools,
    [string]$Dir = '',
    [string]$Owner = 'whatxin7'
)

$ErrorActionPreference = 'Stop'
function Say($t, $c = 'Gray') { Write-Host $t -ForegroundColor $c }

$git = 'git'
if (-not (Get-Command git -ErrorAction SilentlyContinue) -and (Test-Path 'C:\Program Files\Git\cmd\git.exe')) {
    $git = 'C:\Program Files\Git\cmd\git.exe'
}
if (-not (Get-Command $git -ErrorAction SilentlyContinue)) {
    Say 'git not found. Install it first:  winget install --id Git.Git -e' 'Red'
    exit 1
}
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Say 'node not found. These tools need Node >= 20:  winget install --id OpenJS.NodeJS.LTS -e' 'Red'
    exit 1
}
Say ("node " + (node --version) + " / " + (& $git --version)) 'DarkGray'

$root = if ($Dir) { $Dir } else { Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) 'repos' }
New-Item -ItemType Directory -Force -Path $root | Out-Null
Say ("target: " + $root) 'White'

# name = needs npm install (has real deps)
$repos = [ordered]@{
    'dsh-token-meter'    = $false
    'dsh-qq-access'      = $false
    'dsh-qq-voice'       = $false
    'dsh-qq-stickers'    = $false
    'dsh-mcp-safe-tools' = $true
    'dsh-session-link'   = $false
    'dsh-persona-kit'    = $true
    'dsh-qq-suite'       = $false
}

# the six CLI tools (bin name -> repo)
$cli = [ordered]@{
    'dsh-token-meter'  = 'token-meter'
    'dsh-qq-access'    = 'qq-access'
    'dsh-qq-voice'     = 'voice'
    'dsh-qq-stickers'  = 'sticker'
    'dsh-session-link' = 'session-link'
    'dsh-persona-kit'  = 'persona'
}

foreach ($name in $repos.Keys) {
    $dest = Join-Path $root $name
    Say "-- $name" 'White'
    if (Test-Path (Join-Path $dest '.git')) {
        Say '  exists, pulling' 'DarkGray'
        Push-Location $dest; try { & $git pull --ff-only } finally { Pop-Location }
    } else {
        & $git clone "https://github.com/$Owner/$name.git" $dest
        if ($LASTEXITCODE -ne 0) { Say '  clone failed' 'Red'; continue }
    }
    if ($repos[$name]) {
        Push-Location $dest
        try { npm install --no-audit --no-fund | Out-Null; Say '  npm install done' 'DarkGray' } finally { Pop-Location }
    }
    Say ''
}

if ($Tools) {
    Say '== installing global commands' 'White'
    foreach ($name in $cli.Keys) {
        Say ("  npm i -g github:$Owner/$name  ->  " + $cli[$name]) 'DarkCyan'
        npm i -g "github:$Owner/$name" --no-audit --no-fund | Out-Null
        if ($LASTEXITCODE -ne 0) { Say '  install failed' 'Red' }
    }
    Say ''
    Say 'verify:' 'White'
    foreach ($cmd in $cli.Values) { Say ("  $cmd --help") 'DarkGray' }
}

Say 'done.' 'Green'
Say 'Docs: https://github.com/whatxin7/dsh-qq-suite/blob/main/INSTALL.md' 'DarkGray'
