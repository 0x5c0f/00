# 测试版本: redis 5.0.10 
# 机器为: 10.0.2.25 10.0.2.26 
# 
```bash
make PREFIX=/opt/redis-5.0.10 install 
mkdir -p /opt/redis-5.0.10/{data,logs}
```

### 配置文件额外修改以下参数(多少个节点，多少个独立配置文件)
```bash
# /opt/redis-server/etc/redis_6371.conf
masterauth i4ZHIJNDYvndeZOh   # 与requirepass密码一致 
cluster-enabled yes
cluster-config-file /opt/redis-server/etc/nodes-6370.conf
cluster-node-timeout 15000
```

### 启动 
```bash
# 10.0.2.25
/opt/redis-server/bin/redis-server /opt/redis-server/etc/redis_6371.conf
/opt/redis-server/bin/redis-server /opt/redis-server/etc/redis_6372.conf
/opt/redis-server/bin/redis-server /opt/redis-server/etc/redis_6373.conf

# 10.0.2.25
/opt/redis-server/bin/redis-server /opt/redis-server/etc/redis_6375.conf
/opt/redis-server/bin/redis-server /opt/redis-server/etc/redis_6376.conf
/opt/redis-server/bin/redis-server /opt/redis-server/etc/redis_6377.conf
```

### 激活集群连接 任意一个节点执行 
```bash
/opt/redis-server/bin/redis-cli \
--cluster create \
10.0.2.25:6371 \
10.0.2.25:6372 \
10.0.2.25:6373 \
10.0.2.26:6375 \
10.0.2.26:6376 \
10.0.2.26:6377 \
--cluster-replicas 1 \
-a i4ZHIJNDYvndeZOh 
# -cluster-replicas 1 一个主一个从配置，以上为3主3从 
```

## redis 代理(一个服务器上部署，看需要部署多节点)
> https://juejin.im/post/6863701563685371917
 
```bash
yum install libstdc++-static gcc gcc-c++ -y

git clone https://github.com/joyieldInc/predixy.git

make MT=true
cp -v ./conf/auth.conf /opt/redis-server/conf/auth.conf  
cp -v ./conf/cluster.conf /opt/redis-server/conf/cluster.conf  
cp -v ./conf/latency.conf /opt/redis-server/conf/latency.conf  
cp -v ./conf/predixy.conf /opt/redis-server/conf/predixy.conf
cp -v ./src/predixy /opt/redis-server/bin/

##  /opt/redis-server/conf/predixy.conf
# 修改指示节点名
Name Predixy_10.0.2.25

# 可以修改端口
Bind 10.0.2.25:6370
# 修改内容 
Include try.conf
# 为 
Include cluster.conf

## /opt/redis-server/conf/auth.conf
# 移除所有可写权限
# 设置管理权限密码为redis一致
# 

## /opt/redis-server/conf/cluster.conf 
# 修改或添加内容为 
ClusterServerPool {
   Password i4ZHIJNDYvndeZOh
   MasterReadPriority 60
   StaticSlaveReadPriority 50
   DynamicSlaveReadPriority 50
   RefreshInterval 1
   ServerTimeout 1
   ServerFailureLimit 10
   ServerRetryTimeout 1
   KeepAlive 120
   Servers {
       + 10.0.2.25:6371
       + 10.0.2.25:6372
       + 10.0.2.25:6373
       + 10.0.2.26:6375
       + 10.0.2.26:6376
       + 10.0.2.26:6377
   }
}

# 启动 
/opt/redis-server/bin/predixy /opt/redis-server/conf/predixy.conf 
# 连接 
/opt/redis-server/bin/redis-cli -h 10.0.2.25 -p 6370

```
