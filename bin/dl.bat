::call dl direct 直链               完整保存路径(包括文件名) [retry once] [notice noprompt] 检查字符串(可选)
::        lzlink 蓝奏分享链接(-****) 完整保存路径(包括文件名) [retry once] [notice noprompt] 检查字符串(可选)

@ECHO OFF

set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
SETLOCAL
set logger=dl.bat
set dlmode=%var1%& set link_orig=%var2%& set filepath=%var3%& set dltimes=%var4%& set fileexistfunc=%var5%& set chkfield=%var6%
call log %logger% I 接收变量:dlmode:%dlmode%.link_orig:%link_orig%.filepath:%filepath%.dltimes:%dltimes%.fileexistfunc:%fileexistfunc%.chkfield:%chkfield%
goto %dlmode%




:DIRECT
if not "%fileexistfunc%"=="noprompt" (
    if exist %filepath% (
        ECHOC {%c_w%}%filepath%已存在.继续将覆盖此文件.{%c_h%}按任意键继续...{%c_i%}{\n}&& call log %logger% W %filepath%已存在.继续将覆盖此文件&& pause>nul && ECHO.继续...
        del /Q %filepath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}删除%filepath%失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 删除%filepath%失败&& pause>nul && ECHO.重试... && goto DIRECT))
set link_direct=%link_orig%
call :startdl
if "%result%"=="y" goto FINISH
::下载失败
if "%dltimes%"=="once" (goto FINISH) else (ECHO.自动重试... & goto DIRECT)


:LZLINK
for /f "tokens=2 delims=[]" %%a in ('echo.%link_orig%') do (if not "%%a"=="" goto LZLINK-STV)
goto LZLINK-SINGLE

:LZLINK-SINGLE
if not "%fileexistfunc%"=="noprompt" (
    if exist %filepath% (
        ECHOC {%c_w%}%filepath%已存在.继续将覆盖此文件.{%c_h%}按任意键继续...{%c_i%}{\n}&& call log %logger% W %filepath%已存在.继续将覆盖此文件&& pause>nul && ECHO.继续...
        del /Q %filepath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}删除%filepath%失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 删除%filepath%失败&& pause>nul && ECHO.重试... && goto LZLINK-SINGLE))
for /f "tokens=1 delims=[]" %%a in ('echo.%link_orig%') do set link_lz=%%a
echo.%link_lz% | find "-" 1>nul 2>nul
if not "%errorlevel%"=="0" (call :getlzdirectlink-nopswd) else (call :getlzdirectlink-pswd)
call :startdl
if "%result%"=="y" goto FINISH
::下载失败
if "%dltimes%"=="once" (goto FINISH) else (ECHO.自动重试... & goto LZLINK-SINGLE)

:LZLINK-STV
if not "%fileexistfunc%"=="noprompt" (
    if exist %filepath%.??? (
        ECHOC {%c_w%}%filepath%.xxx已存在.继续将覆盖此^(类^)文件.{%c_h%}按任意键继续...{%c_i%}{\n}&& call log %logger% W %filepath%.xxx已存在.继续将覆盖此^(类^)文件&& pause>nul && ECHO.继续...
        del /Q %filepath%.??? 1>>%logfile% 2>&1 || ECHOC {%c_e%}删除%filepath%.xxx失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 删除%filepath%.xxx失败&& pause>nul && ECHO.重试... && goto LZLINK-STV))
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
::下载失败
if "%dltimes%"=="once" (goto FINISH) else (ECHO.自动重试... & goto LZLINK-STV-1)


:FINISH
call log %logger% I 下载结果为%result%.退出下载模块
ENDLOCAL & set dl__result=%result%
goto :eof


