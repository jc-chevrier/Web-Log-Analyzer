#!/bin/bash


# Script de nettoyage des logs d'erreur de la journée
# enregistré par apache.


# Constantes.
LOGS_FILE_PATH="/var/log/apache2/error.log"


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
