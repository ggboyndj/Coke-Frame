::call imgkit magiskpatch boot文件完整路径 新boot文件路径 25200或面具apk路径                             noprompt(可选)
::            recinst     boot文件完整路径 新boot文件路径 recovery文件完整路径(可以是img或ramdisk.cpio)   noprompt(可选)

@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%



:MAGISKPATCH
SETLOCAL
set logger=imgkit.bat-magiskpatch
set bootpath=%var2%& set outputpath=%var3%& set zippath=%var4%& set mode=%var5%
if "%zippath%"=="" set zippath=tool\Android\magisk\25200.apk
if "%zippath%"=="25200" set zippath=tool\Android\magisk\25200.apk
call log %logger% I 接收变量:bootpath:%bootpath%.outputpath:%outputpath%.zippath:%zippath%.mode:%mode%
::检查是否存在
if not exist %bootpath% ECHOC {%c_e%}找不到%bootpath%{%c_i%}{\n}& call log %logger% F 找不到%bootpath%& goto FATAL
if not exist %zippath% ECHOC {%c_e%}找不到%zippath%{%c_i%}{\n}& call log %logger% F 找不到%zippath%& goto FATAL
if not "%mode%"=="noprompt" (if exist %outputpath% ECHOC {%c_w%}已存在%outputpath%, 继续将覆盖此文件. {%c_h%}按任意键继续...{%c_i%}{\n}& call log %logger% W 已存在%outputpath%.继续将覆盖此文件& pause>nul & ECHO.继续...)
::清理临时文件夹
if exist tmp\imgkit-magiskpatch rd /s /q tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}删除tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% E 删除tmp\imgkit-magiskpatch失败
md tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}创建tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% E 创建tmp\imgkit-magiskpatch失败
::设置修补选项
::- 保留AVB2.0, dm-verity (26300-17000)
set KEEPVERITY=true
::- 保持强制加密 (26300-17000)
set KEEPFORCEENCRYPT=true
::- 修补vbmeta标记 (26300-24000)
set PATCHVBMETAFLAG=false
::- 安装到Recovery (26300-19100)(注: 在23000及更低的版本, 当boot解包出现recovery_dtbo文件时, 此项将强制被设为true)
set RECOVERYMODE=false
::- 强开rootfs (26300-26000)
set LEGACYSAR=true
set SYSTEM_ROOT=%LEGACYSAR%
::- 处理器架构 (26300-19000支持64位, 18100-17000不区分或不支持64位)
::  arm_64   arm_32   x86_64   x86_32
set arch=arm_64
::加载自定义选项(如果有的话)
if exist tool\Android\magisk\config.bat call tool\Android\magisk\config.bat
::记录最终选项
call log %logger% I 本次修补选项:KEEPVERITY:%KEEPVERITY%.KEEPFORCEENCRYPT:%KEEPFORCEENCRYPT%.PATCHVBMETAFLAG:%PATCHVBMETAFLAG%.RECOVERYMODE:%RECOVERYMODE%.LEGACYSAR:%LEGACYSAR%.SYSTEM_ROOT:%SYSTEM_ROOT%.arch:%arch%
:MAGISKPATCH-1
::准备Magisk组件
call log %logger% I 准备Magisk组件
if "%arch%"=="arm_64" (
    7z.exe e -aoa -otmp\imgkit-magiskpatch -slp -y -ir!lib\armeabi-v7a\libmagiskinit.so -ir!lib\armeabi-v7a\libmagisk32.so -ir!lib\armeabi-v7a\libmagisk64.so -ir!arm\magiskinit   %zippath% 1>>%logfile% 2>&1
    7z.exe e -aoa -otmp\imgkit-magiskpatch -slp -y -ir!lib\arm64-v8a\libmagiskinit.so                                      -ir!lib\arm64-v8a\libmagisk64.so   -ir!arm\magiskinit64 %zippath% 1>>%logfile% 2>&1)
if "%arch%"=="arm_32" (
    7z.exe e -aoa -otmp\imgkit-magiskpatch -slp -y -ir!lib\armeabi-v7a\libmagiskinit.so -ir!lib\armeabi-v7a\libmagisk32.so                                    -ir!arm\magiskinit   %zippath% 1>>%logfile% 2>&1)
if "%arch%"=="x86_64" (
    7z.exe e -aoa -otmp\imgkit-magiskpatch -slp -y -ir!lib\x86\libmagiskinit.so         -ir!lib\x86\libmagisk32.so         -ir!lib\x86\libmagisk64.so         -ir!x86\magiskinit   %zippath% 1>>%logfile% 2>&1
    7z.exe e -aoa -otmp\imgkit-magiskpatch -slp -y -ir!lib\x86_64\libmagiskinit.so                                         -ir!lib\x86_64\libmagisk64.so      -ir!x86\magiskinit64 %zippath% 1>>%logfile% 2>&1)
if "%arch%"=="x86_32" (
    7z.exe e -aoa -otmp\imgkit-magiskpatch -slp -y -ir!lib\x86\libmagiskinit.so         -ir!lib\x86\libmagisk32.so                                            -ir!x86\magiskinit   %zippath% 1>>%logfile% 2>&1)
