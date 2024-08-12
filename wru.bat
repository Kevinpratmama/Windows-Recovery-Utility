::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCqDJH2L91c9LRVAXziyLmSwA7YI+9TL/eWAsEwQR94IcYHf1aOdYNIW+kTtZ9YYwnNWkd8VMBJbcRy4UgY3pmAMv2eKVw==
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSjk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+IeA==
::cxY6rQJ7JhzQF1fEqQJhZksaHErSXA==
::ZQ05rAF9IBncCkqN+0xwdVsFAlTMbCXqZg==
::ZQ05rAF9IAHYFVzEqQIHIRVQQxORfFm/FrQV+qjO++OLq1kENA==
::eg0/rx1wNQPfEVWB+kM9LVsJDDOwCSWfPpB8
::fBEirQZwNQPfEVWB+kM9LVsJDDOQKSWfHrB8
::cRolqwZ3JBvQF1fEqQIHIRVQQxORfFm/FrQV+qjO++OLq1kENA==
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCqDJH2L91c9LRVAXziyLmSwA7YI+9TL/eWAsEwQR94IcYHf1aOdYNIW+kTtZ9YYwnNWkd8VMAxKa1yudgpU
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
title Windows Repair Utility
:menu
cls
echo Welcome to Windows Repair Utility!
timeout /t 3 > NUL
goto startPoint
:startPoint
echo ===========================================================
echo Choose an option...
echo [1] Run the System File Checker
echo [2] Run the Deployment Image Servicing and Management (fixes corrupted files online if SFC does not work)
echo [3] Run the System File Checker without repairing
echo [4] Exit
echo ===========================================================
set /p choice="Enter your choice: "

if "%choice%"=="1" goto sfc_repair
if "%choice%"=="2" goto dism
if "%choice%"=="3" goto sfc_no_repair
if "%choice%"=="4" goto exit
cls
echo Invalid choice. Please select a valid option.
timeout /t 2 > NUL
goto startPoint

:sfc_repair
echo Running System File Checker with repair...
sfc /scannow
if %errorlevel% neq 0 (
    echo SFC failed.
    set /p pickDISM="Do you want to repair online? (y/n): "
    if /i "%pickDISM%"=="y" goto dism
    if /i "%pickDISM%"=="n" goto exit
)
pause
goto menu

:sfc_no_repair
echo Running System File Checker without repair...
sfc /verifyonly
echo Finished checking, going back to main menu in 3 seconds.
timeout /t 3 > NUL
goto menu

:dism
echo Please wait...
dism /online /cleanup-image /restorehealth
if %errorlevel% neq 0 (
    echo DISM failed. You may need to repair from an ISO.
    set /p repairISO="Do you want to repair from an ISO? (y/n): "
    if /i "%repairISO%"=="y" goto repair_from_iso
    if /i "%repairISO%"=="n" goto exit
)
pause
goto menu

:repair_from_iso
set /p isoPath="Enter the full path to the ISO file: "
if not exist "%isoPath%" (
    echo Invalid ISO path. Please try again.
    timeout /t 5 > NUL
    goto repair_from_iso
)
echo Mounting ISO...
powershell Mount-DiskImage -ImagePath "%isoPath%" -StorageType ISO -PassThru | Get-Volume | Select-Object -ExpandProperty DriveLetter > mount.tmp
for /f "delims=" %%A in (mount.tmp) do set driveLetter=%%A
del mount.tmp

echo Running DISM from ISO...
dism /online /cleanup-image /restorehealth /source:%driveLetter%:\sources\install.wim /limitaccess
if %errorlevel% neq 0 (
    echo DISM from ISO also failed. You may need further assistance.
)
pause
powershell Dismount-DiskImage -ImagePath "%isoPath%"
goto menu

:exit
exit /b