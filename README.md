# AutoHotkey Custom Shortcuts

Personal Windows setup for custom keyboard shortcuts using **AutoHotkey v2** and **VirtualDesktopAccessor**.

This repository provides an organized structure to quickly restore your custom shortcuts on fresh Windows installations. The required `VirtualDesktopAccessor.dll` is not bundled with the repository because binary builds differ between Windows 10 and Windows 11.

---

## Repository Structure

```text
auto_hotkey-ahk_script/
│
├── Scripts/
│   ├── ShortcutScript.ahk
│   └── VirtualDesktopAccessor.dll    # (Placed manually based on OS)
│
├── Setup/
│   ├── AutoHotkey-Download.url
│   └── VirtualDesktopAccessor-Releases.url
│
└── README.md

```

### Files & Directories

| Path | Purpose |
| --- | --- |
| `Scripts/ShortcutScript.ahk` | Main AutoHotkey v2 script defining custom hotkeys |
| `Scripts/VirtualDesktopAccessor.dll` | OS-specific DLL for Windows Virtual Desktop switching (user-provided) |
| `Setup/AutoHotkey-Download.url` | Direct link to download AutoHotkey v2+ |
| `Setup/VirtualDesktopAccessor-Releases.url` | Direct link to download the matching DLL for your Windows version |
| `README.md` | Complete setup, configuration, and maintenance documentation |

---

## Prerequisites

Before running the script, ensure you have:

1. **AutoHotkey v2+**: The script uses v2 syntax (`#Requires AutoHotkey v2.0`) and is incompatible with AutoHotkey v1.
2. **VirtualDesktopAccessor.dll**: You must download the build compiled specifically for your operating system:
* **Windows 11**: Requires the Windows 11 build of the DLL.
* **Windows 10**: Requires the Windows 10 build of the DLL.


3. **Git**: Required to clone and keep the repository updated.

---

## Installation & Setup

### 1. Clone the Repository

It is recommended to keep scripts inside a dedicated `Tools` folder in your User directory (`C:\Users\<username>\Tools\auto_hotkey-ahk_script`).

Open PowerShell and run:

```powershell
# Create Tools folder if it doesn't exist and navigate to it
New-Item -ItemType Directory -Force -Path "$HOME\Tools" | Out-Null
cd "$HOME\Tools"

# Clone repository
git clone <REPOSITORY-URL> auto_hotkey-ahk_script
cd auto_hotkey-ahk_script

```

Verify your directory structure:

```powershell
ls

```

Expected output:

```text
Scripts
Setup
README.md

```

---

### 2. Install AutoHotkey v2+

1. Open `Setup\AutoHotkey-Download.url`.
2. Download and run the **AutoHotkey v2** installer.
3. Complete the default installation steps.

---

### 3. Download & Place `VirtualDesktopAccessor.dll`

Because internal Windows virtual desktop APIs vary by OS build, the DLL is not tracked in the Git repository.

1. Open `Setup\VirtualDesktopAccessor-Releases.url` to open the GitHub Releases page.
2. Download the DLL matching your current OS:
* Select the **Windows 11** release asset if you are on Windows 11.
* Select the **Windows 10** release asset if you are on Windows 10.


3. Place the downloaded `VirtualDesktopAccessor.dll` directly into the `Scripts` folder:

```text
Scripts/
├── ShortcutScript.ahk
└── VirtualDesktopAccessor.dll

```

> **Note:** The script locates the DLL dynamically using `A_ScriptDir "\VirtualDesktopAccessor.dll"`. The DLL **must** sit in the exact same directory as `ShortcutScript.ahk`.

---

### 4. Launch the Script

Run the script directly via Explorer:

```text
Scripts\ShortcutScript.ahk

```

Or execute it from PowerShell:

```powershell
Start-Process ".\Scripts\ShortcutScript.ahk"

```

Look for the green AutoHotkey **H** icon in your Windows system tray to verify that the script is running.

---

## Run Automatically on Windows Startup

To ensure shortcuts are always active after rebooting, place a shortcut to `ShortcutScript.ahk` in your Windows Startup directory.

### Method A: Via Windows GUI

