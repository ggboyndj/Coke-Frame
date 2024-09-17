::call log %logger% I 文字
::                  W
::                  E
::                  F

@ECHO OFF
if "%framwork_log%"=="n" goto :eof
goto WRITELOG

:WRITELOG
if "%logfile%"=="" ECHO.日志系统未加载. 跳过记录日志: [%2] %1 %3 & goto :eof
for /f %%a in ('gettime.exe ^| find "."') do echo.%%a [%2] %1 %3 >>%logfile%
goto :eof


