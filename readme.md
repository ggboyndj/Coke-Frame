版本：1.0  
# COKE简介
COKE开发框架（简称COKE）是一个主要由bat脚本编写，以一些命令行工具和Linux程序为辅助的，为制作bat提供便利的框架。  
COKE拥有以下优点：  
- 模块化：将刷机操作整合成模块，可以轻松调用。  
- 规范化：所有模块按照统一规则编写，避免屎山。  
- 工具丰富：提供制作bat常用的各种工具，包括文件选择器，管理员申请工具等等。  
- 用户友好：屏蔽原始输出，避免杂乱；使用不同颜色的文字代表不同含义，更加直观；支持主题，可自定义配色方案。  
- 完善的实现方法：COKE在一些操作上使用了更完善的实现方法，具有更好的兼容性。  
- 严格的错误处理：COKE有严格的错误处理机制，包括启动自检，关键步骤的报错检测，分级日志系统等。尽力保证及时报告每个问题。  
- ...
# 目录和文件介绍  
- 📂.vscode：vscode编辑器配置文件(不需要可删除)
- 📂bin：工作目录，存放框架文件
  - 📂conf：配置文件夹，存放配置文件
    - 📄fixed.bat：固定配置文件
    - 📄user.bat：用户配置文件
  - 📂tmp：临时文件文件夹，存放临时文件
  - 📂log：日志文件夹，存放日志
  - 📂tool：工具文件夹，存放调用的命令行工具等
    - 📂Android：安卓工具
    - 📂Windows：Windows工具
    - 📄logo.txt：文字图形式的标志，在启动时展示
  - 📄calc.bat：计算模块
  - 📄chkdev.bat：检查设备连接模块
  - 📄choice.bat：选项功能模块
  - 📄clean.bat：清除模块
  - 📄dl.bat：下载模块
  - 📄framwork.bat：框架相关功能模块
  - 📄imgkit.bat：分区镜像处理模块
  - 📄info.bat：读取设备信息模块
  - 📄log.bat：日志模块
  - 📄open.bat：打开模块
  - 📄par.bat：分区模块
  - 📄read.bat：读出（分区镜像等）模块
  - 📄reboot.bat：重启模块
  - 📄scrcpy.bat：投屏模块
  - 📄sel.bat：选择文件（夹）模块
  - 📄slot.bat：槽位模块
  - 📄write.bat：写入（分区镜像等）模块
- 📄cmd.bat：命令行
- 📄readme.md：说明文档
- 📄example.bat：使用COKE制作工具箱的示例
# 模块介绍  
### 关于模块传入参数的特别说明
由于涉及不到复杂的应用场景，模块的参数设计比较简单，就是按照第一个，第二个，第三个的顺序来识别的，中间以空格作为分隔。可选的参数会放在最后，以保证留空不选也不会影响其他参数的识别。模块没有对传入参数是否合法的检查，如果用错了就会按照错误的参数错误地执行下去，所以在使用模块前，请务必查看模块调用方法，按照规定的参数调用。参数内不能有空格，尽量不要带特殊符号。  
### calc（计算模块）
**简介**  
用于精确计算。使用了命令行计算器calc.exe，以弥补bat自带计算功能的不足（如数值不能过大、不能计算小数等）。  
**调用方法**  

|call calc|参数1|参数2|参数3|参数4|参数5|
|-|-|-|-|-|-|
||sec2kb|输出变量名|dec或nodec|扇区值|扇区大小|
||kb2sec|同上|同上|kb值|同上|
||kb2mb|同上|同上|kb值|
||kb2gb|同上|同上|kb值|
||a|同上|同上|数字1|数字2|
||s|同上|同上|数字1|数字2|
||m|同上|同上|数字1|数字2|
||d|同上|同上|数字1|数字2|

