#!/bin/bash
# update by 2019-01-25 1269505840@qq.com
# version: 3.0 
# discript : 
#     备份源定义,格式(["key"]="value") key: 备份名称   value: 备份路径(文件、目录）或数据库名称 , 多个由空格隔开  
#            code_path   : 代码备份定义，每天备份一次
#            app_path    : 应用备份定义,每六月备份一次
#            config_path : 配置文件备份定义,每月备份一次
#            mysql_database: 数据库备份定义，每天备份一次
#     base_path     : 备份文件存放根路径
#     back_ignore   : 备份忽略配置文件，不存在自动创建并添加默认忽略内容( *.log *.bak *.back *-back *-bak log logs bak back temp tmp)
# 00 01 * * * /bin/bash /opt/sh/web.backup.sh >> /data/backup/backlogs.log 2>&1  
# yum install p7zip
# pip install awscli
# aws configure
#

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# debug all back ， Not allowed to modify
debug=0

# 加密密码 为空则不加密
encrypt=""

# mysql account
mysql_username=""
mysql_password=""
mysql_host=""

# base back path; must / end
base_path="/backup/" 

# 远程备份开关 0: ftp sync 1: aws sync 2: rsync
# 默认ftp 远程同步，开启时需配置ftp帐号信息
# 1 : aws 远程同步配置，开启时需配置aws相关信息
ISSync=2

# aws sync path,default: s3://${aws_storage}/${aws_path}
# aws_storage 存储桶名称
aws_storage=""
# aws_path 远程上传路径
aws_path=""

# ftp 帐号信息
ftp_host=""
ftp_port="21"
ftp_user=""
ftp_pass=""


# ignore config
back_ignore="${base_path}back_ignore.txt"

# current server ip (assume)
SERVER_IP="192.16.10.0"

# current back TIME
TIME=$(date +"%Y%m%d%H")

# filename  
FILENAME="${SERVER_IP}_${FILENAME}"

### source path config start (default app 2 month once,other every day) ###
declare -A code_path=(["www.html"]="/var/www/html")
declare -A app_path=(["app.log"]="/app/logs")
declare -A config_path=(["scripts"]="/server/scripts" ["rc.local"]="/etc/rc.d/rc.local" ["root.cron"]="/var/spool/cron/root")
declare -A mysql_database=()
### source path config stop ###

### target config start ###
codebak_path="${base_path}codeback"
dbback_path="${base_path}mysqlback"
appback_path="${base_path}appback"
configback_path="${base_path}configback"
### target config stop ###


file_Compress(){
  _source=$1
  _target=$2
  if [ -n "${encrypt}" ]; then
    echo "current back file ===>: ${_target}.7z"
    7za a -t7z -p${encrypt} ${_target}.7z ${_source} -xr@${back_ignore}
  else
    echo "current back file ===>: ${_target}.tgz"
    tar czf ${_target}.tgz --exclude-from=${back_ignore} ${_source}
  fi
}

