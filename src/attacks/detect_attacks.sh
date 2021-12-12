#!/bin/bash


# Script de détection d'attaques.


# Constantes.
ACCESS_LOGS_FILE_PATH="/var/log/apache2/access.log"
PARSE_ACCESS_LOGS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/logs/parse_access_logs.sh"
PARSED_ACCESS_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/parsed_access_logs"


# Scripts externes.
ARRAY_FILE_COUNT_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/arrays/array_file_count.sh"
DETECT_DDOS_ATTACKS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/attacks/detect_ddos_attacks.sh"


# Détecter des attaques.
function detect() {
	echo -e "Début de la détection d'attaques... \
	         \nCTRL-C pour stopper.\n"

	# Nettoyage des fichiers.
	if [ -f "$PARSED_ACCESS_LOGS_FILE_PATH" ]
	then
		rm "$PARSED_ACCESS_LOGS_FILE_PATH"
	fi

	# Tant que la fonction n'est pas stoppée.
	local index=0
	while [ 0 ]
	do
		# Extraction des logs.
		"$PARSE_ACCESS_LOGS_SCRIPT_PATH" $index

		# Détection des attaques DDOS.
		"$DETECT_DDOS_ATTACKS_SCRIPT_PATH"

		# Préparation de l'itération suivante.
		index=$("$ARRAY_FILE_COUNT_SCRIPT_PATH" "$ACCESS_LOGS_FILE_PATH")
		index=$((index + 1))

		break
	done

	return 0
}


# Exécution.
detect
exit $?
