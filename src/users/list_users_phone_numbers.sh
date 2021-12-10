#!/bin/bash


# Script de listing des numéro de téléphone des utilisateurs
# responsables sécurité, à notifier en cas d'attaques.


# Constantes.
USERS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/conf/users"

# Fonction d'extraction des numéro de téléphone.
function parse() {
	# Extraction pour chaque utilisateur.
	phoneNumbers=""
	while read user;
	do
		oldIFS=$IFS
 		IFS=";"
		count=0
		for dataUser in $user
		do
			if [ $count -eq 2 ]
			then
				phoneNumbers="$dataUser $phoneNumbers"
				break
			else
				count=$((count + 1))
			fi
		done
		IFS=$oldIFS
	done < "$USERS_FILE_PATH"

	# Envoi du résultat.
	echo "$phoneNumbers"

	# Retour.
	return 0
}

# Exécutuion.
if [ -f "$USERS_FILE_PATH" ]
then
	parse
	exit 0
else
	echo "Ficher $USERS_FILE_PATH introuvable !"
	exit 1
fi
