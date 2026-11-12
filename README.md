# FixMicVolume

## How to install:

- ### 1. Download release (7-Zip archive)
- ### 2. Extract anywhere, example: %APPDATA%\SpeartonCS\FixMicVolume
- ### 3. Open Win+R: `taskschd.msc`
- ### 4. If you want - Create new folder
- ### 5. Create basic task...
	- ### 5.1. Any name (FixMicVolume)
	- ### 5.2. When the computer starts | When I log on
	- ### 5.3. Start a program
		- ### 5.3.1. Program/script: path to `FixMicVolume.exe` without "
		- ### 5.3.2. Add arguments: noConsole
		- ### 5.3.3. Start in (optional): path to `FixMicVolume.exe` directory without "

## How to uninstall

- ### 1. Open Task Manager (Ctrl+Shift+Esc)
	- ### 1.1. Find FixMicVolume and End task
- ### 2. Open Win+R: taskschd.msc
	- ### 2.1. Find FixMicVolume task and Delete it
- ### 3. Open Win+R: %APPDATA%\SpeartonCS
	- ### 3.1. Delete FixMicVolume folder

---
## OR JUST USE InstallScript.ps1 (and it's pair UninstallScript.ps1)