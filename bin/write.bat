::call write system        ������               img·��
::           recovery      ������               img·��
::           fastboot      ������               img·��
::           fastbootboot  img·��
::           mtkclient     ������               img·��
::           qcedlxml      �˿ں�               �洢����                     img�����ļ���                                         xml·��     firehose����·��(��ѡ,�������)
::           qcedlsingle   �˿ں�               �洢����                     ������                                               img·��      firehose����·��(��ѡ,�������)
::           sprdboot      �˿ں�               pac��·��
::           spflash       scatter��xml����·�� [download firmware-upgrade] [da����·�� auto](��ƽ̨����,��ƽ̨����)
::           twrpinst      zip·��
::           sideload      zip·��
::           adbpush       Դ�ļ�·��           ���ͺ��ļ���                  [common program program_su](�ļ�����,��ѡ,Ĭ��common)


@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%


:MTKCLIENT
SETLOCAL
set logger=write.bat-mtkclient
::���ձ���
set parname=%var2%& set imgpath=%var3%
call log %logger% I ���ձ���:parname:%parname%.imgpath:%imgpath%
:MTKCLIENT-1
if not exist %imgpath% ECHOC {%c_e%}�Ҳ���%imgpath%{%c_i%}{\n}& call log %logger% F �Ҳ���%imgpath%& goto FATAL
for %%a in ("%imgpath%") do set imgpath=%%~dpnxa
call log %logger% I mtkclient��ʼˢ��%imgpath%��%parname%
call tool\Windows\mtkclient\mtkclient.bat w %parname% %imgpath%
type tmp\output.txt | find "Wrote " | find " to sector " | find " with sector count " 1>nul 2>nul || ECHOC {%c_e%}mtkclientˢ��%imgpath%��%parname%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E mtkclientˢ��%imgpath%��%parname%ʧ��&& pause>nul && ECHO.����... && goto MTKCLIENT-1
call log %logger% I mtkclientˢ��%imgpath%��%parname%���
ENDLOCAL
goto :eof


:SPFLASH
SETLOCAL
set logger=write.bat-spflash
::���ձ���
set script=%var2%& set mode=%var3%& set da=%var4%
call log %logger% I ���ձ���:script:%script%.mode:%mode%.da:%da%
:SPFLASH-1
if not exist %script% ECHOC {%c_e%}�Ҳ���%script%{%c_i%}{\n}& call log %logger% F �Ҳ���%script%& goto FATAL
::�Զ�ѡ��spflash�汾
for %%i in ("%script%") do set var=%%~xi
if "%var%"==".xml" (goto SPFLASH-NEW) else (goto SPFLASH-OLD)
:SPFLASH-OLD
call log %logger% I ʹ�þ�ƽ̨����
set var=
for /f "tokens=2 delims= " %%i in ('type %script% ^| find "platform: "') do set var=%%i
if not "%var:~0,2%"=="MT" ECHOC {%c_e%}ʶ��scatter����������ʧ��.{%c_i%}{\n}& call log %logger% F ʶ��scatter����������ʧ��& goto FATAL
call log %logger% I scatter����������:%var%
set spflashver=
if exist tool\Windows\spflash\5.1728\platform.xml type tool\Windows\spflash\5.1728\platform.xml | find "platform name=" | find "%var%" 1>nul 2>nul && set spflashver=5.1728
if exist tool\Windows\spflash\5.1932\platform.xml type tool\Windows\spflash\5.1932\platform.xml | find "platform name=" | find "%var%" 1>nul 2>nul && set spflashver=5.1932
if exist tool\Windows\spflash\5.2032\platform.xml type tool\Windows\spflash\5.2032\platform.xml | find "platform name=" | find "%var%" 1>nul 2>nul && set spflashver=5.2032
if exist tool\Windows\spflash\5.2048\platform.xml type tool\Windows\spflash\5.2048\platform.xml | find "platform name=" | find "%var%" 1>nul 2>nul && set spflashver=5.2048
if exist tool\Windows\spflash\5.2316\platform.xml type tool\Windows\spflash\5.2316\platform.xml | find "platform name=" | find "%var%" 1>nul 2>nul && set spflashver=5.2316
if "%spflashver%"=="" ECHOC {%c_e%}�Ҳ������ʵ�spflash�汾.{%c_i%}{\n}& call log %logger% F �Ҳ������ʵ�spflash�汾& goto FATAL
call log %logger% I ʹ��spflash�汾:%spflashver%
::���da
if "%da%"=="auto" set da=tool\Windows\spflash\%spflashver%\MTK_AllInOne_DA.bin
if not exist %da% ECHOC {%c_e%}�Ҳ���%da%{%c_i%}{\n}& call log %logger% F �Ҳ���%da%& goto FATAL
call log %logger% I ʹ��da:%da%
::��ʼˢ��
:SPFLASH-OLD-1
call log %logger% I ��ʼspflashˢ��
tool\Windows\spflash\%spflashver%\flash_tool.exe -r -s %script% -c %mode% -d %da% -t auto --disable_storage_life_cycle_check 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "All command exec done!" "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}spflashˢ��ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E spflashˢ��ʧ��&& pause>nul && ECHO.����... && goto SPFLASH-OLD-1
goto SPFLASH-DONE
:SPFLASH-NEW
call log %logger% I ʹ����ƽ̨����
call log %logger% I ��ʼspflashˢ��
tool\Windows\spflash\6.2316\SPFlashToolV6.exe -r -f %script% -c %mode% -t auto --disable_storage_life_cycle_check 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "All command exec done!" "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}spflashˢ��ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E spflashˢ��ʧ��&& pause>nul && ECHO.����... && goto SPFLASH-NEW
goto SPFLASH-DONE
:SPFLASH-DONE
call log %logger% I spflashˢ�����
ENDLOCAL
goto :eof


