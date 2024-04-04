#!/bin/bash


USER_PWD="$(cat ./myconf.conf | grep USER_PWD | cut -d '=' -f2)"
ROOT_PWD="$(cat ./myconf.conf | grep ROOT_PWD | cut -d '=' -f2)"
IP_ODOO=$(cat ./ip.conf | grep IP_DEF_ODOO | cut -d '=' -f2)

ssh -i ./id_rsa user@$IP_ODOO "echo \"$ROOT_PWD\" |su -c \"apt update -y && apt install -y docker-compose docker.io && mkdir /home/user/traefik &&  chmod 777 /home/user/traefik/\""

scp -i ./id_rsa ./docker-compose/traefik/docker-compose.yml user@$IP_ODOO:~/traefik


if [ -n "$(ssh  -i ./id_rsa user@$IP_ODOO "echo \"$ROOT_PWD\" | su -c \"docker container ls -a \" | grep traefik")" ];then
	ssh  -i ./id_rsa user@$IP_ODOO 'echo "$ROOT_PWD" | su -c "docker container rm -f traefik"'
fi

ssh  -i ./id_rsa user@$IP_ODOO "echo \"$ROOT_PWD\" |su -c \"cd /home/user/traefik && docker-compose up -d \""
