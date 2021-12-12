#!/bin/bash

# Script de recherche de cellule dans un tableau
# sous forme de ligne.


# Chercher la cellule.
function search() {
	# Paramètres.
	arrayLine=$1
	separator=$2
	indexSearched=$3

	# Recherche.
	oldIFS=$IFS
	IFS=$separator
	index=0
	for cell in $arrayLine
	do
		# Si l'index est atteint.
		if [ $index -eq $indexSearched ]
		then
			# Envoi du résultat.
			echo $cell
			# Retour.
			return 0
		fi
		# Incrémentation de l'index.
		index=$((index + 1))
	done
	IFS=$oldIFS

	# Retour d'erreur si index non trouvé.
	return 1
}


# Exécution.
if [ $# -eq 3 ]
then
	search "$1" "$2" $3
	exit $?
else
	echo "Tableau et/ou séparateur et/ou index cherché non renseigné(s) !"
	exit 1
fi
