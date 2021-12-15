#!/bin/bash


# Script pour savoir la taille d'un tableau
# sous forme de ligne.


# Calculer la taille d'un tableau.
function count() {
	# Paramètres de fonction.
	local arrayFilePath="$1"
	local separator="$2"

	# Comptage.
	local oldIFS="$IFS"
	IFS="$separator"
	local count=0
	for value in $arrayFilePath
	do
		count=$((count + 1))
	done
	IFS="$oldIFS"

	# Envoi du résultat.
	echo $count

	return 0
}


# Exécution.
if [ $# -eq 2 ]
then
	count "$1" "$2"
	exit $?
else
	echo "Chemin du fichier du tableau et/ou séparateur non renseigné(s) !"
	exit 1
fi
