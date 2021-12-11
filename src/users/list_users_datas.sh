#!/bin/bash


# Script d'extraction de données des utilisateurs.


# Constantes.
USERS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/conf/users"


# Fonction d'extraction des données.
function parse() {
	# Paramètres.
	local indexDataSelected=$1

        # Extraction pour chaque utilisateur.
        local datasUsers=""
        while read user;
        do
                local oldIFS=$IFS
                IFS=";"
                local index=0
                for dataUser in $user
                do
                        if [ $index -eq $indexDataSelected ]
                        then
                                datasUsers="$dataUser $datasUsers"
                                break
                        else
                                index=$((index + 1))
                        fi
                done
                IFS=$oldIFS
        done < "$USERS_FILE_PATH"

        # Envoi du résultat.
        echo "$datasUsers"

        # Retour.
        return 0
}


# Exécution.
if [ $# -eq 1 ]
then
	if [ -f "$USERS_FILE_PATH" ]
	then
        	parse "$1"
        	exit 0
	else
        	echo "Ficher $USERS_FILE_PATH introuvable !"
       	 	exit 1
	fi
else
	echo "Index de donnée sélectionnée non renseigné !"
	exit 1
fi
