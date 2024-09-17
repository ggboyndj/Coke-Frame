::call clean twrpfactoryreset
::           twrpformatdata
::           formatfat32       [name:������ path:����·��]  [���(��ѡ,����������)]
::           formatntfs        [name:������ path:����·��]  [���(��ѡ,����������)]
::           formatexfat       [name:������ path:����·��]  [���(��ѡ,����������)]
::           formatext4        [name:������ path:����·��]  [���(��ѡ,����������)]


@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%


:FORMATEXT4
SETLOCAL
set logger=clean.bat-formatext4
set target=%var2%& set label=%var3%
call log %logger% I ���ձ���:target:%target%.label:%label%
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
call log %logger% I ����ж��%parpath%.��Ŀ�����δ�����򱨴�������������
adb.exe shell umount -f -d %parpath% 1>>%logfile% 2>&1
call log %logger% I ��ʼ��ʽ��EXT4.����·��:%parpath%
set var=
if not "%label%"=="" adb.exe shell ./mke2fs -F -v -t ext4 -L %label% %parpath% 1>>%logfile% 2>&1 || set var=n
if "%label%"=="" adb.exe shell ./mke2fs -F -v -t ext4 %parpath% 1>>%logfile% 2>&1 || set var=n
if "%var%"=="n" ECHOC {%c_e%}��ʽ��EXT4ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ʽ��EXT4ʧ��& pause>nul & ECHO.����... & goto FORMATEXT4-3
call log %logger% I ��ʽ��EXT4���
ENDLOCAL
goto :eof


:FORMATEXFAT
SETLOCAL
set logger=clean.bat-formatexfat
set target=%var2%& set label=%var3%
call log %logger% I ���ձ���:target:%target%.label:%label%
call framwork adbpre mkfs.exfat
call framwork adbpre blktool
if "%target:~0,4%"=="name" (goto FORMATEXFAT-1) else (goto FORMATEXFAT-2)
:FORMATEXFAT-1
call info par %target:~5,999%
set parpath=%info__par__path%& set disksecsize=%info__par__disksecsize%
goto FORMATEXFAT-3
:FORMATEXFAT-2
set parpath=%target:~5,999%
call log %logger% I ��ʼ��ȡ����������С
set disksecsize=
for /f "tokens=2 delims= " %%a in ('adb.exe shell ./blktool -n -p --print-sector-size ^| find "%parpath%"') do set disksecsize=%%a
if "%disksecsize%"=="" ECHOC {%c_e%}��ȡ����������Сʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ����������Сʧ��& pause>nul & ECHO.����... & goto FORMATEXFAT-2
goto FORMATEXFAT-3
:FORMATEXFAT-3
call log %logger% I ����ж��%parpath%.��Ŀ�����δ�����򱨴�������������
adb.exe shell umount -f -d %parpath% 1>>%logfile% 2>&1
call log %logger% I ��ʼ��ʽ��EXFAT.����·��:%parpath%.����������С:%disksecsize%
set var=
if not "%label%"=="" adb.exe shell ./mkfs.exfat -n %label% %parpath% 1>>%logfile% 2>&1 || set var=n
if "%label%"=="" adb.exe shell ./mkfs.exfat %parpath% 1>>%logfile% 2>&1 || set var=n
if "%var%"=="n" ECHOC {%c_e%}��ʽ��EXFATʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ʽ��EXFATʧ��& pause>nul & ECHO.����... & goto FORMATEXFAT-3
call log %logger% I ��ʽ��EXFAT���
ENDLOCAL
goto :eof


:FORMATFAT32
SETLOCAL
set logger=clean.bat-formatfat32
set target=%var2%& set label=%var3%
call log %logger% I ���ձ���:target:%target%.label:%label%
call framwork adbpre mkfs.fat
call framwork adbpre blktool
if "%target:~0,4%"=="name" (goto FORMATFAT32-1) else (goto FORMATFAT32-2)
:FORMATFAT32-1
call info par %target:~5,999%
set parpath=%info__par__path%& set disksecsize=%info__par__disksecsize%
goto FORMATFAT32-3
:FORMATFAT32-2
set parpath=%target:~5,999%
call log %logger% I ��ʼ��ȡ����������С
set disksecsize=
for /f "tokens=2 delims= " %%a in ('adb.exe shell ./blktool -n -p --print-sector-size ^| find "%parpath%"') do set disksecsize=%%a
if "%disksecsize%"=="" ECHOC {%c_e%}��ȡ����������Сʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ����������Сʧ��& pause>nul & ECHO.����... & goto FORMATFAT32-2
goto FORMATFAT32-3
:FORMATFAT32-3
call log %logger% I ����ж��%parpath%.��Ŀ�����δ�����򱨴�������������
adb.exe shell umount -f -d %parpath% 1>>%logfile% 2>&1
call log %logger% I ��ʼ��ʽ��FAT32.����·��:%parpath%.����������С:%disksecsize%
set var=
if not "%label%"=="" adb.exe shell ./mkfs.fat -F 32 -n %label% -S %disksecsize% %parpath% 1>>%logfile% 2>&1 || set var=n
if "%label%"=="" adb.exe shell ./mkfs.fat -F 32 -S %disksecsize% %parpath% 1>>%logfile% 2>&1 || set var=n
if "%var%"=="n" ECHOC {%c_e%}��ʽ��FAT32ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ʽ��FAT32ʧ��& pause>nul & ECHO.����... & goto FORMATFAT32-3
call log %logger% I ��ʽ��FAT32���
ENDLOCAL
goto :eof