**输出结果**  
将指定的输出变量名的值设为计算结果。  
**功能说明**  
sec2kb：扇区值转KiB值  
kb2sec：KiB值转扇区值  
kb2mb：KiB值转MiB值  
mb2kb：MiB值转KiB值  
kb2gb：KiB值转GiB值  
gb2kb：GiB值转KiB值  
b2kb：byte值转KiB值  
kb2b：KiB值转Byte值  
p：两数相加  
s：两数相减  
m：两数相乘  
d：两数相除  
参数中dec和nodec分别指的是保留两位小数和不保留小数。如果不保留小数，小数部分会被直接去掉，不会大于0.5进位。  
**示例**  
将扇区值“666”转为KiB值，不保留小数，输出到result变量：  
`call calc sec2kb result nodec 666 4096`  
计算6乘9，保留两位小数，输出到result变量：  
`call calc m result dec 6 9`  
**特别说明**  
COKE中所有kb，mb，gb简写均代表KiB，MiB，GiB，也就是使用1024进制。COKE中所有存储大小数值均默认以KiB为单位传递和计算。比如xxx_size=233，就默认233为233KiB。如果确实需要以其他单位展示，请在原变量名后面加上_单位，如xxx_size_gb=xxx。  
只有扇区大小除外，扇区大小以Byte（字节）为单位，比如4096。  
### chkdev（检查设备连接模块）  
**简介**  
用于检查各个模式的设备连接，确保连接正常。  
**调用方法**  

|call chkdev|参数1|参数2|参数3|
|-|-|-|-|
||system|rechk|复查前等待秒数|
||recovery|同上|同上|
||sideload|同上|同上|
||fastboot|同上|同上|
||edl|同上|同上|
||diag901d|同上|同上|
||all|同上|同上|

**输出结果**  
edl：端口号（chkdev__edl__port），值为纯数字。  
diag901d：端口号（chkdev__diag901d__port），值为纯数字。  
all：设备所在模式（chkdev__all__mode），值为system、recovery、sideload、fastboot、edl中之一。如果检查的是端口，也会输出端口号（同上）。
**功能说明**  
检查规则：1，检查不到目标设备就不退出模块，一直循环检查。2，不支持多设备，只允许一个目标设备连接。3，大约30秒检测不到则超时，超时后会暂停并提示用户按任意键重新检测。  
当某操作在不同模式下均可完成时，可以使用“检查所有模式”并根据检查到的模式使用不同方法完成该操作，方便快捷。  
由于基带调试模式只用于调试基带，故不在“检查所有模式”范围内。  
默认调用一次模块只检查一次连接，但由于在某些特殊情况下设备连接不稳定，故提供复查（rechk）功能，可以等待指定的秒数后再次检查目标连接，减少短时间内的连接不稳定导致的问题。等待秒数可以自行设置，若不设置则默认3秒。若不复查则无需填写等待秒数。  
**示例**  
检查系统连接：  
`call chkdev system`  
检查所有连接：  
`call chkdev all`  
检查所有连接并复查(默认等待3秒)：  
`call chkdev all rechk`  
检查Recovery连接并在6秒后复查：  
`call chkdev recovery rechk 6`  
### choice（选项功能模块）  
**简介**  
在菜单下面使用，提示用户输入选项并检查用户的输入是否合法，最终输出用户的选项。  
**调用方法**  

|call choice|参数1|参数2|
|-|-|-|
||common|[1][2][3]#[A][B]...(可选)|
||twochoice|提示文字(不能带空格)|

**输出结果**  
传出用户的选择（choice）。注意：当选项是字母时，无论大小写，统一以大写传出。  
**功能说明**  
common（通用）模式：适用于一般的有多个选项的菜单。可以通过增加[1][2][3]...参数限定哪些选项为合法，只有用户输入的选项在[]内时才允许继续，否则会提示用户重新输入。在此基础上，还可以指定一个选项为默认选项（即用户无需输入任何选项，直接按回车即选择该项）。在[]前加#即将该选项设为默认选项，例如[1]#[2][3]中，2即为默认选项。  
注意：在填写限定选项参数时，如果涉及字母，一律使用大写。   
twochoice模式：适用于“是否xxx？直接按Enter xxx，输入1按Enter xxx”的场景。  
**示例**  
通用模式：  
`ECHO.1.刷入Boot`  
`ECHO.2.刷入Recovery`  
`ECHO.A.查看说明`  
`call choice common [1][2]#[A]`  
`if "%choice%"="1" xxx`  
`if "%choice%"="2" xxx`  
`if "%choice%"="A" xxx`  
twochoice模式：  
`call choice twochoice 是否要xxx?直接按Enter继续,输入1按Enter跳过`  
### clean（清除模块）  
**简介**  
包括清除，擦除，格式化等操作。  
**调用方法**  

