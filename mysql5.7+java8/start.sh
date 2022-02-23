#!/bin/bash
if [ -z "$MYSQL_ROOT_PASSWORD" ];then
 echo "MYSQL_ROOT_PASSWORD is empty"
 exit 0
fi
INIT_MYSQL(){
   echo -e "\033[1;32m mysql初始化 \033[0m"
   #新建mysql数据文件夹并提升权限
   echo -e "\033[1;32m ====新建mysql数据文件夹并提升权限==== \033[0m"
   mkdir -p /usr/local/mysql/data && chown -R mysql.mysql /usr/local/mysql
   #修改my.cnf配置
   echo -e "\033[1;32m 修改my.cnf配置 \033[0m"
   sed -i 's/datadir=\/var\/lib\/mysql/datadir=\/usr\/local\/mysql\/data/' /etc/my.cnf
   sed -i '/datadir/i character_set_server=utf8' /etc/my.cnf
   sed -i "/datadir/i init_connect='SET NAMES utf8'" /etc/my.cnf
   sed -i '/datadir/i default_password_lifetime=0' /etc/my.cnf

   #初始化数据库
   echo -e "\033[1;32m 初始化数据库 \033[0m"
   mysqld  --initialize --user=mysql --datadir=/usr/local/mysql/data
   #守护进程运行
   echo -e "\033[1;32m 守护进程运行 \033[0m"
   mysqld --daemonize --pid-file=/var/run/mysqld/mysqld.pid --user=mysql
   #获取随机生成的密码
   echo -e "\033[1;32m 获取随机生成的密码 \033[0m"
   dbPassword=`grep 'temporary password' /var/log/mysqld.log | awk '{print $11}'`
   echo -e "\033[1;32m 随机生成的密码为$dbPassword \033[0m"
   #修改数据库密码
   echo -e "\033[1;32m 修改数据库密码为$MYSQL_ROOT_PASSWORD \033[0m"
   mysqladmin -uroot -p$dbPassword password $MYSQL_ROOT_PASSWORD
   #设置远程登录
   echo -e "\033[1;32m 设置远程登录 \033[0m"
   mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root';flush privileges;";
   echo -e "\033[1;32m emote connection is set \033[0m"
   yum clear all
   rm -rf /usr/local/download
}
if [ `ls /usr/local/mysql/data |wc -l` -eq 0 ];then
  echo -e "\033[1;32m install \033[0m"
  INIT_MYSQL
else
  echo -e "\033[1;32m daemonize \033[0m"
  mysqld --daemonize --pid-file=/var/run/mysqld/mysqld.pid --user=mysql
fi
tail -f /var/log/mysqld.log