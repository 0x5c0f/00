安装前需检查反项代理是否正常 

# 配置文件说明 /etc/keepalived/keepalived.conf
主备节点配置基本一致,需修改的仅有 router_id , state ，priority  
```bash
# GLOBAL CONFIGURATION    # 全局配置
仅保留router_id 即可, router_id 为高可用集群成员ID,ID 唯一 

# VRRPD CONFIGURATION     # vrrpd 配置 
vrrp_instance VI_1 {                # 定义实例信息，同主备节点实例标识相同(唯一) 
    state MASTER                    # 定义实例中主备状态角色(MASTER/BACKUP),仅为标识而已
    interface eth1                  # 设置主备服务器虚拟ip放置网卡位置
    virtual_router_id 51            # 虚拟路由ID标识，不同实例不同，各个主备节点相同(0-255)
    priority 100                    # 设置抢占优先级，数值越大越优先(1-254)
    advert_int 1                    # 主备通讯时间间隔(s)
    authentication {                # 主备间通过认证建立连接
        auth_type PASS
        auth_pass 1111
    }

    virtual_ipaddress {             # 定义主备服务器之间使用的虚拟IP地址信息(VIP)，一般来说一个实例对应一个服务，一个服务监听配置的固定VIP     
        192.16.10.5/24 dev eth1 label eth1:1 
    }
}


# LVS CONFIGURATION       # 相当于nginx的部分 
```

## 脑裂：只要备服务器收不到主的组播包，备就会成为主,而主资源未释放
### 原因 
1. 防火墙
2. 多节点间的网络出现故障 
3. virtual_router_id 配置数值不正确 

### 解决方案 
一般来说,只要备节点出现VIP就表示不正常，但也有可能是正常的主备切换，如果不是正常的切换，
那么可能是当前节点故障或者当前节点与主节点的通信问题，可以建立一个脚本周期性检查当前节点
与网关的连接性，不通，则应该是自身问题(写个循环ping网关，不通关闭keepalive，通过打开keepalive)


## 建立nginx与keepalived的关联 
nginx 存活检测(示例，正式不应该这样检测)
```bash
#!/bin/bash
systemctl is-active nginx.service >& /dev/null || {
    systemctl stop keepalived.service
}
```

### 修改配置 /etc/keepalived/keepalived.conf 
```ini
vrrp_script check_web {                         # 函数名(需放到实例与全局之间)
    script "/opt/sh/check_nginx_status.sh"      # 监控脚本(需有执行权限)          
    interval  2                                 # 检查时间间隔(s)
    # weight  2                                   # 用于与执行结果判断而调整优先级的
}

track_script {                                  # 调用配置的函数脚本（放到示例配置里面） 
    check_web
}

```

## 双主(或互为主备) 
实现就是在两个节点中在添加一个实例，修改state，priority，和VIP
