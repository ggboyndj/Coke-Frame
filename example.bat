::����һ�����ű�ʾ��,�밴�մ�ʾ���е�����������ɽű�������.

::����׼��,����Ķ�
@ECHO OFF
chcp 936>nul
cd /d %~dp0
if exist bin (cd bin) else (ECHO.�Ҳ���bin & goto FATAL)

::��������,������Զ���������ļ�Ҳ���Լ�������
if exist conf\fixed.bat (call conf\fixed) else (ECHO.�Ҳ���conf\fixed.bat & goto FATAL)
if exist conf\user.bat call conf\user

::��������,����Ķ�
if "%framwork_theme%"=="" set framwork_theme=default
call framwork theme %framwork_theme%
COLOR %c_i%

::�Զ��崰�ڴ�С,���԰�����Ҫ�Ķ�
TITLE ����������...
mode con cols=71

::���ͻ�ȡ����ԱȨ��,�粻��Ҫ����ȥ��
if not exist tool\Windows\gap.exe ECHO.�Ҳ���gap.exe & goto FATAL
if exist %windir%\System32\bff-test rd %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT
md %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT
rd %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT

::����׼���ͼ��,����Ķ�
call framwork startpre
::call framwork startpre skiptoolchk

::�������.���������д��Ľű�
TITLE ����ʾ�� ��ܰ汾:%framwork_ver% 
CLS
goto MENU



:MENU
call log example.bat-menu I �������˵�
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.���˵�
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.�˽ű�������ʾ�Ͳ��Ը�ģ�鹦��
ECHO.
ECHO.1.chkdev.bat ����豸����
ECHO.2.dl.bat ����ģ��
ECHO.3.imgkit.bat ����������
ECHO.4.info.bat ��ȡ�豸��Ϣ
ECHO.5.read.bat ����
ECHO.6.reboot.bat ����
ECHO.7.write.bat д��
ECHO.8.clean.bat ���
ECHO.9.scrcpy.bat Ͷ��
ECHO.10.��������
ECHO.11.��λ����
ECHO.12.������־
ECHO.13.par.bat ����
ECHO.14.ʵʱ��־���
ECHO.15.sel.bat ѡ���ļ�(��)
ECHO.16.random.bat ���������
ECHO.17.choice.bat ѡ��
ECHO.18.mtkclient����
ECHO.A.�������˵�
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
call log %logger% I ���빦��MTKCLIENT
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.mtkclient����
ECHO.=--------------------------------------------------------------------=
:MTKCLIENT-1
ECHO.
ECHOC {%c_h%}������mtkclient����: {%c_i%}& set /p cmd=
ECHO.����ִ������...
echo.>tmp\output.txt
start framwork logviewer start tmp\output.txt
call tool\Windows\mtkclient\mtkclient.bat %cmd%
call framwork logviewer end
type tmp\output.txt
goto MTKCLIENT-1


:CHOICE
SETLOCAL
set logger=example.bat-choice
call log %logger% I ���빦��CHOICE
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.choice.bat ѡ��
ECHO.=--------------------------------------------------------------------=
:CHOICE-1
ECHO.
call choice common
ECHO.[%choice%]
goto CHOICE-1


:RANDOM
SETLOCAL
set logger=example.bat-random
call log %logger% I ���빦��RANDOM
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.random.bat ���������
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.��Ĭ���ַ���(abcdefghijklmnopqrstuvwxyz0123456789)������5λ�����.
ECHO.
:RANDOM-1
call random 5
ECHO.���: [%random__str%]
ECHOC {%c_h%}���������������...{%c_i%}{\n}& pause>nul & goto RANDOM-1


:SEL
SETLOCAL
set logger=example.bat-sel
call log %logger% I ���빦��SEL
:SEL-1
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.sel.bat ѡ���ļ�(��)
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.��ѡ�ļ�
ECHO.2.��ѡ�ļ�
ECHO.3.��ѡ�ļ���
ECHO.4.��ѡ�ļ���
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
ECHO. & ECHOC {%c_s%}���. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & goto SEL


