#!/bin/bash


# Script de détection d'attaques.


# Scripts externes.
CLEAR_DIRECTORY_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/files/clear_directory.sh"
ARRAY_FILE_COUNT_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/arrays/array_file_count.sh"
PARSE_ACCESS_LOGS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/logs/parse_access_logs.sh"
PARSE_ERROR_LOGS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/logs/parse_error_logs.sh"
DETECT_DOS_ATTACKS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/attacks/detect_dos_attacks.sh"


#Constantes.
TEMPORARY_DIRECTORY_PATH="${WEB_LOG_ANALYZER_PATH}/tmp"
PARSED_ACCESS_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/parsed_access_logs"
PARSED_ERROR_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/parsed_error_logs"


# Détecter des attaques.
function detect() {
	echo -e "Début de la détection d'attaques... \
	         \nCTRL-C pour arrêter.\n"

	# Nettoyage des fichiers.
	"$CLEAR_DIRECTORY_SCRIPT_PATH" "$TEMPORARY_DIRECTORY_PATH"

	# Tant que la fonction n'est pas arrêtée.
	local indexAccessLogs=0
	local indexErrorLogs=0
	while [ 0 ]
	do
		# Extraction des logs d'accès.
		"$PARSE_ACCESS_LOGS_SCRIPT_PATH" $indexAccessLogs 1

                # Extraction des logs d'erreur.
                "$PARSE_ERROR_LOGS_SCRIPT_PATH" $indexErrorLogs 1

		# Détection des attaques DOS.
		"$DETECT_DOS_ATTACKS_SCRIPT_PATH"

		# Préparation de l'itération suivante.
                indexAccessLogs=$("$ARRAY_FILE_COUNT_SCRIPT_PATH" "$PARSED_ACCESS_LOGS_FILE_PATH")
		indexErrorLogs=$("$ARRAY_FILE_COUNT_SCRIPT_PATH" "$PARSED_ERROR_LOGS_FILE_PATH")
	done

	return 0
}


# Exécution.
detect
exit $?
