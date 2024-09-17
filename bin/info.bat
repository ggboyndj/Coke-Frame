::call info adb
::          fastboot
::          mtkclient
::          par       分区名    [fail back](当找不到分区时的操作.可选.默认为fail)
::          disk      磁盘路径

@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%


:MTKCLIENT
SETLOCAL
set logger=info.bat-mtkclient
call log %logger% I 开始读取联发科设备信息
:MTKCLIENT-1
if exist tmp\output.txt del tmp\output.txt 1>nul
call tool\Windows\mtkclient\mtkclient.bat gettargetconfig
type tmp\output.txt>>%logfile%
::处理器
set var=
for /f "tokens=4 delims=(	 " %%a in ('type "tmp\output.txt" ^| find "Preloader - 	CPU:"') do set var=%%a
if "%var%"=="" ECHOC {%c_e%}读取cpu信息失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 读取cpu信息失败& pause>nul & ECHO.重试... & goto MTKCLIENT-1
set cpu=%var%
::MEID
set meid=
for /f "tokens=4 delims=	 " %%a in ('type "tmp\output.txt" ^| find "Preloader - ME_ID:"') do set meid=%%a
if "%meid%"=="" ECHOC {%c_e%}读取meid信息失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 读取meid信息失败& pause>nul & ECHO.重试... & goto MTKCLIENT-1
call log %logger% I 读取到联发科设备信息:cpu:%cpu%.meid:%meid%
ENDLOCAL & set info__mtkclient__cpu=%cpu%& set info__mtkclient__meid=%meid%
goto :eof


:ADB
SETLOCAL
set logger=info.bat-adb
call log %logger% I 开始读取ADB设备信息
:ADB-1
set product=
for /f %%i in ('adb.exe shell getprop ro.product.device') do set product=%%i
if "%product%"=="" call log %logger% E ro.product.device读取失败& ECHOC {%c_e%}ro.product.device读取失败. {%c_h%}按任意键重试...{%c_i%}{\n}& pause>nul & ECHO.重试... & goto ADB-1
set androidver=
for /f %%i in ('adb.exe shell getprop ro.build.version.release') do set androidver=%%i
if "%androidver%"=="" call log %logger% E ro.build.version.release读取失败& ECHOC {%c_e%}ro.build.version.release读取失败. {%c_h%}按任意键重试...{%c_i%}{\n}& pause>nul & ECHO.重试... & goto ADB-1
set sdkver=
for /f %%i in ('adb.exe shell getprop ro.build.version.sdk') do set sdkver=%%i
if "%sdkver%"=="" call log %logger% E ro.build.version.sdk读取失败& ECHOC {%c_e%}ro.build.version.sdk读取失败. {%c_h%}按任意键重试...{%c_i%}{\n}& pause>nul & ECHO.重试... & goto ADB-1
call log %logger% I 读取到ADB设备信息:product:%product%.androidver:%androidver%.sdkver:%sdkver%
ENDLOCAL & set info__adb__product=%product%& set info__adb__androidver=%androidver%& set info__adb__sdkver=%sdkver%
goto :eof


:FASTBOOT
SETLOCAL
set logger=info.bat-fastboot
call log %logger% I 开始读取Fastboot设备信息
:FASTBOOT-1
set product=
for /f "tokens=2 delims=: " %%i in ('fastboot getvar product 2^>^&1^| find "product"') do set product=%%i
if "%product%"=="" call log %logger% E product读取失败& ECHOC {%c_e%}product读取失败. {%c_h%}按任意键重试...{%c_i%}{\n}& pause>nul & ECHO.重试... & goto FASTBOOT-1
set unlocked=
for /f "tokens=2 delims=: " %%i in ('fastboot getvar unlocked 2^>^&1^| find "unlocked"') do set unlocked=%%i
if "%unlocked%"=="" call log %logger% E unlocked读取失败& ECHOC {%c_e%}unlocked读取失败. {%c_h%}按任意键重试...{%c_i%}{\n}& pause>nul & ECHO.重试... & goto FASTBOOT-1
call log %logger% I 读取到Fastboot设备信息:product:%product%.unlocked:%unlocked%
ENDLOCAL & set info__fastboot__product=%product%& set info__fastboot__unlocked=%unlocked%
goto :eof
::附:摩托罗拉设备判断解锁的方法如下: fastboot getvar securestate 2>&1| find "flashing_unlocked" 1>nul 2>nul && set unlocked=yes


