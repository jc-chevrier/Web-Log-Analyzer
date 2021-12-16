#!/bin/bash


# Script d'analyse du fichier des logs d'accès d'Apache.


# Scripts externes.
CREATE_DIRECTORY_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/files/create_directory.sh"
CREATE_FILE_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/files/create_file.sh"
CLEAR_FILE_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/files/clear_file.sh"
ARRAY_FILE_ADD_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/arrays/array_file_add.sh"
GET_SETTING_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/settings/get_setting.sh"


# Constantes.
LOGS_FILE_PATH=$("$GET_SETTING_SCRIPT_PATH" "access_logs_file_path")
PARSED_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/parsed_access_logs"
TEMPORARY_DIRECTORY_PATH="${WEB_LOG_ANALYZER_PATH}/tmp"


# Fonction d'extraction des logs.
function parse() {
	# Paramètres de fonction.
	local indexStart=$1
	local clearFileAsked=$2

        # Création du dossier de résultat.
        "$CREATE_DIRECTORY_SCRIPT_PATH" "$TEMPORARY_DIRECTORY_PATH"

	# Création du fichier de résultat.
	if [ $clearFileAsked -eq 0 ]
	then
		"$CLEAR_FILE_SCRIPT_PATH" "$PARSED_LOGS_FILE_PATH"
	else
		"$CREATE_FILE_SCRIPT_PATH" "$PARSED_LOGS_FILE_PATH"
	fi

	# Pour chaque ligne des logs.
	local index=0
	while read line
	do
		# Si on a atteint la ligne de début précisée.
		if [ $indexStart -le $index ]
		then
			# Extraction.
 			local IPAddressClient=$(echo $line | grep -o -E "^([0-9]{1,3}\.){3}[0-9]{1,3}")

 			local datetime=$(echo $line | grep -o -E "\[.+\]" | sed -e "s/\[//g" -e "s/\]//g")
			local timestamp=$(echo "$datetime" | sed -e "s|/|-|g" -e "s/:/ /")
			timestamp=$(date -d "$timestamp" "+%s")

 			local command=$(echo $line | grep -o -E "\".+\"" | grep -o -E "^\"[^\"]+" | sed "s/\"//g")
 			local method=$(echo $command | grep -o -E "^[^ ]+")
 			local URI=$(echo $command | grep -o -E " .+ " | sed "s/ //g")
			local HTTPVersion=$(echo $command | grep -o -E " [^ ]+$" | sed "s/ //g")

			local returnHTTPCode=$(echo $line | grep -o -E "\" [0-9]+ " | sed -e "s/\"//g" -e "s/ //g")

			local client=$(echo $line | grep -o -E "\"[^\"]+\"$" | sed "s/\"//g")

			# Envoi du résultat.
			"$ARRAY_FILE_ADD_SCRIPT_PATH" "$PARSED_LOGS_FILE_PATH" "$IPAddressClient~$timestamp~$method~$URI~$HTTPVersion~$returnHTTPCode~$client"
		fi

		# Incrémentation de l'index.
 		index=$((index + 1))
	done < "$LOGS_FILE_PATH"

	# Retour.
	return 0
}


# Exécution.
if [ $# -eq 2 ]
then
	if [ -f "$LOGS_FILE_PATH" ]
	then
		parse $1 $2
		exit 0
	else
		echo "Ficher $LOGS_FILE_PATH introuvable !"
		exit 1
	fi
else
	echo "Indice de départ et/ou nettoyage demandé non renseigné(s) !"
	exit 1
fi
