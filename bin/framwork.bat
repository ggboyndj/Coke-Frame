::call  framwork startpre  skiptoolchk(可选)
::               adbpre    [文件名 all]
::               theme     主题名
::               conf      配置文件名    变量名  变量值
::               logviewer end

::start framwork logviewer start        %logfile%


@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%


:LOGVIEWER
if "%var2%"=="end" taskkill /f /im busybox-bfflogviewer.exe 1>nul 2>nul & goto :eof
@ECHO OFF
COLOR 0F
TITLE BFF-实时日志监控 [本窗口只监控日志, 不参与脚本运行]
ECHO.
ECHO.当前日志文件: %logfile%
ECHO.
call tool\Windows\resizecmdwindow.exe -l 0 -r 70 -t 0 -b 20 -w 500 -h 800
tool\Windows\busybox-bfflogviewer.exe tail -f -s 1 %var3%
EXIT


:CONF
SETLOCAL
set logger=framwork.bat-conf
call log %logger% I 将向conf\%var2%写入%var3%.值为%var4%
::if not exist conf\%var2% ECHOC {%c_e%}找不到conf\%var2%{%c_i%}{\n}& call log %logger% F 找不到conf\%var2%& goto FATAL
if not exist conf\%var2% echo.>conf\%var2%
find "set %var3%=" "conf\%var2%" 1>nul 2>nul || echo.set %var3%=%var4%|findstr "set" 1>>conf\%var2%&& goto CONF-DONE
type conf\%var2% | find "set " | find /v "set %var3%=" 1>tmp\output.txt
echo.set %var3%=%var4%|findstr "set" 1>>tmp\output.txt
move /Y tmp\output.txt conf\%var2% 1>nul || ECHOC {%c_e%}移动tmp\output.txt到conf\%var2%失败{%c_i%}{\n}&& call log %logger% F 移动tmp\output.txt到conf\%var2%失败&& goto FATAL
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
ECHO.正在准备启动...
::ECHO.检查find命令...
find /? | find "string" 1>nul || ECHO.执行find命令失败&& goto FATAL
::ECHO.获取Windows版本号...
for /f "tokens=4 delims=[] " %%a in ('ver ^| find " "') do set winver=%%a
::ECHO.检查findstr命令...
findstr /? | findstr "string" 1>nul || ECHO.执行findstr命令失败&& goto FATAL
::ECHO.检查和保存工作目录路径...
for /f "tokens=2 delims=() " %%i in ('echo." %cd% "') do (if not "%%i"=="%cd%" ECHO.工具箱路径中不允许有空格或英文括号& goto FATAL)
set framwork_workspace=%cd%
::ECHO.设置path...
set path=%path%||ECHO.系统环境变量的Path变量中存在错误的路径. 请更正后再试&& goto FATAL
set path=%framwork_workspace%;%framwork_workspace%\tool\Windows;%windir%\Sysnative;%path%
::ECHO.检查tmp文件夹
if not exist tmp md tmp 1>nul || ECHOC {%c_e%}创建tmp文件夹失败{%c_i%}{\n}&& goto FATAL
::ECHO.检查ECHOC...
if not exist tool\Windows\ECHOC.exe ECHO.找不到ECHOC.exe& goto FATAL
ECHOC | find "Usage" 1>nul 2>nul || ECHO.ECHOC.exe无法运行&& goto FATAL
::ECHO.准备日志系统...
if "%framwork_log%"=="n" set logfile=nul& set logger=CLOSED
if "%framwork_log%"=="n" SETLOCAL & goto STARTPRE-2
if not exist log md log 1>nul || ECHOC {%c_e%}创建log文件夹失败{%c_i%}{\n}&& goto FATAL
if not exist tool\Windows\gettime.exe ECHOC {%c_e%}找不到gettime.exe{%c_i%}{\n}& goto FATAL
gettime.exe | find "." 1>nul 2>nul || ECHOC {%c_e%}gettime.exe无法运行{%c_i%}{\n}&& goto FATAL
for /f %%a in ('gettime.exe ^| find "."') do set logfile=%framwork_workspace%\log\%%a.log
set logger=UNKNOWN
SETLOCAL
set logger=framwork.bat-startpre
call log %logger% I 系统信息:%processor_architecture%.%winver%.工作目录:%framwork_workspace%
::ECHO.清理日志...
if "%framwork_lognum%"=="" set framwork_lognum=6
for /f %%a in ('dir /B log ^| find /C ".log"') do (if %%a LEQ %framwork_lognum% goto STARTPRE-2)
for /f "tokens=1 delims=[]" %%a in ('dir /B log ^| find /N ".log"') do set /a var=%%a-%framwork_lognum%
:STARTPRE-1
dir /B log | find /N ".log" | find "[%var%]" 1>nul 2>nul || goto STARTPRE-2
for /f "tokens=2 delims=[]" %%a in ('dir /B log ^| find /N ".log" ^| find "[%var%]"') do del log\%%a 1>nul
set /a var+=-1& goto STARTPRE-1
:STARTPRE-2
if "%var2%"=="skiptoolchk" call log %logger% I 跳过检查工具& goto STARTPRE-DONE
::ECHO.360AblumViewer...
::if not exist tool\Windows\360AblumViewer.exe ECHOC {%c_e%}找不到360AblumViewer.exe{%c_i%}{\n}& call log %logger% F 找不到360AblumViewer.exe& goto FATAL
::if not exist tool\Windows\360AblumViewer.ini ECHOC {%c_e%}找不到360AblumViewer.ini{%c_i%}{\n}& call log %logger% F 找不到360AblumViewer.ini& goto FATAL
::ECHO.检查Notepad3...
if not exist tool\Windows\Notepad3\Notepad3.exe ECHOC {%c_e%}找不到Notepad3.exe{%c_i%}{\n}& call log %logger% F 找不到Notepad3.exe& goto FATAL
::ECHO.检查scrcpy...
if not exist tool\Windows\scrcpy\scrcpy.exe ECHOC {%c_e%}找不到scrcpy.exe{%c_i%}{\n}& call log %logger% F 找不到scrcpy.exe& goto FATAL
tool\Windows\scrcpy\scrcpy.exe -h | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}scrcpy.exe无法运行{%c_i%}{\n}&& call log %logger% F scrcpy.exe无法运行&& goto FATAL
::ECHO.检查7z...
if not exist tool\Windows\7z.dll ECHOC {%c_e%}找不到7z.dll{%c_i%}{\n}& call log %logger% F 找不到7z.dll& goto FATAL
if not exist tool\Windows\7z.exe ECHOC {%c_e%}找不到7z.exe{%c_i%}{\n}& call log %logger% F 找不到7z.exe& goto FATAL
7z.exe | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}7z.exe无法运行{%c_i%}{\n}&& call log %logger% F 7z.exe无法运行&& goto FATAL
::ECHO.检查aapt...
if not exist tool\Windows\aapt.exe ECHOC {%c_e%}找不到aapt.exe{%c_i%}{\n}& call log %logger% F 找不到aapt.exe& goto FATAL
tool\Windows\aapt.exe v | find "Android" 1>nul 2>nul || ECHOC {%c_e%}aapt.exe无法运行{%c_i%}{\n}&& call log %logger% F aapt.exe无法运行&& goto FATAL
::ECHO.检查adb...
if not exist tool\Windows\adb.exe ECHOC {%c_e%}找不到adb.exe{%c_i%}{\n}& call log %logger% F 找不到adb.exe& goto FATAL
if not exist tool\Windows\AdbWinApi.dll ECHOC {%c_e%}找不到AdbWinApi.dll{%c_i%}{\n}& call log %logger% F 找不到AdbWinApi.dll& goto FATAL
if not exist tool\Windows\AdbWinUsbApi.dll ECHOC {%c_e%}找不到AdbWinUsbApi.dll{%c_i%}{\n}& call log %logger% F 找不到AdbWinUsbApi.dll& goto FATAL
adb.exe start-server>nul
adb.exe devices | find "List of devices attached" 1>nul 2>nul || ECHOC {%c_e%}adb.exe无法运行{%c_i%}{\n}&& call log %logger% F adb.exe无法运行&& goto FATAL
::ECHO.检查aria2c...
if not exist tool\Windows\aria2c.exe ECHOC {%c_e%}找不到aria2c.exe{%c_i%}{\n}& call log %logger% F 找不到aria2c.exe& goto FATAL
aria2c.exe -h | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}aria2c.exe无法运行{%c_i%}{\n}&& call log %logger% F aria2c.exe无法运行&& goto FATAL
::ECHO.检查busybox...
if not exist tool\Windows\busybox.exe ECHOC {%c_e%}找不到busybox.exe{%c_i%}{\n}& call log %logger% F 找不到busybox.exe& goto FATAL
busybox.exe | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}busybox.exe无法运行{%c_i%}{\n}&& call log %logger% F busybox.exe无法运行&& goto FATAL
::ECHO.检查busybox-bfflogviewer...
if not exist tool\Windows\busybox-bfflogviewer.exe ECHOC {%c_e%}找不到busybox-bfflogviewer.exe{%c_i%}{\n}& call log %logger% F 找不到busybox-bfflogviewer.exe& goto FATAL
busybox-bfflogviewer.exe | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}busybox-bfflogviewer.exe无法运行{%c_i%}{\n}&& call log %logger% F busybox-bfflogviewer.exe无法运行&& goto FATAL
::ECHO.检查calc...
if not exist tool\Windows\calc.exe ECHOC {%c_e%}找不到calc.exe{%c_i%}{\n}& call log %logger% F 找不到calc.exe& goto FATAL
calc.exe 6 m 6 | find "36.00" 1>nul 2>nul || ECHOC {%c_e%}calc.exe无法运行{%c_i%}{\n}&& call log %logger% F calc.exe无法运行&& goto FATAL
::ECHO.检查curl...
if not exist tool\Windows\curl.exe ECHOC {%c_e%}找不到curl.exe{%c_i%}{\n}& call log %logger% F 找不到curl.exe& goto FATAL
curl.exe --help | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}curl.exe无法运行{%c_i%}{\n}&& call log %logger% F curl.exe无法运行&& goto FATAL
::ECHO.检查cygwin1.dll...
::if not exist tool\Windows\cygwin1.dll ECHOC {%c_e%}找不到cygwin1.dll{%c_i%}{\n}& call log %logger% F 找不到cygwin1.dll& goto FATAL
::ECHO.检查devcon...
if not exist tool\Windows\devcon.exe ECHOC {%c_e%}找不到devcon.exe{%c_i%}{\n}& call log %logger% F 找不到devcon.exe& goto FATAL
devcon.exe help | find "Device" 1>nul 2>nul || ECHOC {%c_e%}devcon.exe无法运行{%c_i%}{\n}&& call log %logger% F devcon.exe无法运行&& goto FATAL
::ECHO.检查fastboot...
if not exist tool\Windows\fastboot.exe ECHOC {%c_e%}找不到fastboot.exe{%c_i%}{\n}& call log %logger% F 找不到fastboot.exe& goto FATAL
fastboot.exe -h 2>&1 | find "usage" 1>nul 2>nul || ECHOC {%c_e%}fastboot.exe无法运行{%c_i%}{\n}&& call log %logger% F fastboot.exe无法运行&& goto FATAL
::ECHO.检查fh_loader...
if not exist tool\Windows\fh_loader.exe ECHOC {%c_e%}找不到fh_loader.exe{%c_i%}{\n}& call log %logger% F 找不到fh_loader.exe& goto FATAL
fh_loader.exe -6 2>&1 | find "Base" 1>nul 2>nul || ECHOC {%c_e%}fh_loader.exe无法运行{%c_i%}{\n}&& call log %logger% F fh_loader.exe无法运行&& goto FATAL
::ECHO.检查filedialog...
if not exist tool\Windows\filedialog.exe ECHOC {%c_e%}找不到filedialog.exe{%c_i%}{\n}& call log %logger% F 找不到filedialog.exe& goto FATAL
filedialog.exe | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}filedialog.exe无法运行{%c_i%}{\n}&& call log %logger% F filedialog.exe无法运行&& goto FATAL
::ECHO.检查libcurl.def...
if not exist tool\Windows\libcurl.def ECHOC {%c_e%}找不到libcurl.def{%c_i%}{\n}& call log %logger% F 找不到libcurl.def& goto FATAL
::ECHO.检查libcurl.dll...
if not exist tool\Windows\libcurl.dll ECHOC {%c_e%}找不到libcurl.dll{%c_i%}{\n}& call log %logger% F 找不到libcurl.dll& goto FATAL
::ECHO.检查magiskboot...
if not exist tool\Windows\magiskboot.exe ECHOC {%c_e%}找不到magiskboot.exe{%c_i%}{\n}& call log %logger% F 找不到magiskboot.exe& goto FATAL
magiskboot.exe 2>&1 | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}magiskboot.exe无法运行{%c_i%}{\n}&& call log %logger% F magiskboot.exe无法运行&& goto FATAL
::ECHO.检查magiskpatcher...
::if not exist tool\Windows\magiskpatcher.exe ECHOC {%c_e%}找不到magiskpatcher.exe{%c_i%}{\n}& call log %logger% F 找不到magiskpatcher.exe& goto FATAL
::magiskpatcher.exe -h 2>&1 | find "usage" 1>nul 2>nul || ECHOC {%c_e%}magiskpatcher.exe无法运行{%c_i%}{\n}&& call log %logger% F magiskpatcher.exe无法运行&& goto FATAL
::ECHO.检查numcomp...
if not exist tool\Windows\numcomp.exe ECHOC {%c_e%}找不到numcomp.exe{%c_i%}{\n}& call log %logger% F 找不到numcomp.exe& goto FATAL
numcomp.exe 999 888 | find "greater" 1>nul 2>nul || ECHOC {%c_e%}numcomp.exe无法运行{%c_i%}{\n}&& call log %logger% F numcomp.exe无法运行&& goto FATAL
::ECHO.检查ptanalyzer...
if not exist tool\Windows\ptanalyzer.exe ECHOC {%c_e%}找不到ptanalyzer.exe{%c_i%}{\n}& call log %logger% F 找不到ptanalyzer.exe& goto FATAL
ptanalyzer.exe 2>&1 | find "ptanalyzer" 1>nul 2>nul || ECHOC {%c_e%}ptanalyzer.exe无法运行{%c_i%}{\n}&& call log %logger% F ptanalyzer.exe无法运行&& goto FATAL
::ECHO.检查QSaharaServer...
if not exist tool\Windows\QSaharaServer.exe ECHOC {%c_e%}找不到QSaharaServer.exe{%c_i%}{\n}& call log %logger% F 找不到QSaharaServer.exe& goto FATAL
QSaharaServer.exe | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}QSaharaServer.exe无法运行{%c_i%}{\n}&& call log %logger% F QSaharaServer.exe无法运行&& goto FATAL
::ECHO.检查resizecmdwindow...
if not exist tool\Windows\resizecmdwindow.exe ECHOC {%c_e%}找不到resizecmdwindow.exe{%c_i%}{\n}& call log %logger% F 找不到resizecmdwindow.exe& goto FATAL
resizecmdwindow.exe | find "usage" 1>nul 2>nul || ECHOC {%c_e%}resizecmdwindow.exe无法运行{%c_i%}{\n}&& call log %logger% F resizecmdwindow.exe无法运行&& goto FATAL
::ECHO.检查strtofile...
if not exist tool\Windows\strtofile.exe ECHOC {%c_e%}找不到strtofile.exe{%c_i%}{\n}& call log %logger% F 找不到strtofile.exe& goto FATAL
if exist tmp\bff-test.txt del tmp\bff-test.txt 1>nul
echo.bff-test|strtofile.exe tmp\bff-test.txt || ECHOC {%c_e%}strtofile.exe无法运行{%c_i%}{\n}&& call log %logger% F strtofile.exe无法运行&& goto FATAL
for /f %%a in (tmp\bff-test.txt) do (if not "%%a"=="bff-test" ECHOC {%c_e%}strtofile.exe无法运行{%c_i%}{\n}& call log %logger% F strtofile.exe无法运行& goto FATAL)
del tmp\bff-test.txt 1>nul
::ECHO.检查usbdump...
::if not exist tool\Windows\usbdump.exe ECHOC {%c_e%}找不到usbdump.exe{%c_i%}{\n}& call log %logger% F 找不到usbdump.exe& goto FATAL
::usbdump.exe -v | find "." 1>nul 2>nul || ECHOC {%c_e%}usbdump.exe无法运行{%c_i%}{\n}&& call log %logger% F usbdump.exe无法运行&& goto FATAL
::ECHO.检查Vieas...
if not exist tool\Windows\Vieas\Vieas.exe ECHOC {%c_e%}找不到Vieas.exe{%c_i%}{\n}& call log %logger% F 找不到Vieas.exe& goto FATAL
::ECHO.准备安卓工具,安卓工具路径可以用变量
::ECHO.检查magisk\25200.apk...
::if not exist tool\Android\magisk\25200.apk ECHOC {%c_e%}找不到magisk\25200.apk{%c_i%}{\n}& call log %logger% F 找不到magisk\25200.apk& goto FATAL
::ECHO.检查blktool...
if not exist tool\Android\blktool ECHOC {%c_e%}找不到blktool{%c_i%}{\n}& call log %logger% F 找不到blktool& goto FATAL
::ECHO.检查bootctl...
if not exist tool\Android\bootctl ECHOC {%c_e%}找不到bootctl{%c_i%}{\n}& call log %logger% F 找不到bootctl& goto FATAL
::ECHO.检查busybox...
if not exist tool\Android\busybox ECHOC {%c_e%}找不到busybox{%c_i%}{\n}& call log %logger% F 找不到busybox& goto FATAL
::ECHO.检查dmsetup...
if not exist tool\Android\dmsetup ECHOC {%c_e%}找不到dmsetup{%c_i%}{\n}& call log %logger% F 找不到dmsetup& goto FATAL
::ECHO.检查misc_tofastboot.img...
::if not exist tool\Android\misc_tofastboot.img ECHOC {%c_e%}找不到misc_tofastboot.img{%c_i%}{\n}& call log %logger% F 找不到misc_tofastboot.img& goto FATAL
::ECHO.检查misc_torecovery.img...
::if not exist tool\Android\misc_torecovery.img ECHOC {%c_e%}找不到misc_torecovery.img{%c_i%}{\n}& call log %logger% F 找不到misc_torecovery.img& goto FATAL
::ECHO.检查mke2fs...
if not exist tool\Android\mke2fs ECHOC {%c_e%}找不到mke2fs{%c_i%}{\n}& call log %logger% F 找不到mke2fs& goto FATAL
::ECHO.检查mkfs.exfat...
if not exist tool\Android\mkfs.exfat ECHOC {%c_e%}找不到mkfs.exfat{%c_i%}{\n}& call log %logger% F 找不到mkfs.exfat& goto FATAL
::ECHO.检查mkfs.fat...
if not exist tool\Android\mkfs.fat ECHOC {%c_e%}找不到mkfs.fat{%c_i%}{\n}& call log %logger% F 找不到mkfs.fat& goto FATAL
::ECHO.检查mkntfs...
if not exist tool\Android\mkntfs ECHOC {%c_e%}找不到mkntfs{%c_i%}{\n}& call log %logger% F 找不到mkntfs& goto FATAL
::ECHO.检查parted...
if not exist tool\Android\parted ECHOC {%c_e%}找不到parted{%c_i%}{\n}& call log %logger% F 找不到parted& goto FATAL
::ECHO.检查sgdisk...
if not exist tool\Android\sgdisk ECHOC {%c_e%}找不到sgdisk{%c_i%}{\n}& call log %logger% F 找不到sgdisk& goto FATAL
:STARTPRE-DONE
call log %logger% I 启动准备工作完成
ENDLOCAL
goto :eof


:ADBPRE
SETLOCAL
set logger=framwork.bat-adbpre
::接收变量
set target_name=%var2%
call log %logger% I 接收变量:target_name:%target_name%
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
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}抱歉, 脚本遇到问题, 无法继续运行. 请查看日志. {%c_h%}按任意键退出...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.抱歉, 脚本遇到问题, 无法继续运行. 按任意键退出...& pause>nul & EXIT)
