::call imgkit magiskpatch boot�ļ�����·�� ��boot�ļ�·�� 25200�����apk·��                             noprompt(��ѡ)
::            recinst     boot�ļ�����·�� ��boot�ļ�·�� recovery�ļ�����·��(������img��ramdisk.cpio)   noprompt(��ѡ)

@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%



:MAGISKPATCH
SETLOCAL
set logger=imgkit.bat-magiskpatch
set bootpath=%var2%& set outputpath=%var3%& set zippath=%var4%& set mode=%var5%
if "%zippath%"=="" set zippath=tool\Android\magisk\25200.apk
if "%zippath%"=="25200" set zippath=tool\Android\magisk\25200.apk
call log %logger% I ���ձ���:bootpath:%bootpath%.outputpath:%outputpath%.zippath:%zippath%.mode:%mode%
::����Ƿ����
if not exist %bootpath% ECHOC {%c_e%}�Ҳ���%bootpath%{%c_i%}{\n}& call log %logger% F �Ҳ���%bootpath%& goto FATAL
if not exist %zippath% ECHOC {%c_e%}�Ҳ���%zippath%{%c_i%}{\n}& call log %logger% F �Ҳ���%zippath%& goto FATAL
if not "%mode%"=="noprompt" (if exist %outputpath% ECHOC {%c_w%}�Ѵ���%outputpath%, ���������Ǵ��ļ�. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% W �Ѵ���%outputpath%.���������Ǵ��ļ�& pause>nul & ECHO.����...)
::������ʱ�ļ���
if exist tmp\imgkit-magiskpatch rd /s /q tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}ɾ��tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% E ɾ��tmp\imgkit-magiskpatchʧ��
md tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% E ����tmp\imgkit-magiskpatchʧ��
::�����޲�ѡ��
::- ����AVB2.0, dm-verity (26300-17000)
set KEEPVERITY=true
::- ����ǿ�Ƽ��� (26300-17000)
set KEEPFORCEENCRYPT=true
::- �޲�vbmeta��� (26300-24000)
set PATCHVBMETAFLAG=false
::- ��װ��Recovery (26300-19100)(ע: ��23000�����͵İ汾, ��boot�������recovery_dtbo�ļ�ʱ, ���ǿ�Ʊ���Ϊtrue)
set RECOVERYMODE=false
::- ǿ��rootfs (26300-26000)
set LEGACYSAR=true
set SYSTEM_ROOT=%LEGACYSAR%
::- �������ܹ� (26300-19000֧��64λ, 18100-17000�����ֻ�֧��64λ)
::  arm_64   arm_32   x86_64   x86_32
set arch=arm_64
::�����Զ���ѡ��(����еĻ�)
if exist tool\Android\magisk\config.bat call tool\Android\magisk\config.bat
::��¼����ѡ��
call log %logger% I �����޲�ѡ��:KEEPVERITY:%KEEPVERITY%.KEEPFORCEENCRYPT:%KEEPFORCEENCRYPT%.PATCHVBMETAFLAG:%PATCHVBMETAFLAG%.RECOVERYMODE:%RECOVERYMODE%.LEGACYSAR:%LEGACYSAR%.SYSTEM_ROOT:%SYSTEM_ROOT%.arch:%arch%
:MAGISKPATCH-1
::׼��Magisk���
call log %logger% I ׼��Magisk���
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
if exist tmp\imgkit-magiskpatch\magiskinit64 move /Y tmp\imgkit-magiskpatch\magiskinit64 tmp\imgkit-magiskpatch\magiskinit 1>>%logfile% 2>&1 || ECHOC {%c_e%}�ƶ�tmp\imgkit-magiskpatch\magiskinit64��tmp\imgkit-magiskpatch\magiskinitʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �ƶ�tmp\imgkit-magiskpatch\magiskinit64��tmp\imgkit-magiskpatch\magiskinitʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-1
::if exist tmp\imgkit-magiskpatch\magiskinit (
::    7z.exe e -t#:e -aoa -otmp\imgkit-magiskpatch -slp -y -ir!2.xz tmp\imgkit-magiskpatch\magiskinit 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ѹtmp\imgkit-magiskpatch\magiskinitʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ѹtmp\imgkit-magiskpatch\magiskinitʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-1
::    7z.exe e -aoa -otmp\imgkit-magiskpatch -slp -y -ir!2 tmp\imgkit-magiskpatch\2.xz 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ѹtmp\imgkit-magiskpatch\2.xzʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ѹtmp\imgkit-magiskpatch\2.xzʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-1
::    move /Y tmp\imgkit-magiskpatch\2 tmp\imgkit-magiskpatch\magisk 1>>%logfile% 2>&1 || ECHOC {%c_e%}�ƶ�tmp\imgkit-magiskpatch\2��tmp\imgkit-magiskpatch\magiskʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �ƶ�tmp\imgkit-magiskpatch\2��tmp\imgkit-magiskpatch\magiskʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-1)
if exist tmp\imgkit-magiskpatch\libmagiskinit.so move /Y tmp\imgkit-magiskpatch\libmagiskinit.so tmp\imgkit-magiskpatch\magiskinit 1>>%logfile% 2>&1 || ECHOC {%c_e%}�ƶ�tmp\imgkit-magiskpatch\libmagiskinit.so��tmp\imgkit-magiskpatch\magiskinitʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �ƶ�tmp\imgkit-magiskpatch\libmagiskinit.so��tmp\imgkit-magiskpatch\magiskinitʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-1
if exist tmp\imgkit-magiskpatch\libmagisk32.so magiskboot.exe compress=xz tmp\imgkit-magiskpatch\libmagisk32.so tmp\imgkit-magiskpatch\magisk32.xz 1>>%logfile% 2>&1 || ECHOC {%c_e%}ѹ��tmp\imgkit-magiskpatch\libmagisk32.soʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ѹ��tmp\imgkit-magiskpatch\libmagisk32.soʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-1
if exist tmp\imgkit-magiskpatch\libmagisk64.so magiskboot.exe compress=xz tmp\imgkit-magiskpatch\libmagisk64.so tmp\imgkit-magiskpatch\magisk64.xz 1>>%logfile% 2>&1 || ECHOC {%c_e%}ѹ��tmp\imgkit-magiskpatch\libmagisk64.soʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ѹ��tmp\imgkit-magiskpatch\libmagisk64.soʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-1
if exist tmp\imgkit-magiskpatch\stub.apk magiskboot.exe compress=xz tmp\imgkit-magiskpatch\stub.apk tmp\imgkit-magiskpatch\stub.xz 1>>%logfile% 2>&1 || ECHOC {%c_e%}ѹ��tmp\imgkit-magiskpatch\stub.apkʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ѹ��tmp\imgkit-magiskpatch\stub.apkʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-1
::��ȡMagisk�汾
call log %logger% I ��ȡMagisk�汾
7z.exe e -aoa -otmp\imgkit-magiskpatch -slp -y -ir!assets\util_functions.sh -ir!common\util_functions.sh %zippath% 1>>%logfile% 2>&1
set magiskver=
for /f "tokens=2 delims== " %%a in ('type tmp\imgkit-magiskpatch\util_functions.sh ^| find "MAGISK_VER_CODE="') do set magiskver=%%a
for /f "tokens=2 delims== " %%a in ('type tmp\imgkit-magiskpatch\util_functions.sh ^| find "MAGISK_VER="') do set var=%%a
set magiskver_show=%var:~1,-1%
call log %logger% I Magisk�汾:%magiskver%.Magisk��ʾ�汾:%magiskver_show%
::�����汾��Magisk֧��
set vivo_suu_patch=n
if "%magiskver%"=="20201" (if "%magiskver_show%"=="20.3-15bd2da8" goto MAGISKPATCH-phh-20201-20.3-15bd2da8)
if "%magiskver%"=="25200" (if "%magiskver_show%"=="25.2-vivo_suu" set vivo_suu_patch=y& goto MAGISKPATCH-25200)
if "%magiskver%"=="26104" (if "%magiskver_show%"=="26.1-vivo_suu" set vivo_suu_patch=y& goto MAGISKPATCH-26200)
if "%magiskver%"=="26404" (if "%magiskver_show%"=="R65A24840suu-delta" set vivo_suu_patch=y& goto MAGISKPATCH-26300)
if "%magiskver%"=="27001" (if "%magiskver_show%"=="R65C0A20Asuu-kitsune" set vivo_suu_patch=y& goto MAGISKPATCH-26300)
::Magisk�ٷ���ʽ��֧��
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
ECHOC {%c_e%}δ֧�ֵ�Magisk�汾(%magiskver_show% %magiskver%). ��QQ��ϵ1330250642����.{%c_i%}{\n}& goto FATAL

