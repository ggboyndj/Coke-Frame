::call dl direct ֱ��               ��������·��(�����ļ���) [retry once] [notice noprompt] ����ַ���(��ѡ)
::        lzlink �����������(-****) ��������·��(�����ļ���) [retry once] [notice noprompt] ����ַ���(��ѡ)

@ECHO OFF

set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
SETLOCAL
set logger=dl.bat
set dlmode=%var1%& set link_orig=%var2%& set filepath=%var3%& set dltimes=%var4%& set fileexistfunc=%var5%& set chkfield=%var6%
call log %logger% I ���ձ���:dlmode:%dlmode%.link_orig:%link_orig%.filepath:%filepath%.dltimes:%dltimes%.fileexistfunc:%fileexistfunc%.chkfield:%chkfield%
goto %dlmode%




:DIRECT
if not "%fileexistfunc%"=="noprompt" (
    if exist %filepath% (
        ECHOC {%c_w%}%filepath%�Ѵ���.���������Ǵ��ļ�.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% W %filepath%�Ѵ���.���������Ǵ��ļ�&& pause>nul && ECHO.����...
        del /Q %filepath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��%filepath%ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ɾ��%filepath%ʧ��&& pause>nul && ECHO.����... && goto DIRECT))
set link_direct=%link_orig%
call :startdl
if "%result%"=="y" goto FINISH
::����ʧ��
if "%dltimes%"=="once" (goto FINISH) else (ECHO.�Զ�����... & goto DIRECT)


:LZLINK
for /f "tokens=2 delims=[]" %%a in ('echo.%link_orig%') do (if not "%%a"=="" goto LZLINK-STV)
goto LZLINK-SINGLE

:LZLINK-SINGLE
if not "%fileexistfunc%"=="noprompt" (
    if exist %filepath% (
        ECHOC {%c_w%}%filepath%�Ѵ���.���������Ǵ��ļ�.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% W %filepath%�Ѵ���.���������Ǵ��ļ�&& pause>nul && ECHO.����...
        del /Q %filepath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��%filepath%ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ɾ��%filepath%ʧ��&& pause>nul && ECHO.����... && goto LZLINK-SINGLE))
for /f "tokens=1 delims=[]" %%a in ('echo.%link_orig%') do set link_lz=%%a
echo.%link_lz% | find "-" 1>nul 2>nul
if not "%errorlevel%"=="0" (call :getlzdirectlink-nopswd) else (call :getlzdirectlink-pswd)
call :startdl
if "%result%"=="y" goto FINISH
::����ʧ��
if "%dltimes%"=="once" (goto FINISH) else (ECHO.�Զ�����... & goto LZLINK-SINGLE)

:LZLINK-STV
if not "%fileexistfunc%"=="noprompt" (
    if exist %filepath%.??? (
        ECHOC {%c_w%}%filepath%.xxx�Ѵ���.���������Ǵ�^(��^)�ļ�.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% W %filepath%.xxx�Ѵ���.���������Ǵ�^(��^)�ļ�&& pause>nul && ECHO.����...
        del /Q %filepath%.??? 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��%filepath%.xxxʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ɾ��%filepath%.xxxʧ��&& pause>nul && ECHO.����... && goto LZLINK-STV))
set filepath_orig=%filepath%
set num=1
:LZLINK-STV-1
set link_lz=
for /f "tokens=%num% delims=[]" %%a in ('echo.%link_orig%') do set link_lz=%%a
if "%link_lz%"=="" goto FINISH
echo.%link_lz% | find "-" 1>nul 2>nul
if not "%errorlevel%"=="0" (call :getlzdirectlink-nopswd) else (call :getlzdirectlink-pswd)
if not "%num:~0,1%"=="" set filepath=%filepath_orig%.00%num%
if not "%num:~1,1%"=="" set filepath=%filepath_orig%.0%num%
if not "%num:~2,1%"=="" set filepath=%filepath_orig%.%num%
call :startdl
if "%result%"=="y" set /a num+=1& goto LZLINK-STV-1
::����ʧ��
if "%dltimes%"=="once" (goto FINISH) else (ECHO.�Զ�����... & goto LZLINK-STV-1)