7z.exe e -aoa -otmp\imgkit-magiskpatch -slp -y -ir!assets\stub.apk %zippath% 1>>%logfile% 2>&1
if exist tmp\imgkit-magiskpatch\magiskinit64 move /Y tmp\imgkit-magiskpatch\magiskinit64 tmp\imgkit-magiskpatch\magiskinit 1>>%logfile% 2>&1 || ECHOC {%c_e%}移动tmp\imgkit-magiskpatch\magiskinit64到tmp\imgkit-magiskpatch\magiskinit失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 移动tmp\imgkit-magiskpatch\magiskinit64到tmp\imgkit-magiskpatch\magiskinit失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-1
::if exist tmp\imgkit-magiskpatch\magiskinit (
::    7z.exe e -t#:e -aoa -otmp\imgkit-magiskpatch -slp -y -ir!2.xz tmp\imgkit-magiskpatch\magiskinit 1>>%logfile% 2>&1 || ECHOC {%c_e%}解压tmp\imgkit-magiskpatch\magiskinit失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 解压tmp\imgkit-magiskpatch\magiskinit失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-1
::    7z.exe e -aoa -otmp\imgkit-magiskpatch -slp -y -ir!2 tmp\imgkit-magiskpatch\2.xz 1>>%logfile% 2>&1 || ECHOC {%c_e%}解压tmp\imgkit-magiskpatch\2.xz失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 解压tmp\imgkit-magiskpatch\2.xz失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-1
::    move /Y tmp\imgkit-magiskpatch\2 tmp\imgkit-magiskpatch\magisk 1>>%logfile% 2>&1 || ECHOC {%c_e%}移动tmp\imgkit-magiskpatch\2到tmp\imgkit-magiskpatch\magisk失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 移动tmp\imgkit-magiskpatch\2到tmp\imgkit-magiskpatch\magisk失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-1)
if exist tmp\imgkit-magiskpatch\libmagiskinit.so move /Y tmp\imgkit-magiskpatch\libmagiskinit.so tmp\imgkit-magiskpatch\magiskinit 1>>%logfile% 2>&1 || ECHOC {%c_e%}移动tmp\imgkit-magiskpatch\libmagiskinit.so到tmp\imgkit-magiskpatch\magiskinit失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 移动tmp\imgkit-magiskpatch\libmagiskinit.so到tmp\imgkit-magiskpatch\magiskinit失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-1
if exist tmp\imgkit-magiskpatch\libmagisk32.so magiskboot.exe compress=xz tmp\imgkit-magiskpatch\libmagisk32.so tmp\imgkit-magiskpatch\magisk32.xz 1>>%logfile% 2>&1 || ECHOC {%c_e%}压缩tmp\imgkit-magiskpatch\libmagisk32.so失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 压缩tmp\imgkit-magiskpatch\libmagisk32.so失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-1
if exist tmp\imgkit-magiskpatch\libmagisk64.so magiskboot.exe compress=xz tmp\imgkit-magiskpatch\libmagisk64.so tmp\imgkit-magiskpatch\magisk64.xz 1>>%logfile% 2>&1 || ECHOC {%c_e%}压缩tmp\imgkit-magiskpatch\libmagisk64.so失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 压缩tmp\imgkit-magiskpatch\libmagisk64.so失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-1
if exist tmp\imgkit-magiskpatch\stub.apk magiskboot.exe compress=xz tmp\imgkit-magiskpatch\stub.apk tmp\imgkit-magiskpatch\stub.xz 1>>%logfile% 2>&1 || ECHOC {%c_e%}压缩tmp\imgkit-magiskpatch\stub.apk失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 压缩tmp\imgkit-magiskpatch\stub.apk失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-1
::读取Magisk版本
call log %logger% I 读取Magisk版本
7z.exe e -aoa -otmp\imgkit-magiskpatch -slp -y -ir!assets\util_functions.sh -ir!common\util_functions.sh %zippath% 1>>%logfile% 2>&1
set magiskver=
for /f "tokens=2 delims== " %%a in ('type tmp\imgkit-magiskpatch\util_functions.sh ^| find "MAGISK_VER_CODE="') do set magiskver=%%a
for /f "tokens=2 delims== " %%a in ('type tmp\imgkit-magiskpatch\util_functions.sh ^| find "MAGISK_VER="') do set var=%%a
set magiskver_show=%var:~1,-1%
call log %logger% I Magisk版本:%magiskver%.Magisk显示版本:%magiskver_show%
::其他版本的Magisk支持
set vivo_suu_patch=n
if "%magiskver%"=="20201" (if "%magiskver_show%"=="20.3-15bd2da8" goto MAGISKPATCH-phh-20201-20.3-15bd2da8)
if "%magiskver%"=="25200" (if "%magiskver_show%"=="25.2-vivo_suu" set vivo_suu_patch=y& goto MAGISKPATCH-25200)
if "%magiskver%"=="26104" (if "%magiskver_show%"=="26.1-vivo_suu" set vivo_suu_patch=y& goto MAGISKPATCH-26200)
if "%magiskver%"=="26404" (if "%magiskver_show%"=="R65A24840suu-delta" set vivo_suu_patch=y& goto MAGISKPATCH-26300)
if "%magiskver%"=="27001" (if "%magiskver_show%"=="R65C0A20Asuu-kitsune" set vivo_suu_patch=y& goto MAGISKPATCH-26300)
::Magisk官方正式版支持
if "%magiskver%"=="27000" goto MAGISKPATCH-26300
if "%magiskver%"=="26400" goto MAGISKPATCH-26300
if "%magiskver%"=="26300" goto MAGISKPATCH-26300
if "%magiskver%"=="26200" goto MAGISKPATCH-26200
if "%magiskver%"=="26100" goto MAGISKPATCH-26000
if "%magiskver%"=="26000" goto MAGISKPATCH-26000
if "%magiskver%"=="25200" goto MAGISKPATCH-25200
if "%magiskver%"=="25100" goto MAGISKPATCH-25200
if "%magiskver%"=="25000" goto MAGISKPATCH-25000
if "%magiskver%"=="24300" goto MAGISKPATCH-25000
if "%magiskver%"=="24200" goto MAGISKPATCH-25000
if "%magiskver%"=="24100" goto MAGISKPATCH-25000
if "%magiskver%"=="24000" goto MAGISKPATCH-25000
if "%magiskver%"=="23000" goto MAGISKPATCH-23000
if "%magiskver%"=="22100" goto MAGISKPATCH-23000
if "%magiskver%"=="22000" goto MAGISKPATCH-23000
if "%magiskver%"=="21400" goto MAGISKPATCH-21400
if "%magiskver%"=="21300" goto MAGISKPATCH-21400
if "%magiskver%"=="21200" goto MAGISKPATCH-21200
if "%magiskver%"=="21100" goto MAGISKPATCH-21200
if "%magiskver%"=="21000" goto MAGISKPATCH-21200
if "%magiskver%"=="20400" goto MAGISKPATCH-21200
if "%magiskver%"=="20300" goto MAGISKPATCH-21200
if "%magiskver%"=="20200" goto MAGISKPATCH-21200
if "%magiskver%"=="20100" goto MAGISKPATCH-21200
if "%magiskver%"=="20000" goto MAGISKPATCH-21200
if "%magiskver%"=="19400" goto MAGISKPATCH-19400
if "%magiskver%"=="19300" goto MAGISKPATCH-19400
if "%magiskver%"=="19200" goto MAGISKPATCH-19400
if "%magiskver%"=="19100" goto MAGISKPATCH-19400
if "%magiskver%"=="19000" goto MAGISKPATCH-19000
if "%magiskver%"=="18100" goto MAGISKPATCH-18100
if "%magiskver%"=="18000" goto MAGISKPATCH-18100
if "%magiskver%"=="17300" goto MAGISKPATCH-18100
if "%magiskver%"=="17200" goto MAGISKPATCH-17200
if "%magiskver%"=="17100" goto MAGISKPATCH-17200
if "%magiskver%"=="17000" goto MAGISKPATCH-17200
ECHOC {%c_e%}未支持的Magisk版本(%magiskver_show% %magiskver%). 请QQ联系1330250642适配.{%c_i%}{\n}& goto FATAL

:MAGISKPATCH-26300
::检查Magisk组件
call log %logger% I 检查Magisk组件
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magiskinit. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26300
if not exist tmp\imgkit-magiskpatch\magisk32.xz ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk32.xz. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk32.xz&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26300
if "%arch:~-2,2%"=="64" (if not exist tmp\imgkit-magiskpatch\magisk64.xz ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk64.xz. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk64.xz&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26300)
if not exist tmp\imgkit-magiskpatch\stub.xz ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\stub.xz. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\stub.xz&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26300
::解包boot
call log %logger% I 解包%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}解包%bootpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 解包%bootpath%失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-26300
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
::测试ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 无ramdisk.cpio
    set STATUS=0& set SKIP_BACKUP=#& goto MAGISKPATCH-26300-MODE0)
