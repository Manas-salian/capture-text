; OCR Screen Capture - Windows (Simple Version)
; Hotkey: Win + Shift + O
; Uses PowerShell for screen capture - no external dependencies needed

#Requires AutoHotkey v2.0
#SingleInstance Force

CoordMode "Mouse", "Screen"
CoordMode "ToolTip", "Screen"

; Win + Shift + O - Capture and OCR
#+o::CaptureAndOCR()

CaptureAndOCR() {
    ; Store initial mouse position
    MouseGetPos(&clickX, &clickY)
    
    ; Create full-screen transparent blocker to capture all mouse input
    ; This prevents clicking/selecting content underneath during selection
    blockerGui := Gui("+AlwaysOnTop -Caption +ToolWindow -DPIScale +E0x20")
    blockerGui.BackColor := "000000"
    
    ; Get full virtual screen bounds (all monitors)
    sysX := SysGet(76)  ; SM_XVIRTUALSCREEN
    sysY := SysGet(77)  ; SM_YVIRTUALSCREEN  
    sysW := SysGet(78)  ; SM_CXVIRTUALSCREEN
    sysH := SysGet(79)  ; SM_CYVIRTUALSCREEN
    
    ; Show blocker covering entire screen
    blockerGui.Show("x" sysX " y" sysY " w" sysW " h" sysH " NoActivate")
    WinSetTransparent(1, blockerGui)  ; Nearly invisible but blocks input
    
    ; Remove click-through so it captures mouse events
    WinSetExStyle("-0x20", blockerGui)  ; Remove WS_EX_TRANSPARENT
    
    ; Create selection overlay with -DPIScale to match raw screen coordinates
    selectGui := Gui("+AlwaysOnTop -Caption +ToolWindow -DPIScale")
    selectGui.BackColor := "0078D4"
    
    ; Show instruction
    ToolTip "Click and drag to select region for OCR", clickX + 20, clickY + 20
    
    ; Wait for mouse button down
    while !GetKeyState("LButton", "P") {
        MouseGetPos(&clickX, &clickY)
        ToolTip "Click and drag to select region for OCR", clickX + 20, clickY + 20
        Sleep 10
        
        ; Allow ESC to cancel
        if GetKeyState("Escape", "P") {
            ToolTip
            selectGui.Destroy()
            blockerGui.Destroy()
            return
        }
    }
    
    ; Got mouse down - record start position
    MouseGetPos(&startX, &startY)
    ToolTip  ; Hide instruction
    
    ; Show selection rectangle at exact mouse position
    selectGui.Show("x" startX " y" startY " w1 h1 NoActivate")
    WinSetTransparent(80, selectGui)
    
    ; Track mouse movement while button held
    while GetKeyState("LButton", "P") {
        MouseGetPos(&currentX, &currentY)
        
        ; Calculate rectangle bounds
        left := Min(startX, currentX)
        top := Min(startY, currentY)
        width := Max(1, Abs(currentX - startX))
        height := Max(1, Abs(currentY - startY))
        
        ; Update selection rectangle position and size
        selectGui.Move(left, top, width, height)
        
        Sleep 10
    }
    
    ; Mouse released - get final position
    MouseGetPos(&endX, &endY)
    
    ; Hide and destroy both GUIs
    selectGui.Destroy()
    blockerGui.Destroy()
    
    ; Calculate final capture region
    captureX := Min(startX, endX)
    captureY := Min(startY, endY)
    captureW := Abs(endX - startX)
    captureH := Abs(endY - startY)
    
    ; Validate selection size
    if (captureW < 10 || captureH < 10) {
        ToolTip "Selection too small!"
        SetTimer () => ToolTip(), -1500
        return
    }
    
    ; Wait for screen to settle after overlay removal
    Sleep 200
    
    ; Show progress
    ToolTip "Capturing region..."
    
    ; Define file paths
    tempFile := A_Temp "\ocr_capture.png"
    captureScript := A_ScriptDir "\capture_screen.ps1"
    ocrScript := A_ScriptDir "\ocr_process.ps1"
    
    ; Delete old temp file if exists
    try FileDelete(tempFile)
    
    ; Run capture script with parameters
    captureCmd := Format('powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "{1}" -x {2} -y {3} -w {4} -h {5} -o "{6}"',
        captureScript, captureX, captureY, captureW, captureH, tempFile)
    
    RunWait(captureCmd,, "Hide")
    
    ; Verify capture succeeded
    if !FileExist(tempFile) {
        ToolTip "Capture failed! Check coordinates."
        SetTimer () => ToolTip(), -2000
        return
    }
    
    ; Show OCR progress
    ToolTip "Running OCR..."
    
    ; Run OCR script
    ocrCmd := Format('powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "{1}" "{2}"',
        ocrScript, tempFile)
    
    RunWait(ocrCmd,, "Hide")
    
    ; Cleanup temp file
    try FileDelete(tempFile)
    
    ; Done!
    ToolTip "Text copied to clipboard!"
    SetTimer () => ToolTip(), -1500
}
