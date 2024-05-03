@echo off
set "shFileName=%~nx1"
set "wsl_dir=%~dp1"
set "wsl_dir=%wsl_dir:~0,-1%"
for /f "delims=" %%i in ('wsl wslpath "%wsl_dir%"') do set "wsl_dir=%%i"
start wsl --cd "%wsl_dir%"
timeout /t 1
powershell -command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('bash %shFileName%{ENTER}');}"