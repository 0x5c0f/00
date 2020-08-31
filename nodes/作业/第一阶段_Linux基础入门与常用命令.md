## 1.服务器的主要硬件部分是？以及其作用是？  
cpu:  计算    
主板： 连接所有硬件 
网卡： 网络连接 
电源： 供电  
硬盘： 存储数据   
内存： 临时存储数据  
显卡： 基础显示  
风扇、光驱、raid卡、远程控制卡这些应该也算吧   

## 2.写出计算机存储容量单位的关系 bit、Byte、KB、MB、GB  
- `1Byte`=`8bit`   
- `1KB`=`1024Byte`   
- `1MB`=`1024KB`   
- `1GB`=`1024MB`     
- `1TB`=`1024GB`   


## 3.简述服务器的定义是？  
- 一种比普通电脑性能更好、运行更快、负载更高的电脑。  


## 4.服务器常见厂商有？  
 - 我用的最多的是戴尔、IBM 、HP ，云服务器算的话包含aws、华为、阿里、腾讯、百度  

## 5.如果超哥要创业做一个网站，需要搭建linux服务器，简述实体服务器、vmware虚拟机、云服务器的利弊  
 - 实体服务器：优点自己购买，可以定制硬件，不过一般来说都是配对好的，可以购买额外的购买远程控制卡、raid卡等来定制系统。缺点的话，成本太高(运行、价格、机房维护)、硬件好像还不可以升级。 
 - 虚拟机：优点是只要物理机支持可以随时调整硬件分配，独立系统。缺点就是毕竟虚拟机，较依赖物理机器，占用资源也较大。
 - 云服务器：优点是部署快、运维成本较低、价格相对于实体服务器更优惠。缺点就是太依赖与网络（安全、速度）  

## 6.简述操作系统的概念？  
 - 人与计算机硬件交流的介质  

## 7.简述什么是linux？  
 - 一个自由开源的类`unix`系统  

## 8.简述什么是GNU、FSF、GPL  
GNU: 开源计划  
FSF：自由软件基金  
GPL：开源协议许可  


## 9.Linux适合在哪些领域？  
- 目前来说那没有不适合的领域吧

## 10.常见的Linux发行版有哪些？  
- Redhat(Fedora、Centos)、Ubuntu、SUSE

## 11.简述你是如何安装Linux进行学习的，哪种形式?  
 - 我的物理机为`fedora 32`，作为我日常办公使用，作为`CentOS`"先驱版",也可以获得新技术的最新体验。 
 - 我的测试机器为`CentOS 7.x`，以`virtualbox`部署，作为我部署的新测试环境和预发布环境  

## 12.如何远程连接Linux机器 192.168.11.13，命令或者工具是？  
 - 我的物理机器为`fedora`，因此连接直接`ssh <user>@192.168.11.13`即可，`windows`一般使用`xshell`进行登陆  

## 13.解读该语句  
[root@pylinux ~]#    
- 当前用户`root` ,主机名`pylinux` ， 目录`~`(`/root/`) 下  

## 14.解读该语句  
/luffycity/chaoge/love_linux.txt  
- 文件`love_linux.txt`位于目录`/luffycity/chaoge/`下 


## 15.Linux文件目录结构特点是？  
- 倒状的树形结构  


## 16.简述如下目录初始含义/作用?  
/etc  
/home  
/opt  
/usr/bin/  

- (没太理解题目意思)
- `linux`下一切目录及文件起源于`/`,`/etc`一般用于存方系统配置文件或公共配置文件，`/home`一般文系统普通用户的默认用户主目录，`/opt`一般为自编译的程序存放目录，`/usr/bin`一般为系统普通用户所使用命令的存储目录  


## 17.Linux作者是？  
- 内核`Linus Torvalds`

## 18.如何查看当前Linux机器的ip地址？  
- `ip a`  
- `ifconfig`  

## 19.Linux的目录分隔符是？  
- 以`/`进行分割  

## 20.什么是绝对路径、相对路径？  
- 绝对路径： 启始目录为`/` 
- 相对路径： 启始目录为当前目录(或者起始为`.`?)  


## 21.呆在/tmp下，创建/chaoge/love_linux.txt文件，用绝对、相对2种命令方式  
```bash
$> pwd
/tmp
$> touch /chaoge/love_linux.txt   # touch ../chaoge/love_linux.txt
```

## 22.删除/tmp/下所有内容  
- `rm -rf /tmp/*`  
- `cd /tmp && rm -rf *`  

## 23.解释如下目录的含义  
.      
..      
-      
~      
/             

- `.`: 代表当前目录  
- `..`: 代表上级目录  
- `-`: 环境变量`OLDPWD`,代表切换目录前的目录  
- `~`: 当前用户主目录  
- `/`: 系统根目录  

## 24.查看根目录下所有内容详细信息，包含隐藏文件，且显示kb,mb,gb等单位  
- `ls -lah /`  
- `ls -ash /` 

## 25.以树状图显示/home文件夹下的内容  
- `tree /home`   

## 26.一条命令创建文件夹/chaoge/love/linux  
- `mkdir -p /chaoge/love/linux`

