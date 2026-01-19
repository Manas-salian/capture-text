# OCR Processing Script for Windows
# Usage: ocr_process.ps1 "path\to\image.png"
# Uses Tesseract OCR

param([string]$ImagePath)

if (-not (Test-Path $ImagePath)) { exit 1 }

$tesseract = "C:\Program Files\Tesseract-OCR\tesseract.exe"

if (-not (Test-Path $tesseract)) {
    # Tesseract not found
    exit 1
}

try {
    $text = & $tesseract $ImagePath stdout 2>$null
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
