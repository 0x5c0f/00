# linux 权限 

## linux 通配符
>[https://blog.cxd115.me/115/71.html](https://blog.cxd115.me/115/71.html)  

>[https://deerchao.cn/tutorials/regex/regex.htm](https://deerchao.cn/tutorials/regex/regex.htm)


## 输入输出重定向  

### 文件描述符    
|文件描述符|文件名|类型|硬件|
|-|-|-|-|
|`0`|`stdin`|标准输入文件|键盘|
|`1`|`stdout`|标准输出文件|显示器|
|`2`|`stderr`|标准错误输出文件|显示器|

### 标准重定向 
|类型|表现形式|
|-|-|
|标准输入重定向|`0<`或`<`|
|追加输入重定向|`0<<`或`<`|
|标准输出重定向|`1>`或`>`|
|标准输出追加重定向|`1>>`或`>>`|
|标准错误重定向|`2>`|
|标准错误追加重定向|`2>>`|
||`2>&1`|

## 特殊符号 {} 
- 备份示例: `cp /pathto/demo{,.bak} `  