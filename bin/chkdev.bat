::call chkdev system     rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            recovery   rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            sideload   rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            fastboot   rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            edl        rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            diag901d   rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            sprdboot   rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            mtkbrom    rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            all        rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)

@ECHO OFF
call log chkdev.bat I ��ʼ����豸����:%1
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%



:MTKPRELOADER
::���ղ���
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::��ʼ
:MTKPRELOADER-1
ECHO.���ڼ���豸����(������preloaderģʽ)... & set try_times=0
:MTKPRELOADER-2
if %try_times% GTR 30 ECHO.����δ��⵽Ŀ���豸, ����������¼��... & pause>nul & goto MTKPRELOADER-1
set /a try_times+=1
for /f %%a in ('devcon.exe find usb* ^| find /c " PreLoader USB VCOM "') do (if %%a GTR 1 ECHOC {%c_e%}�ж��������preloaderģʽ�豸����! ��Ͽ������豸.{%c_i%}{\n}& devcon.exe find usb* | find /c " PreLoader USB VCOM " & ECHOC {%c_h%}����������¼��...{%c_i%}{\n}& pause>nul & goto MTKPRELOADER-1)
for /f %%a in ('devcon.exe find usb* ^| find /c " PreLoader USB VCOM "') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto MTKPRELOADER-2)
::Ŀ���豸�Ѿ���⵽
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%����ٴμ��, ���Ժ�... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto MTKPRELOADER-1
devcon.exe find usb* | find " PreLoader USB VCOM " 1>tmp\output.txt
set num=2
:MTKPRELOADER-3
set var=
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
if not "%var%"=="" set /a num+=1& goto MTKPRELOADER-3
set /a num+=-1
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
set port=%var:~3,999%
ECHO.�豸������(mtkpreloader, COM%port%)& call log chkdev.bat-all I �豸������:mtkpreloader.COM%port%
ENDLOCAL & set chkdev__mtkpreloader_port=%port%& set chkdev__mtkpreloader__port=%port%
goto :eof


:MTKBROM
::���ղ���
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::��ʼ
:MTKBROM-1
ECHO.���ڼ���豸����(������bromģʽ)... & set try_times=0
:MTKBROM-2
if %try_times% GTR 30 ECHO.����δ��⵽Ŀ���豸, ����������¼��... & pause>nul & goto MTKBROM-1
set /a try_times+=1
for /f %%a in ('devcon.exe find usb* ^| find /c "MediaTek USB Port ("') do (if %%a GTR 1 ECHOC {%c_e%}�ж��������bromģʽ�豸����! ��Ͽ������豸.{%c_i%}{\n}& devcon.exe find usb* | find /c "MediaTek USB Port (" & ECHOC {%c_h%}����������¼��...{%c_i%}{\n}& pause>nul & goto MTKBROM-1)
for /f %%a in ('devcon.exe find usb* ^| find /c "MediaTek USB Port ("') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto MTKBROM-2)
::Ŀ���豸�Ѿ���⵽
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%����ٴμ��, ���Ժ�... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto MTKBROM-1
devcon.exe find usb* | find "MediaTek USB Port (" 1>tmp\output.txt
set num=2
:MTKBROM-3
set var=
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
if not "%var%"=="" set /a num+=1& goto MTKBROM-3
set /a num+=-1
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
set port=%var:~3,999%
ECHO.�豸������(������bromģʽ, COM%port%)& call log chkdev.bat-all I �豸������:mtkbrom.COM%port%
ENDLOCAL & set chkdev__mtkbrom_port=%port%& set chkdev__mtkbrom__port=%port%
goto :eof


:SPRDBOOT
::���ղ���
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::��ʼ
:SPRDBOOT-1
ECHO.���ڼ���豸����(չѶbootģʽ)... & set try_times=0
:SPRDBOOT-2
if %try_times% GTR 30 ECHO.����δ��⵽Ŀ���豸, ����������¼��... & pause>nul & goto SPRDBOOT-1
set /a try_times+=1
for /f %%a in ('devcon.exe find usb* ^| find /c "SPRD U2S Diag"') do (if %%a GTR 1 ECHOC {%c_e%}�ж��չѶbootģʽ�豸����! ��Ͽ������豸.{%c_i%}{\n}& devcon.exe find usb* | find /c "SPRD U2S Diag" & ECHOC {%c_h%}����������¼��...{%c_i%}{\n}& pause>nul & goto SPRDBOOT-1)
for /f %%a in ('devcon.exe find usb* ^| find /c "SPRD U2S Diag"') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto SPRDBOOT-2)
::Ŀ���豸�Ѿ���⵽
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%����ٴμ��, ���Ժ�... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto SPRDBOOT-1
devcon.exe find usb* | find "SPRD U2S Diag" 1>tmp\output.txt
set num=2
:SPRDBOOT-3
set var=
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
if not "%var%"=="" set /a num+=1& goto SPRDBOOT-3
set /a num+=-1
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
set port=%var:~3,999%
ECHO.�豸������(չѶbootģʽ, COM%port%)& call log chkdev.bat-all I �豸������:sprdboot.COM%port%
ENDLOCAL & set chkdev__sprdboot_port=%port%& set chkdev__sprdboot__port=%port%
goto :eof


