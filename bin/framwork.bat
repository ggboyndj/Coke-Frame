::call  framwork startpre  skiptoolchk(��ѡ)
::               adbpre    [�ļ��� all]
::               theme     ������
::               conf      �����ļ���    ������  ����ֵ
::               logviewer end

::start framwork logviewer start        %logfile%


@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%


:LOGVIEWER
if "%var2%"=="end" taskkill /f /im busybox-bfflogviewer.exe 1>nul 2>nul & goto :eof
@ECHO OFF
COLOR 0F
TITLE BFF-ʵʱ��־��� [������ֻ�����־, ������ű�����]
ECHO.
ECHO.��ǰ��־�ļ�: %logfile%
ECHO.
call tool\Windows\resizecmdwindow.exe -l 0 -r 70 -t 0 -b 20 -w 500 -h 800
tool\Windows\busybox-bfflogviewer.exe tail -f -s 1 %var3%
EXIT


:CONF
SETLOCAL
set logger=framwork.bat-conf
call log %logger% I ����conf\%var2%д��%var3%.ֵΪ%var4%
::if not exist conf\%var2% ECHOC {%c_e%}�Ҳ���conf\%var2%{%c_i%}{\n}& call log %logger% F �Ҳ���conf\%var2%& goto FATAL
if not exist conf\%var2% echo.>conf\%var2%
find "set %var3%=" "conf\%var2%" 1>nul 2>nul || echo.set %var3%=%var4%|findstr "set" 1>>conf\%var2%&& goto CONF-DONE
type conf\%var2% | find "set " | find /v "set %var3%=" 1>tmp\output.txt
echo.set %var3%=%var4%|findstr "set" 1>>tmp\output.txt
move /Y tmp\output.txt conf\%var2% 1>nul || ECHOC {%c_e%}�ƶ�tmp\output.txt��conf\%var2%ʧ��{%c_i%}{\n}&& call log %logger% F �ƶ�tmp\output.txt��conf\%var2%ʧ��&& goto FATAL
:CONF-DONE
ENDLOCAL
goto :eof


:THEME
set c_i=0F& set c_w=0E& set c_e=0C& set c_s=0A& set c_h=0D
if "%var2%"=="" set var2=%framwork_theme%
if "%var2%"=="default" set c_i=0F& set c_w=0E& set c_e=0C& set c_s=0A& set c_h=0D& set c_a=0E& set c_we=07
if "%var2%"=="douyinhacker" set c_i=0A& set c_w=0E& set c_e=0C& set c_s=0F& set c_h=0D& set c_a=0E& set c_we=07
if "%var2%"=="ubuntu" set c_i=5F& set c_w=5E& set c_e=5C& set c_s=5A& set c_h=59& set c_a=5E& set c_we=5F
if "%var2%"=="classic" set c_i=3F& set c_w=3E& set c_e=3C& set c_s=3A& set c_h=3D& set c_a=3E& set c_we=3F
if "%var2%"=="gold" set c_i=8E& set c_w=E0& set c_e=CF& set c_s=A0& set c_h=6F& set c_a=8E& set c_we=8E
if "%var2%"=="dos" set c_i=1F& set c_w=1E& set c_e=1C& set c_s=A0& set c_h=80& set c_a=1E& set c_we=1F
if "%var2%"=="ChineseNewYear" set c_i=CF& set c_w=6F& set c_e=0F& set c_s=C0& set c_h=7C& set c_a=6F& set c_we=CF
goto :eof


