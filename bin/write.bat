::call write system        分区名               img路径
::           recovery      分区名               img路径
::           fastboot      分区名               img路径
::           fastbootboot  img路径
::           mtkclient     分区名               img路径
::           qcedlxml      端口号               存储类型                     img所在文件夹                                         xml路径     firehose完整路径(可选,不填不发送)
::           qcedlsingle   端口号               存储类型                     分区名                                               img路径      firehose完整路径(可选,不填不发送)
::           sprdboot      端口号               pac包路径
::           spflash       scatter或xml完整路径 [download firmware-upgrade] [da完整路径 auto](旧平台必填,新平台不填)
::           twrpinst      zip路径
::           sideload      zip路径
::           adbpush       源文件路径           推送后文件名                  [common program program_su](文件类型,可选,默认common)


@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%


:MTKCLIENT
SETLOCAL
set logger=write.bat-mtkclient
::接收变量
set parname=%var2%& set imgpath=%var3%
call log %logger% I 接收变量:parname:%parname%.imgpath:%imgpath%
:MTKCLIENT-1
if not exist %imgpath% ECHOC {%c_e%}找不到%imgpath%{%c_i%}{\n}& call log %logger% F 找不到%imgpath%& goto FATAL
for %%a in ("%imgpath%") do set imgpath=%%~dpnxa
call log %logger% I mtkclient开始刷入%imgpath%到%parname%
call tool\Windows\mtkclient\mtkclient.bat w %parname% %imgpath%
type tmp\output.txt | find "Wrote " | find " to sector " | find " with sector count " 1>nul 2>nul || ECHOC {%c_e%}mtkclient刷入%imgpath%到%parname%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E mtkclient刷入%imgpath%到%parname%失败&& pause>nul && ECHO.重试... && goto MTKCLIENT-1
call log %logger% I mtkclient刷入%imgpath%到%parname%完成
ENDLOCAL
goto :eof


:SPFLASH
SETLOCAL
set logger=write.bat-spflash
::接收变量
set script=%var2%& set mode=%var3%& set da=%var4%
call log %logger% I 接收变量:script:%script%.mode:%mode%.da:%da%
:SPFLASH-1
if not exist %script% ECHOC {%c_e%}找不到%script%{%c_i%}{\n}& call log %logger% F 找不到%script%& goto FATAL
::自动选择spflash版本
for %%i in ("%script%") do set var=%%~xi
if "%var%"==".xml" (goto SPFLASH-NEW) else (goto SPFLASH-OLD)
:SPFLASH-OLD
call log %logger% I 使用旧平台方案
set var=
for /f "tokens=2 delims= " %%i in ('type %script% ^| find "platform: "') do set var=%%i
if not "%var:~0,2%"=="MT" ECHOC {%c_e%}识别scatter处理器类型失败.{%c_i%}{\n}& call log %logger% F 识别scatter处理器类型失败& goto FATAL
call log %logger% I scatter处理器类型:%var%
set spflashver=
if exist tool\Windows\spflash\5.1728\platform.xml type tool\Windows\spflash\5.1728\platform.xml | find "platform name=" | find "%var%" 1>nul 2>nul && set spflashver=5.1728
if exist tool\Windows\spflash\5.1932\platform.xml type tool\Windows\spflash\5.1932\platform.xml | find "platform name=" | find "%var%" 1>nul 2>nul && set spflashver=5.1932
if exist tool\Windows\spflash\5.2032\platform.xml type tool\Windows\spflash\5.2032\platform.xml | find "platform name=" | find "%var%" 1>nul 2>nul && set spflashver=5.2032
if exist tool\Windows\spflash\5.2048\platform.xml type tool\Windows\spflash\5.2048\platform.xml | find "platform name=" | find "%var%" 1>nul 2>nul && set spflashver=5.2048
if exist tool\Windows\spflash\5.2316\platform.xml type tool\Windows\spflash\5.2316\platform.xml | find "platform name=" | find "%var%" 1>nul 2>nul && set spflashver=5.2316
if "%spflashver%"=="" ECHOC {%c_e%}找不到合适的spflash版本.{%c_i%}{\n}& call log %logger% F 找不到合适的spflash版本& goto FATAL
call log %logger% I 使用spflash版本:%spflashver%
::检查da
if "%da%"=="auto" set da=tool\Windows\spflash\%spflashver%\MTK_AllInOne_DA.bin
if not exist %da% ECHOC {%c_e%}找不到%da%{%c_i%}{\n}& call log %logger% F 找不到%da%& goto FATAL
call log %logger% I 使用da:%da%
::开始刷机
:SPFLASH-OLD-1
call log %logger% I 开始spflash刷入
tool\Windows\spflash\%spflashver%\flash_tool.exe -r -s %script% -c %mode% -d %da% -t auto --disable_storage_life_cycle_check 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "All command exec done!" "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}spflash刷入失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E spflash刷入失败&& pause>nul && ECHO.重试... && goto SPFLASH-OLD-1
goto SPFLASH-DONE
:SPFLASH-NEW
call log %logger% I 使用新平台方案
call log %logger% I 开始spflash刷入
tool\Windows\spflash\6.2316\SPFlashToolV6.exe -r -f %script% -c %mode% -t auto --disable_storage_life_cycle_check 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "All command exec done!" "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}spflash刷入失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E spflash刷入失败&& pause>nul && ECHO.重试... && goto SPFLASH-NEW
goto SPFLASH-DONE
:SPFLASH-DONE
call log %logger% I spflash刷入完成
ENDLOCAL
goto :eof