:FINISH
call log %logger% I ���ؽ��Ϊ%result%.�˳�����ģ��
ENDLOCAL & set dl__result=%result%
goto :eof


:getlzdirectlink-nopswd
echo.%link_lz% | find "https" 1>nul 2>nul
if "%errorlevel%"=="0" (set var=2) else (set var=1)
for /f "tokens=%var% delims=/ " %%i in ('echo.%link_lz%') do set link_lz_value1=%%i
echo.%link_lz% | find "/tp/" 1>nul 2>nul
if "%errorlevel%"=="0" (set /a var+=2) else (set /a var+=1)
for /f "tokens=%var% delims=/ " %%i in ('echo.%link_lz%') do set link_lz_value2=%%i
call log %logger% I ������������:https://%link_lz_value1%/tp/%link_lz_value2%
curl.exe -k -A "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" https://%link_lz_value1%/tp/%link_lz_value2% 1>tmp\output.txt 2>tmp\output2.txt || type tmp\output2.txt>>%logfile%&& type tmp\output.txt>>%logfile%&& ECHOC {%c_e%}curl����1ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E curl����1ʧ��&& pause>nul && ECHO.����... && goto getlzdirectlink-nopswd
set link_lz_developer_part1=
::for /f "tokens=4 delims='; " %%i in ('find "var tedomain " "tmp\output.txt"') do set link_lz_developer_part1=%%i
for /f "tokens=4 delims='; " %%i in ('find "var vkjxld " "tmp\output.txt"') do set link_lz_developer_part1=%%i
if "%link_lz_developer_part1%"=="" type tmp\output.txt>>%logfile%& ECHOC {%c_e%}curl����1��link_lz_developer_part1���Ϊ��.{%c_h%}�����������...{%c_i%}{\n}& call log %logger% E curl����1��link_lz_developer_part1���Ϊ��& pause>nul & ECHO.����... & goto getlzdirectlink-nopswd
set link_lz_developer_part2=
::for /f "tokens=4 delims='; " %%i in ('find "var domianload " "tmp\output.txt"') do set link_lz_developer_part2=%%i
for /f "tokens=4 delims='; " %%i in ('find "var hyggid " "tmp\output.txt"') do set link_lz_developer_part2=%%i
if "%link_lz_developer_part2%"=="" type tmp\output.txt>>%logfile%& ECHOC {%c_e%}curl����2��link_lz_developer_part2���Ϊ��.{%c_h%}�����������...{%c_i%}{\n}& call log %logger% E curl����2��link_lz_developer_part2���Ϊ��& pause>nul & ECHO.����... & goto getlzdirectlink-nopswd
call log %logger% I ������������:"%link_lz_developer_part1%%link_lz_developer_part2%"
curl.exe -i -k -A "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" %link_lz_developer_part1%%link_lz_developer_part2% --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" --header "Accept-Encoding: gzip, deflate" --header "Accept-Language: zh-CN,zh;q=0.9" --header "Cache-Control: no-cache" --header "Connection: keep-alive" --header "Pragma: no-cache" --header "Upgrade-Insecure-Requests: 1" 1>tmp\output.txt 2>tmp\output2.txt || type tmp\output2.txt>>%logfile%&& type tmp\output.txt>>%logfile%&& ECHOC {%c_e%}curl����2ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E curl����2ʧ��&& pause>nul && ECHO.����... && goto getlzdirectlink-nopswd
for /f "tokens=2 delims= " %%i in ('find "location: " "tmp\output.txt"') do set link_direct="%%i"
::if "%link_direct%"=="" type tmp\output.txt>>%logfile%& ECHOC {%c_e%}curl����2���Ϊ��.{%c_h%}�����������...{%c_i%}{\n}& call log %logger% E curl����2���Ϊ��& pause>nul & ECHO.����... & goto getlzdirectlink-nopswd
call log %logger% I ���ֱ��:%link_direct%
goto :eof

