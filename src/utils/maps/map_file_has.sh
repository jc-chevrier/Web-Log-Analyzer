#!/bin/bash


# Script pour savoir si une table associative sous
# forme de fichier contient une clé.


# Savoir si une clé est contenue dans une table
# associative.
function has() {
	# Paramètres de fonction.
	local mapFilePath="$1"
	local separator="$2"
	local keySearched="$3"

	# Vérification.
	local count=$(grep -c "$keySearched$separator" "$mapFilePath")
	test $count -eq 1

	# Retour.
	return $?
}


# Exécution.
if [ $# -eq 3 ]
then
	has "$1" "$2" "$3"
	exit $?
else
	echo "Chemin de la table associative et/ou séparateur et/ou clé non renseigné(s) !"
	exit 1
fi
