#!/bin/bash


# Script de suppression d'une valeur dans un tableau
# sous forme de ligne.


# Supprimer une valeur dans un tableau.
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
	test ! $indexSearched -eq 0
	local firstIndex=$?
	for value in $arrayLine
	do
		# Si l'indice cherché est trouvé.
		if [ $index -ne $indexSearched ]
		then
			if [ $index -eq $firstIndex ]
                        then
                                newArrayLine="$value"
                        else
                                newArrayLine="$newArrayLine$separator$value"
                        fi
		fi
		# Incrémentation de l'indice.
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
	echo "Tableau et/ou séparateur et/ou indice cherché non renseigné(s) !"
	exit 1
fi
