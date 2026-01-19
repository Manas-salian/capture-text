# OCR Processing Script for Windows
# Usage: ocr_process.ps1 "path\to\image.png"
# Uses ImageMagick for preprocessing + Tesseract OCR

param([string]$ImagePath)

if (-not (Test-Path $ImagePath)) { exit 1 }

$tesseract = "C:\Program Files\Tesseract-OCR\tesseract.exe"
$magick = "C:\Program Files\ImageMagick-7.1.2-Q16-HDRI\magick.exe"

if (-not (Test-Path $tesseract)) { exit 1 }

try {
    $processedImage = $ImagePath
    
    # Preprocess with ImageMagick if available
    if (Test-Path $magick) {
        $processedImage = "$env:TEMP\ocr_processed.png"
        & $magick $ImagePath -resize 300% -colorspace Gray -auto-level -contrast-stretch "1.5%x1.5%" -brightness-contrast 0x25 -sharpen 0x1.0 -type Grayscale -density 300 $processedImage 2>$null
    }
    
    $text = & $tesseract $processedImage stdout 2>$null
    
    # Cleanup processed image
    if ($processedImage -ne $ImagePath -and (Test-Path $processedImage)) {
        Remove-Item $processedImage -Force -ErrorAction SilentlyContinue
    }
    
    if (-not [string]::IsNullOrWhiteSpace($text)) {
        Set-Clipboard -Value $text.Trim()
        exit 0
    }
}
catch {
    # OCR failed
}

Set-Clipboard -Value ""
exit 1
