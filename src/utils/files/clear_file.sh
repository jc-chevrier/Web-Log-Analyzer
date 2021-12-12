#!/bin/bash


# Script de nettoyage d'un fichier.


# Constantes et scripts appelés.
CREATE_FILE_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/file/create_file.sh"


# Nettoyer un fichier.
function clear() {
	# Paramètres.
	filePath=$1

	# Suppression du fichier.
	if [ -f $filePath ]
	then
		rm $filePath
	fi

	# Création d'un fichier.
	"$CREATE_FILE_SCRIPT_PATH" "$filePath"

	# Retour.
	return $?
}


# Exécution.
if [ $# -eq 1 ]
then
	create "$1"
	exit $?
else
	echo "Chemin de fichier à nettoyer pas renseigné !"
	exit 1
fi
