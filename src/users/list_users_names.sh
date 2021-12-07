#!/bin/bash


# Script de listing des noms des utilisateurs responsables
# sécurité, à notifier en cas d'attaques.


# Constantes.
USERS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/conf/users.conf"

# Fonction d'extraction des noms.
function extract() {
	#Mode de résultat.
	mode=$0

	# Extraction pour chaque utilisateur.
	names=""
	while read user;
	do
		oldIFS=$IFS
 		IFS=";"
		for dataUser in $user
		do
			#Envoi du résultat
			names="$dataUser $names"
			break
		done
		IFS=$oldIFS
	done < $USERS_FILE_PATH

	#Envoi du résultat.
	echo $names

	# Retour.
	return 0
}

# Exécutuion.
if [ -f "$USERS_FILE_PATH" ];
then
	extract $@
	exit 0
else
	echo "Ficher $USERS_FILE_PATH introuvable !"
	exit 1
fi
