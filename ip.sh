#Recuperation des ip de base
IP_DEF_ODOO=$(vmiut info odoo | grep ip | cut -d '=' -f2)
IP_DEF_BDD=$(vmiut info bdd | grep ip | cut -d '=' -f2)
IP_DEF_SAVE=$(vmiut info save | grep ip | cut -d '=' -f2)


IP_ODOO=10.42.136.1
IP_BDD=10.42.136.2
IP_SAVE=10.42.136.3


if [ -z $IP_DEF_ODOO ];then
        IP_DEF_ODOO=$IP_ODOO
fi

if [ -z $IP_DEF_BDD ];then
        IP_DEF_BDD=$IP_BDD
fi

if [ -z $IP_DEF_SAVE ];then
        IP_DEF_SAVE=$IP_SAVE
fi


echo "IP_DEF_ODOO=$IP_DEF_ODOO" > ./ip.conf
echo "IP_DEF_BDD=$IP_DEF_BDD" >> ./ip.conf
echo "IP_DEF_SAVE=$IP_DEF_SAVE" >> ./ip.conf

echo "IP_ODOO=$IP_ODOO" >> ./ip.conf
echo "IP_BDD=$IP_BDD" >> ./ip.conf
echo "IP_SAVE=$IP_SAVE" >> ./ip.conf
