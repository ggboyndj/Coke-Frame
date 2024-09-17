::call open [common folder txt pic] 目标路径

@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
SETLOCAL
set logger=open.bat
if "%var1%"=="common" start %var2%
if "%var1%"=="folder" (
    if not exist %var2% ECHOC {%c_e%}找不到%var2%, 无法打开. {%c_h%}按任意键继续...{%c_i%}{\n}& call log %logger% E 找不到%var2%& pause>nul & ECHO.继续... & goto DONE
    start "" "%var2%")
if "%var1%"=="txt" (
    if not exist %var2% ECHOC {%c_e%}找不到%var2%, 无法打开. {%c_h%}按任意键继续...{%c_i%}{\n}& call log %logger% E 找不到%var2%& pause>nul & ECHO.继续... & goto DONE
    start tool\Windows\Notepad3\Notepad3.exe %var2%)
if "%var1%"=="pic" (
    if not exist %var2% ECHOC {%c_e%}找不到%var2%, 无法打开. {%c_h%}按任意键继续...{%c_i%}{\n}& call log %logger% E 找不到%var2%& pause>nul & ECHO.继续... & goto DONE
    for %%i in ("%var2%") do start tool\Windows\Vieas\Vieas.exe /v %%~dpnxi)
goto DONE
:DONE
ENDLOCAL
goto :eof


:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}抱歉, 脚本遇到问题, 无法继续运行. 请查看日志. {%c_h%}按任意键退出...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.抱歉, 脚本遇到问题, 无法继续运行. 按任意键退出...& pause>nul & EXIT)
