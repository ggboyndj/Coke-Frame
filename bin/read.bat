::call read system        ������  �ļ�����·��(�����ļ���)  noprompt(��ѡ)
::          recovery      ������  �ļ�����·��(�����ļ���)  noprompt(��ѡ)
::          qcedlxml      �˿ں�  �洢����                img����ļ���    xml·��                 firehose����·��(��ѡ,�������)
::          qcedlsingle   �˿ں�  �洢����                ������           �ļ�����·��(�����ļ���)  firehose����·��(��ѡ,�������)


@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%


:EDL
ECHOC {%c_w%}����: readģ���edl�����Ѹ���Ϊqcedlxml, ����ϵ�ű����߾�����ĵ��÷���.{%c_i%}{\n}
goto QCEDLXML


:QCEDLXML
SETLOCAL
set logger=read.bat-qcedlxml
::���ձ���
set port=%var2%& set memory=%var3%& set imgpath=%var4%& set xml=%var5%& set fh=%var6%
call log %logger% I ���ձ���:port:%port%.memory:%memory%.imgpath:%imgpath%.xml:%xml%.fh:%fh%
:QCEDLXML-1
::���img��firehose�Ƿ����
if not exist %imgpath% ECHOC {%c_e%}�Ҳ���%imgpath%{%c_i%}{\n}& call log %logger% F �Ҳ���%imgpath%& goto FATAL
if not "%fh%"=="" (if not exist %fh% ECHOC {%c_e%}�Ҳ���%fh%{%c_i%}{\n}& call log %logger% F �Ҳ���%fh%& goto FATAL)
::����xml
echo.%xml%>tmp\output.txt
for /f %%a in ('busybox.exe sed "s/\//,/g" tmp\output.txt') do set xml=%%a
call log %logger% I xml��������Ϊ:
echo.%xml%>>%logfile%
::��������
if not "%fh%"=="" (
    call log %logger% I ���ڷ�������
    QSaharaServer.exe -p \\.\COM%port% -s 13:%fh% 1>>%logfile% 2>&1 || ECHOC {%c_e%}��������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul)
::��ʼ�ض�
call log %logger% I ����9008�ض�
cd /d %imgpath% || ECHOC {%c_e%}����%imgpath%ʧ��.{%c_i%}{\n}&& call log %logger% F ����%imgpath%ʧ��&& goto FATAL
fh_loader.exe --port=\\.\COM%port% --memoryname=%memory% --sendxml=%xml% --convertprogram2read --noprompt 1>>%logfile% 2>&1 || ECHOC {%c_e%}9008�ض�ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E 9008�ض�ʧ��&& xcopy /Y port_trace.txt %framwork_workspace%\log 1>nul && del port_trace.txt 1>nul && cd /d %framwork_workspace% && pause>nul && ECHO.����... && goto QCEDLXML-1
::--showpercentagecomplete --reset --zlpawarehost=1 --testvipimpact
xcopy /Y port_trace.txt %framwork_workspace%\log 1>nul & del port_trace.txt 1>nul
cd /d %framwork_workspace% || ECHOC {%c_e%}����%framwork_workspace%ʧ��.{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
call log %logger% I 9008�ض����
ENDLOCAL
goto :eof


:QCEDLSINGLE
SETLOCAL
set logger=read.bat-qcedlsingle
::���ձ���
set port=%var2%& set memory=%var3%& set parname=%var4%& set imgpath=%var5%& set fh=%var6%
if "%memory%"=="UFS" set memory=ufs& ECHOC {%c_w%}����: emmc��ufs������ȫ��ʹ��Сд. ����ϵ�ű����߾������.{%c_i%}{\n}
if "%memory%"=="Ufs" set memory=ufs& ECHOC {%c_w%}����: emmc��ufs������ȫ��ʹ��Сд. ����ϵ�ű����߾������.{%c_i%}{\n}
if "%memory%"=="EMMC" set memory=emmc& ECHOC {%c_w%}����: emmc��ufs������ȫ��ʹ��Сд. ����ϵ�ű����߾������.{%c_i%}{\n}
if "%memory%"=="Emmc" set memory=emmc& ECHOC {%c_w%}����: emmc��ufs������ȫ��ʹ��Сд. ����ϵ�ű����߾������.{%c_i%}{\n}
call log %logger% I ���ձ���:port:%port%.memory:%memory%.parname:%parname%.imgpath:%imgpath%.fh:%fh%
:QCEDLSINGLE-1
::��ȡ�ļ���
for %%a in ("%imgpath%") do set imgpath_fullname=%%~nxa
::���img����Ŀ¼��firehose�Ƿ����
for %%a in ("%imgpath%") do set var=%%~dpa
set imgpath_folder=%var:~0,-1%
if not exist %imgpath_folder% ECHOC {%c_e%}�Ҳ���%imgpath_folder%{%c_i%}{\n}& call log %logger% F �Ҳ���%imgpath_folder%& goto FATAL
if not "%fh%"=="" (if not exist %fh% ECHOC {%c_e%}�Ҳ���%fh%{%c_i%}{\n}& call log %logger% F �Ҳ���%fh%& goto FATAL)
::��������
if not "%fh%"=="" (
    call log %logger% I ���ڷ�������
    QSaharaServer.exe -p \\.\COM%port% -s 13:%fh% 1>>%logfile% 2>&1 || ECHOC {%c_e%}��������ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul)
::�ض�, �����������ļ���ˢ�����
if exist tmp\ptanalyse rd /s /q tmp\ptanalyse 1>nul
md tmp\ptanalyse
set num=0
:QCEDLSINGLE-2
call log %logger% I ����9008�ض�������%num%
cd tmp\ptanalyse || ECHOC {%c_e%}����tmp\ptanalyseʧ��.{%c_i%}{\n}&& call log %logger% F ����tmp\ptanalyseʧ��&& goto FATAL
set var=34
if "%memory%"=="ufs" set var=6
fh_loader.exe --port=\\.\COM%port% --memoryname=%memory% --sendimage=gpt_%num%.bin --lun=%num% --start_sector=0 --num_sectors=%var% --convertprogram2read --noprompt 1>>%logfile% 2>&1 || ECHOC {%c_e%}9008�ض�������%num%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E 9008�ض�������%num%ʧ��&& move /Y port_trace.txt %framwork_workspace%\log 1>nul && cd /d %framwork_workspace% && pause>nul && ECHO.����... && goto QCEDLSINGLE-1
move /Y port_trace.txt %framwork_workspace%\log 1>>%logfile% 2>&1
cd /d %framwork_workspace% || ECHOC {%c_e%}����%framwork_workspace%ʧ��.{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
call log %logger% I 9008�ض�������%num%���
call log %logger% I ����������%num%
ptanalyzer.exe tmp\ptanalyse\gpt_%num%.bin gpt%memory%read 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "Analysis completed." "tmp\output.txt" 1>nul 2>nul && goto QCEDLSINGLE-3
find "[Total] 0" "tmp\output.txt" 1>nul 2>nul && goto QCEDLSINGLE-PARNOTFOUND
ECHOC {%c_e%}����������%num%ʧ��{%c_e%}& call log %logger% F ����������%num%ʧ��& goto FATAL
:QCEDLSINGLE-3
set parsizesec=
for /f "tokens=3,5 delims=[] " %%a in ('type tmp\output.txt ^| find "] %parname% "') do set parstartsec=%%a& set parsizesec=%%b
if "%parsizesec%"=="" set /a num+=1& goto QCEDLSINGLE-2
call log %logger% I ����9008�ض�%imgpath%.lun:%num%.��ʼ����:%parstartsec%.������Ŀ:%parsizesec%
cd /d %imgpath_folder% || ECHOC {%c_e%}����%imgpath_folder%ʧ��.{%c_i%}{\n}&& call log %logger% F ����%imgpath_folder%ʧ��&& goto FATAL
if exist %imgpath% del /f /q %imgpath% 1>>%logfile% 2>&1
fh_loader.exe --port=\\.\COM%port% --sendimage=%imgpath_fullname% --lun=%num% --memoryname=%memory% --start_sector=%parstartsec% --num_sectors=%parsizesec% --convertprogram2read --noprompt 1>>%logfile% 2>&1 || ECHOC {%c_e%}9008�ض�ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E 9008�ض�ʧ��&& xcopy /Y port_trace.txt %framwork_workspace%\log 1>nul && del port_trace.txt 1>nul && cd /d %framwork_workspace% && pause>nul && ECHO.����... && goto QCEDLSINGLE-1
xcopy /Y port_trace.txt %framwork_workspace%\log 1>nul & del port_trace.txt 1>nul
cd /d %framwork_workspace% || ECHOC {%c_e%}����%framwork_workspace%ʧ��.{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
call log %logger% I 9008�ض����
ENDLOCAL
goto :eof
:QCEDLSINGLE-PARNOTFOUND
ECHOC {%c_e%}�Ҳ�������%parname%{%c_e%}& call log %logger% F �Ҳ�������%parname%& goto FATAL


:SYSTEM
SETLOCAL
set logger=read.bat-system
set target=./sdcard
goto ADBDD


:RECOVERY
SETLOCAL
set logger=read.bat-recovery
set target=./tmp
goto ADBDD


:ADBDD
::���ձ���
set parname=%var2%& set filepath=%var3%& set mode=%var4%
call log %logger% I ���ձ���:parname:%parname%.filepath:%filepath%.noprompt:%noprompt%
:ADBDD-1
::���Ŀ¼
::if not exist %filepath% ECHOC {%c_e%}�Ҳ���%filepath%{%c_i%}{\n}& call log %logger% F �Ҳ���%filepath%& goto FATAL
if exist %filepath% (if not "%mode%"=="noprompt" ECHOC {%c_w%}�Ѵ���%filepath%, ���������Ǵ��ļ�. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% W �Ѵ���%filepath%.���������Ǵ��ļ�& pause>nul & ECHO.����...)
::ϵͳ��Ҫ���Root
if "%target%"=="./sdcard" (
    call log %logger% I ��ʼ���Root
    echo.su>tmp\cmd.txt& echo.exit>>tmp\cmd.txt& echo.exit>>tmp\cmd.txt
    adb.exe shell < tmp\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ȡRootʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ȡRootʧ��&& pause>nul && ECHO.����... && goto ADBDD-1)
::��ȡ����·��
call info par %parname%
::����
if "%target%"=="./sdcard" echo.su>tmp\cmd.txt& echo.dd if=%info__par__path% of=%target%/%parname%.img >>tmp\cmd.txt
if "%target%"=="./tmp" echo.dd if=%info__par__path% of=%target%/%parname%.img >tmp\cmd.txt
call log %logger% I ��ʼ����%parname%��%target%/%parname%.img
adb.exe shell < tmp\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}����%parname%��%target%/%parname%.imgʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%parname%��%target%/%parname%.imgʧ��&& pause>nul && ECHO.����... && goto ADBDD-1
::��ȡ
call log %logger% I ��ʼ��ȡ%target%/%parname%.img��%filepath%
adb.exe pull %target%/%parname%.img %filepath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ȡ%target%/%parname%.img��%filepath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ȡ%target%/%parname%.img��%filepath%ʧ��&& pause>nul && ECHO.����... && goto ADBDD-1
::����
call log %logger% I ��ʼɾ��%target%/%parname%.img
if "%target%"=="./sdcard" echo.su>tmp\cmd.txt& echo.rm %target%/%parname%.img>>tmp\cmd.txt
if "%target%"=="./tmp" echo.rm %target%/%parname%.img>tmp\cmd.txt
adb.exe shell < tmp\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��%target%/%parname%.imgʧ��.{%c_i%}{\n}&& call log %logger% E ɾ��%target%/%parname%.imgʧ��
ENDLOCAL
goto :eof









:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)