|call clean|参数1|参数2|参数3|
|-|-|-|-|
||twrpfactoryreset|
||twrpformatdata|
||formatfat32|name:分区名 或 path:分区路径|卷标(可选)|
||formatntfs|同上|同上|
||formatexfat|同上|同上|

**输出结果**  
无  
**功能说明**  
twrpfactoryreset：TWRP下恢复出厂（双清），调用的是TWRP内置命令。  
twrpformatdata：TWRP下格式化Data，调用的是TWRP内置命令，格式化后会自动重启Recovery刷新分区表。  
formatfat32：将指定分区格式化为fat32格式。  
formatntfs：将指定分区格式化为ntfs格式。  
formatexfat：将指定分区格式化为exfat格式。  
在formatfat32，formatntfs和formatexfat中，目标分区可以以分区名或分区路径的形式指定。如果使用分区名，则在分区名前加上“name:”，使用路径则加上“path:”。卷标可选，不填则不设置。  
**示例**  
格式化Data：  
`call clean twrpformatdata`  
将abc分区格式化为fat32格式：  
`call clean formatfat32 name:abc`  
将dev/block/sda23格式化为ntfs格式，并设置卷标为Windows：  
`call clean formatntfs path:dev/block/sda23 Windows`  
### dl（下载模块）  
**简介**  
从直链或蓝奏云分享链接下载文件。  
**调用方法**  

|call dl|参数1|参数2|参数3|参数4|参数5|参数6|
|-|-|-|-|-|-|-|
||direct|直链|完整文件保存路径(包括文件名)|retry或once|notice或noprompt|检查字符串(可选)|
||lzlink|蓝奏分享链接|同上|同上|同上|同上|

**输出结果**  
dl__result（下载结果），值为y（成功）或n（失败）。  
**功能说明**  
支持下载直链或蓝奏云分享链接。  
其中蓝奏云分享链接支持分卷压缩包下载。如果是分卷压缩包，在填写蓝奏分享链接时以[分卷1链接][分卷2链接][分卷3链接]...格式填写即可。会一次性下载全部分卷。  
模块有“只尝试下载一次”（once）和“自动重试”（retry）两种下载模式。  
当目标位置已存在同名文件时，可以设置提示等待确认（notice）或不提示直接覆盖（noprompt）。  
针对文本类下载内容，下载完成后可以在下载内容中搜索自定义字符串以检验下载是否成功。  
下载完成后，传出下载是否成功（y或n）。  
注意：下载的文件名和网上原本的文件名没有关系，因为下载后要统一重命名为参数中设定的文件名。另外如果要下载的是一套分卷压缩包，文件名写.001前面的即可，下载后会自动添加.001等分卷后缀名。  
**示例**  
下载某直链：  
`call dl direct 直链链接 C:\test.zip once notice`  
下载某直链，如果目标文件存在则直接覆盖：  
`call dl direct 直链链接 C:\test.zip once noprompt`  
下载某直链txt文档并以下载的文件中是否有“syxz”字符串来检查是否下载成功：  
`call dl direct 直链链接 C:\test.txt once notice syxz`  
下载某蓝奏链接：  
`call dl lzlink 蓝奏分享链接 C:\test.zip once notice`  
下载一套蓝奏上的分卷压缩包：  
`call dl lzlink [001的蓝奏分享链接][002的][003的][...] C:\test.zip notice once`  
### framwork（框架相关功能模块）  
**简介**  
包含框架本身的一些功能，如启动准备工作等。  
**调用方法**  

