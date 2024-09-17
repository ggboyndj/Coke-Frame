::call par mk            磁盘路径  分区名                  类型            start  end  编号(可选,默认为首个可用的)
::         rm            磁盘路径  [name:xxx或numb:xx]
::         setmaxparnum  磁盘路径  目标分区数(可选,默认128)
::         bakpartable   磁盘路径  保存路径(包括文件名)      noprompt(可选)
::         recpartable   磁盘路径  文件路径


@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%


:RECPARTABLE
SETLOCAL
set logger=par.bat-recpartable
set diskpath=%var2%& set filepath=%var3%
call log %logger% I 接收变量:diskpath:%diskpath%.filepath:%filepath%
:RECPARTABLE-1
if not exist %filepath% ECHOC {%c_e%}找不到%filepath%{%c_i%}{\n}& call log %logger% F 找不到%filepath%& goto FATAL
call framwork adbpre sgdisk
call write adbpush %filepath% bff_sgdiskpartable.bak common
::adb.exe push %filepath% ./bff_sgdiskpartable.bak 1>>%logfile% 2>&1 || ECHOC {%c_e%}推送分区表失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 推送分区表失败&& pause>nul && ECHO.重试... && goto RECPARTABLE-1
adb.exe shell ./sgdisk -l %write__adbpush__filepath% %diskpath% 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "The operation has completed successfully." "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}恢复分区表失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 恢复分区表失败&& pause>nul && ECHO.重试... && goto RECPARTABLE-1
call log %logger% I 恢复分区表完成
ENDLOCAL
goto :eof


:BAKPARTABLE
SETLOCAL
set logger=par.bat-bakpartable
set diskpath=%var2%& set filepath=%var3%& set mode=%var4%
call log %logger% I 接收变量:diskpath:%diskpath%.filepath:%filepath%.mode:%mode%
:BAKPARTABLE-1
if not "%mode%"=="noprompt" (if exist %filepath% ECHOC {%c_w%}已存在%filepath%, 继续将覆盖此文件. {%c_h%}按任意键继续...{%c_i%}{\n}& call log %logger% W 已存在%filepath%.继续将覆盖此文件& pause>nul & ECHO.继续...)
call framwork adbpre sgdisk
adb.exe shell ./sgdisk -b ./bff_sgdiskpartable.bak %diskpath% 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "The operation has completed successfully." "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}备份分区表失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份分区表失败&& pause>nul && ECHO.重试... && goto BAKPARTABLE-1
adb.exe pull ./bff_sgdiskpartable.bak %filepath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}复制分区表失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 复制分区表失败&& pause>nul && ECHO.重试... && goto BAKPARTABLE-1
call log %logger% I 备份分区表完成
ENDLOCAL
goto :eof


:MK
SETLOCAL
set logger=par.bat-mk
set diskpath=%var2%& set parname=%var3%& set partype=%var4%& set parstart=%var5%& set parend=%var6%& set parnum=%var7%
call log %logger% I 接收变量:parname:%parname%.partype:%partype%.parstart:%parstart%.parend:%parend%.parnum:%parnum%
call framwork adbpre sgdisk
if not "%parnum%"=="" goto MK-3
:MK-1
call log %logger% I 开始获取可用的分区编号
adb.exe shell ./sgdisk -p %diskpath% 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}获取可用的分区编号失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E 获取可用的分区编号失败&& pause>nul && ECHO.重试... && goto MK-1
type tmp\output.txt>>%logfile%
if exist tmp\output2.txt del tmp\output2.txt 1>nul
for /f "tokens=1 delims= " %%i in ('type tmp\output.txt ^| find "  " ^| find /v "Number"') do echo.[%%i]>>tmp\output2.txt
set num=1
:MK-2
find "[%num%]" "tmp\output2.txt" 1>nul 2>nul || set parnum=%num%&& goto MK-3
set /a num+=1& goto MK-2
:MK-3
call log %logger% I 开始读取磁盘扇区大小
call info disk %diskpath%
call calc kb2sec parstart_sec nodec %parstart% %info__disk__secsize%
call calc kb2sec parend_sec nodec %parend% %info__disk__secsize%
:MK-4
call log %logger% I 开始创建分区.目标编号为%parnum%
adb.exe shell ./sgdisk -n %parnum%:%parstart_sec%:%parend_sec% %diskpath% 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "The operation has completed successfully." "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}创建分区失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 创建分区失败&& pause>nul && ECHO.重试... && goto MK-4
:MK-5
call log %logger% I 开始命名分区
adb.exe shell ./sgdisk -c %parnum%:%parname% %diskpath% 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "The operation has completed successfully." "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}命名分区失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 命名分区失败&& pause>nul && ECHO.重试... && goto MK-5
:MK-6
call log %logger% I 开始设置分区类型
adb.exe shell ./sgdisk -t %parnum%:%partype% %diskpath% 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "The operation has completed successfully." "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}设置分区类型失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 设置分区类型失败&& pause>nul && ECHO.重试... && goto MK-6
::call reboot recovery recovery rechk 3
call log %logger% I 创建分区完成
ENDLOCAL
goto :eof


:RM
SETLOCAL
set logger=par.bat-rm
set diskpath=%var2%& set target=%var3%
call log %logger% I 接收变量:diskpath:%diskpath%.target:%target%
call framwork adbpre sgdisk
if "%target:~0,4%"=="numb" set parnum=%target:~5,999%& goto RM-2
:RM-1
call log %logger% I 开始获取分区编号.分区名为%target:~5,999%
call info par %target:~5,999%
set parnum=%info__par__num%
goto RM-2
:RM-2
call log %logger% I 开始删除分区.目标编号为%parnum%
adb.exe shell ./sgdisk -d %parnum% %diskpath% 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "The operation has completed successfully." "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}删除分区失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 删除分区失败&& pause>nul && ECHO.重试... && goto RM-2
::call reboot recovery recovery rechk 3
call log %logger% I 删除分区完成
ENDLOCAL
goto :eof


:SETMAXPARNUM
SETLOCAL
set logger=par.bat-setmaxparnum
set diskpath=%var2%& set target=%var3%
if "%target%"=="" set target=128
call log %logger% I 接收变量:diskpath:%diskpath%.target:%target%
call framwork adbpre sgdisk
:SETMAXPARNUM-1
call log %logger% I 开始设置最大分区数
adb.exe shell ./sgdisk --resize-table=%target% %diskpath% 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "The operation has completed successfully." "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}设置最大分区数失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 设置最大分区数失败&& pause>nul && ECHO.重试... && goto SETMAXPARNUM-1
call log %logger% I 设置最大分区数完成
ENDLOCAL
goto :eof















:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}抱歉, 脚本遇到问题, 无法继续运行. 请查看日志. {%c_h%}按任意键退出...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.抱歉, 脚本遇到问题, 无法继续运行. 按任意键退出...& pause>nul & EXIT)


