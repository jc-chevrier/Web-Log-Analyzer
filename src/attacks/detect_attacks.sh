#!/bin/bash


# Constantes.
PARSE_ACCESS_LOGS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/logs/parse_access_logs.sh"
PARSED_ACCESS_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/parsed_access_logs"
DETECT_DDOS_ATTACKS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/attacks/detect_ddos_attacks.sh"


# Fonction principale.
function main() {
	echo -e "\nDébut de la détection d'attaques..."
	echo -e "CTRL-C pour stopper."

	# Nettoyage des fichiers.
	if [ -f "$PARSED_ACCESS_LOGS_FILE_PATH" ]
	then
		rm "$PARSED_ACCESS_LOGS_FILE_PATH"
	fi

	local index=0

	#  Tant que la fonction n'est pas stoppée.
	while [ 0 ]
	do
		echo -e "\nNouvelle itération..."

		# Si script(s) non trouvé(s).
		if [ ! -f "$PARSE_ACCESS_LOGS_SCRIPT_PATH" -o ! -f "$DETECT_DDOS_ATTACKS_SCRIPT_PATH" ]
		then
			return 1
		fi

		# Extraction des logs.
		echo "Extraction de logs..."
		"$PARSE_ACCESS_LOGS_SCRIPT_PATH" $index

		# Détection des attaques DDOS.
		echo "Détection des attaques DDOS..."
		"$DETECT_DDOS_ATTACKS_SCRIPT_PATH"

		# Préparation de l'itération suivante.
		index=$(wc -l "$PARSED_ACCESS_LOGS_FILE_PATH" | grep -o -E "^[0-9]+ " | sed "s/ //g")
		index=$((index + 1))
	done

	return 0
}


# Exécution.
main
exit $?
