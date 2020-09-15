# ifconfig 命令
- 网卡启动/关闭: `ifconfig eth0 up/down` 
- 添加附属ip： `ifconfig eth0:1 192.16.10.11 netmask 255.255.255.0 up # ifconfig eth0:1 192.16.10.11/24 up ` 
- 修改mac地址: `ifconfig eth0 hw ether xx:xx:xx:xx:xx:xx`(mac地址有特定格式) 

# route 命令 
从原主机到目标主机的转发过程就叫做路由   
- 静态路由：静态路由是在路由器中设置固定的路由表；除非网络管理员进行干预，否则静态路由表不会发生变化。
- 动态路由：由网络中的路由器之间相互通信，传递路由信息，利用收到的路由信息更新路由表的路由方式。

参数详解:  
`Destination`: 目标网段或者主机    
`Gateway`: 网关地址,网络通过该IP出口，*或者 0.0.0.0代表是由本地转发出去的   
`Genmask`: 子网掩码   
`Flags`: 标记(U: 路由是活动的/运行状态，G： 路由指向的是一个网关,H: 目标是一个主机,!：路由已被禁止)   
`Metric`: 路由距离，到达指定网络所需的中转数（linux 内核中没有使用）  
`Ref`: 路由项引用次数（linux 内核中没有使用）  
`Use`: 此路由项被路由软件查找的次数  
`Iface`:该路由表项对应的输出接口  

临时添加方法:  
- 删除默认路由: `route del default (gw 192.16.10.1)` 
- 添加默认路由: `route add default gw 192.16.10.1` 
- 添加路由: `route add -host 192.16.101.0 netmask 255.255.255.0 gw 192.16.10.1` # 发往`192.16.101`网段的全部需要经过`192.16.10.1`
- 删除路由: `route del -host 192.16.101.0 netmask 255.255.255.0`

永久添加方法:  
- 将路由命令写入`/etc/rc.local`中  
- 在`/etc/sysconfig/`下创建默认脚本 

# ip 命令 
- 网卡启动/关闭: `ip link set eth0 up/down` 
- 修改网卡mac: `ip link set eth0 address xx:xx:xx:xx:xx:xx`
- 添加/删除附属ip： `ip address add/del 192.16.10.11/24 dev eth0`
- 添加/删除附属ip(别名): `ip address add/del 192.16.10.12/24 dev eth0 label eth0:1`  

