# nfs 服务 
## 安装
- `yum install `nfs`-utils rpcbind && mkdir /nfsshare && chown nfsnobody. nfsshare`
## 配置文件说明
### `/etc/exports` 用于管理贡献相关配置的文件 
- 内容格式: `NFS`共享目录 `NFS`客户端地址(参数1、参数2...) 客户点地址2（参数1、参数2...）{示例: ` /        master(rw)  master2(insecure,rw,all_squash)`}
    - `NFS`贡献目录: `NFS`实际需要贡献出去的目录
    - 客户端地址: 客户端可以访问贡献目录的地址，可以为主机名、ip地址(网段)、通配符(*)
    - 
        |参数|作用|
        |-|-|
        |`ro`|只读|
        |`rw`|读写|
        |`root_squash`|当`NFS`客户端以root管理员访问时，映射为`NFS`服务器的匿名用户|
        |`no_root_squash`|当`NFS`客户端以root管理员访问时，映射为`NFS`服务器的root管理员|
        |`all_squash`|无论`NFS`客户端使用什么账户访问，均映射为`NFS`服务器的匿名用户|
        |`sync`|同时将数据写入到内存与硬盘中，保证不丢失数据|
        |`async`|优先将数据保存到内存，然后再写入硬盘；这样效率更高，但可能会丢失数据|
        |`insecure`|是客户端从大于1024的端口发送链接||

## 启动和检查本地共享情况 
```bash
$> systemctl restart nfs
$>  showmount -e 127.0.0.1
Export list for 127.0.0.1:
/nfsshare *

$> cat /var/lib/nfs/etab 
/nfsshare       *(rw,sync,wdelay,hide,nocrossmnt,insecure,root_squash,no_all_squash,no_subtree_check,secure_locks,acl,no_pnfs,anonuid=65534,anongid=65534,sec=sys,rw,insecure,root_squash,no_all_squash)
```

## nfs挂载 

```bash
$> mount.nfs 127.0.0.1:/nfsshare /mnt # 127.0.0.1:/nfshare /mnt nfs defaults 0 0  >> /etc/fstab
```


# autofs 自动挂载 使用systemd automount替代
```bash
# 创建systemd mount和automount节点，文件名命名规范:挂载到/mnt/other下,名字则必须为: mnt-other.mount 和 mnt-other.automount  
$> vim /etc/systemd/system/mnt-other.automount 
[Unit]
Documentation=man:fstab(5) man:systemd-fstab-generator(8)

[Mount]
Where=/mnt/other                # 本地挂载目录 
What=192.16.10.200:/nfsshare    # (远程)挂载点
Type=nfs                        # 挂载系统类型
Options=defaults                # 挂载参数


$> vim /etc/systemd/system/mnt-other.automount  
[Unit]
Documentation=man:fstab(5) man:systemd-fstab-generator(8)

[Automount]
Where=/mnt/other                # 本地挂载目录，同步mount单元的目录 
TimeoutIdleSec=12               # 超时时间，多少秒未操作自动卸载挂载点   

[Install]
WantedBy=multi-user.target

# 创建完成后重载配置
$> systemctl daemon-reload
# 激活 automount 并加入开机启动项
$> systemctl enable --now  mnt-other.automount

# 另：automount 在centos 7下可通过fstab配置默认参数noauto,x-systemd.automount 自动创建,创建于/run/systemd/generator/下，但该数据非持久化数据，需要手动复制到/etc/systemd/system下，并添加install节点，持久化数据后移除fstab配置即可  

```
