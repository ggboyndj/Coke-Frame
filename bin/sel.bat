::call sel file   [s m] %framwork_workspace% [img][bin]...(��ѡ)
::         folder [s m] %framwork_workspace%


@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto SEL

:SEL
SETLOCAL
set logger=sel.bat
::���ձ���
set target=%var1%& set quantity=%var2%& set startfolder=%var3%& set filter=%var4%
::if "%quantity%"=="s" set quantity=
::if "%quantity%"=="m" set quantity=Multi
call log %logger% I ���ձ���:target:%target%.quantity:%quantity%.startfolder:%startfolder%.filter:%filter%
::����������չ��
set "filter_filedialog=|�����ļ�|*.*"
if "%filter%"=="" goto SEL-2
set num=1
:SEL-1
set var=
for /f "tokens=%num% delims=[] " %%i in ('echo.%filter%') do set var=%%i
if "%var%"=="" goto SEL-2
for /f "tokens=%num% delims=[] " %%i in ('echo.%filter%') do set "filter_filedialog=*.%%i;%filter_filedialog%"
set /a num+=1& goto SEL-1
:SEL-2
set "filter_filedialog=��ѡ��|%filter_filedialog%"
:SEL-3
::��ʼѡ��
set selpath=
goto SEL-%target%-%quantity%

:SEL-FILE-S
filedialog.exe Open "%startfolder%" "%filter_filedialog%" | find ":" 1>tmp\output.txt 2>nul || ECHOC {%c_e%}δѡ���κ��ļ�. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
find " " "tmp\output.txt" 1>nul 2>nul && ECHOC {%c_e%}ѡ���·�����ļ����в��ܺ��пո�. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
find "(" "tmp\output.txt" 1>nul 2>nul && ECHOC {%c_e%}ѡ���·�����ļ����в��ܺ���Ӣ������. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
find ")" "tmp\output.txt" 1>nul 2>nul && ECHOC {%c_e%}ѡ���·�����ļ����в��ܺ���Ӣ������. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
find "," "tmp\output.txt" 1>nul 2>nul && ECHOC {%c_e%}ѡ���·�����ļ����в��ܺ���Ӣ�Ķ���. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
for /f %%a in (tmp\output.txt) do set var=%%a
set selpath=%var:~1,-1%
if not exist %selpath% ECHOC {%c_e%}�Ҳ���%selpath%. ����ѡ���·�����ļ����к��������ַ�. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto SEL-3
set sel__file_path=%selpath%
for %%i in ("%sel__file_path%") do set sel__file_fullname=%%~nxi
for %%i in ("%sel__file_path%") do set sel__file_name=%%~ni
for %%i in ("%sel__file_path%") do set var=%%~xi
set sel__file_ext=%var:~1,999%
for %%i in ("%sel__file_path%") do set var=%%~dpi
set sel__file_folder=%var:~0,-1%
ECHO.��ѡ���ļ�:%sel__file_path%& call log %logger% I ��ѡ���ļ�:%sel__file_path%.�����ļ���:%sel__file_fullname%.�ļ���:%sel__file_name%.��չ��:%sel__file_ext%.�����ļ���·��:%sel__file_folder%
ENDLOCAL & set sel__file_path=%sel__file_path%& set sel__file_fullname=%sel__file_fullname%& set sel__file_name=%sel__file_name%& set sel__file_ext=%sel__file_ext%& set sel__file_folder=%sel__file_folder%
goto :eof

