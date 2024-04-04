#!/bin/bash

echo "Merci d'utiliser notre programme de fidelité :)"

echo "Veuillez entrez le mot de passe utilisateur :"
read USER_PWD

echo "Veuillez entrer le mot de passe super utilisateur (root) :"
read ROOT_PWD

echo "USER_PWD=$USER_PWD" > myconf.conf
echo "ROOT_PWD=$ROOT_PWD" >> myconf.conf

liste=("creer vm" "modifier les adresses" "installer postgres" "installer odoo" "installer traefik" "creer une base de données" "faire une backup" "restaurer un backup" "EXIT")

select choix in "${liste[@]}"
do
	case $choix in
	"creer vm")
		./vmiut_creer.sh ;;
	"modifier les adresses")
		./ssh_ip.sh ;;
	"installer postgres")
		./postgres.sh ;;
	"installer odoo")
		./odoo.sh ;;
	"installer traefik")
		./traefik.sh ;;
	"creer une base de données")
		echo "Entrer le nom de votre base"
		read DB_NAME
		./createdb.sh "$DB_NAME";;
	"faire une backup")
		echo "Entrer le nom de la base a sauvegarder"
		read DB_NAME
		./backup.sh $DB_NAME;;
	"restaurer un backup")
		echo "Entrer le nom de la base a sauvegarder"
                read DB_NAME
		./recup_backup.sh $DB_NAME;;
	"EXIT")
		break
	esac
done

echo "USER_PWD=" > myconf.conf
echo "ROOT_PWD=" >> myconf.conf