|call framwork|参数1|参数2|参数3|参数4|
|-|-|-|-|-|
||startpre|
||adbpre|程序名或all|
||theme|主题名|
||conf|要写入的配置文件名|要写入的变量名|要写入的变量值|
||logviewer|end|
|start framwork|参数1|参数2|参数3|参数4|
||logviewer|start|%logfile%|

**输出结果**  
startpre：当前Windows版本号（winver），工作目录完整路径（framwork_workspace），日志文件相对路径（logfile），以及将日志记录者（logger）预设为UNKNOWN。  
**功能说明**  
启动准备工作（startpre）是每次启动前都必须执行的，包括设置path，检查各个命令和命令行工具能否正常使用，准备日志系统等，不执行准备则无法正常使用框架。  
准备adb shell环境（adbpre）是将框架内置的Linux程序推送到设备中并授权，以便后续执行。可以选择只推送指定的程序或推送全部程序。可以在系统(需Root)或Recovery下使用，如在系统下，程序将被推送到./data/local/tmp/目录，如在Recovery下，则推送到根目录（./）。  
加载主题（theme）是根据指定的主题名字加载相关配色方案。如果参数中指定了正确的主题名字，则加载该主题，如果指定的主题名字不正确，则加载默认主题，如果没有指定参数，则加载conf\user.bat内设定的主题。  
写入配置（conf）是向指定配置文件写入指定配置信息。相比于直接echo，使用此功能可以自动移除该配置文件中的同名的旧配置信息，以保证旧信息不会一直累积。  
开关日志实时监控（logviewer）是开启或关闭当前日志文件的实时监控窗口。日志监控是用busybox的tail命令实现的。注意：关闭窗口采用的方法是直接结束bysybox-COKElogviewer.exe。  
**示例**  
完成启动准备工作：  
`call framwork startpre`  
推送blktool并授权：  
`call framwork adbpre blktool`  
加载默认主题：  
`call framwork theme default`  
向conf\custom.bat中写入“set COKE=123”这条配置信息：  
`call framwork conf custom.bat COKE 123`  
开启当前日志的实时监控：  
`start framwork logviewer start %logfile%`  
关闭日志实时监控：  
`call framwork logviewer end`  
### imgkit（分区镜像处理模块）  
**简介**  
分区镜像处理模块。用于修改，合成分区镜像。  
**调用方法**  

|call imgkit|参数1|参数2|参数3|参数4|参数5|
|-|-|-|-|-|-|
||magiskpatch|需要修补的Boot文件完整路径|新Boot文件保存路径(包括文件名)|Magisk版本号(默认为内置的24100)或MagiskAPK路径|noprompt(可选)|
||recinst|需要修补的Boot文件完整路径|新Boot文件保存路径(包括文件名)|recovery文件完整路径(可以是img或ramdisk.cpio)|noprompt(可选)|

**输出结果**  
无  
**功能说明**  
Magisk修补Boot功能（即magiskpatch）需要MagiskAPP。框架内置了24100和25200两个测试可用的版本，如需添加更多版本，请将APK放置于bin\tool\Android\magisk文件夹，并重命名为“版本号.apk”。当然也可以直接使用MagiskAPK路径指定。注意，并不是所有的版本都支持，请自行测试。当输出位置已存在同名文件时，脚本默认会提示并暂停，可以添加noprompt参数用于不提示默认覆盖。  
注入Recovery功能（recinst）适用于ab分区设备，即Recovery被合并在Boot里的情况（部分ab设备也有recovery分区，则不需要注入）。除了Boot外，还需要准备Recovery，Recovery文件格式可以是img（已经合成进Boot的）或ramdisk.cpio，脚本会识别文件扩展名，如果是img则会首先提取出ramdisk.cpio，不是则直接作为ramdisk.cpio处理。  
当输出位置已存在同名文件时，脚本默认会提示并暂停，可以添加noprompt参数用于不提示默认覆盖。  
**示例**  
无  
### info（读取设备信息模块）  
**简介**  
执行读取设备信息相关操作。  
**调用方法**  

