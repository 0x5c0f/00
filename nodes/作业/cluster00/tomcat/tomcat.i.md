# /etc/profile  
## java  
```bash
export JAVA_HOME=/opt/jdk1.8.0_271
export PATH=$JAVA_HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
```

## tomcat  
```bash
export TOMCAT_HOME=/opt/tomcat-8.5.59
```

## 日志 
- `catalina.out` 为主要日志文件，会随着时间不断增加  
- `catalina.$(date +"%Y-%m-%d").log` 为`catalina.out`的每日切割文件(实际好像不是，`tomcat`不会自动切割日志) 

## 多实例
多实例就是多个`tomcat`，然后修改下端口就行了

## 监控
### 命令监控 
- `jps -lvm`  
- `show-busy-java-threads`  

查询到繁忙的`java`进程`pid`后,通过`jstack <pid>`查询详细信息，然后发送给开发人员即可  

### zabbix 监控 
 **系统尽量不要使用纯数字作为主机名**   
1. `tomcat` 开启远程监控功能  
```bash
$> vim +124 /opt/tomcat-8.5.59/bin/catalina.sh # 124 
CATALINA_OPTS="$CATALINA_OPTS
-Dcom.sun.management.jmxremote 
-Dcom.sun.management.jmxremote.port=12345 
-Dcom.sun.management.jmxremote.authenticate=false 
-Dcom.sun.management.jmxremote.ssl=false 
-Djava.rmi.server.hostsname=10.0.2.20       # tomcat服务器的ip
"
```
2. `zabbix_server` 启动并配置 `JavaGateway`
```bash
$> vim /opt/zabbix-server/etc/zabbix_server.conf    # 282
JavaGateway=10.0.2.11
JavaGatewayPort=10052
StartJavaPollers=5

$> systemctl restart zabbix_server.service  
$> /opt/zabbix-server/sbin/zabbix_java/startup.sh

# 前端添加jmx 监控, 完成 
```

## 优化  
1. 根据文献记载，一个`tomcat`一般只部署一个站点, 清理`webbapps`下所有目录，新建`ROOT`将项目内容直接放到里面去，然后`nginx`反代即可  
```conf
# 需要指定Host 等绑定参数，不然有坑 
location / {
    proxy_pass http://jpress_server;
    proxy_set_header Host $host:$server_port;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header REMOTE-HOST $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
```
具体优化见: [https://blog.cxd115.me/115/62.html](https://blog.cxd115.me/115/62.html)
