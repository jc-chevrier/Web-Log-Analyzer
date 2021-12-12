#!/bin/bash


# Script d'extraction de données des utilisateurs.


# Constantes.
USERS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/conf/users"


# Scripts externes.
ARRAY_LINE_GET_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/arrays/array_line_get.sh"


# Fonction d'extraction des données.
function parse() {
	# Paramètres.
	local indexDataUserSearched=$1

        # Extraction pour chaque utilisateur.
        local datasUsers=""
        while read user;
        do
		local dataUser=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$user" ";" $indexDataUserSearched)
                datasUsers="$dataUser $datasUsers"
        done < "$USERS_FILE_PATH"

        # Envoi du résultat.
        echo "$datasUsers"

        # Retour.
        return 0
}


# Exécution.
if [ $# -eq 1 ]
then
        parse "$1"
        exit 0
else
	echo "Index de donnée sélectionnée non renseigné !"
	exit 1
fi
