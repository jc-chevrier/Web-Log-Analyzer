#!/bin/bash


# Script de nettoyage des logs d'accès de la journée
# enregistré par apache.


# Constantes.
LOGS_FILE_PATH="/var/log/apache2/access.log"


# Nettoyer le fichier.
function clear() {
	# Si le fichier existe.
	if [ -f "$LOGS_FILE_PATH" ]
	then
		# Nettoyage.
		truncate -s 0 "$LOGS_FILE_PATH"
	fi

	# Retour.
	return 0
}


# Exécution.
clear
exit $?
