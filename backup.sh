#!/bin/bash

IP_BDD="$(cat ./ip.conf | grep IP_BDD | cut -d '=' -f2)"
IP_ODOO="$(cat ./ip.conf | grep IP_ODOO | cut -d '=' -f2)"
IP_SAVE="$(cat ./ip.conf | grep IP_SAVE | cut -d '=' -f2)"
USER_PWD="$(cat ./myconf.conf | grep USER_PWD | cut -d '=' -f2)"
ROOT_PWD="$(cat ./myconf.conf | grep ROOT_PWD | cut -d '=' -f2)"


if [ -n "$1" ]; then
	ssh -i ./id_rsa user@$IP_BDD "echo \"$ROOT_PWD\" | su -c \" PGPASSWORD=user pg_dump -d $1 -U user -h localhost > /home/user/save/$1.sql\" "

	if [ -n "$(ssh -i ./id_rsa user@$IP_BDD "echo \"$ROOT_PWD\" | ls  /home/user/save/  | grep -x $1.sql")" ]; then
    		scp -i ./id_rsa user@$IP_BDD:/home/user/save/"$1".sql user@$IP_SAVE:/home/user/
  	else
    		echo "EREUR BASE DE DONNÉES NON PRÉSENTES "
  	fi

else
	echo "VOUS N'AVEZ PAS PRÉCISER DE NOM POUR LA BASE DE DONNÉE"
fi
