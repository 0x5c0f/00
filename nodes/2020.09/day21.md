# LAMP  
## apache 安装 

```bash
$> mkdir /opt/softsrc 
$> useradd -u 1010 -d /var/ftproot -s /sbin/nologin www  
$> yum install gcc gcc-c++ expat-devel openldap-devel openssl-devel libnghttp2-devel libxml2-devel 

$> wget http://apache.mirrors.pair.com//apr/apr-1.7.0.tar.gz
$> tar -xzf apr-1.7.0.tar.gz && cd apr-1.7.0
$> ./configure --prefix=/opt/apr-1.7.0 
$> make -j4 && make  install
$> ln -s /opt/apr-1.7.0 /opt/apr

# 需要优先安装 libxml2-devel，不然这而不会报错，但后续http编译会报错 
$> wget http://mirrors.advancedhosters.com/apache//apr/apr-util-1.6.1.tar.gz
$> tar -xzf apr-util-1.6.1.tar.gz && cd apr-util-1.6.1 
$> ./configure --prefix=/opt/apr-util-1.6.1 --with-ldap --with-apr=/opt/apr/bin/apr-1-config
$> make -j4 && make  install
$> ln -s /opt/apr-util-1.6.1 /opt/apr-util 


$> wget https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz
$> tar -xzf pcre-8.44.tar.gz && cd pcre-8.44/
$> ./configure --prefix=/opt/pcre-8.44 
$> make -j4 && make  install
$> ln -s /opt/pcre-8.44 /opt/pcre

$> wget https://apache.cs.utah.edu//httpd/httpd-2.4.46.tar.gz
$> tar -xzf httpd-2.4.46.tar.gz && cd httpd-2.4.46 

# 修改apache版本相关信息 
# 第40-47行 
$> vim include/ap_release.h
######
#define AP_SERVER_BASEVENDOR "IIS"
#define AP_SERVER_BASEPROJECT "IIS HTTP Server"
#define AP_SERVER_BASEPRODUCT "IIS"

#define AP_SERVER_MAJORVERSION_NUMBER 7
#define AP_SERVER_MINORVERSION_NUMBER 0
#define AP_SERVER_PATCHLEVEL_NUMBER   0
#define AP_SERVER_DEVBUILD_BOOLEAN    0
######

# 35行 
$> vim os/unix/os.h 
#define PLATFORM "win32"

$> ./configure --prefix=/opt/httpd-2.4.46 \
--sysconfdir=/opt/httpd-2.4.46/config \
--with-pcre=/opt/pcre \
--with-apr=/opt/apr \
--with-apr-util=/opt/apr-util/ \
--enable-http2 \
--enable-so \
--enable-dav \
--enable-ssl \
--enable-cgi \
--enable-rewrite \
--enable-ldap \
--enable-authnz-ldap \
--with-zlib \
--enable-modules=all \
--enable-mpms-shared=all \
--with-mpm=event

# --sysconfdir=/opt/apache/etc      指定配置文件存放位置 
# --with-pcre=/opt/pcre             启用正则表达式
# --with-apr=/opt/apr               Apache可移植运行时(APR)是httpd源码的一部分并会自动与httpd一起创建。如果你想使用一个已经存在的APR ，就必须在这里指定apr-config脚本的路径。用于提升socket调用,在不使用apr的时候，一个线程同一时间只能处理一个用户,势必造成阻塞，因此生产环境一定需要配置 
# --with-apr-util=/opt/apr-util/    Apache可移植运行时工具包(APU)是httpd源码的一部分并会自动与httpd一起创建。如果你想使用一个已经存在的APU ，就必须在这里指定apu-config脚本的路径。
# --enable-http2                    启用http2支持
# --enable-so                       允许运行时加载DSO模块
# --enable-dav                      启用davweb支持
# --enable-ssl                      ssl/tls支持
# --enable-cgi                      cgi脚本支持
# --enable-rewrite                  重写支持
# --enable-ldap                     启用LDAP
# --enable-authnz-ldap              启用LDAP（需与--enable-ldap同时使用）
# --with-zlib                       支持zlib库
# --enable-modules=all              启用大多数常用模块
# --enable-mpms-shared=all          启用MPM支持的所有模式
# --with-mpm=event                  设置默认MPM为event

$> ln -s /opt/httpd-2.4.46 /opt/httpd 
$> cp /opt/httpd/bin/apachectl /etc/init.d/httpd
$> systemctl daemon-reload 
$> systemctl start httpd
```

## apache 工作模式 
 

