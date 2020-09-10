# bash 特性
- 步长: `echo demo{01..10..2}`  

# bash 常用快捷键 
- `ctrl + a` 移动到行首  
- `ctrl + e` 移动到行尾  
- `ctrl + u` 删除光标之前的字符  
- `ctrl + k` 删除光标之后的字符  
- `ctrl + l` 清空屏幕终端内容(clear)  

# linux 正则表达式 

>[https://deerchao.cn/tutorials/regex/regex.htm](https://deerchao.cn/tutorials/regex/regex.htm)  

正则表达式的意义: 可以让`linux`管理员快速过滤、替换、处理所需要的字符串、文本，让工作更高效。  

## 基础正则 
- `BRE` 对应元字符有 `^`、`$`、`.`、`[]`、`*`  

|字符|作用|
|-|-|
|`^`|匹配以什么开头,如`^0x5c0f`，匹配以`0x5c0f`开头的行| 
|`$`|匹配以什么结尾,如`0x5c0f$`，匹配以`0x5c0f`结尾的行|
|`^$`|组合符，匹配空行|
|`.`|匹配任意一个且只有一个字符，不能匹配空行|
|`\`|转义符|
|`*`|匹配**前一个字符**连续出现`0`次或多次,重复`0`次代表空，即匹配所有内容|
|`.*`|组合符，匹配所有内容|
|`^.*`|组合符，匹配任意多个字符开头的内容|
|`.*$`|组合符，匹配一任意多个字符结尾的内容|
|`[abc]|[a-c]`|匹配`[]`内任意一个字符,`a`或`b`或`c`|
|`[^abc]`|匹配除`a`或`b`或`c`的其他字符|  



## 扩展正则
- `ERE` 对应的元字符除基础正则元字符外还包含`()`、`{}`、`?`、`+`、`|`  

|字符|作用|
|-|-|
|`+`|匹配前一个字符`1`次或多次|
|`[:/]+`|匹配`[]`内`:`、`/`一次或多次|
|`?`|匹配前一个字符`0`次或`1`次|
|`|`|表示或者，同时过滤多个字符串|
|`()`|分组过滤，被括起来的内容表示一个整体|
|`a{n,m}`|匹配前一个字符最少`n`,最多`m`次|
|`a{n,}`|匹配前一个字符最少`n`次|
|`a{n}`|匹配前一个字符恰好`n`次|
|`a{,m}`|匹配前一个字符最多`m`次| 
|`>`|代表单词右边结束,`grep -E "^(root|bin)\>" pwd.txt`|
|`<`|代表单词左边结束,`grep -E "\<[0-9]{3}\>" pwd.txt`,左右合并起来和`-w`效果一样|

## grep 命令 
- `-v`: 反选，排除匹配结果  
- `-n`: 显示匹配行与其行号 
- `-i`: 不区分大小写 
- `-c`: 只统计匹配的行数
- `-E`: `egrep`替代，扩展正则匹配
- `-w`: 只匹配过滤的单词  
- `-o`: 只输出匹配的内容 

### 分组之向后引用  
示例: 
```bash
$> cat demo.txt
I like my lover. 
I love my lover. 
He likes his lovers. 
He love his lovers. 

$>  grep -E "(l..e).*\1" 
I love my lover.
He love his lovers.

# 找出用户名和shell相同的用户 
$> grep -E "^([^:]+\>).*\1$" /etc/passwd 
``` 

# sed 命令 
`sed`工作流程(循环至结束): `读取行` -> `执行` -> `显示`   
`sed`使用的正则为基础正则  
选项参数:   
- `-n`: 取消默认输出  
- `-i`: 直接将修改结果写入文件  
- `-e`: 多次编辑(替换管道符)  
- `-r`: 支持正则扩展  

内置命令参数:  
- `a`: 文本追加，在指定行后面添加一行或多行数据  
- `d`: 删除匹配行数据
- `i`: 文本插入，在指定行前添加一行或多行数据  
- `p`: 打印匹配内容,通常与`p`和`-n`一起使用  
- `s/正则/替换内容/g`: 匹配并替换内容，`g`代表全局  

sed匹配范围: 
什么是空地址，单地址 ？

示例：  
```bash
# 匹配第二行和第三行 
$> sed '2,3p' /etc/passwd -n
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin

# 匹配第二行及向下三行 
$> sed '2,+3p' /etc/passwd -n
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync

# 匹配包含system的行 
$> sed -n '/system/p' /etc/passwd
systemd-timesync:x:101:101:systemd Time Synchronization,,,:/run/systemd:/usr/sbin/nologin
systemd-network:x:102:103:systemd Network Management,,,:/run/systemd:/usr/sbin/nologin
systemd-resolve:x:103:104:systemd Resolver,,,:/run/systemd:/usr/sbin/nologin 

# 删除包含root的行 
$> cat pwd.txt
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin

# 删除包含root的行 
$> sed -i '/root/d' pwd.txt
$> cat pwd.txt
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin

# 替换daemon为www，替换sys为apache 
$> sed -i -e 's/daemon/www/g' -e 's/sys/apache/g' pwd.txt
$> cat pwd.txt 
root:x:0:0:root:/root:/bin/bash
www:x:1:1:www:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
apache:x:3:3:apache:/dev:/usr/sbin/nologin

# 在第一行后追加两行数据  
$> sed -i '1a hello sed \nhello word' pwd.txt 
$> cat pwd.txt
root:x:0:0:root:/root:/bin/bash
hello sed
hello word
www:x:1:1:www:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
apache:x:3:3:apache:/dev:/usr/sbin/nologin

# 在每一行后面加上 ---- 
$> sed 'a -----' pwd.txt
root:x:0:0:root:/root:/bin/bash
-----
www:x:1:1:www:/usr/sbin:/usr/sbin/nologin
-----
hello sed
-----
hello word
-----
bin:x:2:2:bin:/bin:/usr/sbin/nologin
-----
apache:x:3:3:apache:/dev:/usr/sbin/nologin

# 获取系统ip 
$> ifconfig enp0s31f6|sed -ne '2s/^.*inet//' -ne '2s/net.*$//p'
$> ifconfig enp0s31f6|sed -ne 's/^.*inet//g' -ne 's/netm.*$//' -ne '2p'  

```