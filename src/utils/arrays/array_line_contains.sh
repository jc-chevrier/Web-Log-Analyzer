#!/bin/bash


# Script pour savoir si un tableau sous forme de ligne
# contient une valeur.


# Savoir si une valeur contenue dans un tableau.
function contains() {
	# Paramètres de fonction.
	local arrayLine="$1"
	local separator="$2"
	local valueSearched="$3"

	# Recherche.
	local oldIFS="$IFS"
	IFS="$separator"
	for value in $arrayLine
	do
		# Si la valeur cherchée est trouvée.
		if [ "$value" == "$valueSearched" ]
		then
			# Retour.
			return 0
		fi
	done
	IFS="$oldIFS"

	# Retour d'erreur si valeur cherchée non trouvée.
	return 1
}


# Exécution.
if [ $# -eq 3 ]
then
	contains "$1" "$2" "$3"
	exit $?
else
	echo "Tableau et/ou séparateur et/ou valeur cherchée non renseigné(s) !"
	exit 1
fi
