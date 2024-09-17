::这是一个主脚本示例,请按照此示例中的启动过程完成脚本的启动.

::常规准备,请勿改动
@ECHO OFF
chcp 936>nul
cd /d %~dp0
if exist bin (cd bin) else (ECHO.找不到bin & goto FATAL)

::加载配置,如果有自定义的配置文件也可以加在下面
if exist conf\fixed.bat (call conf\fixed) else (ECHO.找不到conf\fixed.bat & goto FATAL)
if exist conf\user.bat call conf\user

::加载主题,请勿改动
if "%framwork_theme%"=="" set framwork_theme=default
call framwork theme %framwork_theme%
COLOR %c_i%

::自定义窗口大小,可以按照需要改动
TITLE 工具启动中...
mode con cols=71

::检查和获取管理员权限,如不需要可以去除
if not exist tool\Windows\gap.exe ECHO.找不到gap.exe & goto FATAL
if exist %windir%\System32\bff-test rd %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT
md %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT
rd %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT

::启动准备和检查,请勿改动
call framwork startpre
::call framwork startpre skiptoolchk

::完成启动.请在下面编写你的脚本
TITLE 工具示例 框架版本:%framwork_ver% 
CLS
goto MENU



:MENU
call log example.bat-menu I 进入主菜单
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.主菜单
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.此脚本用于演示和测试各模块功能
ECHO.
ECHO.1.chkdev.bat 检查设备连接
ECHO.2.dl.bat 下载模块
ECHO.3.imgkit.bat 分区镜像处理
ECHO.4.info.bat 读取设备信息
ECHO.5.read.bat 读出
ECHO.6.reboot.bat 重启
ECHO.7.write.bat 写入
ECHO.8.clean.bat 清除
ECHO.9.scrcpy.bat 投屏
ECHO.10.更换主题
ECHO.11.槽位功能
ECHO.12.开关日志
ECHO.13.par.bat 分区
ECHO.14.实时日志监控
ECHO.15.sel.bat 选择文件(夹)
ECHO.16.random.bat 生成随机数
ECHO.17.choice.bat 选择
ECHO.18.mtkclient测试
ECHO.A.返回主菜单
ECHO.
call choice common [1][2][3][4][5][6][7][8][9][10][11][12][13][14][15][16][17][18]#[A]
if "%choice%"=="1" goto CHKDEV
if "%choice%"=="2" goto DL
if "%choice%"=="3" goto IMGKIT
if "%choice%"=="4" goto INFO
if "%choice%"=="5" goto READ
if "%choice%"=="6" goto REBOOT
if "%choice%"=="7" goto WRITE
if "%choice%"=="8" goto CLEAN
if "%choice%"=="9" goto SCRCPY
if "%choice%"=="10" goto THEME
if "%choice%"=="11" goto SLOT
if "%choice%"=="12" goto LOG
if "%choice%"=="13" goto PAR
if "%choice%"=="14" goto LOGVIEWER
if "%choice%"=="15" goto SEL
if "%choice%"=="16" goto RANDOM
if "%choice%"=="17" goto CHOICE
if "%choice%"=="18" goto MTKCLIENT
if "%choice%"=="A" goto MENU





:MTKCLIENT
SETLOCAL
set logger=example.bat-mtkclient
call log %logger% I 进入功能MTKCLIENT
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.mtkclient测试
ECHO.=--------------------------------------------------------------------=
:MTKCLIENT-1
ECHO.
ECHOC {%c_h%}请输入mtkclient参数: {%c_i%}& set /p cmd=
ECHO.正在执行命令...
echo.>tmp\output.txt
start framwork logviewer start tmp\output.txt
call tool\Windows\mtkclient\mtkclient.bat %cmd%
call framwork logviewer end
type tmp\output.txt
goto MTKCLIENT-1


:CHOICE
SETLOCAL
set logger=example.bat-choice
call log %logger% I 进入功能CHOICE
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.choice.bat 选择
ECHO.=--------------------------------------------------------------------=
:CHOICE-1
ECHO.
call choice common
ECHO.[%choice%]
goto CHOICE-1


:RANDOM
SETLOCAL
set logger=example.bat-random
call log %logger% I 进入功能RANDOM
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.random.bat 生成随机数
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.在默认字符池(abcdefghijklmnopqrstuvwxyz0123456789)中生成5位随机数.
ECHO.
:RANDOM-1
call random 5
ECHO.结果: [%random__str%]
ECHOC {%c_h%}按任意键重新生成...{%c_i%}{\n}& pause>nul & goto RANDOM-1


