#!/bin/bash

# Script de recherche de cellule dans un tableau
# sous forme de fichier.


# Obtenir une cellule.
function get() {
	# Paramètres de fonction.
	local arrayFilePath="$1"
	local indexSearched=$2

	# Recherche.
	local index=0
	while read element
	do
		# Si l'index est atteint.
		if [ $index -eq $indexSearched ]
		then
			# Envoi du résultat.
			echo "$element"
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
	get "$1" $2
	exit $?
else
	echo "Chemin du tableau et/ou index cherché non renseigné(s) !"
	exit 1
fi
