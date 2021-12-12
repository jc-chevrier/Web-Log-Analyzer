#!/bin/bash


# Script de nettoyage d'un dossier.


# Nettoyer un dossier.
function clear() {
	# Paramètres.
	local directoryPath=$1

	# Si le dossier existe.
	if [ -d $directoryPath ]
	then
		# Suppression des fichiers du dossier.
		rm $directoryPath/*
	fi

	# Retour.
	return 0
}


# Exécution.
if [ $# -eq 1 ]
then
	clear "$1"
	exit $?
else
	echo "Chemin de dossier à nettoyer pas renseigné !"
	exit 1
fi
