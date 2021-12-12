#!/bin/bash

# Script de recherche de cellule dans un tableau
# sous forme de ligne.


# Obtenir une cellule.
function get() {
	# Paramètres.
	local arrayLine="$1"
	local separator="$2"
	local indexSearched=$3

	# Recherche.
	local oldIFS="$IFS"
	IFS="$separator"
	local index=0
	for cell in $arrayLine
	do
		# Si l'index est atteint.
		if [ $index -eq $indexSearched ]
		then
			# Envoi du résultat.
			echo "$cell"
			# Retour.
			return 0
		fi
		# Incrémentation de l'index.
		index=$((index + 1))
	done
	IFS="$oldIFS"

	# Retour d'erreur si index non trouvé.
	return 1
}


# Exécution.
if [ $# -eq 3 ]
then
	get "$1" "$2" $3
	exit $?
else
	echo "Tableau et/ou séparateur et/ou index cherché non renseigné(s) !"
	exit 1
fi