:SPRDBOOT
SETLOCAL
set logger=write.bat-sprdboot
::接收变量
set port=%var2%& set pac=%var3%
call log %logger% I 接收变量:port:%port%.pac:%pac%
:SPRDBOOT-1
if not exist %pac% ECHOC {%c_e%}找不到%pac%{%c_i%}{\n}& call log %logger% F 找不到%pac%& goto FATAL
if exist tmp\output.txt del tmp\output.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}删除tmp\output.txt失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 删除tmp\output.txt失败& pause>nul & ECHO.重试... & goto SPRDBOOT-1
::启动监控脚本
call log %logger% I 启动监控脚本
echo.@ECHO OFF>tmp\cmd.bat
echo.TITLE BFF - 展讯boot模式刷机监控脚本>>tmp\cmd.bat
echo.ECHO.此脚本为BFF的展讯boot模式刷机监控脚本, 用于监控刷机状态, 刷机完成后会自动退出.>>tmp\cmd.bat
echo.ECHO.等待刷机开始...>>tmp\cmd.bat
echo.:START-1|find "START" 1>>tmp\cmd.bat
echo.if not exist tmp\output.txt goto START-1|find "START" 1>>tmp\cmd.bat
echo.ECHO.刷机已开始. 等待刷机成功...>>tmp\cmd.bat
echo.:START-2|find "START" 1>>tmp\cmd.bat
echo.find "DownLoad Passed" "tmp\output.txt" 1^>nul 2^>nul ^|^| goto START-2|find "START" 1>>tmp\cmd.bat
echo.ECHO.刷机成功. 结束CmdDloader.exe...>>tmp\cmd.bat
echo.taskkill /f /im CmdDloader.exe>>tmp\cmd.bat
echo.EXIT>>tmp\cmd.bat
start /min tmp\cmd.bat
TIMEOUT /T 1 /NOBREAK>nul
::开始刷机
call log %logger% I 开始展讯boot模式刷机.刷机结束前日志存储在bin\tmp\output.txt
CmdDloader.exe -pac %pac% -port %port% 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "DownLoad Passed" "tmp\output.txt" 1>nul 2>nul && goto SPRDBOOT-DONE
ECHOC {%c_e%}展讯boot模式刷机失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 展讯boot模式刷机失败& pause>nul & ECHO.重试... & goto SPRDBOOT-1
:SPRDBOOT-DONE
call log %logger% I 展讯boot模式刷机成功
ENDLOCAL
goto :eof


