#!/bin/bash

# Script de recherche d'un élément dans un tableau
# sous forme de ligne.


# Obtenir un élément d'un tableau.
function remove() {
	# Paramètres.
	local arrayLine="$1"
	local separator="$2"
	local indexSearched=$3

	# Recherche.
	local newArrayLine=""
	local oldIFS="$IFS"
	IFS="$separator"
	local index=0
	for value in $arrayLine
	do
		# Si l'index est atteint.
		if [ $index -ne $indexSearched ]
		then
			newArrayLine="$value$separator$newArrayLine"
		fi
		# Incrémentation de l'index.
		index=$((index + 1))
	done
	IFS="$oldIFS"

	# Envoi du résultat.
	echo "$newArrayLine"

	# Retour.
	return 0
}


# Exécution.
if [ $# -eq 3 ]
then
	remove "$1" "$2" $3
	exit $?
else
	echo "Tableau et/ou séparateur et/ou index cherché non renseigné(s) !"
	exit 1
fi
