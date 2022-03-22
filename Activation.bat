@setlocal DisableDelayedExpansion
@echo off

:: Add custom name in IDM license info, prefer to write it in English and/or numeric in below line after = sign,
set name=




::============================================================================================
:    Credits: Coders Family
::============================================================================================
::

if exist %SystemRoot%\Sysnative\cmd.exe (
set "_cmdf=%~f0"
setlocal EnableDelayedExpansion
start %SystemRoot%\Sysnative\cmd.exe /c ""!_cmdf!" %*"
exit /b
)

:: Menjalankan ulang jika menggunakan arm32.

if exist %SystemRoot%\Windows\SyChpe32\kernel32.dll if exist %SystemRoot%\SysArm32\cmd.exe if %PROCESSOR_ARCHITECTURE%==AMD64 (
set "_cmdf=%~f0"
setlocal EnableDelayedExpansion
start %SystemRoot%\SysArm32\cmd.exe /c ""!_cmdf!" %*"
exit /b
)

:: Membuat variabel untuk mengurangi kesalahan :)

set "SysPath=%SystemRoot%\System32"
set "Path=%SysPath%;%SystemRoot%;%SysPath%\Wbem;%SysPath%\WindowsPowerShell\v1.0\"

::========================================================================================================================================

cls
color 07

set _args=
set _elev=
set reset=
set Silent=
set activate=

set _args=%*
if defined _args set _args=%_args:"=%
if defined _args (
for %%A in (%_args%) do (
if /i "%%A"=="-el"  set _elev=1
if /i "%%A"=="/res" set Unattended=1&set activate=&set reset=1
if /i "%%A"=="/act" set Unattended=1&set activate=1&set reset=
if /i "%%A"=="/s"   set Unattended=1&set Silent=1
)
)

::========================================================================================================================================

set "nul=>nul 2>&1"
set "_psc=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
set winbuild=1
for /f "tokens=6 delims=[]. " %%G in ('ver') do set winbuild=%%G
call :_colorprep
set "nceline=echo: &echo ==== ERROR ==== &echo:"
set "line=________________________________________________________________________________________"
set "_buf={$W=$Host.UI.RawUI.WindowSize;$B=$Host.UI.RawUI.BufferSize;$W.Height=31;$B.Height=300;$Host.UI.RawUI.WindowSize=$W;$Host.UI.RawUI.BufferSize=$B;}"

if defined Silent if not defined activate if not defined reset exit /b
if defined Silent call :begin %nul% & exit /b

:begin

::========================================================================================================================================
:: Mengecek versi OS anda

if not exist "%_psc%" (
%nceline%
echo Powershell tidak ada di sistem windows anda.
echo Keluar ...
goto done
)

if %winbuild% LSS 7600 (
%nceline%
echo OS anda tidak support
echo Script ini hanya support untuk Windows 7/8/8.1/10.
goto done
)

::========================================================================================================================================

::  Fix for the special characters limitation in path name
::  Thanks to @abbodi1406

set "_work=%~dp0"
if "%_work:~-1%"=="\" set "_work=%_work:~0,-1%"

set "_batf=%~f0"
set "_batp=%_batf:'=''%"

set "_vbsf=%temp%\admin.vbs"
set _PSarg="""%~f0""" -el %_args%

set "_appdata=%appdata%"
for /f "tokens=2*" %%a in ('reg query "HKCU\Software\DownloadManager" /v ExePath 2^>nul') do call set "IDMan=%%b"

setlocal EnableDelayedExpansion

