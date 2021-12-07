#!/bin/bash


# Script de listing des noms des utilisateurs responsables
# sécurité, à notifier en cas d'attaques.


# Constantes.
USERS_FILE_PATH="${WEB_LOG_ANALYSER_PATH}/conf/users.conf"

# Fonction d'extraction des noms.
function extract() {
	# Pour chaque utilisateur.
	while read user;
	do
		oldIFS=$IFS
 		IFS=";"
		for dataUser in $user
		do
			#Envoi du résultat.
			echo $dataUser
			break
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