call log %logger% I 测试ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
set SKIP_BACKUP=
if "%STATUS%"=="0" goto MAGISKPATCH-26300-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-26300-MODE1
ECHOC {%c_e%}测试ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 测试ramdisk.cpio失败:%var%& pause>nul & ECHO.重试... & goto MAGISKPATCH-26300
::模式0-Stock boot image detected
:MAGISKPATCH-26300-MODE0
call log %logger% I 模式0
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 备份ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26300-MODE0)
goto MAGISKPATCH-26300-1
::模式1-Magisk patched boot image detected
:MAGISKPATCH-26300-MODE1
call log %logger% I 模式1
call log %logger% I 还原ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe cpio ramdisk.cpio "extract .backup/.magisk config.orig" "restore" 1>>%logfile% 2>&1 || ECHOC {%c_e%}还原ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 还原ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-26300-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
call log %logger% I 备份ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26300-MODE1
goto MAGISKPATCH-26300-1
:MAGISKPATCH-26300-1
if not exist tmp\imgkit-magiskpatch\config.orig goto MAGISKPATCH-26300-2
for /f "tokens=2 delims== " %%a in ('type tmp\imgkit-magiskpatch\config.orig ^| find "SHA1="') do set SHA1=%%a
:MAGISKPATCH-26300-2
::修补ramdisk.cpio
call log %logger% I 修补ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
if "%arch:~-2,2%"=="64" (set var=) else (set var=#)
magiskboot.exe cpio ramdisk.cpio "add 0750 init magiskinit" "mkdir 0750 overlay.d" "mkdir 0750 overlay.d/sbin" "add 0644 overlay.d/sbin/magisk32.xz magisk32.xz" "%var% add 0644 overlay.d/sbin/magisk64.xz magisk64.xz" "add 0644 overlay.d/sbin/stub.xz stub.xz" "patch" "%SKIP_BACKUP% backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}修补ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 修补ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-26300-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-26300-3
::测试和修补dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
set dtbname=
set result=y
if exist dtb set dtbname=dtb& call :magiskpatch-26300-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26300-3
if exist kernel_dtb set dtbname=kernel_dtb& call :magiskpatch-26300-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26300-3
if exist extra set dtbname=extra& call :magiskpatch-26300-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26300-3
if "%dtbname%"=="" call log %logger% I 无dtb或kernel_dtb或extra
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-26300-4
:magiskpatch-26300-dtb
call log %logger% I 测试%dtbname%
magiskboot.exe dtb %dtbname% test 1>>%logfile% 2>&1 || set result=n&& ECHOC {%c_e%}测试%dtbname%失败. 可能boot已被版本过旧的Magisk修补过. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 测试%dtbname%失败.可能boot已被版本过旧的Magisk修补过&& pause>nul && ECHO.重试... && goto :eof
call log %logger% I 尝试修补%dtbname%
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E 修补%dtbname%失败
goto :eof
:MAGISKPATCH-26300-4
::尝试修补kernel
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
if exist kernel set PATCHEDKERNEL=false
if exist kernel (
    call log %logger% I 尝试修补kernel.若目标字符串不存在则报错属于正常现象
    if "%vivo_suu_patch%"=="y" (
        call log %logger% I 尝试修补kernel-patch-vivo-do_mount_check
        magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E patch-vivo-do_mount_check失败)
    call log %logger% I 尝试修补kernel-移除三星RKP
    magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E 移除三星RKP失败
    call log %logger% I 尝试修补kernel-移除三星defex
    magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E 移除三星defex失败
    if "%LEGACYSAR%"=="true" (
        call log %logger% I 尝试修补kernel-强制开启rootfs
        magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E 强制开启rootfs失败))
if exist kernel (if "%PATCHEDKERNEL%"=="false" call log %logger% I kernel未修改.将删除kernel & del /F /Q kernel 1>>%logfile% 2>&1 || ECHOC {%c_e%}删除kernel失败{%c_i%}{\n}&& call log %logger% F 删除kernel失败&& goto FATAL)
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-26200
::检查Magisk组件
call log %logger% I 检查Magisk组件
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magiskinit. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26200
if not exist tmp\imgkit-magiskpatch\magisk32.xz ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk32.xz. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk32.xz&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26200
if "%arch:~-2,2%"=="64" (if not exist tmp\imgkit-magiskpatch\magisk64.xz ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk64.xz. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk64.xz&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26200)
if not exist tmp\imgkit-magiskpatch\stub.xz ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\stub.xz. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\stub.xz&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26200
::解包boot
call log %logger% I 解包%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}解包%bootpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 解包%bootpath%失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-26200
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
::测试ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 无ramdisk.cpio
    set STATUS=0& set SKIP_BACKUP=#& goto MAGISKPATCH-26200-MODE0)
call log %logger% I 测试ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
set SKIP_BACKUP=
if "%STATUS%"=="0" goto MAGISKPATCH-26200-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-26200-MODE1
ECHOC {%c_e%}测试ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 测试ramdisk.cpio失败:%var%& pause>nul & ECHO.重试... & goto MAGISKPATCH-26200
::模式0-Stock boot image detected
:MAGISKPATCH-26200-MODE0
call log %logger% I 模式0
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 备份ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26200-MODE0)
goto MAGISKPATCH-26200-1
::模式1-Magisk patched boot image detected
:MAGISKPATCH-26200-MODE1
call log %logger% I 模式1
call log %logger% I 还原ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe cpio ramdisk.cpio "extract .backup/.magisk config.orig" "restore" 1>>%logfile% 2>&1 || ECHOC {%c_e%}还原ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 还原ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-26200-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
call log %logger% I 备份ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26200-MODE1
goto MAGISKPATCH-26200-1
:MAGISKPATCH-26200-1
if not exist tmp\imgkit-magiskpatch\config.orig goto MAGISKPATCH-26200-2
for /f "tokens=2 delims== " %%a in ('type tmp\imgkit-magiskpatch\config.orig ^| find "SHA1="') do set SHA1=%%a
:MAGISKPATCH-26200-2
::修补ramdisk.cpio
call log %logger% I 修补ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.PATCHVBMETAFLAG=%PATCHVBMETAFLAG%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
if "%arch:~-2,2%"=="64" (set var=) else (set var=#)
magiskboot.exe cpio ramdisk.cpio "add 0750 init magiskinit" "mkdir 0750 overlay.d" "mkdir 0750 overlay.d/sbin" "add 0644 overlay.d/sbin/magisk32.xz magisk32.xz" "%var% add 0644 overlay.d/sbin/magisk64.xz magisk64.xz" "add 0644 overlay.d/sbin/stub.xz stub.xz" "patch" "%SKIP_BACKUP% backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}修补ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 修补ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-26200-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-26200-3
::测试和修补dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
set dtbname=
set result=y
if exist dtb set dtbname=dtb& call :magiskpatch-26200-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26200-3
if exist kernel_dtb set dtbname=kernel_dtb& call :magiskpatch-26200-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26200-3
if exist extra set dtbname=extra& call :magiskpatch-26200-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26200-3
if "%dtbname%"=="" call log %logger% I 无dtb或kernel_dtb或extra
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-26200-4
:magiskpatch-26200-dtb
call log %logger% I 测试%dtbname%
magiskboot.exe dtb %dtbname% test 1>>%logfile% 2>&1 || set result=n&& ECHOC {%c_e%}测试%dtbname%失败. 可能boot已被版本过旧的Magisk修补过. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 测试%dtbname%失败.可能boot已被版本过旧的Magisk修补过&& pause>nul && ECHO.重试... && goto :eof
call log %logger% I 尝试修补%dtbname%
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E 修补%dtbname%失败
goto :eof
:MAGISKPATCH-26200-4
::尝试修补kernel
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
if exist kernel set PATCHEDKERNEL=false
if exist kernel (
    call log %logger% I 尝试修补kernel.若目标字符串不存在则报错属于正常现象
    if "%vivo_suu_patch%"=="y" (
        call log %logger% I 尝试修补kernel-patch-vivo-do_mount_check
        magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E patch-vivo-do_mount_check失败)
    call log %logger% I 尝试修补kernel-移除三星RKP
    magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E 移除三星RKP失败
    call log %logger% I 尝试修补kernel-移除三星defex
    magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E 移除三星defex失败
    if "%LEGACYSAR%"=="true" (
        call log %logger% I 尝试修补kernel-强制开启rootfs
        magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E 强制开启rootfs失败))
if exist kernel (if "%PATCHEDKERNEL%"=="false" call log %logger% I kernel未修改.将删除kernel & del /F /Q kernel 1>>%logfile% 2>&1 || ECHOC {%c_e%}删除kernel失败{%c_i%}{\n}&& call log %logger% F 删除kernel失败&& goto FATAL)
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-26000
::检查Magisk组件
call log %logger% I 检查Magisk组件
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magiskinit. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26000
if not exist tmp\imgkit-magiskpatch\magisk32.xz ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk32.xz. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk32.xz&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26000
if "%arch:~-2,2%"=="64" (if not exist tmp\imgkit-magiskpatch\magisk64.xz ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk64.xz. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk64.xz&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26000)
if not exist tmp\imgkit-magiskpatch\stub.xz ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\stub.xz. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\stub.xz&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26000
::解包boot
call log %logger% I 解包%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}解包%bootpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 解包%bootpath%失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-26000
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
::测试ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 无ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-26000-MODE0)
call log %logger% I 测试ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-26000-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-26000-MODE1
ECHOC {%c_e%}测试ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 测试ramdisk.cpio失败:%var%& pause>nul & ECHO.重试... & goto MAGISKPATCH-26000
::模式0-Stock boot image detected
:MAGISKPATCH-26000-MODE0
call log %logger% I 模式0
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 备份ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26000-MODE0)
goto MAGISKPATCH-26000-2
::模式1-Magisk patched boot image detected
:MAGISKPATCH-26000-MODE1
call log %logger% I 模式1
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
call log %logger% I 还原ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}还原ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 还原ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-26000-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
call log %logger% I 备份ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-26000-MODE1
goto MAGISKPATCH-26000-2
:MAGISKPATCH-26000-2
::修补ramdisk.cpio
call log %logger% I 修补ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.PATCHVBMETAFLAG=%PATCHVBMETAFLAG%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
call random 16 abcdef0123456789
echo.RANDOMSEED=0x%random__str%|find "RANDOMSEED" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
if "%arch:~-2,2%"=="64" (set var=) else (set var=#)
magiskboot.exe cpio ramdisk.cpio "add 0750 init magiskinit" "mkdir 0750 overlay.d" "mkdir 0750 overlay.d/sbin" "add 0644 overlay.d/sbin/magisk32.xz magisk32.xz" "%var% add 0644 overlay.d/sbin/magisk64.xz magisk64.xz" "add 0644 overlay.d/sbin/stub.xz stub.xz" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}修补ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 修补ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-26000-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-26000-3
::测试和修补dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
set dtbname=
set result=y
if exist dtb set dtbname=dtb& call :magiskpatch-26000-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26000-3
if exist kernel_dtb set dtbname=kernel_dtb& call :magiskpatch-26000-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26000-3
if exist extra set dtbname=extra& call :magiskpatch-26000-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26000-3
if "%dtbname%"=="" call log %logger% I 无dtb或kernel_dtb或extra
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-26000-4
:magiskpatch-26000-dtb
call log %logger% I 测试%dtbname%
magiskboot.exe dtb %dtbname% test 1>>%logfile% 2>&1 || set result=n&& ECHOC {%c_e%}测试%dtbname%失败. 可能boot已被版本过旧的Magisk修补过. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 测试%dtbname%失败.可能boot已被版本过旧的Magisk修补过&& pause>nul && ECHO.重试... && goto :eof
call log %logger% I 尝试修补%dtbname%
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E 修补%dtbname%失败
goto :eof
:MAGISKPATCH-26000-4
::尝试修补kernel
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
if exist kernel set PATCHEDKERNEL=false
if exist kernel (
    call log %logger% I 尝试修补kernel.若目标字符串不存在则报错属于正常现象
    if "%vivo_suu_patch%"=="y" (
        call log %logger% I 尝试修补kernel-patch-vivo-do_mount_check
        magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E patch-vivo-do_mount_check失败)
    call log %logger% I 尝试修补kernel-移除三星RKP
    magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E 移除三星RKP失败
    call log %logger% I 尝试修补kernel-移除三星defex
    magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E 移除三星defex失败
    if "%SYSTEM_ROOT%"=="true" (
        call log %logger% I 尝试修补kernel-强制开启rootfs
        magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E 强制开启rootfs失败))
