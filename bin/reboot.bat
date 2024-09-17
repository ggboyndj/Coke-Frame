::call reboot system     [system recovery fastboot edl diag901d sprdboot]   [chk rechk](��ѡ)  ���rechk��������(��ѡ)
::            recovery   [system recovery fastboot edl sideload sprdboot]   [chk rechk](��ѡ)  ���rechk��������(��ѡ)
::            fastboot   [system recovery fastboot fastbootd edl]           [chk rechk](��ѡ)  ���rechk��������(��ѡ)
::            fastbootd  [system fastboot fastbootd]                        [chk rechk](��ѡ)  ���rechk��������(��ѡ)
::

@ECHO OFF

set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
SETLOCAL
set logger=reboot.bat
set frommode=%var1%& set tomode=%var2%& set chkdev=%var3%& set rechkwait=%var4%
call log %logger% I ���ձ���:frommode:%frommode%.tomode:%tomode%.chkdev:%chkdev%.rechkwait:%rechkwait%
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
::��ͬ���Ϳ��Բ��ò�ͬ�ķ���,�˴�Ĭ��ʹ��OEM��
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
::��ͬ���Ϳ��Բ��ò�ͬ�ķ���,�˴�Ĭ��ʹ��OEM1��
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
ECHOC {%c_e%}����%tomode%ģʽʧ��{%c_i%}{\n}& call log %logger% E ����%tomode%ģʽʧ��
ECHO.1.�ٴγ���   2.���ѽ���,���Լ���
call choice common [1][2]
if "%choice%"=="1" ECHO.����... & goto %frommode%-%tomode%
if "%choice%"=="2" goto FINISH
:UNSUPPORT
ECHOC {%c_e%}��֧���Զ���%frommode%������%tomode%. {%c_h%}���ֶ�����%tomode%, ��ɺ����������...{%c_i%}{\n}& call log %logger% E ��֧���Զ���%frommode%������%tomode%.��ʾ�ֶ�����& pause>nul & ECHO.����...
goto FINISH
:FINISH
call log %logger% I �������.��������������
if "%chkdev%"=="chk" call chkdev %tomode%
if "%chkdev%"=="rechk" call chkdev %tomode% rechk %rechkwait%
::���Ҫ�Ѽ���������漰�Ľ������
ENDLOCAL & set chkdev__edl_port=%chkdev__edl_port%& set chkdev__edl__port=%chkdev__edl__port%& set chkdev__diag901d_port=%chkdev__diag901d_port%& set chkdev__diag901d__port=%chkdev__diag901d__port%& set chkdev__sprdboot_port=%chkdev__sprdboot_port%& set chkdev__sprdboot__port=%chkdev__sprdboot__port%
goto :eof