:LOGVIEWER
SETLOCAL
set logger=example.bat-logviewer
call log %logger% I ���빦��LOGVIEWER
:LOGVIEWER-1
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.framwork.bat ʵʱ��־���
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.��ǰ��־�ļ�: %logfile%
ECHO.
ECHO.1.�������
ECHO.2.�رռ��
ECHO.A.�������˵�
ECHO.
call choice common [1][2][A]
if "%choice%"=="1" start framwork logviewer start %logfile%
if "%choice%"=="2" call framwork logviewer end
if "%choice%"=="A" ENDLOCAL & call log %logger% I ��ɹ���LOGVIEWER& goto MENU
goto LOGVIEWER-1


:CHKDEV
SETLOCAL
set logger=example.bat-chkdev
call log %logger% I ���빦��CHKDEV
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.chkdev.bat ����豸����
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.����豸����(ȫ��)
ECHO.2.����豸����(ϵͳ)
ECHO.3.����豸����(Recovery)
ECHO.4.����豸����(sideload)
ECHO.5.����豸����(Fastboot)
ECHO.6.����豸����(edl)
ECHO.7.����豸����(diag901d)
ECHO.8.����豸����(sprdboot)
ECHO.9.����豸����(mtkbrom)
ECHO.10.����豸����(mtkpreloader)
ECHO.11.����豸����(ȫ��) ����
ECHO.12.����豸����(ϵͳ) 2��󸴲�
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
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���CHKDEV& pause>nul & goto MENU


:DL
SETLOCAL
set logger=example.bat-dl
call log %logger% I ���빦��DL
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.dl.bat ����
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.����ֱ��
ECHO.2.���������������
call choice common [1][2]
goto DL-C%choice%
:DL-C1
ECHOC {%c_h%}������ֱ��: {%c_i%}& set /p choice=
ECHOC {%c_h%}��ѡ�񱣴��ļ���...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
call dl direct %choice% %sel__folder_path%\dl.test once notice
goto DL-DONE
:DL-C2
ECHOC {%c_h%}�����������������: {%c_i%}& set /p choice=
ECHOC {%c_h%}��ѡ�񱣴��ļ���...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
call dl lzlink %choice% %sel__folder_path%\dl.test once notice
goto DL-DONE
:DL-DONE
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���DL& pause>nul & goto MENU


:IMGKIT
SETLOCAL
set logger=example.bat-imgkit
call log %logger% I ���빦��IMGKIT
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.imgkit.bat ����������ģ��
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.����޲�boot
ECHO.2.Ϊbootע��recovery
call choice common [1][2]
goto IMGKIT-C%choice%
:IMGKIT-C1
ECHOC {%c_h%}��ѡ��boot�ļ�...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [img]
set bootpath=%sel__file_path%
ECHOC {%c_h%}��ѡ��Magisk(������zip��apk)...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [zip][apk]
set zippath=%sel__file_path%
ECHOC {%c_h%}��ѡ����boot����λ��...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
set outputpath=%sel__folder_path%\boot_new.img
call imgkit magiskpatch %bootpath% %outputpath% %zippath%
goto IMGKIT-DONE
:IMGKIT-C2
ECHOC {%c_h%}��ѡ��boot.img...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [img]
set bootpath=%sel__file_path%
ECHOC {%c_h%}��ѡ��recovery(������img��ramdisk.cpio)...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [img][cpio]
set recpath=%sel__file_path%
ECHOC {%c_h%}��ѡ����boot����λ��...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
set outputpath=%sel__folder_path%\boot_new.img
call imgkit recinst %bootpath% %outputpath% %recpath%
goto IMGKIT-DONE
:IMGKIT-DONE
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���IMGKIT& pause>nul & goto MENU