:SPRDBOOT
SETLOCAL
set logger=write.bat-sprdboot
::���ձ���
set port=%var2%& set pac=%var3%
call log %logger% I ���ձ���:port:%port%.pac:%pac%
:SPRDBOOT-1
if not exist %pac% ECHOC {%c_e%}�Ҳ���%pac%{%c_i%}{\n}& call log %logger% F �Ҳ���%pac%& goto FATAL
if exist tmp\output.txt del tmp\output.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��tmp\output.txtʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ɾ��tmp\output.txtʧ��& pause>nul & ECHO.����... & goto SPRDBOOT-1
::������ؽű�
call log %logger% I ������ؽű�
echo.@ECHO OFF>tmp\cmd.bat
echo.TITLE BFF - չѶbootģʽˢ����ؽű�>>tmp\cmd.bat
echo.ECHO.�˽ű�ΪBFF��չѶbootģʽˢ����ؽű�, ���ڼ��ˢ��״̬, ˢ����ɺ���Զ��˳�.>>tmp\cmd.bat
echo.ECHO.�ȴ�ˢ����ʼ...>>tmp\cmd.bat
echo.:START-1|find "START" 1>>tmp\cmd.bat
echo.if not exist tmp\output.txt goto START-1|find "START" 1>>tmp\cmd.bat
echo.ECHO.ˢ���ѿ�ʼ. �ȴ�ˢ���ɹ�...>>tmp\cmd.bat
echo.:START-2|find "START" 1>>tmp\cmd.bat
echo.find "DownLoad Passed" "tmp\output.txt" 1^>nul 2^>nul ^|^| goto START-2|find "START" 1>>tmp\cmd.bat
echo.ECHO.ˢ���ɹ�. ����CmdDloader.exe...>>tmp\cmd.bat
echo.taskkill /f /im CmdDloader.exe>>tmp\cmd.bat
echo.EXIT>>tmp\cmd.bat
start /min tmp\cmd.bat
TIMEOUT /T 1 /NOBREAK>nul
::��ʼˢ��
call log %logger% I ��ʼչѶbootģʽˢ��.ˢ������ǰ��־�洢��bin\tmp\output.txt
CmdDloader.exe -pac %pac% -port %port% 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "DownLoad Passed" "tmp\output.txt" 1>nul 2>nul && goto SPRDBOOT-DONE
ECHOC {%c_e%}չѶbootģʽˢ��ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E չѶbootģʽˢ��ʧ��& pause>nul & ECHO.����... & goto SPRDBOOT-1
:SPRDBOOT-DONE
call log %logger% I չѶbootģʽˢ���ɹ�
ENDLOCAL
goto :eof


