#!/bin/bash


# Script de nettoyage d'un fichier.


# Scripts externes.
CREATE_FILE_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/files/create_file.sh"


# Nettoyer un fichier.
function clear() {
	# Paramètres de fonction.
	local filePath="$1"

	# Si le fichier existe.
	if [ -f "$filePath" ]
	then
		# Suppression du fichier.
		rm "$filePath"
	fi

	# Création d'un fichier.
	"$CREATE_FILE_SCRIPT_PATH" "$filePath"

	# Retour.
	return $?
}


# Exécution.
if [ $# -eq 1 ]
then
	clear "$1"
	exit $?
else
	echo "Chemin de fichier à nettoyer pas renseigné !"
	exit 1
fi
