#!/bin/bash

VALIDE=("15" "16" "17")

read -p "Veuillez saisir une valeur : " VERSION

if [[ " ${VALIDE[@]} " =~ " $VERSION " ]]; then
    echo "La valeur saisie est autorisée : $VERSION"
else
    echo "La valeur saisie n'est pas autorisée, la valeur par défaut 'latest' sera utilisée."
    VERSION="latest"
fi

IP_ODOO=$(cat ./ip.conf | grep IP_DEF_ODOO | cut -d '=' -f2)
IP_BDD=$(cat ./ip.conf | grep IP_DEF_BDD | cut -d '=' -f2)
USER_PWD="$(cat ./myconf.conf | grep USER_PWD | cut -d '=' -f2)"
ROOT_PWD="$(cat ./myconf.conf | grep ROOT_PWD | cut -d '=' -f2)"

ssh -i ./id_rsa user@$IP_ODOO "echo \"$ROOT_PWD\" |su -c \"apt update -y && apt install -y docker-compose docker.io\""

ssh -i ./id_rsa user@$IP_ODOO "echo \"$ROOT_PWD\" |su -c \"mkdir /home/user/docker\""

ssh -i ./id_rsa user@$IP_ODOO "echo \"$ROOT_PWD\" |su -c \"chmod 777 /home/user/docker/\""
scp -i ./id_rsa ./docker-compose/odoo/docker-compose.yml user@$IP_ODOO:~/docker
ssh -i ./id_rsa user@$IP_ODOO "echo \"$ROOT_PWD\" |su -c \"sed  -i -e \"s/@/"$VERSION"/g\" /home/user/docker/docker-compose.yml\""

#Fichier de conf
ssh -i ./id_rsa user@$IP_ODOO "echo \"$ROOT_PWD\" |su -c \"mkdir /home/user/config/\""
ssh -i ./id_rsa user@$IP_ODOO "echo \"$ROOT_PWD\" |su -c \"chmod 777 /home/user/config/\""
scp -i ./id_rsa ./odoo.conf user@$IP_ODOO:~/config
ssh -i ./id_rsa user@$IP_ODOO "echo \"$ROOT_PWD\" |su -c \"sed  -i -e \"s/@/"$IP_BDD"/g\" /home/user/config/odoo.conf\""

echo "FICHIER FINI"


if [ -n "$(ssh  -i ./id_rsa user@$IP_ODOO "echo \"$ROOT_PWD\" | su -c \"docker container ls -a \" | grep odoo15")" ];then
	ssh  -i ./id_rsa user@$IP_ODOO "echo \"$ROOT_PWD\" | su -c \"docker container rm -f odoo15\""
fi


ssh  -i ./id_rsa user@$IP_ODOO "echo \"$ROOT_PWD\" |su -c \"cd /home/user/docker && docker-compose up -d \""

./createdb.sh test
