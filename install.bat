@Echo off
set BuildNumber=1902
set Linuxverstion=Linux
for /f "usebackq delims== tokens=2" %%x in (`wmic os get BuildNumber /format:value`) do set CurrentBuildNumber=%%x
Echo CurrentBuildNumber="%CurrentBuildNumber%"
If %CurrentBuildNumber% GTR %BuildNumber% (
    set "params=%*"
    cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
    Echo Are you Eligible
    Echo Checking for Windows Subsystem for Linux...
    IF NOT EXIST "%system32%\wsl.exe" (
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
        DISM /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux -All
    )
    msg %username% Please restart your system and install WSL
    ) 
    Echo ...Checking and Downloading WSL2 Kernel Update.
    wl2="%wmic product where "Vendor like '%Microsoft%'" get Name | findstr /i "Windows Subsystem for Linux Update"%"
    If %wl2% = "Windows Subsystem for Linux Update" (
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
    ) Else (
        Echo .... Already installed
    )
    @For /F %%A IN ('wsl -d deck-app uname -a'
    ) Do @If %%A == Linux (
        Echo Already there Distribution in your system.
    ) Else (
        Echo
        curl -L -C - https://github.com/nabad600/windows_wsl/releases/download/v1.0.1/Deck-app.tar --output Deck-app.tar
        wsl --import deck-app %USERPROFILE% Deck-app.tar
        wsl --set-version deck-app 2
        del Deck-app.tar
    )
) Else (
    Echo This PC doesn't meet the system requirements to upgrade your system minimum BuildNumber 1093
)
pause
