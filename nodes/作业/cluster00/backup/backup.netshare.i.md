# 原定两台一个为网络共享服务器，作为静态资源共享，一台作为备份服务器，用于数据备份，但目前做的时候感觉太麻烦了，合并为一台.
# Git 和 SVN的区别  
1. `git`是分布式的，`svn`是集中式的   
2. `git`存储数据是以元数据形式存储，`svn`是按文件，原数据怎样的结构，存储就是怎样的结构  
3. 分支不同，`svn`的分支就是复制了一个目录出来  

# chroot系统 
**正常来说针对于文件共享的`sftp`应该是以用户为单位来做的,但这儿我却用的是组,这个其实是我测试用用户来做从来没有成功过，只能被迫用组**  
```bash
# groupadd -g 1002 www  

mkdir /data/chroot-sftp

mkdir -p /data/chroot-sftp/{bin,usr,etc,lib64,home,dev,data}

mknod -m 666 /data/chroot-sftp/dev/null c 1 3
mknod -m 666 /data/chroot-sftp/dev/tty c 5 0
mknod -m 666 /data/chroot-sftp/dev/zero c 1 5
mknod -m 666 /data/chroot-sftp/dev/random c 1 8

chmod o+t /data/chroot-sftp/dev/null /data/chroot-sftp/dev/tty /data/chroot-sftp/dev/zero /data/chroot-sftp/dev/random

cd /data/chroot-sftp/usr
ln -sf ../bin ./bin
ln -sf ../lib64 ./lib64

cat >> /etc/ssh/sshd_config <<EOE
Match Group  www
    ChrootDirectory  /data/chroot-sftp/data
    ForceCommand internal-sftp
    X11Forwarding no
    AllowTcpForwarding no
    PasswordAuthentication no
EOE

systemctl restart sshd

cp -p /bin/ls /bin/cat /bin/rm /bin/echo /bin/sh /bin/touch /bin/vi /bin/mkdir  /data/chroot-sftp/bin/

for i in /bin/{ls,cat,echo,rm,sh,touch,vi,mkdir}; do  list=$(ldd ${i} | egrep -o '/lib.*\.[0-9]'); for _so in $list; do /bin/cp -v ${_so} /data/chroot-sftp${_so}; done; done

# 创建sftp运行账号 
useradd sshfsdir -u 1010 -g 1002 -M -d /home/sshfsdir -s /sbin/nologin

mkdir -p /data/chroot-sftp/home/sshfsdir

chown sshfsdir:www /data/chroot-sftp/home/sshfsdir
chmod 700 /data/chroot-sftp/home/sshfsdir

# 创建系统映射目录 ，让系统可查询到该用户
ln -sf /data/chroot-sftp/home/sshfsdir /home/sshfsdir

# 生成公私钥用于远程登陆(实际创建路径为/data/chroot-sftp/home/sshfsdir/.ssh/,保留私钥给远程登陆即可) 
su - sshfsdir -s /bin/bash -c "ssh-keygen -t rsa -b 4096"
su - sshfsdir -s /bin/bash -c "cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys"  

```
## 节点服务器配置
```bash
# 开机启动项
$> vim /etc/fstab
sshfsdir@10.0.2.30:/node21 /data/backup fuse.sshfs auto,reconnect,_netdev,user,idmap=user,identityfile=/etc/.ssh/sshfsdir,allow_other,default_permissions,uid=1002,gid=1002 0 0

# zabbix 监控 
$> vim /opt/zabbix-agentd/etc/zabbix_agentd.conf.d/sshfs_status.conf 
UserParameter=sshfs_status,/bin/systemctl is-active data-ltbstore.mount >& /dev/null && echo 0 || echo 1

```