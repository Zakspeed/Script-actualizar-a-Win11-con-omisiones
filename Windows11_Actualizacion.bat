@echo off
title Instalación forzada Windows 11
echo ================================================
echo Instalación forzada Windows 11 - Omisión
echo ================================================
echo.
REM Verificación de privilegios de administrador
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Privilegios de administrador detectados
) else (
    echo [ERROR] Este script requiere privilegios de administrador
    echo Clic derecho en el archivo y "Ejecutar como administrador"
    pause
    exit /b 1
)
echo.
echo === PASO 1: Configuración de omisiones del sistema ===
echo Configurando omisiones del sistema...
REM Eliminar bloqueos previos
powershell -Command "Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\CompatMarkers' -Recurse -Force -ErrorAction SilentlyContinue"
powershell -Command "Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Shared' -Recurse -Force -ErrorAction SilentlyContinue"
REM Crear las omisiones en el registro
powershell -Command "New-Item -Path 'HKLM:\SYSTEM\Setup\MoSetup' -Force | Out-Null"
powershell -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\Setup\MoSetup' -Name 'AllowUpgradesWithUnsupportedTPMOrCPU' -Value 1 -Type DWord"
powershell -Command "New-Item -Path 'HKLM:\SYSTEM\Setup\LabConfig' -Force | Out-Null"
powershell -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\Setup\LabConfig' -Name 'BypassTPMCheck' -Value 1 -Type DWord"
powershell -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\Setup\LabConfig' -Name 'BypassSecureBootCheck' -Value 1 -Type DWord"
powershell -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\Setup\LabConfig' -Name 'BypassRAMCheck' -Value 1 -Type DWord"
powershell -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\Setup\LabConfig' -Name 'BypassCPUCheck' -Value 1 -Type DWord"
powershell -Command "New-Item -Path 'HKCU:\Software\Microsoft\PCHC' -Force | Out-Null"
powershell -Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\PCHC' -Name 'UpgradeEligibility' -Value 1 -Type DWord"
echo [OK] Omisiones configuradas con éxito!
echo.
echo === PASO 2: Descarga de Windows 11 ===
echo Descargando Windows 11...
set "DownloadFolder=%USERPROFILE%\Downloads"
set "Win11AssistantPath=%DownloadFolder%\Windows11InstallationAssistant.exe"
REM Descargar el asistente de Windows 11
powershell -Command "Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/?linkid=2171764' -OutFile '%Win11AssistantPath%' -UseBasicParsing"
if exist "%Win11AssistantPath%" (
    echo [OK] Descarga completada!
) else (
    echo [ERROR] Fallo en la descarga
    pause
    exit /b 1
)
echo.
echo === PASO 3: Inicio de la instalación ===
echo Iniciando instalación de Windows 11...
REM Mostrar la licencia actual
for /f "tokens=*" %%a in ('powershell -Command "(Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey"') do set "ProductKey=%%a"
echo IMPORTANTE: Tu licencia %ProductKey% será preservada!
echo.
echo Iniciando asistente de instalación...
start "" "%Win11AssistantPath%"
echo.
echo [OK] Instalación iniciada! Sigue las instrucciones en pantalla.
echo [INFO] Tus archivos y licencia serán preservados automáticamente.
echo.
echo ================================================
echo Instalación en curso...
echo Cierra esta ventana cuando la instalación comience
echo ================================================
pause