|call info|参数1|参数2|参数3|
|-|-|-|-|
||adb|
||fastboot|
||par|分区名|fail或back(当找不到分区时的操作.可选.默认为fail)|
||disk|磁盘路径|

**输出结果**  
adb功能：info__adb__product（设备代号），info__adb__androidver（安卓版本），info__adb__sdkver（sdk版本）。  
fastboot功能：info__fastboot__product（设备代号，很可能不准确，建议用adb读代号），info__fastboot__unlocked（是否已经解锁BL）。  
par功能：info__par__exist（分区是否存在），info__par__diskpath（分区所在磁盘路径），info__par__num（分区编号），info__par__path（分区路径），info__par__type（分区类型），info__par__start（分区start），info__par__end（分区end），info__par__size（分区大小），info__par__disksecsize（分区所在磁盘扇区大小），info_par_disktype（分区所在磁盘类型，UFS或MMC）。  
disk功能：info__disk__type（磁盘类型，UFS或MMC），info__disk__secsize（磁盘扇区大小），info__disk__maxparnum（磁盘最大分区数）。  
**功能说明**  
adb：adb读取一些设备信息。  
fastboot：fastboot读取一些设备信息。  
par：adb读取指定分区的信息。读取分区信息前会先检查目标分区是否存在，如果不存在默认会提示失败，但可以通过增加“back”参数使找不到分区后不提示失败，正常返回主脚本。  
disk：adb读取指定磁盘信息。    
注：默认输入和输出单位为KiB，进制为1024（详见calc模块）。  
**示例**  
获取boot分区信息：  
`call info par boot`  
### log（日志模块）  
**简介**  
向当前日志文件（logfile）写日志。  
**调用方法**  

|call log|参数1|参数2|参数3|
|-|-|-|-|
||日志记录者|I、W、E或F|日志内容(不能带空格)|

**输出结果**  
无  
**功能说明**  
向当前日志文件（logfile）写日志（logfile是在启动准备工作中设置的）。在调用时需要指定记录者、级别和内容。其中记录者指的是哪个模块要求记录的这个日志，可以直接填模块名来指定，在记录操作较多时也可以预先设置logger为模块名，然后统一使用%logger%。级别可以填I，W，E，F四个等级，分别指“信息”，“警告”，“错误”，“崩溃”。  
**示例**  
由example.bat记录“xxx文件将被覆盖”的警告信息：  
`call log example.bat W xxx文件将被覆盖`  
### open（打开模块）  
**简介**  
以指定的方式打开指定文件。  
**调用方法**  

|call open|参数1|参数2|
|-|-|-|
||common|目标路径|
||folder|同上|
||txt|同上|
||pic|同上|

**输出结果**  
无  
**功能说明**  
打开文本调用的是Notepad3，打开图片调用的是360AblumViewer。  
**示例**  
打开a.jpg：  
`call open pic a.jpg`  
### par（分区模块）  
**简介**  
修改分区表相关操作。  
**调用方法**  

|call par|参数1|参数2|参数3|参数4|参数5|参数6|参数7|
|-|-|-|-|-|-|-|-|
||mk|磁盘路径|分区名|分区类型|start|end|编号(可选,默认为首个可用的)|
||rm|磁盘路径|name:分区名 或 numb:分区编号|
||setmaxparnum|磁盘路径|目标分区数(可选,默认128)|
||bakpartable|磁盘路径|备份文件保存路径(包括文件名)|noprompt(可选)|
||recpartable|磁盘路径|备份文件路径|  

**输出结果**  
无  
**功能说明**  
mk：新建分区。  
rm：删除分区。  
setmaxparnum：设置磁盘最大分区数。  
bakpartable：使用sgdisk备份目标磁盘分区表。  
recpartable：使用sgdisk恢复目标磁盘分区表备份。  
注：分区功能要求在Recovery完成，开机不可以。读取分区信息请使用info.bat，格式化请使用clean.bat。  
**示例**  
无  
### read（读出模块）  
**简介**  
用于读出（分区镜像等）操作。注意：这不是读信息。  
**调用方法**  

