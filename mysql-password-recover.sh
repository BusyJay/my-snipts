#!/bin/bash
# 用于重置MySQL密码
# 注意不可用于生产环境，具有潜在危险。
if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root!" 1>&2
	exit 1
fi
if [[ `pgrep mysqld` != "" ]]; then
	echo "Mysqld is running, please turn it off." 1>&2
	exit 1
fi
name=
pass=
while [[ "$name" == "" ]]; do
	read -p "Please input username: " name
done
while [[ "$pass" == "" ]]; do
	read -s -p "Please input new password: " first_pass
	echo
	read -s -p "Please input your new password again: " second_pass
	echo 
	if [[ "$first_pass" == "$second_pass" ]]; then
		pass="$first_pass"
	else
		echo "Two passwords do not match each other!" 1>&2
	fi
done
tmp_file=/tmp/.please_delete_me.sql
echo "UPDATE mysql.user SET Password=PASSWORD('$pass') WHERE User='$name';
FLUSH PRIVILEGES;" > $tmp_file
echo 
ping -c 2 127.0.0.1 > /dev/null
mysqld_safe --init-file=$tmp_file & > /dev/null
ping -c 10 127.0.0.1 > /dev/null
kill -10 `pgrep mysqld` 2> /dev/null
rm $tmp_file
