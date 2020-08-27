# linux 文件管理命令 

# cut 命令
 - `-c`：仅显示行中指定范围的字符串；
 - `-d`：指定字段的分隔符，默认的字段分隔符为“TAB”,需配合`-f`使用；
 - `-f`：显示指定字段的内容；
 - `-b`：仅显示行中指定直接范围的字节；
 - `-n`：与`-b`选项连用，不分割多字节字符；

## 示例1

```bash
$> cat demo
这是一个测试数据 
this is a test data

# 截取第1-3个字符
$> cut -c 1-3 demo 
这是一
thi

# 截取前4个字符 
$> cut -c -4 demo 
这是一个
this

# 截取从第4个字符到末尾
$> cut -c 4- demo
个测试数据 
s is a test data

# 截取第2个和第4个字符
$> cut -c 2,4 demo 
是个
hs
```

# 示例2
```bash
# 截取/etc/passwd，以:分割 
# 获取第2-5列的数据(2 =< [value] < 5) 
$>  cut -d : -f 2-5 /etc/passwd 
x:0:0:root
x:1:1:bin
x:2:2:daemon
x:3:4:adm
......

# 获取第5列之后的数据(5 =< [value] )
$> cut -d ":" -f 5- /etc/passwd
root:/root:/bin/bash
bin:/bin:/sbin/nologin
daemon:/sbin:/sbin/nologin
adm:/var/adm:/sbin/nologin
......

# 获取第一列到第五列的数据
$>  cut -d : -f -5 /etc/passwd
root:x:0:0:root
bin:x:1:1:bin
daemon:x:2:2:daemon
adm:x:3:4:adm
......

```

# soft 命令  

 - `-b,--ignore-leading-blanks`	忽略每行前面开始出的空格字符
 - `-d,--dictionary-order`	只考虑空白区域和字母字符
 - `-n`：对文件的第一个字符进行排序，依照数值的大小(小到大)排序  
 - `-f,--ignore-case`		忽略字母大小写
 - `-r`：以相反的顺序来排序；  
 - `-t`：指定排序时所用的栏位分隔字符  
 - `-k`：指定区域排序(一般配合`-t`分割)  
 - `-u`: 对排序结果去重,第一个字符，从小到大

# uniq 命令 
 - `-c`: 在每列旁边显示该行重复出现的次数  
 - `-u`: 只输出不重复（内容唯一）的行  
 - `-d`: 仅显示重复出现的行列  

# tr 命令 tr [选项] [字符一] [字符二]
 - `-c`：替换所有不属于第一字符集的字符为第二字符；
 - `-d`：删除所有属于第一字符集的字符；
 - `-s`：把连续重复的字符以单独一个字符表示；

示例: 
```bash
# 去除重复字符  
$> echo "zzzzeroooo" |tr -s 'zo'

# 删除匹配字符 
$> echo "test 0123 gg"|tr -d '1-9'

# 替换非第一字符的字符为第二字符 
$> echo "hello 0x "|tr -c 'x' 'c'
```

# find 命令 
## 忽略示例 
```bash
# 查询非/home/<user>目录下非 /home/<user>/Videos目录中大于100M的文件  
# -path 指定值需要与path同类型路径(相对或绝对)  
$> find /home/<user>/ -path "/home/<user>/Videos" -prune -o -size +100M -a -type f -print
```

# readlink 命令
- `readlink /pathto >& /dev/null && ehco ok || echo no`  # 判断文件或目录是否为链接属性  

