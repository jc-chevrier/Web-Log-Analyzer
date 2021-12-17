#!/bin/bash


# Script d'ajout d'une valeur dans un tableau sous
# forme de fichier.


# Ajouter une valeur dans un tableau.
function add() {
	# Paramètres de fonction.
	local arrayFilePath="$1"
	local value="$2"

	# Ajout.
	echo "$value" >> "$arrayFilePath"

	# Retour.
	return $?
}


# Exécution.
if [ $# -eq 2 ]
then
	add "$1" "$2"
	exit $?
else
	echo "Chemin du fichier du tableau et/ou valeur non renseigné(s) !"
	exit 1
fi
