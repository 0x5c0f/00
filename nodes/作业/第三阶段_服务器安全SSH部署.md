# 服务器的远程连接，对于服务器安全尤其重要，完成如下部署，提供部署过程  
## 设置linux服务器ssh默认端口为21133  
- `sed -i 's/#Port 22/Port 21133/g' /etc/ssh/sshd_config`

## 禁止root用户使用ssh远程登录  
- `sed -i 's%#PermitRootLogin yes%PermitRootLogin no%' /etc/ssh/sshd_config`

## ssh连接密码错误3次后断开连接  
```bash
# 修改后立即生效(tty,ssh)
$> vim /etc/pam.d/password-auth # 添加(nu:4,12) 似乎有时候无效
auth        required      pam_tally2.so deny=3 unlock_time=600 even_deny_root unlock_time=300
account     required      pam_tally2.so
# 修改后立即生效(ssh)
$> vim /etc/pam.d/sshd # 添加(nu:2)
auth        required      pam_tally2.so deny=3 unlock_time=600 even_deny_root unlock_time=300
# 修改后立即生效(tty)
$> vim /etc/pam.d/login # 添加(nu:1)
auth        required      pam_tally2.so deny=3 unlock_time=600 even_deny_root unlock_time=300

deny=3            #失败三次锁定
even_deny_root    #对于root也适用
unlock_time=600   #锁定时间600秒 
```

## ssh服务器最大连接会话数限制10个  
- 最大会话连接数限制按照官方和网络上流传的方法应该是设置`MaxSessions`此参数，但实际上该参数点毛用都没有(主要针对复用ssh)，要真正限制实际的最大连接数应该只能使用脚本控制`ps/tty`的在线数量，不知道是否还有其他方案  

## 禁止使用密码登录服务器  
- `sed -i 's%PasswordAuthentication yes%PasswordAuthentication no%' /etc/ssh/sshd_config`

## 只能使用chaoge用户免密登录服务器部署  
**这题没有太理解题目(只能)意思,以下按照本地连接`chaoge`用户为免密登陆处理**
- `ssh-keygen -t rsa -b 4096` 创建本地公/私钥文件(本地) 
- `ssh-copy-id chaoge@192.16.10.200` 复制公钥到服务器(`/home/chaoge/.ssh/authorized_keys`)
