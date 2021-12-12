#!/bin/bash


# Script de suppression d'un élément d'un tableau sous
# forme de fichier.


# Supprimer un élément dans un tableau.
function remove() {
	# Paramètres de fonction.
	local arrayFilePath="$1"
	local index=$2

	# Modification.
	index=$((index + 1))
	sed -i "${index}d" "$arrayFilePath"

	# Retour.
	return $?
}


# Exécution.
if [ $# -eq 2 ]
then
	set "$1" $2
	exit $?
else
	echo "Chemin du fichier du tableau et/ou index non resneigné(s) !"
	exit 1
fi
