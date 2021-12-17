#!/bin/bash

# Script de recherche d'une valeur dans un tableau
# sous forme de fichier.


# Obtenir une valeur d'un tableau.
function get() {
	# Paramètres de fonction.
	local arrayFilePath="$1"
	local indexSearched=$2

	# Recherche.
	local index=0
	while read value
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
	done < "$arrayFilePath"

	# Retour d'erreur si indice cherché non trouvé.
	return 1
}


# Exécution.
if [ $# -eq 2 ]
then
	get "$1" $2
	exit $?
else
	echo "Chemin du tableau et/ou indice cherché non renseigné(s) !"
	exit 1
fi