:getlzdirectlink-nopswd
echo.%link_lz% | find "https" 1>nul 2>nul
if "%errorlevel%"=="0" (set var=2) else (set var=1)
for /f "tokens=%var% delims=/ " %%i in ('echo.%link_lz%') do set link_lz_value1=%%i
echo.%link_lz% | find "/tp/" 1>nul 2>nul
if "%errorlevel%"=="0" (set /a var+=2) else (set /a var+=1)
for /f "tokens=%var% delims=/ " %%i in ('echo.%link_lz%') do set link_lz_value2=%%i
call log %logger% I 即将解析链接:https://%link_lz_value1%/tp/%link_lz_value2%
curl.exe -k -A "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" https://%link_lz_value1%/tp/%link_lz_value2% 1>tmp\output.txt 2>tmp\output2.txt || type tmp\output2.txt>>%logfile%&& type tmp\output.txt>>%logfile%&& ECHOC {%c_e%}curl解析1失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E curl解析1失败&& pause>nul && ECHO.重试... && goto getlzdirectlink-nopswd
set link_lz_developer_part1=
::for /f "tokens=4 delims='; " %%i in ('find "var tedomain " "tmp\output.txt"') do set link_lz_developer_part1=%%i
for /f "tokens=4 delims='; " %%i in ('find "var vkjxld " "tmp\output.txt"') do set link_lz_developer_part1=%%i
if "%link_lz_developer_part1%"=="" type tmp\output.txt>>%logfile%& ECHOC {%c_e%}curl解析1的link_lz_developer_part1结果为空.{%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E curl解析1的link_lz_developer_part1结果为空& pause>nul & ECHO.重试... & goto getlzdirectlink-nopswd
set link_lz_developer_part2=
::for /f "tokens=4 delims='; " %%i in ('find "var domianload " "tmp\output.txt"') do set link_lz_developer_part2=%%i
for /f "tokens=4 delims='; " %%i in ('find "var hyggid " "tmp\output.txt"') do set link_lz_developer_part2=%%i
if "%link_lz_developer_part2%"=="" type tmp\output.txt>>%logfile%& ECHOC {%c_e%}curl解析2的link_lz_developer_part2结果为空.{%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E curl解析2的link_lz_developer_part2结果为空& pause>nul & ECHO.重试... & goto getlzdirectlink-nopswd
call log %logger% I 即将解析链接:"%link_lz_developer_part1%%link_lz_developer_part2%"
curl.exe -i -k -A "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" %link_lz_developer_part1%%link_lz_developer_part2% --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" --header "Accept-Encoding: gzip, deflate" --header "Accept-Language: zh-CN,zh;q=0.9" --header "Cache-Control: no-cache" --header "Connection: keep-alive" --header "Pragma: no-cache" --header "Upgrade-Insecure-Requests: 1" 1>tmp\output.txt 2>tmp\output2.txt || type tmp\output2.txt>>%logfile%&& type tmp\output.txt>>%logfile%&& ECHOC {%c_e%}curl解析2失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E curl解析2失败&& pause>nul && ECHO.重试... && goto getlzdirectlink-nopswd
for /f "tokens=2 delims= " %%i in ('find "location: " "tmp\output.txt"') do set link_direct="%%i"
::if "%link_direct%"=="" type tmp\output.txt>>%logfile%& ECHOC {%c_e%}curl解析2结果为空.{%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E curl解析2结果为空& pause>nul & ECHO.重试... & goto getlzdirectlink-nopswd
call log %logger% I 获得直链:%link_direct%
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
call log %logger% I 即将解析链接:https://%link_lz_value1%/tp/%link_lz_value2%.密码:%link_lz_pswd%
curl.exe -k -A "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" https://%link_lz_value1%/tp/%link_lz_value2% 1>tmp\output.txt 2>tmp\output2.txt || type tmp\output2.txt>>%logfile%&& type tmp\output.txt>>%logfile%&& ECHOC {%c_e%}curl解析1失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E curl解析1失败&& pause>nul && ECHO.重试... && goto getlzdirectlink-pswd
::for /f "tokens=4 delims=' " %%i in ('type tmp\output.txt ^| find "var postsign"') do set link_lz_postsign=%%i
for /f "tokens=4 delims=' " %%i in ('type tmp\output.txt ^| find "var vidksek"') do set link_lz_postsign=%%i
curl.exe -k -A "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" -e "https://syxz.lanzoub.com" https://%link_lz_value1%/ajaxm.php --data-raw "action=downprocess&sign=%link_lz_postsign%&p=%link_lz_pswd%" 1>tmp\output.txt 2>tmp\output2.txt || type tmp\output2.txt>>%logfile%&& type tmp\output.txt>>%logfile%&& ECHOC {%c_e%}curl解析2失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E curl解析2失败&& pause>nul && ECHO.重试... && goto getlzdirectlink-pswd
busybox.exe sed -i "s/\"/ /g" tmp\output.txt
if not "%errorlevel%"=="0" ECHOC {%c_e%}sed处理1失败.{%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E sed处理1失败& pause>nul & ECHO.重试... & goto getlzdirectlink-pswd
busybox.exe sed -i "s/\\//g" tmp\output.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}sed处理2失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E sed处理2失败&& pause>nul && ECHO.重试... && goto getlzdirectlink-pswd
set link_lz_developer_part1=& set link_lz_developer_part2=
for /f "tokens=6,10 delims= " %%a in (tmp\output.txt) do (set link_lz_developer_part1=%%a& set link_lz_developer_part2=%%b)
if "%link_lz_developer_part1%"=="" type tmp\output.txt>>%logfile%& ECHOC {%c_e%}link_lz_developer_part1结果为空.{%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E link_lz_developer_part1结果为空& pause>nul & ECHO.重试... & goto getlzdirectlink-pswd
if "%link_lz_developer_part2%"=="" type tmp\output.txt>>%logfile%& ECHOC {%c_e%}link_lz_developer_part2结果为空.{%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E link_lz_developer_part2结果为空& pause>nul & ECHO.重试... & goto getlzdirectlink-pswd
call log %logger% I 即将解析链接:"%link_lz_developer_part1%/file/%link_lz_developer_part2%"
curl.exe -i -k -A "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" %link_lz_developer_part1%/file/%link_lz_developer_part2% --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" --header "Accept-Encoding: gzip, deflate" --header "Accept-Language: zh-CN,zh;q=0.9" --header "Cache-Control: no-cache" --header "Connection: keep-alive" --header "Pragma: no-cache" --header "Upgrade-Insecure-Requests: 1" 1>tmp\output.txt 2>tmp\output2.txt || type tmp\output2.txt>>%logfile%&& type tmp\output.txt>>%logfile%&& ECHOC {%c_e%}curl解析3失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E curl解析3失败&& pause>nul && ECHO.重试... && goto getlzdirectlink-pswd
for /f "tokens=2 delims= " %%i in ('find "location: " "tmp\output.txt"') do set link_direct="%%i"
call log %logger% I 获得直链:%link_direct%
goto :eof


:startdl
call log %logger% I 即将下载%link_direct%到tmp\dl\bffdl.tmp
if exist tmp\dl rd /s /q tmp\dl 1>nul 2>>%logfile% || ECHOC {%c_e%}删除tmp\dl失败{%c_i%}{\n}&& call log %logger% E 删除tmp\dl失败
md tmp\dl 1>nul 2>>%logfile% || ECHOC {%c_e%}创建tmp\dl失败{%c_i%}{\n}&& call log %logger% E 创建tmp\dl失败
aria2c.exe --max-concurrent-downloads=16 --max-connection-per-server=16 --split=16 --file-allocation=none --out=tmp\dl\bffdl.tmp %link_direct% 1>>%logfile% 2>&1 || ECHOC {%c_e%}下载失败{%c_i%}{\n}&& call log %logger% E 本次下载失败&& set result=n&& goto :eof
if not "%chkfield%"=="" find "%chkfield%" "tmp\dl\bffdl.tmp" 1>nul 2>nul || ECHOC {%c_e%}检验失败,找不到指定的字符,下载失败{%c_i%}{\n}&& call log %logger% E 检验失败.找不到指定的字符:%chkfield%.下载失败&& set result=n&& goto :eof
for /f "tokens=3 delims= " %%i in ('dir tmp\dl /-C /-N /A:-D ^| find "bffdl"') do set var=%%i
if %var% LEQ 10240 (
    find "code" "tmp\dl\bffdl.tmp" | find ": 400," 1>nul 2>nul && ECHOC {%c_e%}检验失败,发现报错,下载失败{%c_i%}{\n}&& call log %logger% E 检验失败.发现报错.下载失败&& set result=n&& goto :eof
    find "code" "tmp\dl\bffdl.tmp" | find ": 201," 1>nul 2>nul && ECHOC {%c_e%}检验失败,发现报错,下载失败{%c_i%}{\n}&& call log %logger% E 检验失败.发现报错.下载失败&& set result=n&& goto :eof
    find "path not found" "tmp\dl\bffdl.tmp" | find ":500," 1>nul 2>nul && ECHOC {%c_e%}检验失败,找不到云端路径,下载失败{%c_i%}{\n}&& call log %logger% E 检验失败.找不到云端路径.下载失败&& set result=n&& goto :eof
    find "could not be found" "tmp\dl\bffdl.tmp" | find ":500," 1>nul 2>nul && ECHOC {%c_e%}检验失败,发现报错,下载失败{%c_i%}{\n}&& call log %logger% E 检验失败.发现报错.下载失败&& set result=n&& goto :eof
    find "failed to get file" "tmp\dl\bffdl.tmp" | find ":500," 1>nul 2>nul && ECHOC {%c_e%}检验失败,找不到云端文件,下载失败{%c_i%}{\n}&& call log %logger% E 检验失败.找不到云端文件.下载失败&& set result=n&& goto :eof
    find "Loading storage, please wait" "tmp\dl\bffdl.tmp" | find ":500," 1>nul 2>nul && ECHOC {%c_e%}检验失败,云存储还未加载完毕,下载失败{%c_i%}{\n}&& call log %logger% E 检验失败.云存储还未加载完毕.下载失败&& set result=n&& goto :eof)
move /Y tmp\dl\bffdl.tmp %filepath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}移动失败{%c_i%}{\n}&& call log %logger% E 移动失败&& set result=n&& goto :eof
set result=y& call log %logger% I 本次下载成功
goto :eof


