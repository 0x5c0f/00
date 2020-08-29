# linux 权限 
## useradd 命令
 - `-c`, `--comment COMMENT`         账户描述
 - `-d`, `--home-dir HOME_DIR`       账户的主目录
 - `-e`, `--expiredate EXPIRE_DATE`  新账户的过期日期
 - `-f`, `--inactive INACTIVE`       新账户的密码不活动期(天)
 - `-m`, `--create-home`             创建用户的主目录
 - `-M`, `--no-create-home`          不创建用户的主目录
 - `-u`, `--uid UID`                 指定 `uid`
 - `-g`, `--gid GROUP`               指定 `gid` 
 - `-G`, `--groups GROUPS`           新账户的附加组列表
 - `-l`, `--no-log-init`             不要将此用户添加到最近登录和登录失败数据库
 - `-N`, `--no-user-group`           不创建同名的组
 - `-o`, `--non-unique`              允许使用重复的 `UID` 创建用户
 - `-r`, `--system`                  创建一个系统账户
 - `-s`, `--shell SHELL`             指定账户登录的 `shell`
 - `-U`, `--user-group`              创建与用户同名的组  


## usermod 命令
 - `-c`, `--comment COMMENT`         修改用户注释
 - `-d`, `--home HOME_DIR`           修改用户主目录 
 - `-e`, `--expiredate EXPIRE_DATE`  修改密码过期日期
 - `-f`, `--inactive INACTIVE`       密码过期后多少天关闭账号
 - `-g`, `--gid GROUP`               修改用户用户组
 - `-G`, `--groups GROUPS`           修改用户所属组的附加组
 - `-a`, `--append GROUP`            追加组到用户，需配合`-G`使用 
 - `-l`, `--login NEW_LOGIN`         修改用户账号名称
 - `-L`, `--lock`                    锁定用户帐号
 - `-U`, `--unlock`                  解锁用户帐号
 - `-m`, `--move-home`               将家目录内容移至新位置 (仅于 -d 一起使用)
 - `-s`, `--shell SHELL`             修改用户帐号的新登录 `shell`
 - `-u`, `--uid UID`                 修改用户`UID`
 
## su 命令 
`su`命令切换用户，使用`su - <user>`切换将完全切换，包括环境变量、顺便也会切换当前目录为用户主目录，`su <user>`仅切换用户，其他保持现有不变。 
- `su - root -c "ls -l /home/"`: `-c`仅执行一条命令，而不切换用户  
- `su - <user> -s /bin/fish`： `-s` 指定登陆用户所使用的`bash`  

## groupmod 命令
 - `-g`, `--gid GID`                 修改用户组`GID`
 - `-n`, `--new-name NEW_GROUP`      修改组名字


## linux 创建用户流程 
 1. 读取`/etc/login.defs`和`/etc/default/useradd`创建规则  
 2. 向`/etc/passwd`和`/etc/group`中添加用户及组信息,向`/etc/shadow`和`/etc/gshadow`中添加密码信息  
 3. 根据`/etc/default/useradd`中规则创建家目录  
 4. 复制`/etc/skel`内容到家目录  

## /etc/login.defs 
```bash
MAIL_DIR	/var/spool/mail        # 邮件存放位置 
PASS_MAX_DAYS	99999              # 密码最长使用天数 
PASS_MIN_DAYS	0                  # 密码更换最短时间 
PASS_MIN_LEN	5                  # 密码最小长度 
PASS_WARN_AGE	7                  # 密码失效前几天开始报警 
UID_MIN                  1000      # uid 开始 
UID_MAX                 60000      # uid 结束
SYS_UID_MIN               201      # 
SYS_UID_MAX               999      # 
GID_MIN                  1000      # 
GID_MAX                 60000      # 
SYS_GID_MIN               201      #
SYS_GID_MAX               999      # 
CREATE_HOME	yes                    # 
UMASK           077                # 家目录umask
USERGROUPS_ENAB yes                # 
ENCRYPT_METHOD SHA512              # 密码加密算法 
```



## umask 计算 (更正)  

- 当创建目录时候，`目录创建后的权限` =  `默认目录最大权限(777)` - `umask 权限`  
    - `umask=0022 --> 777 - 022 = 755(目录权限)`  
- 当创建文件时候，若`umask`值所有位数为偶数，则 `文件创建后的权限` = `默认文件最大权限(666)` - `umask权限`  
    - `umask = 0022 --> 666 - 022 = 644(文件权限)`  
- 当创建文件时候，若`umask`值部分或全部为奇数时候，则 `文件创建后的权限` = `默认文件最大权限(666)` - `umask权限` + `umask基数位+1`  
    - `umask = 0045 --> 666 - 045 = (621 + 001) = 622`  
    - `umask = 0033 --> 666 - 033 = (633 + 011) = 644`  

## chattr 命令 
|-|-|
|-|-|
|`i`|如果对文件设置属性，那么不允许对文件进行删除、改名，也不能添加和修改数据<br/>如果对目录设置 i 属性，那么只能修改目录下文件中的数据，但不允许建立和删除文件|
|`a`|如果对文件设置 a 属性，那么只能在文件中増加数据，但是不能删除和修改数据<br/>如果对目录设置 a 属性，那么只允许在目录中建立和修改文件，但是不允许删除文件|
|`e`|Linux 中的绝大多数文件都默认拥有 e 属性，表示该文件是使用 ext 文件系统进行存储的|

## shred 命令 
彻底删除一个文件  
```bash
-f, --force 必要时修改权限以使目标可写
-n, --iterations=N 覆盖N 次，而非使用默认的3 次
    --random-source=文件 从指定文件中取出随机字节
-s, --size=N 粉碎数据为指定字节的碎片(可使用K、M 和G 作为单位)
-u, --remove 覆盖后截断并删除文件
-v, --verbose 显示详细信息
-x, --exact 不将文件大小增加至最接近的块大小
-z, --zero 最后一次使用0 进行覆盖以隐藏覆盖动作
```