@echo off
echo code=Msgbox("Please restart your system, installed and configure WSL feature", vbYesNo, "I'm The Title!") > "%temp%\popupBox.vbs"
echo WScript.Quit code >> "%temp%\popupBox.vbs"
cscript /nologo "%temp%\popupBox.vbs"

if %errorlevel%==6 call :ok_tag
if %errorlevel%==7 call :cancel_tag
echo Done!
exit /b 1

:ok_tag
shutdown -r /t 00
exit /b

:cancel_tag
echo You pressed No!
exit /b
