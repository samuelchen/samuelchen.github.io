title: 为2012年中的13寸macbook pro更换固态硬盘SSD并添加内存
tags:
  - MacBook
  - upgrade
categories:
  - Life
date: 2018-11-15 00:55:37
---

刚刚给2012年中的13寸MacBook Pro更换了SSD固态硬盘，并且添加了内存，记录一下。

<!--more-->

    **注意请先断电**

### 工具和配件

* 十字起子

钟表手机维修用的十字起子 锥头型号 PH000 用来开外壳以及绝大部分螺丝.
网上有些文章说PH00，PH0甚至一般十字起子，这些都不对，大了容易伤螺丝。

* 内6角起子
 
另外如果要把SSD固态硬盘放到HDD机械硬盘位，那么需要拆掉机械硬盘，这个时候会用到。
网上说的一般是T5，这个应该可以，但我用的是T6，也合适。

* 光驱位硬盘托架

市面上一般有两种厚度，9.5mm 和 12.5mm (也有相差零点几个毫米的)，要选择薄的9.5mm这种。
接口要选择SATA 3.0，这款2012年中13寸的MacBook Pro支持SATA 3.0。
最好选择专门为MacBook Pro设计的，我在挑选的时候发现这种好像比普通的在外延多两个螺丝孔，
后面安装的时候会发现这个是必须的固定位。
商家有些会送螺丝，或者固定胶条和胶钉，视情况选择，我感觉胶条和胶钉比较好。


### 内存

该款机型内置的是2条1600海士力DDR3内存，电压为标准压1.5v，所以不能买1.25v低电压内存。
因此我选购了金士顿的标准压8G-1600单条，毋需买同品牌同大小的内存，频率相同即可，可以节省一条。
频率选择不同的应该也可以，但应就高不就低，也就是说高于1600应该是可以的。
装好后配置为10G，使用中没发现什么问题。

安装也很简单，两边的卡子轻推就会自动弹出，插好新的后下压可卡住，网上很多教程。

### SSD固态硬盘

选择很多，比如三星Samsung EVO860等等，我选择了东芝Toshiba TR200。
无他，因为之前用过，还便宜。几个月之前买是380RMB，前两天双11买是236.
支持SATA3，SSD固态硬盘可以达到6G速度。

安装之前要想好是装在光驱位还是机械硬盘位。我建议放到光驱位，原因如下：
* 机械硬盘位有自动探测震动的功能，而光驱位靠近喇叭，震动频繁，这样机械硬盘很容易坏
* 不必拆卸机械硬盘，少准备一个6角螺丝刀
* 原系统可保留（其他方式应也可以保留，但这个几乎无变动，还可以从原系统中安给SSD全新安装新系统）
* 最重要的，硬盘托架+机械硬盘 厚度很有可能超过，会造成很大麻烦。

具体安装过程网上很多教程，我发现有两篇英文的最准确，每个步骤都有，而其他的教程基本上都省略了很多步骤，
拆喇叭，摄像头等线的基本都没介绍，这几个步骤很关键。具体步骤不细说，**先拆电源接线**，小心即可。

### 系统安装

**首先做好备份**， 方法很多，time machine， 移动硬盘复制，网盘，等等。需要转移整个系统的就用time machine，
全新安装系统的就备份自己需要的文档和数据。

系统安装有几种方式：
* Time Machine 全系统恢复
* 从Recover恢复当前系统使用MacOS版本 （开机 command + R + xxx 网上介绍很多）
* 从网络安装当前机型支持的最高版本MacOS （同样组合键开机安装，有点旧型号不支持）
* 下载安装文件，从原系统中安装

我使用的是最后这种，比较保险，而且可以选择需要等版本。

当时准备了3个版本：Sierra，High Sierra，Mojave。很快就放弃了Sierra，因为High Sierra是其升级且更稳定版本，
估计性能差不多，High Sierra应该更好。Mojave考虑不太敢装，6年前的机器，怕跑不动。
另外还有一个就是Recover的EI Captain，这个还是用的 Macos 文件系统，而上面准备的三种，都升级到了APFS文件系统。
APFS是Apple专门为SSD打造的系统，比较新，只经历了2个版本，不知道稳定性如何。
最终选择的是Mojave，因为全新安装，打算试试，如果性能太差就抹掉再安装High Sierra。