::========================================================================================================================================
::  Mengubah CMD menjadi administrator
::  Thanks to @hearywarlot [ https://forums.mydigitallife.net/threads/.74332/ ] for the VBS method.
::  Thanks to @abbodi1406 for the powershell method and solving special characters issue in file path name.

%nul% reg query HKU\S-1-5-19 || (
  if not defined _elev (
    %nul% del /f /q "!_vbsf!"
    (
    echo Set strArg=WScript.Arguments.Named
    echo Set strRdlproc = CreateObject^("WScript.Shell"^).Exec^("rundll32 kernel32,Sleep"^)
    echo With GetObject^("winmgmts:\\.\root\CIMV2:Win32_Process.Handle='" ^& strRdlproc.ProcessId ^& "'"^)
    echo With GetObject^("winmgmts:\\.\root\CIMV2:Win32_Process.Handle='" ^& .ParentProcessId ^& "'"^)
    echo If InStr ^(.CommandLine, WScript.ScriptName^) ^<^> 0 Then
    echo strLine = Mid^(.CommandLine, InStr^(.CommandLine , "/File:"^) + Len^(strArg^("File"^)^) + 8^)
    echo End If
    echo End With
    echo .Terminate
    echo End With
    echo CreateObject^("Shell.Application"^).ShellExecute "cmd.exe", "/c " ^& chr^(34^) ^& chr^(34^) ^& strArg^("File"^) ^& chr^(34^) ^& strLine ^& chr^(34^), "", "runas", 1
    )>"!_vbsf!"

    (%nul% wmic.exe alias /? && %nul% cscript //NoLogo "!_vbsf!" /File:"!_batf!" -el %_args%) && (
      del /f /q "!_vbsf!"
      exit /b
    ) || (
      del /f /q "!_vbsf!"
      %nul% %_psc% "start cmd.exe -arg '/c \"!_PSarg:'=''!\"' -verb runas" && (
        exit /b
      )
    )
  )
  %nceline%
  echo Skrip ini memerlukan hak administrator.
  echo Klik kanan pada file lalu 'Run as administrator'.
  goto done
)

::========================================================================================================================================

:: Kode di bawah ini juga berfungsi untuk ARM64 Windows 10 (termasuk emulasi x64 bit)

reg query "HKLM\Hardware\Description\System\CentralProcessor\0" /v "Identifier" | find /i "x86" 1>nul && set arch=x86|| set arch=x64

if not exist "!IDMan!" (
  if %arch%==x64 set "IDMan=%ProgramFiles(x86)%\Internet Download Manager\IDMan.exe"
  if %arch%==x86 set "IDMan=%ProgramFiles%\Internet Download Manager\IDMan.exe"
)

if "%arch%"=="x86" (
  set "CLSID=HKCU\Software\Classes\CLSID"
  set "HKLM=HKLM\Software\Internet Download Manager"
  set "_tok=5"
) else (
  set "CLSID=HKCU\Software\Classes\Wow6432Node\CLSID"
  set "HKLM=HKLM\SOFTWARE\Wow6432Node\Internet Download Manager"
  set "_tok=6"
)

set _temp=%SystemRoot%\Temp
set regdata=%SystemRoot%\Temp\regdata.txt
set "idmcheck=tasklist /fi "imagename eq idman.exe" | findstr /i "idman.exe" >nul"

::========================================================================================================================================

if defined Unattended (
  if defined reset goto _reset
  if defined activate goto _activate
)


::  Class MainMenu
:MainMenu

cls
title  Aktivasi IDM - Coders Family
mode 90, 30

:: Cek status firewall

set /a _ena=0
set /a _dis=0
for %%# in (DomainProfile PublicProfile StandardProfile) do (
  for /f "skip=2 tokens=2*" %%a in ('reg query HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\%%# /v EnableFirewall 2^>nul') do (
    if /i %%b equ 0x1 (set /a _ena+=1) else (set /a _dis+=1)
  )
)

if %_ena%==3 (
  set _status=Enabled
  set _col=%_Green%
)

if %_dis%==3 (
  set _status=Disabled
  set _col=%_Red%
)

if not %_ena%==3 if not %_dis%==3 (
  set _status=Status_Unclear
  set _col=%_Yellow%
)

::  Mematikan IDM Otomatis
%idmcheck% && taskkill /f /im idman.exe

echo:
echo:
echo:          [A] Aktivasi IDM dan block all web IDM                               
echo:          [R] Reset IDM Activation / Trial in Registry
echo:          [I] Block semua website IDM
echo:          [D] Block semua website Adobe
echo:          _____________________________________________   
echo:                                                          
call :_color2 %_White% "          [F] Toggle Windows Firewall  " %_col% "[%_status%]"
echo:          _____________________________________________ 
echo:                                                                                                                     
echo:          [H] Buka File Hosts                                        
echo:          [C] Cara penggunaan                                        
echo:          [X] Exit                                        
echo:          _____________________________________________
echo:   
choice /C:ARIDFHCX /m "   Silahkan Pilih"
set _erl=%errorlevel%
if %_erl%==8 exit /b
if %_erl%==7 call :readme&goto MainMenu
if %_erl%==6 goto hostFile
if %_erl%==5 call :_tog_Firewall&goto MainMenu
if %_erl%==4 goto blockAdobe
if %_erl%==3 goto blockIDM
if %_erl%==2 goto _reset
if %_erl%==1 goto _activate
goto :MainMenu

