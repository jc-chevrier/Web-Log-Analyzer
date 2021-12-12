#!/bin/bash


# Script de modification d'un élément d'un tableau sous
# forme de fichier.


# Modifier un élément dans un tableau.
function set() {
	# Paramètres de fonction.
	local arrayFilePath="$1"
	local index=$2
	local value="$3"

	# Modification.
	index=$((index + 1))
	sed -i -E "${index}s/.*/${value}/g" "$arrayFilePath"

	# Retour.
	return $?
}


# Exécution.
if [ $# -eq 3 ]
then
	set "$1" $2 "$3"
	exit $?
else
	echo "Chemin du fichier du tableau et/ou index et/ou valeur non resneigné(s) !"
	exit 1
fi
