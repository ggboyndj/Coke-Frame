::call info adb
::          fastboot
::          mtkclient
::          par       ������    [fail back](���Ҳ�������ʱ�Ĳ���.��ѡ.Ĭ��Ϊfail)
::          disk      ����·��

@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%


:MTKCLIENT
SETLOCAL
set logger=info.bat-mtkclient
call log %logger% I ��ʼ��ȡ�������豸��Ϣ
:MTKCLIENT-1
if exist tmp\output.txt del tmp\output.txt 1>nul
call tool\Windows\mtkclient\mtkclient.bat gettargetconfig
type tmp\output.txt>>%logfile%
::������
set var=
for /f "tokens=4 delims=(	 " %%a in ('type "tmp\output.txt" ^| find "Preloader - 	CPU:"') do set var=%%a
if "%var%"=="" ECHOC {%c_e%}��ȡcpu��Ϣʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡcpu��Ϣʧ��& pause>nul & ECHO.����... & goto MTKCLIENT-1
set cpu=%var%
::MEID
set meid=
for /f "tokens=4 delims=	 " %%a in ('type "tmp\output.txt" ^| find "Preloader - ME_ID:"') do set meid=%%a
if "%meid%"=="" ECHOC {%c_e%}��ȡmeid��Ϣʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡmeid��Ϣʧ��& pause>nul & ECHO.����... & goto MTKCLIENT-1
call log %logger% I ��ȡ���������豸��Ϣ:cpu:%cpu%.meid:%meid%
ENDLOCAL & set info__mtkclient__cpu=%cpu%& set info__mtkclient__meid=%meid%
goto :eof


:ADB
SETLOCAL
set logger=info.bat-adb
call log %logger% I ��ʼ��ȡADB�豸��Ϣ
:ADB-1
set product=
for /f %%i in ('adb.exe shell getprop ro.product.device') do set product=%%i
if "%product%"=="" call log %logger% E ro.product.device��ȡʧ��& ECHOC {%c_e%}ro.product.device��ȡʧ��. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto ADB-1
set androidver=
for /f %%i in ('adb.exe shell getprop ro.build.version.release') do set androidver=%%i
if "%androidver%"=="" call log %logger% E ro.build.version.release��ȡʧ��& ECHOC {%c_e%}ro.build.version.release��ȡʧ��. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto ADB-1
set sdkver=
for /f %%i in ('adb.exe shell getprop ro.build.version.sdk') do set sdkver=%%i
if "%sdkver%"=="" call log %logger% E ro.build.version.sdk��ȡʧ��& ECHOC {%c_e%}ro.build.version.sdk��ȡʧ��. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto ADB-1
call log %logger% I ��ȡ��ADB�豸��Ϣ:product:%product%.androidver:%androidver%.sdkver:%sdkver%
ENDLOCAL & set info__adb__product=%product%& set info__adb__androidver=%androidver%& set info__adb__sdkver=%sdkver%
goto :eof


:FASTBOOT
SETLOCAL
set logger=info.bat-fastboot
call log %logger% I ��ʼ��ȡFastboot�豸��Ϣ
:FASTBOOT-1
set product=
for /f "tokens=2 delims=: " %%i in ('fastboot getvar product 2^>^&1^| find "product"') do set product=%%i
if "%product%"=="" call log %logger% E product��ȡʧ��& ECHOC {%c_e%}product��ȡʧ��. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto FASTBOOT-1
set unlocked=
for /f "tokens=2 delims=: " %%i in ('fastboot getvar unlocked 2^>^&1^| find "unlocked"') do set unlocked=%%i
if "%unlocked%"=="" call log %logger% E unlocked��ȡʧ��& ECHOC {%c_e%}unlocked��ȡʧ��. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto FASTBOOT-1
call log %logger% I ��ȡ��Fastboot�豸��Ϣ:product:%product%.unlocked:%unlocked%
ENDLOCAL & set info__fastboot__product=%product%& set info__fastboot__unlocked=%unlocked%
goto :eof
::��:Ħ�������豸�жϽ����ķ�������: fastboot getvar securestate 2>&1| find "flashing_unlocked" 1>nul 2>nul && set unlocked=yes


:PAR
SETLOCAL
set logger=info.bat-par
set parname=%var2%& set ifparnotexist=%var3%
if "%ifparnotexist%"=="" set ifparnotexist=fail
call log %logger% I ���ձ���:parname:%parname%.ifparnotexist:%ifparnotexist%
call framwork adbpre blktool
call framwork adbpre sgdisk
::call framwork adbpre parted
:PAR-1
call chkdev all 1>nul
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" ECHOC {%c_e%}�豸ģʽ����, ֻ֧����ϵͳ��Recovery��ȡ����·��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ģʽ����:%chkdev__all__mode%.Ӧ����ϵͳ��Recoveryģʽ& pause>nul & ECHO.����... & goto PAR-1)
call log %logger% I ��ʼ�������Ƿ����
if "%chkdev__all__mode%"=="system" echo.su>tmp\cmd.txt& echo../data/local/tmp/blktool -n -N %parname% -l>>tmp\cmd.txt
if "%chkdev__all__mode%"=="recovery" echo../blktool -n -N %parname% -l>tmp\cmd.txt
set parexist=n
adb.exe shell < tmp\cmd.txt 2>&1 | find "list failed: no any match block found" 1>nul 2>nul || set parexist=y
if "%parexist%"=="n" (
    if "%ifparnotexist%"=="fail" ECHOC {%c_e%}%parname%����������. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E %parname%����������& pause>nul & ECHO.����... & goto PAR-1
    if "%ifparnotexist%"=="back" (
        call log %logger% I %parname%����������.�˳���ȡ������Ϣ
        ENDLOCAL & set info__par__exist=n
        goto :eof))