:STARTPRE
if exist tool\logo.txt type tool\logo.txt
ECHO.����׼������...
::ECHO.���find����...
find /? | find "string" 1>nul || ECHO.ִ��find����ʧ��&& goto FATAL
::ECHO.��ȡWindows�汾��...
for /f "tokens=4 delims=[] " %%a in ('ver ^| find " "') do set winver=%%a
::ECHO.���findstr����...
findstr /? | findstr "string" 1>nul || ECHO.ִ��findstr����ʧ��&& goto FATAL
::ECHO.���ͱ��湤��Ŀ¼·��...
for /f "tokens=2 delims=() " %%i in ('echo." %cd% "') do (if not "%%i"=="%cd%" ECHO.������·���в������пո��Ӣ������& goto FATAL)
set framwork_workspace=%cd%
::ECHO.����path...
set path=%path%||ECHO.ϵͳ����������Path�����д��ڴ����·��. �����������&& goto FATAL
set path=%framwork_workspace%;%framwork_workspace%\tool\Windows;%windir%\Sysnative;%path%
::ECHO.���tmp�ļ���
if not exist tmp md tmp 1>nul || ECHOC {%c_e%}����tmp�ļ���ʧ��{%c_i%}{\n}&& goto FATAL
::ECHO.���ECHOC...
if not exist tool\Windows\ECHOC.exe ECHO.�Ҳ���ECHOC.exe& goto FATAL
ECHOC | find "Usage" 1>nul 2>nul || ECHO.ECHOC.exe�޷�����&& goto FATAL
::ECHO.׼����־ϵͳ...
if "%framwork_log%"=="n" set logfile=nul& set logger=CLOSED
if "%framwork_log%"=="n" SETLOCAL & goto STARTPRE-2
if not exist log md log 1>nul || ECHOC {%c_e%}����log�ļ���ʧ��{%c_i%}{\n}&& goto FATAL
if not exist tool\Windows\gettime.exe ECHOC {%c_e%}�Ҳ���gettime.exe{%c_i%}{\n}& goto FATAL
gettime.exe | find "." 1>nul 2>nul || ECHOC {%c_e%}gettime.exe�޷�����{%c_i%}{\n}&& goto FATAL
for /f %%a in ('gettime.exe ^| find "."') do set logfile=%framwork_workspace%\log\%%a.log
set logger=UNKNOWN
SETLOCAL
set logger=framwork.bat-startpre
call log %logger% I ϵͳ��Ϣ:%processor_architecture%.%winver%.����Ŀ¼:%framwork_workspace%
::ECHO.������־...
if "%framwork_lognum%"=="" set framwork_lognum=6
for /f %%a in ('dir /B log ^| find /C ".log"') do (if %%a LEQ %framwork_lognum% goto STARTPRE-2)
for /f "tokens=1 delims=[]" %%a in ('dir /B log ^| find /N ".log"') do set /a var=%%a-%framwork_lognum%
:STARTPRE-1
dir /B log | find /N ".log" | find "[%var%]" 1>nul 2>nul || goto STARTPRE-2
for /f "tokens=2 delims=[]" %%a in ('dir /B log ^| find /N ".log" ^| find "[%var%]"') do del log\%%a 1>nul
set /a var+=-1& goto STARTPRE-1
:STARTPRE-2
if "%var2%"=="skiptoolchk" call log %logger% I ������鹤��& goto STARTPRE-DONE
::ECHO.360AblumViewer...
::if not exist tool\Windows\360AblumViewer.exe ECHOC {%c_e%}�Ҳ���360AblumViewer.exe{%c_i%}{\n}& call log %logger% F �Ҳ���360AblumViewer.exe& goto FATAL
::if not exist tool\Windows\360AblumViewer.ini ECHOC {%c_e%}�Ҳ���360AblumViewer.ini{%c_i%}{\n}& call log %logger% F �Ҳ���360AblumViewer.ini& goto FATAL
::ECHO.���Notepad3...
if not exist tool\Windows\Notepad3\Notepad3.exe ECHOC {%c_e%}�Ҳ���Notepad3.exe{%c_i%}{\n}& call log %logger% F �Ҳ���Notepad3.exe& goto FATAL
::ECHO.���scrcpy...
if not exist tool\Windows\scrcpy\scrcpy.exe ECHOC {%c_e%}�Ҳ���scrcpy.exe{%c_i%}{\n}& call log %logger% F �Ҳ���scrcpy.exe& goto FATAL
tool\Windows\scrcpy\scrcpy.exe -h | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}scrcpy.exe�޷�����{%c_i%}{\n}&& call log %logger% F scrcpy.exe�޷�����&& goto FATAL
::ECHO.���7z...
if not exist tool\Windows\7z.dll ECHOC {%c_e%}�Ҳ���7z.dll{%c_i%}{\n}& call log %logger% F �Ҳ���7z.dll& goto FATAL
if not exist tool\Windows\7z.exe ECHOC {%c_e%}�Ҳ���7z.exe{%c_i%}{\n}& call log %logger% F �Ҳ���7z.exe& goto FATAL
7z.exe | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}7z.exe�޷�����{%c_i%}{\n}&& call log %logger% F 7z.exe�޷�����&& goto FATAL
::ECHO.���aapt...
if not exist tool\Windows\aapt.exe ECHOC {%c_e%}�Ҳ���aapt.exe{%c_i%}{\n}& call log %logger% F �Ҳ���aapt.exe& goto FATAL
tool\Windows\aapt.exe v | find "Android" 1>nul 2>nul || ECHOC {%c_e%}aapt.exe�޷�����{%c_i%}{\n}&& call log %logger% F aapt.exe�޷�����&& goto FATAL
::ECHO.���adb...
if not exist tool\Windows\adb.exe ECHOC {%c_e%}�Ҳ���adb.exe{%c_i%}{\n}& call log %logger% F �Ҳ���adb.exe& goto FATAL
if not exist tool\Windows\AdbWinApi.dll ECHOC {%c_e%}�Ҳ���AdbWinApi.dll{%c_i%}{\n}& call log %logger% F �Ҳ���AdbWinApi.dll& goto FATAL
if not exist tool\Windows\AdbWinUsbApi.dll ECHOC {%c_e%}�Ҳ���AdbWinUsbApi.dll{%c_i%}{\n}& call log %logger% F �Ҳ���AdbWinUsbApi.dll& goto FATAL
adb.exe start-server>nul
adb.exe devices | find "List of devices attached" 1>nul 2>nul || ECHOC {%c_e%}adb.exe�޷�����{%c_i%}{\n}&& call log %logger% F adb.exe�޷�����&& goto FATAL
::ECHO.���aria2c...
if not exist tool\Windows\aria2c.exe ECHOC {%c_e%}�Ҳ���aria2c.exe{%c_i%}{\n}& call log %logger% F �Ҳ���aria2c.exe& goto FATAL
aria2c.exe -h | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}aria2c.exe�޷�����{%c_i%}{\n}&& call log %logger% F aria2c.exe�޷�����&& goto FATAL
::ECHO.���busybox...
if not exist tool\Windows\busybox.exe ECHOC {%c_e%}�Ҳ���busybox.exe{%c_i%}{\n}& call log %logger% F �Ҳ���busybox.exe& goto FATAL
busybox.exe | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}busybox.exe�޷�����{%c_i%}{\n}&& call log %logger% F busybox.exe�޷�����&& goto FATAL
::ECHO.���busybox-bfflogviewer...
if not exist tool\Windows\busybox-bfflogviewer.exe ECHOC {%c_e%}�Ҳ���busybox-bfflogviewer.exe{%c_i%}{\n}& call log %logger% F �Ҳ���busybox-bfflogviewer.exe& goto FATAL
busybox-bfflogviewer.exe | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}busybox-bfflogviewer.exe�޷�����{%c_i%}{\n}&& call log %logger% F busybox-bfflogviewer.exe�޷�����&& goto FATAL
::ECHO.���calc...
if not exist tool\Windows\calc.exe ECHOC {%c_e%}�Ҳ���calc.exe{%c_i%}{\n}& call log %logger% F �Ҳ���calc.exe& goto FATAL
calc.exe 6 m 6 | find "36.00" 1>nul 2>nul || ECHOC {%c_e%}calc.exe�޷�����{%c_i%}{\n}&& call log %logger% F calc.exe�޷�����&& goto FATAL
::ECHO.���curl...
if not exist tool\Windows\curl.exe ECHOC {%c_e%}�Ҳ���curl.exe{%c_i%}{\n}& call log %logger% F �Ҳ���curl.exe& goto FATAL
curl.exe --help | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}curl.exe�޷�����{%c_i%}{\n}&& call log %logger% F curl.exe�޷�����&& goto FATAL
::ECHO.���cygwin1.dll...
::if not exist tool\Windows\cygwin1.dll ECHOC {%c_e%}�Ҳ���cygwin1.dll{%c_i%}{\n}& call log %logger% F �Ҳ���cygwin1.dll& goto FATAL
::ECHO.���devcon...
if not exist tool\Windows\devcon.exe ECHOC {%c_e%}�Ҳ���devcon.exe{%c_i%}{\n}& call log %logger% F �Ҳ���devcon.exe& goto FATAL
devcon.exe help | find "Device" 1>nul 2>nul || ECHOC {%c_e%}devcon.exe�޷�����{%c_i%}{\n}&& call log %logger% F devcon.exe�޷�����&& goto FATAL
::ECHO.���fastboot...
if not exist tool\Windows\fastboot.exe ECHOC {%c_e%}�Ҳ���fastboot.exe{%c_i%}{\n}& call log %logger% F �Ҳ���fastboot.exe& goto FATAL
fastboot.exe -h 2>&1 | find "usage" 1>nul 2>nul || ECHOC {%c_e%}fastboot.exe�޷�����{%c_i%}{\n}&& call log %logger% F fastboot.exe�޷�����&& goto FATAL
::ECHO.���fh_loader...
if not exist tool\Windows\fh_loader.exe ECHOC {%c_e%}�Ҳ���fh_loader.exe{%c_i%}{\n}& call log %logger% F �Ҳ���fh_loader.exe& goto FATAL
fh_loader.exe -6 2>&1 | find "Base" 1>nul 2>nul || ECHOC {%c_e%}fh_loader.exe�޷�����{%c_i%}{\n}&& call log %logger% F fh_loader.exe�޷�����&& goto FATAL
::ECHO.���filedialog...
if not exist tool\Windows\filedialog.exe ECHOC {%c_e%}�Ҳ���filedialog.exe{%c_i%}{\n}& call log %logger% F �Ҳ���filedialog.exe& goto FATAL
filedialog.exe | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}filedialog.exe�޷�����{%c_i%}{\n}&& call log %logger% F filedialog.exe�޷�����&& goto FATAL
::ECHO.���libcurl.def...
if not exist tool\Windows\libcurl.def ECHOC {%c_e%}�Ҳ���libcurl.def{%c_i%}{\n}& call log %logger% F �Ҳ���libcurl.def& goto FATAL
::ECHO.���libcurl.dll...
if not exist tool\Windows\libcurl.dll ECHOC {%c_e%}�Ҳ���libcurl.dll{%c_i%}{\n}& call log %logger% F �Ҳ���libcurl.dll& goto FATAL
::ECHO.���magiskboot...
if not exist tool\Windows\magiskboot.exe ECHOC {%c_e%}�Ҳ���magiskboot.exe{%c_i%}{\n}& call log %logger% F �Ҳ���magiskboot.exe& goto FATAL
magiskboot.exe 2>&1 | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}magiskboot.exe�޷�����{%c_i%}{\n}&& call log %logger% F magiskboot.exe�޷�����&& goto FATAL
::ECHO.���magiskpatcher...
::if not exist tool\Windows\magiskpatcher.exe ECHOC {%c_e%}�Ҳ���magiskpatcher.exe{%c_i%}{\n}& call log %logger% F �Ҳ���magiskpatcher.exe& goto FATAL
::magiskpatcher.exe -h 2>&1 | find "usage" 1>nul 2>nul || ECHOC {%c_e%}magiskpatcher.exe�޷�����{%c_i%}{\n}&& call log %logger% F magiskpatcher.exe�޷�����&& goto FATAL
::ECHO.���numcomp...
if not exist tool\Windows\numcomp.exe ECHOC {%c_e%}�Ҳ���numcomp.exe{%c_i%}{\n}& call log %logger% F �Ҳ���numcomp.exe& goto FATAL
numcomp.exe 999 888 | find "greater" 1>nul 2>nul || ECHOC {%c_e%}numcomp.exe�޷�����{%c_i%}{\n}&& call log %logger% F numcomp.exe�޷�����&& goto FATAL
::ECHO.���ptanalyzer...
if not exist tool\Windows\ptanalyzer.exe ECHOC {%c_e%}�Ҳ���ptanalyzer.exe{%c_i%}{\n}& call log %logger% F �Ҳ���ptanalyzer.exe& goto FATAL
ptanalyzer.exe 2>&1 | find "ptanalyzer" 1>nul 2>nul || ECHOC {%c_e%}ptanalyzer.exe�޷�����{%c_i%}{\n}&& call log %logger% F ptanalyzer.exe�޷�����&& goto FATAL
::ECHO.���QSaharaServer...
if not exist tool\Windows\QSaharaServer.exe ECHOC {%c_e%}�Ҳ���QSaharaServer.exe{%c_i%}{\n}& call log %logger% F �Ҳ���QSaharaServer.exe& goto FATAL
QSaharaServer.exe | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}QSaharaServer.exe�޷�����{%c_i%}{\n}&& call log %logger% F QSaharaServer.exe�޷�����&& goto FATAL
::ECHO.���resizecmdwindow...
if not exist tool\Windows\resizecmdwindow.exe ECHOC {%c_e%}�Ҳ���resizecmdwindow.exe{%c_i%}{\n}& call log %logger% F �Ҳ���resizecmdwindow.exe& goto FATAL
resizecmdwindow.exe | find "usage" 1>nul 2>nul || ECHOC {%c_e%}resizecmdwindow.exe�޷�����{%c_i%}{\n}&& call log %logger% F resizecmdwindow.exe�޷�����&& goto FATAL
::ECHO.���strtofile...
if not exist tool\Windows\strtofile.exe ECHOC {%c_e%}�Ҳ���strtofile.exe{%c_i%}{\n}& call log %logger% F �Ҳ���strtofile.exe& goto FATAL
if exist tmp\bff-test.txt del tmp\bff-test.txt 1>nul
echo.bff-test|strtofile.exe tmp\bff-test.txt || ECHOC {%c_e%}strtofile.exe�޷�����{%c_i%}{\n}&& call log %logger% F strtofile.exe�޷�����&& goto FATAL
for /f %%a in (tmp\bff-test.txt) do (if not "%%a"=="bff-test" ECHOC {%c_e%}strtofile.exe�޷�����{%c_i%}{\n}& call log %logger% F strtofile.exe�޷�����& goto FATAL)
del tmp\bff-test.txt 1>nul
::ECHO.���usbdump...
::if not exist tool\Windows\usbdump.exe ECHOC {%c_e%}�Ҳ���usbdump.exe{%c_i%}{\n}& call log %logger% F �Ҳ���usbdump.exe& goto FATAL
::usbdump.exe -v | find "." 1>nul 2>nul || ECHOC {%c_e%}usbdump.exe�޷�����{%c_i%}{\n}&& call log %logger% F usbdump.exe�޷�����&& goto FATAL
::ECHO.���Vieas...
if not exist tool\Windows\Vieas\Vieas.exe ECHOC {%c_e%}�Ҳ���Vieas.exe{%c_i%}{\n}& call log %logger% F �Ҳ���Vieas.exe& goto FATAL
::ECHO.׼����׿����,��׿����·�������ñ���
::ECHO.���magisk\25200.apk...
::if not exist tool\Android\magisk\25200.apk ECHOC {%c_e%}�Ҳ���magisk\25200.apk{%c_i%}{\n}& call log %logger% F �Ҳ���magisk\25200.apk& goto FATAL
::ECHO.���blktool...
if not exist tool\Android\blktool ECHOC {%c_e%}�Ҳ���blktool{%c_i%}{\n}& call log %logger% F �Ҳ���blktool& goto FATAL
::ECHO.���bootctl...
if not exist tool\Android\bootctl ECHOC {%c_e%}�Ҳ���bootctl{%c_i%}{\n}& call log %logger% F �Ҳ���bootctl& goto FATAL
::ECHO.���busybox...
if not exist tool\Android\busybox ECHOC {%c_e%}�Ҳ���busybox{%c_i%}{\n}& call log %logger% F �Ҳ���busybox& goto FATAL
::ECHO.���dmsetup...
if not exist tool\Android\dmsetup ECHOC {%c_e%}�Ҳ���dmsetup{%c_i%}{\n}& call log %logger% F �Ҳ���dmsetup& goto FATAL
::ECHO.���misc_tofastboot.img...
::if not exist tool\Android\misc_tofastboot.img ECHOC {%c_e%}�Ҳ���misc_tofastboot.img{%c_i%}{\n}& call log %logger% F �Ҳ���misc_tofastboot.img& goto FATAL
::ECHO.���misc_torecovery.img...
::if not exist tool\Android\misc_torecovery.img ECHOC {%c_e%}�Ҳ���misc_torecovery.img{%c_i%}{\n}& call log %logger% F �Ҳ���misc_torecovery.img& goto FATAL
::ECHO.���mke2fs...
if not exist tool\Android\mke2fs ECHOC {%c_e%}�Ҳ���mke2fs{%c_i%}{\n}& call log %logger% F �Ҳ���mke2fs& goto FATAL
::ECHO.���mkfs.exfat...
if not exist tool\Android\mkfs.exfat ECHOC {%c_e%}�Ҳ���mkfs.exfat{%c_i%}{\n}& call log %logger% F �Ҳ���mkfs.exfat& goto FATAL
::ECHO.���mkfs.fat...
if not exist tool\Android\mkfs.fat ECHOC {%c_e%}�Ҳ���mkfs.fat{%c_i%}{\n}& call log %logger% F �Ҳ���mkfs.fat& goto FATAL
::ECHO.���mkntfs...
if not exist tool\Android\mkntfs ECHOC {%c_e%}�Ҳ���mkntfs{%c_i%}{\n}& call log %logger% F �Ҳ���mkntfs& goto FATAL
::ECHO.���parted...
if not exist tool\Android\parted ECHOC {%c_e%}�Ҳ���parted{%c_i%}{\n}& call log %logger% F �Ҳ���parted& goto FATAL
::ECHO.���sgdisk...
if not exist tool\Android\sgdisk ECHOC {%c_e%}�Ҳ���sgdisk{%c_i%}{\n}& call log %logger% F �Ҳ���sgdisk& goto FATAL
:STARTPRE-DONE
call log %logger% I ����׼���������
ENDLOCAL
goto :eof


:ADBPRE
SETLOCAL
set logger=framwork.bat-adbpre
::���ձ���
set target_name=%var2%
call log %logger% I ���ձ���:target_name:%target_name%
if "%target_name%"=="" set target_name=all
if "%target_name%"=="all" (goto ADBPRE-ALL) else (goto ADBPRE-SINGLE)
:ADBPRE-ALL
call write adbpush tool\Android\blktool blktool program_su
call write adbpush tool\Android\bootctl bootctl program_su
call write adbpush tool\Android\busybox busybox program_su
call write adbpush tool\Android\dmsetup dmsetup program_su
call write adbpush tool\Android\mke2fs mke2fs program_su
call write adbpush tool\Android\mkfs.exfat mkfs.exfat program_su
call write adbpush tool\Android\mkfs.fat mkfs.fat program_su
call write adbpush tool\Android\mkntfs mkntfs program_su
call write adbpush tool\Android\parted parted program_su
call write adbpush tool\Android\sgdisk sgdisk program_su
goto ADBPRE-DONE
:ADBPRE-SINGLE
call write adbpush tool\Android\%target_name% %target_name% program_su
goto ADBPRE-DONE
:ADBPRE-DONE
ENDLOCAL
goto :eof





:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)
