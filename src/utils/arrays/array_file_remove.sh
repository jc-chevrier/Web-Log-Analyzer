#!/bin/bash


# Script de suppression d'une valeur d'un tableau sous
# forme de fichier.


# Supprimer une valeur dans un tableau.
function remove() {
	# Paramètres de fonction.
	local arrayFilePath="$1"
	local indexSearched=$2

	# Modification.
	indexSearched=$((indexSearched + 1))
	sed -i "${indexSearched}d" "$arrayFilePath"

	# Retour.
	return $?
}


# Exécution.
if [ $# -eq 2 ]
then
	remove "$1" $2
	exit $?
else
	echo "Chemin du fichier du tableau et/ou indice cherché non resneigné(s) !"
	exit 1
fi
