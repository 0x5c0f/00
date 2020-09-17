# samba 服务 

```ini
$> yum install samba samba-client 
$> cat /etc/samba/smb.conf 
; 全局配置
[global]

; Samba服务器加入的工作组名，一个局域网内，必须有相同的工作组名。
workgroup = MYGROUP

; Samba服务器注释，可以不选，%v代表显示Samba版本号
server string = Samba Server Version %v

; 主机NetBIOS名
netbios name = samba

; 主机NetBIOS名
netbios name = samba

; 设置Samba服务器端监听网卡，可以写网卡名称或者IP地址
interfaces = lo eth0

; 允许连接到Samba server客户端IP，多个参数用空格分开。可以用一个IP表示，也可以用一个网段表示。EXCEPT 排除某个特定地址 
hosts allow/deny = 10.10.10.1 
;hosts allow = 127. 192.168.2. 192.168.1. EXCEPT 192.168.1.7


;用来指定连接Samba server服务器最大连接数如果操作则连接请求被拒绝。0表示不限制。
max connections = 0

; 来设置断掉一个没有任何文件的链接时间。单位十分钟，0代表Samba server不自动断开任何连接
deadtime = 0

;用来设置让nmdb成为Windows客户端的时间服务器
time server = yes/no

;设置Samba server日志文件存储位置和日志名称。文件后面加一个%m（主机名），每个主机都会有一个主机名.log日志文件
log file = /var/log/samba/%m.log

;限制每个日志文件的最大容量为50KB，0代表不限制
max log size = 50

;设置客户端访问Samba服务器的验证方式，Samba4版本已经不使用share和server方式，这里不介绍
;1) user:Samba用户名和密码登录
;2) domain：添加Samba服务器到N域，由NT与控制起来进行身份验证。域安全级别，使用主域控制器（PDC）来完成认证
Security = user

;后台管理用户密码方式
;1）smbpasswd：该方式是使用smb自己的工具smbpasswd来给系统用户
;2）tdbsam：该方式则是使用一个数据库文件来建立用户数据库。
;3）ldapsam：该方式则是基于LDAP的账户管理方式来验证用户。
passdb backend = tdbsam

;用来定义samba用户的密码文件。smbpasswd文件如果没有那就要手工新建。
smb passwd file = /etc/samba/smbpasswd

;用来定义用户名映射，比如可以将root换administrator、admin等。内容：用户名 = 别名 
username map = /etc/samba/smbusers

;用来设置guest用户名。
guest account = nobody

;用来设置服务器和客户端之间会话的Socket选项，可以优化传输速度
socket options = TCP_NODELAY SO_RCVBUF=8192 SO_SNDBUF=8192

;设置是否在启动Samba时就共享打印机。
load printers = yes/no

; 共享参数 
[share]
;comment是对该共享的描述，可以是任意字符串。
comment = 任意字符串

;browseable用来指定该共享是否可以浏览。
browseable = yes/no

;path用来指定共享目录的路径。
path = 共享目录路径

;用来指定该共享路径是否可写
writable = yes/no


;invalid users用来指定不允许访问该共享资源的用户。
;例如：invalid users = root，@bob（多个用户或者组中间用逗号或空格隔开。）
valid users = 有效的访问账户列表
invalid users = 禁止访问该共享的用户

;用来指定该共享是否允许guest账户访问。
public = yes/no

;用来指定该共享是否允许guest账户访问。
guest ok = yes/no 
```