:ADBPUSH
SETLOCAL
set logger=write.bat-adbpush
::接收变量
set filepath=%var2%& set pushname_full=%var3%& set mode=%var4%
call log %logger% I 接收变量:filepath:%filepath%.pushname_full:%pushname_full%.mode:%mode%
:ADBPUSH-1
::检查是否存在
if not exist %filepath% ECHOC {%c_e%}找不到%filepath%{%c_i%}{\n}& call log %logger% F 找不到%filepath%& goto FATAL
::获取文件名(不包括扩展名)
for %%i in ("%pushname_full%") do set pushname=%%~ni
::获取文件扩展名
for %%i in ("%pushname_full%") do set var=%%~xi
set pushname_ext=%var:~1,999%
::计算文件大小(b)
for /f "tokens=2 delims= " %%i in ('busybox.exe stat -t %filepath%') do set filesize_b=%%i
call log %logger% I %filepath%大小为%filesize_b%b
::检查设备模式
call chkdev all 1>nul
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" ECHOC {%c_e%}设备模式错误. {%c_i%}请将设备进入系统或Recovery模式. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 设备模式错误& pause>nul & ECHO.重试... & goto ADBPUSH-1)
goto ADBPUSH-%chkdev__all__mode%
:ADBPUSH-SYSTEM
::系统下分两种:普通推sdcard,程序推data/local/tmp
::无论哪种都需要首先推送到sdcard
set pushfolder=./sdcard
call log %logger% I 推送%filepath%到%pushfolder%/%pushname_full%
adb.exe push %filepath% %pushfolder%/%pushname_full% 1>>%logfile% 2>&1 || ECHOC {%c_e%}推送%filepath%到%pushfolder%/%pushname_full%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 推送%filepath%到%pushfolder%/%pushname_full%失败&& pause>nul && ECHO.重试... && goto ADBPUSH-SYSTEM
call log %logger% I 检查%pushfolder%/%pushname_full%大小
adb.exe shell stat -t %pushfolder%/%pushname_full% 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}获取%pushfolder%/%pushname_full%大小失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 获取%pushfolder%/%pushname_full%大小失败&& pause>nul && ECHO.重试... && goto ADBPUSH-SYSTEM
set filesize_pushed_b=
for /f "tokens=2 delims= " %%i in (tmp\output.txt) do set filesize_pushed_b=%%i
call log %logger% I %pushfolder%/%pushname_full%大小为%filesize_pushed_b%b
if not "%filesize_b%"=="%filesize_pushed_b%" ECHOC {%c_e%}已推送文件大小%filesize_pushed_b%b和原文件大小%filesize_b%b不一致. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 已推送文件大小%filesize_pushed_b%b和原文件大小%filesize_b%b不一致&& pause>nul && ECHO.重试... && goto ADBPUSH-SYSTEM
if "%mode:~0,7%"=="program" (
    ::对于程序要移动到./data/local/tmp以便执行
    set pushfolder=./data/local/tmp
    call log %logger% I 移动./sdcard/%pushname_full%到./data/local/tmp
    adb.exe shell mv -f ./sdcard/%pushname_full% ./data/local/tmp 1>>%logfile% 2>&1 || ECHOC {%c_e%}移动./sdcard/%pushname_full%到./data/local/tmp失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 移动./sdcard/%pushname_full%到./data/local/tmp失败&& pause>nul && ECHO.重试... && goto ADBPUSH-SYSTEM)
if not "%mode%"=="program_su" goto ADBPUSH-DONE
:ADBPUSH-SYSTEM-1
::对于需要授权的程序则授权
ECHOC {%c_we%}正在申请Root权限. 请注意手机提示. 或在Root权限管理页面手动授权Shell...{%c_i%}{\n}& call log %logger% I 检查Root权限
echo.su>tmp\cmd.txt & echo.whoami>>tmp\cmd.txt
adb.exe shell < tmp\cmd.txt 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}检查用户失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E 检查用户失败失败&& pause>nul && ECHO.重试... && goto ADBPUSH-SYSTEM-1
type tmp\output.txt>>%logfile%
for /f %%a in (tmp\output.txt) do (if not "%%a"=="root" ECHOC {%c_e%}检查Root权限失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 检查Root权限失败& pause>nul & ECHO.重试... & goto ADBPUSH-SYSTEM-1)
call log %logger% I 授权%pushfolder%/%pushname_full%
echo.su>tmp\cmd.txt & echo.chmod +x %pushfolder%/%pushname_full%>>tmp\cmd.txt
adb.exe shell < tmp\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}授权%pushfolder%/%pushname_full%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 授权%pushfolder%/%pushname_full%失败&& pause>nul && ECHO.重试... && goto ADBPUSH-SYSTEM-1
goto ADBPUSH-DONE
::Recovery下
:ADBPUSH-RECOVERY
call log %logger% I 检查Root权限
adb.exe shell whoami 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}检查用户失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E 检查用户失败失败&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY
type tmp\output.txt>>%logfile%
for /f %%a in (tmp\output.txt) do (if not "%%a"=="root" ECHOC {%c_e%}检查Root权限失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 检查Root权限失败& pause>nul & ECHO.重试... & goto ADBPUSH-RECOVERY)
if "%mode:~0,7%"=="program" goto ADBPUSH-RECOVERY-1
goto ADBPUSH-RECOVERY-2
::如果是程序直接推根目录
:ADBPUSH-RECOVERY-1
set pushfolder=.
call log %logger% I 推送%filepath%到%pushfolder%/%pushname_full%
adb.exe push %filepath% %pushfolder%/%pushname_full% 1>>%logfile% 2>&1 || ECHOC {%c_e%}推送%filepath%到%pushfolder%/%pushname_full%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 推送%filepath%到%pushfolder%/%pushname_full%失败&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY-1
call log %logger% I 检查%pushfolder%/%pushname_full%大小
adb.exe shell stat -t %pushfolder%/%pushname_full% 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}获取%pushfolder%/%pushname_full%大小失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 获取%pushfolder%/%pushname_full%大小失败&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY-1
set filesize_pushed_b=
for /f "tokens=2 delims= " %%i in (tmp\output.txt) do set filesize_pushed_b=%%i
call log %logger% I %pushfolder%/%pushname_full%大小为%filesize_pushed_b%b
if not "%filesize_b%"=="%filesize_pushed_b%" ECHOC {%c_e%}已推送文件大小%filesize_pushed_b%b和原文件大小%filesize_b%b不一致. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 已推送文件大小%filesize_pushed_b%b和原文件大小%filesize_b%b不一致&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY-1
if "%mode%"=="program_su" (
    call log %logger% I 授权%pushfolder%/%pushname_full%
    adb.exe shell chmod +x %pushfolder%/%pushname_full% || ECHOC {%c_e%}授权%pushfolder%/%pushname_full%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 授权%pushfolder%/%pushname_full%失败&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY-1)