:PAR-2
::call log %logger% I ��ʼ��ȡ�������.����·��.����������С
if "%chkdev__all__mode%"=="system" echo.su>tmp\cmd.txt& echo../data/local/tmp/blktool -n -N %parname% --print-part -l --print-sector-size>>tmp\cmd.txt
if "%chkdev__all__mode%"=="recovery" echo../blktool -n -N %parname% --print-part -l --print-sector-size>tmp\cmd.txt
set parnum=& set parpath=& set disksecsize=
for /f "tokens=1,2,3 delims= " %%a in ('adb.exe shell ^< tmp\cmd.txt') do (set parnum=%%a& set parpath=%%b& set disksecsize=%%c)
if "%parnum%"=="" (ECHOC {%c_e%}��ȡ�������ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ�������ʧ��& pause>nul & ECHO.����... & goto PAR-2) else (call log %logger% I ��ȡ����������:%parnum%)
if "%parpath%"=="" (ECHOC {%c_e%}��ȡ����·��ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ����·��ʧ��& pause>nul & ECHO.����... & goto PAR-2) else (call log %logger% I ��ȡ����·�����:%parpath%)
if "%disksecsize%"=="" (ECHOC {%c_e%}��ȡ����������Сʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ����������Сʧ��& pause>nul & ECHO.����... & goto PAR-2) else (call log %logger% I ��ȡ����������С���:%disksecsize%)
:PAR-6
::call log %logger% I ��ʼ��ȡ�洢����
echo.%parpath% | find "mmcblk" 1>nul 2>nul && set disktype=emmc&& call log %logger% I ��ȡ�洢�������:emmc&& goto PAR-3
echo.%parpath% | find "dev/block/sd" 1>nul 2>nul && set disktype=ufs&& call log %logger% I ��ȡ�洢�������:ufs&& goto PAR-3
ECHOC {%c_e%}��֧�ֵĴ洢����{%c_i%}{\n}& call log %logger% F ��֧�ֵĴ洢����& goto FATAL
::if "%chkdev__all__mode%"=="system" echo.su>tmp\cmd.txt& echo../data/local/tmp/parted %diskpath% p>>tmp\cmd.txt
::if "%chkdev__all__mode%"=="recovery" echo../parted %diskpath% p>tmp\cmd.txt
::set disktype=
::for /f "tokens=2 delims= " %%a in ('adb.exe shell ^< tmp\cmd.txt ^| find "Model: "') do set disktype=%%a
::if "%disktype%"=="" (ECHOC {%c_e%}��ȡ�洢����ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ�洢����ʧ��& pause>nul & ECHO.����... & goto PAR-6) else (call log %logger% I ��ȡ�洢�������:%disktype%)
::if not "%disktype%"=="MMC" (if not "%disktype%"=="ufs" ECHOC {%c_e%}��֧�ֵĴ洢����:%disktype%{%c_i%}{\n}& call log %logger% F ��֧�ֵĴ洢����& goto FATAL)
:PAR-3
::call log %logger% I ��ʼ��ȡ���ڴ���·��
echo.%parpath%>tmp\output.txt
if "%disktype%"=="ufs" busybox.exe sed -i "s/%parnum%$//g" tmp\output.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}sed����tmp\output.txtʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E sed����tmp\output.txtʧ��&& pause>nul && ECHO.����... && goto PAR-3
if "%disktype%"=="emmc" busybox.exe sed -i "s/p%parnum%$//g" tmp\output.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}sed����tmp\output.txtʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E sed����tmp\output.txtʧ��&& pause>nul && ECHO.����... && goto PAR-3
set diskpath=
for /f "tokens=1 delims= " %%i in ('type tmp\output.txt') do set diskpath=%%i
if "%diskpath%"=="" (ECHOC {%c_e%}��ȡ���ڴ���·��ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ���ڴ���·��ʧ��& pause>nul & ECHO.����... & goto PAR-3) else (call log %logger% I ��ȡ���ڴ���·�����:%diskpath%)
:PAR-4
::call log %logger% I ��ʼ��ȡ����start.end.����
if "%chkdev__all__mode%"=="system" echo.su>tmp\cmd.txt& echo../data/local/tmp/sgdisk -p %diskpath% >>tmp\cmd.txt
if "%chkdev__all__mode%"=="recovery" echo../sgdisk -p %diskpath% >tmp\cmd.txt
del tmp\output.txt 1>nul
for /f "tokens=1 delims=" %%i in ('adb.exe shell ^< tmp\cmd.txt ^| find "  " ^| find /v "Number"') do echo.%%i#>>tmp\output.txt
set parstart=& set parend=& set partype=
for /f "tokens=2,3,6 delims= " %%a in ('type tmp\output.txt ^| find "%parname%#"') do (set parstart_sec=%%a& set parend_sec=%%b& set partype=%%c)
call calc sec2kb parstart nodec %parstart_sec% %disksecsize%
call calc sec2kb parend nodec %parend_sec% %disksecsize%
if "%parstart%"=="" (ECHOC {%c_e%}��ȡ����startʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ����startʧ��& pause>nul & ECHO.����... & goto PAR-4) else (call log %logger% I ��ȡ����start���:%parstart%)
if "%parend%"=="" (ECHOC {%c_e%}��ȡ����endʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ����endʧ��& pause>nul & ECHO.����... & goto PAR-4) else (call log %logger% I ��ȡ����end���:%parend%)
if "%partype%"=="" (ECHOC {%c_e%}��ȡ��������ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ��������ʧ��& pause>nul & ECHO.����... & goto PAR-4) else (call log %logger% I ��ȡ�����������:%partype%)
:PAR-5
::call log %logger% I ��ʼ���������С
set /a parsize_sec=%parend_sec%-%parstart_sec%+1
call calc sec2kb parsize nodec %parsize_sec% %disksecsize%
call log %logger% I ���������С���:%parsize%
call log %logger% I ��ȡ������Ϣ���
ENDLOCAL & set info__par__exist=%parexist%& set info__par__diskpath=%diskpath%& set info__par__num=%parnum%& set info__par__path=%parpath%& set info__par__type=%partype%& set info__par__start=%parstart%& set info__par__end=%parend%& set info__par__size=%parsize%& set info__par__disksecsize=%disksecsize%& set info__par__disktype=%disktype%
goto :eof