## 27.创建文件 /tmp/lovelinux.txt  
- `touch /tmp/lovelinux.txt`  
- `echo > /tmp/lovelinux.txt`  
- `echo >> /tmp/lovelinux.txt`  

## 28.拷贝/opt/下所有内容至/optbak/中  
- `cp -r /opt/ /optbak/`  
- `mkdir /optbak && cp -r /opt/* /optbak`  


## 29.重命名文件chaoge.txt  chaoge_linux.txt  
- `mv chaoge.txt  chaoge_linux.txt`  

## 30.移动/tmp下所有内容到/tmpbak/  
- `mkdir /tmpbak && mv /tmp/* /tmpbak/`  


## 31.解释下为什么rm命令删除文件时候，默认会让用户输入yes确认？如何强制删除文件？  
- `rm`默认删除文件是不会让用户确认的，需要确认是因为一般环境变量为使用别名`alias`为`rm`命令添加了`-i`选项, 强制删除文件可以取消别名或者在执行`rm`时使用`\`对`rm`进行忽略别名配置,或者添加`-f`选项    

## 32.如何查看rm命令的帮助信息?  
- `rm --help or man rm `

## 33.常用Linux快捷键有哪些？  
- `Ctrl + C`: 结束当前正在运行的进程  
- `Ctrl + z`: 暂停当前运行的进程 
- `Ctrl + d`: 结束输入 

## 34.vim常见的工作模式有哪些？  
- 编辑、插入、命令、可视、普通 

## 35.使用vim写一个chaoge_linux.txt，内容是"我是如此的热爱Linux"  
```bash
$> vim chaoge_linux.txt
我是如此的热爱Linux

> esc -- :wq (esc -- :x)
```

## 36.如何在vim中显示行号?快速搜索"root"字符？如何给多行信息添加注释符？  
- 行号: 命令模式下输入 `set nu` 开启行号 
- 搜索: 正常模式下输入`/root`  
- 添加注释: 正常模式下按键`Ctrl + v`进入可视块,上下键选择多行，按`Shift + i`进入编辑模式，输入`#`，连续按下`esc`退出保存即可。   

## 37.简述如下符号含义  
*  
&  
?  
\  
&&  
#  
""  
''  
$  
- `*`: 匹配0次或多次  
- `?`: 基本正则代表匹配仅一次，扩展和`perl`正则表示匹配零次或一次  
- `\`: `linux`下的转义符号 
- `&`:  命令后跟代表将程序运行到后台
- `&&`: 逻辑判断标识，`shell`中代表`&&`前面命令执行成功后且结果为真后面的命令才会被继续执行  
- `#`:  在`shell`中，`#`代表注释,在命令提示符中代表当前登陆用户为`root`  
- `""`: 在`shell`中,当注释一个文本，若文本中包含变量或转义符时,会将齐转换后在输出
- `''`: 在`shell`中代表所见即所得，单引号内容是什么就打印什么 
- `$`: 在`shell`代表获取变量值,在命令提示符中代表当前登陆用户为普通用户 

## 38.如何读取文件chaoge_linux.txt且显示行号？ 
- `cat -n chaoge_linux.txt`  
- `less -n chaoge_linux.txt`  

## 39.读取/etc/passwd内容写入到/tmp/pwd.txt中  
- `cat /etc/passwd > /tmp/pwd.txt`  
- `install -m 644 -p /etc/passwd  /tmp/pwd.txt`

## 40.如何检查mysql端口号是否存活  
- `telnet 127.0.0.1 3306`  
- `nc -z -w 3 127.0.0.1 3306 >& /dev/null && echo ok`  


## 41.如何读取chaoge.txt文件20行~30行的内容?  
- `head -n 30 chaoge.txt| tail -n 11`  
- `awk 'NR==20,NR==30' chaoge.txt`  
- `sed -n '20,30p' chaoge.txt`  

## 42.实时监听文件chaoge.log的内容变化
- `tail -f chaoge.log` 


## 43.输出文件chaoge.txt每一行的第6个字符到结尾  
- `cut -c -6 chaoge.txt`  
- 

## 44.对文件/etc/passwd操作，以冒号分割，对第三列进行排序  
- `sort -n -t : -k 3 /etc/passwd`  

## 45.找出文件chaoge.txt重复的行，且统计重复次数  
- `sort -n chaoge.txt | uniq -c -d `

## 46.计算当前linux有几个登录终端  
- 一般默认`6`个, 可通过`/etc/systemd/logind.conf`管理`NAutoVTs`控制   
- 或者问的是`ps -ef|grep tty`  

## 47.查看文件chaoge.sh文件的状态信息  
- `stat chaoge.sh`  

## 48.找到当前linux上所有"chaoge.txt"文件且删除  
- `find / -type f -name "chaoge.txt" -exec rm -rf {} \;`  
- `find / -type f -name "chaoge.txt"|xargs rm -rf `  
- `find / -type f -name "chaoge.txt" -delete `   


## 49.找出linux机器上，恰好在7天内被访问的文件  
 - `find / -type f -atime -7` 


## 50.搜索出linux上超过100M的文件  
 - `find / -type f -size +100M `  