goto ADBPUSH-DONE
::推普通文件
::先尝试./tmp
:ADBPUSH-RECOVERY-2
set pushfolder=./tmp
call log %logger% I 尝试删除已有%pushfolder%/%pushname_full%.若文件不存在则报错属于正常现象
adb.exe shell rm %pushfolder%/%pushname_full% 1>>%logfile% 2>&1
call log %logger% I 检查./tmp
adb.exe shell df -a -k 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}检查挂载失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E 检查挂载失败&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY-2
type tmp\output.txt>>%logfile%
busybox.exe sed -i "s/$/& /g" tmp\output.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}sed处理tmp\output.txt失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E sed处理tmp\output.txt失败&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY-2
set availsize=& set var=& set num=4
for /f "tokens=6 delims= " %%a in ('find " /tmp " "tmp\output.txt"') do set var=%%a
if "%var%"=="" set /a num+=-1
for /f "tokens=%num% delims= " %%i in ('find " /tmp " "tmp\output.txt"') do set availsize=%%i
if "%availsize%"=="" call log %logger% W ./tmp未挂载& goto ADBPUSH-RECOVERY-4
call calc kb2b availsize_b nodec %availsize%
call log %logger% I ./tmp可用空间为%availsize_b%b
for /f %%a in ('numcomp.exe %availsize_b% %filesize_b%') do (if "%%a"=="less" call log %logger% W ./tmp空间不足& goto ADBPUSH-RECOVERY-4)
adb.exe shell mkdir -p ./tmp/bff-test 1>>%logfile% 2>&1 || call log %logger% W 创建./tmp/bff-test失败&& goto ADBPUSH-RECOVERY-4
adb.exe shell ls -l ./tmp | find " bff-test" 1>nul 2>nul || call log %logger% W 找不到./tmp/bff-test&& goto ADBPUSH-RECOVERY-4
adb.exe shell rm -rf ./tmp/bff-test 1>>%logfile% 2>&1 || call log %logger% W 删除./tmp/bff-test失败&& goto ADBPUSH-RECOVERY-4
call log %logger% I 检查./tmp完毕.开始推送%filepath%到%pushfolder%/%pushname_full%
:ADBPUSH-RECOVERY-3
adb.exe push %filepath% %pushfolder%/%pushname_full% 1>>%logfile% 2>&1 || ECHOC {%c_e%}推送%filepath%到%pushfolder%/%pushname_full%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 推送%filepath%到%pushfolder%/%pushname_full%失败&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY-3
call log %logger% I 检查%pushfolder%/%pushname_full%大小
adb.exe shell stat -t %pushfolder%/%pushname_full% 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}获取%pushfolder%/%pushname_full%大小失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 获取%pushfolder%/%pushname_full%大小失败&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY-3
set filesize_pushed_b=
for /f "tokens=2 delims= " %%i in (tmp\output.txt) do set filesize_pushed_b=%%i
call log %logger% I %pushfolder%/%pushname_full%大小为%filesize_pushed_b%b
if not "%filesize_b%"=="%filesize_pushed_b%" ECHOC {%c_e%}已推送文件大小%filesize_pushed_b%b和原文件大小%filesize_b%b不一致. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 已推送文件大小%filesize_pushed_b%b和原文件大小%filesize_b%b不一致&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY-3
goto ADBPUSH-DONE
::再尝试./data. data是最后的选项.
:ADBPUSH-RECOVERY-4
set pushfolder=./data
call log %logger% I 尝试删除已有%pushfolder%/%pushname_full%.若文件不存在则报错属于正常现象
adb.exe shell rm %pushfolder%/%pushname_full% 1>>%logfile% 2>&1
call log %logger% I 检查./data
adb.exe shell df -a -k 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}检查挂载失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E 检查挂载失败&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY-4
type tmp\output.txt>>%logfile%
busybox.exe sed -i "s/$/& /g" tmp\output.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}sed处理tmp\output.txt失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E sed处理tmp\output.txt失败&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY-4
set availsize=& set var=& set num=4
for /f "tokens=6 delims= " %%a in ('find " /data " "tmp\output.txt"') do set var=%%a
if "%var%"=="" set /a num+=-1
for /f "tokens=%num% delims= " %%i in ('find " /data " "tmp\output.txt"') do set availsize=%%i
if "%availsize%"=="" ECHOC {%c_e%}./data未挂载. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% W ./data未挂载& pause>nul & ECHO.重试... & goto ADBPUSH-RECOVERY-4
call calc kb2b availsize_b nodec %availsize%
call log %logger% I ./data可用空间为%availsize_b%b
for /f %%a in ('numcomp.exe %availsize_b% %filesize_b%') do (if "%%a"=="less" ECHOC {%c_e%}./data空间不足. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% W ./data空间不足& pause>nul & ECHO.重试... & goto ADBPUSH-RECOVERY-4)
adb.exe shell mkdir -p ./data/bff-test 1>>%logfile% 2>&1 || ECHOC {%c_e%}./data读写测试失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% W 创建./data/bff-test失败&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY-4
adb.exe shell ls -l ./data | find " bff-test" 1>nul 2>nul || ECHOC {%c_e%}./data读写测试失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% W 找不到./data/bff-test&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY-4
adb.exe shell rm -rf ./data/bff-test 1>>%logfile% 2>&1 || ECHOC {%c_e%}./data读写测试失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% W 删除./data/bff-test失败&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY-4
call log %logger% I 检查./data完毕.开始推送%filepath%到%pushfolder%/%pushname_full%
:ADBPUSH-RECOVERY-5
adb.exe push %filepath% %pushfolder%/%pushname_full% 1>>%logfile% 2>&1 || ECHOC {%c_e%}推送%filepath%到%pushfolder%/%pushname_full%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 推送%filepath%到%pushfolder%/%pushname_full%失败&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY-5
call log %logger% I 检查%pushfolder%/%pushname_full%大小
adb.exe shell stat -t %pushfolder%/%pushname_full% 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}获取%pushfolder%/%pushname_full%大小失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 获取%pushfolder%/%pushname_full%大小失败&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY-5
set filesize_pushed_b=
for /f "tokens=2 delims= " %%i in (tmp\output.txt) do set filesize_pushed_b=%%i
call log %logger% I %pushfolder%/%pushname_full%大小为%filesize_pushed_b%b
if not "%filesize_b%"=="%filesize_pushed_b%" ECHOC {%c_e%}已推送文件大小%filesize_pushed_b%b和原文件大小%filesize_b%b不一致. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 已推送文件大小%filesize_pushed_b%b和原文件大小%filesize_b%b不一致&& pause>nul && ECHO.重试... && goto ADBPUSH-RECOVERY-5
goto ADBPUSH-DONE
:ADBPUSH-DONE
call log %logger% I ADB推送完毕.文件路径:%pushfolder%/%pushname_full%
ENDLOCAL & set write__adbpush__filepath=%pushfolder%/%pushname_full%& set write__adbpush__filename_full=%pushname_full%& set write__adbpush__filename=%pushname%& set write__adbpush__folder=%pushfolder%& set write__adbpush__ext=%pushname_ext%
goto :eof


