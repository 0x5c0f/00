## 1.统计日志，日志内容
39.96.187.239 - - [11/Nov/2019:10:08:01 +0800] "GET / HTTP/1.1" 302 0 "-" "Zabbix"
211.162.238.91 - - [11/Nov/2019:10:08:02 +0800] "GET /api/v1/course_sub/category/list/?belong=1 HTTP/1.1" 200 363 "https://www.luffycity.com/free" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36"
211.162.238.91 - - [11/Nov/2019:10:08:02 +0800] "GET /api/v1/degree_course/ HTTP/1.1" 200 370 "https://www.luffycity.com/free" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36"

- 统计日志的访客ip数量
    - `cat rizhi.txt |awk '{print $1}'| sort | uniq | wc -l`
- 查看访问最频繁的前10个ip
    - `cat rizhi.txt |awk '{print $1}'| sort | uniq -c| sort -nr|head -n 10`

## 2.查看linux的定时任务列表
- `crontab -l `
- `cat /var/spool/cron/crontabs/<user>` 

## 3.每晚0点整，把站点目录/var/www/html下的内容打包备份到/data目录下
- `0 0 * * * /usr/bin/tar -czf /data/html_`date +"\%Y\%m\%d"`.tar.gz /var/www/html/* >&　/dev/null ` 


## 4.每5分钟让服务器进行时间同步
- `*/5 * * * * /usr/sbin/ntpdate ntp.aliyun.com >& /dev/null`

## 5.在每天的10:31开始，每隔2小时重复一次
- `31 10-23/2 * * * /bin/echo "hello" >& /dev/null` 

## 6.每周六凌晨4:00执行
- `0 4 * * 6 /bin/echo "hello" >& /dev/null` 

## 7.linux对磁盘分区格式化的命令
- `mkfs.xfs /dev/sdb` 
- `mkfs -t xfs /dev/sdb`

## 8.解释inode与block的含义
- `inode`: 文件在系统里面的索引标识 
- `block`: 操作系统存取的最小单位

## 9.格式化分区/dev/sdc1为xfs文件系统(提示：注意格式化分区文件系统前，检查好当前分区是否在用，是否重要，明确后再自己本地虚拟机实验)
```bash
$> df -h /dev/sdc1
$> mkfs.xfs /dev/sdc1
```

## 10.简述buffers和cache含义及作用
- `buffer`: 用于写入数据的缓冲 
- `cache`: 用于读取数据时的缓存

## 11.简述raid不同级别的区别
- `raid 0` : 100%利用存储空间。最少需要两块盘(据说一块也可以，不过个人觉得一块应该没啥用)， 没用冗余数据，不做备份，任何一块磁盘损坏都无法运行。理论读写是单块磁盘的n倍。存储性能最好，但安全性不高。 
- `raid 1`: 50%的利用空间，磁盘最小需要`2n`块,总空间以最小盘为准，镜像同步数据，理论读取速度不受影响，甚至更快一点，写入速度受影响，更换盘后需要长时间的镜像同步，但外部读取读写不受影响。 
- `raid 3`: 至少需要3块盘，最后一块盘用于存储奇偶校验数据(专用的奇偶校验)，空间利用率`n - 1`,  可用性、成本和性能折中，但由于需要奇偶校验，因此速度较慢。 
- `raid 5`: 和`raid 3`类似,也是至少需要3块盘，区别在于每个奇偶校验数据是存储于每一个相同的数据块(分布式存储奇偶校验数据)
- `raid 10`: `raid 0 + raid 1`,又称为`raid 01`

## 12.简述lvm创建流程
- `添加新硬盘`-`创建新分区`-`创建物理卷(PV)`-`创建卷组(VG)`-`创建逻辑卷(LV)`-`格式化` 

## 13.简述lvm动态扩容流程
- `卸载挂载点`-`扩容: lvextend -L 290M /dev/storage/vo` - `检查完整性: e2fsck -f /dev/storage/vo`-`挂载`

## 14.如何配置yum源，能够下载诸多第三方软件？
- 新增配置文件`file.repo`到`/etc/yum.repos.d/` 下, 格式如下: 
```bash
[base]
name=CentOS-$releasever - Base      # 仓库描述
baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/   # 仓库地址
gpgcheck=1              # 启用校验
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7     # 公钥 
```

## 15.简述源代码编译安装nginx的步骤
- `下载源码`-`解压`-`配置编译(./configure)`-`编译(make)`-`安装(make install)`

## 16.linux有哪些系统资源监控的命令？
- `top` 
- `sar`  
- `vmstat` 
- `iostat` 