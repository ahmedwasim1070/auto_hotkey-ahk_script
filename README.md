# AutoHotkey Custom Shortcuts

Personal Windows setup for custom keyboard shortcuts using **AutoHotkey v2** and **VirtualDesktopAccessor**.

This repository is designed to make the setup easy to restore on a fresh Windows installation while keeping the required script and DLL together.

---

## Repository Structure

```text
auto_hotkey-ahk_script/
│
├── CustomShortcuts/
│   ├── CustomShortcuts.ahk
│   └── VirtualDesktopAccessor.dll
│
├── Setup/
│   ├── AutoHotkey-Download.url
│   └── VirtualDesktopAccessor-Releases.url
│
└── README.md
```

### Files

| Path | Purpose |
| :--- | :--- |
| `CustomShortcuts/CustomShortcuts.ahk` | Main AutoHotkey v2 script |
| `CustomShortcuts/VirtualDesktopAccessor.dll` | DLL used by the script for Windows Virtual Desktop switching |
| `Setup/AutoHotkey-Download.url` | Opens the AutoHotkey download page |
| `Setup/VirtualDesktopAccessor-Releases.url` | Opens the VirtualDesktopAccessor GitHub Releases page |
| `README.md` | Setup and usage documentation |

---

## Requirements

* Windows 10/11
* [AutoHotkey v2](https://www.autohotkey.com/)
* `VirtualDesktopAccessor.dll`
* Git (only required if cloning/updating this repository)

---

## Installation

### 1. Clone the Repository

Recommended location:

```text
C:\Users\<username>\Tools\CustomShortcuts\auto_hotkey-ahk_script
```

Clone it with PowerShell:

```powershell
cd "$HOME\Tools\CustomShortcuts"
git clone <REPOSITORY-URL> auto_hotkey-ahk_script
```

Enter the repository:

```powershell
cd "$HOME\Tools\CustomShortcuts\auto_hotkey-ahk_script"
```

Verify the structure:

```powershell
ls
```

Expected output:

```text
CustomShortcuts
Setup
README.md
```

---

### 2. Install AutoHotkey v2

Open:

```text
Setup\AutoHotkey-Download.url
```

Install **AutoHotkey v2**.

The script requires:

```ahk
#Requires AutoHotkey v2.0
```

AutoHotkey v1 is not supported by this script.

---

### 3. Verify VirtualDesktopAccessor.dll

The required DLL should already be included in:

```text
CustomShortcuts\VirtualDesktopAccessor.dll
```

The final structure must be:

```text
CustomShortcuts/
├── CustomShortcuts.ahk
└── VirtualDesktopAccessor.dll
```

The DLL is intentionally located beside the `.ahk` script. The script finds it using:

```ahk
dll := A_ScriptDir "\VirtualDesktopAccessor.dll"
```

`A_ScriptDir` points to the directory containing `CustomShortcuts.ahk`. Do not move the DLL to another directory unless the script is modified accordingly.

---

### 4. VirtualDesktopAccessor Updates

The repository contains:

```text
Setup\VirtualDesktopAccessor-Releases.url
```

Open it to visit the project's GitHub Releases page when:
* Setting up a new Windows installation
* Virtual Desktop shortcuts stop working after a Windows update
* A newer `VirtualDesktopAccessor` release is available

If a newer DLL is required:
1. Open `Setup\VirtualDesktopAccessor-Releases.url`.
2. Download the latest Windows DLL release.
3. Replace `CustomShortcuts\VirtualDesktopAccessor.dll`.
4. Restart the AutoHotkey script.
5. Test the shortcuts.
6. Commit the updated DLL to Git.

---

### 5. Run the Script

Run the file directly:

```text
CustomShortcuts\CustomShortcuts.ahk
```

Or execute via PowerShell:

```powershell
Start-Process ".\CustomShortcuts\CustomShortcuts.ahk"
```

To verify execution, check for the green AutoHotkey **H** icon in the Windows system tray.

---

## Custom Shortcuts

### Virtual Desktop Switching

Direct switching for Virtual Desktops 1 through 9.

| Shortcut | Action |
| :--- | :--- |
| `Alt + 1` | Switch to Virtual Desktop 1 |
| `Alt + 2` | Switch to Virtual Desktop 2 |
| `Alt + 3` | Switch to Virtual Desktop 3 |
| `Alt + 4` | Switch to Virtual Desktop 4 |
| `Alt + 5` | Switch to Virtual Desktop 5 |
| `Alt + 6` | Switch to Virtual Desktop 6 |
| `Alt + 7` | Switch to Virtual Desktop 7 |
| `Alt + 8` | Switch to Virtual Desktop 8 |
| `Alt + 9` | Switch to Virtual Desktop 9 |

The script translates the desktop number to zero-based indexing for the DLL:

```ahk
GoToDesktopNumber(number - 1)
```

* `Alt + 1` → Desktop 1 (DLL receives `0`)
* `Alt + 2` → Desktop 2 (DLL receives `1`)

---

### Media Controls

Global system media playback controls:

| Shortcut | Action |
| :--- | :--- |
| `Win + Alt + J` | Previous Track |
| `Win + Alt + K` | Next Track |
| `Win + Alt + P` | Play / Pause |

AutoHotkey definitions:

```ahk
#!j::Send("{Media_Prev}")
#!k::Send("{Media_Next}")
#!p::Send("{Media_Play_Pause}")
```

Key symbol reference:
* `#` = `Win`
* `!` = `Alt`

---

### Maximize / Restore Active Window

Shortcut:

```text
Win + F1
```

* If window is normal/restored → Maximizes window
* If window is maximized → Restores original window bounds

The script queries the active window state using `WinGetMinMax("A")` and executes either `WinRestore("A")` or `WinMaximize("A")`.

---

## Run Automatically With Windows

Keep the repository directory intact and place a shortcut inside the Windows Startup folder. Do not move the `.ahk` script directly.

### Open Startup Folder

1. Press `Win + R`.
2. Type `shell:startup` and press `Enter`.

Standard path:
```text
C:\Users\<username>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
```

---

### Create Startup Shortcut via Explorer

1. Navigate to `CustomShortcuts\CustomShortcuts.ahk`.
2. Right-click the file and select **Create shortcut**.
3. Move the generated `.lnk` shortcut file into the `shell:startup` folder.

---

### Create Startup Shortcut via PowerShell

Run from the root of the repository:

```powershell
$Script = (Resolve-Path ".\CustomShortcuts\CustomShortcuts.ahk").Path
$Startup = [Environment]::GetFolderPath("Startup")
$ShortcutPath = Join-Path $Startup "CustomShortcuts.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)

$Shortcut.TargetPath = $Script
$Shortcut.WorkingDirectory = Split-Path $Script
$Shortcut.Description = "Start CustomShortcuts AutoHotkey script"

$Shortcut.Save()
```

Verify:

```powershell
ls ([Environment]::GetFolderPath("Startup"))
```

---

### Test Startup

1. Confirm `CustomShortcuts.lnk` is inside `shell:startup`.
2. Restart Windows and log in.
3. Confirm the AutoHotkey tray icon appears automatically.
4. Verify hotkeys:
   * `Alt + 1`, `Alt + 2`
   * `Win + Alt + J`, `Win + Alt + K`, `Win + Alt + P`
   * `Win + F1`

---

## Why the DLL Is Beside the Script

The script resolves the DLL relative to its working location:

```ahk
dll := A_ScriptDir "\VirtualDesktopAccessor.dll"
```

Because both files are in the same folder, the entire repository can be moved to any disk or path without modifying code or setting absolute environment paths.

---

## Full Script Source

File: `CustomShortcuts/CustomShortcuts.ahk`

```ahk
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
```

---

## Script Breakdown

### AutoHotkey Version Validation
```ahk
#Requires AutoHotkey v2.0
```
Blocks execution if run under AutoHotkey v1.

### Instance Handling
```ahk
#SingleInstance Force
```
Automatically replaces running instances with the new one when reloaded.

### Path Resolution
```ahk
dll := A_ScriptDir "\VirtualDesktopAccessor.dll"
```
Constructs a dynamic absolute path to the DLL at runtime based on `A_ScriptDir`.

### Desktop Switching Function
```ahk
switchDesktop(number) {
    global dll

    DllCall("user32\AllowSetForegroundWindow", "Int", -1)
    DllCall(dll "\GoToDesktopNumber", "Int", number - 1, "Int")
}
```
`AllowSetForegroundWindow(-1)` unlocks window activation barriers in Windows, ensuring the target desktop and active application get immediate focus without shell notification flashes.

---

## Stopping the Script

1. Locate the AutoHotkey icon in the system tray.
2. Right-click the icon.
3. Select **Exit**.

---

## Updating the Repository

Pushing script adjustments:

```powershell
git status
git add .
git commit -m "Update custom shortcuts"
git push
```

Pushing DLL updates:

```powershell
git status
git add .\CustomShortcuts\VirtualDesktopAccessor.dll
git commit -m "Update VirtualDesktopAccessor"
git push
```

---

## Fresh Windows Setup — Quick Sequence

```text
1. Install Git
   ↓
2. Clone repository
   ↓
3. Run Setup\AutoHotkey-Download.url -> Install AHK v2
   ↓
4. Verify VirtualDesktopAccessor.dll exists in CustomShortcuts/
   ↓
5. Run CustomShortcuts.ahk
   ↓
6. Test hotkeys
   ↓
7. Run PowerShell startup shortcut command
   ↓
8. Reboot & verify auto-start
```

---

## Maintenance Flow

```text
Windows update breaks virtual desktop hooks
   ↓
Visit Setup\VirtualDesktopAccessor-Releases.url
   ↓
Download updated VirtualDesktopAccessor.dll
   ↓
Replace file in CustomShortcuts\VirtualDesktopAccessor.dll
   ↓
Reload AHK Script
   ↓
Verify desktop switching
   ↓
Commit and push new DLL to Git
```

---

## Quick Reference

| Resource | Path / Command |
| :--- | :--- |
| **Main Script** | `CustomShortcuts\CustomShortcuts.ahk` |
| **Required DLL** | `CustomShortcuts\VirtualDesktopAccessor.dll` |
| **Startup Folder** | `Win + R` → `shell:startup` |
| **Switch Desktop** | `Alt + 1..9` |
| **Previous Track** | `Win + Alt + J` |
| **Next Track** | `Win + Alt + K` |
| **Play / Pause** | `Win + Alt + P` |
| **Maximize / Restore** | `Win + F1` |
