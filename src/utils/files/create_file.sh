#!/bin/bash


# Script de création d'un fichier.


# Créer un fichier.
function create() {
	filePath=$1

	if [ ! -f "$filePath" ]
	then
		touch "$filePath"
                chown root:root "$filePath"
                chmod u=rw,g=,o= "$filePath"
	fi

	return 0
}


# Exécution.
if [ $# -eq 1 ]
then
	create "$1"
	exit $?
else
	echo "Chemin de fichier à créer pas renseigné !"
	exit 1
fi
