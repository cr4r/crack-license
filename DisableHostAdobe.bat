@ECHO OFF

::============================================================================================
:    Credits:
::============================================================================================
::

if exist %SystemRoot%\Sysnative\cmd.exe (
set "_cmdf=%~f0"
setlocal EnableDelayedExpansion
start %SystemRoot%\Sysnative\cmd.exe /c ""!_cmdf!" %*"
exit /b
)

:: Re-launch the script with ARM32 process if it was initiated by x64 process on ARM64 Windows

if exist %SystemRoot%\Windows\SyChpe32\kernel32.dll if exist %SystemRoot%\SysArm32\cmd.exe if %PROCESSOR_ARCHITECTURE%==AMD64 (
set "_cmdf=%~f0"
setlocal EnableDelayedExpansion
start %SystemRoot%\SysArm32\cmd.exe /c ""!_cmdf!" %*"
exit /b
)

::  Set Path variable, it helps if it is misconfigured in the system

set "SysPath=%SystemRoot%\System32"
set "Path=%SysPath%;%SystemRoot%;%SysPath%\Wbem;%SysPath%\WindowsPowerShell\v1.0\"

::========================================================================================================================================


IF "%OS%"=="Windows_NT" (
SET HOSTFILE=%windir%\system32\drivers\etc\hosts
) ELSE (
SET HOSTFILE=%windir%\hosts
)
ECHO.>> %HOSTFILE%
ECHO 127.0.0.1  test2.internetdownloadmanager.com>> %HOSTFILE%

ECHO # ====== Block Adobe ======>> %HOSTFILE%
ECHO 127.0.0.1 lmlicenses.wip4.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 lm.licenses.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 na1r.services.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 hlrcv.stage.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 practivate.adobe.com >> %HOSTFILE%
ECHO 127.0.0.1 activate.adobe.com>> %HOSTFILE%
ECHO # ====== Selesai Block Adobe ======>> %HOSTFILE%
IPCONFIG -flushdns
ECHO.
ECHO Disable Activation
ECHO Berhasil Block Adobe
ECHO.
PAUSE
exit