:INFO
SETLOCAL
set logger=example.bat-info
call log %logger% I ���빦��INFO
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.info.bat ��ȡ�豸��Ϣ
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.��ȡ������Ϣ
ECHO.2.ADB��Fastboot����Ϣ
ECHO.3.��ȡ������Ϣ(��/dev/block/sda��/dev/block/mmcblk0)
ECHO.4.MTKClient����Ϣ
call choice common [1][2][3][4]
goto INFO-C%choice%
:INFO-C1
ECHOC {%c_h%}������: {%c_i%}& set /p parname=
if "%parname%"=="" goto INFO-C1
ECHOC {%c_h%}�뽫�豸����ϵͳ��Recoveryģʽ...{%c_i%}{\n}& call chkdev all
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" ECHOC {%c_e%}ģʽ����, �����ϵͳ��Recoveryģʽ. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto INFO-C1)
::call info par %parname%
call info par %parname% back
if "%info__par__exist%"=="y" (ECHO.%info__par__path%) else (ECHO.����������)
goto INFO-DONE
:INFO-C2
ECHOC {%c_h%}�뽫�豸����ϵͳ,Recovery��Fastbootģʽ...{%c_i%}{\n}& call chkdev all
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" (if not "%chkdev__all__mode%"=="fastboot" ECHOC {%c_e%}ģʽ����, �����ϵͳ, Recovery��Fastbootģʽ. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto INFO-C2))
if "%chkdev__all__mode%"=="system" call info adb
if "%chkdev__all__mode%"=="recovery" call info adb
if "%chkdev__all__mode%"=="fastboot" call info fastboot
ECHO.ADB��Ϣ: [�豸����:%info__adb__product%] [��׿�汾:%info__adb__androidver%] [SDK�汾:%info__adb__sdkver%]
ECHO.Fastboot��Ϣ: [�豸����:%info__fastboot__product%] [����״̬:%info__fastboot__unlocked%]
goto INFO-DONE
:INFO-C3
ECHOC {%c_h%}����·��: {%c_i%}& set /p diskpath=
if "%diskpath%"=="" goto INFO-C3
ECHOC {%c_h%}�뽫�豸����ϵͳ��Recoveryģʽ...{%c_i%}{\n}& call chkdev all
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" ECHOC {%c_e%}ģʽ����, �����ϵͳ��Recoveryģʽ. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto INFO-C3)
call info disk %diskpath%
goto INFO-DONE
:INFO-C4
ECHOC {%c_h%}�뽫�豸����������bromģʽ...{%c_i%}{\n}& call chkdev mtkbrom
ECHO.���ڶ�ȡ��Ϣ... & call info mtkclient
ECHO.CPU: [%info__mtkclient__cpu%]
ECHO.MEID: [%info__mtkclient__meid%]
goto INFO-DONE
:INFO-DONE
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���INFO& pause>nul & goto MENU


