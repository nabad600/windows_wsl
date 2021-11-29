@ECHO OFF
ECHO Please Wait.... WSL/WSL2 download
# Package checking, Download and Install Multipass package
@ECHO OFF
ECHO Please Wait.... WSL/WSL2 download
    DISM /online /enable-feature /featurename:HypervisorPlatform -All
    DISM /online /enable-feature /featurename:VirtualMachinePlatform -All
    DISM /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux -All
    curl -L -C - https://github.com/nabad600/windows_wsl/releases/download/v1.0.0/deck-app.tar --output %temp%\deck-app.tar
    wsl --import Deck-app %temp%\deck-app %temp%\deck-app.tar
    