:SEL
SETLOCAL
set logger=example.bat-sel
call log %logger% I 进入功能SEL
:SEL-1
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.sel.bat 选择文件(夹)
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.单选文件
ECHO.2.多选文件
ECHO.3.单选文件夹
ECHO.4.多选文件夹
ECHO.
call choice common [1][2][3][4]
if "%choice%"=="1" call sel file s %framwork_workspace% [bat]
if "%choice%"=="2" call sel file m %framwork_workspace% [bat]
if "%choice%"=="3" call sel folder s %framwork_workspace%
if "%choice%"=="4" call sel folder m %framwork_workspace%
ECHO.
if "%choice%"=="1" ECHO.[%sel__file_path%]
if "%choice%"=="2" ECHO.[%sel__files%]
if "%choice%"=="3" ECHO.[%sel__folder_path%]
if "%choice%"=="4" ECHO.[%sel__folders%]
ECHO. & ECHOC {%c_s%}完成. {%c_h%}按任意键返回...{%c_i%}{\n}& pause>nul & goto SEL


:LOGVIEWER
SETLOCAL
set logger=example.bat-logviewer
call log %logger% I 进入功能LOGVIEWER
:LOGVIEWER-1
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.framwork.bat 实时日志监控
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.当前日志文件: %logfile%
ECHO.
ECHO.1.开启监控
ECHO.2.关闭监控
ECHO.A.返回主菜单
ECHO.
call choice common [1][2][A]
if "%choice%"=="1" start framwork logviewer start %logfile%
if "%choice%"=="2" call framwork logviewer end
if "%choice%"=="A" ENDLOCAL & call log %logger% I 完成功能LOGVIEWER& goto MENU
goto LOGVIEWER-1


:CHKDEV
SETLOCAL
set logger=example.bat-chkdev
call log %logger% I 进入功能CHKDEV
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.chkdev.bat 检查设备连接
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.检查设备连接(全部)
ECHO.2.检查设备连接(系统)
ECHO.3.检查设备连接(Recovery)
ECHO.4.检查设备连接(sideload)
ECHO.5.检查设备连接(Fastboot)
ECHO.6.检查设备连接(edl)
ECHO.7.检查设备连接(diag901d)
ECHO.8.检查设备连接(sprdboot)
ECHO.9.检查设备连接(mtkbrom)
ECHO.10.检查设备连接(mtkpreloader)
ECHO.11.检查设备连接(全部) 复查
ECHO.12.检查设备连接(系统) 2秒后复查
call choice common [1][2][3][4][5][6][7][8][9][10][11][12]
if "%choice%"=="1" call chkdev all
if "%choice%"=="2" call chkdev system
if "%choice%"=="3" call chkdev recovery
if "%choice%"=="4" call chkdev sideload
if "%choice%"=="5" call chkdev fastboot
if "%choice%"=="6" call chkdev edl
if "%choice%"=="7" call chkdev diag901d
if "%choice%"=="8" call chkdev sprdboot
if "%choice%"=="9" call chkdev mtkbrom
if "%choice%"=="10" call chkdev mtkpreloader
if "%choice%"=="11" call chkdev all rechk 2
if "%choice%"=="12" call chkdev system rechk 2
ECHO. & ECHOC {%c_s%}完成. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& ENDLOCAL & call log %logger% I 完成功能CHKDEV& pause>nul & goto MENU


:DL
SETLOCAL
set logger=example.bat-dl
call log %logger% I 进入功能DL
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.dl.bat 下载
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.下载直链
ECHO.2.下载蓝奏分享链接
call choice common [1][2]
goto DL-C%choice%
:DL-C1
ECHOC {%c_h%}请输入直链: {%c_i%}& set /p choice=
ECHOC {%c_h%}请选择保存文件夹...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
call dl direct %choice% %sel__folder_path%\dl.test once notice
goto DL-DONE
:DL-C2
ECHOC {%c_h%}请输入蓝奏分享链接: {%c_i%}& set /p choice=
ECHOC {%c_h%}请选择保存文件夹...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
call dl lzlink %choice% %sel__folder_path%\dl.test once notice
goto DL-DONE
:DL-DONE
ECHO. & ECHOC {%c_s%}完成. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& ENDLOCAL & call log %logger% I 完成功能DL& pause>nul & goto MENU


