::call calc sec2kb  ���������  [dec nodec]  ����ֵ  ������С
::          kb2sec  ���������  [dec nodec]  kb     ������С
::          kb2mb   ���������  [dec nodec]  kb
::          mb2kb   ���������  [dec nodec]  mb
::          kb2gb   ���������  [dec nodec]  kb
::          gb2kb   ���������  [dec nodec]  gb
::          b2kb    ���������  [dec nodec]  b
::          kb2b    ���������  [dec nodec]  kb
::          p       ���������  [dec nodec]  ����1   ����2
::          s       ���������  [dec nodec]  ����1   ����2
::          m       ���������  [dec nodec]  ����1   ����2
::          d       ���������  [dec nodec]  ����1   ����2



@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%


:SEC2KB
SETLOCAL
set logger=calc.bat-sec2kb
set output=%var2%& set dec=%var3%& set sec=%var4%& set secsize=%var5%
call log %logger% I ���ձ���:output:%output%.dec:%dec%.sec:%sec%.secsize:%secsize%
if "%dec%"=="dec" (set dec=) else (set dec=.)
for /f "tokens=1 delims=%dec% " %%i in ('calc.exe %sec% m %secsize%') do set var=%%i
for /f "tokens=1 delims=%dec% " %%i in ('calc.exe %var% d 1024') do set var=%%i
call log %logger% I ������:%var%
ENDLOCAL & set %output%=%var%
goto :eof


:KB2SEC
SETLOCAL
set logger=calc.bat-kb2sec
set output=%var2%& set dec=%var3%& set kb=%var4%& set secsize=%var5%
call log %logger% I ���ձ���:output:%output%.dec:%dec%.kb:%kb%.secsize:%secsize%
if "%dec%"=="dec" (set dec=) else (set dec=.)
for /f "tokens=1 delims=%dec% " %%i in ('calc.exe %kb% m 1024') do set var=%%i
for /f "tokens=1 delims=%dec% " %%i in ('calc.exe %var% d %secsize%') do set var=%%i
call log %logger% I ������:%var%
ENDLOCAL & set %output%=%var%
goto :eof


:KB2MB
SETLOCAL
set logger=calc.bat-kb2mb
set output=%var2%& set dec=%var3%& set kb=%var4%
call log %logger% I ���ձ���:output:%output%.dec:%dec%.kb:%kb%
if "%dec%"=="dec" (set dec=) else (set dec=.)
for /f "tokens=1 delims=%dec% " %%i in ('calc.exe %kb% d 1024') do set var=%%i
call log %logger% I ������:%var%
ENDLOCAL & set %output%=%var%
goto :eof


:MB2KB
SETLOCAL
set logger=calc.bat-mb2kb
set output=%var2%& set dec=%var3%& set mb=%var4%
call log %logger% I ���ձ���:output:%output%.dec:%dec%.mb:%mb%
if "%dec%"=="dec" (set dec=) else (set dec=.)
for /f "tokens=1 delims=%dec% " %%i in ('calc.exe %mb% m 1024') do set var=%%i
call log %logger% I ������:%var%
ENDLOCAL & set %output%=%var%
goto :eof


:KB2GB
SETLOCAL
set logger=calc.bat-kb2gb
set output=%var2%& set dec=%var3%& set kb=%var4%
call log %logger% I ���ձ���:output:%output%.dec:%dec%.kb:%kb%
if "%dec%"=="dec" (set dec=) else (set dec=.)
for /f "tokens=1 delims=%dec% " %%i in ('calc.exe %kb% d 1048576') do set var=%%i
call log %logger% I ������:%var%
ENDLOCAL & set %output%=%var%
goto :eof


:GB2KB
SETLOCAL
set logger=calc.bat-gb2kb
set output=%var2%& set dec=%var3%& set gb=%var4%
call log %logger% I ���ձ���:output:%output%.dec:%dec%.gb:%gb%
if "%dec%"=="dec" (set dec=) else (set dec=.)
for /f "tokens=1 delims=%dec% " %%i in ('calc.exe %gb% m 1048576') do set var=%%i
call log %logger% I ������:%var%
ENDLOCAL & set %output%=%var%
goto :eof


:B2KB
SETLOCAL
set logger=calc.bat-b2kb
set output=%var2%& set dec=%var3%& set b=%var4%
call log %logger% I ���ձ���:output:%output%.dec:%dec%.b:%b%
if "%dec%"=="dec" (set dec=) else (set dec=.)
for /f "tokens=1 delims=%dec% " %%i in ('calc.exe %b% d 1024') do set var=%%i
call log %logger% I ������:%var%
ENDLOCAL & set %output%=%var%
goto :eof


:KB2B
SETLOCAL
set logger=calc.bat-kb2b
set output=%var2%& set dec=%var3%& set kb=%var4%
call log %logger% I ���ձ���:output:%output%.dec:%dec%.kb:%kb%
if "%dec%"=="dec" (set dec=) else (set dec=.)
for /f "tokens=1 delims=%dec% " %%i in ('calc.exe %kb% m 1024') do set var=%%i
call log %logger% I ������:%var%
ENDLOCAL & set %output%=%var%
goto :eof


:P
SETLOCAL
set func=p& goto PSMD
:S
SETLOCAL
set func=s& goto PSMD
:M
SETLOCAL
set func=m& goto PSMD
:D
SETLOCAL
set func=d& goto PSMD
:PSMD
set logger=calc.bat-%func%
set output=%var2%& set dec=%var3%& set input1=%var4%& set input2=%var5%
call log %logger% I ���ձ���:output:%output%.dec:%dec%.input1:%input1%.input2:%input2%
if "%dec%"=="dec" (set dec=) else (set dec=.)
for /f "tokens=1 delims=%dec% " %%i in ('calc.exe %input1% %func% %input2%') do set var=%%i
call log %logger% I ������:%var%
ENDLOCAL & set %output%=%var%
goto :eof






:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)