if exist kernel (if "%PATCHEDKERNEL%"=="false" call log %logger% I kernel未修改.将删除kernel & del /F /Q kernel 1>>%logfile% 2>&1 || ECHOC {%c_e%}删除kernel失败{%c_i%}{\n}&& call log %logger% F 删除kernel失败&& goto FATAL)
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-25200
::检查Magisk组件
call log %logger% I 检查Magisk组件
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magiskinit. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.重试... && goto MAGISKPATCH-25200
if not exist tmp\imgkit-magiskpatch\magisk32.xz ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk32.xz. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk32.xz&& pause>nul && ECHO.重试... && goto MAGISKPATCH-25200
if "%arch:~-2,2%"=="64" (if not exist tmp\imgkit-magiskpatch\magisk64.xz ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk64.xz. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk64.xz&& pause>nul && ECHO.重试... && goto MAGISKPATCH-25200)
::解包boot
call log %logger% I 解包%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}解包%bootpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 解包%bootpath%失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-25200
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
::测试ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 无ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-25200-MODE0)
call log %logger% I 测试ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-25200-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-25200-MODE1
ECHOC {%c_e%}测试ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 测试ramdisk.cpio失败:%var%& pause>nul & ECHO.重试... & goto MAGISKPATCH-25200
::模式0-Stock boot image detected
:MAGISKPATCH-25200-MODE0
call log %logger% I 模式0
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 备份ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-25200-MODE0)
goto MAGISKPATCH-25200-2
::模式1-Magisk patched boot image detected
:MAGISKPATCH-25200-MODE1
call log %logger% I 模式1
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
call log %logger% I 还原ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}还原ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 还原ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-25200-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
call log %logger% I 备份ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-25200-MODE1
goto MAGISKPATCH-25200-2
:MAGISKPATCH-25200-2
::修补ramdisk.cpio
call log %logger% I 修补ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.PATCHVBMETAFLAG=%PATCHVBMETAFLAG%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
if "%arch:~-2,2%"=="64" (set var=) else (set var=#)
magiskboot.exe cpio ramdisk.cpio "add 0750 init magiskinit" "mkdir 0750 overlay.d" "mkdir 0750 overlay.d/sbin" "add 0644 overlay.d/sbin/magisk32.xz magisk32.xz" "%var% add 0644 overlay.d/sbin/magisk64.xz magisk64.xz" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}修补ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 修补ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-25200-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-25200-3
::测试和修补dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
set dtbname=
set result=y
if exist dtb set dtbname=dtb& call :magiskpatch-25200-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-25200-3
if exist kernel_dtb set dtbname=kernel_dtb& call :magiskpatch-25200-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-25200-3
if exist extra set dtbname=extra& call :magiskpatch-25200-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-25200-3
if "%dtbname%"=="" call log %logger% I 无dtb或kernel_dtb或extra
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-25200-4
:magiskpatch-25200-dtb
call log %logger% I 测试%dtbname%
magiskboot.exe dtb %dtbname% test 1>>%logfile% 2>&1 || set result=n&& ECHOC {%c_e%}测试%dtbname%失败. 可能boot已被版本过旧的Magisk修补过. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 测试%dtbname%失败.可能boot已被版本过旧的Magisk修补过&& pause>nul && ECHO.重试... && goto :eof
call log %logger% I 尝试修补%dtbname%
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E 修补%dtbname%失败
goto :eof
:MAGISKPATCH-25200-4
::尝试修补kernel
call log %logger% I 尝试修补kernel.若目标字符串不存在则报错属于正常现象
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I 尝试修补kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_check失败)
call log %logger% I 尝试修补kernel-移除三星RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E 移除三星RKP失败
call log %logger% I 尝试修补kernel-移除三星defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E 移除三星defex失败
call log %logger% I 尝试修补kernel-强制开启rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E 强制开启rootfs失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-25000
::检查Magisk组件
call log %logger% I 检查Magisk组件
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magiskinit. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.重试... && goto MAGISKPATCH-25000
if not exist tmp\imgkit-magiskpatch\magisk32.xz ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk32.xz. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk32.xz&& pause>nul && ECHO.重试... && goto MAGISKPATCH-25000
if "%arch:~-2,2%"=="64" (if not exist tmp\imgkit-magiskpatch\magisk64.xz ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk64.xz. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk64.xz&& pause>nul && ECHO.重试... && goto MAGISKPATCH-25000)
::解包boot
call log %logger% I 解包%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}解包%bootpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 解包%bootpath%失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-25000
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
::测试ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 无ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-25000-MODE0)
call log %logger% I 测试ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-25000-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-25000-MODE1
ECHOC {%c_e%}测试ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 测试ramdisk.cpio失败:%var%& pause>nul & ECHO.重试... & goto MAGISKPATCH-25000
::模式0-Stock boot image detected
:MAGISKPATCH-25000-MODE0
call log %logger% I 模式0
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 备份ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-25000-MODE0)
goto MAGISKPATCH-25000-2
::模式1-Magisk patched boot image detected
:MAGISKPATCH-25000-MODE1
call log %logger% I 模式1
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
call log %logger% I 还原ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}还原ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 还原ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-25000-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
call log %logger% I 备份ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-25000-MODE1
goto MAGISKPATCH-25000-2
:MAGISKPATCH-25000-2
::修补ramdisk.cpio
call log %logger% I 修补ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.PATCHVBMETAFLAG=%PATCHVBMETAFLAG%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
if "%arch:~-2,2%"=="64" (set var=) else (set var=#)
magiskboot.exe cpio ramdisk.cpio "add 0750 init magiskinit" "mkdir 0750 overlay.d" "mkdir 0750 overlay.d/sbin" "add 0644 overlay.d/sbin/magisk32.xz magisk32.xz" "%var% add 0644 overlay.d/sbin/magisk64.xz magisk64.xz" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}修补ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 修补ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-25000-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-25000-3
::尝试修补dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\kernel_dtb set dtbname=kernel_dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if "%dtbname%"=="" (
    call log %logger% I 无dtb或kernel_dtb
    goto MAGISKPATCH-25000-4)
