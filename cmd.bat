@ECHO OFF
mode con cols=71
COLOR 0F
TITLE BFF-������

cd /d %~dp0 1>nul 2>nul
if exist bin (cd bin) else (ECHO.�Ҳ���bin & goto FATAL)
if not exist tmp ECHO.�Ҳ���tmp & goto FATAL
set path=%cd%;%cd%\tool\Windows;%path%
set framwork_workspace=%cd%

::ECHO.���ECHOC...
if not exist %framwork_workspace%\tool\Windows\ECHOC.exe ECHO.�Ҳ���ECHOC.exe& goto FATAL
ECHOC | find "Usage" 1>nul 2>nul || ECHO.ECHOC.exe�޷�����&& goto FATAL
::ECHO.���strtofile...
if not exist %framwork_workspace%\tool\Windows\strtofile.exe ECHOC {%c_e%}�Ҳ���strtofile.exe{%c_i%}{\n}& goto FATAL
if exist %framwork_workspace%\tmp\bff-test.txt del %framwork_workspace%\tmp\bff-test.txt 1>nul
echo.bff-test|strtofile.exe %framwork_workspace%\tmp\bff-test.txt || ECHOC {%c_e%}strtofile.exe�޷�����{%c_i%}{\n}&& goto FATAL
for /f %%a in (%framwork_workspace%\tmp\bff-test.txt) do (if not "%%a"=="bff-test" ECHOC {%c_e%}strtofile.exe�޷�����{%c_i%}{\n}& goto FATAL)
del %framwork_workspace%\tmp\bff-test.txt 1>nul


:CMD
CLS
ECHOC {0E}=--------------------------------------------------------------------={0F}{\n}
ECHO.
ECHO.                              BFF-������
ECHO.
ECHOC {0E}=--------------------------------------------------------------------={0F}{\n}
ECHO.
ECHOC {0E} ������ADB��Fastboot����. ����������, ��Enterִ��. ������һЩԤ������.{0F}{\n}
ECHO.
ECHOC {0E} cc{0F}  ���ADB��Fastboot����  {0E}kil{0F} ��������ADB��Fastboot����{0F}{\n}
ECHOC {0E} pre{0F} һ��׼��ADB Shell����  {0E}cfg{0F} ���ز���ʾ������Ϣ{0F}{\n}
ECHOC {0E} mmc{0F} �����豸������         {0E}cls{0F} �����Ļ{0F}{\n}
ECHO. 
:CMD-CONTINUE
ECHOC {0E}=--------------------------------------------------------------------={0F}{\n}
ECHOC {0E}[����]{0F} & call strtofile.exe %framwork_workspace%\tmp\cmd.bat
for /f %%a in (%framwork_workspace%\tmp\cmd.bat) do set cmd=%%a
if "%cmd%"=="" ECHOC {0C}                                                        [û����������]{0F}{\n}& goto CMD-CONTINUE
if "%cmd%"=="cls" goto CMD
if "%cmd%"=="CLS" goto CMD
if "%cmd%"=="cc" (
    ECHO.���ADB����...& adb.exe devices | findstr /v "attached"
    ECHO.���Fastboot����...& fastboot.exe devices & goto CMD-CONTINUE)
if "%cmd%"=="mmc" (
    tasklist | find "mmc.exe" 1>nul 2>nul && ECHOC {0A}�豸�������������У�{0F}{\n}&& goto CMD-CONTINUE
    start %windir%\system32\devmgmt.msc & goto CMD-CONTINUE)
if "%cmd%"=="kil" (
    tasklist | find "adb.exe" 1>nul 2>nul && taskkill /f /im adb.exe
    tasklist | find "fastboot.exe" 1>nul 2>nul && taskkill /f /im fastboot.exe
    goto CMD-CONTINUE)
if "%cmd%"=="pre" (
    ECHO.���й��߾��ᱻ���͵���Ŀ¼����Ȩ
    ECHO.bootctl...& call :pushlinuxtool bootctl
    ECHO.busybox...& call :pushlinuxtool busybox
    ECHO.dmsetup...& call :pushlinuxtool dmsetup
    ECHO.blktool...& call :pushlinuxtool blktool
    ECHO.mke2fs...& call :pushlinuxtool mke2fs
    ECHO.mkfs.exfat...& call :pushlinuxtool mkfs.exfat
    ECHO.mkfs.fat...& call :pushlinuxtool mkfs.fat
    ECHO.mkntfs...& call :pushlinuxtool mkntfs
    ECHO.parted...& call :pushlinuxtool parted
	ECHO.sgdisk...& call :pushlinuxtool sgdisk
    goto CMD-CONTINUE)
if "%cmd%"=="cfg" (
    ECHOC {0F}�̶�����:{07}{\n}& @ECHO ON & prompt $_& call %framwork_workspace%\conf\fixed|findstr "set" & prompt & @ECHO OFF
    ECHOC {0F}�û�����:{07}{\n}& @ECHO ON & prompt $_& call %framwork_workspace%\conf\user|findstr "set" & prompt & @ECHO OFF
    goto CMD-CONTINUE)
call %framwork_workspace%\tmp\cmd.bat || ECHOC {0C}                                                          [���������]{0F}{\n}
goto CMD-CONTINUE


:pushlinuxtool
if not exist %framwork_workspace%\tool\Android\%1 ECHOC {0C}�Ҳ���%framwork_workspace%\tool\Android\%1{0F}{\n}& goto :eof
adb.exe push %framwork_workspace%\tool\Android\%1 ./%1 1>nul || ECHOC {0C}����%framwork_workspace%\tool\Android\%1��./%1ʧ��{0F}{\n}&& goto :eof
adb.exe shell chmod +x ./%1 1>nul || ECHOC {0C}��Ȩ./%1ʧ��{0F}{\n}&& goto :eof
goto :eof


:NODEV
ECHOC {0C}                                                    [�豸δ(��ȷ)����]{0F}{\n}
goto CMD-CONTINUE






:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)