:MAGISKPATCH-26300
::���Magisk���
call log %logger% I ���Magisk���
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magiskinit. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.����... && goto MAGISKPATCH-26300
if not exist tmp\imgkit-magiskpatch\magisk32.xz ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk32.xz. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk32.xz&& pause>nul && ECHO.����... && goto MAGISKPATCH-26300
if "%arch:~-2,2%"=="64" (if not exist tmp\imgkit-magiskpatch\magisk64.xz ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk64.xz. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk64.xz&& pause>nul && ECHO.����... && goto MAGISKPATCH-26300)
if not exist tmp\imgkit-magiskpatch\stub.xz ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\stub.xz. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\stub.xz&& pause>nul && ECHO.����... && goto MAGISKPATCH-26300
::���boot
call log %logger% I ���%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}���%bootpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���%bootpath%ʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-26300
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
::����ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ��ramdisk.cpio
    set STATUS=0& set SKIP_BACKUP=#& goto MAGISKPATCH-26300-MODE0)
call log %logger% I ����ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
set SKIP_BACKUP=
if "%STATUS%"=="0" goto MAGISKPATCH-26300-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-26300-MODE1
ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ����ramdisk.cpioʧ��:%var%& pause>nul & ECHO.����... & goto MAGISKPATCH-26300
::ģʽ0-Stock boot image detected
:MAGISKPATCH-26300-MODE0
call log %logger% I ģʽ0
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ����ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-26300-MODE0)
goto MAGISKPATCH-26300-1
::ģʽ1-Magisk patched boot image detected
:MAGISKPATCH-26300-MODE1
call log %logger% I ģʽ1
call log %logger% I ��ԭramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe cpio ramdisk.cpio "extract .backup/.magisk config.orig" "restore" 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ԭramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ԭramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-26300-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
call log %logger% I ����ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-26300-MODE1
goto MAGISKPATCH-26300-1
:MAGISKPATCH-26300-1
if not exist tmp\imgkit-magiskpatch\config.orig goto MAGISKPATCH-26300-2
for /f "tokens=2 delims== " %%a in ('type tmp\imgkit-magiskpatch\config.orig ^| find "SHA1="') do set SHA1=%%a
:MAGISKPATCH-26300-2
::�޲�ramdisk.cpio
call log %logger% I �޲�ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
if "%arch:~-2,2%"=="64" (set var=) else (set var=#)
magiskboot.exe cpio ramdisk.cpio "add 0750 init magiskinit" "mkdir 0750 overlay.d" "mkdir 0750 overlay.d/sbin" "add 0644 overlay.d/sbin/magisk32.xz magisk32.xz" "%var% add 0644 overlay.d/sbin/magisk64.xz magisk64.xz" "add 0644 overlay.d/sbin/stub.xz stub.xz" "patch" "%SKIP_BACKUP% backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}�޲�ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �޲�ramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-26300-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-26300-3
::���Ժ��޲�dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
set dtbname=
set result=y
if exist dtb set dtbname=dtb& call :magiskpatch-26300-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26300-3
if exist kernel_dtb set dtbname=kernel_dtb& call :magiskpatch-26300-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26300-3
if exist extra set dtbname=extra& call :magiskpatch-26300-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26300-3
if "%dtbname%"=="" call log %logger% I ��dtb��kernel_dtb��extra
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-26300-4
:magiskpatch-26300-dtb
call log %logger% I ����%dtbname%
magiskboot.exe dtb %dtbname% test 1>>%logfile% 2>&1 || set result=n&& ECHOC {%c_e%}����%dtbname%ʧ��. ����boot�ѱ��汾���ɵ�Magisk�޲���. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%dtbname%ʧ��.����boot�ѱ��汾���ɵ�Magisk�޲���&& pause>nul && ECHO.����... && goto :eof
call log %logger% I �����޲�%dtbname%
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E �޲�%dtbname%ʧ��
goto :eof
:MAGISKPATCH-26300-4
::�����޲�kernel
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
if exist kernel set PATCHEDKERNEL=false
if exist kernel (
    call log %logger% I �����޲�kernel.��Ŀ���ַ����������򱨴�������������
    if "%vivo_suu_patch%"=="y" (
        call log %logger% I �����޲�kernel-patch-vivo-do_mount_check
        magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E patch-vivo-do_mount_checkʧ��)
    call log %logger% I �����޲�kernel-�Ƴ�����RKP
    magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E �Ƴ�����RKPʧ��
    call log %logger% I �����޲�kernel-�Ƴ�����defex
    magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E �Ƴ�����defexʧ��
    if "%LEGACYSAR%"=="true" (
        call log %logger% I �����޲�kernel-ǿ�ƿ���rootfs
        magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E ǿ�ƿ���rootfsʧ��))
if exist kernel (if "%PATCHEDKERNEL%"=="false" call log %logger% I kernelδ�޸�.��ɾ��kernel & del /F /Q kernel 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��kernelʧ��{%c_i%}{\n}&& call log %logger% F ɾ��kernelʧ��&& goto FATAL)
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-26200
::���Magisk���
call log %logger% I ���Magisk���
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magiskinit. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.����... && goto MAGISKPATCH-26200
if not exist tmp\imgkit-magiskpatch\magisk32.xz ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk32.xz. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk32.xz&& pause>nul && ECHO.����... && goto MAGISKPATCH-26200
if "%arch:~-2,2%"=="64" (if not exist tmp\imgkit-magiskpatch\magisk64.xz ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk64.xz. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk64.xz&& pause>nul && ECHO.����... && goto MAGISKPATCH-26200)
if not exist tmp\imgkit-magiskpatch\stub.xz ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\stub.xz. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\stub.xz&& pause>nul && ECHO.����... && goto MAGISKPATCH-26200
::���boot
call log %logger% I ���%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}���%bootpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���%bootpath%ʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-26200
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
::����ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ��ramdisk.cpio
    set STATUS=0& set SKIP_BACKUP=#& goto MAGISKPATCH-26200-MODE0)