:SYSTEM
::���ղ���
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::��ʼ
:SYSTEM-1
ECHO.���ڼ���豸����(ϵͳ)... & set try_times=0& adb.exe start-server>nul
:SYSTEM-2
if %try_times% GTR 30 ECHO.����δ��⵽Ŀ���豸, ����������¼��... & pause>nul & goto SYSTEM-1
set /a try_times+=1
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a GTR 1 ECHOC {%c_e%}�ж��ADB�豸����! ��Ͽ������豸.{%c_i%}{\n}& adb.exe devices -l | find /v "List of devices attached" | find " " & ECHOC {%c_h%}����������¼��...{%c_i%}{\n}& pause>nul & goto SYSTEM-1)
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto SYSTEM-2)
for /f "tokens=2 delims= " %%i in ('adb.exe devices -l ^| find /v "List of devices attached"') do (if not "%%i"=="device" TIMEOUT /T 1 /NOBREAK>nul & goto SYSTEM-2)
::Ŀ���豸�Ѿ���⵽
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%����ٴμ��, ���Ժ�... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto SYSTEM-1
ECHO.�豸������(ϵͳ) & ENDLOCAL & call log chkdev.bat-system I �豸������:%var1%& goto :eof


:RECOVERY
::���ղ���
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::��ʼ
:RECOVERY-1
ECHO.���ڼ���豸����(Recovery)... & set try_times=0& adb.exe start-server 1>nul
:RECOVERY-2
if %try_times% GTR 30 ECHO.����δ��⵽Ŀ���豸, ����������¼��... & pause>nul & goto RECOVERY-1
set /a try_times+=1
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a GTR 1 ECHOC {%c_e%}�ж��ADB�豸����! ��Ͽ������豸.{%c_i%}{\n}& adb.exe devices -l | find /v "List of devices attached" | find " " & ECHOC {%c_h%}����������¼��...{%c_i%}{\n}& pause>nul & goto RECOVERY-1)
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto RECOVERY-2)
for /f "tokens=2 delims= " %%i in ('adb.exe devices -l ^| find /v "List of devices attached"') do (if not "%%i"=="recovery" TIMEOUT /T 1 /NOBREAK>nul & goto RECOVERY-2)
::Ŀ���豸�Ѿ���⵽
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%����ٴμ��, ���Ժ�... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto RECOVERY-1
ECHO.�豸������(Recovery) & ENDLOCAL & call log chkdev.bat-recovery I �豸������:%var1%& goto :eof


:SIDELOAD
::���ղ���
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::��ʼ
:SIDELOAD-1
ECHO.���ڼ���豸����(Sideload)... & set try_times=0& adb.exe start-server 1>nul
:SIDELOAD-2
if %try_times% GTR 30 ECHO.����δ��⵽Ŀ���豸, ����������¼��... & pause>nul & goto SIDELOAD-1
set /a try_times+=1
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a GTR 1 ECHOC {%c_e%}�ж��ADB�豸����! ��Ͽ������豸.{%c_i%}{\n}& adb.exe devices -l | find /v "List of devices attached" | find " " & ECHOC {%c_h%}����������¼��...{%c_i%}{\n}& pause>nul & goto SIDELOAD-1)
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto SIDELOAD-2)
for /f "tokens=2 delims= " %%i in ('adb.exe devices -l ^| find /v "List of devices attached"') do (if not "%%i"=="sideload" TIMEOUT /T 1 /NOBREAK>nul & goto SIDELOAD-2)
::Ŀ���豸�Ѿ���⵽
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%����ٴμ��, ���Ժ�... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto SIDELOAD-1
ECHO.�豸������(Sideload) & ENDLOCAL & call log chkdev.bat-sideload I �豸������:%var1%& goto :eof


