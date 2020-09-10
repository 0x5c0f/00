# 1.用vmware添加一块10G的硬盘，且永久挂载到/data01中，写出详细的步骤
个人使用`virtualbox`,虚拟机软件添加硬盘两者差异是在是否需要提前关机，`vmware`添加硬盘可以不用提前关机而直接添加，具体步骤为选中`虚拟机`-`右键`-`设置`-`添加`-`硬盘`-`下一步(全部默认)`-`修改磁盘大小为10G`-`选择存储位置`-`确定`，`virtualbox`添加硬盘必须要先关闭虚拟机,然后右键选中`虚拟机`-`右键`-`设置`-`存储`-`右键 控制器:sata`-`硬盘`-`创建(默认)`-`固定大小`-`修改大小10G`-`点击创建`-`选择创建磁盘`-最后确定设置完成添加。`vmware`添加后硬盘后可以通过重新扫描`SCSI总线`获取添加硬盘信息，但个人建议重启，`virtualbox`添加后直接启动就行了。  
内部处理： 
```bash
    # 假设新增盘为sdb 
    $> mkdir /data01 
    ## 不分区情况 
    $> mkfs.ext4 /dev/sdb 
    $> blkid /dev/sdb  # 获取到硬盘sdb的uuid 
    $> echo "UUID=xxxxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /data01 ext4    defaults        1 1" >> /etc/fstab 
    $> mount -av # 挂载到系统 

    ## 分区情况 
    $> fdisk /dev/sdb 
    > n # 新建分区 
    > p # 创建主分区
    > # 回车全部使用默认参数
    > w # 保存退出 
    # 新建盘为 /dev/sdb1 
    $> blkid /dev/sdb1  # 获取到硬盘sdb1的uuid 
    $> echo "UUID=xxxxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /data01 ext4    defaults        1 1" >> /etc/fstab 
    $> mount -av # 挂载到系统 
```
# 2.用自己语言描述raid0和raid1的区别
- `raid0`: 性能最好的一种，至少需要2块盘(据说一块也可以，不过一块个人感觉没什么用)，可大量提升文件读写速度，但安全性差，一旦任意一块盘损坏，即全部损坏 
- `raid1`: 相当于主备盘，至少需要2n块，损失一块盘的磁盘容量，总容量和最小盘一致。写数据效率受影响，读效率不受影响 



# 3.sed删除文件的空白和注释行
- `sed -e '/^$/d' -e '/^#/d' pwd.txt`

# 4.使用awk删除文件chaoge.txt空白行
- `awk '/./{print}' chaoge.txt`

# 5.把命令echo  "I am oldboy" 的结果写入"黑洞文件中"，且命令的标准错误输出，也当做标准输出处理
- `echo "I am oldboy" > /dev/null 2>&1`

# 6.利用{}符号备份/etc/hosts文件
- `cp /etc/hosts{,.bak}`

# 7.过滤掉文件chaoge.txt的注释和空白行
- `grep -Ev "^($|#)" chaoge.txt` 
- `sed -r '/^($|#)/d' chaoge.txt`


# 8.找出除了小写字母以外的字符，文本如下chaoge.txt
I am oldboy teacher
I teach linux.
I like python.
My qq is 877348180.
My name is chaoge.
My website is http://pythonav.cn

- `grep -E '[^a-z]' chaoge.txt   # grep -Eo '[^a-z]' chaoge.txt`

# 9.使用sed输出文件chaoge.txt的2-5行内容
- `sed -n '2,5p' chaoge.txt`

# 10.使用sed删除含有game字符的行,chaoge.txt
- `sed '/game/d' chaoge`


# 11.使用sed替换文件chaoge.txt中，替换所有My为His，同时换掉QQ号为8888888
My name is chaoge.
I teach linux.
I like play computer game.
My qq is 877348180.
My website is http://pythonav.cn.

- `sed -e 's/My/His/g' -e 's/877348180/8888888/g' chaoge.txt`

# 12.用sed取出ip地址
- `ifconfig enp0s31f6| sed -ne '2s/^.*inet//' -e '2s/netmask.*//p'` 
- `ifconfig enp0s31f6| sed -ne 's/^.*inet//' -e 's/netmask.*//' -e '2p'`


# 13.用awk显示/etc/passwd文件的第一列，倒数第二列，以冒号分割。
- `awk 'BEGIN{FS=":"; printf "%-22s%-25s\n","第一列","倒数第二列"}{printf "%-25s%-25s\n",$1,$(NF-1)}'`


# 14.用awk取出ip地址
- `ifconfig enp0s31f6| awk 'NR==2{print $2}'`


# 15.用awk找出/etc/passwd文件中禁止登录的用户
- `awk '/\/sbin\/nologin\>/' /etc/passwd`
