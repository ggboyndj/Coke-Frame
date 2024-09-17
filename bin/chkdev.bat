::call chkdev system     rechk(可选)  复查前等待秒数(默认3)
::            recovery   rechk(可选)  复查前等待秒数(默认3)
::            sideload   rechk(可选)  复查前等待秒数(默认3)
::            fastboot   rechk(可选)  复查前等待秒数(默认3)
::            edl        rechk(可选)  复查前等待秒数(默认3)
::            diag901d   rechk(可选)  复查前等待秒数(默认3)
::            sprdboot   rechk(可选)  复查前等待秒数(默认3)
::            mtkbrom    rechk(可选)  复查前等待秒数(默认3)
::            all        rechk(可选)  复查前等待秒数(默认3)

@ECHO OFF
call log chkdev.bat I 开始检查设备连接:%1
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%



:MTKPRELOADER
::接收参数
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::开始
:MTKPRELOADER-1
ECHO.正在检查设备连接(联发科preloader模式)... & set try_times=0
:MTKPRELOADER-2
if %try_times% GTR 30 ECHO.本次未检测到目标设备, 按任意键重新检测... & pause>nul & goto MTKPRELOADER-1
set /a try_times+=1
for /f %%a in ('devcon.exe find usb* ^| find /c " PreLoader USB VCOM "') do (if %%a GTR 1 ECHOC {%c_e%}有多个联发科preloader模式设备连接! 请断开其他设备.{%c_i%}{\n}& devcon.exe find usb* | find /c " PreLoader USB VCOM " & ECHOC {%c_h%}按任意键重新检查...{%c_i%}{\n}& pause>nul & goto MTKPRELOADER-1)
for /f %%a in ('devcon.exe find usb* ^| find /c " PreLoader USB VCOM "') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto MTKPRELOADER-2)
::目标设备已经检测到
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%秒后将再次检查, 请稍候... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto MTKPRELOADER-1
devcon.exe find usb* | find " PreLoader USB VCOM " 1>tmp\output.txt
set num=2
:MTKPRELOADER-3
set var=
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
if not "%var%"=="" set /a num+=1& goto MTKPRELOADER-3
set /a num+=-1
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
set port=%var:~3,999%
ECHO.设备已连接(mtkpreloader, COM%port%)& call log chkdev.bat-all I 设备已连接:mtkpreloader.COM%port%
ENDLOCAL & set chkdev__mtkpreloader_port=%port%& set chkdev__mtkpreloader__port=%port%
goto :eof


:MTKBROM
::接收参数
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::开始
:MTKBROM-1
ECHO.正在检查设备连接(联发科brom模式)... & set try_times=0
:MTKBROM-2
if %try_times% GTR 30 ECHO.本次未检测到目标设备, 按任意键重新检测... & pause>nul & goto MTKBROM-1
set /a try_times+=1
for /f %%a in ('devcon.exe find usb* ^| find /c "MediaTek USB Port ("') do (if %%a GTR 1 ECHOC {%c_e%}有多个联发科brom模式设备连接! 请断开其他设备.{%c_i%}{\n}& devcon.exe find usb* | find /c "MediaTek USB Port (" & ECHOC {%c_h%}按任意键重新检查...{%c_i%}{\n}& pause>nul & goto MTKBROM-1)
for /f %%a in ('devcon.exe find usb* ^| find /c "MediaTek USB Port ("') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto MTKBROM-2)
::目标设备已经检测到
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%秒后将再次检查, 请稍候... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto MTKBROM-1
devcon.exe find usb* | find "MediaTek USB Port (" 1>tmp\output.txt
set num=2
:MTKBROM-3
set var=
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
if not "%var%"=="" set /a num+=1& goto MTKBROM-3
set /a num+=-1
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
set port=%var:~3,999%
ECHO.设备已连接(联发科brom模式, COM%port%)& call log chkdev.bat-all I 设备已连接:mtkbrom.COM%port%
ENDLOCAL & set chkdev__mtkbrom_port=%port%& set chkdev__mtkbrom__port=%port%
goto :eof


