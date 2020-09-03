# awk 格式化输出 
## 示例: 
```bash
$> awk -F: 'BEGIN{printf "%-25s\t%-25s\t%-25s\t\n","用户名","UID","GID"}NR==2,NR==5{printf "%-25s\t%-25s\t%-25s\n",$1,$3,$4}' pwd.txt 
用户名                       UID                       	 GID                      	
bin                      	1                        	1                        
daemon                   	2                        	2                        
adm                      	3                        	4                        
lp                       	4                        	7  
```

## awk 模式 

```bash
awk '
BEGIN { actions } 
/pattern/ { actions }
/pattern/ { actions }
……….
END { actions } 
' filenames 
```

## awk 正则 
```

```