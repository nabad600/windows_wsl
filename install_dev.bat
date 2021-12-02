@Echo off
set BuildNumber=1902
set Linuxverstion=Linux
for /f "usebackq delims== tokens=2" %%x in (`wmic os get BuildNumber /format:value`) do set CurrentBuildNumber=%%x
Echo CurrentBuildNumber="%CurrentBuildNumber%"
If %CurrentBuildNumber% GTR %BuildNumber% (
    Echo Are you Eligible
    Echo Checking for Windows Subsystem for Linux...
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
    @For /F %%A IN ('wsl -d deck-app uname -a'
    ) Do @If %%A == Linux (
        Echo Already there Distribution in your system.
    ) Else (
        Echo
        curl -L -C - https://github.com/nabad600/windows_wsl/releases/download/v1.0.1/Deck-app.tar --output Deck-app.tar
        wsl --import deck-app C:\deck-app D:\custom_os\Deck-app.tar
        wsl --set-version deck-app 2
        del Deck-app.tar
    )
    Echo ...Checking and Downloading WSL2 Kernel Update.
    @For /F %%A IN ('wsl -l -v^|find "1" /C'
    ) Do @If %%A == 0 (
        Echo ... Your system already WSL2 install
    ) Else (
        curl -L -C - https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi --output wsl_update_x64.msi
        msiexec /i "wsl_update_x64.msi" /passive
        SLEEP 5
        del wsl_update_x64.msi
        wsl --set-default-version 2
        wsl --set-version deck-app 2
    )
) Else (
    Echo This PC doesn't meet the system requirements to upgrade your system minimum BuildNumber 1093
)
pause
