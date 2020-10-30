# zabbix
```bash

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'  Identified by "k22gve2rSgUTArEd" WITH GRANT OPTION;

wget "https://cdn.zabbix.com/zabbix/sources/stable/4.0/zabbix-4.0.26.tar.gz"

tar -xzf zabbix-4.0.26.tar.gz && cd zabbix-4.0.26/

yum -y install curl libcurl-devel net-snmp net-snmp-devel perl-DBI libdbi-dbd-mysql mysql-devel gcc gcc++ make libxml2 libxml2-devel libevent-devel

./configure --prefix=/opt/zabbix-3.4.15 --enable-server --enable-agent --enable-java --with-mysql --enable-ipv6 --with-net-snmp --with-libcurl --with-libxml2

make && make install

ln -s /opt/zabbix-4.0.26 /opt/zabbix-server


# /misc/init.d/fedora/core/zabbix_server	 
# /misc/init.d/fedora/core/zabbix_agent


CREATE SCHEMA `zabbix` DEFAULT CHARACTER SET utf8 collate utf8_bin;  ;

source /data/softsrc/zabbix-4.0.26/database/mysql/schema.sql;

source /data/softsrc/zabbix-4.0.26/database/mysql/images.sql;

source /data/softsrc/zabbix-4.0.26/database/mysql/data.sql;

GRANT ALL PRIVILEGES ON *.* TO 'zabbix'@'127.0.0.1'  Identified by "NQHWbkuyjpZ84dWt" WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'zabbix'@'localhost'  Identified by "NQHWbkuyjpZ84dWt" WITH GRANT OPTION;


useradd -M -u 1001 -d /opt/zabbix-server -s /sbin/nologin zabbix

#####
grep "^[a-zA-Z]" zabbix_server.conf
DBHost=127.0.0.1
DBName=zabbix
DBUser=zabbix
DBPassword=NQHWbkuyjpZ84dWt
DBPort=3306
######

#########
wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-5.3.4-1.x86_64.rpm 

yum localinstall grafana-5.3.4-1.x86_64.rpm 
```
