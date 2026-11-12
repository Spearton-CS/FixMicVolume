# FixMicVolume

## How to set-up:

- ### Download release (7-Zip archive)
- ### Extract anywhere, example: %APPDATA%\SpeartonCS\FixMicVolume
- ### Open Win+R: `taskschd.msc`
- ### If you want - Create new folder
- ### Create basic task...
	- ### Any name (FixMicVolume)
	- ### When the computer starts | When I log on
	- ### Start a program
		- ### Program/script: path to `FixMicVolume.exe` without "
		- ### Add arguments: noConsole
		- ### Start in (optional): path to `FixMicVolume.exe` directory without "