call log %logger% I ����ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
set SKIP_BACKUP=
if "%STATUS%"=="0" goto MAGISKPATCH-26200-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-26200-MODE1
ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ����ramdisk.cpioʧ��:%var%& pause>nul & ECHO.����... & goto MAGISKPATCH-26200
::ģʽ0-Stock boot image detected
:MAGISKPATCH-26200-MODE0
call log %logger% I ģʽ0
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ����ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-26200-MODE0)
goto MAGISKPATCH-26200-1
::ģʽ1-Magisk patched boot image detected
:MAGISKPATCH-26200-MODE1
call log %logger% I ģʽ1
call log %logger% I ��ԭramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe cpio ramdisk.cpio "extract .backup/.magisk config.orig" "restore" 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ԭramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ԭramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-26200-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
call log %logger% I ����ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-26200-MODE1
goto MAGISKPATCH-26200-1
:MAGISKPATCH-26200-1
if not exist tmp\imgkit-magiskpatch\config.orig goto MAGISKPATCH-26200-2
for /f "tokens=2 delims== " %%a in ('type tmp\imgkit-magiskpatch\config.orig ^| find "SHA1="') do set SHA1=%%a
:MAGISKPATCH-26200-2
::�޲�ramdisk.cpio
call log %logger% I �޲�ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.PATCHVBMETAFLAG=%PATCHVBMETAFLAG%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
if "%arch:~-2,2%"=="64" (set var=) else (set var=#)
magiskboot.exe cpio ramdisk.cpio "add 0750 init magiskinit" "mkdir 0750 overlay.d" "mkdir 0750 overlay.d/sbin" "add 0644 overlay.d/sbin/magisk32.xz magisk32.xz" "%var% add 0644 overlay.d/sbin/magisk64.xz magisk64.xz" "add 0644 overlay.d/sbin/stub.xz stub.xz" "patch" "%SKIP_BACKUP% backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}�޲�ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �޲�ramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-26200-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-26200-3
::���Ժ��޲�dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
set dtbname=
set result=y
if exist dtb set dtbname=dtb& call :magiskpatch-26200-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26200-3
if exist kernel_dtb set dtbname=kernel_dtb& call :magiskpatch-26200-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26200-3
if exist extra set dtbname=extra& call :magiskpatch-26200-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26200-3
if "%dtbname%"=="" call log %logger% I ��dtb��kernel_dtb��extra
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-26200-4
:magiskpatch-26200-dtb
call log %logger% I ����%dtbname%
magiskboot.exe dtb %dtbname% test 1>>%logfile% 2>&1 || set result=n&& ECHOC {%c_e%}����%dtbname%ʧ��. ����boot�ѱ��汾���ɵ�Magisk�޲���. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%dtbname%ʧ��.����boot�ѱ��汾���ɵ�Magisk�޲���&& pause>nul && ECHO.����... && goto :eof
call log %logger% I �����޲�%dtbname%
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E �޲�%dtbname%ʧ��
goto :eof
:MAGISKPATCH-26200-4
::�����޲�kernel
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
if exist kernel set PATCHEDKERNEL=false
if exist kernel (
    call log %logger% I �����޲�kernel.��Ŀ���ַ����������򱨴�������������
    if "%vivo_suu_patch%"=="y" (
        call log %logger% I �����޲�kernel-patch-vivo-do_mount_check
        magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E patch-vivo-do_mount_checkʧ��)
    call log %logger% I �����޲�kernel-�Ƴ�����RKP
    magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E �Ƴ�����RKPʧ��
    call log %logger% I �����޲�kernel-�Ƴ�����defex
    magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E �Ƴ�����defexʧ��
    if "%LEGACYSAR%"=="true" (
        call log %logger% I �����޲�kernel-ǿ�ƿ���rootfs
        magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E ǿ�ƿ���rootfsʧ��))
if exist kernel (if "%PATCHEDKERNEL%"=="false" call log %logger% I kernelδ�޸�.��ɾ��kernel & del /F /Q kernel 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��kernelʧ��{%c_i%}{\n}&& call log %logger% F ɾ��kernelʧ��&& goto FATAL)
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-26000
::���Magisk���
call log %logger% I ���Magisk���
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magiskinit. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.����... && goto MAGISKPATCH-26000
if not exist tmp\imgkit-magiskpatch\magisk32.xz ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk32.xz. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk32.xz&& pause>nul && ECHO.����... && goto MAGISKPATCH-26000
if "%arch:~-2,2%"=="64" (if not exist tmp\imgkit-magiskpatch\magisk64.xz ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk64.xz. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk64.xz&& pause>nul && ECHO.����... && goto MAGISKPATCH-26000)
if not exist tmp\imgkit-magiskpatch\stub.xz ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\stub.xz. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\stub.xz&& pause>nul && ECHO.����... && goto MAGISKPATCH-26000
::���boot
call log %logger% I ���%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}���%bootpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���%bootpath%ʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-26000
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
::����ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ��ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-26000-MODE0)
call log %logger% I ����ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-26000-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-26000-MODE1
ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ����ramdisk.cpioʧ��:%var%& pause>nul & ECHO.����... & goto MAGISKPATCH-26000
::ģʽ0-Stock boot image detected
:MAGISKPATCH-26000-MODE0
call log %logger% I ģʽ0
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ����ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-26000-MODE0)
goto MAGISKPATCH-26000-2
::ģʽ1-Magisk patched boot image detected
:MAGISKPATCH-26000-MODE1
call log %logger% I ģʽ1
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
call log %logger% I ��ԭramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ԭramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ԭramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-26000-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
call log %logger% I ����ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-26000-MODE1
goto MAGISKPATCH-26000-2
:MAGISKPATCH-26000-2
::�޲�ramdisk.cpio
call log %logger% I �޲�ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.PATCHVBMETAFLAG=%PATCHVBMETAFLAG%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
call random 16 abcdef0123456789
echo.RANDOMSEED=0x%random__str%|find "RANDOMSEED" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
if "%arch:~-2,2%"=="64" (set var=) else (set var=#)
magiskboot.exe cpio ramdisk.cpio "add 0750 init magiskinit" "mkdir 0750 overlay.d" "mkdir 0750 overlay.d/sbin" "add 0644 overlay.d/sbin/magisk32.xz magisk32.xz" "%var% add 0644 overlay.d/sbin/magisk64.xz magisk64.xz" "add 0644 overlay.d/sbin/stub.xz stub.xz" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}�޲�ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �޲�ramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-26000-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-26000-3
::���Ժ��޲�dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
set dtbname=
set result=y
if exist dtb set dtbname=dtb& call :magiskpatch-26000-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26000-3
if exist kernel_dtb set dtbname=kernel_dtb& call :magiskpatch-26000-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26000-3
if exist extra set dtbname=extra& call :magiskpatch-26000-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-26000-3
if "%dtbname%"=="" call log %logger% I ��dtb��kernel_dtb��extra
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-26000-4
:magiskpatch-26000-dtb
call log %logger% I ����%dtbname%
magiskboot.exe dtb %dtbname% test 1>>%logfile% 2>&1 || set result=n&& ECHOC {%c_e%}����%dtbname%ʧ��. ����boot�ѱ��汾���ɵ�Magisk�޲���. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%dtbname%ʧ��.����boot�ѱ��汾���ɵ�Magisk�޲���&& pause>nul && ECHO.����... && goto :eof
call log %logger% I �����޲�%dtbname%
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E �޲�%dtbname%ʧ��
goto :eof
:MAGISKPATCH-26000-4
::�����޲�kernel
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
if exist kernel set PATCHEDKERNEL=false
if exist kernel (
    call log %logger% I �����޲�kernel.��Ŀ���ַ����������򱨴�������������
    if "%vivo_suu_patch%"=="y" (
        call log %logger% I �����޲�kernel-patch-vivo-do_mount_check
        magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E patch-vivo-do_mount_checkʧ��)
    call log %logger% I �����޲�kernel-�Ƴ�����RKP
    magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E �Ƴ�����RKPʧ��
    call log %logger% I �����޲�kernel-�Ƴ�����defex
    magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E �Ƴ�����defexʧ��
    if "%SYSTEM_ROOT%"=="true" (
        call log %logger% I �����޲�kernel-ǿ�ƿ���rootfs
        magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 && set PATCHEDKERNEL=true || call log %logger% E ǿ�ƿ���rootfsʧ��))