|call read|参数1|参数2|参数3|参数4|参数5|参数6|
|-|-|-|-|-|-|-|
||system|分区名|保存文件夹路径|noprompt(可选)|
||recovery|同上|同上|同上|
||edl|端口号(不带COM)|存储类型(如UFS,EMMC)|img存放文件夹|xml路径|elf完整路径(可选,不填不发送)|

**输出结果**  
无  
**功能说明**  
对于系统或Recovery，读出的文件名为“分区名.img”，如果指定的保存文件夹中已有同名文件，则会暂停并显示一个文件覆盖的警告信息，按任意键可以继续。如果需要默认覆盖不提示，可以使用noprompt参数。  
对于9008，读出的分区和分区名取决于xml内容。elf引导文件路径为可选参数，填则先发送引导再刷机，不填则不发送引导直接刷机。  
**示例**  
系统下读出boot分区镜像到C:\Users文件夹：  
`call read system boot C:\Users`  
Recovery下读出boot分区镜像到C:\Users文件夹（默认覆盖）：  
`call read recovery boot C:\Users noprompt`  
### reboot（重启模块）  
**简介**：  
重启设备到指定模式。  
**调用方法**  

|call reboot|参数1|参数2|参数3|参数4|
|-|-|-|-|-|
||system|system、recovery、fastboot、edl、diag901d|chk、rechk(是否检查或复查目标模式连接，可选)|如果rechk则填秒数(可选)|
||recovery|system、recovery、fastboot、edl、sideload|chk、rechk(是否检查或复查目标模式连接，可选)|如果rechk则填秒数(可选)|
||fastboot|system、recovery、fastboot、fastbootd、edl|chk、rechk(是否检查或复查目标模式连接，可选)|如果rechk则填秒数(可选)|
||fastbootd|system、fastboot、fastbootd|chk、rechk(是否检查或复查目标模式连接，可选)|如果rechk则填秒数(可选)|

**输出结果**  
无  
**功能说明**  
重启设备到指定模式。如果无法自动完成重启，则提示用户手动重启。另外，由于某些未知原因，重启命令不一定每次都能正确完成，或实际上完成但返回错误的结果，所以在重启命令出错后，提供给用户重试和直接继续两个选择。  
“system”代表开机，重启到system就是正常开机的意思。  
注意：一些重启方案不一定适合所有机型，比如Fastboot重启Recovery等，如果当前方案不合适，则需要修改reboot.bat。  
**示例**  
从Recovery重启到Fastboot：  
`call reboot recovery fastboot`  
从Recovery重启到Fastboot并随后检查Fastboot连接：  
`call reboot recovery fastboot chk`  
从Recovery重启到Fastboot并随后检查Fastboot连接，然后间隔6秒复查：  
`call reboot recovery fastboot rechk 6`  
### scrcpy（投屏模块）  
**简介**  
开机状态下ADB投屏。  
**调用方法**  

|call scrcpy|参数1|参数2|
|-|-|-|
||窗口标题|wait(可选,填wait为等待模式,不填不等待)|

**输出结果**  
无  
**功能说明**  
开机状态下ADB投屏。有两种启动模式：启动后等待投屏窗口关闭再继续运行脚本，和启动后正常继续不等待。提示：为了避免文件占用冲突，不等待模式下scrcpy的运行日志会单独输出到log\scrcpy.log。  
**示例**  
启动ADB投屏（不等待）：  
`call scrcpy ADB投屏`  
### sel（选择文件（夹）模块）  
**简介**  
打开文件或文件夹选择器。  
**调用方法**  

|call sel|参数1|参数2|参数3|参数4|
|-|-|-|-|-|
||file|s(单选)或m(多选)|打开时展示的文件夹的路径|[img][bin]...(可选)|
||folder|s(单选)或m(多选)|打开时展示的文件夹的路径|