:READ
SETLOCAL
set logger=example.bat-read
call log %logger% I ���빦��READ
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.read.bat ����
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.ϵͳ��Recovery������������
ECHO.2.9008������������ (xmlģʽ)
ECHO.3.9008������������ (������ģʽ)
call choice common [1][2][3]
goto READ-C%choice%
:READ-C1
ECHOC {%c_h%}������Ҫ�����ķ�����: {%c_i%}& set /p parname=
if "%parname%"=="" goto READ-C1
call log %logger% I ���������:%parname%
ECHOC {%c_h%}��ѡ��img�ļ�����λ��...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
ECHOC {%c_h%}�뽫�豸����ϵͳ��Recoveryģʽ...{%c_i%}{\n}& call chkdev all
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" ECHOC {%c_e%}ģʽ����, �����ϵͳ��Recoveryģʽ. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ģʽ����:%chkdev__all__mode%.Ӧ����ϵͳ��Recoveryģʽ& pause>nul & ECHO.����... & goto READ-C1)
ECHO.���ڽ�%parname%������%sel__folder_path%(%chkdev__all__mode%)...& call read %chkdev__all__mode% %parname% %sel__folder_path%
goto READ-DONE
:READ-C2
ECHOC {%c_h%}��ѡ��img�ļ�����Ŀ¼...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
set searchpath=%sel__folder_path%
ECHOC {%c_h%}��ѡ��rawprogram.xml�ļ�...{%c_i%}{\n}& call sel file m %framwork_workspace% [xml]
set xml=%sel__files%
ECHO.�Ƿ�ѡ��patch.xml�ļ�? & ECHO.1.ѡ��   2.����& call choice common [1][2]
if "%choice%"=="1" ECHOC {%c_h%}��ѡ��patch.xml�ļ�...{%c_i%}{\n}& call sel file m %framwork_workspace% [xml]
if "%choice%"=="1" set xml=%xml%/%sel__files%
set fh=
ECHO.�Ƿ�ѡ��firehose�����ļ�? ѡ����������, �����򲻷���& ECHO.1.ѡ��   2.����& call choice common [1][2]
if "%choice%"=="1" ECHOC {%c_h%}��ѡ��firehose�����ļ�...{%c_i%}{\n}& call sel file s %framwork_workspace% [elf]
if "%choice%"=="1" set fh=%sel__file_path%
ECHOC {%c_h%}�뽫�豸����9008ģʽ...{%c_i%}{\n}& call chkdev edl rechk 1
call read edl %chkdev__edl__port% ufs %searchpath% %xml% %fh%
goto READ-DONE
:READ-C3
ECHOC {%c_h%}������Ҫˢ��ķ�����: {%c_i%}& set /p parname=
if "%parname%"=="" goto READ-C3
call log %logger% I ���������:%parname%
ECHOC {%c_h%}��ѡ��img�ļ�����Ŀ¼...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
set imgpath=%sel__folder_path%\%parname%.img
ECHO.�Ƿ�ѡ��firehose�����ļ�? ѡ����������, �����򲻷���& ECHO.1.ѡ��   2.����& call choice common [1][2]
if "%choice%"=="1" ECHOC {%c_h%}��ѡ��firehose�����ļ�...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [elf]
if "%choice%"=="1" set fh=%sel__file_path%
ECHOC {%c_h%}�뽫�豸����9008ģʽ...{%c_i%}{\n}& call chkdev edl rechk 1
start framwork logviewer start %logfile%
call read qcedlsingle %chkdev__edl__port% ufs %parname% %imgpath% %fh%
call framwork logviewer end
goto READ-DONE
:READ-DONE
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���READ& pause>nul & goto MENU


:REBOOT
SETLOCAL
set logger=example.bat-reboot
call log %logger% I ���빦��REBOOT
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.reboot.bat ����
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.��ѡ��Ҫ�����ģʽ:
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
ECHO.����%target%ģʽ... & call reboot %chkdev__all__mode% %target% rechk 1
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���REBOOT& pause>nul & goto MENU


