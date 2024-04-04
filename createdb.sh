#!/bin/bash


IP_BDD="$(cat ./ip.conf | grep IP_BDD | cut -d '=' -f2)"
IP_ODOO="$(cat ./ip.conf | grep IP_ODOO | cut -d '=' -f2)"
IP_SAVE="$(cat ./ip.conf | grep IP_SAVE | cut -d '=' -f2)"
USER_PWD="$(cat ./myconf.conf | grep USER_PWD | cut -d '=' -f2)"
ROOT_PWD="$(cat ./myconf.conf | grep ROOT_PWD | cut -d '=' -f2)"

if [ -n "$1" ];then
	ssh -i ./id_rsa user@$IP_BDD "PGPASSWORD=user psql -U user -h localhost -c \"CREATE USER "$1" WITH PASSWORD 'test';\""
	ssh -i ./id_rsa user@$IP_ODOO "echo \"$ROOT_PWD\" | su -c \"docker exec odoo15 odoo -d $1 -i base \"" 1>/dev/null 2>&1 &
	if [ -n "ssh -i ./id_rsa user@$IP_BDD crontab -l" ];then

		ssh -i ./id_rsa user@$IP_BDD "crontab -l | { cat; echo '1 00 * * * pg_dump -d test -U user -h localhost > /home/user/save/$1.sql'; } | crontab -"

		ssh -i ./id_rsa user@$IP_BDD "crontab -l | { cat; echo '5 00 * * * scp /home/user/save/$1.sql user@$IP_SAVE:~'; } | crontab -"
	fi
else
	echo "IL MANQUE LE NOM DE LA DATABASE !! "
fi