:ADBPUSH
SETLOCAL
set logger=write.bat-adbpush
::���ձ���
set filepath=%var2%& set pushname_full=%var3%& set mode=%var4%
call log %logger% I ���ձ���:filepath:%filepath%.pushname_full:%pushname_full%.mode:%mode%
:ADBPUSH-1
::����Ƿ����
if not exist %filepath% ECHOC {%c_e%}�Ҳ���%filepath%{%c_i%}{\n}& call log %logger% F �Ҳ���%filepath%& goto FATAL
::��ȡ�ļ���(��������չ��)
for %%i in ("%pushname_full%") do set pushname=%%~ni
::��ȡ�ļ���չ��
for %%i in ("%pushname_full%") do set var=%%~xi
set pushname_ext=%var:~1,999%
::�����ļ���С(b)
for /f "tokens=2 delims= " %%i in ('busybox.exe stat -t %filepath%') do set filesize_b=%%i
call log %logger% I %filepath%��СΪ%filesize_b%b
::����豸ģʽ
call chkdev all 1>nul
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" ECHOC {%c_e%}�豸ģʽ����. {%c_i%}�뽫�豸����ϵͳ��Recoveryģʽ. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �豸ģʽ����& pause>nul & ECHO.����... & goto ADBPUSH-1)
goto ADBPUSH-%chkdev__all__mode%
:ADBPUSH-SYSTEM
::ϵͳ�·�����:��ͨ��sdcard,������data/local/tmp
::�������ֶ���Ҫ�������͵�sdcard
set pushfolder=./sdcard
call log %logger% I ����%filepath%��%pushfolder%/%pushname_full%
adb.exe push %filepath% %pushfolder%/%pushname_full% 1>>%logfile% 2>&1 || ECHOC {%c_e%}����%filepath%��%pushfolder%/%pushname_full%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%filepath%��%pushfolder%/%pushname_full%ʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-SYSTEM
call log %logger% I ���%pushfolder%/%pushname_full%��С
adb.exe shell stat -t %pushfolder%/%pushname_full% 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}��ȡ%pushfolder%/%pushname_full%��Сʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ȡ%pushfolder%/%pushname_full%��Сʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-SYSTEM
set filesize_pushed_b=
for /f "tokens=2 delims= " %%i in (tmp\output.txt) do set filesize_pushed_b=%%i
call log %logger% I %pushfolder%/%pushname_full%��СΪ%filesize_pushed_b%b
if not "%filesize_b%"=="%filesize_pushed_b%" ECHOC {%c_e%}�������ļ���С%filesize_pushed_b%b��ԭ�ļ���С%filesize_b%b��һ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �������ļ���С%filesize_pushed_b%b��ԭ�ļ���С%filesize_b%b��һ��&& pause>nul && ECHO.����... && goto ADBPUSH-SYSTEM
if "%mode:~0,7%"=="program" (
    ::���ڳ���Ҫ�ƶ���./data/local/tmp�Ա�ִ��
    set pushfolder=./data/local/tmp
    call log %logger% I �ƶ�./sdcard/%pushname_full%��./data/local/tmp
    adb.exe shell mv -f ./sdcard/%pushname_full% ./data/local/tmp 1>>%logfile% 2>&1 || ECHOC {%c_e%}�ƶ�./sdcard/%pushname_full%��./data/local/tmpʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �ƶ�./sdcard/%pushname_full%��./data/local/tmpʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-SYSTEM)
