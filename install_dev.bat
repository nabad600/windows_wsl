@echo off

rem Make sure script is run with admin privileges

for /f "delims=" %%F in ('powershell -C "(New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)"') do set admin=%%F

if %admin%==False (
	echo Script needs to run as admin, please relaunch
	PAUSE
	exit
) else (
	echo You are running as Administrator
) 

rem Enable Optional Windows Feature Microsoft-Windows-Subsystem-Linux

for /f "delims=" %%F in ('powershell -C "(Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State"') do set wslenabled=%%F

if %wslenabled%==False (
	echo Microsoft-Windows-Subsystem-Linux not enabled. Enabling now. Restart required
	powershell -C "Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux"
	PAUSE
	exit
) else (
	echo Microsoft-Windows-Subsystem-Linux is enabled
) 

ECHO Setting WSLENV ...
cmd.exe /c setx WSLENV USERNAME:USERPROFILE/p:DOCKER_HOST
setx WSLENV USERNAME:USERPROFILE/p:DOCKER_HOST
ECHO ... WSLENV is now %WSLENV%


echo Installation is now complete

PAUSE
exit