call log %logger% I 尝试修补dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E 修补%dtbname%失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-25000-4
::尝试修补kernel
call log %logger% I 尝试修补kernel.若目标字符串不存在则报错属于正常现象
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I 尝试修补kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_check失败)
call log %logger% I 尝试修补kernel-移除三星RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E 移除三星RKP失败
call log %logger% I 尝试修补kernel-移除三星defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E 移除三星defex失败
call log %logger% I 尝试修补kernel-强制开启rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E 强制开启rootfs失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-23000
::检查Magisk组件
call log %logger% I 检查Magisk组件
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magiskinit. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.重试... && goto MAGISKPATCH-23000
if not exist tmp\imgkit-magiskpatch\magisk32.xz ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk32.xz. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk32.xz&& pause>nul && ECHO.重试... && goto MAGISKPATCH-23000
if "%arch:~-2,2%"=="64" (if not exist tmp\imgkit-magiskpatch\magisk64.xz ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk64.xz. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk64.xz&& pause>nul && ECHO.重试... && goto MAGISKPATCH-23000)
::解包boot
call log %logger% I 解包%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}解包%bootpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 解包%bootpath%失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-23000
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
::检查recovery_dtbo
if exist tmp\imgkit-magiskpatch\recovery_dtbo set RECOVERYMODE=true
::测试ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 无ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-23000-MODE0)
call log %logger% I 测试ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-23000-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-23000-MODE1
ECHOC {%c_e%}测试ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 测试ramdisk.cpio失败:%var%& pause>nul & ECHO.重试... & goto MAGISKPATCH-23000
::模式0-Stock boot image detected
:MAGISKPATCH-23000-MODE0
call log %logger% I 模式0
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 备份ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-23000-MODE0)
goto MAGISKPATCH-23000-2
::模式1-Magisk patched boot image detected
:MAGISKPATCH-23000-MODE1
call log %logger% I 模式1
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
call log %logger% I 还原ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}还原ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 还原ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-23000-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
call log %logger% I 备份ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-23000-MODE1
goto MAGISKPATCH-23000-2
:MAGISKPATCH-23000-2
::修补ramdisk.cpio
call log %logger% I 修补ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
if "%arch:~-2,2%"=="64" (set var=) else (set var=#)
magiskboot.exe cpio ramdisk.cpio "add 0750 init magiskinit" "mkdir 0750 overlay.d" "mkdir 0750 overlay.d/sbin" "add 0644 overlay.d/sbin/magisk32.xz magisk32.xz" "%var% add 0644 overlay.d/sbin/magisk64.xz magisk64.xz" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}修补ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 修补ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-23000-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-23000-3
::尝试修补dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\kernel_dtb set dtbname=kernel_dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if "%dtbname%"=="" (
    call log %logger% I 无dtb或kernel_dtb
    goto MAGISKPATCH-23000-4)
call log %logger% I 尝试修补dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E 修补%dtbname%失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-23000-4
::尝试修补kernel
call log %logger% I 尝试修补kernel.若目标字符串不存在则报错属于正常现象
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I 尝试修补kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_check失败)
call log %logger% I 尝试修补kernel-移除三星RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E 移除三星RKP失败
call log %logger% I 尝试修补kernel-移除三星defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E 移除三星defex失败
call log %logger% I 尝试修补kernel-强制开启rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E 强制开启rootfs失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-21400
::检查Magisk组件
call log %logger% I 检查Magisk组件
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magiskinit. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.重试... && goto MAGISKPATCH-21400
::if not exist tmp\imgkit-magiskpatch\magisk ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk&& pause>nul && ECHO.重试... && goto MAGISKPATCH-21400
::解包boot
call log %logger% I 解包%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}解包%bootpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 解包%bootpath%失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-21400
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
::检查recovery_dtbo
if exist tmp\imgkit-magiskpatch\recovery_dtbo set RECOVERYMODE=true
::测试ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 无ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-21400-MODE0)
call log %logger% I 测试ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-21400-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-21400-MODE1
ECHOC {%c_e%}测试ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 测试ramdisk.cpio失败:%var%& pause>nul & ECHO.重试... & goto MAGISKPATCH-21400
::模式0-Stock boot image detected
:MAGISKPATCH-21400-MODE0
call log %logger% I 模式0
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 备份ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-21400-MODE0)
goto MAGISKPATCH-21400-2
::模式1-Magisk patched boot image detected
:MAGISKPATCH-21400-MODE1
call log %logger% I 模式1
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
call log %logger% I 还原ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}还原ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 还原ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-21400-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
call log %logger% I 备份ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-21400-MODE1
goto MAGISKPATCH-21400-2
:MAGISKPATCH-21400-2
::修补ramdisk.cpio
call log %logger% I 修补ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
magiskboot.exe cpio ramdisk.cpio "add 750 init magiskinit" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}修补ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 修补ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-21400-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-21400-3
::尝试修补dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\kernel_dtb set dtbname=kernel_dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if "%dtbname%"=="" (
    call log %logger% I 无dtb或kernel_dtb
    goto MAGISKPATCH-21400-4)
call log %logger% I 尝试修补dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E 修补%dtbname%失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-21400-4
::尝试修补kernel
call log %logger% I 尝试修补kernel.若目标字符串不存在则报错属于正常现象
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I 尝试修补kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_check失败)
call log %logger% I 尝试修补kernel-移除三星RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E 移除三星RKP失败
call log %logger% I 尝试修补kernel-移除三星defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E 移除三星defex失败
call log %logger% I 尝试修补kernel-强制开启rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E 强制开启rootfs失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-21200
::检查Magisk组件
call log %logger% I 检查Magisk组件
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magiskinit. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.重试... && goto MAGISKPATCH-21200
::if not exist tmp\imgkit-magiskpatch\magisk ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk&& pause>nul && ECHO.重试... && goto MAGISKPATCH-21200
::解包boot
call log %logger% I 解包%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}解包%bootpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 解包%bootpath%失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-21200
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
::检查recovery_dtbo
if exist tmp\imgkit-magiskpatch\recovery_dtbo set RECOVERYMODE=true
::测试ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 无ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-21200-MODE0)
call log %logger% I 测试ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-21200-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-21200-MODE1
ECHOC {%c_e%}测试ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 测试ramdisk.cpio失败:%var%& pause>nul & ECHO.重试... & goto MAGISKPATCH-21200
::模式0-Stock boot image detected
:MAGISKPATCH-21200-MODE0
call log %logger% I 模式0
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 备份ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-21200-MODE0)
goto MAGISKPATCH-21200-2
::模式1-Magisk patched boot image detected
:MAGISKPATCH-21200-MODE1
call log %logger% I 模式1
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
call log %logger% I 还原ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}还原ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 还原ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-21200-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
call log %logger% I 备份ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-21200-MODE1
goto MAGISKPATCH-21200-2
:MAGISKPATCH-21200-2
::修补ramdisk.cpio
call log %logger% I 修补ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
magiskboot.exe cpio ramdisk.cpio "add 750 init magiskinit" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}修补ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 修补ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-21200-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-21200-3
::尝试修补dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\kernel_dtb set dtbname=kernel_dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if exist tmp\imgkit-magiskpatch\recovery_dtbo set dtbname=recovery_dtbo
if "%dtbname%"=="" (
    call log %logger% I 无dtb
    goto MAGISKPATCH-21200-4)
