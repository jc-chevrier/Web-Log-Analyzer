#!/bin/bash


# Script de création d'un dossier.


# Créer un dossier.
function create() {
	directoryPath=$1

	if [ ! -d "$directoryPath" ]
	then
		mkdir "directoryPath"
                chown root:root "$directoryPath"
                chmod u=rwx,g=,o= "$directoryPath"
	fi

	return 0
}


# Exécution.
if [ $# -eq 1 ]
then
	create "$1"
	exit $?
else
	echo "Chemin de dossier à créer pas renseigné !"
	exit 1
fi
