#Requires AutoHotkey v2.0
#SingleInstance Force

dll := A_ScriptDir "\VirtualDesktopAccessor.dll"

switchDesktop(number) {
    global dll
    ; ASFW_ANY (-1) allows any process to take focus cleanly without flashing
    DllCall("user32\AllowSetForegroundWindow", "Int", -1)
    DllCall(dll "\GoToDesktopNumber", "Int", number - 1, "Int")
}

; --- Virtual Desktop Switching (Alt + 1..9) ---
!1::switchDesktop(1)
!2::switchDesktop(2)
!3::switchDesktop(3)
!4::switchDesktop(4)
!5::switchDesktop(5)
!6::switchDesktop(6)
!7::switchDesktop(7)
!8::switchDesktop(8)
!9::switchDesktop(9)

; --- Media Controls (Win + Alt + J / K / P) ---
#!j::Send("{Media_Prev}")         ; Win + Alt + J -> Previous Track
#!k::Send("{Media_Next}")         ; Win + Alt + K -> Next Track
#!p::Send("{Media_Play_Pause}")   ; Win + Alt + P -> Play / Pause

; --- Maximize / Restore Active Window (Win + F1) ---
#F1:: {
    if !WinActive("A")
        return
    WinGetMinMax("A") = 1 ? WinRestore("A") : WinMaximize("A")
}