:SIDELOAD
SETLOCAL
set logger=write.bat-sideload
::接收变量
set zippath=%var2%
call log %logger% I 接收变量:zippath:%zippath%
:SIDELOAD-1
::检查是否存在
if not exist %zippath% ECHOC {%c_e%}找不到%zippath%{%c_i%}{\n}& call log %logger% F 找不到%zippath%& goto FATAL
::安装
call reboot recovery sideload rechk 3
call log %logger% I 安装%zippath%
adb.exe sideload %zippath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}安装%zippath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 安装%zippath%失败&& pause>nul && ECHO.重试... && goto SIDELOAD-1
ENDLOCAL
goto :eof


:TWRPINST
SETLOCAL
set logger=write.bat-twrpinst
::接收变量
set zippath=%var2%
call log %logger% I 接收变量:zippath:%zippath%
:TWRPINST-1
::检查是否存在
if not exist %zippath% ECHOC {%c_e%}找不到%zippath%{%c_i%}{\n}& call log %logger% F 找不到%zippath%& goto FATAL
::推送
call log %logger% I 推送%zippath%
call write adbpush %zippath% bff.zip common
::adb.exe push %zippath% ./tmp/bff.zip 1>>%logfile% 2>&1 || ECHOC {%c_e%}推送%zippath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 推送%zippath%失败&& pause>nul && ECHO.重试... && goto TWRPINST-1
::安装
call log %logger% I 安装%write__adbpush__filepath%
adb.exe shell twrp install %write__adbpush__filepath% 1>tmp\output.txt 2>&1 || type tmp\output.txt>>%logfile% && call log %logger% E 安装%zippath%失败&& ECHOC {%c_e%}安装%zippath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& pause>nul && ECHO.重试... && goto TWRPINST-1
type tmp\output.txt>>%logfile%
find "zip" "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}安装%zippath%失败, TWRP未执行命令. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 安装%zippath%失败,TWRP未执行命令&& pause>nul && ECHO.重试... && goto TWRPINST-1
adb.exe shell rm %write__adbpush__filepath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}删除%write__adbpush__filepath%失败{%c_i%}{\n}&& call log %logger% E 删除%write__adbpush__filepath%失败
ENDLOCAL
goto :eof


