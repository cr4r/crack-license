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

ECHO # ====== Block Adobe ======>> %HOSTFILE%
ECHO 127.0.0.1 lmlicenses.wip4.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 lm.licenses.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 na1r.services.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 hlrcv.stage.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 practivate.adobe.com >> %HOSTFILE%
ECHO 127.0.0.1 activate.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 lm.licenses.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 practivate.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 ereg.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 activate.wip3.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 wip3.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 3dns-3.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 3dns-2.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 adobe-dns.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 adobe-dns-2.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 adobe-dns-3.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 ereg.wip3.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 activate-sea.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 wwis-dubc1-vip60.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 activate-sjc0.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 adobe.activate.com>> %HOSTFILE%
ECHO 127.0.0.1 hl2rcv.adobe.com>> %HOSTFILE%
ECHO 127.0.0.1 209.34.83.73:443>> %HOSTFILE%
ECHO 127.0.0.1 209.34.83.73:43>> %HOSTFILE%
ECHO 127.0.0.1 209.34.83.73>> %HOSTFILE%
ECHO 127.0.0.1 209.34.83.67:443>> %HOSTFILE%
ECHO 127.0.0.1 209.34.83.67:43>> %HOSTFILE%
ECHO 127.0.0.1 209.34.83.67>> %HOSTFILE%
ECHO 127.0.0.1 ood.opsource.net>> %HOSTFILE%
ECHO 127.0.0.1 CRL.VERISIGN.NET>> %HOSTFILE%
ECHO 127.0.0.1 199.7.52.190:80>> %HOSTFILE%
ECHO 127.0.0.1 199.7.52.190>> %HOSTFILE%
ECHO 127.0.0.1 adobeereg.com>> %HOSTFILE%
ECHO 127.0.0.1 OCSP.SPO1.VERISIGN.COM>> %HOSTFILE%
ECHO 127.0.0.1 199.7.54.72:80>> %HOSTFILE%
ECHO 127.0.0.1 199.7.54.7>> %HOSTFILE%
ECHO # ====== Selesai Block Adobe ======>> %HOSTFILE%
IPCONFIG -flushdns
ECHO.
ECHO Disable Activation
ECHO Berhasil Block Adobe
ECHO.
PAUSE
exit