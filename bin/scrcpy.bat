::call scrcpy ���� wait(��ѡ)
::            

@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9

SETLOCAL
set logger=scrcpy.bat
set title=%var1%
if "%title%"=="" set title=BFF-ADBͶ��
set wait=%var2%
call log %logger% I ���ձ���:title:%title%.wait:%wait%
goto START

:START
call log %logger% I ��ʼADBͶ��
taskkill /f /im scrcpy.exe 1>>%logfile% 2>&1
taskkill /f /im adb.exe 1>>%logfile% 2>&1
if "%wait%"=="wait" (
    %framwork_workspace%\tool\Windows\scrcpy\scrcpy.exe --show-touches --stay-awake --window-title=%title% 1>>%logfile% 2>&1 || ECHOC {%c_e%}����scrcpyʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����scrcpyʧ��&& pause>nul && ECHO.����... && goto START
    taskkill /f /im scrcpy.exe 1>>%logfile% 2>&1)
if not "%wait%"=="wait" (
    echo.%framwork_workspace%\tool\Windows\scrcpy\scrcpy.exe --show-touches --stay-awake --window-title=%title% 1^>^>%framwork_workspace%\log\scrcpy.log 2^>^&1 >tmp\cmd.bat
    echo.taskkill /f /im scrcpy.exe 1^>^>%framwork_workspace%\log\scrcpy.log 2^>^&1 >>tmp\cmd.bat
    echo.Set ws = CreateObject^("Wscript.Shell"^)>tmp\hide.vbs
    echo.ws.run "cmd /c tmp\cmd.bat",vbhide>>tmp\hide.vbs
    start tmp\hide.vbs)
call log %logger% I �˳�scrcpy.bat
ENDLOCAL
goto :eof