::========================================================================================================================================
::  Memblokir situs IDM
:blockIDM

start cmd /k "%~dp0\DisableHostIDM.bat"
goto MainMenu
::========================================================================================================================================

::========================================================================================================================================
::  Memblokir situs Adobe
:blockAdobe

start cmd /k "%~dp0\DisableHostAdobe.bat"
goto MainMenu
::========================================================================================================================================

::========================================================================================================================================
::  Mematikan / Hidupkan Firewall windows
:_tog_Firewall

if %_status%==Enabled (
netsh AdvFirewall Set AllProfiles State Off >nul
) else (
netsh AdvFirewall Set AllProfiles State On >nul
)
exit /b
::========================================================================================================================================

::========================================================================================================================================
::  Membuka file hosts di windows
:hostFile

set "_hostFile=%windir%\system32\drivers\etc\hosts"
start notepad "%_hostFile%"
goto MainMenu
::========================================================================================================================================

::========================================================================================================================================
:: Baca Readme
:readme

set "_ReadMe=%SystemRoot%\Temp\ReadMe.txt"
if exist "%_ReadMe%" del /f /q "%_ReadMe%" %nul%
call :export txt "%_ReadMe%"
start notepad "%_ReadMe%"
timeout /t 2 %nul%
del /f /q "%_ReadMe%"
exit /b
::========================================================================================================================================


::  Extract the text from batch script without character and file encoding issue
::  Thanks to @abbodi1406

::========================================================================================================================================
:export

%nul% %_psc% "$f=[io.file]::ReadAllText('!_batp!') -split \":%~1\:.*`r`n\"; [io.file]::WriteAllText('%~2',$f[1].Trim(),[System.Text.Encoding]::ASCII);"
exit/b
::========================================================================================================================================

::========================================================================================================================================
:_reset

if not defined Unattended (
  mode 93, 32
  %nul% %_psc% "&%_buf%"
)

echo:
set _error=

reg query "HKCU\Software\DownloadManager" "/v" "Serial" %nul% && (
  %idmcheck% && taskkill /f /im idman.exe
)

if exist "!_appdata!\DMCache\settings.bak" del /s /f /q "!_appdata!\DMCache\settings.bak"

set "_action=call :delete_key"
call :reset

echo:
echo %line%
echo:
if not defined _error (
  call :_color %Green% "Trial IDM berhasil Di Aktifkan."
) else (
  call :_color %Red% "Gagal mengaktifkan Trial"
)

goto done
::========================================================================================================================================

::========================================================================================================================================
:_activate

if not defined Unattended (
mode 93, 32
%nul% %_psc% "&%_buf%"
)

echo:
set _error=

if not exist "!IDMan!" (
  call :_color %Red% "IDM [Internet Download Manager] belum di install."
  echo Bisa di download di  https://www.internetdownloadmanager.com/download.html
  goto done
)

%idmcheck% && taskkill /f /im idman.exe

if exist "!_appdata!\DMCache\settings.bak" del /s /f /q "!_appdata!\DMCache\settings.bak"

set "_action=call :delete_key"
call :reset

set "_action=call :count_key"
call :register_IDM

@REM goto blockIDM

echo:
if defined _derror call :f_reset & goto done

::========================================================================================================================================

::========================================================================================================================================
:done

echo %line%
echo:
echo:
if defined Unattended (
  timeout /t 3
  exit /b
)

echo Tekan apa saja untuk kembali...
pause >nul
goto MainMenu

:f_reset

echo:
echo %line%
echo:
call :_color %Red% "Error saat mereset aktivasi IDM..."
set "_action=call :delete_key"
call :reset
echo:
echo %line%
echo:
call :_color %Red% "IDM gagal di aktifkan."
exit /b
::========================================================================================================================================

::========================================================================================================================================
:reset

set take_permission=
call :delete_queue
set take_permission=1
call :action
call :add_key
exit /b
::========================================================================================================================================

::========================================================================================================================================
:_rcont

reg add %reg% %nul%
call :_add_key
exit /b

:register_IDM

echo:
echo Mereset registrasi IDM...
echo:

If not defined name set name=cr4r

set "reg=HKCU\SOFTWARE\DownloadManager /v FName /t REG_SZ /d "CR4R"" & call :_rcont
set "reg=HKCU\SOFTWARE\DownloadManager /v LName /t REG_SZ /d "Coders Family"" & call :_rcont
set "reg=HKCU\SOFTWARE\DownloadManager /v Email /t REG_SZ /d "admin@coders-family.me"" & call :_rcont
set "reg=HKCU\SOFTWARE\DownloadManager /v Serial /t REG_SZ /d "FOX6H-3KWH4-7TSIN-Q4US7"" & call :_rcont
set "reg=HKCU\SOFTWARE\DownloadManager /v LstCheck /t REG_SZ /d "10/10/99"" & call :_rcont