if exist kernel (if "%PATCHEDKERNEL%"=="false" call log %logger% I kernelδ�޸�.��ɾ��kernel & del /F /Q kernel 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��kernelʧ��{%c_i%}{\n}&& call log %logger% F ɾ��kernelʧ��&& goto FATAL)
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-25200
::���Magisk���
call log %logger% I ���Magisk���
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magiskinit. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.����... && goto MAGISKPATCH-25200
if not exist tmp\imgkit-magiskpatch\magisk32.xz ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk32.xz. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk32.xz&& pause>nul && ECHO.����... && goto MAGISKPATCH-25200
if "%arch:~-2,2%"=="64" (if not exist tmp\imgkit-magiskpatch\magisk64.xz ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk64.xz. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk64.xz&& pause>nul && ECHO.����... && goto MAGISKPATCH-25200)
::���boot
call log %logger% I ���%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}���%bootpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���%bootpath%ʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-25200
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
::����ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ��ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-25200-MODE0)
call log %logger% I ����ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-25200-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-25200-MODE1
ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ����ramdisk.cpioʧ��:%var%& pause>nul & ECHO.����... & goto MAGISKPATCH-25200
::ģʽ0-Stock boot image detected
:MAGISKPATCH-25200-MODE0
call log %logger% I ģʽ0
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ����ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-25200-MODE0)
goto MAGISKPATCH-25200-2
::ģʽ1-Magisk patched boot image detected
:MAGISKPATCH-25200-MODE1
call log %logger% I ģʽ1
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
call log %logger% I ��ԭramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ԭramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ԭramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-25200-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
call log %logger% I ����ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-25200-MODE1
goto MAGISKPATCH-25200-2
:MAGISKPATCH-25200-2
::�޲�ramdisk.cpio
call log %logger% I �޲�ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.PATCHVBMETAFLAG=%PATCHVBMETAFLAG%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
if "%arch:~-2,2%"=="64" (set var=) else (set var=#)
magiskboot.exe cpio ramdisk.cpio "add 0750 init magiskinit" "mkdir 0750 overlay.d" "mkdir 0750 overlay.d/sbin" "add 0644 overlay.d/sbin/magisk32.xz magisk32.xz" "%var% add 0644 overlay.d/sbin/magisk64.xz magisk64.xz" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}�޲�ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �޲�ramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-25200-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-25200-3
::���Ժ��޲�dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
set dtbname=
set result=y
if exist dtb set dtbname=dtb& call :magiskpatch-25200-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-25200-3
if exist kernel_dtb set dtbname=kernel_dtb& call :magiskpatch-25200-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-25200-3
if exist extra set dtbname=extra& call :magiskpatch-25200-dtb
if "%result%"=="n" cd %framwork_workspace% && goto MAGISKPATCH-25200-3
if "%dtbname%"=="" call log %logger% I ��dtb��kernel_dtb��extra
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-25200-4
:magiskpatch-25200-dtb
call log %logger% I ����%dtbname%
magiskboot.exe dtb %dtbname% test 1>>%logfile% 2>&1 || set result=n&& ECHOC {%c_e%}����%dtbname%ʧ��. ����boot�ѱ��汾���ɵ�Magisk�޲���. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%dtbname%ʧ��.����boot�ѱ��汾���ɵ�Magisk�޲���&& pause>nul && ECHO.����... && goto :eof
call log %logger% I �����޲�%dtbname%
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E �޲�%dtbname%ʧ��
goto :eof
:MAGISKPATCH-25200-4
::�����޲�kernel
call log %logger% I �����޲�kernel.��Ŀ���ַ����������򱨴�������������
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I �����޲�kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_checkʧ��)
call log %logger% I �����޲�kernel-�Ƴ�����RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����RKPʧ��
call log %logger% I �����޲�kernel-�Ƴ�����defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����defexʧ��
call log %logger% I �����޲�kernel-ǿ�ƿ���rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E ǿ�ƿ���rootfsʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-25000
::���Magisk���
call log %logger% I ���Magisk���
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magiskinit. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.����... && goto MAGISKPATCH-25000
if not exist tmp\imgkit-magiskpatch\magisk32.xz ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk32.xz. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk32.xz&& pause>nul && ECHO.����... && goto MAGISKPATCH-25000
if "%arch:~-2,2%"=="64" (if not exist tmp\imgkit-magiskpatch\magisk64.xz ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk64.xz. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk64.xz&& pause>nul && ECHO.����... && goto MAGISKPATCH-25000)
::���boot
call log %logger% I ���%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}���%bootpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���%bootpath%ʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-25000
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
::����ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ��ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-25000-MODE0)
call log %logger% I ����ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-25000-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-25000-MODE1
ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ����ramdisk.cpioʧ��:%var%& pause>nul & ECHO.����... & goto MAGISKPATCH-25000
::ģʽ0-Stock boot image detected
:MAGISKPATCH-25000-MODE0
call log %logger% I ģʽ0
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ����ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-25000-MODE0)
goto MAGISKPATCH-25000-2
::ģʽ1-Magisk patched boot image detected
:MAGISKPATCH-25000-MODE1
call log %logger% I ģʽ1
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
call log %logger% I ��ԭramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ԭramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ԭramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-25000-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
call log %logger% I ����ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-25000-MODE1
goto MAGISKPATCH-25000-2
:MAGISKPATCH-25000-2
::�޲�ramdisk.cpio
call log %logger% I �޲�ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.PATCHVBMETAFLAG=%PATCHVBMETAFLAG%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
if "%arch:~-2,2%"=="64" (set var=) else (set var=#)
magiskboot.exe cpio ramdisk.cpio "add 0750 init magiskinit" "mkdir 0750 overlay.d" "mkdir 0750 overlay.d/sbin" "add 0644 overlay.d/sbin/magisk32.xz magisk32.xz" "%var% add 0644 overlay.d/sbin/magisk64.xz magisk64.xz" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}�޲�ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �޲�ramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-25000-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-25000-3
::�����޲�dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\kernel_dtb set dtbname=kernel_dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if "%dtbname%"=="" (
    call log %logger% I ��dtb��kernel_dtb
    goto MAGISKPATCH-25000-4)
call log %logger% I �����޲�dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E �޲�%dtbname%ʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-25000-4
::�����޲�kernel
call log %logger% I �����޲�kernel.��Ŀ���ַ����������򱨴�������������
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I �����޲�kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_checkʧ��)
call log %logger% I �����޲�kernel-�Ƴ�����RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����RKPʧ��
call log %logger% I �����޲�kernel-�Ƴ�����defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����defexʧ��
call log %logger% I �����޲�kernel-ǿ�ƿ���rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E ǿ�ƿ���rootfsʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-23000
::���Magisk���
call log %logger% I ���Magisk���
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magiskinit. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.����... && goto MAGISKPATCH-23000
if not exist tmp\imgkit-magiskpatch\magisk32.xz ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk32.xz. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk32.xz&& pause>nul && ECHO.����... && goto MAGISKPATCH-23000
if "%arch:~-2,2%"=="64" (if not exist tmp\imgkit-magiskpatch\magisk64.xz ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk64.xz. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk64.xz&& pause>nul && ECHO.����... && goto MAGISKPATCH-23000)
::���boot
call log %logger% I ���%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}���%bootpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���%bootpath%ʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-23000
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
::���recovery_dtbo
if exist tmp\imgkit-magiskpatch\recovery_dtbo set RECOVERYMODE=true
::����ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ��ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-23000-MODE0)
call log %logger% I ����ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-23000-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-23000-MODE1
ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ����ramdisk.cpioʧ��:%var%& pause>nul & ECHO.����... & goto MAGISKPATCH-23000
::ģʽ0-Stock boot image detected
:MAGISKPATCH-23000-MODE0
call log %logger% I ģʽ0
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ����ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-23000-MODE0)
goto MAGISKPATCH-23000-2
::ģʽ1-Magisk patched boot image detected
:MAGISKPATCH-23000-MODE1
call log %logger% I ģʽ1
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
call log %logger% I ��ԭramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ԭramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ԭramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-23000-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
call log %logger% I ����ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-23000-MODE1
goto MAGISKPATCH-23000-2
:MAGISKPATCH-23000-2
::�޲�ramdisk.cpio
call log %logger% I �޲�ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
if "%arch:~-2,2%"=="64" (set var=) else (set var=#)
magiskboot.exe cpio ramdisk.cpio "add 0750 init magiskinit" "mkdir 0750 overlay.d" "mkdir 0750 overlay.d/sbin" "add 0644 overlay.d/sbin/magisk32.xz magisk32.xz" "%var% add 0644 overlay.d/sbin/magisk64.xz magisk64.xz" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}�޲�ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �޲�ramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-23000-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-23000-3
::�����޲�dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\kernel_dtb set dtbname=kernel_dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if "%dtbname%"=="" (
    call log %logger% I ��dtb��kernel_dtb
    goto MAGISKPATCH-23000-4)
