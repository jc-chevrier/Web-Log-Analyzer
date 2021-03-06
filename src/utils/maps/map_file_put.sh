#!/bin/bash


# Script d'ajout ou de modification de la valeur d'une clé
# dans une table associative.


# Scripts externes.
MAP_FILE_HAS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/maps/map_file_has.sh"


# Ajouter ou modifier la valeur associéee à une clé dans une
# table associative.
function put() {
	# Paramètres de fonction.
	local mapFilePath"=$1"
	local separator="$2"
	local keySearched="$3"
	local newValue="$4"

	# Si la clé existe déjà.
	"$MAP_FILE_HAS_SCRIPT_PATH" "$mapFilePath" "$separator" "$keySearched"
	if [ $? -eq 0 ]
	then
		sed -i -E "s|^${keySearched}${separator}.+$|${keySearched}${separator}${newValue}|g" "$mapFilePath"
	else
		echo "$keySearched$separator$newValue" >> "$mapFilePath"
	fi

	# Retour.
	return 0
}


# Exécution.
if [ $# -eq 4 ]
then
	put "$1" "$2" "$3" "$4"
	exit $?
else
	echo "Chemin du fichier de la table associative et/ou séparateur et/ou clé et/ou valeur non renseigné(s) !"
	exit 1
fi
