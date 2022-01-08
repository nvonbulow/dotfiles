$ErrorActionPreference = 'Stop';

if (($PSVersionTable.PSVersion.Major) -lt 5) {
    Write-Warning "PowerShell 5 or later is required to run this install script."
    Write-Warning "Please upgrade: https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell"
    break
}

function Test-CommandExists {
    param(
        [string]$commandName
    )

    $oldPref = $ErrorActionPreference
    $ErrorActionPreference = 'Stop'

    try {
        if (Get-Command $commandName) {
            return $true
        }
    }
    catch {
        return $false
    }
    finally {
        $ErrorActionPreference = $oldPref
    }
}

# Install chezmoi if it's not already installed
if (-not (Test-CommandExists 'chezmoi')) {
    $BinDir = "~\.local\bin"
    $ChezmoiBin = Join-Path $BinDir 'chezmoi'
    "`$params = `"-BinDir ${BinDir}`"", (Invoke-WebRequest https://git.io/chezmoi.ps1).Content | powershell -c -
}
else {
    $ChezmoiBin = 'chezmoi'
}

$ChezmoiInitCmd = "$ChezmoiBin init --apply --source=$PSScriptRoot"
Invoke-Expression $ChezmoiInitCmd
