# Windows Dependencies Installer (using winget)
# Installs: AutoHotkey, ImageMagick, and Tesseract OCR

Write-Host "=== Windows Dependencies Installer ===" -ForegroundColor Green
Write-Host "Installing: AutoHotkey, ImageMagick, Tesseract OCR`n" -ForegroundColor Cyan

# Check if winget is available
try {
    $wingetVersion = winget --version
    Write-Host "winget version: $wingetVersion`n" -ForegroundColor Green
} catch {
    Write-Host "ERROR: winget is not installed or not available in PATH." -ForegroundColor Red
    Write-Host "Please install winget from the Microsoft Store (App Installer) or update Windows." -ForegroundColor Yellow
    exit 1
}

# Function to install package with winget
function Install-Package {
    param($packageId, $packageName)
    
    Write-Host "=== Installing $packageName ===" -ForegroundColor Cyan
    Write-Host "Package ID: $packageId" -ForegroundColor Yellow
    
    try {
        winget install --id $packageId --exact --silent --accept-package-agreements --accept-source-agreements
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "$packageName installed successfully!`n" -ForegroundColor Green
            return $true
        } else {
            Write-Host "Warning: $packageName installation returned exit code $LASTEXITCODE`n" -ForegroundColor Yellow
            return $false
        }
    } catch {
        Write-Host "ERROR: Failed to install $packageName - $_`n" -ForegroundColor Red
        return $false
    }
}

# Install packages
$packages = @(
    @{Id = "AutoHotkey.AutoHotkey"; Name = "AutoHotkey"},
    @{Id = "ImageMagick.ImageMagick"; Name = "ImageMagick"},
    @{Id = "UB-Mannheim.TesseractOCR"; Name = "Tesseract OCR"}
)

$results = @()
foreach ($pkg in $packages) {
    $success = Install-Package -packageId $pkg.Id -packageName $pkg.Name
    $results += @{Name = $pkg.Name; Success = $success}
}

# Summary
Write-Host "`n=== Installation Summary ===" -ForegroundColor Green
foreach ($result in $results) {
    $status = if ($result.Success) { "[SUCCESS]" } else { "[FAILED]" }
    $color = if ($result.Success) { "Green" } else { "Red" }
    Write-Host "$status - $($result.Name)" -ForegroundColor $color
}

Write-Host "`nNote: You may need to restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
Write-Host "`nInstallation complete!" -ForegroundColor Green