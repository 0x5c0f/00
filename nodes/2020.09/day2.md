# awk 命令  
- `-F`: 指定分割符 
- `-v`：修改一个内置变量或定义一个自定义变量 
- `-f`: 从脚本中读取`awk`命令

## 内置变量 
- `$n`: 分割后，第`n`列的字段   
- `$0`: 代表整行的数据  
- `FS`: 输入分割符，默认为空格  
- `OFS`: 输出分隔符，默认为空格 
- `NF`: 分割后，当前行一共多少个字段(`$NF`最后一列,`$(NF-1)`倒数第2列)  
- `NR`: 当前的行号 
- `FNR`: 各文件分别计数的行号 
- `RS`: 输入记录分割符(输入换行符)，指定输入时的换行符,默认为制表符 
- `ORS`: 输出记录分隔符(输出换行符)，输出时用指定符号代替换行符 
- `FILENAME`: 当前文件名 
- `ARGC`：命令行参数的个数
- `ARGV`: 数组，命令行参数的值 

## 分割符 
- `FS`: 输入分割符，命令处理参数使用`-F`指定分割符,或者使用变量形式修改
    - 示例: 
        ```bash
        $> awk -F ":" 'NR==12,NR==15{print NR,$1,$3}' pwd.txt 
        12 ftp 14
        13 nobody 65534
        14 systemd-coredump 999
        15 systemd-network 192
        $> awk -v FS=":" 'NR==12,NR==15{print NR,$1,$3}' pwd.txt 
        12 ftp 14
        13 nobody 65534
        14 systemd-coredump 999
        15 systemd-network 192
        ```
- `OFS`: 输出分割符，使用`OFS`变量进行修改 
    - 示例: 
        ```bash
        $> awk -F ":" -v OFS="--" 'NR==12,NR==15{print NR,$1,$3}' pwd.txt 
        12--ftp--14
        13--nobody--65534
        14--systemd-coredump--999
        15--systemd-network--192
        ```
## 示例  
```bash
# 打印范围 
$> awk -F: 'NR==12,NR==15{print NR,$1,$3}' pwd.txt 
12 ftp 14
13 nobody 65534
14 systemd-coredump 999
15 systemd-network 192

# 自定义变量 
awk -v param=n_user 'BEGIN{print "当前用户: " param}'
当前用户: n_user
$> param=$(whoami)
$> echo $param
cxd
$> awk -v param=$param 'BEGIN{print "当前用户: " param}'
当前用户: cxd


```