:IMGKIT
SETLOCAL
set logger=example.bat-imgkit
call log %logger% I 进入功能IMGKIT
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.imgkit.bat 分区镜像处理模块
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.面具修补boot
ECHO.2.为boot注入recovery
call choice common [1][2]
goto IMGKIT-C%choice%
:IMGKIT-C1
ECHOC {%c_h%}请选择boot文件...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [img]
set bootpath=%sel__file_path%
ECHOC {%c_h%}请选择Magisk(可以是zip或apk)...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [zip][apk]
set zippath=%sel__file_path%
ECHOC {%c_h%}请选择新boot保存位置...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
set outputpath=%sel__folder_path%\boot_new.img
call imgkit magiskpatch %bootpath% %outputpath% %zippath%
goto IMGKIT-DONE
:IMGKIT-C2
ECHOC {%c_h%}请选择boot.img...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [img]
set bootpath=%sel__file_path%
ECHOC {%c_h%}请选择recovery(可以是img或ramdisk.cpio)...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [img][cpio]
set recpath=%sel__file_path%
ECHOC {%c_h%}请选择新boot保存位置...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
set outputpath=%sel__folder_path%\boot_new.img
call imgkit recinst %bootpath% %outputpath% %recpath%
goto IMGKIT-DONE
:IMGKIT-DONE
ECHO. & ECHOC {%c_s%}完成. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& ENDLOCAL & call log %logger% I 完成功能IMGKIT& pause>nul & goto MENU


:INFO
SETLOCAL
set logger=example.bat-info
call log %logger% I 进入功能INFO
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.info.bat 读取设备信息
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.读取分区信息
ECHO.2.ADB或Fastboot读信息
ECHO.3.读取磁盘信息(如/dev/block/sda或/dev/block/mmcblk0)
ECHO.4.MTKClient读信息
call choice common [1][2][3][4]
goto INFO-C%choice%
:INFO-C1
ECHOC {%c_h%}分区名: {%c_i%}& set /p parname=
if "%parname%"=="" goto INFO-C1
ECHOC {%c_h%}请将设备进入系统或Recovery模式...{%c_i%}{\n}& call chkdev all
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" ECHOC {%c_e%}模式错误, 请进入系统或Recovery模式. {%c_h%}按任意键重试...{%c_i%}{\n}& pause>nul & ECHO.重试... & goto INFO-C1)
::call info par %parname%
call info par %parname% back
if "%info__par__exist%"=="y" (ECHO.%info__par__path%) else (ECHO.分区不存在)
goto INFO-DONE
:INFO-C2
ECHOC {%c_h%}请将设备进入系统,Recovery或Fastboot模式...{%c_i%}{\n}& call chkdev all
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" (if not "%chkdev__all__mode%"=="fastboot" ECHOC {%c_e%}模式错误, 请进入系统, Recovery或Fastboot模式. {%c_h%}按任意键重试...{%c_i%}{\n}& pause>nul & ECHO.重试... & goto INFO-C2))
if "%chkdev__all__mode%"=="system" call info adb
if "%chkdev__all__mode%"=="recovery" call info adb
if "%chkdev__all__mode%"=="fastboot" call info fastboot
ECHO.ADB信息: [设备代号:%info__adb__product%] [安卓版本:%info__adb__androidver%] [SDK版本:%info__adb__sdkver%]
ECHO.Fastboot信息: [设备代号:%info__fastboot__product%] [解锁状态:%info__fastboot__unlocked%]
goto INFO-DONE
:INFO-C3
ECHOC {%c_h%}磁盘路径: {%c_i%}& set /p diskpath=
if "%diskpath%"=="" goto INFO-C3
ECHOC {%c_h%}请将设备进入系统或Recovery模式...{%c_i%}{\n}& call chkdev all
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" ECHOC {%c_e%}模式错误, 请进入系统或Recovery模式. {%c_h%}按任意键重试...{%c_i%}{\n}& pause>nul & ECHO.重试... & goto INFO-C3)
call info disk %diskpath%
goto INFO-DONE
:INFO-C4
ECHOC {%c_h%}请将设备进入联发科brom模式...{%c_i%}{\n}& call chkdev mtkbrom
ECHO.正在读取信息... & call info mtkclient
ECHO.CPU: [%info__mtkclient__cpu%]
ECHO.MEID: [%info__mtkclient__meid%]
goto INFO-DONE
:INFO-DONE
ECHO. & ECHOC {%c_s%}完成. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& ENDLOCAL & call log %logger% I 完成功能INFO& pause>nul & goto MENU