:WRITE
SETLOCAL
set logger=example.bat-write
call log %logger% I ���빦��WRITE
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.write.bat д��
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.ˢ���������: ϵͳ,Recovery��Fastboot
ECHO.2.Fastboot��ʱ����
ECHO.3.��ͨ9008ˢ�� (xmlģʽ)
ECHO.4.��ͨ9008ˢ�� (������ģʽ)
ECHO.5.ˢ��չѶpac��
ECHO.6.ˢ�����������ˢ����
ECHO.7.adb push
ECHO.
call choice common [1][2][3][4][5][6][7]
goto WRITE-C%choice%
:WRITE-C1
ECHOC {%c_h%}������Ҫˢ��ķ�����: {%c_i%}& set /p parname=
if "%parname%"=="" goto WRITE-C1
call log %logger% I ���������:%parname%
ECHOC {%c_h%}��ѡ��Ҫˢ���img�ļ�...{%c_i%}{\n}& call sel file s %framwork_workspace% [img]
ECHOC {%c_h%}�뽫�豸����ϵͳ, Recovery��Fastbootģʽ...{%c_i%}{\n}& call chkdev all
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" (if not "%chkdev__all__mode%"=="fastboot" ECHOC {%c_e%}ģʽ����, �����ϵͳ, Recovery��Fastbootģʽ. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ģʽ����:%chkdev__all__mode%.Ӧ����ϵͳ��Recovery��Fastbootģʽ& pause>nul & ECHO.����... & goto WRITE-C1))
ECHO.���ڽ�%sel__file_path%ˢ��%parname%(%chkdev__all__mode%)...& call write %chkdev__all__mode% %parname% %sel__file_path%
goto INFO-DONE
:WRITE-C2
ECHOC {%c_h%}��ѡ��Ҫ������img�ļ�...{%c_i%}{\n}& call sel file s %framwork_workspace% [img]
ECHOC {%c_h%}�뽫�豸����Fastbootģʽ...{%c_i%}{\n}& call chkdev fastboot
ECHO.������ʱ����%sel__file_path%...& call write fastbootboot %sel__file_path%
goto WRITE-DONE
:WRITE-C3
ECHOC {%c_h%}��ѡ��img�ļ�����Ŀ¼...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
set searchpath=%sel__folder_path%
ECHOC {%c_h%}��ѡ��rawprogram.xml�ļ�...{%c_i%}{\n}& call sel file m %framwork_workspace% [xml]
set xml=%sel__files%
ECHO.�Ƿ�ѡ��patch.xml�ļ�? & ECHO.1.ѡ��   2.����& call choice common [1][2]
if "%choice%"=="1" ECHOC {%c_h%}��ѡ��patch.xml�ļ�...{%c_i%}{\n}& call sel file m %framwork_workspace% [xml]
if "%choice%"=="1" set xml=%xml%/%sel__files%
set fh=
ECHO.�Ƿ�ѡ��firehose�����ļ�? ѡ����������, �����򲻷���& ECHO.1.ѡ��   2.����& call choice common [1][2]
if "%choice%"=="1" ECHOC {%c_h%}��ѡ��firehose�����ļ�...{%c_i%}{\n}& call sel file s %framwork_workspace% [elf]
if "%choice%"=="1" set fh=%sel__file_path%
ECHOC {%c_h%}�뽫�豸����9008ģʽ...{%c_i%}{\n}& call chkdev edl rechk 1
start framwork logviewer start %logfile%
call write qcedlxml %chkdev__edl__port% ufs %searchpath% %xml% %fh%
call framwork logviewer end
goto WRITE-DONE
:WRITE-C4
ECHOC {%c_h%}������Ҫˢ��ķ�����: {%c_i%}& set /p parname=
if "%parname%"=="" goto WRITE-C4
call log %logger% I ���������:%parname%
ECHOC {%c_h%}��ѡ��Ҫˢ���img�ļ�...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [img]
set imgpath=%sel__file_path%
ECHO.�Ƿ�ѡ��firehose�����ļ�? ѡ����������, �����򲻷���& ECHO.1.ѡ��   2.����& call choice common [1][2]
if "%choice%"=="1" ECHOC {%c_h%}��ѡ��firehose�����ļ�...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [elf]
if "%choice%"=="1" set fh=%sel__file_path%
ECHOC {%c_h%}�뽫�豸����9008ģʽ...{%c_i%}{\n}& call chkdev edl rechk 1
start framwork logviewer start %logfile%
call write qcedlsingle %chkdev__edl__port% ufs %parname% %imgpath% %fh%
call framwork logviewer end
goto WRITE-DONE
:WRITE-C5
ECHOC {%c_h%}��ѡ��Ҫˢ���pac�ļ�...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [pac]
ECHOC {%c_h%}�뽫�豸���������չѶbootģʽ...{%c_i%}{\n}& call chkdev all
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="sprdboot" ECHOC {%c_e%}ģʽ����, �����ϵͳ��չѶbootģʽ. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ģʽ����:%chkdev__all__mode%.Ӧ����ϵͳ��չѶbootģʽ& pause>nul & ECHO.����... & goto WRITE-C5)
if "%chkdev__all__mode%"=="system" call reboot system sprdboot chk
start framwork logviewer start %logfile%
ECHO.����ˢ��pac... & call write sprdboot %chkdev__sprdboot__port% %sel__file_path%
call framwork logviewer end
goto WRITE-DONE
:WRITE-C6
ECHOC {%c_h%}��ѡ��scatter.txt��xml�ļ�...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [txt][xml]
set script=%sel__file_path%
if "%sel__file_ext%"=="xml" goto WRITE-C6-1
ECHO.1.ʹ��Ĭ��da   2.�ֶ�ѡ��da
call choice common #[1][2]
if "%choice%"=="1" set da=auto& goto WRITE-C6-1
ECHOC {%c_h%}��ѡ��da�ļ�...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [bin]
set da=%sel__file_path%
:WRITE-C6-1
ECHOC {%c_h%}�뽫�豸����������bromģʽ. {%c_i%}�������Զ���ʼˢ��...{%c_i%}{\n}
start framwork logviewer start tmp\output.txt
call write spflash %script% download %da%
call framwork logviewer end
goto WRITE-DONE
:WRITE-C7
ECHOC {%c_h%}��ѡ��Ҫ���͵��ļ�...{%c_i%}{\n}& call sel file s %framwork_workspace%
ECHO.1.��ͨ   2.����   3.����(��Ȩ)
call choice common [1][2][3]
if "%choice%"=="1" set type=common
if "%choice%"=="2" set type=program
if "%choice%"=="3" set type=program_su
:WRITE-C7-1
ECHOC {%c_h%}�뽫�豸����ϵͳ��Recoveryģʽ...{%c_i%}{\n}& call chkdev all
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" ECHOC {%c_e%}ģʽ����, �����ϵͳ��Recoveryģʽ. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto WRITE-C7-1)
ECHOC {%c_a%}��������...{%c_i%}{\n}& call write adbpush %sel__file_path% bff.test %type%
ECHO.�������. λ��Ϊ: %write__adbpush__filepath%
:WRITE-DONE
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���WRITE& pause>nul & goto MENU