call log %logger% I �����޲�dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E �޲�%dtbname%ʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-23000-4
::�����޲�kernel
call log %logger% I �����޲�kernel.��Ŀ���ַ����������򱨴�������������
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I �����޲�kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_checkʧ��)
call log %logger% I �����޲�kernel-�Ƴ�����RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����RKPʧ��
call log %logger% I �����޲�kernel-�Ƴ�����defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����defexʧ��
call log %logger% I �����޲�kernel-ǿ�ƿ���rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E ǿ�ƿ���rootfsʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-21400
::���Magisk���
call log %logger% I ���Magisk���
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magiskinit. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.����... && goto MAGISKPATCH-21400
::if not exist tmp\imgkit-magiskpatch\magisk ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk&& pause>nul && ECHO.����... && goto MAGISKPATCH-21400
::���boot
call log %logger% I ���%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}���%bootpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���%bootpath%ʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-21400
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
::���recovery_dtbo
if exist tmp\imgkit-magiskpatch\recovery_dtbo set RECOVERYMODE=true
::����ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ��ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-21400-MODE0)
call log %logger% I ����ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-21400-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-21400-MODE1
ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ����ramdisk.cpioʧ��:%var%& pause>nul & ECHO.����... & goto MAGISKPATCH-21400
::ģʽ0-Stock boot image detected
:MAGISKPATCH-21400-MODE0
call log %logger% I ģʽ0
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ����ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-21400-MODE0)
goto MAGISKPATCH-21400-2
::ģʽ1-Magisk patched boot image detected
:MAGISKPATCH-21400-MODE1
call log %logger% I ģʽ1
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
call log %logger% I ��ԭramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ԭramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ԭramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-21400-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
call log %logger% I ����ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-21400-MODE1
goto MAGISKPATCH-21400-2
:MAGISKPATCH-21400-2
::�޲�ramdisk.cpio
call log %logger% I �޲�ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
magiskboot.exe cpio ramdisk.cpio "add 750 init magiskinit" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}�޲�ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �޲�ramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-21400-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-21400-3
::�����޲�dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\kernel_dtb set dtbname=kernel_dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if "%dtbname%"=="" (
    call log %logger% I ��dtb��kernel_dtb
    goto MAGISKPATCH-21400-4)
call log %logger% I �����޲�dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E �޲�%dtbname%ʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-21400-4
::�����޲�kernel
call log %logger% I �����޲�kernel.��Ŀ���ַ����������򱨴�������������
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I �����޲�kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_checkʧ��)
call log %logger% I �����޲�kernel-�Ƴ�����RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����RKPʧ��
call log %logger% I �����޲�kernel-�Ƴ�����defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����defexʧ��
call log %logger% I �����޲�kernel-ǿ�ƿ���rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E ǿ�ƿ���rootfsʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-21200
::���Magisk���
call log %logger% I ���Magisk���
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magiskinit. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.����... && goto MAGISKPATCH-21200
::if not exist tmp\imgkit-magiskpatch\magisk ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk&& pause>nul && ECHO.����... && goto MAGISKPATCH-21200
::���boot
call log %logger% I ���%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}���%bootpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���%bootpath%ʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-21200
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
::���recovery_dtbo
if exist tmp\imgkit-magiskpatch\recovery_dtbo set RECOVERYMODE=true
::����ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ��ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-21200-MODE0)
call log %logger% I ����ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-21200-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-21200-MODE1
ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ����ramdisk.cpioʧ��:%var%& pause>nul & ECHO.����... & goto MAGISKPATCH-21200
::ģʽ0-Stock boot image detected
:MAGISKPATCH-21200-MODE0
call log %logger% I ģʽ0
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ����ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-21200-MODE0)
goto MAGISKPATCH-21200-2
::ģʽ1-Magisk patched boot image detected
:MAGISKPATCH-21200-MODE1
call log %logger% I ģʽ1
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
call log %logger% I ��ԭramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ԭramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ԭramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-21200-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
call log %logger% I ����ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-21200-MODE1
goto MAGISKPATCH-21200-2
:MAGISKPATCH-21200-2
::�޲�ramdisk.cpio
call log %logger% I �޲�ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
magiskboot.exe cpio ramdisk.cpio "add 750 init magiskinit" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}�޲�ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �޲�ramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-21200-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-21200-3
::�����޲�dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\kernel_dtb set dtbname=kernel_dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if exist tmp\imgkit-magiskpatch\recovery_dtbo set dtbname=recovery_dtbo
if "%dtbname%"=="" (
    call log %logger% I ��dtb
    goto MAGISKPATCH-21200-4)
call log %logger% I �����޲�dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E �޲�%dtbname%ʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-21200-4
::�����޲�kernel
call log %logger% I �����޲�kernel.��Ŀ���ַ����������򱨴�������������
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I �����޲�kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_checkʧ��)
call log %logger% I �����޲�kernel-�Ƴ�����RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����RKPʧ��
call log %logger% I �����޲�kernel-�Ƴ�����defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����defexʧ��
call log %logger% I �����޲�kernel-ǿ�ƿ���rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E ǿ�ƿ���rootfsʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-19400
::���Magisk���
call log %logger% I ���Magisk���
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magiskinit. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.����... && goto MAGISKPATCH-19400
::if not exist tmp\imgkit-magiskpatch\magisk ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk&& pause>nul && ECHO.����... && goto MAGISKPATCH-19400
::���boot
call log %logger% I ���%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}���%bootpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���%bootpath%ʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-19400
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
::���recovery_dtbo
if exist tmp\imgkit-magiskpatch\recovery_dtbo set RECOVERYMODE=true
::����ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ��ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-19400-MODE0)
call log %logger% I ����ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-19400-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-19400-MODE1
ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ����ramdisk.cpioʧ��:%var%& pause>nul & ECHO.����... & goto MAGISKPATCH-19400
::ģʽ0-Stock boot image detected
:MAGISKPATCH-19400-MODE0
call log %logger% I ģʽ0
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ����ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-19400-MODE0)
goto MAGISKPATCH-19400-2
::ģʽ1-Magisk patched boot image detected
:MAGISKPATCH-19400-MODE1
call log %logger% I ģʽ1
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
call log %logger% I ��ԭramdisk.cpio
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ԭramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ԭramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-19400-MODE1
call log %logger% I ���ramdisk.cpio���Ƿ����init.rc
magiskboot.exe cpio ramdisk.cpio "exists init.rc" 1>>%logfile% 2>&1
if "%errorlevel%"=="0" (
    call log %logger% I ramdisk.cpio�д���init.rc.����ramdisk.cpio
    copy /Y ramdisk.cpio ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-19400-MODE1
) else (
    call log %logger% I ramdisk.cpio�в�����init.rc.ɾ��ramdisk.cpio
    del /F /Q ramdisk.cpio 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ɾ��ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-19400-MODE1)
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-19400-2
:MAGISKPATCH-19400-2
::�޲�ramdisk.cpio
call log %logger% I �޲�ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
magiskboot.exe cpio ramdisk.cpio "add 750 init magiskinit" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}�޲�ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �޲�ramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-19400-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-19400-3
if "%KEEPVERITY%"=="true" (
    call log %logger% I ����У��.�����޲�dtb
    goto MAGISKPATCH-19400-4)
::�����޲�dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\kernel_dtb set dtbname=kernel_dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if exist tmp\imgkit-magiskpatch\recovery_dtbo set dtbname=recovery_dtbo
if "%dtbname%"=="" (
    call log %logger% I ��dtb
    goto MAGISKPATCH-19400-4)