:READ
SETLOCAL
set logger=example.bat-read
call log %logger% I 进入功能READ
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.read.bat 读出
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.系统或Recovery读出分区镜像
ECHO.2.9008读出分区镜像 (xml模式)
ECHO.3.9008读出分区镜像 (单分区模式)
call choice common [1][2][3]
goto READ-C%choice%
:READ-C1
ECHOC {%c_h%}请输入要读出的分区名: {%c_i%}& set /p parname=
if "%parname%"=="" goto READ-C1
call log %logger% I 输入分区名:%parname%
ECHOC {%c_h%}请选择img文件保存位置...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
ECHOC {%c_h%}请将设备进入系统或Recovery模式...{%c_i%}{\n}& call chkdev all
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" ECHOC {%c_e%}模式错误, 请进入系统或Recovery模式. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 模式错误:%chkdev__all__mode%.应进入系统或Recovery模式& pause>nul & ECHO.重试... & goto READ-C1)
ECHO.正在将%parname%读出到%sel__folder_path%(%chkdev__all__mode%)...& call read %chkdev__all__mode% %parname% %sel__folder_path%
goto READ-DONE
:READ-C2
ECHOC {%c_h%}请选择img文件保存目录...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
set searchpath=%sel__folder_path%
ECHOC {%c_h%}请选择rawprogram.xml文件...{%c_i%}{\n}& call sel file m %framwork_workspace% [xml]
set xml=%sel__files%
ECHO.是否选择patch.xml文件? & ECHO.1.选择   2.跳过& call choice common [1][2]
if "%choice%"=="1" ECHOC {%c_h%}请选择patch.xml文件...{%c_i%}{\n}& call sel file m %framwork_workspace% [xml]
if "%choice%"=="1" set xml=%xml%/%sel__files%
set fh=
ECHO.是否选择firehose引导文件? 选择则发送引导, 跳过则不发送& ECHO.1.选择   2.跳过& call choice common [1][2]
if "%choice%"=="1" ECHOC {%c_h%}请选择firehose引导文件...{%c_i%}{\n}& call sel file s %framwork_workspace% [elf]
if "%choice%"=="1" set fh=%sel__file_path%
ECHOC {%c_h%}请将设备进入9008模式...{%c_i%}{\n}& call chkdev edl rechk 1
call read edl %chkdev__edl__port% ufs %searchpath% %xml% %fh%
goto READ-DONE
:READ-C3
ECHOC {%c_h%}请输入要刷入的分区名: {%c_i%}& set /p parname=
if "%parname%"=="" goto READ-C3
call log %logger% I 输入分区名:%parname%
ECHOC {%c_h%}请选择img文件保存目录...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
set imgpath=%sel__folder_path%\%parname%.img
ECHO.是否选择firehose引导文件? 选择则发送引导, 跳过则不发送& ECHO.1.选择   2.跳过& call choice common [1][2]
if "%choice%"=="1" ECHOC {%c_h%}请选择firehose引导文件...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [elf]
if "%choice%"=="1" set fh=%sel__file_path%
ECHOC {%c_h%}请将设备进入9008模式...{%c_i%}{\n}& call chkdev edl rechk 1
start framwork logviewer start %logfile%
call read qcedlsingle %chkdev__edl__port% ufs %parname% %imgpath% %fh%
call framwork logviewer end
goto READ-DONE
:READ-DONE
ECHO. & ECHOC {%c_s%}完成. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& ENDLOCAL & call log %logger% I 完成功能READ& pause>nul & goto MENU


:REBOOT
SETLOCAL
set logger=example.bat-reboot
call log %logger% I 进入功能REBOOT
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.reboot.bat 重启
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.请选择要进入的模式:
ECHO.1.system
ECHO.2.recovery
ECHO.3.sideload
ECHO.4.fastboot
ECHO.5.fastbootd
ECHO.6.edl
ECHO.7.diag901d
call choice common [1][2][3][4][5][6][7]
if "%choice%"=="1" set target=system
if "%choice%"=="2" set target=recovery
if "%choice%"=="3" set target=sideload
if "%choice%"=="4" set target=fastboot
if "%choice%"=="5" set target=fastbootd
if "%choice%"=="6" set target=edl
if "%choice%"=="7" set target=diag901d
call chkdev all rechk 1
ECHO.进入%target%模式... & call reboot %chkdev__all__mode% %target% rechk 1
ECHO. & ECHOC {%c_s%}完成. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& ENDLOCAL & call log %logger% I 完成功能REBOOT& pause>nul & goto MENU