:SPRDBOOT
::接收参数
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::开始
:SPRDBOOT-1
ECHO.正在检查设备连接(展讯boot模式)... & set try_times=0
:SPRDBOOT-2
if %try_times% GTR 30 ECHO.本次未检测到目标设备, 按任意键重新检测... & pause>nul & goto SPRDBOOT-1
set /a try_times+=1
for /f %%a in ('devcon.exe find usb* ^| find /c "SPRD U2S Diag"') do (if %%a GTR 1 ECHOC {%c_e%}有多个展讯boot模式设备连接! 请断开其他设备.{%c_i%}{\n}& devcon.exe find usb* | find /c "SPRD U2S Diag" & ECHOC {%c_h%}按任意键重新检查...{%c_i%}{\n}& pause>nul & goto SPRDBOOT-1)
for /f %%a in ('devcon.exe find usb* ^| find /c "SPRD U2S Diag"') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto SPRDBOOT-2)
::目标设备已经检测到
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%秒后将再次检查, 请稍候... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto SPRDBOOT-1
devcon.exe find usb* | find "SPRD U2S Diag" 1>tmp\output.txt
set num=2
:SPRDBOOT-3
set var=
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
if not "%var%"=="" set /a num+=1& goto SPRDBOOT-3
set /a num+=-1
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
set port=%var:~3,999%
ECHO.设备已连接(展讯boot模式, COM%port%)& call log chkdev.bat-all I 设备已连接:sprdboot.COM%port%
ENDLOCAL & set chkdev__sprdboot_port=%port%& set chkdev__sprdboot__port=%port%
goto :eof


:SYSTEM
::接收参数
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::开始
:SYSTEM-1
ECHO.正在检查设备连接(系统)... & set try_times=0& adb.exe start-server>nul
:SYSTEM-2
if %try_times% GTR 30 ECHO.本次未检测到目标设备, 按任意键重新检测... & pause>nul & goto SYSTEM-1
set /a try_times+=1
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a GTR 1 ECHOC {%c_e%}有多个ADB设备连接! 请断开其他设备.{%c_i%}{\n}& adb.exe devices -l | find /v "List of devices attached" | find " " & ECHOC {%c_h%}按任意键重新检查...{%c_i%}{\n}& pause>nul & goto SYSTEM-1)
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto SYSTEM-2)
for /f "tokens=2 delims= " %%i in ('adb.exe devices -l ^| find /v "List of devices attached"') do (if not "%%i"=="device" TIMEOUT /T 1 /NOBREAK>nul & goto SYSTEM-2)
::目标设备已经检测到
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%秒后将再次检查, 请稍候... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto SYSTEM-1
ECHO.设备已连接(系统) & ENDLOCAL & call log chkdev.bat-system I 设备已连接:%var1%& goto :eof


:RECOVERY
::接收参数
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::开始
:RECOVERY-1
ECHO.正在检查设备连接(Recovery)... & set try_times=0& adb.exe start-server 1>nul
:RECOVERY-2
if %try_times% GTR 30 ECHO.本次未检测到目标设备, 按任意键重新检测... & pause>nul & goto RECOVERY-1
set /a try_times+=1
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a GTR 1 ECHOC {%c_e%}有多个ADB设备连接! 请断开其他设备.{%c_i%}{\n}& adb.exe devices -l | find /v "List of devices attached" | find " " & ECHOC {%c_h%}按任意键重新检查...{%c_i%}{\n}& pause>nul & goto RECOVERY-1)
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto RECOVERY-2)
for /f "tokens=2 delims= " %%i in ('adb.exe devices -l ^| find /v "List of devices attached"') do (if not "%%i"=="recovery" TIMEOUT /T 1 /NOBREAK>nul & goto RECOVERY-2)
::目标设备已经检测到
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%秒后将再次检查, 请稍候... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto RECOVERY-1
ECHO.设备已连接(Recovery) & ENDLOCAL & call log chkdev.bat-recovery I 设备已连接:%var1%& goto :eof