:FASTBOOT
::���ղ���
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::��ʼ
:FASTBOOT-1
ECHO.���ڼ���豸����(Fastboot)... & set try_times=0
:FASTBOOT-2
if %try_times% GTR 30 ECHO.����δ��⵽Ŀ���豸, ����������¼��... & pause>nul & goto FASTBOOT-1
set /a try_times+=1
for /f %%a in ('fastboot.exe devices ^| find /c "	"') do (if %%a GTR 1 ECHOC {%c_e%}�ж��Fastboot�豸����! ��Ͽ������豸.{%c_i%}{\n}& fastboot.exe devices | find "	" & ECHOC {%c_h%}����������¼��...{%c_i%}{\n}& pause>nul & goto FASTBOOT-1)
for /f %%a in ('fastboot.exe devices ^| find /c "	"') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto FASTBOOT-2)
for /f "tokens=2 delims= " %%i in ('fastboot.exe devices ^| find "	"') do (if not "%%i"=="fastboot" TIMEOUT /T 1 /NOBREAK>nul & goto FASTBOOT-2)
::Ŀ���豸�Ѿ���⵽
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%����ٴμ��, ���Ժ�... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto FASTBOOT-1
ECHO.�豸������(Fastboot) & ENDLOCAL & call log chkdev.bat-fastboot I �豸������:%var1%& goto :eof


:FASTBOOTD
::���ղ���
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::��ʼ
:FASTBOOTD-1
ECHO.���ڼ���豸����(Fastbootd)... & set try_times=0
:FASTBOOTD-2
if %try_times% GTR 30 ECHO.����δ��⵽Ŀ���豸, ����������¼��... & pause>nul & goto FASTBOOTD-1
set /a try_times+=1
for /f %%a in ('fastboot.exe devices ^| find /c "	"') do (if %%a GTR 1 ECHOC {%c_e%}�ж��Fastboot�豸����! ��Ͽ������豸.{%c_i%}{\n}& fastboot.exe devices | find "	" & ECHOC {%c_h%}����������¼��...{%c_i%}{\n}& pause>nul & goto FASTBOOTD-1)
for /f %%a in ('fastboot.exe devices ^| find /c "	"') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto FASTBOOTD-2)
for /f "tokens=2 delims= " %%i in ('fastboot.exe devices ^| find "	"') do (if not "%%i"=="fastboot" TIMEOUT /T 1 /NOBREAK>nul & goto FASTBOOTD-2)
::Ŀ���豸�Ѿ���⵽
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%����ٴμ��, ���Ժ�... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto FASTBOOTD-1
ECHO.�豸������(Fastbootd) & ENDLOCAL & call log chkdev.bat-fastbootd I �豸������:%var1%& goto :eof


:EDL
::���ղ���
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::��ʼ
:EDL-1
ECHO.���ڼ���豸����(edl)... & set try_times=0
:EDL-2
if %try_times% GTR 30 ECHO.����δ��⵽Ŀ���豸, ����������¼��... & pause>nul & goto EDL-1
set /a try_times+=1
for /f %%a in ('devcon.exe find usb* ^| find /c "Qualcomm HS-USB QDLoader 9008"') do (if %%a GTR 1 ECHOC {%c_e%}�ж��edl�豸����! ��Ͽ������豸.{%c_i%}{\n}& devcon.exe find usb* | find /c "Qualcomm HS-USB QDLoader 9008" & ECHOC {%c_h%}����������¼��...{%c_i%}{\n}& pause>nul & goto EDL-1)
for /f %%a in ('devcon.exe find usb* ^| find /c "Qualcomm HS-USB QDLoader 9008"') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto EDL-2)
::Ŀ���豸�Ѿ���⵽
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%����ٴμ��, ���Ժ�... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto EDL-1
devcon.exe find usb* | find "Qualcomm HS-USB QDLoader 9008" 1>tmp\output.txt
set num=2
:EDL-3
set var=
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
if not "%var%"=="" set /a num+=1& goto EDL-3
set /a num+=-1
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
set port=%var:~3,999%
ECHO.�豸������(edl, COM%port%)& call log chkdev.bat-all I �豸������:edl.COM%port%
ENDLOCAL & set chkdev__edl_port=%port%& set chkdev__edl__port=%port%
goto :eof


