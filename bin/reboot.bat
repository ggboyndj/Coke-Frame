::call reboot system     [system recovery fastboot edl diag901d sprdboot]   [chk rechk](可选)  如果rechk则填秒数(可选)
::            recovery   [system recovery fastboot edl sideload sprdboot]   [chk rechk](可选)  如果rechk则填秒数(可选)
::            fastboot   [system recovery fastboot fastbootd edl]           [chk rechk](可选)  如果rechk则填秒数(可选)
::            fastbootd  [system fastboot fastbootd]                        [chk rechk](可选)  如果rechk则填秒数(可选)
::

@ECHO OFF

set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
SETLOCAL
set logger=reboot.bat
set frommode=%var1%& set tomode=%var2%& set chkdev=%var3%& set rechkwait=%var4%
call log %logger% I 接收变量:frommode:%frommode%.tomode:%tomode%.chkdev:%chkdev%.rechkwait:%rechkwait%
find /I ":%frommode%-%tomode%" "%framwork_workspace%\reboot.bat" 1>nul 2>nul || goto UNSUPPORT
goto %frommode%-%tomode%

:SYSTEM-SYSTEM
goto COMMON-ADB-SYSTEM

:SYSTEM-RECOVERY
goto COMMON-ADB-RECOVERY

:SYSTEM-FASTBOOT
goto COMMON-ADB-FASTBOOT

:SYSTEM-EDL
goto COMMON-ADB-EDL

:SYSTEM-DIAG901D
echo.su>tmp\cmd.txt & echo.setprop sys.usb.config diag,adb>>tmp\cmd.txt
adb.exe shell < tmp\cmd.txt 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:SYSTEM-SPRDBOOT
goto COMMON-ADB-SPRDBOOT

:RECOVERY-SYSTEM
goto COMMON-ADB-SYSTEM

:RECOVERY-RECOVERY
goto COMMON-ADB-RECOVERY

:RECOVERY-FASTBOOT
goto COMMON-ADB-FASTBOOT

:RECOVERY-EDL
goto COMMON-ADB-EDL

:RECOVERY-SIDELOAD
adb.exe shell twrp sideload 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:RECOVERY-SPRDBOOT
goto COMMON-ADB-SPRDBOOT

:FASTBOOT-SYSTEM
goto COMMON-FASTBOOT-SYSTEM

:FASTBOOT-RECOVERY
::不同机型可以采用不同的方案,此处默认使用OEM法
goto FASTBOOT-RECOVERY-OEM
:FASTBOOT-RECOVERY-OEM
fastboot.exe oem reboot-recovery 1>>%logfile% 2>&1 && goto FINISH
goto FAILED
:FASTBOOT-RECOVERY-MISC
call write fastboot misc tool\Android\misc_torecovery.img
fastboot.exe reboot 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:FASTBOOT-FASTBOOT
goto COMMON-FASTBOOT-FASTBOOT

:FASTBOOT-FASTBOOTD
goto COMMON-FASTBOOT-FASTBOOTD

:FASTBOOT-EDL
::不同机型可以采用不同的方案,此处默认使用OEM1法
goto FASTBOOT-EDL-OEM1
:FASTBOOT-EDL-OEM1
fastboot.exe oem edl 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:FASTBOOTD-SYSTEM
goto COMMON-FASTBOOT-SYSTEM

:FASTBOOTD-FASTBOOT
goto COMMON-FASTBOOT-FASTBOOT

:FASTBOOTD-FASTBOOTD
goto COMMON-FASTBOOT-FASTBOOTD










:COMMON-ADB-SYSTEM
adb.exe reboot 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:COMMON-ADB-RECOVERY
adb.exe reboot recovery 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:COMMON-ADB-FASTBOOT
adb.exe reboot bootloader 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:COMMON-ADB-EDL
adb.exe reboot edl 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:COMMON-ADB-SPRDBOOT
adb.exe reboot reboot autodloader 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:COMMON-FASTBOOT-SYSTEM
fastboot.exe reboot 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:COMMON-FASTBOOT-FASTBOOT
fastboot.exe reboot bootloader 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:COMMON-FASTBOOT-FASTBOOTD
fastboot.exe reboot fastboot 1>>%logfile% 2>&1 && goto FINISH
goto FAILED



:FAILED
ECHOC {%c_e%}进入%tomode%模式失败{%c_i%}{\n}& call log %logger% E 进入%tomode%模式失败
ECHO.1.再次尝试   2.我已进入,可以继续
call choice common [1][2]
if "%choice%"=="1" ECHO.重试... & goto %frommode%-%tomode%
if "%choice%"=="2" goto FINISH
:UNSUPPORT
ECHOC {%c_e%}不支持自动从%frommode%重启到%tomode%. {%c_h%}请手动进入%tomode%, 完成后按任意键继续...{%c_i%}{\n}& call log %logger% E 不支持自动从%frommode%重启到%tomode%.提示手动重启& pause>nul & ECHO.继续...
goto FINISH
:FINISH
call log %logger% I 重启完成.如需检查连接则检查
if "%chkdev%"=="chk" call chkdev %tomode%
if "%chkdev%"=="rechk" call chkdev %tomode% rechk %rechkwait%
::最后要把检查连接里涉及的结果传出
ENDLOCAL & set chkdev__edl_port=%chkdev__edl_port%& set chkdev__edl__port=%chkdev__edl__port%& set chkdev__diag901d_port=%chkdev__diag901d_port%& set chkdev__diag901d__port=%chkdev__diag901d__port%& set chkdev__sprdboot_port=%chkdev__sprdboot_port%& set chkdev__sprdboot__port=%chkdev__sprdboot__port%
goto :eof