**输出结果**  
选择文件传出变量（单选模式）：  
sel__file_path：完整路径  
sel__file_fullname：完整文件名  
sel__file_name：文件名（不包括扩展名）  
sel__file_ext：扩展名  
sel__file_folder：该文件所在文件夹完整路径  
选择文件夹传出变量（单选模式）：  
sel__folder_path：完整路径  
sel__folder_name：文件夹名  
选择文件传出变量（多选模式）：  
sel__files：被选的所有文件的完整路径连在一起，以“/”分隔  
选择文件夹传出变量（多选模式）：  
sel__folders：被选的所有文件夹的完整路径连在一起，以“/”分隔  
**功能说明**  
按指定参数唤起文件或文件夹选择器，输出用户选择的路径。可以指定单选或多选，指定选择器打开时展示哪个文件夹（如果不知道指定哪个就填%framwork_workspace%即工作目录）。文件选择功能还可以指定一个或多个允许的扩展名，每个扩展名用[]括起来，中间不能有空格。  
单选模式（s）只允许选择一个文件（夹），输出该文件（夹）完整路径以及一系列相关参数（详见“传出”）。多选模式（m）允许选择一个或多个文件（夹），将它们的完整路径连在一起输出，路径之间以“/”符号分隔。多选模式只输出所有完整路径，没有相关参数输出。  
**示例**  
选择一个img文件：  
`call sel file s %framwork_workspace% [img]`  
选择一个img或bin文件：   
`call sel file s %framwork_workspace% [img][bin]`  
选择一个文件夹：  
`call sel folder s %framwork_workspace%`  
### slot（槽位模块）  
**简介**  
查看和设置槽位，适用于ab或vab设备。  
**调用方法**  

|call slot|参数1|参数2|参数3|
|-|-|-|-|
||system、recovery、fastboot或auto|set|a、b、cur或cur_oth|
|同上|chk|

**输出结果**  
查看槽位（chk）会输出当前槽位（slot__cur）和当前槽位的另一槽位（slot__cur_oth）。  
**功能说明**  
查看（chk）和设置（set）槽位。适用于ab或vab设备。可以在系统，Recovery和Fastboot模式执行，但系统下设置槽位有可能不生效。auto指自动识别设备所在模式。cur指当前槽位，cur_oth指当前槽位的另一槽位。  
**示例**  
查看当前槽位：  
`call slot auto chk`  
在Fastboot模式查看当前槽位：  
`call slot fastboot chk`  
切换到另一槽位：  
`call slot auto set cur_oth`  
切换到槽位a：  
`call slot auto set a`  
### write（写入模块）  
**简介**  
用于写入（分区镜像等）操作。  
**调用方法**  

|call xxx|参数1|参数2|参数3|参数4|参数5|参数6|
|-|-|-|-|-|-|-|
||system|分区名|img文件夹路径|
||recovery|同上|同上|
||fastboot|同上|同上|
||fastbootboot|img文件路径|
||edl|端口号(不带COM)|存储类型(如UFS,EMMC等)|img所在文件夹(即搜索路径)|xml路径|elf完整路径(可选,不填不发送)|
||twrpinst|卡刷包路径|
||sideload|卡刷包路径|