echo:
echo Registrasi IDM Berhasil di reset
echo Anda mempunyai 30 hari untuk mengaktifkan ulang IDM
::========================================================================================================================================

::========================================================================================================================================
:_skip

echo:
if not defined _derror (
  echo registri yang diperlukan berhasil dibuat.
) else (
  if not defined _fileexist call :_color %Red% "Tidak dapat mengunduh file dengan IDM."
  call :_color %Red% "Gagal membuat registri yang diperlukan."
  call :_color %Magenta% "Cobalah untuk menonaktifkan Windows Firewall"
)

echo:
%idmcheck% && taskkill /f /im idman.exe
if exist "%file%" del /f /q "%file%"
exit /b
::========================================================================================================================================

::========================================================================================================================================
:check_file

timeout /t 1 >nul
set /a attempt+=1
if exist "%file%" set _fileexist=1&exit /b
if %attempt% GEQ 20 exit /b
goto :Check_file
::========================================================================================================================================

::========================================================================================================================================
:delete_queue

echo:
echo Deleting registry keys...
echo:

for %%# in (
""HKCU\Software\DownloadManager" "/v" "FName""
""HKCU\Software\DownloadManager" "/v" "LName""
""HKCU\Software\DownloadManager" "/v" "Email""
""HKCU\Software\DownloadManager" "/v" "Serial""
""HKCU\Software\DownloadManager" "/v" "scansk""
""HKCU\Software\DownloadManager" "/v" "tvfrdt""
""HKCU\Software\DownloadManager" "/v" "radxcnt""
""HKCU\Software\DownloadManager" "/v" "LstCheck""
""HKCU\Software\DownloadManager" "/v" "ptrk_scdt""
""HKCU\Software\DownloadManager" "/v" "LastCheckQU""
"%HKLM%"
) do for /f "tokens=* delims=" %%A in ("%%~#") do (
set "reg="%%~A"" &reg query !reg! %nul% && call :delete_key
)

exit /b
::========================================================================================================================================

::========================================================================================================================================
:add_key

echo:
echo Adding registry key...
echo:

set "reg="%HKLM%" /v "AdvIntDriverEnabled2""

reg add %reg% /t REG_DWORD /d "1" /f %nul%
::========================================================================================================================================

::========================================================================================================================================
:_add_key

if [%errorlevel%]==[0] (
  set "reg=%reg:"=%"
  echo Added - !reg!
) else (
  set _error=1
  set "reg=%reg:"=%"
%_psc% write-host 'Failed' -fore 'white' -back 'DarkRed'  -NoNewline&echo  - !reg!
)
exit /b
::========================================================================================================================================

::========================================================================================================================================
:action

if exist %regdata% del /f /q %regdata% %nul%

reg query %CLSID% > %regdata%

%nul% %_psc% "(gc %regdata%) -replace 'HKEY_CURRENT_USER', 'HKCU' | Out-File -encoding ASCII %regdata%"

for /f %%a in (%regdata%) do (
  for /f "tokens=%_tok% delims=\" %%# in ("%%a") do (
    echo %%#|findstr /r "{.*-.*-.*-.*-.*}" >nul && (set "reg=%%a" & call :scan_key)
  )
)

if exist %regdata% del /f /q %regdata% %nul%

exit /b
::========================================================================================================================================

::========================================================================================================================================
:scan_key

reg query %reg% 2>nul | findstr /i "LocalServer32 InProcServer32 InProcHandler32" >nul && exit /b

reg query %reg% 2>nul | find /i "H" 1>nul || (
%_action%
exit /b
)

for /f "skip=2 tokens=*" %%a in ('reg query %reg% /ve 2^>nul') do echo %%a|findstr /r /e "[^0-9]" >nul || (
  %_action%
  exit /b
)

for /f "skip=2 tokens=3" %%a in ('reg query %reg%\Version /ve 2^>nul') do echo %%a|findstr /r "[^0-9]" >nul || (
  %_action%
  exit /b
)

for /f "skip=2 tokens=1" %%a in ('reg query %reg% 2^>nul') do echo %%a| findstr /i "MData Model scansk Therad" >nul && (
  %_action%
  exit /b
)