:WRITE
SETLOCAL
set logger=example.bat-write
call log %logger% I 进入功能WRITE
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.write.bat 写入
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.刷入分区镜像: 系统,Recovery或Fastboot
ECHO.2.Fastboot临时启动
ECHO.3.高通9008刷入 (xml模式)
ECHO.4.高通9008刷入 (单分区模式)
ECHO.5.刷入展讯pac包
ECHO.6.刷入联发科深度刷机包
ECHO.7.adb push
ECHO.
call choice common [1][2][3][4][5][6][7]
goto WRITE-C%choice%
:WRITE-C1
ECHOC {%c_h%}请输入要刷入的分区名: {%c_i%}& set /p parname=
if "%parname%"=="" goto WRITE-C1
call log %logger% I 输入分区名:%parname%
ECHOC {%c_h%}请选择要刷入的img文件...{%c_i%}{\n}& call sel file s %framwork_workspace% [img]
ECHOC {%c_h%}请将设备进入系统, Recovery或Fastboot模式...{%c_i%}{\n}& call chkdev all
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" (if not "%chkdev__all__mode%"=="fastboot" ECHOC {%c_e%}模式错误, 请进入系统, Recovery或Fastboot模式. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 模式错误:%chkdev__all__mode%.应进入系统或Recovery或Fastboot模式& pause>nul & ECHO.重试... & goto WRITE-C1))
ECHO.正在将%sel__file_path%刷入%parname%(%chkdev__all__mode%)...& call write %chkdev__all__mode% %parname% %sel__file_path%
goto INFO-DONE
:WRITE-C2
ECHOC {%c_h%}请选择要启动的img文件...{%c_i%}{\n}& call sel file s %framwork_workspace% [img]
ECHOC {%c_h%}请将设备进入Fastboot模式...{%c_i%}{\n}& call chkdev fastboot
ECHO.正在临时启动%sel__file_path%...& call write fastbootboot %sel__file_path%
goto WRITE-DONE
:WRITE-C3
ECHOC {%c_h%}请选择img文件所在目录...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
set searchpath=%sel__folder_path%
ECHOC {%c_h%}请选择rawprogram.xml文件...{%c_i%}{\n}& call sel file m %framwork_workspace% [xml]
set xml=%sel__files%
ECHO.是否选择patch.xml文件? & ECHO.1.选择   2.跳过& call choice common [1][2]
if "%choice%"=="1" ECHOC {%c_h%}请选择patch.xml文件...{%c_i%}{\n}& call sel file m %framwork_workspace% [xml]
if "%choice%"=="1" set xml=%xml%/%sel__files%
set fh=
ECHO.是否选择firehose引导文件? 选择则发送引导, 跳过则不发送& ECHO.1.选择   2.跳过& call choice common [1][2]
if "%choice%"=="1" ECHOC {%c_h%}请选择firehose引导文件...{%c_i%}{\n}& call sel file s %framwork_workspace% [elf]
if "%choice%"=="1" set fh=%sel__file_path%
ECHOC {%c_h%}请将设备进入9008模式...{%c_i%}{\n}& call chkdev edl rechk 1
start framwork logviewer start %logfile%
call write qcedlxml %chkdev__edl__port% ufs %searchpath% %xml% %fh%
call framwork logviewer end
goto WRITE-DONE
:WRITE-C4
ECHOC {%c_h%}请输入要刷入的分区名: {%c_i%}& set /p parname=
if "%parname%"=="" goto WRITE-C4
call log %logger% I 输入分区名:%parname%
ECHOC {%c_h%}请选择要刷入的img文件...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [img]
set imgpath=%sel__file_path%
ECHO.是否选择firehose引导文件? 选择则发送引导, 跳过则不发送& ECHO.1.选择   2.跳过& call choice common [1][2]
if "%choice%"=="1" ECHOC {%c_h%}请选择firehose引导文件...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [elf]
if "%choice%"=="1" set fh=%sel__file_path%
ECHOC {%c_h%}请将设备进入9008模式...{%c_i%}{\n}& call chkdev edl rechk 1
start framwork logviewer start %logfile%
call write qcedlsingle %chkdev__edl__port% ufs %parname% %imgpath% %fh%
call framwork logviewer end
goto WRITE-DONE
:WRITE-C5
ECHOC {%c_h%}请选择要刷入的pac文件...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [pac]
ECHOC {%c_h%}请将设备开机或进入展讯boot模式...{%c_i%}{\n}& call chkdev all
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="sprdboot" ECHOC {%c_e%}模式错误, 请进入系统或展讯boot模式. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 模式错误:%chkdev__all__mode%.应进入系统或展讯boot模式& pause>nul & ECHO.重试... & goto WRITE-C5)
if "%chkdev__all__mode%"=="system" call reboot system sprdboot chk
start framwork logviewer start %logfile%
ECHO.正在刷入pac... & call write sprdboot %chkdev__sprdboot__port% %sel__file_path%
call framwork logviewer end
goto WRITE-DONE
:WRITE-C6
ECHOC {%c_h%}请选择scatter.txt或xml文件...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [txt][xml]
set script=%sel__file_path%
if "%sel__file_ext%"=="xml" goto WRITE-C6-1
ECHO.1.使用默认da   2.手动选择da
call choice common #[1][2]
if "%choice%"=="1" set da=auto& goto WRITE-C6-1
ECHOC {%c_h%}请选择da文件...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [bin]
set da=%sel__file_path%
:WRITE-C6-1
ECHOC {%c_h%}请将设备进入联发科brom模式. {%c_i%}进入后会自动开始刷机...{%c_i%}{\n}
start framwork logviewer start tmp\output.txt
call write spflash %script% download %da%
call framwork logviewer end
goto WRITE-DONE
:WRITE-C7
ECHOC {%c_h%}请选择要推送的文件...{%c_i%}{\n}& call sel file s %framwork_workspace%
ECHO.1.普通   2.程序   3.程序(授权)
call choice common [1][2][3]
if "%choice%"=="1" set type=common
if "%choice%"=="2" set type=program
if "%choice%"=="3" set type=program_su
:WRITE-C7-1
ECHOC {%c_h%}请将设备进入系统或Recovery模式...{%c_i%}{\n}& call chkdev all
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" ECHOC {%c_e%}模式错误, 请进入系统或Recovery模式. {%c_h%}按任意键重试...{%c_i%}{\n}& pause>nul & ECHO.重试... & goto WRITE-C7-1)
ECHOC {%c_a%}正在推送...{%c_i%}{\n}& call write adbpush %sel__file_path% bff.test %type%
ECHO.推送完成. 位置为: %write__adbpush__filepath%
:WRITE-DONE
ECHO. & ECHOC {%c_s%}完成. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& ENDLOCAL & call log %logger% I 完成功能WRITE& pause>nul & goto MENU


