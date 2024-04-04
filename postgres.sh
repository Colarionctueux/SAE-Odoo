#!/bin/bash

IP_BDD=$(cat ./ip.conf | grep IP_DEF_BDD | cut -d '=' -f2)
IP_SAVE=$(cat ./ip.conf | grep IP_DEF_SAVE | cut -d '=' -f2)
USER_PWD="$(cat ./myconf.conf | grep USER_PWD | cut -d '=' -f2)"
ROOT_PWD="$(cat ./myconf.conf | grep ROOT_PWD | cut -d '=' -f2)"

ssh -i ./id_rsa user@$IP_BDD "echo \"$ROOT_PWD\" |su -c \"apt update -y && apt -y install docker-compose docker.io  postgresql-client\""

ssh -i ./id_rsa user@$IP_BDD "echo \"$ROOT_PWD\" |su -c \"mkdir /home/user/docker\""

ssh -i ./id_rsa user@$IP_BDD "echo \"$ROOT_PWD\" |su -c \"chmod 777 /home/user/docker\""
scp -i ./id_rsa ./docker-compose/postgres/docker-compose.yml user@$IP_BDD:~/docker


if [ -n "$(ssh -i ./id_rsa user@$IP_BDD "echo \"$ROOT_PWD\" | su -c \"docker container ls -a \" | grep docker_postgres_1")" ];then
	ssh -i ./id_rsa user@$IP_BDD "echo \"$ROOT_PWD\" | su -c 'docker container rm -f docker_postgres_1'"
fi

ssh -i ./id_rsa user@$IP_BDD "echo \"$ROOT_PWD\" |su -c \"cd /home/user/docker && docker-compose up -d \"" 2>./erreur
ssh -i ./id_rsa user@$IP_BDD "echo \"$ROOT_PWD\" |su -c \"mkdir /home/user/save && chmod 777 /home/user/save \""