:DISK
SETLOCAL
set logger=info.bat-disk
set diskpath=%var2%
call log %logger% I ���ձ���:diskpath:%diskpath%
call framwork adbpre blktool
call framwork adbpre sgdisk
:DISK-3
call chkdev all 1>nul
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" ECHOC {%c_e%}�豸ģʽ����, ֻ֧����ϵͳ��Recovery��ȡ����·��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ģʽ����:%chkdev__all__mode%.Ӧ����ϵͳ��Recoveryģʽ& pause>nul & ECHO.����... & goto DISK-3)
::��ȡ�洢����
echo.%diskpath% | find "mmcblk" 1>nul 2>nul && set disktype=emmc&& call log %logger% I ��ȡ�洢�������:emmc&& goto DISK-1
echo.%diskpath% | find "dev/block/sd" 1>nul 2>nul && set disktype=ufs&& call log %logger% I ��ȡ�洢�������:ufs&& goto DISK-1
ECHOC {%c_e%}��֧�ֵĴ洢����{%c_i%}{\n}& call log %logger% F ��֧�ֵĴ洢����& goto FATAL
::��ȡ����������С
:DISK-1
if "%chkdev__all__mode%"=="system" echo.su>tmp\cmd.txt& echo../data/local/tmp/blktool -n -p --print-sector-size>>tmp\cmd.txt
if "%chkdev__all__mode%"=="recovery" echo../blktool -n -p --print-sector-size>tmp\cmd.txt
set disksecsize=
for /f "tokens=2 delims= " %%a in ('adb.exe shell ^< tmp\cmd.txt ^| find "%diskpath%"') do set disksecsize=%%a
if "%disksecsize%"=="" (ECHOC {%c_e%}��ȡ����������Сʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ����������Сʧ��& pause>nul & ECHO.����... & goto DISK-1) else (call log %logger% I ��ȡ����������С���:%disksecsize%)
::��ȡ��������
:DISK-2
if "%chkdev__all__mode%"=="system" echo.su>tmp\cmd.txt& echo../data/local/tmp/sgdisk -p %diskpath% >>tmp\cmd.txt
if "%chkdev__all__mode%"=="recovery" echo../sgdisk -p %diskpath% >tmp\cmd.txt
set maxparnum=
for /f "tokens=6 delims= " %%a in ('adb.exe shell ^< tmp\cmd.txt ^| find "Partition table holds up to "') do set maxparnum=%%a
if "%maxparnum%"=="" (ECHOC {%c_e%}��ȡ��������ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ��������ʧ��& pause>nul & ECHO.����... & goto DISK-2) else (call log %logger% I ��ȡ�����������:%maxparnum%)
call log %logger% I ��ȡ������Ϣ���
ENDLOCAL & set info__disk__type=%disktype%& set info__disk__secsize=%disksecsize%& set info__disk__maxparnum=%maxparnum%
goto :eof















:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)