call log %logger% I 尝试修补dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E 修补%dtbname%失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-21200-4
::尝试修补kernel
call log %logger% I 尝试修补kernel.若目标字符串不存在则报错属于正常现象
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I 尝试修补kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_check失败)
call log %logger% I 尝试修补kernel-移除三星RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E 移除三星RKP失败
call log %logger% I 尝试修补kernel-移除三星defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E 移除三星defex失败
call log %logger% I 尝试修补kernel-强制开启rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E 强制开启rootfs失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-19400
::检查Magisk组件
call log %logger% I 检查Magisk组件
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magiskinit. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.重试... && goto MAGISKPATCH-19400
::if not exist tmp\imgkit-magiskpatch\magisk ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk&& pause>nul && ECHO.重试... && goto MAGISKPATCH-19400
::解包boot
call log %logger% I 解包%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}解包%bootpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 解包%bootpath%失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-19400
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
::检查recovery_dtbo
if exist tmp\imgkit-magiskpatch\recovery_dtbo set RECOVERYMODE=true
::测试ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 无ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-19400-MODE0)
call log %logger% I 测试ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-19400-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-19400-MODE1
ECHOC {%c_e%}测试ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 测试ramdisk.cpio失败:%var%& pause>nul & ECHO.重试... & goto MAGISKPATCH-19400
::模式0-Stock boot image detected
:MAGISKPATCH-19400-MODE0
call log %logger% I 模式0
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 备份ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-19400-MODE0)
goto MAGISKPATCH-19400-2
::模式1-Magisk patched boot image detected
:MAGISKPATCH-19400-MODE1
call log %logger% I 模式1
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
call log %logger% I 还原ramdisk.cpio
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}还原ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 还原ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-19400-MODE1
call log %logger% I 检查ramdisk.cpio中是否存在init.rc
magiskboot.exe cpio ramdisk.cpio "exists init.rc" 1>>%logfile% 2>&1
if "%errorlevel%"=="0" (
    call log %logger% I ramdisk.cpio中存在init.rc.备份ramdisk.cpio
    copy /Y ramdisk.cpio ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-19400-MODE1
) else (
    call log %logger% I ramdisk.cpio中不存在init.rc.删除ramdisk.cpio
    del /F /Q ramdisk.cpio 1>>%logfile% 2>&1 || ECHOC {%c_e%}删除ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 删除ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-19400-MODE1)
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-19400-2
:MAGISKPATCH-19400-2
::修补ramdisk.cpio
call log %logger% I 修补ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
magiskboot.exe cpio ramdisk.cpio "add 750 init magiskinit" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}修补ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 修补ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-19400-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-19400-3
if "%KEEPVERITY%"=="true" (
    call log %logger% I 保持校验.跳过修补dtb
    goto MAGISKPATCH-19400-4)
::尝试修补dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\kernel_dtb set dtbname=kernel_dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if exist tmp\imgkit-magiskpatch\recovery_dtbo set dtbname=recovery_dtbo
if "%dtbname%"=="" (
    call log %logger% I 无dtb
    goto MAGISKPATCH-19400-4)
call log %logger% I 尝试修补dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E 修补%dtbname%失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-19400-4
::尝试修补kernel
call log %logger% I 尝试修补kernel.若目标字符串不存在则报错属于正常现象
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I 尝试修补kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_check失败)
call log %logger% I 尝试修补kernel-移除三星RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E 移除三星RKP失败
call log %logger% I 尝试修补kernel-移除三星defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E 移除三星defex失败
call log %logger% I 尝试修补kernel-强制开启rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E 强制开启rootfs失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-19000
::检查Magisk组件
call log %logger% I 检查Magisk组件
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magiskinit. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.重试... && goto MAGISKPATCH-19000
::if not exist tmp\imgkit-magiskpatch\magisk ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk&& pause>nul && ECHO.重试... && goto MAGISKPATCH-19000
::解包boot
call log %logger% I 解包%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}解包%bootpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 解包%bootpath%失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-19000
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
::测试ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 无ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-19000-MODE0)
call log %logger% I 测试ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-19000-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-19000-MODE1
ECHOC {%c_e%}测试ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 测试ramdisk.cpio失败:%var%& pause>nul & ECHO.重试... & goto MAGISKPATCH-19000
::模式0-Stock boot image detected
:MAGISKPATCH-19000-MODE0
call log %logger% I 模式0
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 备份ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-19000-MODE0)
goto MAGISKPATCH-19000-2
::模式1-Magisk patched boot image detected
:MAGISKPATCH-19000-MODE1
call log %logger% I 模式1
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
call log %logger% I 还原ramdisk.cpio
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}还原ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 还原ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-19000-MODE1
call log %logger% I 检查ramdisk.cpio中是否存在init.rc
magiskboot.exe cpio ramdisk.cpio "exists init.rc" 1>>%logfile% 2>&1
if "%errorlevel%"=="0" (
    call log %logger% I ramdisk.cpio中存在init.rc.备份ramdisk.cpio
    copy /Y ramdisk.cpio ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-19000-MODE1
) else (
    call log %logger% I ramdisk.cpio中不存在init.rc.删除ramdisk.cpio
    del /F /Q ramdisk.cpio 1>>%logfile% 2>&1 || ECHOC {%c_e%}删除ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 删除ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-19000-MODE1)
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-19000-2
:MAGISKPATCH-19000-2
::修补ramdisk.cpio
call log %logger% I 修补ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
magiskboot.exe cpio ramdisk.cpio "add 750 init magiskinit" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}修补ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 修补ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-19000-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-19000-3
if "%KEEPVERITY%"=="true" (
    call log %logger% I 保持校验.跳过修补dtb
    goto MAGISKPATCH-19000-4)
::尝试修补dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\kernel_dtb set dtbname=kernel_dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if "%dtbname%"=="" (
    call log %logger% I 无dtb
    goto MAGISKPATCH-19000-4)
call log %logger% I 尝试修补dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E 修补%dtbname%失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-19000-4
::尝试修补kernel
call log %logger% I 尝试修补kernel.若目标字符串不存在则报错属于正常现象
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I 尝试修补kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_check失败)
call log %logger% I 尝试修补kernel-移除三星RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E 移除三星RKP失败
call log %logger% I 尝试修补kernel-移除三星defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E 移除三星defex失败
call log %logger% I 尝试修补kernel-强制开启rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E 强制开启rootfs失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-18100
::检查Magisk组件
call log %logger% I 检查Magisk组件
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magiskinit. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.重试... && goto MAGISKPATCH-18100
::if not exist tmp\imgkit-magiskpatch\magisk ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk&& pause>nul && ECHO.重试... && goto MAGISKPATCH-18100
::解包boot
call log %logger% I 解包%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}解包%bootpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 解包%bootpath%失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-18100
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
::测试ramdisk
call log %logger% I 测试ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-18100-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-18100-MODE1
ECHOC {%c_e%}测试ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 测试ramdisk.cpio失败:%var%& pause>nul & ECHO.重试... & goto MAGISKPATCH-18100
::模式0-Stock boot image detected
:MAGISKPATCH-18100-MODE0
call log %logger% I 模式0
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 备份ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-18100-MODE0)
goto MAGISKPATCH-18100-2
::模式1-Magisk patched boot image detected
:MAGISKPATCH-18100-MODE1
call log %logger% I 模式1
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
call log %logger% I 还原ramdisk.cpio
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}还原ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 还原ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-18100-MODE1
copy /Y ramdisk.cpio ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-18100-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-18100-2
:MAGISKPATCH-18100-2
::修补ramdisk.cpio
call log %logger% I 修补ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
magiskboot.exe cpio ramdisk.cpio "add 750 init magiskinit" "patch" "backup ramdisk.cpio.orig" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}修补ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 修补ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-18100-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-18100-3
if "%KEEPVERITY%"=="true" (
    call log %logger% I 保持校验.跳过修补dtb
    goto MAGISKPATCH-18100-4)