:PAR
SETLOCAL
set logger=info.bat-par
set parname=%var2%& set ifparnotexist=%var3%
if "%ifparnotexist%"=="" set ifparnotexist=fail
call log %logger% I 接收变量:parname:%parname%.ifparnotexist:%ifparnotexist%
call framwork adbpre blktool
call framwork adbpre sgdisk
::call framwork adbpre parted
:PAR-1
call chkdev all 1>nul
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" ECHOC {%c_e%}设备模式错误, 只支持在系统或Recovery获取分区路径. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 模式错误:%chkdev__all__mode%.应进入系统或Recovery模式& pause>nul & ECHO.重试... & goto PAR-1)
call log %logger% I 开始检查分区是否存在
if "%chkdev__all__mode%"=="system" echo.su>tmp\cmd.txt& echo../data/local/tmp/blktool -n -N %parname% -l>>tmp\cmd.txt
if "%chkdev__all__mode%"=="recovery" echo../blktool -n -N %parname% -l>tmp\cmd.txt
set parexist=n
adb.exe shell < tmp\cmd.txt 2>&1 | find "list failed: no any match block found" 1>nul 2>nul || set parexist=y
if "%parexist%"=="n" (
    if "%ifparnotexist%"=="fail" ECHOC {%c_e%}%parname%分区不存在. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E %parname%分区不存在& pause>nul & ECHO.重试... & goto PAR-1
    if "%ifparnotexist%"=="back" (
        call log %logger% I %parname%分区不存在.退出读取分区信息
        ENDLOCAL & set info__par__exist=n
        goto :eof))
:PAR-2
::call log %logger% I 开始获取分区编号.分区路径.磁盘扇区大小
if "%chkdev__all__mode%"=="system" echo.su>tmp\cmd.txt& echo../data/local/tmp/blktool -n -N %parname% --print-part -l --print-sector-size>>tmp\cmd.txt
if "%chkdev__all__mode%"=="recovery" echo../blktool -n -N %parname% --print-part -l --print-sector-size>tmp\cmd.txt
set parnum=& set parpath=& set disksecsize=
for /f "tokens=1,2,3 delims= " %%a in ('adb.exe shell ^< tmp\cmd.txt') do (set parnum=%%a& set parpath=%%b& set disksecsize=%%c)
if "%parnum%"=="" (ECHOC {%c_e%}获取分区编号失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 获取分区编号失败& pause>nul & ECHO.重试... & goto PAR-2) else (call log %logger% I 获取分区编号完成:%parnum%)
if "%parpath%"=="" (ECHOC {%c_e%}获取分区路径失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 获取分区路径失败& pause>nul & ECHO.重试... & goto PAR-2) else (call log %logger% I 获取分区路径完成:%parpath%)
if "%disksecsize%"=="" (ECHOC {%c_e%}获取磁盘扇区大小失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 获取磁盘扇区大小失败& pause>nul & ECHO.重试... & goto PAR-2) else (call log %logger% I 获取磁盘扇区大小完成:%disksecsize%)
:PAR-6
::call log %logger% I 开始获取存储类型
echo.%parpath% | find "mmcblk" 1>nul 2>nul && set disktype=emmc&& call log %logger% I 获取存储类型完成:emmc&& goto PAR-3
echo.%parpath% | find "dev/block/sd" 1>nul 2>nul && set disktype=ufs&& call log %logger% I 获取存储类型完成:ufs&& goto PAR-3
ECHOC {%c_e%}不支持的存储类型{%c_i%}{\n}& call log %logger% F 不支持的存储类型& goto FATAL
::if "%chkdev__all__mode%"=="system" echo.su>tmp\cmd.txt& echo../data/local/tmp/parted %diskpath% p>>tmp\cmd.txt
::if "%chkdev__all__mode%"=="recovery" echo../parted %diskpath% p>tmp\cmd.txt
::set disktype=
::for /f "tokens=2 delims= " %%a in ('adb.exe shell ^< tmp\cmd.txt ^| find "Model: "') do set disktype=%%a
::if "%disktype%"=="" (ECHOC {%c_e%}获取存储类型失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 获取存储类型失败& pause>nul & ECHO.重试... & goto PAR-6) else (call log %logger% I 获取存储类型完成:%disktype%)
::if not "%disktype%"=="MMC" (if not "%disktype%"=="ufs" ECHOC {%c_e%}不支持的存储类型:%disktype%{%c_i%}{\n}& call log %logger% F 不支持的存储类型& goto FATAL)
:PAR-3
::call log %logger% I 开始获取所在磁盘路径
echo.%parpath%>tmp\output.txt
if "%disktype%"=="ufs" busybox.exe sed -i "s/%parnum%$//g" tmp\output.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}sed处理tmp\output.txt失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E sed处理tmp\output.txt失败&& pause>nul && ECHO.重试... && goto PAR-3
if "%disktype%"=="emmc" busybox.exe sed -i "s/p%parnum%$//g" tmp\output.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}sed处理tmp\output.txt失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E sed处理tmp\output.txt失败&& pause>nul && ECHO.重试... && goto PAR-3
set diskpath=
for /f "tokens=1 delims= " %%i in ('type tmp\output.txt') do set diskpath=%%i
if "%diskpath%"=="" (ECHOC {%c_e%}获取所在磁盘路径失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 获取所在磁盘路径失败& pause>nul & ECHO.重试... & goto PAR-3) else (call log %logger% I 获取所在磁盘路径完成:%diskpath%)
:PAR-4
::call log %logger% I 开始获取分区start.end.类型
if "%chkdev__all__mode%"=="system" echo.su>tmp\cmd.txt& echo../data/local/tmp/sgdisk -p %diskpath% >>tmp\cmd.txt
if "%chkdev__all__mode%"=="recovery" echo../sgdisk -p %diskpath% >tmp\cmd.txt
del tmp\output.txt 1>nul
for /f "tokens=1 delims=" %%i in ('adb.exe shell ^< tmp\cmd.txt ^| find "  " ^| find /v "Number"') do echo.%%i#>>tmp\output.txt
set parstart=& set parend=& set partype=
for /f "tokens=2,3,6 delims= " %%a in ('type tmp\output.txt ^| find "%parname%#"') do (set parstart_sec=%%a& set parend_sec=%%b& set partype=%%c)
call calc sec2kb parstart nodec %parstart_sec% %disksecsize%
call calc sec2kb parend nodec %parend_sec% %disksecsize%
if "%parstart%"=="" (ECHOC {%c_e%}获取分区start失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 获取分区start失败& pause>nul & ECHO.重试... & goto PAR-4) else (call log %logger% I 获取分区start完成:%parstart%)
if "%parend%"=="" (ECHOC {%c_e%}获取分区end失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 获取分区end失败& pause>nul & ECHO.重试... & goto PAR-4) else (call log %logger% I 获取分区end完成:%parend%)
if "%partype%"=="" (ECHOC {%c_e%}获取分区类型失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 获取分区类型失败& pause>nul & ECHO.重试... & goto PAR-4) else (call log %logger% I 获取分区类型完成:%partype%)
:PAR-5
::call log %logger% I 开始计算分区大小
set /a parsize_sec=%parend_sec%-%parstart_sec%+1
call calc sec2kb parsize nodec %parsize_sec% %disksecsize%
call log %logger% I 计算分区大小完成:%parsize%
call log %logger% I 读取分区信息完成
ENDLOCAL & set info__par__exist=%parexist%& set info__par__diskpath=%diskpath%& set info__par__num=%parnum%& set info__par__path=%parpath%& set info__par__type=%partype%& set info__par__start=%parstart%& set info__par__end=%parend%& set info__par__size=%parsize%& set info__par__disksecsize=%disksecsize%& set info__par__disktype=%disktype%
goto :eof


