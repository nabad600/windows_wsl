@Echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
set BuildNumber=1902
set Linuxverstion=Linux
set VAR=Windows Subsystem for Linux Update
@For /F %%A IN ('dism /online /get-featureinfo /featurename:VirtualMachinePlatform^|find "Disable" /C'
) Do set VMP=%%A
for /f "usebackq delims== tokens=2" %%x in (`wmic product where "Name= 'Windows Subsystem for Linux Update'" get Name /format:value`) do set VAR1=%%x
for /f "usebackq delims== tokens=2" %%x in (`wmic os get BuildNumber /format:value`) do set CurrentBuildNumber=%%x
for /f "usebackq delims== tokens=2" %%A in (`wmic service where "Name= 'LxssManager'" get Name /format:value`) do set SER=%%A
If exist "%UserProfile%\AppData\Local\Programs\deck\DECK.exe" ( 
 Echo DECK already install....
) Else (
 Echo DECK not Install......
 curl -L -C - https://github.com/deck-app/stable-releases/releases/download/v4.2.2/DECK-4.2.2-win-x64.zip --output %temp%\DECK.zip
 powershell -command "Expand-Archive -Force '%temp%\DECK.zip' '%temp%'"
 start /wait %temp%\DECK-4.2.2-win-x64.exe 
)
if "%VMP%" == "0" if "%SER%" == "LxssManager" set res=true
If %CurrentBuildNumber% GTR %BuildNumber% (
    Echo Checking for Windows Subsystem for Linux...
    if "%res%" == "true" (
        Echo ...Windows Subsystem for Linux already installed.
    ) Else (
    @For /F %%A IN ('dism /online /get-featureinfo /featurename:VirtualMachinePlatform^|find "Enabled" /C'
    ) Do @If %%A == 0 (
        DISM /online /NoRestart /enable-feature /featurename:VirtualMachinePlatform -All
    ) Else (
        Echo ...Virtual Machine Platform already installed.
    )
    @For /F %%A IN ('dism /online /get-featureinfo /featurename:Microsoft-Windows-Subsystem-Linux^|find "Enabled" /C'
    ) Do @If %%A == 0 (
        DISM /online /NoRestart /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux -All
    ) Else (
        Echo ...Windows Subsystem for Linux already installed.
    )
    Echo ...Checking and Downloading WSL2 Kernel Update.
    SET VAR1=%VAR1: =%
    SET VAR=%VAR: =%
    If "%VAR1%"=="%VAR%" (
       Echo .... Already installed
    ) Else (
    If %CurrentBuildNumber% LEQ 18362 (
        Echo ... Your system not avalabile WSL2 install
    ) Else (
        if /i "%PROCESSOR_ARCHITECTURE%" EQU "AMD64" (
            curl -L -C - https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi --output wsl_update_x64.msi
            msiexec /i "wsl_update_x64.msi" /passive
            timeout 5 > NUL
            del wsl_update_x64.msi
            wsl --set-default-version 2
        ) Else (
            curl -L -C - https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_arm64.msi --output wsl_update_arm64.msi
            msiexec /i "wsl_update_arm64.msi" /passive
            timeout 5 > NUL
            del wsl_update_arm64.msi
            wsl --set-default-version 2
        )
    )
    )
    curl -L -C - https://raw.githubusercontent.com/nabad600/windows_wsl/master/reboot.bat --output %temp%\reboot.bat
    call %temp%\reboot.bat
    goto :break
    )
    @For /F %%A IN ('wsl -d deck-app uname -a'
    ) Do @If %%A == Linux (
        Echo Already there Distribution in your system.
    ) Else (
        curl -L -C - https://github.com/deck-app/wsl-installer/releases/download/v1.0.0/deck-app.tar --output deck-app.tar
        wsl --import deck-app c:\deck-app deck-app.tar
        wsl --set-version deck-app 2
        del deck-app.tar
    )
) Else (
    Echo This PC doesn't meet the system requirements to upgrade your system minimum BuildNumber 1093
)
:break
cmd /k
pause
