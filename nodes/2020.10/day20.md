# 初始化 
# https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.32-linux-glibc2.12-x86_64.tar.gz
# 5.7 
```bash
$> /opt/mysql/bin/mysqld \
--initialize-insecure \
--user=cxd \
--basedir=/opt/mysql \
--datadir=/opt/mysql/data
```

# 5.6 
# https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.50-linux-glibc2.12-x86_64.tar.gz 
```bash
$> /opt/mysql/(bin|scripts)/mysql_install_db \
--user=cxd \
--basedir=/opt/mysql \
--datadir=/opt/mysql/data
```


# 修正文件路径及启动用户 
```
$> /opt/mysql/bin/mysqld_safe   /opt/mysql/support-files/mysql.server(启动文件，复制并重命名/etc/init.d/mysqld)
```

# 修改配置文件(默认的/etc/my.cnf是mariadb的)
```ini
[mysqld]
basedir = /opt/mysql
datadir = /opt/mysql/data
port = 3306
server_id = 1
socket = /tmp/mysql.sock

sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
```

# 修改密码
```
mysql> set password for root@localhost = password(‘123’);
```