:getlzdirectlink-pswd
for /f "tokens=1,2 delims=-" %%a in ('echo.%link_lz%') do (set var=%%a& set link_lz_pswd=%%b)
set link_lz=%var%
echo.%link_lz% | find "https" 1>nul 2>nul
if "%errorlevel%"=="0" (set var=2) else (set var=1)
for /f "tokens=%var% delims=/ " %%i in ('echo.%link_lz%') do set link_lz_value1=%%i
echo.%link_lz% | find "/tp/" 1>nul 2>nul
if "%errorlevel%"=="0" (set /a var+=2) else (set /a var+=1)
for /f "tokens=%var% delims=/ " %%i in ('echo.%link_lz%') do set link_lz_value2=%%i
call log %logger% I ������������:https://%link_lz_value1%/tp/%link_lz_value2%.����:%link_lz_pswd%
curl.exe -k -A "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" https://%link_lz_value1%/tp/%link_lz_value2% 1>tmp\output.txt 2>tmp\output2.txt || type tmp\output2.txt>>%logfile%&& type tmp\output.txt>>%logfile%&& ECHOC {%c_e%}curl����1ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E curl����1ʧ��&& pause>nul && ECHO.����... && goto getlzdirectlink-pswd
::for /f "tokens=4 delims=' " %%i in ('type tmp\output.txt ^| find "var postsign"') do set link_lz_postsign=%%i
for /f "tokens=4 delims=' " %%i in ('type tmp\output.txt ^| find "var vidksek"') do set link_lz_postsign=%%i
curl.exe -k -A "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" -e "https://syxz.lanzoub.com" https://%link_lz_value1%/ajaxm.php --data-raw "action=downprocess&sign=%link_lz_postsign%&p=%link_lz_pswd%" 1>tmp\output.txt 2>tmp\output2.txt || type tmp\output2.txt>>%logfile%&& type tmp\output.txt>>%logfile%&& ECHOC {%c_e%}curl����2ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E curl����2ʧ��&& pause>nul && ECHO.����... && goto getlzdirectlink-pswd
busybox.exe sed -i "s/\"/ /g" tmp\output.txt
if not "%errorlevel%"=="0" ECHOC {%c_e%}sed����1ʧ��.{%c_h%}�����������...{%c_i%}{\n}& call log %logger% E sed����1ʧ��& pause>nul & ECHO.����... & goto getlzdirectlink-pswd
busybox.exe sed -i "s/\\//g" tmp\output.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}sed����2ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E sed����2ʧ��&& pause>nul && ECHO.����... && goto getlzdirectlink-pswd
set link_lz_developer_part1=& set link_lz_developer_part2=
for /f "tokens=6,10 delims= " %%a in (tmp\output.txt) do (set link_lz_developer_part1=%%a& set link_lz_developer_part2=%%b)
if "%link_lz_developer_part1%"=="" type tmp\output.txt>>%logfile%& ECHOC {%c_e%}link_lz_developer_part1���Ϊ��.{%c_h%}�����������...{%c_i%}{\n}& call log %logger% E link_lz_developer_part1���Ϊ��& pause>nul & ECHO.����... & goto getlzdirectlink-pswd
if "%link_lz_developer_part2%"=="" type tmp\output.txt>>%logfile%& ECHOC {%c_e%}link_lz_developer_part2���Ϊ��.{%c_h%}�����������...{%c_i%}{\n}& call log %logger% E link_lz_developer_part2���Ϊ��& pause>nul & ECHO.����... & goto getlzdirectlink-pswd
call log %logger% I ������������:"%link_lz_developer_part1%/file/%link_lz_developer_part2%"
curl.exe -i -k -A "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" %link_lz_developer_part1%/file/%link_lz_developer_part2% --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" --header "Accept-Encoding: gzip, deflate" --header "Accept-Language: zh-CN,zh;q=0.9" --header "Cache-Control: no-cache" --header "Connection: keep-alive" --header "Pragma: no-cache" --header "Upgrade-Insecure-Requests: 1" 1>tmp\output.txt 2>tmp\output2.txt || type tmp\output2.txt>>%logfile%&& type tmp\output.txt>>%logfile%&& ECHOC {%c_e%}curl����3ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E curl����3ʧ��&& pause>nul && ECHO.����... && goto getlzdirectlink-pswd
for /f "tokens=2 delims= " %%i in ('find "location: " "tmp\output.txt"') do set link_direct="%%i"
call log %logger% I ���ֱ��:%link_direct%
goto :eof