:EDL
ECHOC {%c_w%}警告: write模块的edl参数已更新为qcedlxml, 请联系脚本作者尽快更改调用方法.{%c_i%}{\n}
goto QCEDLXML


:QCEDLXML
SETLOCAL
set logger=write.bat-qcedlxml
::接收变量
set port=%var2%& set memory=%var3%& set searchpath=%var4%& set xml=%var5%& set fh=%var6%
call log %logger% I 接收变量:port:%port%.memory:%memory%.searchpath:%searchpath%.xml:%xml%.fh:%fh%
:QCEDLXML-1
::检查searchpath和firehose是否存在
if not exist %searchpath% ECHOC {%c_e%}找不到%searchpath%{%c_i%}{\n}& call log %logger% F 找不到%searchpath%& goto FATAL
if not "%fh%"=="" (if not exist %fh% ECHOC {%c_e%}找不到%fh%{%c_i%}{\n}& call log %logger% F 找不到%fh%& goto FATAL)
::处理xml
echo.%xml%>tmp\output.txt
for /f %%a in ('busybox.exe sed "s/\//,/g" tmp\output.txt') do set xml=%%a
call log %logger% I xml参数更新为:
echo.%xml%>>%logfile%
::发送引导
if not "%fh%"=="" (
    call log %logger% I 正在发送引导
    QSaharaServer.exe -p \\.\COM%port% -s 13:%fh% 1>>%logfile% 2>&1 || ECHOC {%c_e%}发送引导失败.{%c_h%}按任意键继续...{%c_i%}{\n}&& call log %logger% E 发送引导失败&& pause>nul)
::开始刷机
call log %logger% I 正在9008刷入
fh_loader.exe --port=\\.\COM%port% --memoryname=%memory% --search_path=%searchpath% --sendxml=%xml% --noprompt 1>>%logfile% 2>&1 || ECHOC {%c_e%}9008刷入失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 9008刷入失败&& move /Y port_trace.txt log 1>>%logfile% 2>&1 && pause>nul && ECHO.重试... && goto QCEDLXML-1
::--showpercentagecomplete --reset --noprompt --zlpawarehost=1 --testvipimpact
move /Y port_trace.txt log 1>>%logfile% 2>&1
call log %logger% I 9008刷入完成
ENDLOCAL
goto :eof


