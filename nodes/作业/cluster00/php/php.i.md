php redis 扩展, php 5.6 对应phpredis 5.0以下测试正常编译 

wget https://github.com/phpredis/phpredis/archive/4.3.0.tar.gz

/opt/php-server/bin/phpize

./configure --with-php-config=/opt/php-server/bin/php-config


extension=redis.so 
