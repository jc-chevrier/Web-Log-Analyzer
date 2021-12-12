#!/bin/bash


# Script pour savoir la taille d'un tableau
# sous forme de fichier.


# Calculer la taille d'un tableau.
function count() {
	# Paramètres de fonction.
	local arrayFilePath="$1"

	# Comptage.
	local count=$(wc -l "$arrayFilePath" | grep -o -E "^[0-9]+")

	# Envoi du résultat.
	echo $count

	return 0
}


# Exécution.
if [ $# -eq 1 ]
then
	count "$1"
	exit $?
else
	echo "Chemin du fichier du tableau non renseigné !"
	exit 1
fi
