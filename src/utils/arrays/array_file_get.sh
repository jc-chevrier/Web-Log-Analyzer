#!/bin/bash

# Script de recherche de cellule dans un tableau
# sous forme de fichier.


# Chercher la cellule.
function search() {
	# Paramètres de fonction.
	arrayFilePath=$1
	indexSearched=$2

	# Recherche.
	index=0
	while read cell
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
	done < "$arrayFilePath"

	# Retour d'erreur si index non trouvé.
	return 1
}


# Exécution.
if [ $# -eq 2 ]
then
	search "$1" $2
	exit $?
else
	echo "Chemin du tableau et/ou index cherché non renseigné(s) !"
	exit 1
fi
