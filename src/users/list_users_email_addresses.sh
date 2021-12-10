#!/bin/bash


# Script de listing des adresses e-mail des utilisateurs
# responsables sécurité, à notifier en cas d'attaque.


# Constantes.
USERS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/conf/users"

# Fonction d'extraction des adresses e-mail.
function parse() {
	# Extraction pour chaque utilisateur.
	emailAddresses=""
	while read user;
	do
		oldIFS=$IFS
 		IFS=";"
		index=0
		for dataUser in $user
		do
			if [ $index -eq 1 ]
			then
				emailAddresses="$dataUser $emailAddresses"
				break
			else
				index=$((index + 1))
			fi
		done
		IFS=$oldIFS
	done < "$USERS_FILE_PATH"

	# Envoi du résultat.
	echo "$emailAddresses"

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