::尝试修补dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if "%dtbname%"=="" (
    call log %logger% I 无dtb
    goto MAGISKPATCH-18100-4)
call log %logger% I 尝试修补dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E 修补%dtbname%失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-18100-4
::尝试修补kernel
call log %logger% I 尝试修补kernel.若目标字符串不存在则报错属于正常现象
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I 尝试修补kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_check失败)
call log %logger% I 尝试修补kernel-移除三星RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E 移除三星RKP失败
call log %logger% I 尝试修补kernel-移除三星defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E 移除三星defex失败
call log %logger% I 尝试修补kernel-强制开启rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E 强制开启rootfs失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-17200
::检查Magisk组件
call log %logger% I 检查Magisk组件
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magiskinit. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.重试... && goto MAGISKPATCH-17200
::if not exist tmp\imgkit-magiskpatch\magisk ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk&& pause>nul && ECHO.重试... && goto MAGISKPATCH-17200
::解包boot
call log %logger% I 解包%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}解包%bootpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 解包%bootpath%失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-17200
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
::测试ramdisk
call log %logger% I 测试ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-17200-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-17200-MODE1
ECHOC {%c_e%}测试ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 测试ramdisk.cpio失败:%var%& pause>nul & ECHO.重试... & goto MAGISKPATCH-17200
::模式0-Stock boot image detected
:MAGISKPATCH-17200-MODE0
call log %logger% I 模式0
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 备份ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-17200-MODE0)
goto MAGISKPATCH-17200-2
::模式1-Magisk patched boot image detected
:MAGISKPATCH-17200-MODE1
call log %logger% I 模式1
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
call log %logger% I 还原ramdisk.cpio
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}还原ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 还原ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-17200-MODE1
copy /Y ramdisk.cpio ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-17200-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-17200-2
:MAGISKPATCH-17200-2
::修补ramdisk.cpio
call log %logger% I 修补ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
magiskboot.exe cpio ramdisk.cpio "add 750 init magiskinit" "patch" "backup ramdisk.cpio.orig" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}修补ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 修补ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-17200-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-17200-3
if "%KEEPVERITY%"=="true" (
    call log %logger% I 保持校验.跳过修补dtb
    goto MAGISKPATCH-17200-4)
::尝试修补dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if "%dtbname%"=="" (
    call log %logger% I 无dtb
    goto MAGISKPATCH-17200-4)
call log %logger% I 尝试修补dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E 修补%dtbname%失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-17200-4
::尝试修补kernel
call log %logger% I 尝试修补kernel.若目标字符串不存在则报错属于正常现象
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I 尝试修补kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_check失败)
call log %logger% I 尝试修补kernel-移除三星RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E 移除三星RKP失败
call log %logger% I 尝试修补kernel-移除三星defex-A8_variant
magiskboot.exe hexpatch kernel 006044B91F040071802F005460DE41F9 006044B91F00006B802F005460DE41F9 1>>%logfile% 2>&1 || call log %logger% E 移除三星defex-A8_variant失败
call log %logger% I 尝试修补kernel-移除三星defex-N9_variant
magiskboot.exe hexpatch kernel 603A46B91F0400710030005460C642F9 603A46B91F00006B0030005460C642F9 1>>%logfile% 2>&1 || call log %logger% E 移除三星defex-N9_variant失败
call log %logger% I 尝试修补kernel-强制开启rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D6673 77616E745F696E697472616D6673 1>>%logfile% 2>&1 || call log %logger% E 强制开启rootfs失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-phh-20201-20.3-15bd2da8
::检查Magisk组件
call log %logger% I 检查Magisk组件
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magiskinit. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.重试... && goto MAGISKPATCH-phh-20201-20.3-15bd2da8
::if not exist tmp\imgkit-magiskpatch\magisk ECHOC {%c_e%}找不到tmp\imgkit-magiskpatch\magisk. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 找不到tmp\imgkit-magiskpatch\magisk&& pause>nul && ECHO.重试... && goto MAGISKPATCH-phh-20201-20.3-15bd2da8
::解包boot
call log %logger% I 解包%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}解包%bootpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 解包%bootpath%失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-phh-20201-20.3-15bd2da8
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
::检查recovery_dtbo
if exist tmp\imgkit-magiskpatch\recovery_dtbo set RECOVERYMODE=true
::测试ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 无ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-phh-20201-20.3-15bd2da8-MODE0)
call log %logger% I 测试ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-phh-20201-20.3-15bd2da8-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-phh-20201-20.3-15bd2da8-MODE1
ECHOC {%c_e%}测试ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 测试ramdisk.cpio失败:%var%& pause>nul & ECHO.重试... & goto MAGISKPATCH-phh-20201-20.3-15bd2da8
::模式0-Stock boot image detected
:MAGISKPATCH-phh-20201-20.3-15bd2da8-MODE0
call log %logger% I 模式0
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I 备份ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-phh-20201-20.3-15bd2da8-MODE0)
goto MAGISKPATCH-phh-20201-20.3-15bd2da8-2
::模式1-Magisk patched boot image detected
:MAGISKPATCH-phh-20201-20.3-15bd2da8-MODE1
call log %logger% I 模式1
call log %logger% I 计算sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
call log %logger% I 还原ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}还原ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 还原ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-phh-20201-20.3-15bd2da8-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
call log %logger% I 备份ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}备份ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 备份ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-phh-20201-20.3-15bd2da8-MODE1
goto MAGISKPATCH-phh-20201-20.3-15bd2da8-2
:MAGISKPATCH-phh-20201-20.3-15bd2da8-2
::修补ramdisk.cpio
call log %logger% I 修补ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
magiskboot.exe cpio ramdisk.cpio "rm init.zygote32.rc" "rm init.zygote64_32.rc" 1>>%logfile% 2>&1 || ECHOC {%c_e%}删除zygote失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 删除zygote失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-phh-20201-20.3-15bd2da8-2
magiskboot.exe cpio ramdisk.cpio "add 750 init magiskinit" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}修补ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 修补ramdisk.cpio失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-phh-20201-20.3-15bd2da8-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-phh-20201-20.3-15bd2da8-3
::尝试修补dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\kernel_dtb set dtbname=kernel_dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if exist tmp\imgkit-magiskpatch\recovery_dtbo set dtbname=recovery_dtbo
if "%dtbname%"=="" (
    call log %logger% I 无dtb
    goto MAGISKPATCH-phh-20201-20.3-15bd2da8-4)
call log %logger% I 尝试修补dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E 修补%dtbname%失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
:MAGISKPATCH-phh-20201-20.3-15bd2da8-4
::尝试修补kernel
call log %logger% I 尝试修补kernel.若目标字符串不存在则报错属于正常现象
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I 尝试修补kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_check失败)
call log %logger% I 尝试修补kernel-移除三星RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E 移除三星RKP失败
call log %logger% I 尝试修补kernel-移除三星defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E 移除三星defex失败
call log %logger% I 尝试修补kernel-强制开启rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E 强制开启rootfs失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-DONE
::打包boot
call log %logger% I 打包boot
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-magiskpatch失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-magiskpatch失败&& goto FATAL
magiskboot.exe repack %bootpath% boot_new.img 1>>%logfile% 2>&1 || ECHOC {%c_e%}打包boot失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 打包boot失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto MAGISKPATCH-DONE
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
::和原boot比较大小
call log %logger% I 检查boot大小
set origbootsize=
for /f "tokens=2 delims= " %%a in ('busybox.exe stat -t %bootpath%') do set origbootsize=%%a
if "%origbootsize%"=="" ECHOC {%c_e%}获取%bootpath%大小失败{%c_i%}{\n}& call log %logger% F 获取%bootpath%大小失败 & goto FATAL
set patchedbootsize=
for /f "tokens=2 delims= " %%a in ('busybox.exe stat -t tmp\imgkit-magiskpatch\boot_new.img') do set patchedbootsize=%%a
if "%patchedbootsize%"=="" ECHOC {%c_e%}获取tmp\imgkit-magiskpatch\boot_new.img大小失败{%c_i%}{\n}& call log %logger% F 获取tmp\imgkit-magiskpatch\boot_new.img大小失败 & goto FATAL
if not "%origbootsize%"=="%patchedbootsize%" ECHOC {%c_w%}警告: boot大小不相等. 原boot: %origbootsize%b. 修补后: %patchedbootsize%b. {%c_h%}按任意键继续...{%c_i%}{\n}& call log %logger% W boot大小不相等.原boot:%origbootsize%b.修补后:%patchedbootsize%b & pause>nul & ECHO.继续...
::移动成品到指定目录
move /Y tmp\imgkit-magiskpatch\boot_new.img %outputpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}移动tmp\imgkit-magiskpatch\boot_new.img到%outputpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 移动tmp\imgkit-magiskpatch\boot_new.img到%outputpath%失败&& pause>nul && ECHO.重试... && goto MAGISKPATCH-DONE
call log %logger% I 全部完成
ENDLOCAL
goto :eof


