# mysql 未系统学习过，通过yum直接安装的5.6版本，集群安装为单节点，以下为测试集群中单节点授权语句 

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'  Identified by "ih1dH8P9XuCMgTIY" WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1'  Identified by "ih1dH8P9XuCMgTIY" WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost'  Identified by "ih1dH8P9XuCMgTIY" WITH GRANT OPTION;


CREATE DATABASE `zbpsys` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
GRANT ALL PRIVILEGES ON zbpsys.* TO 'zbsys'@'10.0.2.%'  Identified by "Owzffj5gcdgalyMD";


CREATE DATABASE `jpress` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
GRANT ALL PRIVILEGES ON jpress.* TO 'jpress'@'10.0.2.%'  Identified by "42uWelnesCzF16rxxAIjKHdAncc";