#!/bin/bash


# Script de recherche de la valeur associée à une clé dans une table
# associative sous forme de fichier.


# Scripts externes.
MAP_FILE_HAS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/maps/map_file_has.sh"
ARRAY_LINE_GET_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/arrays/array_line_get.sh"


# Obtenir la valeur d'une clé dans une table associative.
function get() {
        # Paramètres de fonction.
        local mapFilePath="$1"
        local separator="$2"
	local keySearched="$3"
	local indexPartValueSearched=$4

	# Vérification de la clé.
	"$MAP_FILE_HAS_SCRIPT_PATH" "$mapFilePath" "$separator" "$keySearched"
	if [ $? -eq 1 ]
	then
		# Retour d'erreur.
		return 1
	fi

        # Recherche de valeur.
        local line=$(grep "$keySearched$separator" "$mapFilePath")
        local value=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$line" "$separator" $indexPartValueSearched)
	# Envoi de la valeur en résultat.
	echo "$value"

        # Retour.
        return 0
}


# Exécution.
if [ $# -eq 4 ]
then
        get "$1" "$2" "$3" $4
        exit $?
else
        echo "Chemin du fichier de la table associative et/ou sépérateur et/ou clé et/ou index de valeur cherché non renseigné(s) !"
        exit 1
fi
