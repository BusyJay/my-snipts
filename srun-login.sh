#!/bin/bash
#author: jay
#srun3000登录脚本，出于安全考虑，去掉了登录路径。
LOGDIR=`pwd` # 事实上这个设定为一个固定的目录会比较好。
REQUESTURI=PLEASE_FILL_THE_LOGIN_LINK_HERE
result=`which wget 2> /dev/null`
if [ -z $result ]; then
	result=`which curl 2> /dev/null`
	if [ -z $result ]; then
		echo "Fail, it seems that you don't have wget or curl installed!" >2
		exit
	else
		REQUESTTOOLS="curl -s -o $LOGDIR/srun.log $REQUESTURI -X POST -d "
	fi
else
	REQUESTTOOLS="wget -q -O $LOGDIR/srun.log $REQUESTURI --post-data="
fi
read -p "Your name: " name
pass=$(read -s -p "Your pass: " pass && echo -n $pass | md5sum -b - | cut -c9-24)
echo
if `$REQUESTTOOLS"username=$name&password=$pass&drop=0&type=1&n=100"`; then
	result=$(cat $LOGDIR/srun.log)
	if [ $result -gt 0 ] 2>/dev/null; then
		echo "Succeed! You are online now." 
	else
		echo "Error: $result" 
	fi
else
	echo "Failed! Couldn't build the connection!"
fi
