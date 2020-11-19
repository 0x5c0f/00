# ntp 服务 
`ntp`可以安装在`centos 6 ` 也可以安装在 `centos 7` 上，安装在`centos7`上需要关闭默认的`chronyd.service`   

```bash
$> yum install ntp -y
$> vim /etc/ntp.conf
# nomodify:不允许修改服务器时间(ntpc/ntpq) noquery:不允许查询服务器状态  notrap:不提供 trap 这个远程事件登录 (remote event logging) 的功能。
restrict default nomodify notrap noquery
# 设置那个网段可以访问ntp服务器
restrict 10.0.2.0/24 192.16.10.0/24 
restrict ::1

# 修改为国内时间服务器
server ntp1.aliyun.com iburst
server ntp2.aliyun.com iburst
server ntp3.aliyun.com iburst
server ntp4.aliyun.com iburst

# 显示ntp服务器上游服务器信息
$> ntpq -p 

$> ntpstat 10.0.2.11

```

# chronyd 服务
`centos7`默认安装，此服务可以解决ntp服务时间差异太大而无法同步的问题   

```bash
$> vim /etc/chrony.conf
# 配置时间服务器
pool 2.fedora.pool.ntp.org iburst
pool ntp1.aliyun.com iburst
pool ntp2.aliyun.com iburst
pool ntp3.aliyun.com iburst

# 配置允许同步的地址 
allow 192.16.10.0/24 

# 启动
$> systemctl restart chronyd.service 
# 防火墙放ntp就行，因为没有chronyd
$> firewall-cmd --add-service=ntp --permanent

```


