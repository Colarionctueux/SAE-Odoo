#!/bin/bash

USER_PWD="$(cat ./myconf.conf | grep USER_PWD | cut -d '=' -f2)"
ROOT_PWD="$(cat ./myconf.conf | grep ROOT_PWD | cut -d '=' -f2)"
ROOT_PWD="root"
USER_PWD="user"
network(){
	echo "JE RENTRE DANS LA METHODE"
	ROOT_PWD=$3
	cat ./network/interfaces | sed -e "s/@/$2/g" > ./network/inter
	scp -i ./id_rsa -o StrictHostKeyChecking=no ./network/inter user@$1:~
	ssh -i ./id_rsa -o StrictHostKeyChecking=no  user@$1 "echo \"$ROOT_PWD\" | su -c \"cat /home/user/inter > /etc/network/interfaces\""
}

#Creation des clés ssh
rm -f ./id_rsa*
ssh-keygen -t rsa -C clef-ssh-Illolas -f ./id_rsa -P ""

IP_DEF_ODOO=$(cat ./ip.conf | grep IP_DEF_ODOO | cut -d '=' -f2)
IP_ODOO=$(cat ./ip.conf | grep IP_ODOO | cut -d '=' -f2)

IP_DEF_BDD=$(cat ./ip.conf | grep IP_DEF_BDD | cut -d '=' -f2)
IP_BDD=$(cat ./ip.conf | grep IP_BDD | cut -d '=' -f2)

IP_DEF_SAVE=$(cat ./ip.conf | grep IP_DEF_SAVE | cut -d '=' -f2)
IP_SAVE=$(cat ./ip.conf | grep IP_SAVE | cut -d '=' -f2)


COMMAND="echo \"$ROOT_PWD\" | su -c \"/sbin/reboot\""
echo "COMMAND : $COMMAND"

#Attributions des address ip
##Odoo
echo "IP ODOO DEF : $IP_DEF_ODOO ET IP A METTRE $IP_ODOO"
echo "$USER_PWD" | ./sshpass.sh ssh-copy-id -i ./id_rsa -o StrictHostKeyChecking=no  user@$IP_DEF_ODOO
network $IP_DEF_ODOO $IP_ODOO $ROOT_PWD
ssh -i ./id_rsa -o StrictHostKeyChecking=no user@$IP_DEF_ODOO "$COMMAND"
sed -i -e "s/$IP_DEF_ODOO/$IP_ODOO/g" ./ip.conf

#Postgres
echo "IP BDD DEF : $IP_DEF_BDD ET IP A METTRE $IP_BDD"
echo "$USER_PWD" | ./sshpass.sh ssh-copy-id -i ./id_rsa -o StrictHostKeyChecking=no  user@$IP_DEF_BDD
network $IP_DEF_BDD $IP_BDD $ROOT_PWD
ssh -i ./id_rsa -o StrictHostKeyChecking=no user@$IP_DEF_BDD "$COMMAND"
sed -i -e "s/$IP_DEF_BDD/$IP_BDD/g" ./ip.conf

#Machine de sauvegarde
echo "IP SAVE DEF : $IP_DEF_SAVE ET IP A METTRE $IP_SAVE"
echo "$USER_PWD" | ./sshpass.sh ssh-copy-id -i ./id_rsa -o StrictHostKeyChecking=no  user@$IP_DEF_SAVE
network $IP_DEF_SAVE $IP_SAVE $ROOT_PWD
ssh -i ./id_rsa -o StrictHostKeyChecking=no user@$IP_DEF_SAVE "$COMMAND"
sed -i -e "s/$IP_DEF_SAVE/$IP_SAVE/g" ./ip.conf


