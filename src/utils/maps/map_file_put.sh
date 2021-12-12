#!/bin/bash


# Script d'ajout ou de modification de la valeur d'une clé
# dans une table associative.


# Scripts externes.
MAP_FILE_HAS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/maps/map_file_has.sh"


# Ajouter ou modifier la valeur associéee à une clé dans une
# table associative.
function put() {
	# Paramètres de fonction.
	mapFilePath=$1
	separator=$2
	key=$3
	value=$4

	# Si la clé existe déjà.
	"$MAP_FILE_HAS_SCRIPT_PATH" "$mapFilePath" "$key"
	if [ $? -eq 0 ]
	then
		sed -i -E "s/^${key}.+$/${key}${separator}${value}/g" "$mapFilePath"
	else
		echo "$key$separator$value" >> "$mapFilePath"
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
	echo "Chemin de la table associative et/ou séparateur et/ou clé et/ou valeur non renseigné(s) !"
	exit 1
fi
