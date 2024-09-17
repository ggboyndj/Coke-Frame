::call scrcpy 标题 wait(可选)
::            

@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9

SETLOCAL
set logger=scrcpy.bat
set title=%var1%
if "%title%"=="" set title=BFF-ADB投屏
set wait=%var2%
call log %logger% I 接收变量:title:%title%.wait:%wait%
goto START

:START
call log %logger% I 开始ADB投屏
taskkill /f /im scrcpy.exe 1>>%logfile% 2>&1
taskkill /f /im adb.exe 1>>%logfile% 2>&1
if "%wait%"=="wait" (
    %framwork_workspace%\tool\Windows\scrcpy\scrcpy.exe --show-touches --stay-awake --window-title=%title% 1>>%logfile% 2>&1 || ECHOC {%c_e%}启动scrcpy失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 启动scrcpy失败&& pause>nul && ECHO.重试... && goto START
    taskkill /f /im scrcpy.exe 1>>%logfile% 2>&1)
if not "%wait%"=="wait" (
    echo.%framwork_workspace%\tool\Windows\scrcpy\scrcpy.exe --show-touches --stay-awake --window-title=%title% 1^>^>%framwork_workspace%\log\scrcpy.log 2^>^&1 >tmp\cmd.bat
    echo.taskkill /f /im scrcpy.exe 1^>^>%framwork_workspace%\log\scrcpy.log 2^>^&1 >>tmp\cmd.bat
    echo.Set ws = CreateObject^("Wscript.Shell"^)>tmp\hide.vbs
    echo.ws.run "cmd /c tmp\cmd.bat",vbhide>>tmp\hide.vbs
    start tmp\hide.vbs)
call log %logger% I 退出scrcpy.bat
ENDLOCAL
goto :eof