:FORMATNTFS
SETLOCAL
set logger=clean.bat-formatntfs
set target=%var2%& set label=%var3%
call log %logger% I ���ձ���:target:%target%.label:%label%
call framwork adbpre mkntfs
call framwork adbpre blktool
if "%target:~0,4%"=="name" (goto FORMATNTFS-1) else (goto FORMATNTFS-2)
:FORMATNTFS-1
call info par %target:~5,999%
set parpath=%info__par__path%& set disksecsize=%info__par__disksecsize%
goto FORMATNTFS-3
:FORMATNTFS-2
set parpath=%target:~5,999%
call log %logger% I ��ʼ��ȡ����������С
set disksecsize=
for /f "tokens=2 delims= " %%a in ('adb.exe shell ./blktool -n -p --print-sector-size ^| find "%parpath%"') do set disksecsize=%%a
if "%disksecsize%"=="" ECHOC {%c_e%}��ȡ����������Сʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ����������Сʧ��& pause>nul & ECHO.����... & goto FORMATNTFS-2
goto FORMATNTFS-3
:FORMATNTFS-3
call log %logger% I ����ж��%parpath%.��Ŀ�����δ�����򱨴�������������
adb.exe shell umount -f -d %parpath% 1>>%logfile% 2>&1
call log %logger% I ��ʼ��ʽ��NTFS.����·��:%parpath%.����������С:%disksecsize%
set var=
if not "%label%"=="" adb.exe shell ./mkntfs -Q -L %label% -s %disksecsize% %parpath% 1>>%logfile% 2>&1 || set var=n
if "%label%"=="" adb.exe shell ./mkntfs -Q -s %disksecsize% %parpath% 1>>%logfile% 2>&1 || set var=n
if "%var%"=="n" ECHOC {%c_e%}��ʽ��NTFSʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ʽ��NTFSʧ��& pause>nul & ECHO.����... & goto FORMATNTFS-3
call log %logger% I ��ʽ��NTFS���
ENDLOCAL
goto :eof


:TWRPFACTORYRESET
SETLOCAL
set logger=clean.bat-twrpfactoryreset
call log %logger% I ��ʼTWRP�ָ�����
:TWRPFACTORYRESET-1
adb.exe shell twrp wipe data 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}TWRP���Dataʧ��. {%c_h%}�����������...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E TWRP���Dataʧ��&& pause>nul && goto TWRPFACTORYRESET-1
type tmp\output.txt>>%logfile%
find "ata" "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}TWRP���Dataʧ��, TWRPδִ������. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E TWRP���Dataʧ��.TWRPδִ������&& pause>nul && goto TWRPFACTORYRESET-1
adb.exe shell twrp wipe cache 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}TWRP���Cacheʧ��. {%c_h%}�����������...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E TWRP���Cacheʧ��&& pause>nul && goto TWRPFACTORYRESET-1
type tmp\output.txt>>%logfile%
find "ache" "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}TWRP���Cacheʧ��, TWRPδִ������. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E TWRP���Cacheʧ��.TWRPδִ������&& pause>nul && goto TWRPFACTORYRESET-1
adb.exe shell twrp wipe dalvik 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}TWRP���Dalvikʧ��. {%c_h%}�����������...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E TWRP���Dalvikʧ��&& pause>nul && goto TWRPFACTORYRESET-1
type tmp\output.txt>>%logfile%
find "alvik" "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}TWRP���Dalvikʧ��, TWRPδִ������. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E TWRP���Dalvikʧ��.TWRPδִ������&& pause>nul && goto TWRPFACTORYRESET-1
call log %logger% I TWRP�ָ��������
ENDLOCAL
goto :eof


:TWRPFORMATDATA
SETLOCAL
set logger=clean.bat-twrpformatdata
call log %logger% I ��ʼTWRP��ʽ��Data
:TWRPFORMATDATA-1
adb.exe shell twrp format data 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}TWRP��ʽ��Dataʧ��. {%c_h%}�����������...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E TWRP��ʽ��Dataʧ�� && pause>nul && goto TWRPFORMATDATA-1
type tmp\output.txt>>%logfile%
find "ata" "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}TWRP��ʽ��Dataʧ��, TWRPδִ������. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E TWRP��ʽ��Dataʧ��.TWRPδִ������&& pause>nul && goto TWRPFORMATDATA-1
call reboot recovery recovery rechk 3
call log %logger% I TWRP��ʽ��Data���
ENDLOCAL
goto :eof