:SCRCPY
SETLOCAL
set logger=example.bat-scrcpy
call log %logger% I ���빦��SCRCPY
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.scrcpy.bat Ͷ��
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHOC {%c_h%}�뽫�豸����ϵͳ...{%c_i%}{\n}& call chkdev system
call scrcpy ����Ͷ��
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���SCRCPY& pause>nul & goto MENU


:CLEAN
SETLOCAL
set logger=example.bat-clean
call log %logger% I ���빦��CLEAN
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.clean.bat ���
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.TWRP�ָ�����
ECHO.2.TWRP��ʽ��Data
ECHO.3.��ʽ��FAT32,NTFS��EXFAT
call choice common [1][2][3]
goto CLEAN-C%choice%
:CLEAN-C1
ECHOC {%c_h%}�뽫�豸����Recovery...{%c_i%}{\n}& call chkdev recovery rechk 3
call clean twrpfactoryreset
goto CLEAN-DONE
:CLEAN-C2
ECHOC {%c_h%}�뽫�豸����Recovery...{%c_i%}{\n}& call chkdev recovery rechk 3
call clean twrpformatdata
goto CLEAN-DONE
:CLEAN-C3
ECHO.1.��ʽ��ΪFAT32
ECHO.2.��ʽ��ΪNTFS
ECHO.3.��ʽ��ΪEXFAT
call choice common [1][2][3]
if "%choice%"=="1" set format=fat32
if "%choice%"=="2" set format=ntfs
if "%choice%"=="3" set format=exfat
ECHO.1.�����������
ECHO.2.�������·��
call choice common [1][2]
goto CLEAN-C3-%choice%
:CLEAN-C3-1
ECHOC {%c_h%}����������ְ�Enter����: {%c_i%}& set /p choice=
if "%choice%"=="" goto CLEAN-C3-1
set var=name:%choice%& goto CLEAN-C3-A
:CLEAN-C3-2
ECHOC {%c_h%}�������·����Enter����: {%c_i%}& set /p choice=
if "%choice%"=="" goto CLEAN-C3-2
set var=path:%choice%& goto CLEAN-C3-A
:CLEAN-C3-A
ECHOC {%c_h%}�뽫�豸����Recovery...{%c_i%}{\n}& call chkdev recovery
call clean format%format% %var%
goto CLEAN-DONE
:CLEAN-DONE
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���CLEAN& pause>nul & goto MENU


