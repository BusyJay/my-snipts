#!/bin/bash
# 用于重置MySQL密码
# 注意不可用于生产环境，具有潜在危险。
if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root!" 1>&2
	exit 1
fi
read -p "Please input username:" name
read -s -p "Please input new password:" pass
tmp_file=`mktemp`.sql
echo "UPDATE mysql.user SET Password=PASSWORD('$pass') WHERE User='$name';
FLUSH PRIVILEGES;" > $tmp_file
cat $tmp_file
echo 
kill -15 `pgrep mysqld`
mysqld_safe --init-file=$tmp_file &
ping -c 10 127.0.0.1 > /dev/null
kill -15 `pgrep mysqld`
rm $tmp_file

