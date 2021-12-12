#!/bin/bash


# Script d'analyse du fichier des logs d'accès d'Apache.


# Constantes.
LOGS_FILE_PATH="/var/log/apache2/access.log"
PARSED_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/parsed_access_logs"
TEMPORARY_DIRECTORY_PATH="${WEB_LOG_ANALYZER_PATH}/tmp"


# Fonction d'extraction des logs.
function parse() {
	# Paramètres.
	local indexStart=$1

	# Création du dossier des données temporaires.
	if [ ! -d "$TEMPORARY_DIRECTORY_PATH" ]
	then
		mkdir "$TEMPORARY_DIRECTORY_PATH"
		chown root:root "$TEMPORARY_DIRECTORY_PATH"
		chmod u=rw,g=,o= "$TEMPORARY_DIRECTORY_PATH"
	fi

	# Création du fichier de résultat.
	if [ ! -f "$PARSED_LOGS_FILE_PATH" ]
	then
		touch "$PARSED_LOGS_FILE_PATH"
                chown root:root "$PARSED_LOGS_FILE_PATH"
                chmod u=rw,g=,o= "$PARSED_LOGS_FILE_PATH"
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

 			local datetime=$(echo $line | grep -o -E "\[.+\]" | sed "s/\[//g" | sed "s/\]//g")
			local timestamp=$(echo "$datetime" | sed -e "s,/,-,g" -e "s,:, ,")
			timestamp=$(date -d "$timestamp" +"%s")

 			local command=$(echo $line | grep -o -E "\".+\"" | grep -o -E "^\"[^\"]+" | sed "s/\"//g")
 			local method=$(echo $command | grep -o -E "^[^ ]+")
 			local URI=$(echo $command | grep -o -E " .+ " | sed "s/ //g")
			local HTTPVersion=$(echo $command | grep -o -E " [^ ]+$" | sed "s/ //g")

			local returnCode=$(echo $line | grep -o -E "\" [0-9]+ " | sed "s/\"//g" | sed "s/ //g")

			local client=$(echo $line | grep -o -E "\"[^\"]+\"$" | sed "s/\"//g")

			# Envoi du résultat.
			echo "$IPAddressClient|$datetime|$timestamp|$method|$URI|$HTTPVersion|$returnCode|$client" >> "$PARSED_LOGS_FILE_PATH"
		fi

 		index=$((index + 1))
	done < "$LOGS_FILE_PATH"

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
