#!/bin/bash


# Script pour savoir si une table associative sous
# forme de fichier contient une clé.


# Savoir si la clé est contenue dans la table assciative.
function hasKey() {
	# Paramètres de fonction.
	mapFilePath=$1
	key=$2

	# Vérification.
	count=$(grep -c "$key" "$mapFilePath")
	test $count -eq 1

	# Retour.
	return $?
}


# Exécution.
if [ $# -eq 2 ]
then
	hasKey "$1" "$2"
	exit $?
else
	echo "Chemin de la table associative et/ou clé non renseigné(s) !"
	exit 1
fi
