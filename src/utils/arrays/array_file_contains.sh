#!/bin/bash


# Script pour savoir si un tableau sous forme de
# fichier contient une valeur.


# Savoir si une valeur est contenue dans un tableau.
function get() {
	# Paramètres de fonction.
	local arrayFilePath="$1"
	local valueSearched="$2"

	# Recherche.
	while read value
	do
		# Si la valeur cherchée est trouvée.
		if [ "$value" == "$valueSearched" ]
		then
			# Retour.
			return 0
		fi
	done < "$arrayFilePath"

	# Retour d'erreur si valeur cherchée non trouvée.
	return 1
}


# Exécution.
if [ $# -eq 2 ]
then
	get "$1" "$2"
	exit $?
else
	echo "Chemin du tableau et/ou valeur cherchée non renseigné(s) !"
	exit 1
fi
