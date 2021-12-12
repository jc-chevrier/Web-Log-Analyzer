#!/bin/bash


# Script d'ajout d'un élément à un tableau sous
# forme de fichier.


# Ajouter un élément à un tableau.
function add() {
	# Paramètres de fonction.
	local arrayFilePath="$1"
	local value="$2"

	# Ajout.
	echo "$value" >> "$arrayFilePath"

	# Retour.
	return $?
}


# Esécution.
if [ $# -eq 2 ]
then
	add "$1" "$2"
	exit $?
else
	echo "Chemin du fichier du tableau et/ou élément non resneigné(s) !"
	exit 1
fi