:QCEDLSINGLE
SETLOCAL
set logger=write.bat-qcedlsingle
::接收变量
set port=%var2%& set memory=%var3%& set parname=%var4%& set imgpath=%var5%& set fh=%var6%
if "%memory%"=="UFS" set memory=ufs& ECHOC {%c_w%}警告: emmc和ufs参数请全部使用小写. 请联系脚本作者尽快更改.{%c_i%}{\n}
if "%memory%"=="Ufs" set memory=ufs& ECHOC {%c_w%}警告: emmc和ufs参数请全部使用小写. 请联系脚本作者尽快更改.{%c_i%}{\n}
if "%memory%"=="EMMC" set memory=emmc& ECHOC {%c_w%}警告: emmc和ufs参数请全部使用小写. 请联系脚本作者尽快更改.{%c_i%}{\n}
if "%memory%"=="Emmc" set memory=emmc& ECHOC {%c_w%}警告: emmc和ufs参数请全部使用小写. 请联系脚本作者尽快更改.{%c_i%}{\n}
call log %logger% I 接收变量:port:%port%.memory:%memory%.parname:%parname%.imgpath:%imgpath%.fh:%fh%
:QCEDLSINGLE-1
::检查img和firehose是否存在
if not exist %imgpath% ECHOC {%c_e%}找不到%imgpath%{%c_i%}{\n}& call log %logger% F 找不到%imgpath%& goto FATAL
if not "%fh%"=="" (if not exist %fh% ECHOC {%c_e%}找不到%fh%{%c_i%}{\n}& call log %logger% F 找不到%fh%& goto FATAL)
::发送引导
if not "%fh%"=="" (
    call log %logger% I 正在发送引导
    QSaharaServer.exe -p \\.\COM%port% -s 13:%fh% 1>>%logfile% 2>&1 || ECHOC {%c_e%}发送引导失败.{%c_h%}按任意键继续...{%c_i%}{\n}&& call log %logger% E 发送引导失败&& pause>nul)
::回读, 解析分区表文件和刷入分区
if exist tmp\ptanalyse rd /s /q tmp\ptanalyse 1>nul
md tmp\ptanalyse
set num=0
:QCEDLSINGLE-2
call log %logger% I 正在9008回读分区表%num%
cd tmp\ptanalyse || ECHOC {%c_e%}进入tmp\ptanalyse失败.{%c_i%}{\n}&& call log %logger% F 进入tmp\ptanalyse失败&& goto FATAL
set var=34
if "%memory%"=="ufs" set var=6
fh_loader.exe --port=\\.\COM%port% --memoryname=%memory% --sendimage=gpt_%num%.bin --lun=%num% --start_sector=0 --num_sectors=%var% --convertprogram2read --noprompt 1>>%logfile% 2>&1 || ECHOC {%c_e%}9008回读分区表%num%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 9008回读分区表%num%失败&& move /Y port_trace.txt %framwork_workspace%\log 1>nul && cd /d %framwork_workspace% && pause>nul && ECHO.重试... && goto QCEDLSINGLE-1
move /Y port_trace.txt %framwork_workspace%\log 1>>%logfile% 2>&1
cd /d %framwork_workspace% || ECHOC {%c_e%}进入%framwork_workspace%失败.{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
call log %logger% I 9008回读分区表%num%完成
call log %logger% I 解析分区表%num%
ptanalyzer.exe tmp\ptanalyse\gpt_%num%.bin gpt%memory%read 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "Analysis completed." "tmp\output.txt" 1>nul 2>nul && goto QCEDLSINGLE-3
find "[Total] 0" "tmp\output.txt" 1>nul 2>nul && goto QCEDLSINGLE-PARNOTFOUND
ECHOC {%c_e%}解析分区表%num%失败{%c_e%}& call log %logger% F 解析分区表%num%失败& goto FATAL
:QCEDLSINGLE-3
set parsizesec=
for /f "tokens=3,5 delims=[] " %%a in ('type tmp\output.txt ^| find "] %parname% "') do set parstartsec=%%a& set parsizesec=%%b
if "%parsizesec%"=="" set /a num+=1& goto QCEDLSINGLE-2
call log %logger% I 正在9008刷入%imgpath%.lun:%num%.起始扇区:%parstartsec%.扇区数目:%parsizesec%
fh_loader.exe --port=\\.\COM%port% --search_path=%framwork_workspace% --sendimage=%imgpath% --lun=%num% --memoryname=%memory% --start_sector=%parstartsec% --num_sectors=%parsizesec% --noprompt 1>>%logfile% 2>&1 || ECHOC {%c_e%}9008刷入失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 9008刷入失败&& move /Y port_trace.txt log 1>>%logfile% 2>&1 && pause>nul && ECHO.重试... && goto QCEDLSINGLE-1
move /Y port_trace.txt log 1>>%logfile% 2>&1
call log %logger% I 9008刷入完成
ENDLOCAL
goto :eof
:QCEDLSINGLE-PARNOTFOUND
ECHOC {%c_e%}找不到分区%parname%{%c_e%}& call log %logger% F 找不到分区%parname%& goto FATAL


:SYSTEM
SETLOCAL
set logger=write.bat-system
set target=system
goto ADBDD


:RECOVERY
SETLOCAL
set logger=write.bat-recovery
set target=recovery
goto ADBDD


:ADBDD
::接收变量
set parname=%var2%& set imgpath=%var3%
call log %logger% I 接收变量:parname:%parname%.imgpath:%imgpath%
:ADBDD-1
::检查文件
if not exist %imgpath% ECHOC {%c_e%}找不到%imgpath%{%c_i%}{\n}& call log %logger% F 找不到%imgpath%& goto FATAL
::系统下要检查Root
if "%target%"=="system" (
    call log %logger% I 开始检查Root
    echo.su>tmp\cmd.txt& echo.exit>>tmp\cmd.txt& echo.exit>>tmp\cmd.txt
    adb.exe shell < tmp\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}获取Root失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 获取Root失败&& pause>nul && ECHO.重试... && goto ADBDD-1)