:SIDELOAD
::接收参数
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::开始
:SIDELOAD-1
ECHO.正在检查设备连接(Sideload)... & set try_times=0& adb.exe start-server 1>nul
:SIDELOAD-2
if %try_times% GTR 30 ECHO.本次未检测到目标设备, 按任意键重新检测... & pause>nul & goto SIDELOAD-1
set /a try_times+=1
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a GTR 1 ECHOC {%c_e%}有多个ADB设备连接! 请断开其他设备.{%c_i%}{\n}& adb.exe devices -l | find /v "List of devices attached" | find " " & ECHOC {%c_h%}按任意键重新检查...{%c_i%}{\n}& pause>nul & goto SIDELOAD-1)
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto SIDELOAD-2)
for /f "tokens=2 delims= " %%i in ('adb.exe devices -l ^| find /v "List of devices attached"') do (if not "%%i"=="sideload" TIMEOUT /T 1 /NOBREAK>nul & goto SIDELOAD-2)
::目标设备已经检测到
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%秒后将再次检查, 请稍候... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto SIDELOAD-1
ECHO.设备已连接(Sideload) & ENDLOCAL & call log chkdev.bat-sideload I 设备已连接:%var1%& goto :eof


:FASTBOOT
::接收参数
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::开始
:FASTBOOT-1
ECHO.正在检查设备连接(Fastboot)... & set try_times=0
:FASTBOOT-2
if %try_times% GTR 30 ECHO.本次未检测到目标设备, 按任意键重新检测... & pause>nul & goto FASTBOOT-1
set /a try_times+=1
for /f %%a in ('fastboot.exe devices ^| find /c "	"') do (if %%a GTR 1 ECHOC {%c_e%}有多个Fastboot设备连接! 请断开其他设备.{%c_i%}{\n}& fastboot.exe devices | find "	" & ECHOC {%c_h%}按任意键重新检查...{%c_i%}{\n}& pause>nul & goto FASTBOOT-1)
for /f %%a in ('fastboot.exe devices ^| find /c "	"') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto FASTBOOT-2)
for /f "tokens=2 delims= " %%i in ('fastboot.exe devices ^| find "	"') do (if not "%%i"=="fastboot" TIMEOUT /T 1 /NOBREAK>nul & goto FASTBOOT-2)
::目标设备已经检测到
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%秒后将再次检查, 请稍候... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto FASTBOOT-1
ECHO.设备已连接(Fastboot) & ENDLOCAL & call log chkdev.bat-fastboot I 设备已连接:%var1%& goto :eof


:FASTBOOTD
::接收参数
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::开始
:FASTBOOTD-1
ECHO.正在检查设备连接(Fastbootd)... & set try_times=0
:FASTBOOTD-2
if %try_times% GTR 30 ECHO.本次未检测到目标设备, 按任意键重新检测... & pause>nul & goto FASTBOOTD-1
set /a try_times+=1
for /f %%a in ('fastboot.exe devices ^| find /c "	"') do (if %%a GTR 1 ECHOC {%c_e%}有多个Fastboot设备连接! 请断开其他设备.{%c_i%}{\n}& fastboot.exe devices | find "	" & ECHOC {%c_h%}按任意键重新检查...{%c_i%}{\n}& pause>nul & goto FASTBOOTD-1)
for /f %%a in ('fastboot.exe devices ^| find /c "	"') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto FASTBOOTD-2)
for /f "tokens=2 delims= " %%i in ('fastboot.exe devices ^| find "	"') do (if not "%%i"=="fastboot" TIMEOUT /T 1 /NOBREAK>nul & goto FASTBOOTD-2)
::目标设备已经检测到
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%秒后将再次检查, 请稍候... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto FASTBOOTD-1
ECHO.设备已连接(Fastbootd) & ENDLOCAL & call log chkdev.bat-fastbootd I 设备已连接:%var1%& goto :eof


