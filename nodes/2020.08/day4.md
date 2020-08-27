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
 - `-c`, --comment COMMENT         修改用户注释
 - `-d`, --home HOME_DIR           修改用户主目录 
 - `-e`, --expiredate EXPIRE_DATE  修改密码过期日期
 - `-f`, --inactive INACTIVE       密码过期后多少天关闭账号
 - `-g`, --gid GROUP               修改用户用户组
 - `-G`, --groups GROUPS           修改用户所属组的附加组
 - `-a`, --append GROUP            追加组到用户，需配合`-G`使用 
 - `-l`, --login NEW_LOGIN         修改用户账号名称
 - `-L`, --lock                    锁定用户帐号
 - `-U`, --unlock                  解锁用户帐号
 - `-m`, --move-home               将家目录内容移至新位置 (仅于 -d 一起使用)
 - `-s`, --shell SHELL             修改用户帐号的新登录 `shell`
 - `-u`, --uid UID                 修改用户`UID`
 
# su 命令 

## linux 创建用户流程 
 1. 读取`/etc/login.defs`和`/etc/default/useradd`创建规则  
 2. 向`/etc/passwd`和`/etc/group`中添加用户及组信息,向`/etc/shadow`和`/etc/gshadow`中添加密码信息  
 3. 根据`/etc/default/useradd`中规则创建家目录  
 4. 复制`/etc/skel`内容到家目录  

## /etc/login.defs 
 - `MAIL_DIR	/var/spool/mail`        # 邮件存放位置 
 - `PASS_MAX_DAYS	99999`              # 密码最长使用天数 
 - `PASS_MIN_DAYS	0`                  # 密码更换最短时间 
 - `PASS_MIN_LEN	5`                  # 密码最小长度 
 - `PASS_WARN_AGE	7`                  # 密码失效前几天开始报警 
 - `UID_MIN                  1000`      # uid 开始 
 - `UID_MAX                 60000`      # uid 结束
 - `SYS_UID_MIN               201`      # 
 - `SYS_UID_MAX               999`      # 
 - `GID_MIN                  1000`      # 
 - `GID_MAX                 60000`      # 
 - `SYS_GID_MIN               201`      #
 - `SYS_GID_MAX               999`      # 
 - `CREATE_HOME	yes`                    # 
 - `UMASK           077`                # 家目录umask
 - `USERGROUPS_ENAB yes`                # 
 - `ENCRYPT_METHOD SHA512`              # 密码加密算法 

## 