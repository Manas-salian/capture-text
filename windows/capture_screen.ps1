# Screen Capture Script
# Usage: capture_screen.ps1 -x X -y Y -w WIDTH -h HEIGHT -o OUTPUT
param(
    [int]$x,
    [int]$y,
    [int]$w,
    [int]$h,
    [string]$o
)

Add-Type -AssemblyName System.Drawing

try {
    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CopyFromScreen($x, $y, 0, 0, [System.Drawing.Size]::new($w, $h))
    $bmp.Save($o, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    exit 0
}
catch {
    Write-Error $_.Exception.Message
    exit 1
}