:EDL
::接收参数
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::开始
:EDL-1
ECHO.正在检查设备连接(edl)... & set try_times=0
:EDL-2
if %try_times% GTR 30 ECHO.本次未检测到目标设备, 按任意键重新检测... & pause>nul & goto EDL-1
set /a try_times+=1
for /f %%a in ('devcon.exe find usb* ^| find /c "Qualcomm HS-USB QDLoader 9008"') do (if %%a GTR 1 ECHOC {%c_e%}有多个edl设备连接! 请断开其他设备.{%c_i%}{\n}& devcon.exe find usb* | find /c "Qualcomm HS-USB QDLoader 9008" & ECHOC {%c_h%}按任意键重新检查...{%c_i%}{\n}& pause>nul & goto EDL-1)
for /f %%a in ('devcon.exe find usb* ^| find /c "Qualcomm HS-USB QDLoader 9008"') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto EDL-2)
::目标设备已经检测到
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%秒后将再次检查, 请稍候... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto EDL-1
devcon.exe find usb* | find "Qualcomm HS-USB QDLoader 9008" 1>tmp\output.txt
set num=2
:EDL-3
set var=
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
if not "%var%"=="" set /a num+=1& goto EDL-3
set /a num+=-1
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
set port=%var:~3,999%
ECHO.设备已连接(edl, COM%port%)& call log chkdev.bat-all I 设备已连接:edl.COM%port%
ENDLOCAL & set chkdev__edl_port=%port%& set chkdev__edl__port=%port%
goto :eof


:DIAG901D
::接收参数
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::开始
:DIAG901D-1
ECHO.正在检查设备连接(diag901d)... & set try_times=0
:DIAG901D-2
if %try_times% GTR 30 ECHO.本次未检测到目标设备, 按任意键重新检测... & pause>nul & goto DIAG901D-1
set /a try_times+=1
for /f %%a in ('devcon.exe find usb* ^| find /c "Qualcomm HS-USB Android DIAG 901D"') do (if %%a GTR 1 ECHOC {%c_e%}有多个diag901d设备连接! 请断开其他设备.{%c_i%}{\n}& devcon.exe find usb* | find /c "Qualcomm HS-USB Android DIAG 901D" & ECHOC {%c_h%}按任意键重新检查...{%c_i%}{\n}& pause>nul & goto DIAG901D-1)
for /f %%a in ('devcon.exe find usb* ^| find /c "Qualcomm HS-USB Android DIAG 901D"') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto DIAG901D-2)
::目标设备已经检测到
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%秒后将再次检查, 请稍候... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto DIAG901D-1
devcon.exe find usb* | find "Qualcomm HS-USB Android DIAG 901D" 1>tmp\output.txt
set num=2
:DIAG901D-3
set var=
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
if not "%var%"=="" set /a num+=1& goto DIAG901D-3
set /a num+=-1
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
set port=%var:~3,999%
ECHO.设备已连接(diag901d, COM%port%)& call log chkdev.bat-all I 设备已连接:diag901d.COM%port%
ENDLOCAL & set chkdev__diag901d_port=%port%& set chkdev__diag901d__port=%port%
goto :eof


