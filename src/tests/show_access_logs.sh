#!/bin/bash


# Script d'affichage des logs d'accès de la journée
# enregistré par Apache.


# Constantes.
LOGS_FILE_PATH="/var/log/apache2/access.log"


# Afficher le fichier.
function show() {
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
show
exit $?