for /f "skip=2 tokens=*" %%a in ('reg query %reg% /ve 2^>nul') do echo %%a| find /i "+" >nul && (
  %_action%
  exit /b
)

exit/b
::========================================================================================================================================

::========================================================================================================================================
:delete_key

reg delete %reg% /f %nul%

if not [%errorlevel%]==[0] if defined take_permission (
  %nul% call :reg_own "%reg%" preserve S-1-1-0
  reg delete %reg% /f %nul%
)

if [%errorlevel%]==[0] (
  set "reg=%reg:"=%"
  echo Deleted - !reg!
) else (
  set "reg=%reg:"=%"
  set _error=1
  %_psc% write-host 'Failed' -fore 'white' -back 'DarkRed'  -NoNewline & echo  - !reg!
)

exit /b
::========================================================================================================================================

::========================================================================================================================================
:lock_key

%nul% call :reg_own "%reg%" "" S-1-1-0 S-1-0-0 Deny "FullControl"

reg delete %reg% /f %nul%

if not [%errorlevel%]==[0] (
  set "reg=%reg:"=%"
  echo Locked - !reg!
  set /a lockedkeys+=1
) else (
  set _error=1
  set "reg=%reg:"=%"
  %_psc% write-host 'Failed' -fore 'white' -back 'DarkRed'  -NoNewline&echo  - !reg!
)

exit /b
::========================================================================================================================================

::========================================================================================================================================
:count_key

set /a foundkeys+=1
exit /b

::========================================================================================================================================

::  A lean and mean snippet to set registry ownership and permission recursively
::  Written by @AveYo aka @BAU
::  pastebin.com/XTPt0JSC

:reg_own

%_psc% $A='%~1','%~2','%~3','%~4','%~5','%~6';iex(([io.file]::ReadAllText('!_batp!')-split':Own1\:.*')[1])&exit/b:Own1:
$D1=[uri].module.gettype('System.Diagnostics.Process')."GetM`ethods"(42) |where {$_.Name -eq 'SetPrivilege'} #`:no-ev-warn
'SeSecurityPrivilege','SeTakeOwnershipPrivilege','SeBackupPrivilege','SeRestorePrivilege'|foreach {$D1.Invoke($null, @("$_",2))}
$path=$A[0]; $rk=$path-split'\\',2; $HK=gi -lit Registry::$($rk[0]) -fo; $s=$A[1]; $sps=[Security.Principal.SecurityIdentifier]
$u=($A[2],'S-1-5-32-544')[!$A[2]];$o=($A[3],$u)[!$A[3]];$w=$u,$o |% {new-object $sps($_)}; $old=!$A[3];$own=!$old; $y=$s-eq'all'
$rar=new-object Security.AccessControl.RegistryAccessRule( $w[0], ($A[5],'FullControl')[!$A[5]], 1, 0, ($A[4],'Allow')[!$A[4]] )
$x=$s-eq'none';function Own1($k){$t=$HK.OpenSubKey($k,2,'TakeOwnership');if($t){0,4|%{try{$o=$t.GetAccessControl($_)}catch{$old=0}
};if($old){$own=1;$w[1]=$o.GetOwner($sps)};$o.SetOwner($w[0]);$t.SetAccessControl($o); $c=$HK.OpenSubKey($k,2,'ChangePermissions')
$p=$c.GetAccessControl(2);if($y){$p.SetAccessRuleProtection(1,1)};$p.ResetAccessRule($rar);if($x){$p.RemoveAccessRuleAll($rar)}
$c.SetAccessControl($p);if($own){$o.SetOwner($w[1]);$t.SetAccessControl($o)};if($s){$subkeys=$HK.OpenSubKey($k).GetSubKeyNames()
foreach($n in $subkeys){Own1 "$k\$n"}}}};Own1 $rk[1];if($env:VO){get-acl Registry::$path|fl} #:Own1: powered by cr4r

::========================================================================================================================================

:_color