::推送
call log %logger% I 开始推送%imgpath%
call write adbpush %imgpath% %parname%.img common
::adb.exe push %imgpath% %target%/%parname%.img 1>>%logfile% 2>&1 || ECHOC {%c_e%}推送%imgpath%到%target%/%parname%.img失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 推送%imgpath%到%target%/%parname%.img失败&& pause>nul && ECHO.重试... && goto ADBDD-1
::获取分区路径
call info par %parname%
::刷入和清理
if "%target%"=="system" echo.su>tmp\cmd.txt& echo.dd if=%write__adbpush__filepath% of=%info__par__path% >>tmp\cmd.txt& echo.rm %write__adbpush__filepath%>>tmp\cmd.txt
if "%target%"=="recovery" echo.dd if=%write__adbpush__filepath% of=%info__par__path% >tmp\cmd.txt& echo.rm %write__adbpush__filepath%>>tmp\cmd.txt
call log %logger% I 开始刷入%write__adbpush__filepath%到%info__par__path%
adb.exe shell < tmp\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}刷入%write__adbpush__filepath%到%info__par__path%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 刷入%write__adbpush__filepath%到%info__par__path%失败&& pause>nul && ECHO.重试... && goto ADBDD-1
ENDLOCAL
goto :eof


:FASTBOOT
SETLOCAL
set logger=write.bat-fastboot
::接收变量
set parname=%var2%& set imgpath=%var3%
call log %logger% I 接收变量:parname:%parname%.imgpath:%imgpath%
:FASTBOOT-1
::检查文件
if not exist %imgpath% ECHOC {%c_e%}找不到%imgpath%{%c_i%}{\n}& call log %logger% F 找不到%imgpath%& goto FATAL
::刷入
call log %logger% I 开始刷入%imgpath%到%parname%
fastboot.exe flash %parname% %imgpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}刷入%imgpath%到%parname%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 刷入%imgpath%到%parname%失败&& pause>nul && ECHO.重试... && goto FASTBOOT-1
ENDLOCAL
goto :eof


:FASTBOOTBOOT
SETLOCAL
set logger=write.bat-fastbootboot
::接收变量
set imgpath=%var2%
call log %logger% I 接收变量:imgpath:%imgpath%
:FASTBOOTBOOT-1
::检查文件
if not exist %imgpath% ECHOC {%c_e%}找不到%imgpath%{%c_i%}{\n}& call log %logger% F 找不到%imgpath%& goto FATAL
::临时启动
call log %logger% I 启动%imgpath%
fastboot.exe boot %imgpath% 1>>%logfile% 2>&1 && goto FASTBOOTBOOT-DONE
ECHOC {%c_e%}启动%imgpath%失败{%c_i%}{\n}& call log %logger% E 启动%imgpath%失败
ECHO.1.设备没有进入目标模式, 重新尝试临时启动
ECHO.2.脚本判断有误, 设备已进入目标模式, 可以继续
call choice common [1][2]
if "%choice%"=="2" goto FASTBOOTBOOT-DONE
call chkdev fastboot
ECHO.重新尝试临时启动...
goto FASTBOOTBOOT-1
:FASTBOOTBOOT-DONE
ENDLOCAL
goto :eof








:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}抱歉, 脚本遇到问题, 无法继续运行. 请查看日志. {%c_h%}按任意键退出...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.抱歉, 脚本遇到问题, 无法继续运行. 按任意键退出...& pause>nul & EXIT)