:DIAG901D
::���ղ���
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::��ʼ
:DIAG901D-1
ECHO.���ڼ���豸����(diag901d)... & set try_times=0
:DIAG901D-2
if %try_times% GTR 30 ECHO.����δ��⵽Ŀ���豸, ����������¼��... & pause>nul & goto DIAG901D-1
set /a try_times+=1
for /f %%a in ('devcon.exe find usb* ^| find /c "Qualcomm HS-USB Android DIAG 901D"') do (if %%a GTR 1 ECHOC {%c_e%}�ж��diag901d�豸����! ��Ͽ������豸.{%c_i%}{\n}& devcon.exe find usb* | find /c "Qualcomm HS-USB Android DIAG 901D" & ECHOC {%c_h%}����������¼��...{%c_i%}{\n}& pause>nul & goto DIAG901D-1)
for /f %%a in ('devcon.exe find usb* ^| find /c "Qualcomm HS-USB Android DIAG 901D"') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto DIAG901D-2)
::Ŀ���豸�Ѿ���⵽
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%����ٴμ��, ���Ժ�... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto DIAG901D-1
devcon.exe find usb* | find "Qualcomm HS-USB Android DIAG 901D" 1>tmp\output.txt
set num=2
:DIAG901D-3
set var=
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
if not "%var%"=="" set /a num+=1& goto DIAG901D-3
set /a num+=-1
for /f "tokens=%num% delims=()" %%a in (tmp\output.txt) do set var=%%a
set port=%var:~3,999%
ECHO.�豸������(diag901d, COM%port%)& call log chkdev.bat-all I �豸������:diag901d.COM%port%
ENDLOCAL & set chkdev__diag901d_port=%port%& set chkdev__diag901d__port=%port%
goto :eof


:ALL
::���ղ���
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::��ʼ
:ALL-1
ECHO.���ڼ���豸����(ȫ��)... & set try_times=0& adb.exe start-server 1>nul
:ALL-2
set devnum=0
if %try_times% GTR 30 ECHO.����δ��⵽Ŀ���豸, ����������¼��... & pause>nul & goto ALL-1
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
::�ȼ�����豸��
if %devnum% GTR 1 ECHOC {%c_e%}�ж���豸����! ��Ͽ������豸.{%c_i%}{\n}& ECHOC {%c_h%}����������¼��...{%c_i%}{\n}& pause>nul & goto ALL-1
if not "%devnum%"=="1" TIMEOUT /T 1 /NOBREAK>nul& goto ALL-2
::�豸����1,�����ж�ģʽ
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
::Ŀ���豸�Ѿ���⵽
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%����ٴμ��, ���Ժ�... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto ALL-1
if "%devmode%"=="edl" goto ALL-CHKPORT
if "%devmode%"=="sprdboot" goto ALL-CHKPORT
if "%devmode%"=="mtkbrom" goto ALL-CHKPORT
if "%devmode%"=="mtkpreloader" goto ALL-CHKPORT
ECHO.�豸������(%devmode%)& call log chkdev.bat-all I �豸������:%devmode%
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
ECHO.�豸������(%devmode%, COM%port%)& call log chkdev.bat-all I �豸������:%devmode%.COM%port%
ENDLOCAL & set chkdev__all__mode=%devmode%& set chkdev__all__port=%port%& set chkdev__%devmode%_port=%port%& set chkdev__%devmode%__port=%port%
goto :eof


:::usb3chk
::call log chkdev.bat I ��ʼ���Ŀ���豸�Ƿ�������USB3�����
::usbdump.exe | find /N " " 1>tmp\output.txt
::for /f "tokens=1 delims=[]" %%i in ('find /I "%1" "tmp\output.txt"') do set /a var01=%%i+2
::for /f "tokens=2 delims=[]" %%i in ('find "[%var01%]" "tmp\output.txt"') do set var02=%%i
::for /f "tokens=1 delims=[]" %%i in ('find "]%var02%" "tmp\output.txt" ^| find /N " " ^| find "[%var01%]"') do set /a var03=%%i-1
::for /f "tokens=2 delims=[]" %%i in ('find "]%var02%" "tmp\output.txt" ^| find /N " " ^| find "[%var03%]["') do set /a var04=%%i+23
::set usb3=unknown
::for /f "tokens=3 delims= " %%i in ('find "[%var04%]" "tmp\output.txt" ^| find "Usb300"') do set usb3=%%i
::call log chkdev.bat I USB3�����Ϊ:%usb3%
::goto :eof








:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)