:ALL
::接收参数
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::开始
:ALL-1
ECHO.正在检查设备连接(全部)... & set try_times=0& adb.exe start-server 1>nul
:ALL-2
set devnum=0
if %try_times% GTR 30 ECHO.本次未检测到目标设备, 按任意键重新检测... & pause>nul & goto ALL-1
set /a try_times+=1
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do set /a devnum+=%%a
for /f "tokens=2 delims= " %%i in ('adb.exe devices -l ^| find /v "List of devices attached"') do (if not "%%i"=="" set devmode=%%i)
for /f %%a in ('fastboot.exe devices ^| find /c "	"') do set /a devnum+=%%a
for /f "tokens=2 delims=	" %%i in ('fastboot.exe devices ^| find "	"') do (if not "%%i"=="" set devmode=%%i)
for /f %%a in ('devcon.exe find usb* ^| find /c "Qualcomm HS-USB QDLoader 9008"') do set /a devnum+=%%a
devcon.exe find usb* | find "Qualcomm HS-USB QDLoader 9008" 1>nul 2>nul && set devmode=edl
for /f %%a in ('devcon.exe find usb* ^| find /c "SPRD U2S Diag"') do set /a devnum+=%%a
devcon.exe find usb* | find "SPRD U2S Diag" 1>nul 2>nul && set devmode=sprdboot
for /f %%a in ('devcon.exe find usb* ^| find /c "MediaTek USB Port ("') do set /a devnum+=%%a
devcon.exe find usb* | find "MediaTek USB Port (" 1>nul 2>nul && set devmode=mtkbrom
for /f %%a in ('devcon.exe find usb* ^| find /c " PreLoader USB VCOM "') do set /a devnum+=%%a
devcon.exe find usb* | find " PreLoader USB VCOM " 1>nul 2>nul && set devmode=mtkpreloader
::先检查总设备数
if %devnum% GTR 1 ECHOC {%c_e%}有多个设备连接! 请断开其他设备.{%c_i%}{\n}& ECHOC {%c_h%}按任意键重新检查...{%c_i%}{\n}& pause>nul & goto ALL-1
if not "%devnum%"=="1" TIMEOUT /T 1 /NOBREAK>nul& goto ALL-2
::设备数是1,继续判断模式
if "%devmode%"=="device" set devmode=system& goto ALL-3
if "%devmode%"=="recovery" goto ALL-3
if "%devmode%"=="sideload" goto ALL-3
if "%devmode%"=="fastboot" goto ALL-3
if "%devmode%"=="edl" goto ALL-3
if "%devmode%"=="sprdboot" goto ALL-3
if "%devmode%"=="mtkbrom" goto ALL-3
if "%devmode%"=="mtkpreloader" goto ALL-3
TIMEOUT /T 1 /NOBREAK>nul& goto ALL-2
:ALL-3
::目标设备已经检测到
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%秒后将再次检查, 请稍候... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto ALL-1
if "%devmode%"=="edl" goto ALL-CHKPORT
if "%devmode%"=="sprdboot" goto ALL-CHKPORT
if "%devmode%"=="mtkbrom" goto ALL-CHKPORT
if "%devmode%"=="mtkpreloader" goto ALL-CHKPORT
ECHO.设备已连接(%devmode%)& call log chkdev.bat-all I 设备已连接:%devmode%
ENDLOCAL & set chkdev__all__mode=%devmode%
goto :eof
:ALL-CHKPORT
if "%devmode%"=="edl" devcon.exe find usb* | find "Qualcomm HS-USB QDLoader 9008" 1>tmp\output.txt
if "%devmode%"=="sprdboot" devcon.exe find usb* | find "SPRD U2S Diag" 1>tmp\output.txt
if "%devmode%"=="mtkbrom" devcon.exe find usb* | find "MediaTek USB Port (" 1>tmp\output.txt
if "%devmode%"=="mtkpreloader" devcon.exe find usb* | find " PreLoader USB VCOM " 1>tmp\output.txt
set num=2
:ALL-CHKPORT-1
set var=
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
if not "%var%"=="" set /a num+=1& goto ALL-CHKPORT-1
set /a num+=-1
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
set port=%var:~3,999%
ECHO.设备已连接(%devmode%, COM%port%)& call log chkdev.bat-all I 设备已连接:%devmode%.COM%port%
ENDLOCAL & set chkdev__all__mode=%devmode%& set chkdev__all__port=%port%& set chkdev__%devmode%_port=%port%& set chkdev__%devmode%__port=%port%
goto :eof


:::usb3chk
::call log chkdev.bat I 开始检查目标设备是否连接在USB3插口上
::usbdump.exe | find /N " " 1>tmp\output.txt
::for /f "tokens=1 delims=[]" %%i in ('find /I "%1" "tmp\output.txt"') do set /a var01=%%i+2
::for /f "tokens=2 delims=[]" %%i in ('find "[%var01%]" "tmp\output.txt"') do set var02=%%i
::for /f "tokens=1 delims=[]" %%i in ('find "]%var02%" "tmp\output.txt" ^| find /N " " ^| find "[%var01%]"') do set /a var03=%%i-1
::for /f "tokens=2 delims=[]" %%i in ('find "]%var02%" "tmp\output.txt" ^| find /N " " ^| find "[%var03%]["') do set /a var04=%%i+23
::set usb3=unknown
::for /f "tokens=3 delims= " %%i in ('find "[%var04%]" "tmp\output.txt" ^| find "Usb300"') do set usb3=%%i
::call log chkdev.bat I USB3检查结果为:%usb3%
::goto :eof








:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}抱歉, 脚本遇到问题, 无法继续运行. 请查看日志. {%c_h%}按任意键退出...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.抱歉, 脚本遇到问题, 无法继续运行. 按任意键退出...& pause>nul & EXIT)

