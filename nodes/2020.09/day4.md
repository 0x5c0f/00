# linux 定时任务 
## at 命令 
依赖于`atd`服务，适用于执行一次就结束的调度任务(很少使用，不做详细记录)  
```bash
# 语法 at now+1min 进入编辑台,ctrl+d 结束编辑 
HH:MM 
YYYY-mm-dd
noon 中午12点整 
midnight 晚上12(0)点整
teatime 下午4点整 
tomorrow 明天
now+1min  一分钟后 
now+1minutes/hours/days/weeks  一分钟/一小时/一天/一周 
```

## crontab 
- `crontab -e`实际上是编辑`/var/spool/cron/<user>`文件  

## 软件包管理 
- `rpm -qi sersync-2.5.4-1.x86_64.rpm`: 查询软件包的详细信息  

## !$ 
- `!$`：代表上一次执行的最后一个参数,同部分机器支持的`alt + .`、`esc + .`快捷键  