**输出结果**  
无  
**功能说明**  
目前可以在系统(需Root)，Recovery，Fastboot，9008写入分区镜像，在Fastboot临时启动，TWRP内置命令安装卡刷包，以及TWRP下adb sideload安装卡刷包。  
**示例**  
系统下写入xxx\boot.img到boot分区：  
`call write system boot xxx\boot.img`  
Fastboot临时启动xxx\boot.img：  
`call write fastbootboot xxx\boot.img`  
# 日志系统介绍  
日志系统在framwork模块的startpre（即启动准备）功能里完成准备。包括设定日志文件相对路径（logfile），记录电脑系统版本号、处理器架构、工作目录，清理日志（超过最大允许的日志数时）等。所以框架每次启动都会在log文件夹里生成一个日志文件，之后本次启动调用的所有模块和功能也都会统一将日志追加输出到这个文件。  
日志不仅要记录框架本身的日志，也要记录关键命令的原始输出。所以一般使用“1>>%logfile% 2>&1”将原始输出全部输出到日志文件。如果脚本需要读取原始输出中的信息，可以先覆盖输出到tmp\output.txt，读取信息后再type tmp\output.txt>>%logfile%。
# 变量命名和使用规则  
为避免变量杂乱和重名冲突，特别制定此规则。  
框架中的变量分为全局变量和局部变量。一些通用的变量，比如框架版本号、日志文件路径等，是设置为全局变量的。而模块运行时内部产生的临时变量则应作为局部变量，避免干扰全局变量。如果模块需要输出某些变量作为运行结果，则必须以“模块名__功能名__变量名”的格式输出，以和全局变量区分。注意是两个“_”而不是一个。  
命名变量时，应避免使用以下名字：  
path；time；errorlevel；date；ver；logfile；logger；winver；var1；var2；var3；var4；var5；var6；var7；var8；var9；  
临时变量可以使用以下名字：  
var；target；num；size；times；result；  
# 配置文件规则  
配置文件均位于conf文件夹，分为固定配置（fixed.bat）和用户配置（user.bat）两种。固定配置存放不允许用户自定义的配置信息，如框架版本号等。用户配置存放允许用户自定义的配置信息，如是否开启日志等。这样设计是为了方便在线更新，更新时只需要覆盖固定配置而跳过用户配置即可。注意：用户配置中所有项目都必须在使用它的相关脚本中设置当其值为空时的默认值或处理方法，确保即使user.bat被删除也不影响脚本运行。  
框架自身的配置项目如下：  
固定配置：  
framwork_ver：框架版本号  
用户配置：  
framwork_theme：主题名称。默认值为default  
framwork_log：是否开启日志。默认值为y  
framwork_lognum：最多保留几个日志文件。默认值为8  
配置项目均为全局变量，由主脚本在启动过程中加载（具体过程请参考example.bat）。  
如需向指定配置文件写入配置项目，请使用framwork模块的conf功能。  
如需增加配置文件，请将配置文件置于conf文件夹并在主脚本启动过程的加载配置部分增加加载该文件。  
# 颜色和主题  
COKE中，不同颜色代表不同含义。默认情况下，亮白（F）代表普通提示信息，淡黄（E）代表警告信息，淡红（C）代表错误或崩溃信息，淡绿（A）代表操作成功信息，淡紫（D）提示手动操作（即需要用户手动操作时使用淡紫色）。此外，也用淡黄（E）代表强调的提示信息，灰白（7）代表弱化的提示信息。  
COKE使用变量替代颜色代码，从而使COKE支持应用自定义的配色方案，也就是“主题”。提示类型和变量名的对应关系如下：  

|提示类型|对应变量名|
|-|-|
|普通提示信息|%c_i%|
|警告信息|%c_w%|
|错误或崩溃信息|%c_e%|
|操作成功信息|%c_s%|
|手动操作|%c_h%|
|强调色|%c_a%|
|弱化色|%c_we%|

为这些变量赋值相应的颜色代码是在framwork.bat模块的THEME功能完成的。相关调用方法详见framwork.bat模块简介。如果需要自定义主题，也需要修改THEME中的脚本。  
# 关于脚本编码和换行符  
COKE中所有bat脚本都以GB2312或GB18030编码，换行符为CRLF。下载后请检查编码和换行符，以免出现问题。  
# 如何使用COKE制作一个刷机工具  
首先下载COKE并解压缩。找到example.bat，这是一个主脚本示例。将它复制一份，改名为你的工具名，编辑，将脚本中主菜单MENU以及之后的内容全部删除。上面的内容属于框架的启动步骤，有些可以修改，有些不能修改，具体请参照注释。完成启动步骤后就可以在下面编写你的脚本了。  
COKE将许多常用的刷机操作做成了模块，在涉及这些操作时，只需按照要求调用模块即可。实际执行命令的是模块，主脚本只起一个引领作用。  
COKE在tool里集成了很多工具，但你可能不一定都需要。具体是否需要请参照模块介绍中的“使用工具”一栏。如果确认不需要某工具，可以将其删除，然后在framwork.bat的startpre功能中将该工具相关的检查项注释掉。注意，删除错误会导致脚本无法正常运行。
