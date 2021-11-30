@ECHO OFF
ECHO Please Wait.... WSL/WSL2 download
# Package checking, Download and Install Multipass package
@ECHO OFF
ECHO Please Wait.... WSL/WSL2 download
DISM /online /enable-feature /featurename:VirtualMachinePlatform -All
DISM /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux -All
curl -L -C - https://github.com/nabad600/windows_wsl/releases/download/v1.0.0/Deck-app.tar --output %temp%\Deck-app.tar
wsl --import deck-app C:\deck-app %temp%\Deck-app.tar
wsl --set-version deck-app 2
https://drive.google.com/file/d/1zF-SQmb1Wk7GmK6j09Edim0Pa4b67Mmr/view?usp=sharing
