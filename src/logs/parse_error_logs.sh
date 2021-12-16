#!/bin/bash


# Script d'analyse du fichier des logs d'erreur d'Apache.


# Constantes.
LOGS_FILE_PATH="/var/log/apache2/error.log"
PARSED_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/parsed_error_logs"
TEMPORARY_DIRECTORY_PATH="${WEB_LOG_ANALYZER_PATH}/tmp"


# Scripts externes.
CREATE_DIRECTORY_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/files/create_directory.sh"
CREATE_FILE_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/files/create_file.sh"
ARRAY_FILE_ADD_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/arrays/array_file_add.sh"


# Fonction d'extraction des logs.
function parse() {
	# Paramètres de fonction.
	local indexStart=$1

        # Création du dossier de résultat.
        "$CREATE_DIRECTORY_SCRIPT_PATH" "$TEMPORARY_DIRECTORY_PATH"

	# Création du fichier de résultat.
	"$CREATE_FILE_SCRIPT_PATH" "$PARSED_LOGS_FILE_PATH"

	# Pour chaque ligne des logs.
	local index=0
	while read line
	do
		# Si on a atteint la ligne de début précisée.
		if [ $indexStart -le $index ]
		then
			# Extraction.
 			local datetime=$(echo $line | grep -o -E "\[.+\]" | sed "s/\[//g" | sed "s/\]//g")
			local timestamp=$(echo "$datetime" | sed -e "s,/,-,g" -e "s,:, ,")
			timestamp=$(date -d "$timestamp" +"%s")

			local errorDomain=
			local errorType=

			local processId=

			local errorCode=
			local errorMessage=

			# Envoi du résultat.
			"$ARRAY_FILE_ADD_SCRIPT_PATH" "$PARSED_LOGS_FILE_PATH" "$datetime|$timestamp|$errorDomain|$errorType|$processId|$erroeCode|$errorMessage"
		fi

		# Incrémentation de l'index.
 		index=$((index + 1))
	done < "$LOGS_FILE_PATH"

	# Retour.
	return 0
}


# Exécution.
if [ -f "$LOGS_FILE_PATH" ]
then
	if [ $# -eq 1 ]
	then
		parse "$1"
	else
		parse 0
	fi

	exit 0
else
	echo "Ficher $LOGS_FILE_PATH introuvable !"
	exit 1
fi
