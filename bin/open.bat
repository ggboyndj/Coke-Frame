::call open [common folder txt pic] Ŀ��·��

@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
SETLOCAL
set logger=open.bat
if "%var1%"=="common" start %var2%
if "%var1%"=="folder" (
    if not exist %var2% ECHOC {%c_e%}�Ҳ���%var2%, �޷���. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �Ҳ���%var2%& pause>nul & ECHO.����... & goto DONE
    start "" "%var2%")
if "%var1%"=="txt" (
    if not exist %var2% ECHOC {%c_e%}�Ҳ���%var2%, �޷���. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �Ҳ���%var2%& pause>nul & ECHO.����... & goto DONE
    start tool\Windows\Notepad3\Notepad3.exe %var2%)
if "%var1%"=="pic" (
    if not exist %var2% ECHOC {%c_e%}�Ҳ���%var2%, �޷���. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �Ҳ���%var2%& pause>nul & ECHO.����... & goto DONE
    for %%i in ("%var2%") do start tool\Windows\Vieas\Vieas.exe /v %%~dpnxi)
goto DONE
:DONE
ENDLOCAL
goto :eof


:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)