call log %logger% I �����޲�dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E �޲�%dtbname%ʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-19400-4
::�����޲�kernel
call log %logger% I �����޲�kernel.��Ŀ���ַ����������򱨴�������������
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I �����޲�kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_checkʧ��)
call log %logger% I �����޲�kernel-�Ƴ�����RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����RKPʧ��
call log %logger% I �����޲�kernel-�Ƴ�����defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����defexʧ��
call log %logger% I �����޲�kernel-ǿ�ƿ���rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E ǿ�ƿ���rootfsʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-19000
::���Magisk���
call log %logger% I ���Magisk���
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magiskinit. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.����... && goto MAGISKPATCH-19000
::if not exist tmp\imgkit-magiskpatch\magisk ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk&& pause>nul && ECHO.����... && goto MAGISKPATCH-19000
::���boot
call log %logger% I ���%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}���%bootpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���%bootpath%ʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-19000
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
::����ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ��ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-19000-MODE0)
call log %logger% I ����ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-19000-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-19000-MODE1
ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ����ramdisk.cpioʧ��:%var%& pause>nul & ECHO.����... & goto MAGISKPATCH-19000
::ģʽ0-Stock boot image detected
:MAGISKPATCH-19000-MODE0
call log %logger% I ģʽ0
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ����ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-19000-MODE0)
goto MAGISKPATCH-19000-2
::ģʽ1-Magisk patched boot image detected
:MAGISKPATCH-19000-MODE1
call log %logger% I ģʽ1
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
call log %logger% I ��ԭramdisk.cpio
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ԭramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ԭramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-19000-MODE1
call log %logger% I ���ramdisk.cpio���Ƿ����init.rc
magiskboot.exe cpio ramdisk.cpio "exists init.rc" 1>>%logfile% 2>&1
if "%errorlevel%"=="0" (
    call log %logger% I ramdisk.cpio�д���init.rc.����ramdisk.cpio
    copy /Y ramdisk.cpio ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-19000-MODE1
) else (
    call log %logger% I ramdisk.cpio�в�����init.rc.ɾ��ramdisk.cpio
    del /F /Q ramdisk.cpio 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ɾ��ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-19000-MODE1)
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-19000-2
:MAGISKPATCH-19000-2
::�޲�ramdisk.cpio
call log %logger% I �޲�ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
magiskboot.exe cpio ramdisk.cpio "add 750 init magiskinit" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}�޲�ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �޲�ramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-19000-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-19000-3
if "%KEEPVERITY%"=="true" (
    call log %logger% I ����У��.�����޲�dtb
    goto MAGISKPATCH-19000-4)
::�����޲�dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\kernel_dtb set dtbname=kernel_dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if "%dtbname%"=="" (
    call log %logger% I ��dtb
    goto MAGISKPATCH-19000-4)
call log %logger% I �����޲�dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E �޲�%dtbname%ʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-19000-4
::�����޲�kernel
call log %logger% I �����޲�kernel.��Ŀ���ַ����������򱨴�������������
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I �����޲�kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_checkʧ��)
call log %logger% I �����޲�kernel-�Ƴ�����RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����RKPʧ��
call log %logger% I �����޲�kernel-�Ƴ�����defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����defexʧ��
call log %logger% I �����޲�kernel-ǿ�ƿ���rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E ǿ�ƿ���rootfsʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-18100
::���Magisk���
call log %logger% I ���Magisk���
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magiskinit. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.����... && goto MAGISKPATCH-18100
::if not exist tmp\imgkit-magiskpatch\magisk ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk&& pause>nul && ECHO.����... && goto MAGISKPATCH-18100
::���boot
call log %logger% I ���%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}���%bootpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���%bootpath%ʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-18100
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
::����ramdisk
call log %logger% I ����ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-18100-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-18100-MODE1
ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ����ramdisk.cpioʧ��:%var%& pause>nul & ECHO.����... & goto MAGISKPATCH-18100
::ģʽ0-Stock boot image detected
:MAGISKPATCH-18100-MODE0
call log %logger% I ģʽ0
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ����ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-18100-MODE0)
goto MAGISKPATCH-18100-2
::ģʽ1-Magisk patched boot image detected
:MAGISKPATCH-18100-MODE1
call log %logger% I ģʽ1
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
call log %logger% I ��ԭramdisk.cpio
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ԭramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ԭramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-18100-MODE1
copy /Y ramdisk.cpio ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-18100-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-18100-2
:MAGISKPATCH-18100-2
::�޲�ramdisk.cpio
call log %logger% I �޲�ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
magiskboot.exe cpio ramdisk.cpio "add 750 init magiskinit" "patch" "backup ramdisk.cpio.orig" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}�޲�ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �޲�ramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-18100-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-18100-3
if "%KEEPVERITY%"=="true" (
    call log %logger% I ����У��.�����޲�dtb
    goto MAGISKPATCH-18100-4)
::�����޲�dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if "%dtbname%"=="" (
    call log %logger% I ��dtb
    goto MAGISKPATCH-18100-4)
call log %logger% I �����޲�dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E �޲�%dtbname%ʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-18100-4
::�����޲�kernel
call log %logger% I �����޲�kernel.��Ŀ���ַ����������򱨴�������������
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I �����޲�kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_checkʧ��)
call log %logger% I �����޲�kernel-�Ƴ�����RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����RKPʧ��
call log %logger% I �����޲�kernel-�Ƴ�����defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����defexʧ��
call log %logger% I �����޲�kernel-ǿ�ƿ���rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E ǿ�ƿ���rootfsʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-17200
::���Magisk���
call log %logger% I ���Magisk���
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magiskinit. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.����... && goto MAGISKPATCH-17200
::if not exist tmp\imgkit-magiskpatch\magisk ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk&& pause>nul && ECHO.����... && goto MAGISKPATCH-17200
::���boot
call log %logger% I ���%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}���%bootpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���%bootpath%ʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-17200
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
::����ramdisk
call log %logger% I ����ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-17200-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-17200-MODE1
ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ����ramdisk.cpioʧ��:%var%& pause>nul & ECHO.����... & goto MAGISKPATCH-17200
::ģʽ0-Stock boot image detected
:MAGISKPATCH-17200-MODE0
call log %logger% I ģʽ0
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ����ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-17200-MODE0)
goto MAGISKPATCH-17200-2
::ģʽ1-Magisk patched boot image detected
:MAGISKPATCH-17200-MODE1
call log %logger% I ģʽ1
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
call log %logger% I ��ԭramdisk.cpio
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ԭramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ԭramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-17200-MODE1
copy /Y ramdisk.cpio ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-17200-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-17200-2
:MAGISKPATCH-17200-2
::�޲�ramdisk.cpio
call log %logger% I �޲�ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
magiskboot.exe cpio ramdisk.cpio "add 750 init magiskinit" "patch" "backup ramdisk.cpio.orig" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}�޲�ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �޲�ramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-17200-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-17200-3
if "%KEEPVERITY%"=="true" (
    call log %logger% I ����У��.�����޲�dtb
    goto MAGISKPATCH-17200-4)
::�����޲�dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if "%dtbname%"=="" (
    call log %logger% I ��dtb
    goto MAGISKPATCH-17200-4)
