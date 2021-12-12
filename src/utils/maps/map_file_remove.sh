#!/bin/bash


# Script de suppression d'un couple clé-valeur dans une
# table associative.


# Scripts externes.
MAP_FILE_HAS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/maps/map_file_has.sh"


# Supprimer un couple clé-valeur d'une table associative.
function remove() {
	# Paramètres de fonction.
	local mapFilePath=$1
	local key=$2

	# Si la clé existe.
	"$MAP_FILE_HAS_SCRIPT_PATH" "$mapFilePath" "$key"
	if [ $? -eq 0 ]
	then
		# Suppression de la ligne de la clé.
		sed -i -E "/^${key}.+$/d" "$mapFilePath"
		# Retour.
		return 0
	else
		# Retour d'erreur.
		return 1
	fi
}


# Exécution.
if [ $# -eq 2 ]
then
	remove "$1" "$2"
	exit $?
else
	echo "Chemin de la table associative et/ou clé non renseigné(s) !"
	exit 1
fi
