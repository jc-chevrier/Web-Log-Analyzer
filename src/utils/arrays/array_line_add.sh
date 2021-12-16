#!/bin/bash


# Script d'ajout d'une valeur dans un tableau sous
# forme de ligne.


# Ajouter une valeur dans un tableau.
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
	echo "Tableau et/ou séparateur et/ou valeur non resneigné(s) !"
	exit 1
fi
