php redis 扩展, php 5.6 对应phpredis 5.0以下测试正常编译 

wget https://github.com/phpredis/phpredis/archive/4.3.0.tar.gz

/opt/php-server/bin/phpize

./configure --with-php-config=/opt/php-server/bin/php-config


extension=redis.so 




# php memcache 扩展

wget http://pecl.php.net/get/memcache-2.2.7.tgz
/opt/php-server/bin/phpize

yum install re2c

./configure --enable-memcache --with-php-config=/opt/php-server/bin/php-config --with-zlib-dir

extension=memcache.so

# memcache 管理工具
http://www.junopen.com/memadmin/