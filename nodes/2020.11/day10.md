# kickstart + pxe 
***太尼玛复杂了，这个大概记录下，估计我也不会用...***  

整体的安装过程是,通过`pxe`安装第一台机器，然后生成`ks`文件，然后通过生成的`ks`文件用`kickstart`来批量自动安装  

安装的节点机器内存需大于2G,否则汇报空间不够的错误     
## 1. kickstart 服务器标准初始化，需关闭防火墙，关闭selinux，静态化配置固定ip，默认网关 
## 2. DHCP 服务端配置  
```bash
$> yum install dhcp -y 
$> cat /etc/dhcp/dhcpd.conf  
# 客户端默认自动使用eth0从dhcp获取ip，未检测到使用eth1去从dhcp获取，相当于检测网线插入的是那块网卡,然后获取ip绑定到网卡上(但virtualbox双网卡eth1配置测试失败，只能检测eth0)
# tshark -ni eht0 抓包查看详细数据 

subnet 172.16.10.0 netmask 255.255.255.0 {              # 配置的网段需要和服务器上网卡网段一致
    range 172.16.10.100 172.16.10.199;                  # range设置起始，结束ip范围
    option subnet-mask 255.255.255.0;                   # 选项，设置掩码
    option routers 172.16.10.2;                         # dhcp服务的网关设置，这里不写，客户端则无法上网
    option domain-name-servers 1.2.4.8;                 # 保证dhcp客户端可以域名解析
    default-lease-time 21600;                           # 默认的IP租用期限
    max-lease-time 43200;                               # 最大的IP租用期限
    next-server 172.16.10.133;                          # 告知客户端tftp服务器的ip
    filename "/pxelinux.0";                             # 指明引导文件，用于指定PXE的运行程序文件，放在TFTP服务器的目录下
}
```

## 3. tftp-server syslinux 
```bash
$> yum install tftp-server syslinux -y

$> systemctl start tftp.socket
$> cp -v /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
# 挂载安装镜像 
$> mount /dev/cdrom /mnt 
$> cp -a /mnt/isolinux/* /var/lib/tftpboot/
$> mkdir /var/lib/tftpboot/pxelinux.cfg
$> cp /mnt/isolinux/isolinux.cfg /var/lib/tftpboot/pxelinux.cfg/default
```
## 4. 通过pxe手动安装  
忽略选择模块，更换安装源位置 
```bash
#
$> vi /var/lib/tftpboot/pxelinux.cfg/default 
# 修改为自动选择安装 
#替换第一行的 default vesamenu.c32 为:
default linux 

# 修改 镜像软件包仓库的位置及网卡信息 
# 替换65行 append initrd=initrd.img inst.stage2=hd:LABEL=CentOS\x207\x20x86_64 quiet 为: 
append initrd=initrd.img inst.repo=http://10.0.2.5/CentOS-7 net.ifnames=0 biosdevname=0

```

## 5. 通过ks文件自动安装 
一般服务器安装完成后会在`/root`目录下生成一个`anaconda-ks.cfg`,
这个可以当作`ks`自动安装的配置文件(如果服务器配置一致，修改下文件中的IP,主机名的配置基本上就可以直接用了，但需要注意的是这个`ks`文件生成的服务器也必定要是通过`pxe`来安装的，不然自动安装的时候他会找不到安装源，或者每台机器都去放一个光盘上去)  

修改`pxelinux.cfg/default` 为使用`ks`文件自动安装：  
```bash
default auto-install-ks
timeout 50
prompt 0

label auto-install-ks
  kernel vmlinuz
  append initrd=initrd.img inst.ks=http://10.0.2.5/ks_config/anaconda-ks.cfg ksdevice=eth0 net.ifnames=0 biosdevname=0

```

# cobbler 安装
```bash
$> yum install cobbler cobbler-web dhcp tftp-server pykickstart httpd python-django -y

$> vim /etc/cobbler/settings
manage_dhcp: 1             # 让cobbler可以管理dhcp
server: 10.0.2.5           # 修正cobbler check 错误 1
next_server: 10.0.2.5      # 修正cobbler check 错误 2

$> vim /etc/xinetd.d/tftp
disable   =  no            # 修正cobbler check 错误 3

$> cobbler get-loaders     # 修正cobbler check 错误 4

$> systemctl start rsyncd.service   # 修正cobbler check 错误 5

# python -c 'import crypt;print(crypt.crypt("1"))'
$> vim /etc/cobbler/settings        # 修改默认密码 (cobbler)
default_password_crypted: "$1$Fb82190H$FnE/hPyWSmK96jfXU3ItP1"      # 修正cobbler check 错误 7,这个密码是指的安装系统的系统默认密码


$> vim /etc/cobbler/dhcp.template
# 修改IP为网卡ip段，并移除
# option routers     xxxx
# option domain-name-servers    xxx

$> systemctl restart cobblerd.service       # 重启
$> cobbler sync                             # 写入修改配置 
$> cobbler check                            # 在检查 (遗留两个)

# cobblerd.service httpd.service tftp.socket rsyncd.service 需要手动管理并启动的服务(dhcp是由cobber管理的，不用手动处理)

```

## 访问
`https://192.16.10.5/cobbler_web` 默认账号密码: `cobbler:cobbler`  

1. 登陆后选择 `Import DVD`，`Prefix`为名称，`Path`为系统挂载镜像的位置,如`/mnt`(`mount /dev/cdrom /mnt`),其他根据实际情况选择,点击`Run`，
然后在`Eents`中就可以看到导入任务了，服务器上导入存储到的位置是`/var/www/cobbler/ks_mirror`下    

2. 选择`Distros` 点击导入的镜像名称,在`Kernel Options` 添加内核参数`net.ifnames=0 biosdevname=0`保存(也可以忽略),其他不修改

3. 创建自定义的`ks`文件  