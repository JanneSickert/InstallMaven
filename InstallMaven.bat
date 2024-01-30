@echo off
echo Programm start

set "OrdnerPfad=C:\maven"

if exist "%OrdnerPfad%" (
    echo Maven ist bereits installiert
    goto end_of_script
)

REM Überprüfen, ob das Skript mit Administratorrechten gestartet wurde
net session >nul 2>&1
if %errorlevel% == 0 (
    set ADMINISTRATOR=1
) else (
    set ADMINISTRATOR=0
)

REM Ausgabe abhängig von den Administratorrechten
if %ADMINISTRATOR% == 1 (
    echo starte Instalation
) else (
    echo Es werden Administrator Rechte benötigt um das Script auszuführen
    pause
    goto end_of_script
)

set "url=https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip"
set "zipFile=C:\maven\maven.zip"
set "rootFolder=C:\maven"
set "projectDirectory=C:\maven\apache-maven-3.9.6"

mkdir %rootFolder%
bitsadmin /transfer "MeineDownload" %url% %zipFile%

powershell -command "& {Expand-Archive -Path '%zipFile%' -DestinationPath '%rootFolder%'}"
del %zipFile%

set "binPath=C:\maven\apache-maven-3.9.6\bin"

REM Überprüfen, ob der Pfad bereits im PATH enthalten ist
echo %PATH% | find /i "%neuerPfad%" > nul
if not errorlevel 1 (
    echo Der Pfad ist bereits im PATH enthalten.
    goto end_of_script
) else (
    REM Füge den Pfad zum PATH hinzu
    setx PATH "%PATH%;%neuerPfad%" -m
    echo Der Maven Pfad wurde erfolgreich zum PATH hinzugefügt.
)

REM Aktualisiere das PATH für die aktuelle Sitzung
set "PATH=%PATH%;%neuerPfad%"

echo Der Computer wird neu gestartet um die Instalation Abzuschließen
echo Gebe anschließend folgenden Befehl ein um die Instalation zu testen: "mvn -v"
pause

shutdown /r /t 0

:end_of_script
echo Programm ende
pause
