# Documentation SAÉ 4.01 Réseau

> Auteurs: Illies Douhab, Nicolas Eckman

## Utilisation 


## Fonctionnement du code

### vmiut_creer.sh
Ce script permet de supprimer les machines existantes, en creer de nouvelles et les démarrent.

### ip.sh
Ce script permet de récuprer les adresses ip données par défaut aux machines et les inscrits dans le fichier ip.conf.

### ssh_ip.sh
Ce scripst permet de générer une clé privée (id_rsa) et une clé publique (id_rsa.pub). Il donne ensuite la clé publique aux machines grace à ssh-copy-id. Le script va ensuite changer les adresses ip des machines.

### postgres.sh
Ce script va copier le fichier docker-compose.yml correspondant à postgres dans la machine dédiée. Il va ensuite mettre à jour ses paquets puis installer docker-compose et docker.io. Enfin il va démarrer le conteneur grace au fichier, docker-compose, importé précédemment. Si un conteneur existe déjà il sera arrêté et supprimé. Un volume est créé pour les données de la base de données (dans le /home/user/bdd). Pour finir, une sauvegarde automatique est effectuée tous les jours à 00H00 et les données de la base sont exportées vers la machine save.

### odoo.sh
Ce script va copier le fichier docker-compose.yml correspondant à odoo dans la machine dédiée. Il va aussi copier le fichier odoo.conf dans un dossier config. Il va ensuite mettre à jour ses paquets puis installe docker-compose et docker.io. Enfin il va démarrer le conteneur grace au fichier, docker-compose, importé précédemment. Si un conteneur existe déjà il sera arrêté et supprimé.
Dans le fichier odoo.conf il est possible de modifier le mot de passe administrateur qui sera utilisé pour toute action sur les bases de données. Vous le trouverez sur la ligne
```bash
admin_passwd = password
```

### traefik.sh
Ce script va copier le fichier docker-compose.yml correspondant à traefik dans la machine odoo. Étant donné que les paquets sont déjà installés, le conteneur va simplement se lancer avec le docker-compose. Si un conteneur existe déjà il sera arrêté et supprimé.

### Modification des adresses ip
Si vous souhaitez modifier les adresses ip des machines, vous devez vous rendre dans le fichier ip.sh et modifier les lignes
```bash
IP_ODOO=[votre ip]
IP_BDD=[votre ip]
IP_SAVE=[votre ip]
```

### createdb.sh
Ce script permet la création d'une base de données dans postgres, cette base sera initialisée par le script et utilisable directement utilisable dans l'application Odoo. Pour l'utiliser il suffit d'appeler le script et de mettre en paramètre le nom de la base de données.
```bash
./createdb.sh [nom base de donnée]
```

### sshpass.sh 
Ce script permet d'entrer son mot de passe directement dans la ligne de commande.
```bash
echo "[mot de passe]" | ./sshpass.sh ssh user@[ip]
echo "[mot de passe]" | ./sshpass.sh scp user@[ip]
```

