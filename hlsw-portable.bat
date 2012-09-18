@ECHO OFF

:: Config file
SET hlswInvis=%TEMP%\hlswinvis_%RANDOM%.vbs

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
start /w hlsw.exe "-PATH:%CD%\" "-DATADIR:%CD%\data\"
DEL %hlswInvis%
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