#!/bin/bash


# Script de nettoyage des logs d'accès de la journée
# enregistré par apache.


# Constantes.
ACCESS_LOGS_PATH="/var/log/apache2/access.log"


# Nettoyer le fichier.
function clear() {
	# Si le fichier existe.
	if [ -f "$ACCESS_LOGS_PATH" ]
	then
		# Nettoyage.
		truncate -s 0 "$ACCESS_LOGS_PATH"
	fi

	# Retour.
	return 0
}


# Exécution.
clear
exit $?
