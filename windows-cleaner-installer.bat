@echo off
setlocal

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting admin...
    powershell start-process "%~f0" -verb runas
    exit
)

set SOURCE=%userprofile%\Downloads\WindowsCleaner
set DEST=%ProgramFiles%\WindowsCleaner

echo Checking source...

if not exist "%SOURCE%" (
    echo Folder not found in Downloads!
    pause
    exit
)

echo Creating Program Files folder...
mkdir "%DEST%"

echo Copying files...
xcopy "%SOURCE%\*" "%DEST%\" /E /H /Y /I

echo Deleting source folder from Downloads...
rmdir /s /q "%SOURCE%"

echo Creating desktop shortcut...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$desktop = [Environment]::GetFolderPath('Desktop'); ^
$WshShell = New-Object -ComObject WScript.Shell; ^
$Shortcut = $WshShell.CreateShortcut($desktop + '\Windows Cleaner.lnk'); ^
$Shortcut.TargetPath = '%ProgramFiles%\WindowsCleaner\startup.bat'; ^
$Shortcut.IconLocation = '%ProgramFiles%\WindowsCleaner\ICO.ico'; ^
$Shortcut.Save()"

echo Done!
pause