call log %logger% I �����޲�dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E �޲�%dtbname%ʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-17200-4
::�����޲�kernel
call log %logger% I �����޲�kernel.��Ŀ���ַ����������򱨴�������������
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I �����޲�kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_checkʧ��)
call log %logger% I �����޲�kernel-�Ƴ�����RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����RKPʧ��
call log %logger% I �����޲�kernel-�Ƴ�����defex-A8_variant
magiskboot.exe hexpatch kernel 006044B91F040071802F005460DE41F9 006044B91F00006B802F005460DE41F9 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����defex-A8_variantʧ��
call log %logger% I �����޲�kernel-�Ƴ�����defex-N9_variant
magiskboot.exe hexpatch kernel 603A46B91F0400710030005460C642F9 603A46B91F00006B0030005460C642F9 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����defex-N9_variantʧ��
call log %logger% I �����޲�kernel-ǿ�ƿ���rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D6673 77616E745F696E697472616D6673 1>>%logfile% 2>&1 || call log %logger% E ǿ�ƿ���rootfsʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-phh-20201-20.3-15bd2da8
::���Magisk���
call log %logger% I ���Magisk���
if not exist tmp\imgkit-magiskpatch\magiskinit ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magiskinit. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magiskinit&& pause>nul && ECHO.����... && goto MAGISKPATCH-phh-20201-20.3-15bd2da8
::if not exist tmp\imgkit-magiskpatch\magisk ECHOC {%c_e%}�Ҳ���tmp\imgkit-magiskpatch\magisk. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �Ҳ���tmp\imgkit-magiskpatch\magisk&& pause>nul && ECHO.����... && goto MAGISKPATCH-phh-20201-20.3-15bd2da8
::���boot
call log %logger% I ���%bootpath%
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe unpack %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}���%bootpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���%bootpath%ʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-phh-20201-20.3-15bd2da8
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
::���recovery_dtbo
if exist tmp\imgkit-magiskpatch\recovery_dtbo set RECOVERYMODE=true
::����ramdisk
if not exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ��ramdisk.cpio
    set STATUS=0& goto MAGISKPATCH-phh-20201-20.3-15bd2da8-MODE0)
call log %logger% I ����ramdisk.cpio
magiskboot.exe cpio tmp\imgkit-magiskpatch\ramdisk.cpio test 1>>%logfile% 2>&1
set STATUS=%errorlevel%
if "%STATUS%"=="0" goto MAGISKPATCH-phh-20201-20.3-15bd2da8-MODE0
if "%STATUS%"=="1" goto MAGISKPATCH-phh-20201-20.3-15bd2da8-MODE1
ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ����ramdisk.cpioʧ��:%var%& pause>nul & ECHO.����... & goto MAGISKPATCH-phh-20201-20.3-15bd2da8
::ģʽ0-Stock boot image detected
:MAGISKPATCH-phh-20201-20.3-15bd2da8-MODE0
call log %logger% I ģʽ0
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot sha1 %bootpath% 2^>^>%logfile%') do set SHA1=%%a
if exist tmp\imgkit-magiskpatch\ramdisk.cpio (
    call log %logger% I ����ramdisk.cpio
    copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-phh-20201-20.3-15bd2da8-MODE0)
goto MAGISKPATCH-phh-20201-20.3-15bd2da8-2
::ģʽ1-Magisk patched boot image detected
:MAGISKPATCH-phh-20201-20.3-15bd2da8-MODE1
call log %logger% I ģʽ1
call log %logger% I ����sha1
set SHA1=
for /f %%a in ('magiskboot cpio ramdisk.cpio sha1 2^>^>%logfile%') do set SHA1=%%a
call log %logger% I ��ԭramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe cpio ramdisk.cpio restore 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ԭramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ԭramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-phh-20201-20.3-15bd2da8-MODE1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
call log %logger% I ����ramdisk.cpio
copy /Y tmp\imgkit-magiskpatch\ramdisk.cpio tmp\imgkit-magiskpatch\ramdisk.cpio.orig 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-phh-20201-20.3-15bd2da8-MODE1
goto MAGISKPATCH-phh-20201-20.3-15bd2da8-2
:MAGISKPATCH-phh-20201-20.3-15bd2da8-2
::�޲�ramdisk.cpio
call log %logger% I �޲�ramdisk.cpio
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
echo.KEEPVERITY=%KEEPVERITY%>config& echo.KEEPFORCEENCRYPT=%KEEPFORCEENCRYPT%>>config& echo.RECOVERYMODE=%RECOVERYMODE%>>config
if not "%SHA1%"=="" echo.SHA1=%SHA1%|find "SHA1" 1>>config
busybox.exe sed -i "s/\r//g;s/^M//g" config
type config>>%logfile%
magiskboot.exe cpio ramdisk.cpio "rm init.zygote32.rc" "rm init.zygote64_32.rc" 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��zygoteʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ɾ��zygoteʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-phh-20201-20.3-15bd2da8-2
magiskboot.exe cpio ramdisk.cpio "add 750 init magiskinit" "patch" "backup ramdisk.cpio.orig" "mkdir 000 .backup" "add 000 .backup/.magisk config" 1>>%logfile% 2>&1 || ECHOC {%c_e%}�޲�ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �޲�ramdisk.cpioʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-phh-20201-20.3-15bd2da8-2
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-phh-20201-20.3-15bd2da8-3
::�����޲�dtb
set dtbname=
if exist tmp\imgkit-magiskpatch\dtb set dtbname=dtb
if exist tmp\imgkit-magiskpatch\kernel_dtb set dtbname=kernel_dtb
if exist tmp\imgkit-magiskpatch\extra set dtbname=extra
if exist tmp\imgkit-magiskpatch\recovery_dtbo set dtbname=recovery_dtbo
if "%dtbname%"=="" (
    call log %logger% I ��dtb
    goto MAGISKPATCH-phh-20201-20.3-15bd2da8-4)
call log %logger% I �����޲�dtb
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe dtb %dtbname% patch 1>>%logfile% 2>&1 || call log %logger% E �޲�%dtbname%ʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
:MAGISKPATCH-phh-20201-20.3-15bd2da8-4
::�����޲�kernel
call log %logger% I �����޲�kernel.��Ŀ���ַ����������򱨴�������������
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
if "%vivo_suu_patch%"=="y" (
    call log %logger% I �����޲�kernel-patch-vivo-do_mount_check
    magiskboot.exe hexpatch kernel 0092CFC2C9CDDDDA00 0092CFC2C9CEC0DB00 1>>%logfile% 2>&1 || call log %logger% E patch-vivo-do_mount_checkʧ��)
call log %logger% I �����޲�kernel-�Ƴ�����RKP
magiskboot.exe hexpatch kernel 49010054011440B93FA00F71E9000054010840B93FA00F7189000054001840B91FA00F7188010054 A1020054011440B93FA00F7140020054010840B93FA00F71E0010054001840B91FA00F7181010054 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����RKPʧ��
call log %logger% I �����޲�kernel-�Ƴ�����defex
magiskboot.exe hexpatch kernel 821B8012 E2FF8F12 1>>%logfile% 2>&1 || call log %logger% E �Ƴ�����defexʧ��
call log %logger% I �����޲�kernel-ǿ�ƿ���rootfs
magiskboot.exe hexpatch kernel 736B69705F696E697472616D667300 77616E745F696E697472616D667300 1>>%logfile% 2>&1 || call log %logger% E ǿ�ƿ���rootfsʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
goto MAGISKPATCH-DONE

:MAGISKPATCH-DONE
::���boot
call log %logger% I ���boot
cd tmp\imgkit-magiskpatch 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-magiskpatchʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-magiskpatchʧ��&& goto FATAL
magiskboot.exe repack %bootpath% boot_new.img 1>>%logfile% 2>&1 || ECHOC {%c_e%}���bootʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���bootʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto MAGISKPATCH-DONE
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
::��ԭboot�Ƚϴ�С
call log %logger% I ���boot��С
set origbootsize=
for /f "tokens=2 delims= " %%a in ('busybox.exe stat -t %bootpath%') do set origbootsize=%%a
if "%origbootsize%"=="" ECHOC {%c_e%}��ȡ%bootpath%��Сʧ��{%c_i%}{\n}& call log %logger% F ��ȡ%bootpath%��Сʧ�� & goto FATAL
set patchedbootsize=
for /f "tokens=2 delims= " %%a in ('busybox.exe stat -t tmp\imgkit-magiskpatch\boot_new.img') do set patchedbootsize=%%a
if "%patchedbootsize%"=="" ECHOC {%c_e%}��ȡtmp\imgkit-magiskpatch\boot_new.img��Сʧ��{%c_i%}{\n}& call log %logger% F ��ȡtmp\imgkit-magiskpatch\boot_new.img��Сʧ�� & goto FATAL
if not "%origbootsize%"=="%patchedbootsize%" ECHOC {%c_w%}����: boot��С�����. ԭboot: %origbootsize%b. �޲���: %patchedbootsize%b. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% W boot��С�����.ԭboot:%origbootsize%b.�޲���:%patchedbootsize%b & pause>nul & ECHO.����...
::�ƶ���Ʒ��ָ��Ŀ¼
move /Y tmp\imgkit-magiskpatch\boot_new.img %outputpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}�ƶ�tmp\imgkit-magiskpatch\boot_new.img��%outputpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �ƶ�tmp\imgkit-magiskpatch\boot_new.img��%outputpath%ʧ��&& pause>nul && ECHO.����... && goto MAGISKPATCH-DONE
call log %logger% I ȫ�����
ENDLOCAL
goto :eof


