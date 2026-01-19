# Windows OCR Screen Capture

A Windows equivalent of the Linux `gnome-screenshot + tesseract` OCR workflow. Press **Win + Shift + O** to capture a screen region and copy the recognized text to clipboard.

## Features

- **No visible windows** - everything runs hidden
- **Visual region selection** - semi-transparent overlay for selecting area
- **Dual OCR engines** - Windows built-in OCR (fast, no install) with Tesseract fallback (more accurate)
- **Image preprocessing** - ImageMagick enhancement for better OCR results (optional)
- **Direct clipboard output** - text copied immediately after capture

## Files

| File | Description |
|------|-------------|
| `ocr_capture.ahk` | Main script using GDI+ (faster capture) |
| `ocr_capture_simple.ahk` | Alternative using PowerShell capture (no GDI+ needed) |
| `ocr_process.ps1` | OCR processing script (image preprocessing + OCR) |
| `Gdip_All.ahk` | GDI+ library for AHK v2 (minimal version) |
| `test2.ps1` | Dependency installer (winget) |

## Installation

### 1. Install Dependencies

Run PowerShell as Administrator:

```powershell
# Using winget (recommended)
.\test2.ps1

# Or manually:
winget install AutoHotkey.AutoHotkey
winget install UB-Mannheim.TesseractOCR      # Optional - for better accuracy
winget install ImageMagick.ImageMagick        # Optional - for image preprocessing
```

### 2. Add Tesseract to PATH (if installed)

Add `C:\Program Files\Tesseract-OCR` to your system PATH, or the script will auto-detect common install locations.

### 3. Run the Script

Double-click `ocr_capture.ahk` (or `ocr_capture_simple.ahk` for the simpler version).

## Usage

1. Press **Win + Shift + O**
2. Click and drag to select the area containing text
3. Release the mouse button
4. Text is automatically copied to clipboard
5. Paste anywhere with **Ctrl + V**

## OCR Priority

1. **Windows OCR** (built-in, fast, supports multiple languages based on installed language packs)
2. **Tesseract OCR** with ImageMagick preprocessing (if both installed, more accurate for difficult text)

## Customization

### Change Hotkey

Edit `ocr_capture.ahk` and modify:
```autohotkey
#+o::CaptureAndOCR()  ; Win + Shift + O
```

Common alternatives:
- `#o` - Win + O
- `^!o` - Ctrl + Alt + O
- `#PrintScreen` - Win + PrintScreen

### Add to Startup

1. Press **Win + R**
2. Type `shell:startup`
3. Create a shortcut to `ocr_capture.ahk` in that folder

## Troubleshooting

### "Failed to initialize GDI+"
- Ensure you're running Windows 7 or later
- Try `ocr_capture_simple.ahk` instead (doesn't use GDI+)

### Empty or incorrect OCR results
- Ensure the selected text is clearly visible
- Install Tesseract for better accuracy on difficult text
- Install ImageMagick for image preprocessing

### Script doesn't run
- Ensure AutoHotkey v2 is installed (not v1)
- Right-click the script → "Run with AutoHotkey v2"

## Comparison with Linux Original

| Linux Command | Windows Equivalent |
|---------------|-------------------|
| `gnome-screenshot -af` | GDI+ `Gdip_BitmapFromScreen()` or PowerShell capture |
| `convert ... -resize 300% -colorspace Gray` | ImageMagick `magick` with same parameters |
| `tesseract stdout` | Tesseract or Windows.Media.Ocr |
| `xsel -b -i` | `Set-Clipboard` |

## License

MIT - Use freely