:DISK
SETLOCAL
set logger=info.bat-disk
set diskpath=%var2%
call log %logger% I 接收变量:diskpath:%diskpath%
call framwork adbpre blktool
call framwork adbpre sgdisk
:DISK-3
call chkdev all 1>nul
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" ECHOC {%c_e%}设备模式错误, 只支持在系统或Recovery获取分区路径. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 模式错误:%chkdev__all__mode%.应进入系统或Recovery模式& pause>nul & ECHO.重试... & goto DISK-3)
::获取存储类型
echo.%diskpath% | find "mmcblk" 1>nul 2>nul && set disktype=emmc&& call log %logger% I 获取存储类型完成:emmc&& goto DISK-1
echo.%diskpath% | find "dev/block/sd" 1>nul 2>nul && set disktype=ufs&& call log %logger% I 获取存储类型完成:ufs&& goto DISK-1
ECHOC {%c_e%}不支持的存储类型{%c_i%}{\n}& call log %logger% F 不支持的存储类型& goto FATAL
::获取磁盘扇区大小
:DISK-1
if "%chkdev__all__mode%"=="system" echo.su>tmp\cmd.txt& echo../data/local/tmp/blktool -n -p --print-sector-size>>tmp\cmd.txt
if "%chkdev__all__mode%"=="recovery" echo../blktool -n -p --print-sector-size>tmp\cmd.txt
set disksecsize=
for /f "tokens=2 delims= " %%a in ('adb.exe shell ^< tmp\cmd.txt ^| find "%diskpath%"') do set disksecsize=%%a
if "%disksecsize%"=="" (ECHOC {%c_e%}获取磁盘扇区大小失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 获取磁盘扇区大小失败& pause>nul & ECHO.重试... & goto DISK-1) else (call log %logger% I 获取磁盘扇区大小完成:%disksecsize%)
::获取最大分区数
:DISK-2
if "%chkdev__all__mode%"=="system" echo.su>tmp\cmd.txt& echo../data/local/tmp/sgdisk -p %diskpath% >>tmp\cmd.txt
if "%chkdev__all__mode%"=="recovery" echo../sgdisk -p %diskpath% >tmp\cmd.txt
set maxparnum=
for /f "tokens=6 delims= " %%a in ('adb.exe shell ^< tmp\cmd.txt ^| find "Partition table holds up to "') do set maxparnum=%%a
if "%maxparnum%"=="" (ECHOC {%c_e%}获取最大分区数失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 获取最大分区数失败& pause>nul & ECHO.重试... & goto DISK-2) else (call log %logger% I 获取最大分区数完成:%maxparnum%)
call log %logger% I 读取磁盘信息完成
ENDLOCAL & set info__disk__type=%disktype%& set info__disk__secsize=%disksecsize%& set info__disk__maxparnum=%maxparnum%
goto :eof















:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}抱歉, 脚本遇到问题, 无法继续运行. 请查看日志. {%c_h%}按任意键退出...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.抱歉, 脚本遇到问题, 无法继续运行. 按任意键退出...& pause>nul & EXIT)