code_back(){
  check_local_dir ${codebak_path}
  check_arrslen ${#code_path[@]}
  for key in ${!code_path[@]}; do
    file_Compress ${code_path[$key]} ${codebak_path}/${FILENAME}-${key}
    sleep 1
  done 
}

msyql_back(){
  check_local_dir ${dbback_path}
  check_arrslen ${#mysql_database[@]}
  for key in ${!mysql_database[@]}; do
     echo -e "current database backup >> : ${mysql_database[$key]} "
    /usr/bin/mysqldump -u${mysql_username} -p${mysql_password} -h${mysql_host} --single-transaction -R -E ${mysql_database[$key]} | gzip > ${dbback_path}/${FILENAME}-${key}.sql.gz
  done
}

app_back(){
  check_local_dir ${appback_path}
  check_arrslen ${#app_path[@]}
  res=$(expr $(date +"%m") % 2)
  if [ $res -eq 0 ] || [ ${debug} -eq 1 ];then
    day=$(date +"%d")
    if [ $day -eq 1 ] || [ ${debug} -eq 1 ]; then
      #every 6 month back
      for key in ${!app_path[@]}; do
        file_Compress ${app_path[$key]} ${appback_path}/${FILENAME}-${key} 
        sleep 1
      done  
    else
      echo -e "###  \033[31m The first day of the every month backup \033[0m  ###"
    fi
  else
   echo -e "###  \033[31m No backup this month \033[0m  ###" 
  fi
}

config_back(){
  check_local_dir ${configback_path}  
  check_arrslen ${#config_path[@]}
  day=$(date +"%d")
  if [ $day -eq 1 ] || [ ${debug} -eq 1 ]; then
    for key in ${!config_path[@]}; do
      #tar czf ${configback_path}/${FILENAME}-${key}.tgz --exclude-from=${back_ignore} ${config_path[$key]}
      file_Compress ${config_path[$key]} ${configback_path}/${FILENAME}-${key} 
      sleep 1
    done
  else
    echo -e "###  \033[31m The first day of the every month backup \033[0m  ###"
  fi
}


awscli_sync(){
  if [ "$aws_path" == "" ];then 
    echo "You need to configure the S3 upload path !"
  else
    for _dir in $(ls ${base_path}); do 
      file_path="${base_path}${_dir}"
      if [ -d ${file_path} ] ; then
        #cd ${file_path}
        for file in $(ls ${file_path}|grep ${FILENAME}); do
          ## awscli sync 
          echo "====>: awscli sync s3://${aws_storage}/${aws_path} "
          echo -e "$(md5sum ${file_path}/${file})\n" >> ${file_path}/README.md5sum 
          /bin/aws s3 cp ${file_path}/${file} s3://${aws_storage}/${aws_path}/${_dir}/
        done
        echo -e "====== ${FILENAME} end ======\n" >> ${file_path}/README.md5sum
        /bin/aws s3 cp ${file_path}/README.md5sum s3://${aws_storage}/${aws_path}/${_dir}/
      fi    
    done
  fi
}

FTP_TRANSFER(){
ftp -inv <<!!! >/tmp/FTPLOG.TXT
  open $ftp_host $ftp_port
  user ${ftp_user} ${ftp_pass}
  passive
  binary
  prompt
  cd $2
  put $1
  close
  bye
!!!
  if fgrep "$FTP_SUCCESS_MSG" /tmp/FTPLOG.TXT ; then
    echo -e "\033[40;34m ..............FTP OK!...$1 \033[0m"
    FTP_FLAG=1
  else
    echo -e "\033[40;31m ..............FTP Error!...$1 \033[0m"
    FTP_FLAG=0
  fi
}

ftp_sync(){
  if [ "$ftp_user" == "" ]; then
    echo "You need to configure the ftp account info !"
  else
    for _dir in $(ls ${base_path}); do 
      file_path="${base_path}${_dir}"
      if [ -d ${file_path} ] ; then
        #cd ${file_path}
        for file in $(ls ${file_path}|grep ${FILENAME}); do
          ##FTP  starting###
          echo "=======>: ${file_path}/${file}"
          echo -e "$(md5sum ${file_path}/${file})\n" >> ${file_path}/README.md5sum 
          FTP_TRANSFER "${file_path}/${file}" "${ftp_root_path}/${_dir}"
        done
        echo -e "====== ${FILENAME} end ======\n" >> ${file_path}/README.md5sum
        FTP_TRANSFER "${file_path}/README.md5sum" "${ftp_root_path}/${_dir}"
      fi
    done
  fi 
}

check_arrslen(){
  let len=$1
  if [ ${len} -eq 0 ];then
    echo -e "###  \033[31m No backup data defined \033[0m ###"
  fi
}


choose_fun(){
  case "$1" in
    "code_back")
      echo -e "###  \033[32m code back \033[0m  ###"
      code_back
    ;;
    "mysql_back") 
      echo -e "###  \033[32m mysql back \033[0m  ###"
      msyql_back
    ;;
    "app_back") 
      echo -e "###  \033[32m app back \033[0m  ###"
      app_back
    ;;
    "config_back") 
      echo -e "###  \033[32m config back \033[0m  ###"
      config_back
    ;;
    "awscli_sync") 
      echo -e "###  \033[32m aws sync s3://${aws_storage}/${aws_path} \033[0m  ###"
      awscli_sync
    ;;
    "ftp_sync") 
      echo -e "###  \033[32m ftp upload ${ftp_host} \033[0m  ###"
      ftp_sync
    ;;
    *) 
      echo "Usg : $0 (0|1) (code_back|msyql_back|app_back|config_back|awscli_sync|ftp_sync)"
      echo -e "\t 可选参数: "
      echo -e "\t\t (0|1) debug参数(默认: 0)，是否取消备份时间限制，应用程序每六月备份一次，配置文件每月备份一次"
      echo -e "\t\t code_back|mysql_back|... 可选参数，选择后进行单个备份，未选择备份所有已配置项目"
    ;;
  esac
}

check_local_dir(){
  local_dir=$1
  if [ ! -d ${local_dir} ];then
    mkdir ${local_dir} -p
  fi
}

default_conf(){
    if [ ! -f ${back_ignore} ];then
    dir_path=$(dirname ${back_ignore})
    if [ ! -d "${dir_path}" ]; then
       echo "create default backup dir: ${dir_path}"
       mkdir -p ${dir_path}
    fi
    echo "create default ignore : *.log *.bak *.back *-back *-bak log logs bak back temp tmp"
    echo -e "*.log\n*.bak\n*.back\n*-back\n*-bak\nlog\nlogs\nbak\nback\ntemp\ntmp" >> ${back_ignore}
  fi

  rpm -q p7zip >& /dev/null
  if [ $? -ne 0 ]; then
   echo -e "Adding encryption dependencies: p7zip\n"
   sleep 3
    yum install p7zip -y
  fi
    
}

main(){

  default_conf

  if [ ! -z "$1" ]; then
    if [ "$1" == "1" ]; then
      debug=1
      if [ ! -z "$2" ]; then
        choose_fun $2
        exit 0
      fi
      echo -e "### \033[31m debug, backup all info \033[0m ###"
    elif [ "$1" == "-h" ]; then
      choose_fun
      exit 0
    else
      if [ ! -z "$2" ]; then
        choose_fun $2
        exit 0
      elif [ "$2" == "-h" ]; then
        choose_fun
        exit 0
      else
        choose_fun $1
        exit 0
      fi
    fi
  fi

  echo -e "###  \033[32m code back \033[0m  ###"
  code_back
  sleep 1
  echo -e "###  \033[32m mysql back \033[0m  ###"
  msyql_back
  sleep 1
  echo -e "###  \033[32m app back \033[0m  ###"
  app_back
  sleep 1
  echo -e "###  \033[32m config back \033[0m  ###"
  config_back
  sleep 1
  echo -e "###  \033[32m Start remote sync \033[0m  ###"
  if [ "$ISSync" -eq "1" ]; then
    awscli_sync
  else
    ftp_sync 
  fi
}

echo "Backup start TIME >:"$(date +"%s")
main $1 $2
echo "Backup end TIME >:"$(date +"%s")

