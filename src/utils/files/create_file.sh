#!/bin/bash


# Script de création d'un fichier.


# Créer un fichier.
function create() {
	# Paramètres de fonction.
	local filePath="$1"

	# Si le fichier n'existe pas.
	if [ ! -f "$filePath" ]
	then
		touch "$filePath"
                chown root:root "$filePath"
                chmod u=rw,g=,o= "$filePath"
	fi

	# Retour.
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
