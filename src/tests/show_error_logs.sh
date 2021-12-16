#!/bin/bash


# Script d'affichage des logs d'erreur de la journée
# enregistré par apache.


# Constantes.
LOGS_FILE_PATH="/var/log/apache2/error.log"


# Afficher le fichier.
function clear() {
	# Si le fichier existe.
	if [ -f "$LOGS_FILE_PATH" ]
	then
		# Affichage.
		cat "$LOGS_FILE_PATH"
	fi

	# Retour.
	return 0
}


# Exécution.
clear
exit $?
