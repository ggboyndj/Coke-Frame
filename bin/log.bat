::call log %logger% I ����
::                  W
::                  E
::                  F

@ECHO OFF
if "%framwork_log%"=="n" goto :eof
goto WRITELOG

:WRITELOG
if "%logfile%"=="" ECHO.��־ϵͳδ����. ������¼��־: [%2] %1 %3 & goto :eof
for /f %%a in ('gettime.exe ^| find "."') do echo.%%a [%2] %1 %3 >>%logfile%
goto :eof


