#!/bin/bash


# Script pour savoir la taille d'une table assoctative
# sous forme de fichier.


# Calculer la taille d'une table associative.
function count() {
	# Paramètres de fonction.
	local mapFilePath="$1"

	# Comptage.
	local count=$(wc -l "$mapFilePath" | grep -o -E "^[0-9]+")

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
	echo "Chemin du fichier de la table associative non renseigné !"
	exit 1
fi
