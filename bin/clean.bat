::call clean twrpfactoryreset
::           twrpformatdata
::           formatfat32       [name:分区名 path:分区路径]  [卷标(可选,不填则不设置)]
::           formatntfs        [name:分区名 path:分区路径]  [卷标(可选,不填则不设置)]
::           formatexfat       [name:分区名 path:分区路径]  [卷标(可选,不填则不设置)]
::           formatext4        [name:分区名 path:分区路径]  [卷标(可选,不填则不设置)]


@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%


:FORMATEXT4
SETLOCAL
set logger=clean.bat-formatext4
set target=%var2%& set label=%var3%
call log %logger% I 接收变量:target:%target%.label:%label%
call framwork adbpre mke2fs
call framwork adbpre blktool
if "%target:~0,4%"=="name" (goto FORMATEXT4-1) else (goto FORMATEXT4-2)
:FORMATEXT4-1
call info par %target:~5,999%
set parpath=%info__par__path%
goto FORMATEXT4-3
:FORMATEXT4-2
set parpath=%target:~5,999%
goto FORMATEXT4-3
:FORMATEXT4-3
call log %logger% I 尝试卸载%parpath%.若目标分区未挂载则报错属于正常现象
adb.exe shell umount -f -d %parpath% 1>>%logfile% 2>&1
call log %logger% I 开始格式化EXT4.分区路径:%parpath%
set var=
if not "%label%"=="" adb.exe shell ./mke2fs -F -v -t ext4 -L %label% %parpath% 1>>%logfile% 2>&1 || set var=n
if "%label%"=="" adb.exe shell ./mke2fs -F -v -t ext4 %parpath% 1>>%logfile% 2>&1 || set var=n
if "%var%"=="n" ECHOC {%c_e%}格式化EXT4失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 格式化EXT4失败& pause>nul & ECHO.重试... & goto FORMATEXT4-3
call log %logger% I 格式化EXT4完成
ENDLOCAL
goto :eof


:FORMATEXFAT
SETLOCAL
set logger=clean.bat-formatexfat
set target=%var2%& set label=%var3%
call log %logger% I 接收变量:target:%target%.label:%label%
call framwork adbpre mkfs.exfat
call framwork adbpre blktool
if "%target:~0,4%"=="name" (goto FORMATEXFAT-1) else (goto FORMATEXFAT-2)
:FORMATEXFAT-1
call info par %target:~5,999%
set parpath=%info__par__path%& set disksecsize=%info__par__disksecsize%
goto FORMATEXFAT-3
:FORMATEXFAT-2
set parpath=%target:~5,999%
call log %logger% I 开始获取磁盘扇区大小
set disksecsize=
for /f "tokens=2 delims= " %%a in ('adb.exe shell ./blktool -n -p --print-sector-size ^| find "%parpath%"') do set disksecsize=%%a
if "%disksecsize%"=="" ECHOC {%c_e%}获取磁盘扇区大小失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 获取磁盘扇区大小失败& pause>nul & ECHO.重试... & goto FORMATEXFAT-2
goto FORMATEXFAT-3
:FORMATEXFAT-3
call log %logger% I 尝试卸载%parpath%.若目标分区未挂载则报错属于正常现象
adb.exe shell umount -f -d %parpath% 1>>%logfile% 2>&1
call log %logger% I 开始格式化EXFAT.分区路径:%parpath%.磁盘扇区大小:%disksecsize%
set var=
if not "%label%"=="" adb.exe shell ./mkfs.exfat -n %label% %parpath% 1>>%logfile% 2>&1 || set var=n
if "%label%"=="" adb.exe shell ./mkfs.exfat %parpath% 1>>%logfile% 2>&1 || set var=n
if "%var%"=="n" ECHOC {%c_e%}格式化EXFAT失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 格式化EXFAT失败& pause>nul & ECHO.重试... & goto FORMATEXFAT-3
call log %logger% I 格式化EXFAT完成
ENDLOCAL
goto :eof


:FORMATFAT32
SETLOCAL
set logger=clean.bat-formatfat32
set target=%var2%& set label=%var3%
call log %logger% I 接收变量:target:%target%.label:%label%
call framwork adbpre mkfs.fat
call framwork adbpre blktool
if "%target:~0,4%"=="name" (goto FORMATFAT32-1) else (goto FORMATFAT32-2)
:FORMATFAT32-1
call info par %target:~5,999%
set parpath=%info__par__path%& set disksecsize=%info__par__disksecsize%
goto FORMATFAT32-3
:FORMATFAT32-2
set parpath=%target:~5,999%
call log %logger% I 开始获取磁盘扇区大小
set disksecsize=
for /f "tokens=2 delims= " %%a in ('adb.exe shell ./blktool -n -p --print-sector-size ^| find "%parpath%"') do set disksecsize=%%a
if "%disksecsize%"=="" ECHOC {%c_e%}获取磁盘扇区大小失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 获取磁盘扇区大小失败& pause>nul & ECHO.重试... & goto FORMATFAT32-2
goto FORMATFAT32-3
:FORMATFAT32-3
call log %logger% I 尝试卸载%parpath%.若目标分区未挂载则报错属于正常现象
adb.exe shell umount -f -d %parpath% 1>>%logfile% 2>&1
call log %logger% I 开始格式化FAT32.分区路径:%parpath%.磁盘扇区大小:%disksecsize%
set var=
if not "%label%"=="" adb.exe shell ./mkfs.fat -F 32 -n %label% -S %disksecsize% %parpath% 1>>%logfile% 2>&1 || set var=n
if "%label%"=="" adb.exe shell ./mkfs.fat -F 32 -S %disksecsize% %parpath% 1>>%logfile% 2>&1 || set var=n
if "%var%"=="n" ECHOC {%c_e%}格式化FAT32失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 格式化FAT32失败& pause>nul & ECHO.重试... & goto FORMATFAT32-3
call log %logger% I 格式化FAT32完成
ENDLOCAL
goto :eof


