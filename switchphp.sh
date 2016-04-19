#!/bin/bash
php_fpms=($(locate -ir "/usr/local.*php-fpm$"| awk '{printf "%s ",$1}'))

i=0

for phpdir in ${php_fpms[@]};
do 
	echo $i")"$phpdir
	i=$((i+1))
done 

echo "请输入要切换的版本:"
read ver

case $ver in
	[0123])
		pid=($(pgrep php-fpm | awk '{printf "%s ", $1}'))
		pid=${pid[0]}

		if [ $pid ]; then
			kill -QUIT $pid
		fi

		php_opts=$(echo ${php_fpms[$ver]} | awk -F '/' '{printf "/%s/%s/%s/etc/php-fpm.conf",$2,$3,$4}')

		php_pid=$(echo ${php_fpms[$ver]} | awk -F '/' '{printf "/%s/%s/%s/var/run/php-fpm.pid",$2,$3,$4}')
		

		${php_fpms[$ver]} --daemonize --fpm-config $php_opts --pid $php_pid

		if [ "$?" != 0 ]; then
			echo "切换失败"
			exit 1
		fi
		echo "切换成功"

	;;

	*)
		echo "选择错误"
	;;
esac


