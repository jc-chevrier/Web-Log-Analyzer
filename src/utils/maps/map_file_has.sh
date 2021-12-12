#!/bin/bash


# Script pour savoir si une table associative sous
# forme de fichier contient une clé.


# Savoir si une clé est contenue dans une table
# associative.
function has() {
	# Paramètres de fonction.
	local mapFilePath="$1"
	local key="$2"

	# Vérification.
	local count=$(grep -c "$key" "$mapFilePath")
	test $count -eq 1

	# Retour.
	return $?
}


# Exécution.
if [ $# -eq 2 ]
then
	has "$1" "$2"
	exit $?
else
	echo "Chemin de la table associative et/ou clé non renseigné(s) !"
	exit 1
fi
