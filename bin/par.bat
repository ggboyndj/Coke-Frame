::call par mk            ����·��  ������                  ����            start  end  ���(��ѡ,Ĭ��Ϊ�׸����õ�)
::         rm            ����·��  [name:xxx��numb:xx]
::         setmaxparnum  ����·��  Ŀ�������(��ѡ,Ĭ��128)
::         bakpartable   ����·��  ����·��(�����ļ���)      noprompt(��ѡ)
::         recpartable   ����·��  �ļ�·��


@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%


:RECPARTABLE
SETLOCAL
set logger=par.bat-recpartable
set diskpath=%var2%& set filepath=%var3%
call log %logger% I ���ձ���:diskpath:%diskpath%.filepath:%filepath%
:RECPARTABLE-1
if not exist %filepath% ECHOC {%c_e%}�Ҳ���%filepath%{%c_i%}{\n}& call log %logger% F �Ҳ���%filepath%& goto FATAL
call framwork adbpre sgdisk
call write adbpush %filepath% bff_sgdiskpartable.bak common
::adb.exe push %filepath% ./bff_sgdiskpartable.bak 1>>%logfile% 2>&1 || ECHOC {%c_e%}���ͷ�����ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���ͷ�����ʧ��&& pause>nul && ECHO.����... && goto RECPARTABLE-1
adb.exe shell ./sgdisk -l %write__adbpush__filepath% %diskpath% 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "The operation has completed successfully." "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}�ָ�������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �ָ�������ʧ��&& pause>nul && ECHO.����... && goto RECPARTABLE-1
call log %logger% I �ָ����������
ENDLOCAL
goto :eof


:BAKPARTABLE
SETLOCAL
set logger=par.bat-bakpartable
set diskpath=%var2%& set filepath=%var3%& set mode=%var4%
call log %logger% I ���ձ���:diskpath:%diskpath%.filepath:%filepath%.mode:%mode%
:BAKPARTABLE-1
if not "%mode%"=="noprompt" (if exist %filepath% ECHOC {%c_w%}�Ѵ���%filepath%, ���������Ǵ��ļ�. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% W �Ѵ���%filepath%.���������Ǵ��ļ�& pause>nul & ECHO.����...)
call framwork adbpre sgdisk
adb.exe shell ./sgdisk -b ./bff_sgdiskpartable.bak %diskpath% 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "The operation has completed successfully." "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}���ݷ�����ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���ݷ�����ʧ��&& pause>nul && ECHO.����... && goto BAKPARTABLE-1
adb.exe pull ./bff_sgdiskpartable.bak %filepath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}���Ʒ�����ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���Ʒ�����ʧ��&& pause>nul && ECHO.����... && goto BAKPARTABLE-1
call log %logger% I ���ݷ��������
ENDLOCAL
goto :eof


:MK
SETLOCAL
set logger=par.bat-mk
set diskpath=%var2%& set parname=%var3%& set partype=%var4%& set parstart=%var5%& set parend=%var6%& set parnum=%var7%
call log %logger% I ���ձ���:parname:%parname%.partype:%partype%.parstart:%parstart%.parend:%parend%.parnum:%parnum%
call framwork adbpre sgdisk
if not "%parnum%"=="" goto MK-3
:MK-1
call log %logger% I ��ʼ��ȡ���õķ������
adb.exe shell ./sgdisk -p %diskpath% 1>tmp\output.txt 2>&1 || ECHOC {%c_e%}��ȡ���õķ������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& type tmp\output.txt>>%logfile% && call log %logger% E ��ȡ���õķ������ʧ��&& pause>nul && ECHO.����... && goto MK-1
type tmp\output.txt>>%logfile%
if exist tmp\output2.txt del tmp\output2.txt 1>nul
for /f "tokens=1 delims= " %%i in ('type tmp\output.txt ^| find "  " ^| find /v "Number"') do echo.[%%i]>>tmp\output2.txt
set num=1
:MK-2
find "[%num%]" "tmp\output2.txt" 1>nul 2>nul || set parnum=%num%&& goto MK-3
set /a num+=1& goto MK-2
:MK-3
call log %logger% I ��ʼ��ȡ����������С
call info disk %diskpath%
call calc kb2sec parstart_sec nodec %parstart% %info__disk__secsize%
call calc kb2sec parend_sec nodec %parend% %info__disk__secsize%
:MK-4
call log %logger% I ��ʼ��������.Ŀ����Ϊ%parnum%
adb.exe shell ./sgdisk -n %parnum%:%parstart_sec%:%parend_sec% %diskpath% 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "The operation has completed successfully." "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}��������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul && ECHO.����... && goto MK-4
:MK-5
call log %logger% I ��ʼ��������
adb.exe shell ./sgdisk -c %parnum%:%parname% %diskpath% 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "The operation has completed successfully." "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}��������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul && ECHO.����... && goto MK-5
:MK-6
call log %logger% I ��ʼ���÷�������
adb.exe shell ./sgdisk -t %parnum%:%partype% %diskpath% 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "The operation has completed successfully." "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}���÷�������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���÷�������ʧ��&& pause>nul && ECHO.����... && goto MK-6
::call reboot recovery recovery rechk 3
call log %logger% I �����������
ENDLOCAL
goto :eof


:RM
SETLOCAL
set logger=par.bat-rm
set diskpath=%var2%& set target=%var3%
call log %logger% I ���ձ���:diskpath:%diskpath%.target:%target%
call framwork adbpre sgdisk
if "%target:~0,4%"=="numb" set parnum=%target:~5,999%& goto RM-2
:RM-1
call log %logger% I ��ʼ��ȡ�������.������Ϊ%target:~5,999%
call info par %target:~5,999%
set parnum=%info__par__num%
goto RM-2
:RM-2
call log %logger% I ��ʼɾ������.Ŀ����Ϊ%parnum%
adb.exe shell ./sgdisk -d %parnum% %diskpath% 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "The operation has completed successfully." "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}ɾ������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ɾ������ʧ��&& pause>nul && ECHO.����... && goto RM-2
::call reboot recovery recovery rechk 3
call log %logger% I ɾ���������
ENDLOCAL
goto :eof


:SETMAXPARNUM
SETLOCAL
set logger=par.bat-setmaxparnum
set diskpath=%var2%& set target=%var3%
if "%target%"=="" set target=128
call log %logger% I ���ձ���:diskpath:%diskpath%.target:%target%
call framwork adbpre sgdisk
:SETMAXPARNUM-1
call log %logger% I ��ʼ������������
adb.exe shell ./sgdisk --resize-table=%target% %diskpath% 1>tmp\output.txt 2>&1
type tmp\output.txt>>%logfile%
find "The operation has completed successfully." "tmp\output.txt" 1>nul 2>nul || ECHOC {%c_e%}������������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ������������ʧ��&& pause>nul && ECHO.����... && goto SETMAXPARNUM-1
call log %logger% I ���������������
ENDLOCAL
goto :eof















:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)