:RECINST
SETLOCAL
set logger=imgkit.bat-recinst
set bootpath=%var2%& set outputpath=%var3%& set recpath=%var4%& set mode=%var5%
call log %logger% I ���ձ���:bootpath:%bootpath%.outputpath:%outputpath%.recpath:%recpath%.mode:%noprompt%
:RECINST-1
::����Ƿ����
if not exist %bootpath% ECHOC {%c_e%}�Ҳ���%bootpath%{%c_i%}{\n}& call log %logger% F �Ҳ���%bootpath%& goto FATAL
if not exist %recpath% ECHOC {%c_e%}�Ҳ���%recpath%{%c_i%}{\n}& call log %logger% F �Ҳ���%recpath%& goto FATAL
if not "%mode%"=="noprompt" (if exist %outputpath% ECHOC {%c_w%}�Ѵ���%outputpath%, ���������Ǵ��ļ�. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% W �Ѵ���%outputpath%.���������Ǵ��ļ�& pause>nul & ECHO.����...)
::׼������
call log %logger% I ׼������
if exist tmp\imgkit-recinst rd /s /q tmp\imgkit-recinst 1>nul 2>>%logfile% || ECHOC {%c_e%}ɾ��tmp\imgkit-recinstʧ��{%c_i%}{\n}&& call log %logger% E ɾ��tmp\imgkit-recinstʧ��
md tmp\imgkit-recinst 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-recinstʧ��{%c_i%}{\n}&& call log %logger% E ����tmp\imgkit-recinstʧ��
::�ж�rec�ļ���ʽ
for %%i in ("%recpath%") do (if not "%%~xi"==".img" goto RECINST-2)
::�����img������ȡramdisk
call log %logger% I ��ѡrecovery��img�ļ�.��ʼ�����ȡ
cd tmp\imgkit-recinst 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-recinstʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-recinstʧ��&& goto FATAL
magiskboot.exe unpack %recpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}���%recpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���%recpath%ʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto RECINST-1
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
if not exist tmp\imgkit-recinst\ramdisk.cpio ECHOC {%c_e%}�Ҳ���tmp\imgkit-recinst\ramdisk.cpio, ���%recpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �Ҳ���tmp\imgkit-recinst\ramdisk.cpio.���%recpath%ʧ��& pause>nul & ECHO.����... & goto RECINST-1
move /Y tmp\imgkit-recinst\ramdisk.cpio tmp\imgkit-recinst\ramdisk.cpio_new 1>>%logfile% 2>&1 || ECHOC {%c_e%}������tmp\imgkit-recinst\ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ������tmp\imgkit-recinst\ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto RECINST-1
call log %logger% I ��ȡramdisk.cpio���
goto RECINST-3
:RECINST-2
::�������img��ֱ�Ӹ���Ϊramdisk.cpio_new
echo.F|xcopy /Y %recpath% tmp\imgkit-recinst\ramdisk.cpio_new 1>>%logfile% 2>&1 || ECHOC {%c_e%}����%recpath%��tmp\imgkit-recinst\ramdisk.cpio_newʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%recpath%��tmp\imgkit-recinst\ramdisk.cpio_newʧ��&& pause>nul && ECHO.����... && goto RECINST-1
goto RECINST-3
:RECINST-3
::���boot
call log %logger% I ��ʼ���boot
cd tmp\imgkit-recinst 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-recinstʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-recinstʧ��&& goto FATAL
magiskboot.exe cleanup 1>>%logfile% 2>&1 || ECHOC {%c_e%}magiskboot�������л���ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E magiskboot�������л���ʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto RECINST-3
magiskboot.exe unpack -h %bootpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}���%bootpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���%bootpath%ʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto RECINST-3
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
::cmdline_remove_skip_override
call log %logger% I ��ʼcmdline_remove_skip_override
if not exist tmp\imgkit-recinst\header ECHOC {%c_e%}�Ҳ���tmp\imgkit-recinst\header, ���%bootpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �Ҳ���tmp\imgkit-recinst\header.���%bootpath%ʧ��& pause>nul & ECHO.����... & goto RECINST-3
echo.#!/busybox ash>tmp\imgkit-recinst\cmdline_remove_skip_override.sh
echo.sed -i "s|$(grep '^cmdline=' tmp/imgkit-recinst/header | cut -d= -f2-)|$(grep '^cmdline=' tmp/imgkit-recinst/header | cut -d= -f2- | sed -e 's/skip_override//' -e 's/  */ /g' -e 's/[ \t]*$//')|" tmp/imgkit-recinst/header>>tmp\imgkit-recinst\cmdline_remove_skip_override.sh
::busybox.exe ash tmp\imgkit-recinst\cmdline_remove_skip_override.sh 1>>%logfile% 2>&1 || ECHOC {%c_e%}cmdline_remove_skip_overrideʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E cmdline_remove_skip_overrideʧ��&& pause>nul && ECHO.����... && goto RECINST-3
busybox.exe ash tmp\imgkit-recinst\cmdline_remove_skip_override.sh 1>>%logfile% 2>&1 || call log %logger% W cmdline_remove_skip_overrideʧ��
::hexpatch_kernel
call log %logger% I ��ʼhexpatch_kernel
cd tmp\imgkit-recinst 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-recinstʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-recinstʧ��&& goto FATAL
magiskboot.exe hexpatch kernel 77616E745F696E697472616D6673 736B69705F696E697472616D6673 1>>%logfile% 2>&1 || call log %logger% E hexpatch_kernelʧ��
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
::�滻ramdisk
call log %logger% I ��ʼ�滻ramdisk
move /Y tmp\imgkit-recinst\ramdisk.cpio_new tmp\imgkit-recinst\ramdisk.cpio 1>>%logfile% 2>&1 || ECHOC {%c_e%}�滻tmp\imgkit-recinst\ramdisk.cpioʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �滻tmp\imgkit-recinst\ramdisk.cpioʧ��&& pause>nul && ECHO.����... && goto RECINST-3
::���boot
call log %logger% I ��ʼ���boot
cd tmp\imgkit-recinst 1>nul 2>>%logfile% || ECHOC {%c_e%}����tmp\imgkit-recinstʧ��{%c_i%}{\n}&& call log %logger% F ����tmp\imgkit-recinstʧ��&& goto FATAL
magiskboot.exe repack %bootpath% boot_new.img 1>>%logfile% 2>&1 || ECHOC {%c_e%}���bootʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���bootʧ��&& pause>nul && ECHO.����... && cd %framwork_workspace% && goto RECINST-3
cd %framwork_workspace% 1>nul 2>>%logfile% || ECHOC {%c_e%}����%framwork_workspace%ʧ��{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
move /Y tmp\imgkit-recinst\boot_new.img %outputpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}�ƶ�tmp\imgkit-recinst\boot_new.img��%outputpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �ƶ�tmp\imgkit-recinst\boot_new.img��%outputpath%ʧ��&& pause>nul && ECHO.����... && goto RECINST-3
call log %logger% I ȫ�����
ENDLOCAL
goto :eof







:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)











::����



