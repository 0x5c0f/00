# 用户从浏览器打开网页的过程 
- DNS解析
    - 当将网页输入到浏览器会车后，浏览器会首先查询本地缓存和hosts文件，如果里面都没有这个域名的话，将会通过网卡配置的dns服务器(localdns)进行查找,如果localdns里面也查询不到这个域名服务器，localdns将会把这个请求发送到全球13台DNS根服务器(根服务器只管理顶级域名，又称为一级域名)进行查询
- TCP三次握手建立连接 
- HTTP请求报文处理 
    - 请求方法URI协议/版本
    - 请求头(Request Header)
    - 请求正文
- 网站内部数据(发送、接收)整理响应 
- HTTP响应报文处理
- TCP四次断开

# dnsmasq 搭建dns局域网 
```bash
$> yum install dnsmasq -y
# /etc/dnsmasq.conf   主配置文件 
# /etc/dnsmasq.hosts  自定义域名和ip对应关系(默认无,需创建)
# /etc/resolv.dnsmasq.conf dns上游服务器地址(默认无，需创建)

$> vi /etc/dnsmasq.conf 
# 指定dns上有服务器配置地址(默认/etc/resolv.conf) <格式: nameserver dnsip>
resolv-file=/etc/resolv.dnsmasq.conf
# 解析指定,顶级域名默认包含所有子域名  
address=/blog.cxd115.me/3.113.149.100
# 本地监听地址
listen-address=127.0.0.1
# 定义一个本地域名配置文件，需要自定义的一些域名解析记录 (语法格式: IP + 域名)
addn-hosts=/etc/dnsmasq.hosts
# 记录dns查询记录  
log-queries
```