:startdl
call log %logger% I ��������%link_direct%��tmp\dl\bffdl.tmp
if exist tmp\dl rd /s /q tmp\dl 1>nul 2>>%logfile% || ECHOC {%c_e%}ɾ��tmp\dlʧ��{%c_i%}{\n}&& call log %logger% E ɾ��tmp\dlʧ��
md tmp\dl 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\dlʧ��{%c_i%}{\n}&& call log %logger% E ����tmp\dlʧ��
aria2c.exe --max-concurrent-downloads=16 --max-connection-per-server=16 --split=16 --file-allocation=none --out=tmp\dl\bffdl.tmp %link_direct% 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ʧ��{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& set result=n&& goto :eof
if not "%chkfield%"=="" find "%chkfield%" "tmp\dl\bffdl.tmp" 1>nul 2>nul || ECHOC {%c_e%}����ʧ��,�Ҳ���ָ�����ַ�,����ʧ��{%c_i%}{\n}&& call log %logger% E ����ʧ��.�Ҳ���ָ�����ַ�:%chkfield%.����ʧ��&& set result=n&& goto :eof
for /f "tokens=3 delims= " %%i in ('dir tmp\dl /-C /-N /A:-D ^| find "bffdl"') do set var=%%i
if %var% LEQ 10240 (
    find "code" "tmp\dl\bffdl.tmp" | find ": 400," 1>nul 2>nul && ECHOC {%c_e%}����ʧ��,���ֱ���,����ʧ��{%c_i%}{\n}&& call log %logger% E ����ʧ��.���ֱ���.����ʧ��&& set result=n&& goto :eof
    find "code" "tmp\dl\bffdl.tmp" | find ": 201," 1>nul 2>nul && ECHOC {%c_e%}����ʧ��,���ֱ���,����ʧ��{%c_i%}{\n}&& call log %logger% E ����ʧ��.���ֱ���.����ʧ��&& set result=n&& goto :eof
    find "path not found" "tmp\dl\bffdl.tmp" | find ":500," 1>nul 2>nul && ECHOC {%c_e%}����ʧ��,�Ҳ����ƶ�·��,����ʧ��{%c_i%}{\n}&& call log %logger% E ����ʧ��.�Ҳ����ƶ�·��.����ʧ��&& set result=n&& goto :eof
    find "could not be found" "tmp\dl\bffdl.tmp" | find ":500," 1>nul 2>nul && ECHOC {%c_e%}����ʧ��,���ֱ���,����ʧ��{%c_i%}{\n}&& call log %logger% E ����ʧ��.���ֱ���.����ʧ��&& set result=n&& goto :eof
    find "failed to get file" "tmp\dl\bffdl.tmp" | find ":500," 1>nul 2>nul && ECHOC {%c_e%}����ʧ��,�Ҳ����ƶ��ļ�,����ʧ��{%c_i%}{\n}&& call log %logger% E ����ʧ��.�Ҳ����ƶ��ļ�.����ʧ��&& set result=n&& goto :eof
    find "Loading storage, please wait" "tmp\dl\bffdl.tmp" | find ":500," 1>nul 2>nul && ECHOC {%c_e%}����ʧ��,�ƴ洢��δ�������,����ʧ��{%c_i%}{\n}&& call log %logger% E ����ʧ��.�ƴ洢��δ�������.����ʧ��&& set result=n&& goto :eof)
move /Y tmp\dl\bffdl.tmp %filepath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}�ƶ�ʧ��{%c_i%}{\n}&& call log %logger% E �ƶ�ʧ��&& set result=n&& goto :eof
set result=y& call log %logger% I �������سɹ�
goto :eof