:THEME
SETLOCAL
set logger=example.bat-theme
call log %logger% I ���빦��THEME
:THEME-1
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.����
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.Ĭ��
ECHO.2.����
ECHO.3.�ڰ�ͼ
ECHO.4.�����ڿ�
ECHO.5.����
ECHO.6.DOS
ECHO.7.�����
ECHO.A.�������˵�
call choice common [1][2][3][4][5][6][7][A]
if "%choice%"=="1" set target=default
if "%choice%"=="2" set target=classic
if "%choice%"=="3" set target=ubuntu
if "%choice%"=="4" set target=douyinhacker
if "%choice%"=="5" set target=gold
if "%choice%"=="6" set target=dos
if "%choice%"=="7" set target=ChineseNewYear
if "%choice%"=="A" ENDLOCAL & call log %logger% I ��ɹ���THEME& goto MENU
::����Ԥ��
call framwork theme %target%
echo.@ECHO OFF>tmp\theme.bat
echo.mode con cols=50 lines=17 >>tmp\theme.bat
echo.cd ..>>tmp\theme.bat
echo.set path=%framwork_workspace%;%framwork_workspace%\tool\Windows;%framwork_workspace%\tool\Android;%path% >>tmp\theme.bat
echo.COLOR %c_i% >>tmp\theme.bat
echo.TITLE ����Ԥ��: %target% >>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_i%}��ͨ��Ϣ{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_w%}������Ϣ{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_e%}������Ϣ{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_s%}�ɹ���Ϣ{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_h%}�ֶ�������ʾ{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_a%}ǿ��ɫ{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_we%}����ɫ{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.pause^>nul>>tmp\theme.bat
echo.EXIT>>tmp\theme.bat
call framwork theme
start tmp\theme.bat
::����Ԥ�����
ECHO.
ECHO.�Ѽ���Ԥ��. �Ƿ�ʹ�ø�����
ECHO.1.ʹ��   2.��ʹ��
call choice common #[1][2]
if "%choice%"=="1" call framwork conf user.bat framwork_theme %target%& ECHOC {%c_i%}�Ѹ�������, ���´򿪽ű���Ч. {%c_h%}��������رսű�...{%c_i%}{\n}& call log %logger% I ��������Ϊ%target%& pause>nul & EXIT
if "%choice%"=="2" goto THEME-1


:SLOT
SETLOCAL
set logger=example.bat-slot
call log %logger% I ���빦��SLOT
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.slot.bat ��λ����
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.��鵱ǰ��λ
ECHO.2.���ò�λ
call choice common [1][2]
ECHOC {%c_h%}�뽫�豸����ϵͳ, Recovery��Fastbootģʽ...{%c_i%}{\n}& call chkdev all
if not "%chkdev__all__mode%"=="system" (if not "%chkdev__all__mode%"=="recovery" (if not "%chkdev__all__mode%"=="fastboot" ECHOC {%c_e%}ģʽ����, �����ϵͳ, Recovery��Fastbootģʽ. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ģʽ����:%chkdev__all__mode%.Ӧ����ϵͳ��Recovery��Fastbootģʽ& pause>nul & ECHO.����... & goto SLOT))
goto SLOT-C%choice%
:SLOT-C1
call slot %chkdev__all__mode% chk
ECHO.[��ǰ��λ:%slot__cur%] [��ǰ��λ����һ��λ:%slot__cur_oth%] [��ǰ��λ�Ƿ񲻿���:%slot__cur_unbootable%] [��ǰ��λ����һ��λ�Ƿ񲻿���:%slot__cur_oth_unbootable%]
goto SLOT-DONE
:SLOT-C2
ECHOC {%c_h%}����Ŀ���λ��Enter����: {%c_i%}& set /p choice=
call slot %chkdev__all__mode% set %choice%
goto SLOT-DONE
:SLOT-DONE
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���SLOT& pause>nul & goto MENU


:LOG
SETLOCAL
set logger=example.bat-log
call log %logger% I ���빦��LOG
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.������־
ECHO.=--------------------------------------------------------------------=
ECHO.
if "%framwork_log%"=="y" (ECHO.1.[��ǰ]������־) else (ECHO.1.      ������־)
if "%framwork_log%"=="n" (ECHO.2.[��ǰ]�ر���־) else (ECHO.2.      �ر���־)
call choice common [1][2]
if "%choice%"=="1" call framwork conf user.bat framwork_log y
if "%choice%"=="2" call framwork conf user.bat framwork_log n
ECHO. & ECHOC {%c_s%}���. {%c_i%}���Ľ����´�����ʱ��Ч. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���SLOT& pause>nul & goto MENU


:PAR
SETLOCAL
set logger=example.bat-par
call log %logger% I ���빦��PAR
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.par.bat ����
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.ɾ���ͽ���userdata����
ECHO.2.������������
ECHO.3.���ݷ�����
ECHO.4.�ָ�������
ECHO.A.���˵�
call choice common [1][2][3][4][A]
if "%choice%"=="A" ENDLOCAL & call log %logger% I ��ɹ���PAR& goto MENU
ECHOC {%c_h%}�뽫�豸����Recovery...{%c_i%}{\n}& call chkdev recovery
goto PAR-C%choice%
:PAR-C1
ECHO.���ڶ�ȡ������Ϣ... & call info par userdata
set diskpath_userdata=%info__par__diskpath%& set partype_userdata=%info__par__type%& set parstart_userdata=%info__par__start%& set parend_userdata=%info__par__end%& set parnum_userdata=%info__par__num%
ECHO. & adb.exe shell ./sgdisk -p %diskpath_userdata%& ECHO.
ECHO.���������ʼɾ��... & pause>nul & ECHO.ɾ������... & call par rm %diskpath_userdata% numb:%parnum_userdata%
ECHO. & adb.exe shell ./sgdisk -p %diskpath_userdata%& ECHO.
ECHO.���������ʼ����... & pause>nul & ECHO.��������... & call par mk %diskpath_userdata% userdata %partype_userdata% %parstart_userdata% %parend_userdata% %parnum_userdata%
ECHO. & adb.exe shell ./sgdisk -p %diskpath_userdata%
ECHO. & ECHOC {%c_s%}���. {%c_i%}���Ľ����´�����ʱ��Ч. {%c_h%}�����������...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���PAR& pause>nul & goto MENU
:PAR-C2
ECHOC {%c_h%}����Ŀ�����·����Enter����: {%c_i%}& set /p diskpath=
if "%diskpath%"=="" goto PAR-C2
ECHOC {%c_h%}��������������Enter����(Ĭ��128): {%c_i%}& set /p maxparnum=
ECHO.����������������... & call par setmaxparnum %diskpath% %maxparnum%
ECHO. & ECHOC {%c_s%}���. {%c_i%}���Ľ����´�����ʱ��Ч. {%c_h%}�����������...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���PAR& pause>nul & goto MENU
:PAR-C3
ECHOC {%c_h%}����Ŀ�����·����Enter����: {%c_i%}& set /p diskpath=
if "%diskpath%"=="" goto PAR-C3
ECHOC {%c_h%}��ѡ�񱣴��ļ���...{%c_i%}{\n}& call sel folder s %framwork_workspace%\..
ECHO.���ڱ��ݷ�����%diskpath% %sel__folder_path%\partable.bak... & call par bakpartable %diskpath% %sel__file_path%\partable.bak
ECHO. & ECHOC {%c_s%}���. {%c_h%}�����������...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���PAR& pause>nul & goto MENU
:PAR-C4
ECHOC {%c_h%}����Ŀ�����·����Enter����: {%c_i%}& set /p diskpath=
if "%diskpath%"=="" goto PAR-C4
ECHOC {%c_h%}��ѡ��������ļ�...{%c_i%}{\n}& call sel file s %framwork_workspace%\..
ECHO.���ڻָ�������... & call par recpartable %diskpath% %sel__file_path%
ECHO. & ECHOC {%c_s%}���. {%c_i%}���Ľ����´�����ʱ��Ч. {%c_h%}�����������...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���PAR& pause>nul & goto MENU






:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)