1. Press `Win + R`, type `shell:startup`, and press **Enter**.
2. Right-click inside the folder and select **New > Shortcut**.
3. Click **Browse...** and navigate to:
```text
C:\Users\<username>\Tools\auto_hotkey-ahk_script\Scripts\ShortcutScript.ahk

```


4. Name the shortcut `ShortcutScript` and click **Finish**.

---

### Method B: Via PowerShell (Automated)

Run the following command from the repository root:

```powershell
$Script = (Resolve-Path ".\Scripts\ShortcutScript.ahk").Path
$Startup = [Environment]::GetFolderPath("Startup")
$ShortcutPath = Join-Path $Startup "ShortcutScript.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = $Script
$Shortcut.WorkingDirectory = Split-Path $Script
$Shortcut.Description = "AutoHotkey Custom Shortcuts"
$Shortcut.Save()

```

Verify that the shortcut was generated:

```powershell
Get-ChildItem ([Environment]::GetFolderPath("Startup")) | Where-Object { $_.Name -like "*ShortcutScript*" }

```

---

## Custom Shortcuts Reference

### Virtual Desktop Switching

Direct 1-to-1 switching across desktops 1 through 9.

| Shortcut | Action | DLL Index Passed |
| --- | --- | --- |
| `Alt + 1` | Switch to Virtual Desktop 1 | `0` |
| `Alt + 2` | Switch to Virtual Desktop 2 | `1` |
| `Alt + 3` | Switch to Virtual Desktop 3 | `2` |
| `Alt + 4` | Switch to Virtual Desktop 4 | `3` |
| `Alt + 5` | Switch to Virtual Desktop 5 | `4` |
| `Alt + 6` | Switch to Virtual Desktop 6 | `5` |
| `Alt + 7` | Switch to Virtual Desktop 7 | `6` |
| `Alt + 8` | Switch to Virtual Desktop 8 | `7` |
| `Alt + 9` | Switch to Virtual Desktop 9 | `8` |

---

### Global Media Playback

Control audio without needing media keys or focusing on playback apps:

| Shortcut | Action | AHK Key Code |
| --- | --- | --- |
| `Win + Alt + J` | Previous Track | `{Media_Prev}` |
| `Win + Alt + K` | Next Track | `{Media_Next}` |
| `Win + Alt + P` | Play / Pause | `{Media_Play_Pause}` |

---

### Maximize / Restore Active Window

| Shortcut | Action |
| --- | --- |
| `Win + F1` | Toggles between **Maximize** and **Restore** bounds for the active window |

---

## Full Script Source

File: `Scripts/ShortcutScript.ahk`

```ahk
#Requires AutoHotkey v2.0
#SingleInstance Force

dll := A_ScriptDir "\VirtualDesktopAccessor.dll"

switchDesktop(number) {
    global dll

    ; ASFW_ANY (-1) unlocks window activation barriers for clean focus transitions
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

## Maintenance & Troubleshooting

### Virtual Desktops Stop Working After Windows Updates

Major Windows feature updates occasionally alter internal Virtual Desktop API signatures.

1. Open `Setup\VirtualDesktopAccessor-Releases.url`.
2. Check for an updated release targeting your updated Windows build number.
3. Download the new DLL and overwrite `Scripts\VirtualDesktopAccessor.dll`.
4. Right-click the AutoHotkey tray icon and select **Reload This Script** (or restart the script).

### Stopping the Script

1. Locate the green **H** icon in the system notification tray.
2. Right-click and choose **Exit**.

---

## Quick Setup Checklist

```text
1. Clone repo to: %USERPROFILE%\Tools\auto_hotkey-ahk_script
   ↓
2. Install AutoHotkey v2+ (via Setup\AutoHotkey-Download.url)
   ↓
3. Download OS-specific DLL (Win 10 vs Win 11) from Setup\VirtualDesktopAccessor-Releases.url
   ↓
4. Move VirtualDesktopAccessor.dll into the Scripts/ directory
   ↓
5. Run Scripts\ShortcutScript.ahk
   ↓
6. Add shortcut to shell:startup (GUI or PowerShell)
   ↓
7. Done — shortcuts persist across reboots

```