:SEL-FOLDER-S
filedialog.exe Folder "%startfolder%" | find ":" 1>tmp\output.txt 2>nul || ECHOC {%c_e%}δѡ���κ��ļ���. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
find " " "tmp\output.txt" 1>nul 2>nul && ECHOC {%c_e%}ѡ���·�����ļ����в��ܺ��пո�. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
find "(" "tmp\output.txt" 1>nul 2>nul && ECHOC {%c_e%}ѡ���·�����ļ����в��ܺ���Ӣ������. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
find ")" "tmp\output.txt" 1>nul 2>nul && ECHOC {%c_e%}ѡ���·�����ļ����в��ܺ���Ӣ������. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
find "," "tmp\output.txt" 1>nul 2>nul && ECHOC {%c_e%}ѡ���·�����ļ����в��ܺ���Ӣ�Ķ���. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
for /f %%a in (tmp\output.txt) do set var=%%a
set selpath=%var:~1,-1%
if not exist %selpath% ECHOC {%c_e%}�Ҳ���%selpath%. ����ѡ���·�����ļ����к��������ַ�. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto SEL-3
set sel__folder_path=%selpath%
for %%i in ("%sel__folder_path%") do set sel__folder_name=%%~nxi
ECHO.��ѡ���ļ���:%sel__folder_path%& call log %logger% I ��ѡ���ļ���:%sel__folder_path%.�ļ�����:%sel__folder_name%
ENDLOCAL & set sel__folder_path=%sel__folder_path%& set sel__folder_name=%sel__folder_name%
goto :eof

:SEL-FILE-M
filedialog.exe Open "%startfolder%" "%filter_filedialog%" Multi | find ":" 1>tmp\output.txt 2>nul || ECHOC {%c_e%}δѡ���κ��ļ�. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
busybox.exe sed -i "s/\",\"/\//g" tmp\output.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}sed����tmp\output.txtʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E sed����tmp\output.txtʧ��&& pause>nul && ECHO.����... && goto SEL-3
find " " "tmp\output.txt" 1>nul 2>nul && ECHOC {%c_e%}ѡ���·�����ļ����в��ܺ��пո�. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
find "(" "tmp\output.txt" 1>nul 2>nul && ECHOC {%c_e%}ѡ���·�����ļ����в��ܺ���Ӣ������. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
find ")" "tmp\output.txt" 1>nul 2>nul && ECHOC {%c_e%}ѡ���·�����ļ����в��ܺ���Ӣ������. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
find "," "tmp\output.txt" 1>nul 2>nul && ECHOC {%c_e%}ѡ���·�����ļ����в��ܺ���Ӣ�Ķ���. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
for /f %%a in (tmp\output.txt) do set var=%%a
set sel__files=%var:~1,-1%
ECHO.��ѡ���ļ�(��ѡģʽ):%sel__files%& call log %logger% I �Ѷ�ѡ�ļ�:%sel__files%
ENDLOCAL & set sel__files=%sel__files%
goto :eof

:SEL-FOLDER-M
filedialog.exe Folder "%startfolder%" Multi ^| find ":" 1>tmp\output.txt 2>nul || ECHOC {%c_e%}δѡ���κ��ļ���. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
busybox.exe sed -i "s/\",\"/\//g" tmp\output.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}sed����tmp\output.txtʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E sed����tmp\output.txtʧ��&& pause>nul && ECHO.����... && goto SEL-3
find " " "tmp\output.txt" 1>nul 2>nul && ECHOC {%c_e%}ѡ���·�����ļ����в��ܺ��пո�. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
find "(" "tmp\output.txt" 1>nul 2>nul && ECHOC {%c_e%}ѡ���·�����ļ����в��ܺ���Ӣ������. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
find ")" "tmp\output.txt" 1>nul 2>nul && ECHOC {%c_e%}ѡ���·�����ļ����в��ܺ���Ӣ������. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
find "," "tmp\output.txt" 1>nul 2>nul && ECHOC {%c_e%}ѡ���·�����ļ����в��ܺ���Ӣ�Ķ���. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto SEL-3
for /f %%a in (tmp\output.txt) do set var=%%a
set sel__folders=%var:~1,-1%
ECHO.��ѡ���ļ���(��ѡģʽ):%sel__folders%& call log %logger% I �Ѷ�ѡ�ļ���:%sel__folders%
ENDLOCAL & set sel__folders=%sel__folders%
goto :eof



