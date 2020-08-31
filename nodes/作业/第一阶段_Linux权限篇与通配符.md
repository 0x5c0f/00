## 1.找到当前目录下所有的.txt文件，且将查询结果写入到allfile.txt中
- `find ./ -type f -name "*.txt" > allfile.txt`

## 2.解读如下语句
-rw-r--r--  1 root     root         11921 11月 11 09:01 err150.log

- 文件名 `err150.log`,用户是`root`拥有权限可读、可写，所在组`root`拥有权限可读，其他人可读权限。

## 3.如何输出PATH的变量值
- `echo $PATH` 


# 4.查看bash解释器的绝对路径
- `env|grep bash` 
- `type bash` 

## 5.打包且压缩/opt下所有内容，压缩文件名字为allopt.tar.gz
- `tar -czf allopt.tar.gz /opt/* `  

## 6.指定解压缩目录/tmp/ ，解压缩allopt.tar.gz
- `tar -xzf allopt.tar.gz -C /tmp`

## 7.压缩当前目录所有.html类型文件
- `tar -czf file.tar.gz *.html` 

## 8.解压缩data.zip文件
- `unzip data.zip` 

## 9.显示当前时间，格式是"年-月-日 时：分：秒"
- `date +"%Y-%m-%d %T"`
- `date +"%Y-%m-%d %H:%M:%S"` 

## 10.解读如下语句 /etc/passwd文件
chaoge:x:2002:2002::/home/chaoge:/bin/bash
- 当前用户`chaoge`,用户`UID:2002,GID:2002`,无用户说明,用户所属主目录`/home/chaoge`,命令解释器`/bin/bash`

## 11.创建系统用户chaoge，且设置密码"chaoge666"，且禁止该用户登录，且不创建该用户家目录
- `useradd -M -s /sbin/nologin chaoge && echo "chaoge666" | passwd --stdin chaoge `
- `useradd -r -M -s /sbin/nologin chaoge && echo "chaoge666" | passwd --stdin chaoge ` (系统账户) 

## 12.修改系统用户chaoge，允许登录
 - `usermod -s /bin/bash chaoge`
 - `chsh  -s /bin/bash chaoge`

## 13.删除系统用户chaoge及其家目录
 - `userdel -r chaoge`

## 14.设置用户chaoge，7天内不得修改密码，允许30天后可以修改，账号过期前7天通知用户，过期10天后禁止登录
- `chage -m 7 -M 30 -W 7 -i 10 chaoge` 


## 15.切换至用户chaoge登录
 - `su - chaoge`

## 16.配置chaoge用户允许使用sudo命令，且使用chaoge用户查看/root下内容
```bash
$> visudo  # sed -i '100a chaoge    ALL=(ALL)       ALL' /etc/sudoers
## 101 行添加
chaoge    ALL=(ALL)       ALL
# 查看/root 
$> su - chaoge
$> sudo ls -la /root 
```

## 17.设置data.zip文件 所有角色可读可写
- `chmod 666 data.zip`

## 18.仅允许user读写/data下的内容，其他角色无任何权限
```bash
$> chmod 700 /data -R 
$> chow user.user /data -R 
```

## 19.修改文件chaoge.txt属主为pyyu,属组为pyyu
- `chown pyyu.pyyu chaoge.txt` 

## 20.如何查看机器umask值
- 命令执行 `umask`

## 21.找出/tmp下以任意一位数字开头，且以非数字结尾的文件
- `find /tmp -type f -regextype "posix-egrep" -regex "/tmp/[0-9].*[^0-9]$"`

## 22.复制/tmp目录下所有的.txt文件结尾的文件，且以y、t开头的文件，放入/data目录
- `find /tmp -type f -regextype "posix-egrep" -regex "/tmp/[y,t].*\.txt" -exec cp {} /data \;`

## 23.找出linux下除了字符a-d单个字符的后缀是.txt文件
- `find / -type f -name "*.txt" | egrep "./[^a-d].*\.txt"` 
- `find / -type f -name "*.txt" -regextype "posix-egrep" -regex "/[^a-d].*"`

## 24.分别举例对于文件和目录来说rwx权限的含义。
- 文件: 可读、可写、可执行 
- 目录：可读、可写、可切换

## 25.通过权限角度解释报错的原因
[oldboy@show ~]$ whoami 
oldboy
[oldboy@show ~]$ ls /root/
ls: cannot open directory /root/: Permission denied
1. `oldboy`用户对于目录 `/root` 没有可读权限  


[oldboy@show ~]$ touch /etc/oldboy.txt
touch: cannot touch `/etc/oldboy.txt': Permission denied
2. `oldboy`用户对于目录 `/etc`没有可写权限(和可执行权限) 


[oldboy@show ~]$ rm -f /etc/hosts 
rm: cannot remove `/etc/hosts': Permission denied
3. `oldboy`用户对于目录`/etc`没有可写权限(和可执行权限) 

[oldboy@show ~]$ cat /etc/shadow
cat: /etc/shadow: Permission denied
3. `oldboy`用户对于文件`/etc/shadow`没有可读权限 