:SCRCPY
SETLOCAL
set logger=example.bat-scrcpy
call log %logger% I 进入功能SCRCPY
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.scrcpy.bat 投屏
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHOC {%c_h%}请将设备进入系统...{%c_i%}{\n}& call chkdev system
call scrcpy 测试投屏
ECHO. & ECHOC {%c_s%}完成. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& ENDLOCAL & call log %logger% I 完成功能SCRCPY& pause>nul & goto MENU


:CLEAN
SETLOCAL
set logger=example.bat-clean
call log %logger% I 进入功能CLEAN
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.clean.bat 清除
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.TWRP恢复出厂
ECHO.2.TWRP格式化Data
ECHO.3.格式化FAT32,NTFS或EXFAT
call choice common [1][2][3]
goto CLEAN-C%choice%
:CLEAN-C1
ECHOC {%c_h%}请将设备进入Recovery...{%c_i%}{\n}& call chkdev recovery rechk 3
call clean twrpfactoryreset
goto CLEAN-DONE
:CLEAN-C2
ECHOC {%c_h%}请将设备进入Recovery...{%c_i%}{\n}& call chkdev recovery rechk 3
call clean twrpformatdata
goto CLEAN-DONE
:CLEAN-C3
ECHO.1.格式化为FAT32
ECHO.2.格式化为NTFS
ECHO.3.格式化为EXFAT
call choice common [1][2][3]
if "%choice%"=="1" set format=fat32
if "%choice%"=="2" set format=ntfs
if "%choice%"=="3" set format=exfat
ECHO.1.输入分区名字
ECHO.2.输入分区路径
call choice common [1][2]
goto CLEAN-C3-%choice%
:CLEAN-C3-1
ECHOC {%c_h%}输入分区名字按Enter继续: {%c_i%}& set /p choice=
if "%choice%"=="" goto CLEAN-C3-1
set var=name:%choice%& goto CLEAN-C3-A
:CLEAN-C3-2
ECHOC {%c_h%}输入分区路径按Enter继续: {%c_i%}& set /p choice=
if "%choice%"=="" goto CLEAN-C3-2
set var=path:%choice%& goto CLEAN-C3-A
:CLEAN-C3-A
ECHOC {%c_h%}请将设备进入Recovery...{%c_i%}{\n}& call chkdev recovery
call clean format%format% %var%
goto CLEAN-DONE
:CLEAN-DONE
ECHO. & ECHOC {%c_s%}完成. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& ENDLOCAL & call log %logger% I 完成功能CLEAN& pause>nul & goto MENU


