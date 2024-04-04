#!/bin/bash

IP_BDD="$(cat ./ip.conf | grep IP_BDD | cut -d '=' -f2)"
IP_ODOO="$(cat ./ip.conf | grep IP_ODOO | cut -d '=' -f2)"
IP_SAVE="$(cat ./ip.conf | grep IP_SAVE | cut -d '=' -f2)"
USER_PWD="$(cat ./myconf.conf | grep USER_PWD | cut -d '=' -f2)"
ROOT_PWD="$(cat ./myconf.conf | grep ROOT_PWD | cut -d '=' -f2)"


if [ -n "$1" ]; then
 	echo "test :"
	if [ -n "$(ssh -i ./id_rsa user@$IP_SAVE "echo \"$ROOT_PWD\" | ls  /home/user/  | grep -x $1.sql")" ]; then
		ssh -i ./id_rsa user@$IP_BDD "rm -f /home/user/save/$1.sql"
    		scp -i ./id_rsa user@$IP_SAVE:/home/user/"$1".sql   user@$IP_BDD:/home/user/save/
		ssh -i ./id_rsa user@$IP_BDD "PGPASSWORD=user psql -d $1 -f /home/user/save/$1.sql -h localhost -U user"
  	else
    		echo "EREUR BASE DE DONNÉES NON PRÉSENTES "
  	fi
fi