if %winbuild% GEQ 10586 (
  echo %esc%[%~1%~2%esc%[0m
) else (
  call :batcol %~1 "%~2"
)
exit /b

:_color2

if %winbuild% GEQ 10586 (
  echo %esc%[%~1%~2%esc%[%~3%~4%esc%[0m
) else (
  call :batcol %~1 "%~2" %~3 "%~4"
)
exit /b

::=======================================

:: Colored text with pure batch method
:: Thanks to @dbenham and @jeb
:: https://stackoverflow.com/a/10407642

:: Powershell is not used here because its slow

:batcol

pushd %_coltemp%
if not exist "'" (<nul >"'" set /p "=.")
setlocal
set "s=%~2"
set "t=%~4"
call :_batcol %1 s %3 t
del /f /q "'"
del /f /q "`.txt"
popd
exit /b

:_batcol

setlocal EnableDelayedExpansion
set "s=!%~2!"
set "t=!%~4!"
for /f delims^=^ eol^= %%i in ("!s!") do (
  if "!" equ "" setlocal DisableDelayedExpansion
    >`.txt (echo %%i\..\')
    findstr /a:%~1 /f:`.txt "."
    <nul set /p "=%_BS%%_BS%%_BS%%_BS%%_BS%%_BS%%_BS%"
)
if "%~4"=="" echo(&exit /b
setlocal EnableDelayedExpansion
for /f delims^=^ eol^= %%i in ("!t!") do (
  if "!" equ "" setlocal DisableDelayedExpansion
    >`.txt (echo %%i\..\')
    findstr /a:%~3 /f:`.txt "."
    <nul set /p "=%_BS%%_BS%%_BS%%_BS%%_BS%%_BS%%_BS%"
)
echo(
exit /b

::=======================================

:_colorprep

if %winbuild% GEQ 10586 (
for /F %%a in ('echo prompt $E ^| cmd') do set "esc=%%a"

set     "Red="41;97m""
set    "Gray="100;97m""
set   "Black="30m""
set   "Green="42;97m""
set    "Blue="44;97m""
set  "Yellow="43;97m""
set "Magenta="45;97m""

set    "_Red="40;91m""
set  "_Green="40;92m""
set   "_Blue="40;94m""
set  "_White="40;37m""
set "_Yellow="40;93m""

exit /b
)

if not defined _BS for /f %%A in ('"prompt $H&for %%B in (1) do rem"') do set "_BS=%%A %%A"
set "_coltemp=%SystemRoot%\Temp"

set     "Red="CF""
set    "Gray="8F""
set   "Black="00""
set   "Green="2F""
set    "Blue="1F""
set  "Yellow="6F""
set "Magenta="5F""

set    "_Red="0C""
set  "_Green="0A""
set   "_Blue="09""
set  "_White="07""
set "_Yellow="0E""

exit /b

::========================================================================================================================================

:txt:
_________________________________

   Script aktivasi otomatis:
_________________________________

 - Script ini menerapkan metode kunci registri untuk mengaktifkan Internet download manager (IDM) dan Adobe.

 - Mungkin membutuhkan internet untuk aktivasi.

 - Jika sudah mengaktifkan IDM, tidak akan ada update lagi dari IDM.

 - After the activation, if in some case, the IDM starts to show activation nag screen, 
   then just run the activation option again.

_________________________________

   Reset IDM Activation / Trial:
_________________________________

 - IDM akan direset dan menjadi trial selama 30 hari
 
 - Jika IDM di aktifkan secara penuh, script ini akan menjadi solusi sementara anda

_________________________________

   OS requirement:
_________________________________

 - Projek ini sudah di coba di windows 7/8/8.1/10 dan mungkin berfungsi di server.
_________________________________

 - Advanced Info:
_________________________________

   - To add a custom name in IDM license info, edit the line number 5 in the script file.

   - For activation in unattended mode, run the script with /act parameter.
   - For reset in unattended mode, run the script with /res parameter.
   - To enable silent mode with above two methods, run the script with /s parameter.

Possible accepted values,

"IAS_xxxxxxxx.cmd" /act
"IAS_xxxxxxxx.cmd" /res
"IAS_xxxxxxxx.cmd" /act /s
"IAS_xxxxxxxx.cmd" /res /s

_________________________________

 - Troubleshooting steps:
_________________________________

   -  Aktivasi IDM dengan menekan tombol A
      Pastikan aktivasi sebelumnya sudah di aktifkan dengan benar, Jika masih maka
      Matikan firewall, lalu tekan I untuk memblokir situs IDM

   - Hapus IDM melalui control panel atau aplikasi uninstaller lainnya.

   - Tetap gunakan IDM yang asli yang dapat di download di website resminya

   - Install IDM terbaru jika gagal, maka

     - Matikan firewall 
     - Matikan antivirus yang dapat menyebabkan membuka blokiran situs IDM/Adobe
     - Editt program sendiri hehe
____________________________________________________________________________________________________
:txt:

::========================================================================================================================================