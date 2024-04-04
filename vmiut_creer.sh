#!/bin/bash

#Suppression des machines
vmiut supprimer odoo
vmiut rm bdd
vmiut supprimer save

#Creation des machines
vmiut creer odoo
vmiut creer bdd
vmiut creer save

#Demarrage des amchines
vmiut demarrer odoo
vmiut demarrer bdd
vmiut demarrer save



sleep 20
./ip.sh
