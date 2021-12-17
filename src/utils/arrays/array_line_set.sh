#!/bin/bash

# Script de modification d'une valeur dans un tableau
# sous forme de ligne.


# Modifier une valeur d'un tableau.
function set() {
	# Paramètres.
	local arrayLine="$1"
	local separator="$2"
	local indexSearched=$3
	local newValue="$4"

	# Recherche.
	local newArrayLine=""
	local oldIFS="$IFS"
	IFS="$separator"
	local index=0
	local found=1
	for value in $arrayLine
	do
		# Si l'indice cherché est trouvé.
		if [ $index -eq $indexSearched ]
		then
			found=0
			if [ $index -eq 0 ]
			then
				newArrayLine="$newValue"
			else
				newArrayLine="$newArrayLine$separator$newValue"
			fi
		else
                        if [ $index -eq 0 ]
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
	return $found
}


# Exécution.
if [ $# -eq 4 ]
then
	set "$1" "$2" $3 "$4"
	exit $?
else
	echo "Tableau et/ou séparateur et/ou indice cherché et/ou nouvelle valeur non renseigné(s) !"
	exit 1
fi
