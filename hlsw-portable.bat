@ECHO OFF

:: Config file
SET hlswInvis=%TEMP%\hlswinvis_%RANDOM%.vbs
SET hlswRnd=%TEMP%\hlswrnd_%RANDOM%.tmp
SET hlswDel=%TEMP%\hlswdel_%RANDOM%.tmp
SET hlswReg=%TEMP%\hlswreg_%RANDOM%.tmp

IF "%1"=="" GOTO LAUNCH
IF "%1"=="process" GOTO PROCESS

:: Run the batch file in the background
:LAUNCH
ECHO set args = WScript.Arguments >%hlswInvis%
ECHO num = args.Count >>%hlswInvis%
ECHO. >>%hlswInvis%
ECHO if num = 0 then >>%hlswInvis%
ECHO    WScript.Quit 1 >>%hlswInvis%
ECHO end if >>%hlswInvis%
ECHO. >>%hlswInvis%
ECHO sargs = "" >>%hlswInvis%
ECHO if num ^> 1 then >>%hlswInvis%
ECHO    sargs = " " >>%hlswInvis%
ECHO    for k = 1 to num - 1 >>%hlswInvis%
ECHO        anArg = args.Item(k) >>%hlswInvis%
ECHO        sargs = sargs ^& anArg ^& " " >>%hlswInvis%
ECHO    next >>%hlswInvis%
ECHO end if >>%hlswInvis%
ECHO. >>%hlswInvis%
ECHO Set WshShell = WScript.CreateObject("WScript.Shell") >>%hlswInvis%
ECHO. >>%hlswInvis%
ECHO WshShell.Run """" ^& WScript.Arguments(0) ^& """" ^& sargs, 0, False >>%hlswInvis%

wscript.exe %hlswInvis% %~n0.bat process
GOTO DONE

:: Start HLSW
:PROCESS
IF NOT EXIST %CD%\data GOTO CREATE_DATA_FOLDER

ECHO REGEDIT4>%hlswRnd%
ECHO [HKEY_CURRENT_USER\Software\HLSW]>>%hlswRnd%
ECHO "RandSeedFile"="%TEMP:\=\\%\\hlsw.rnd">>%hlswRnd%
regedit /s %hlswRnd%
DEL %hlswRnd%
SET hlswRnd=

regedit /s hlsw.ini
start /w hlsw.exe "-PATH:%CD%\" "-DATADIR:%CD%\data\"

DEL %TEMP%\hlsw.rnd
regedit /ea %hlswReg% HKEY_CURRENT_USER\Software\HLSW
fc hlsw.ini %hlswReg% | find "FC: no dif" > NUL
IF ERRORLEVEL 1 COPY %hlswReg% hlsw.ini
DEL %hlswReg%
SET hlswReg=

ECHO REGEDIT4>%hlswDel%
ECHO.>>%hlswDel%
ECHO [-HKEY_CURRENT_USER\Software\HLSW]>>%hlswDel%
ECHO.>>%hlswDel%
type %hlswDel%
regedit /s %hlswDel%
DEL %hlswDel%
DEL %hlswInvis%
SET hlswDel=
GOTO DONE

:: Create data folder 
:CREATE_DATA_FOLDER
mkdir data
IF EXIST %APPDATA%\HLSW GOTO COPY_APPDATA
GOTO PROCESS

:: Write appdata to data folder if exists
:COPY_APPDATA
robocopy /copyall /mir /xj /v /np %APPDATA%\HLSW %CD%\data
GOTO PROCESS

:DONE