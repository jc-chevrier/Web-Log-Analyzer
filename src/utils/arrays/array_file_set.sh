#!/bin/bash


# Script de modification d'une valeur d'un tableau sous
# forme de fichier.


# Modifier une valeur dans un tableau.
function set() {
	# Paramètres de fonction.
	local arrayFilePath="$1"
	local indexSearched=$2
	local newValue="$3"

	# Modification.
	indexSearched=$((indexSearched + 1))
	sed -i -E "${indexSearched}s/.*/${newValue}/g" "$arrayFilePath"

	# Retour.
	return $?
}


# Exécution.
if [ $# -eq 3 ]
then
	set "$1" $2 "$3"
	exit $?
else
	echo "Chemin du fichier du tableau et/ou indice et/ou nouvelle valeur non renseigné(s) !"
	exit 1
fi
