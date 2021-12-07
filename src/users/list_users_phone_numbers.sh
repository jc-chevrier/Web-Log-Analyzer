#!/bin/bash


# Script de listing des numéro de téléphone des utilisateurs
# responsables sécurité, à notifier en cas d'attaques.


# Constantes.
USERS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/conf/users.conf"

# Fonction d'extraction des numéro de téléphone.
function extract() {
	# Pour chaque utilisateur.
	while read user;
	do
		oldIFS=$IFS
 		IFS=";"
		count=0
		for dataUser in $user
		do
			if [ $count -eq 2 ]
			then
				#Envoi du résultat.
				echo $dataUser
				break
			else
				count=$((count + 1))
			fi
		done
		IFS=$oldIFS
	done < $USERS_FILE_PATH

	# Retour.
	return 0
}

# Exécutuion.
if [ -f "$USERS_FILE_PATH" ];
then
	extract
	exit 0
else
	echo "Ficher $USERS_FILE_PATH introuvable !"
	exit 1
fi
