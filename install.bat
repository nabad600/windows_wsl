@ECHO OFF
ECHO Please Wait.... WSL/WSL2 download
# Package checking, Download and Install Multipass package
blanko="";
pkg=`wsl`
if [ "$pkg" == "$blanko" ]; then
    ECHO "Multipass not install in your system"
    curl -L -C - https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi --output %temp%/wsl_update_x64.msi
    msiexec.exe /I "%temp%/wsl_update_x64.msi" /QB-!
else
    ECHO "Multipass already install in your system"
fi
