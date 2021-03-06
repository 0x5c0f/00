# linux 运维基础 

## 入门导学
重要内容:  
- 单位转换  
    - `1B`(`Byte` 字节)=`8bit`  
    - `1KB` (`Kilobyte` 千字节)=`1024B`  
    - `1MB` (`Megabyte` 兆字节 简称“兆”)=`1024KB`  
    - `1GB` (`Gigabyte` 吉字节 又称“千兆”)=`1024MB`    
    - `1TB` (`Trillionbyte` 万亿字节 太字节)=`1024GB`  

- 磁盘分区划分  
    - swap: 常规大小为内存的`1.5 - 2`倍,内存大于`8G` 分 `8G`,实际云环境并未分配`swap`  
    - boot: 常规分为`200M`，实际应用个人建议 `1-2G`   
    - 其他分区看情况划分  

- `ip` 配置  
    - `/etc/sysconfig/network-scripts/ifcfg-ens33`  
    **`centos 7`网络管理服务`network.service`**  
    **`centos 7` 默认管理终端网卡管理 `nmtui`,该命令来源软件包`NetworkManager-tui`**   
    **网卡名称修改为`ethx`: [`https://blog.cxd115.me/115/54.html`](https://blog.cxd115.me/115/54.html)**  
    ```bash
    DEVICE=eth0                 # 网络接口名称,centos7 默认为ensxx ，可通过上诉方法修改为ethx 
    HWADDR=00:0c:29:7c:e9:b6    # MAC地址。只需设置其中一个，同时设置时不能相互冲突。
    DEFROUTE=yes                # 指定默认路由，适用于多网卡机器，一般系统默认选择eth0,被坑过一次，以后每次都必要设置设个参数  
    TYPE=Ethernet               # 配置文件接口类型，包含Ethernet 、IPsec等,网络接口为Ethernet  
    UUID=1f959e16-1b05-427c-8b3b-0aaee1ac11e4   # 
    ONBOOT=yes                  # 系统启动时是否激活 yes: 激活  no: 不激活
    NM_CONTROLLED=yes           # 是否由Network Manager控制该网络接口。实时生效，无需重启，一般建议设为no。(不过我没有遇到过这个问题产生的故障。) 
    BOOTPROTO=none              # 系统启动地址协议 none：不使用启动地址协议; bootp：BOOTP协议; dhcp：DHCP动态地址协议; static：静态地址协议
    IPADDR=192.16.10.11        # IP 地址
    NETMASK=255.255.255.0       # 子网掩码
    IPV6INIT=no                 # 是否启用ipv6 
    USERCTL=no                  # 用户权限控制 yes: 非root用户允许控制该网络接口 no: 非root不允许
    DNS1=114.114.114.114        # dns 配置地址，DNS1 DNS2        
    GATEWAY=192.16.10.1         # 网关地址  
    ```
- linux 开机启动流程  
    1. 打开电源  
    2. 开机`bios`自检  
    3. `mbr`引导  
    4. `gurb`查找并加载内核   
    5. 内核初始化  
    6. `systemd`初始化  
    7. 读取运行级别(`/etc/systemd/system/default.target`-`/lib/systemd/system/multi-user.target`)  
    8. 启动系统服务  
    9. 启动登陆界面  

- linux 运行级别    
    默认运行级别: `/etc/systemd/system/default.target`  

    |-|-|-|
    |-|-|-|
    |`0`|`runlevel0.target(poweroff.target)`|停机模式|
    |`1`|`runlevel1.target(rescue.target)`|单用户模式|
    |`2`|`runlevel2.target(multi-user.target)`|多用户模式,不支持`nfs`|
    |`3`|`runlevel3.target(multi-user.target)`|多用户模式|
    |`4`|`runlevel4.target(multi-user.target)`|系统未使用，保留给用户|
    |`5`|`runlevel5.target(graphical.target)`|图形界面|
    |`6`|`runlevel6.target(reboot.target)`|重启模式|