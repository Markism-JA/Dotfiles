; =================================================================================
;                                SCRIPT CONFIGURATION
;                               (Auto-Execute Section)
; =================================================================================
#SingleInstance Force
#Warn
SendMode Input
SetWorkingDir A_ScriptDir

; --- ONE-TIME SETUP: CREATE THE CUSTOM GUI ---
; We add '+HwndOfficeMenuHwnd' to get a reliable unique ID for our window.
; Added '+toolwindow' for a cleaner look, often removing default window borders
; that might interfere with perfect rounding.
Gui, OfficeMenu:New, +AlwaysOnTop -Caption +HwndOfficeMenuHwnd +toolwindow
Gui, OfficeMenu:Color, FFFFFF ; Changed from F8F8F8 to FFFFFF (pure white)
Gui, OfficeMenu:Font, s11 c0x222222, Segoe UI Variable

; Add spacing at the top
Gui, OfficeMenu:Add, Text, w0 h10

; Add buttons to the GUI
Gui, OfficeMenu:Add, Button, w200 h45 gLaunchWord, Word
Gui, OfficeMenu:Add, Button, w200 h45 gLaunchExcel, Excel
Gui, OfficeMenu:Add, Button, w200 h45 gLaunchPowerPoint, PowerPoint
Gui, OfficeMenu:Add, Button, w200 h45 gLaunchOutlook, Outlook

; Add spacing at the Bottom
Gui, OfficeMenu:Add, Text, w0 h10

; *** NEW SECTION FOR ROUNDING ***
; This uses the Windows Desktop Window Manager (DWM) API to apply system-native
; rounded corners. This is the modern method and works best on Windows 11.
; 33 = DWMWA_WINDOW_CORNER_PREFERENCE
; 2 = DWMWCP_ROUND
DwmSetWindowAttribute_WindowCornerPreference := 33
DWMWCP_ROUND := 2
DllCall("Dwmapi\DwmSetWindowAttribute", "Ptr", OfficeMenuHwnd, "UInt", DwmSetWindowAttribute_WindowCornerPreference, "UInt*", DWMWCP_ROUND, "UInt", 4)

return


; =================================================================================
;                                     HOTKEYS
; =================================================================================

; --- Application Hotkeys ---
#Enter::Run, "wt.exe"
#c::Run, "code"
#w::Run, "firefox.exe"
^#x::Run, "notepad.exe"

; --- Office Menu Hotkey ---
#o::Gui, OfficeMenu:Show, Center, Office Launcher


; --- Window Management ---
#q::WinClose, A

; --- System Hotkeys ---
^!p::
    ; Directly activate the desktop window (Program Manager). This is not a simulation.
    WinActivate, ahk_class Progman
    ; Now that the desktop is guaranteed to be active, send the keystroke.
    Send, !{F4}
return

; --- Workspace/Virtual Desktop Management ---
#PgDn::Send, #^{Right} ; Win + Page Down to go to the next desktop
#PgUp::Send, #^{Left}  ; Win + Page Up to go to the previous desktop
+#d::Send, #^d          ; Win + Shift + D to CREATE a new desktop
+#q::Send, #^{F4}      ; Win + Shift + Q to CLOSE the current desktop

; --- Task Manager Hotkey ---
#t::
    KeyWait, LWin  ; Wait for the Left Windows key to be physically released
    KeyWait, RWin  ; Also wait for the Right Windows key, just in case
    Run, "taskmgr.exe"
return

; --- Open System Tray Hotkey ---
^!b:: ; This is now Ctrl + Alt + B
    Send, #b      ; The native Windows shortcut to focus the notification area.
    Sleep, 200    ; Increased delay for better reliability.
    Send, {Enter} ; Sends Enter to expand the "Show hidden icons" chevron.
return


; =================================================================================
;                    CONTEXT-SENSITIVE ESCAPE KEY
; This block makes the Escape key ONLY work when our Office Menu is active.
; =================================================================================
#If WinActive("ahk_id " . OfficeMenuHwnd)
    Escape::Gui, OfficeMenu:Hide
#If ; This turns off the context-sensitivity for any hotkeys below.


; =================================================================================
;                                   SUBROUTINES
; =================================================================================

LaunchWord:
    Gui, OfficeMenu:Hide
    Run, "winword.exe"
return

LaunchExcel:
    Gui, OfficeMenu:Hide
    Run, "excel.exe"
return

LaunchPowerPoint:
    Gui, OfficeMenu:Hide
    Run, "powerpnt.exe"
return

LaunchOutlook:
    Gui, OfficeMenu:Hide
    Run, "outlook.exe"
return