后面使用发现这个选择是正确的，虽然Mojave还是第一个版本，但稳定行还不错，而且经过内存升级和更换SSD后，性能也还能接受。

系统安装好后，自动会使用SSD启动（即使在光驱位），几天运行良好，因此我决定抹掉机械银盘
（HDD使用macos 不区分大小写日志文件系统），将其作为数据盘。
但恢复分区没有抹掉，里面有EI Captain的恢复镜像，保留以备将来有用。

### 系统优化

因为使用SSD固态硬盘，系统安装好之后，需要配置一下更适合固态硬盘。

固态硬盘特性是寿命有限制，那么我们需要做这么几件事情来优化

* 关闭rootless
  
    Rootless 具体是什么网上很多，简单说就是限制root的权限来确保系统目录或文件的安全。
    有些文章说开启TRIM可能需要关闭rootless，我在开启TRIM时发现不需要，这个因系统而异。
    如果后面要移动一些系统目录（比如HOME），或者做开发，也最好关闭。
    
    步骤 ：

        * 重启并按住command+r 进入恢复模式
        * 选择命令行工具，输入`sudo csrutil disable`
        * 需要重启。

* 开启Trim。
  
    Trim是一种均衡固态硬盘读写的技术，使得写入不会总在一个地方。非Apple内置SSD不会自动开启Trim，需要自行开启。
    使用命令 `sudo trimforce enable`, 然后确认即可，可能重启。早期版本比如Yosimate可能需要重置 NVRAM/PRAM，
    我是用Mojave没有重置。

* 移动User Home

    为了减少SSD的使用量以及读写消耗，我将个人用户home目录移动到了机械硬盘。
    这个目录移动可以在 `设置->用户与组->解锁->右键自己用户->高级功能` 中修改，然后系统自动移动并重启。

    也可以使用命令完成移动整个User目录
  
        $sudo ditto /Users /Volumes/Macintosh\ HD/Users

        $sudo mv /Users /Users.backup 

        $sudo ln -s /Volumes/Macintosh\ HD/Users Users

        $sudo rm -rf /Users.backup

* 移动其他目录

    移动临时目录/tmp，因为/tmp是链接到/private/tmp，所以如下： 

        $ sudo ditto /private/tmp /Volumes/Macintosh\ HD/private/tmp

        $ sudo rm -rf /private/tmp

        $ sudo ln -s /Volumes/Macintosh\ HD/private/tmp /private/tmp

* 修改休眠文件位置 或 关闭休眠

    * 查看休眠配置

            $ pmset -g|grep hibernate
            hibernatefile        /var/vm/sleepimage
            hibernatemode        3

    * 修改休眠文件位置
  
            $ sudo pmset -a hibernatefile /Volumes/Macintosh\ HD/var/vm/sleepimage

    * 关闭休眠

    Suspend to RAM ——> 对应的hibernatemode：0；
    Suspend to RAM+Disk ——> 对应的hibernatemode：3 
    Suspend to Disk ——> 对应的hibernatemode：5；
   
            $ sudo pmset -a hibernatemode 0


* 关闭文件最后访问时间

    http://junqiu.lofter.com/post/1d084679_5ef95d0

        $ sudo vi /Library/LaunchDaemons/com.nullvision.noatime.plist

    编辑为如下内容

        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
            <dict>
                <key>Label</key>
                <string>com.noatime</string>
                <key>ProgramArguments</key>
                <array>
                    <string>mount</string>
                    <string>-vuwo</string>
                    <string>noatime</string>
                    <string>/</string>
                </array>
                <key>RunAtLoad</key><true/>
            </dict>
        </plist>

    然后设置权限

        $ sudo chown root:wheel /Library/LaunchDaemons/com.noatime.plist
        $ sudo chmod 644 /Library/LaunchDaemons/com.noatime.plist

    重启后，使用命令 `mount | grep /` 查看，可以看到多了一个`noatime`属性

    使用前

        /dev/disk2s1 on / (apfs, local, journaled)

    使用后

        /dev/disk2s1 on / (apfs, local, journaled, noatime)


--- END ---
