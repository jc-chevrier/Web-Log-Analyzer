#!/bin/bash


# Script de recherche d'une valeur dans un tableau
# sous forme de ligne.


# Obtenir une valeur d'un tableau.
function get() {
	# Paramètres de fonction.
	local arrayLine="$1"
	local separator="$2"
	local indexSearched=$3

	# Recherche.
	local oldIFS="$IFS"
	IFS="$separator"
	local index=0
	for value in $arrayLine
	do
		# Si l'indice cherché est trouvé.
		if [ $index -eq $indexSearched ]
		then
			# Envoi du résultat.
			echo "$value"
			# Retour.
			return 0
		fi
		# Incrémentation de l'indice.
		index=$((index + 1))
	done
	IFS="$oldIFS"

	# Retour d'erreur si indice cherché non trouvé.
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