:FORMATNTFS
SETLOCAL
set logger=clean.bat-formatntfs
set target=%var2%& set label=%var3%
call log %logger% I 接收变量:target:%target%.label:%label%
call framwork adbpre mkntfs
call framwork adbpre blktool
if "%target:~0,4%"=="name" (goto FORMATNTFS-1) else (goto FORMATNTFS-2)
:FORMATNTFS-1
call info par %target:~5,999%
set parpath=%info__par__path%& set disksecsize=%info__par__disksecsize%
goto FORMATNTFS-3
:FORMATNTFS-2
set parpath=%target:~5,999%
call log %logger% I 开始获取磁盘扇区大小
set disksecsize=
for /f "tokens=2 delims= " %%a in ('adb.exe shell ./blktool -n -p --print-sector-size ^| find "%parpath%"') do set disksecsize=%%a
if "%disksecsize%"=="" ECHOC {%c_e%}获取磁盘扇区大小失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 获取磁盘扇区大小失败& pause>nul & ECHO.重试... & goto FORMATNTFS-2
goto FORMATNTFS-3
:FORMATNTFS-3
call log %logger% I 尝试卸载%parpath%.若目标分区未挂载则报错属于正常现象
adb.exe shell umount -f -d %parpath% 1>>%logfile% 2>&1
call log %logger% I 开始格式化NTFS.分区路径:%parpath%.磁盘扇区大小:%disksecsize%
set var=
if not "%label%"=="" adb.exe shell ./mkntfs -Q -L %label% -s %disksecsize% %parpath% 1>>%logfile% 2>&1 || set var=n
if "%label%"=="" adb.exe shell ./mkntfs -Q -s %disksecsize% %parpath% 1>>%logfile% 2>&1 || set var=n
if "%var%"=="n" ECHOC {%c_e%}格式化NTFS失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 格式化NTFS失败& pause>nul & ECHO.重试... & goto FORMATNTFS-3
call log %logger% I 格式化NTFS完成
ENDLOCAL
goto :eof


:TWRPFACTORYRESET
SETLOCAL
set logger=clean.bat-twrpfactoryreset
call log %logger% I 开始TWRP恢复出厂
:TWRPFACTORYRESET-1
adb.exe shell twrp wipe data 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}TWRP清除Data失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E TWRP清除Data失败&& pause>nul && goto TWRPFACTORYRESET-1
type tmp\output.txt>>%logfile%
find "ata" "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}TWRP清除Data失败, TWRP未执行命令. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E TWRP清除Data失败.TWRP未执行命令&& pause>nul && goto TWRPFACTORYRESET-1
adb.exe shell twrp wipe cache 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}TWRP清除Cache失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E TWRP清除Cache失败&& pause>nul && goto TWRPFACTORYRESET-1
type tmp\output.txt>>%logfile%
find "ache" "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}TWRP清除Cache失败, TWRP未执行命令. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E TWRP清除Cache失败.TWRP未执行命令&& pause>nul && goto TWRPFACTORYRESET-1
adb.exe shell twrp wipe dalvik 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}TWRP清除Dalvik失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E TWRP清除Dalvik失败&& pause>nul && goto TWRPFACTORYRESET-1
type tmp\output.txt>>%logfile%
find "alvik" "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}TWRP清除Dalvik失败, TWRP未执行命令. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E TWRP清除Dalvik失败.TWRP未执行命令&& pause>nul && goto TWRPFACTORYRESET-1
call log %logger% I TWRP恢复出厂完毕
ENDLOCAL
goto :eof


:TWRPFORMATDATA
SETLOCAL
set logger=clean.bat-twrpformatdata
call log %logger% I 开始TWRP格式化Data
:TWRPFORMATDATA-1
adb.exe shell twrp format data 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}TWRP格式化Data失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E TWRP格式化Data失败 && pause>nul && goto TWRPFORMATDATA-1
type tmp\output.txt>>%logfile%
find "ata" "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}TWRP格式化Data失败, TWRP未执行命令. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E TWRP格式化Data失败.TWRP未执行命令&& pause>nul && goto TWRPFORMATDATA-1
call reboot recovery recovery rechk 3
call log %logger% I TWRP格式化Data完毕
ENDLOCAL
goto :eof


