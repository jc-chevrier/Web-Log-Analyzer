#!/bin/bash


# Script de détection des attaques DDOS.


# Constantes.
GET_SETTING_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/conf/setting"
INTERVAL=$("$GET_SETTNG_SCRIPT_PATH" "attack_ddos_interval")
COUNT_REQUEST=$("$GET_SETTNG_SCRIPT_PATH" "attack_ddos_count_request")
PARSED_ACCESS_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/parsed_access_logs"
FILTERED_ACCESS_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/filtered_access_logs"
ACCUMULATED_ACCESS_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/accumulated_access_logs"


# Filtrer les logs d'accès pour ne conserver que des
# logs inclus dans l'intervalle d'étude des atatques DDOS.
function filter() {
	# Nettoyage du fichier des logs d'accès filtrés.
	if [ -f "$FILTERED_ACCESS_LOGS_FILE_PATH" ]
	then
		rm "FILTERED_ACCESS_LOGS_FILE_PATH"
	fi
	touch "$FILTERED_ACCESS_LOGS_FILE_PATH"

	# Date courante.
	local datetimeNow=$(date +%s)
	local timestampNow=$(date -d @$datetimeNow)

	# Filtrage des logs pour ne conserver que ceux
	# qui sont dans l'intervalle de temps de surveillance.
	while read line
	do
		# Récupération des informations du log.
		IPAddressClient=$("$ARRAY_LINE_GET_CELL_SCRIPT_PATH" "$line" ";;" 0)
                timestamp=$("$ARRAY_LINE_GET_CELL_SCRIPT_PATH" "$line" ";;" 2)
		URI=$("$ARRAY_LINE_GET_CELL_SCRIPT_PATH" ";;" 4)
		# Si le log est a eu lieu dans l"intervalle de
		# temps de surveillance.
		if [ $((timestampNow - timestamp)) -le $INTERVAL ]
		then
			echo "$IPAddressClient;$URI"  >> "$FILTERED_ACCESS_LOGS_FILE_PATH"
		fi
	done < "PARSED_ACCESS_LOGS_FILE_PATH"
}


# Détecter des attaques DDOS.
function detect() {
	local ipClientAddresses=()
	# Pour chaque ligne de logs.
	while read line
	do
		# Récupération des informations du log.
		local IPClientAddress=("$ARRAY_LINE_GET_CELL_SCRIPT_PATH" "$line" ";" 0)
		local URI=("$ARRAY_LINE_GET_CELL_SCRIPT_PATH" "$line" ";" 1)
		# Accumulation des logs .
		if [ $(grep -c -E "^$ipClientAddress;$uri;[0-9]+$" "$ACCUMULATED_ACCESS_LOFS_FILE_PATH") -eq 1 ]
		then
			local countAccess=$(grep -o -E "^$ipClientAddress;$uri;[0-9]+$" "$ACCUMULATED_ACCESS_LOFS_FILE_PATH" | grep -o -E ";[0-9]+$" | sed "s/;//g")
			countAccess=$((countAccess + 1))
			sed "s/^$ipClientAddress;$uri;[0-9]+$/^$ipClientAddress;$uri;$countAccess$/g" "$ACCUMULATED_ACCESS_LOGS_FILE_PATH"
		else
                        echo "$ipClientAddress;$uri;1" >> "$ACCUMULATED_ACCESS_LOGS_FILE_PATH"
		fi
	done < "FILTERED_ACCESS_LOGS_FILE_PATH"
}


# Exécution.
filter && detect
exit $?
