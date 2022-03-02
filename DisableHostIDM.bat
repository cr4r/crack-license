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

ECHO # ====== Block IDM ======>> %HOSTFILE%
ECHO 127.0.0.1  miror.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  ww3.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  ww35.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  ecure.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  www.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  0www.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  w.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  ww8.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  1secure.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  -www.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  goole.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  wwwwww.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  www1.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  www.mirror6.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  lwww.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  mirrora.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  demand.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  www.m.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  wwww.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  ocsp.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  www.ww.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  mirror0.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  static.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  register.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  0mirror3.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  secure.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  mirror.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  mirror2.internetdownloadmanager.com>> %HOSTFILE%
ECHO 127.0.0.1  mirror3.internetdownloadmanager.com >> %HOSTFILE%
ECHO 127.0.0.1  internetdownloadmanager.com>> %HOSTFILE%
ECHO # ====== Selesai Block IDM ======>> %HOSTFILE%
IPCONFIG -flushdns
ECHO.
ECHO Disable Activation
ECHO Berhasil Block IDM
ECHO.
PAUSE
exit