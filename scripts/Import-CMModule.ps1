# MECM Configuration Manager Module Loader
# Attempts to load the Configuration Manager module using multiple methods
# Usage: . .\Import-CMModule.ps1 -SiteCode "PS1"

param(
    [Parameter(Mandatory = $true)]
    [string]$SiteCode
)

try {
    $CMModulePath = $env:SMS_ADMIN_UI_PATH
    if ($CMModulePath) {
        $CMModulePath = $CMModulePath.Replace("\bin\i386", "\bin\ConfigurationManager.psd1")
        if (Test-Path $CMModulePath) {
            Import-Module $CMModulePath -Force
            Write-Host "Configuration Manager module loaded successfully using environment variable path." -ForegroundColor Green
        } else {
            throw "Module path from environment variable not found"
        }
    } else {
        throw "SMS_ADMIN_UI_PATH environment variable not found"
    }
}
catch {
    Write-Host "Failed to load module using environment variable path. Attempting fallback method..." -ForegroundColor Yellow

    try {
        Import-Module ConfigurationManager -Force
        Write-Host "Configuration Manager module loaded successfully using Import-Module ConfigurationManager." -ForegroundColor Green
    }
    catch {
        Write-Host "ERROR: Failed to load Configuration Manager module using both methods." -ForegroundColor Red
        Write-Host "Please ensure SCCM/MECM Console is installed and SMS_ADMIN_UI_PATH environment variable is set correctly." -ForegroundColor Red
        exit 1
    }
}

Set-Location "$($SiteCode):\"
