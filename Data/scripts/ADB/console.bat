@echo off
mode con: cols=120 lines=30
color 2
title ADB ^& SCRCPY Console
chcp 65001 >nul
cls
echo Android Debug Bridge (ADB) ^& Screen Copy (SCRCPY)
echo Type "help" to see available commands.
echo.

:input
set /p "cmd=> "
if "%cmd%"=="" goto input

:: Allow specific commands
if /i "%cmd%"=="help" goto help
if /i "%cmd%"=="version" goto version
if /i "%cmd%"=="exit" exit

:: Block cd, cls manually
if /i "%cmd:~0,2%"=="cd" (
    echo '%cmd%' is not recognized as an internal or external command,
    echo operable program or batch file.
    goto input
)
if /i "%cmd%"=="cls" (
    echo 'cls' is not recognized as an internal or external command,
    echo operable program or batch file.
    goto input
)

:: Allow only adb, scrcpy, or fastboot commands
echo %cmd% | findstr /r "^[aA][dD][bB].*" >nul && goto run
echo %cmd% | findstr /r "^[sS][cC][rR][cC][pP][yY].*" >nul && goto run
echo %cmd% | findstr /r "^[fF][aA][sS][tT][bB][oO][oO][tT].*" >nul && goto run

:: Anything else = unknown command
echo Unknown command: %cmd%
echo.
goto input

:run
%cmd%
goto input

:help
echo.
echo ===================== HELP MENU =====================
echo help                          Show this help screen
echo version                       Show adb and scrcpy version
echo adb (command)                 Type "adb your_command_here"
echo scrcpy (command)              Type "scrcpy your_command_here"
echo fastboot (command)            Type "fastboot your_command_here"
echo exit                          Close this console
echo =====================================================
echo.
goto input

:version
echo ADB
adb version
echo.
echo SCRCPY
scrcpy --version
echo.
echo FASTBOOT
fastboot --version
echo.
goto input
