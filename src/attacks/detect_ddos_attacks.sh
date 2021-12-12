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

}


# Détecter des attaques DDOS.
function detect() {
	local ipClientAddresses=()
	# Pour chaque ligne de logs.
	while read line
	do
		# Extraction.
		local index=0
		local ipClientAddress=
		local uri=
		local oldIFS=$IFS
		IFS=";;"
		for data in $line
		do
			if [ $index -eq 0 ]
			then
				ipClientAddress=$data
			else
				if [ $index -eq 2 ]
				then
					uri=$data
				fi
			fi
			index=$((index + 1))
		done
		IFS=$oldIFS

		# Accumulation.
		if [ $(grep -c -E "^$ipClientAddress;$uri;[0-9]+$" "$ACCUMULATED_ACCESS_LOFS_FILE_PATH") -eq 1 ]
		then
			local countAccess=$(grep -o -E "^$ipClientAddress;$uri;[0-9]+$" "$ACCUMULATED_ACCESS_LOFS_FILE_PATH" | grep -o -E ";[0-9]+$" | sed "s/;//g")
			countAccess=$((countAccess + 1))
			sed "s/^$ipClientAddress;$uri;[0-9]+$/^$ipClientAddress;$uri;$countAccess$/g" "$ACCUMULATED_ACCESS_LOGS_FILE_PATH"
		else
                        echo "$ipClientAddress;$uri;1" >> "$ACCUMULATED_ACCESS_LOGS_FILE_PATH"
		fi
	done < "PARSED_FILTERED_ACCESS_LOGS_FILE_PATH"
}


# Exécution.
filter && detect
exit $?