:RECINST
SETLOCAL
set logger=imgkit.bat-recinst
set bootpath=%var2%& set outputpath=%var3%& set recpath=%var4%& set mode=%var5%
call log %logger% I 接收变量:bootpath:%bootpath%.outputpath:%outputpath%.recpath:%recpath%.mode:%noprompt%
:RECINST-1
::检查是否存在
if not exist %bootpath% ECHOC {%c_e%}找不到%bootpath%{%c_i%}{\n}& call log %logger% F 找不到%bootpath%& goto FATAL
if not exist %recpath% ECHOC {%c_e%}找不到%recpath%{%c_i%}{\n}& call log %logger% F 找不到%recpath%& goto FATAL
if not "%mode%"=="noprompt" (if exist %outputpath% ECHOC {%c_w%}已存在%outputpath%, 继续将覆盖此文件. {%c_h%}按任意键继续...{%c_i%}{\n}& call log %logger% W 已存在%outputpath%.继续将覆盖此文件& pause>nul & ECHO.继续...)
::准备环境
call log %logger% I 准备环境
if exist tmp\imgkit-recinst rd /s /q tmp\imgkit-recinst 1>nul 2>>%logfile% || ECHOC {%c_e%}删除tmp\imgkit-recinst失败{%c_i%}{\n}&& call log %logger% E 删除tmp\imgkit-recinst失败
md tmp\imgkit-recinst 1>nul 2>>%logfile% || ECHOC {%c_e%}创建tmp\imgkit-recinst失败{%c_i%}{\n}&& call log %logger% E 创建tmp\imgkit-recinst失败
::判断rec文件格式
for %%i in ("%recpath%") do (if not "%%~xi"==".img" goto RECINST-2)
::如果是img则解包提取ramdisk
call log %logger% I 所选recovery是img文件.开始解包提取
cd tmp\imgkit-recinst 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-recinst失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-recinst失败&& goto FATAL
magiskboot.exe unpack %recpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}解包%recpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 解包%recpath%失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto RECINST-1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
if not exist tmp\imgkit-recinst\ramdisk.cpio ECHOC {%c_e%}找不到tmp\imgkit-recinst\ramdisk.cpio, 解包%recpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 找不到tmp\imgkit-recinst\ramdisk.cpio.解包%recpath%失败& pause>nul & ECHO.重试... & goto RECINST-1
move /Y tmp\imgkit-recinst\ramdisk.cpio tmp\imgkit-recinst\ramdisk.cpio_new 1>>%logfile% 2>&1 || ECHOC {%c_e%}重命名tmp\imgkit-recinst\ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 重命名tmp\imgkit-recinst\ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto RECINST-1
call log %logger% I 提取ramdisk.cpio完毕
goto RECINST-3
:RECINST-2
::如果不是img则直接复制为ramdisk.cpio_new
echo.F|xcopy /Y %recpath% tmp\imgkit-recinst\ramdisk.cpio_new 1>>%logfile% 2>&1 || ECHOC {%c_e%}复制%recpath%到tmp\imgkit-recinst\ramdisk.cpio_new失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 复制%recpath%到tmp\imgkit-recinst\ramdisk.cpio_new失败&& pause>nul && ECHO.重试... && goto RECINST-1
goto RECINST-3
:RECINST-3
::解包boot
call log %logger% I 开始解包boot
cd tmp\imgkit-recinst 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-recinst失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-recinst失败&& goto FATAL
magiskboot.exe cleanup 1>>%logfile% 2>&1 || ECHOC {%c_e%}magiskboot清理运行环境失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E magiskboot清理运行环境失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto RECINST-3
magiskboot.exe unpack -h %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}解包%bootpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 解包%bootpath%失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto RECINST-3
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
::cmdline_remove_skip_override
call log %logger% I 开始cmdline_remove_skip_override
if not exist tmp\imgkit-recinst\header ECHOC {%c_e%}找不到tmp\imgkit-recinst\header, 解包%bootpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 找不到tmp\imgkit-recinst\header.解包%bootpath%失败& pause>nul & ECHO.重试... & goto RECINST-3
echo.#!/busybox ash>tmp\imgkit-recinst\cmdline_remove_skip_override.sh
echo.sed -i "s|$(grep '^cmdline=' tmp/imgkit-recinst/header | cut -d= -f2-)|$(grep '^cmdline=' tmp/imgkit-recinst/header | cut -d= -f2- | sed -e 's/skip_override//' -e 's/  */ /g' -e 's/[ \t]*$//')|" tmp/imgkit-recinst/header>>tmp\imgkit-recinst\cmdline_remove_skip_override.sh
::busybox.exe ash tmp\imgkit-recinst\cmdline_remove_skip_override.sh 1>>%logfile% 2>&1 || ECHOC {%c_e%}cmdline_remove_skip_override失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E cmdline_remove_skip_override失败&& pause>nul && ECHO.重试... && goto RECINST-3
busybox.exe ash tmp\imgkit-recinst\cmdline_remove_skip_override.sh 1>>%logfile% 2>&1 || call log %logger% W cmdline_remove_skip_override失败
::hexpatch_kernel
call log %logger% I 开始hexpatch_kernel
cd tmp\imgkit-recinst 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-recinst失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-recinst失败&& goto FATAL
magiskboot.exe hexpatch kernel 77616E745F696E697472616D6673 736B69705F696E697472616D6673 1>>%logfile% 2>&1 || call log %logger% E hexpatch_kernel失败
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
::替换ramdisk
call log %logger% I 开始替换ramdisk
move /Y tmp\imgkit-recinst\ramdisk.cpio_new tmp\imgkit-recinst\ramdisk.cpio 1>>%logfile% 2>&1 || ECHOC {%c_e%}替换tmp\imgkit-recinst\ramdisk.cpio失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 替换tmp\imgkit-recinst\ramdisk.cpio失败&& pause>nul && ECHO.重试... && goto RECINST-3
::打包boot
call log %logger% I 开始打包boot
cd tmp\imgkit-recinst 1>nul 2>>%logfile% || ECHOC {%c_e%}进入tmp\imgkit-recinst失败{%c_i%}{\n}&& call log %logger% F 进入tmp\imgkit-recinst失败&& goto FATAL
magiskboot.exe repack %bootpath% boot_new.img 1>>%logfile% 2>&1 || ECHOC {%c_e%}打包boot失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 打包boot失败&& pause>nul && ECHO.重试... && cd %framwork_workspace% && goto RECINST-3
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}进入%framwork_workspace%失败{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
move /Y tmp\imgkit-recinst\boot_new.img %outputpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}移动tmp\imgkit-recinst\boot_new.img到%outputpath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 移动tmp\imgkit-recinst\boot_new.img到%outputpath%失败&& pause>nul && ECHO.重试... && goto RECINST-3
call log %logger% I 全部完成
ENDLOCAL
goto :eof







:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}抱歉, 脚本遇到问题, 无法继续运行. 请查看日志. {%c_h%}按任意键退出...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.抱歉, 脚本遇到问题, 无法继续运行. 按任意键退出...& pause>nul & EXIT)











::弃用