:THEME
SETLOCAL
set logger=example.bat-theme
call log %logger% I 进入功能THEME
:THEME-1
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.主题
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.默认
ECHO.2.经典
ECHO.3.乌班图
ECHO.4.抖音黑客
ECHO.5.流金
ECHO.6.DOS
ECHO.7.过年好
ECHO.A.返回主菜单
call choice common [1][2][3][4][5][6][7][A]
if "%choice%"=="1" set target=default
if "%choice%"=="2" set target=classic
if "%choice%"=="3" set target=ubuntu
if "%choice%"=="4" set target=douyinhacker
if "%choice%"=="5" set target=gold
if "%choice%"=="6" set target=dos
if "%choice%"=="7" set target=ChineseNewYear
if "%choice%"=="A" ENDLOCAL & call log %logger% I 完成功能THEME& goto MENU
::加载预览
call framwork theme %target%
echo.@ECHO OFF>tmp\theme.bat
echo.mode con cols=50 lines=17 >>tmp\theme.bat
echo.cd ..>>tmp\theme.bat
echo.set path=%framwork_workspace%;%framwork_workspace%\tool\Windows;%framwork_workspace%\tool\Android;%path% >>tmp\theme.bat
echo.COLOR %c_i% >>tmp\theme.bat
echo.TITLE 主题预览: %target% >>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_i%}普通信息{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_w%}警告信息{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_e%}错误信息{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_s%}成功信息{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_h%}手动操作提示{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_a%}强调色{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_we%}弱化色{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.pause^>nul>>tmp\theme.bat
echo.EXIT>>tmp\theme.bat
call framwork theme
start tmp\theme.bat
::加载预览完成
ECHO.
ECHO.已加载预览. 是否使用该主题
ECHO.1.使用   2.不使用
call choice common #[1][2]
if "%choice%"=="1" call framwork conf user.bat framwork_theme %target%& ECHOC {%c_i%}已更换主题, 重新打开脚本生效. {%c_h%}按任意键关闭脚本...{%c_i%}{\n}& call log %logger% I 更换主题为%target%& pause>nul & EXIT
if "%choice%"=="2" goto THEME-1


:SLOT
SETLOCAL
set logger=example.bat-slot
call log %logger% I 进入功能SLOT
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.slot.bat 槽位功能
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.检查当前槽位
ECHO.2.设置槽位
call choice common [1][2]
ECHOC {%c_h%}请将设备进入系统, Recovery或Fastboot模式...{%c_i%}{\n}& call chkdev all
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" (if not "%chkdev__all__mode%"=="fastboot" ECHOC {%c_e%}模式错误, 请进入系统, Recovery或Fastboot模式. {%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 模式错误:%chkdev__all__mode%.应进入系统或Recovery或Fastboot模式& pause>nul & ECHO.重试... & goto SLOT))
goto SLOT-C%choice%
:SLOT-C1
call slot %chkdev__all__mode% chk
ECHO.[当前槽位:%slot__cur%] [当前槽位的另一槽位:%slot__cur_oth%] [当前槽位是否不可用:%slot__cur_unbootable%] [当前槽位的另一槽位是否不可用:%slot__cur_oth_unbootable%]
goto SLOT-DONE
:SLOT-C2
ECHOC {%c_h%}输入目标槽位按Enter继续: {%c_i%}& set /p choice=
call slot %chkdev__all__mode% set %choice%
goto SLOT-DONE
:SLOT-DONE
ECHO. & ECHOC {%c_s%}完成. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& ENDLOCAL & call log %logger% I 完成功能SLOT& pause>nul & goto MENU


:LOG
SETLOCAL
set logger=example.bat-log
call log %logger% I 进入功能LOG
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.开关日志
ECHO.=--------------------------------------------------------------------=
ECHO.
if "%framwork_log%"=="y" (ECHO.1.[当前]开启日志) else (ECHO.1.      开启日志)
if "%framwork_log%"=="n" (ECHO.2.[当前]关闭日志) else (ECHO.2.      关闭日志)
call choice common [1][2]
if "%choice%"=="1" call framwork conf user.bat framwork_log y
if "%choice%"=="2" call framwork conf user.bat framwork_log n
ECHO. & ECHOC {%c_s%}完成. {%c_i%}更改将在下次启动时生效. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& ENDLOCAL & call log %logger% I 完成功能SLOT& pause>nul & goto MENU


:PAR
SETLOCAL
set logger=example.bat-par
call log %logger% I 进入功能PAR
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.par.bat 分区
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.删除和建立userdata分区
ECHO.2.设置最大分区数
ECHO.3.备份分区表
ECHO.4.恢复分区表
ECHO.A.主菜单
call choice common [1][2][3][4][A]
if "%choice%"=="A" ENDLOCAL & call log %logger% I 完成功能PAR& goto MENU
ECHOC {%c_h%}请将设备进入Recovery...{%c_i%}{\n}& call chkdev recovery
goto PAR-C%choice%
:PAR-C1
ECHO.正在读取分区信息... & call info par userdata
set diskpath_userdata=%info__par__diskpath%& set partype_userdata=%info__par__type%& set parstart_userdata=%info__par__start%& set parend_userdata=%info__par__end%& set parnum_userdata=%info__par__num%
ECHO. & adb.exe shell ./sgdisk -p %diskpath_userdata%& ECHO.
ECHO.按任意键开始删除... & pause>nul & ECHO.删除分区... & call par rm %diskpath_userdata% numb:%parnum_userdata%
ECHO. & adb.exe shell ./sgdisk -p %diskpath_userdata%& ECHO.
ECHO.按任意键开始建立... & pause>nul & ECHO.建立分区... & call par mk %diskpath_userdata% userdata %partype_userdata% %parstart_userdata% %parend_userdata% %parnum_userdata%
ECHO. & adb.exe shell ./sgdisk -p %diskpath_userdata%
ECHO. & ECHOC {%c_s%}完成. {%c_i%}更改将在下次启动时生效. {%c_h%}按任意键返回...{%c_i%}{\n}& ENDLOCAL & call log %logger% I 完成功能PAR& pause>nul & goto MENU
:PAR-C2
ECHOC {%c_h%}输入目标磁盘路径按Enter继续: {%c_i%}& set /p diskpath=
if "%diskpath%"=="" goto PAR-C2
ECHOC {%c_h%}输入最大分区数按Enter继续(默认128): {%c_i%}& set /p maxparnum=
ECHO.正在设置最大分区数... & call par setmaxparnum %diskpath% %maxparnum%
ECHO. & ECHOC {%c_s%}完成. {%c_i%}更改将在下次启动时生效. {%c_h%}按任意键返回...{%c_i%}{\n}& ENDLOCAL & call log %logger% I 完成功能PAR& pause>nul & goto MENU
:PAR-C3
ECHOC {%c_h%}输入目标磁盘路径按Enter继续: {%c_i%}& set /p diskpath=
if "%diskpath%"=="" goto PAR-C3
ECHOC {%c_h%}请选择保存文件夹...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
ECHO.正在备份分区表到%diskpath% %sel__folder_path%\partable.bak... & call par bakpartable %diskpath% %sel__file_path%\partable.bak
ECHO. & ECHOC {%c_s%}完成. {%c_h%}按任意键返回...{%c_i%}{\n}& ENDLOCAL & call log %logger% I 完成功能PAR& pause>nul & goto MENU
:PAR-C4
ECHOC {%c_h%}输入目标磁盘路径按Enter继续: {%c_i%}& set /p diskpath=
if "%diskpath%"=="" goto PAR-C4
ECHOC {%c_h%}请选择分区表文件...{%c_i%}{\n}& call sel file s %framwork_workspace%\..
ECHO.正在恢复分区表... & call par recpartable %diskpath% %sel__file_path%
ECHO. & ECHOC {%c_s%}完成. {%c_i%}更改将在下次启动时生效. {%c_h%}按任意键返回...{%c_i%}{\n}& ENDLOCAL & call log %logger% I 完成功能PAR& pause>nul & goto MENU






:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}抱歉, 脚本遇到问题, 无法继续运行. 请查看日志. {%c_h%}按任意键退出...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.抱歉, 脚本遇到问题, 无法继续运行. 按任意键退出...& pause>nul & EXIT)