if not "%mode%"=="program_su" goto ADBPUSH-DONE
:ADBPUSH-SYSTEM-1
::������Ҫ��Ȩ�ĳ�������Ȩ
ECHOC {%c_we%}��������RootȨ��. ��ע���ֻ���ʾ. ����RootȨ�޹���ҳ���ֶ���ȨShell...{%c_i%}{\n}& call log %logger% I ���RootȨ��
echo.su>tmp\cmd.txt & echo.whoami>>tmp\cmd.txt
adb.exe shell < tmp\cmd.txt 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}����û�ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E ����û�ʧ��ʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-SYSTEM-1
type tmp\output.txt>>%logfile%
for /f %%a in (tmp\output.txt) do (if not "%%a"=="root" ECHOC {%c_e%}���RootȨ��ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ���RootȨ��ʧ��& pause>nul & ECHO.����... & goto ADBPUSH-SYSTEM-1)
call log %logger% I ��Ȩ%pushfolder%/%pushname_full%
echo.su>tmp\cmd.txt & echo.chmod +x %pushfolder%/%pushname_full%>>tmp\cmd.txt
adb.exe shell < tmp\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}��Ȩ%pushfolder%/%pushname_full%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��Ȩ%pushfolder%/%pushname_full%ʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-SYSTEM-1
goto ADBPUSH-DONE
::Recovery��
:ADBPUSH-RECOVERY
call log %logger% I ���RootȨ��
adb.exe shell whoami 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}����û�ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E ����û�ʧ��ʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY
type tmp\output.txt>>%logfile%
for /f %%a in (tmp\output.txt) do (if not "%%a"=="root" ECHOC {%c_e%}���RootȨ��ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ���RootȨ��ʧ��& pause>nul & ECHO.����... & goto ADBPUSH-RECOVERY)
if "%mode:~0,7%"=="program" goto ADBPUSH-RECOVERY-1
goto ADBPUSH-RECOVERY-2
::����ǳ���ֱ���Ƹ�Ŀ¼
:ADBPUSH-RECOVERY-1
set pushfolder=.
call log %logger% I ����%filepath%��%pushfolder%/%pushname_full%
adb.exe push %filepath% %pushfolder%/%pushname_full% 1>>%logfile% 2>&1 || ECHOC {%c_e%}����%filepath%��%pushfolder%/%pushname_full%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%filepath%��%pushfolder%/%pushname_full%ʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY-1
call log %logger% I ���%pushfolder%/%pushname_full%��С
adb.exe shell stat -t %pushfolder%/%pushname_full% 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}��ȡ%pushfolder%/%pushname_full%��Сʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ȡ%pushfolder%/%pushname_full%��Сʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY-1
set filesize_pushed_b=
for /f "tokens=2 delims= " %%i in (tmp\output.txt) do set filesize_pushed_b=%%i
call log %logger% I %pushfolder%/%pushname_full%��СΪ%filesize_pushed_b%b
if not "%filesize_b%"=="%filesize_pushed_b%" ECHOC {%c_e%}�������ļ���С%filesize_pushed_b%b��ԭ�ļ���С%filesize_b%b��һ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �������ļ���С%filesize_pushed_b%b��ԭ�ļ���С%filesize_b%b��һ��&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY-1
if "%mode%"=="program_su" (
    call log %logger% I ��Ȩ%pushfolder%/%pushname_full%
    adb.exe shell chmod +x %pushfolder%/%pushname_full% || ECHOC {%c_e%}��Ȩ%pushfolder%/%pushname_full%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��Ȩ%pushfolder%/%pushname_full%ʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY-1)
goto ADBPUSH-DONE
::����ͨ�ļ�
::�ȳ���./tmp
:ADBPUSH-RECOVERY-2
set pushfolder=./tmp
call log %logger% I ����ɾ������%pushfolder%/%pushname_full%.���ļ��������򱨴�������������
adb.exe shell rm %pushfolder%/%pushname_full% 1>>%logfile% 2>&1
call log %logger% I ���./tmp
adb.exe shell df -a -k 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E ������ʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY-2
type tmp\output.txt>>%logfile%
busybox.exe sed -i "s/$/& /g" tmp\output.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}sed����tmp\output.txtʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E sed����tmp\output.txtʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY-2
set availsize=& set var=& set num=4
for /f "tokens=6 delims= " %%a in ('find " /tmp " "tmp\output.txt"') do set var=%%a
if "%var%"=="" set /a num+=-1
for /f "tokens=%num% delims= " %%i in ('find " /tmp " "tmp\output.txt"') do set availsize=%%i
if "%availsize%"=="" call log %logger% W ./tmpδ����& goto ADBPUSH-RECOVERY-4
call calc kb2b availsize_b nodec %availsize%
call log %logger% I ./tmp���ÿռ�Ϊ%availsize_b%b
for /f %%a in ('numcomp.exe %availsize_b% %filesize_b%') do (if "%%a"=="less" call log %logger% W ./tmp�ռ䲻��& goto ADBPUSH-RECOVERY-4)
adb.exe shell mkdir -p ./tmp/bff-test 1>>%logfile% 2>&1 || call log %logger% W ����./tmp/bff-testʧ��&& goto ADBPUSH-RECOVERY-4
adb.exe shell ls -l ./tmp | find " bff-test" 1>nul 2>nul || call log %logger% W �Ҳ���./tmp/bff-test&& goto ADBPUSH-RECOVERY-4
adb.exe shell rm -rf ./tmp/bff-test 1>>%logfile% 2>&1 || call log %logger% W ɾ��./tmp/bff-testʧ��&& goto ADBPUSH-RECOVERY-4
call log %logger% I ���./tmp���.��ʼ����%filepath%��%pushfolder%/%pushname_full%
:ADBPUSH-RECOVERY-3
adb.exe push %filepath% %pushfolder%/%pushname_full% 1>>%logfile% 2>&1 || ECHOC {%c_e%}����%filepath%��%pushfolder%/%pushname_full%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%filepath%��%pushfolder%/%pushname_full%ʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY-3
call log %logger% I ���%pushfolder%/%pushname_full%��С
adb.exe shell stat -t %pushfolder%/%pushname_full% 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}��ȡ%pushfolder%/%pushname_full%��Сʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ȡ%pushfolder%/%pushname_full%��Сʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY-3
set filesize_pushed_b=
for /f "tokens=2 delims= " %%i in (tmp\output.txt) do set filesize_pushed_b=%%i
call log %logger% I %pushfolder%/%pushname_full%��СΪ%filesize_pushed_b%b
if not "%filesize_b%"=="%filesize_pushed_b%" ECHOC {%c_e%}�������ļ���С%filesize_pushed_b%b��ԭ�ļ���С%filesize_b%b��һ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �������ļ���С%filesize_pushed_b%b��ԭ�ļ���С%filesize_b%b��һ��&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY-3
goto ADBPUSH-DONE
::�ٳ���./data. data������ѡ��.
:ADBPUSH-RECOVERY-4
set pushfolder=./data
call log %logger% I ����ɾ������%pushfolder%/%pushname_full%.���ļ��������򱨴�������������
adb.exe shell rm %pushfolder%/%pushname_full% 1>>%logfile% 2>&1
call log %logger% I ���./data
adb.exe shell df -a -k 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E ������ʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY-4
type tmp\output.txt>>%logfile%
busybox.exe sed -i "s/$/& /g" tmp\output.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}sed����tmp\output.txtʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E sed����tmp\output.txtʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY-4
set availsize=& set var=& set num=4
for /f "tokens=6 delims= " %%a in ('find " /data " "tmp\output.txt"') do set var=%%a
if "%var%"=="" set /a num+=-1
for /f "tokens=%num% delims= " %%i in ('find " /data " "tmp\output.txt"') do set availsize=%%i
if "%availsize%"=="" ECHOC {%c_e%}./dataδ����. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% W ./dataδ����& pause>nul & ECHO.����... & goto ADBPUSH-RECOVERY-4
call calc kb2b availsize_b nodec %availsize%
call log %logger% I ./data���ÿռ�Ϊ%availsize_b%b
for /f %%a in ('numcomp.exe %availsize_b% %filesize_b%') do (if "%%a"=="less" ECHOC {%c_e%}./data�ռ䲻��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% W ./data�ռ䲻��& pause>nul & ECHO.����... & goto ADBPUSH-RECOVERY-4)
adb.exe shell mkdir -p ./data/bff-test 1>>%logfile% 2>&1 || ECHOC {%c_e%}./data��д����ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% W ����./data/bff-testʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY-4
adb.exe shell ls -l ./data | find " bff-test" 1>nul 2>nul || ECHOC {%c_e%}./data��д����ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% W �Ҳ���./data/bff-test&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY-4
adb.exe shell rm -rf ./data/bff-test 1>>%logfile% 2>&1 || ECHOC {%c_e%}./data��д����ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% W ɾ��./data/bff-testʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY-4
call log %logger% I ���./data���.��ʼ����%filepath%��%pushfolder%/%pushname_full%
:ADBPUSH-RECOVERY-5
adb.exe push %filepath% %pushfolder%/%pushname_full% 1>>%logfile% 2>&1 || ECHOC {%c_e%}����%filepath%��%pushfolder%/%pushname_full%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%filepath%��%pushfolder%/%pushname_full%ʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY-5
call log %logger% I ���%pushfolder%/%pushname_full%��С
adb.exe shell stat -t %pushfolder%/%pushname_full% 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}��ȡ%pushfolder%/%pushname_full%��Сʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ȡ%pushfolder%/%pushname_full%��Сʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY-5
set filesize_pushed_b=
for /f "tokens=2 delims= " %%i in (tmp\output.txt) do set filesize_pushed_b=%%i
call log %logger% I %pushfolder%/%pushname_full%��СΪ%filesize_pushed_b%b
if not "%filesize_b%"=="%filesize_pushed_b%" ECHOC {%c_e%}�������ļ���С%filesize_pushed_b%b��ԭ�ļ���С%filesize_b%b��һ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �������ļ���С%filesize_pushed_b%b��ԭ�ļ���С%filesize_b%b��һ��&& pause>nul && ECHO.����... && goto ADBPUSH-RECOVERY-5
goto ADBPUSH-DONE
:ADBPUSH-DONE
call log %logger% I ADB�������.�ļ�·��:%pushfolder%/%pushname_full%
ENDLOCAL & set write__adbpush__filepath=%pushfolder%/%pushname_full%& set write__adbpush__filename_full=%pushname_full%& set write__adbpush__filename=%pushname%& set write__adbpush__folder=%pushfolder%& set write__adbpush__ext=%pushname_ext%
goto :eof


:SIDELOAD
SETLOCAL
set logger=write.bat-sideload
::���ձ���
set zippath=%var2%
call log %logger% I ���ձ���:zippath:%zippath%
:SIDELOAD-1
::����Ƿ����
if not exist %zippath% ECHOC {%c_e%}�Ҳ���%zippath%{%c_i%}{\n}& call log %logger% F �Ҳ���%zippath%& goto FATAL
::��װ
call reboot recovery sideload rechk 3
call log %logger% I ��װ%zippath%
adb.exe sideload %zippath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}��װ%zippath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��װ%zippath%ʧ��&& pause>nul && ECHO.����... && goto SIDELOAD-1
ENDLOCAL
goto :eof


:TWRPINST
SETLOCAL
set logger=write.bat-twrpinst
::���ձ���
set zippath=%var2%
call log %logger% I ���ձ���:zippath:%zippath%
:TWRPINST-1
::����Ƿ����
if not exist %zippath% ECHOC {%c_e%}�Ҳ���%zippath%{%c_i%}{\n}& call log %logger% F �Ҳ���%zippath%& goto FATAL
::����
call log %logger% I ����%zippath%
call write adbpush %zippath% bff.zip common
::adb.exe push %zippath% ./tmp/bff.zip 1>>%logfile% 2>&1 || ECHOC {%c_e%}����%zippath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%zippath%ʧ��&& pause>nul && ECHO.����... && goto TWRPINST-1
::��װ
call log %logger% I ��װ%write__adbpush__filepath%
adb.exe shell twrp install %write__adbpush__filepath% 1>tmp\output.txt 2>&1 || type tmp\output.txt>>%logfile% && call log %logger% E ��װ%zippath%ʧ��&& ECHOC {%c_e%}��װ%zippath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto TWRPINST-1
type tmp\output.txt>>%logfile%
find "zip" "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}��װ%zippath%ʧ��, TWRPδִ������. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��װ%zippath%ʧ��,TWRPδִ������&& pause>nul && ECHO.����... && goto TWRPINST-1
adb.exe shell rm %write__adbpush__filepath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��%write__adbpush__filepath%ʧ��{%c_i%}{\n}&& call log %logger% E ɾ��%write__adbpush__filepath%ʧ��
ENDLOCAL
goto :eof


:EDL
ECHOC {%c_w%}����: writeģ���edl�����Ѹ���Ϊqcedlxml, ����ϵ�ű����߾�����ĵ��÷���.{%c_i%}{\n}
goto QCEDLXML


:QCEDLXML
SETLOCAL
set logger=write.bat-qcedlxml
::���ձ���
set port=%var2%& set memory=%var3%& set searchpath=%var4%& set xml=%var5%& set fh=%var6%
call log %logger% I ���ձ���:port:%port%.memory:%memory%.searchpath:%searchpath%.xml:%xml%.fh:%fh%
:QCEDLXML-1
::���searchpath��firehose�Ƿ����
if not exist %searchpath% ECHOC {%c_e%}�Ҳ���%searchpath%{%c_i%}{\n}& call log %logger% F �Ҳ���%searchpath%& goto FATAL
if not "%fh%"=="" (if not exist %fh% ECHOC {%c_e%}�Ҳ���%fh%{%c_i%}{\n}& call log %logger% F �Ҳ���%fh%& goto FATAL)
::����xml
echo.%xml%>tmp\output.txt
for /f %%a in ('busybox.exe sed "s/\//,/g" tmp\output.txt') do set xml=%%a
call log %logger% I xml��������Ϊ:
echo.%xml%>>%logfile%
::��������
if not "%fh%"=="" (
    call log %logger% I ���ڷ�������
    QSaharaServer.exe -p \\.\COM%port% -s 13:%fh% 1>>%logfile% 2>&1 || ECHOC {%c_e%}��������ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul)
::��ʼˢ��
call log %logger% I ����9008ˢ��
fh_loader.exe --port=\\.\COM%port% --memoryname=%memory% --search_path=%searchpath% --sendxml=%xml% --noprompt 1>>%logfile% 2>&1 || ECHOC {%c_e%}9008ˢ��ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E 9008ˢ��ʧ��&& move /Y port_trace.txt log 1>>%logfile% 2>&1 && pause>nul && ECHO.����... && goto QCEDLXML-1
::--showpercentagecomplete --reset --noprompt --zlpawarehost=1 --testvipimpact
move /Y port_trace.txt log 1>>%logfile% 2>&1
call log %logger% I 9008ˢ�����
ENDLOCAL
goto :eof


:QCEDLSINGLE
SETLOCAL
set logger=write.bat-qcedlsingle
::���ձ���
set port=%var2%& set memory=%var3%& set parname=%var4%& set imgpath=%var5%& set fh=%var6%
if "%memory%"=="UFS" set memory=ufs& ECHOC {%c_w%}����: emmc��ufs������ȫ��ʹ��Сд. ����ϵ�ű����߾������.{%c_i%}{\n}
if "%memory%"=="Ufs" set memory=ufs& ECHOC {%c_w%}����: emmc��ufs������ȫ��ʹ��Сд. ����ϵ�ű����߾������.{%c_i%}{\n}
if "%memory%"=="EMMC" set memory=emmc& ECHOC {%c_w%}����: emmc��ufs������ȫ��ʹ��Сд. ����ϵ�ű����߾������.{%c_i%}{\n}
if "%memory%"=="Emmc" set memory=emmc& ECHOC {%c_w%}����: emmc��ufs������ȫ��ʹ��Сд. ����ϵ�ű����߾������.{%c_i%}{\n}
call log %logger% I ���ձ���:port:%port%.memory:%memory%.parname:%parname%.imgpath:%imgpath%.fh:%fh%
:QCEDLSINGLE-1
::���img��firehose�Ƿ����
if not exist %imgpath% ECHOC {%c_e%}�Ҳ���%imgpath%{%c_i%}{\n}& call log %logger% F �Ҳ���%imgpath%& goto FATAL
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
call log %logger% I ����9008ˢ��%imgpath%.lun:%num%.��ʼ����:%parstartsec%.������Ŀ:%parsizesec%
fh_loader.exe --port=\\.\COM%port% --search_path=%framwork_workspace% --sendimage=%imgpath% --lun=%num% --memoryname=%memory% --start_sector=%parstartsec% --num_sectors=%parsizesec% --noprompt 1>>%logfile% 2>&1 || ECHOC {%c_e%}9008ˢ��ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E 9008ˢ��ʧ��&& move /Y port_trace.txt log 1>>%logfile% 2>&1 && pause>nul && ECHO.����... && goto QCEDLSINGLE-1
move /Y port_trace.txt log 1>>%logfile% 2>&1
call log %logger% I 9008ˢ�����
ENDLOCAL
goto :eof
:QCEDLSINGLE-PARNOTFOUND
ECHOC {%c_e%}�Ҳ�������%parname%{%c_e%}& call log %logger% F �Ҳ�������%parname%& goto FATAL


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
::���ձ���
set parname=%var2%& set imgpath=%var3%
call log %logger% I ���ձ���:parname:%parname%.imgpath:%imgpath%
:ADBDD-1
::����ļ�
if not exist %imgpath% ECHOC {%c_e%}�Ҳ���%imgpath%{%c_i%}{\n}& call log %logger% F �Ҳ���%imgpath%& goto FATAL
::ϵͳ��Ҫ���Root
if "%target%"=="system" (
    call log %logger% I ��ʼ���Root
    echo.su>tmp\cmd.txt& echo.exit>>tmp\cmd.txt& echo.exit>>tmp\cmd.txt
    adb.exe shell < tmp\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ȡRootʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ȡRootʧ��&& pause>nul && ECHO.����... && goto ADBDD-1)
::����
call log %logger% I ��ʼ����%imgpath%
call write adbpush %imgpath% %parname%.img common
::adb.exe push %imgpath% %target%/%parname%.img 1>>%logfile% 2>&1 || ECHOC {%c_e%}����%imgpath%��%target%/%parname%.imgʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%imgpath%��%target%/%parname%.imgʧ��&& pause>nul && ECHO.����... && goto ADBDD-1
::��ȡ����·��
call info par %parname%
::ˢ�������
if "%target%"=="system" echo.su>tmp\cmd.txt& echo.dd if=%write__adbpush__filepath% of=%info__par__path% >>tmp\cmd.txt& echo.rm %write__adbpush__filepath%>>tmp\cmd.txt
if "%target%"=="recovery" echo.dd if=%write__adbpush__filepath% of=%info__par__path% >tmp\cmd.txt& echo.rm %write__adbpush__filepath%>>tmp\cmd.txt
call log %logger% I ��ʼˢ��%write__adbpush__filepath%��%info__par__path%
adb.exe shell < tmp\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}ˢ��%write__adbpush__filepath%��%info__par__path%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ˢ��%write__adbpush__filepath%��%info__par__path%ʧ��&& pause>nul && ECHO.����... && goto ADBDD-1
ENDLOCAL
goto :eof


:FASTBOOT
SETLOCAL
set logger=write.bat-fastboot
::���ձ���
set parname=%var2%& set imgpath=%var3%
call log %logger% I ���ձ���:parname:%parname%.imgpath:%imgpath%
:FASTBOOT-1
::����ļ�
if not exist %imgpath% ECHOC {%c_e%}�Ҳ���%imgpath%{%c_i%}{\n}& call log %logger% F �Ҳ���%imgpath%& goto FATAL
::ˢ��
call log %logger% I ��ʼˢ��%imgpath%��%parname%
fastboot.exe flash %parname% %imgpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}ˢ��%imgpath%��%parname%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ˢ��%imgpath%��%parname%ʧ��&& pause>nul && ECHO.����... && goto FASTBOOT-1
ENDLOCAL
goto :eof


:FASTBOOTBOOT
SETLOCAL
set logger=write.bat-fastbootboot
::���ձ���
set imgpath=%var2%
call log %logger% I ���ձ���:imgpath:%imgpath%
:FASTBOOTBOOT-1
::����ļ�
if not exist %imgpath% ECHOC {%c_e%}�Ҳ���%imgpath%{%c_i%}{\n}& call log %logger% F �Ҳ���%imgpath%& goto FATAL
::��ʱ����
call log %logger% I ����%imgpath%
fastboot.exe boot %imgpath% 1>>%logfile% 2>&1 && goto FASTBOOTBOOT-DONE
ECHOC {%c_e%}����%imgpath%ʧ��{%c_i%}{\n}& call log %logger% E ����%imgpath%ʧ��
ECHO.1.�豸û�н���Ŀ��ģʽ, ���³�����ʱ����
ECHO.2.�ű��ж�����, �豸�ѽ���Ŀ��ģʽ, ���Լ���
call choice common [1][2]
if "%choice%"=="2" goto FASTBOOTBOOT-DONE
call chkdev fastboot
ECHO.���³�����ʱ����...
goto FASTBOOTBOOT-1
:FASTBOOTBOOT-DONE
ENDLOCAL
goto :eof








:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)

