#!/bin/bash


# Script d'ajout d'un élément à un tableau sous
# forme de fichier.


# Ajouter un élément à un tableau.
function add() {
	# Paramètres de fonction.
	local arrayLine="$1"
	local separator="$2"
	local value="$3"

	# Ajout.
	if [ -z "$arrayLine" ]
	then
		echo "$value"
	else
		echo "$arrayLine$separator$value"
	fi

	# Retour.
	return $?
}


# Exécution.
if [ $# -eq 3 ]
then
	add "$1" "$2" "$3"
	exit $?
else
	echo "Chemin du fichier du tableau et/ou élément non resneigné(s) !"
	exit 1
fi
