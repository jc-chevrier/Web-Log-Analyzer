#!/bin/bash


# Script de nettoyage d'un dossier.


# Nettoyer un dossier.
function clear() {
	# Paramètres.
	directoryPath=$1

	# Suppression des fichiers du dossier.
	if [ -d $directoryPath ]
	then
		rm $directoryPath/*
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
	echo "Chemin de dossier à nettoyer pas renseigné !"
	exit 1
fi
