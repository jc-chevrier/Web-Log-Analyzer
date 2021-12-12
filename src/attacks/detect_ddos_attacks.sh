#!/bin/bash


# Script de détection des attaques DDOS.


# Scripts externes.
GET_SETTING_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/settings/get_setting.sh"
ARRAY_LINE_GET_CELL_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/array/array_line_get_cell.sh"
CLEAR_FILE_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/files/clear_file.sh"


# Fichiers des structures de données.
PARSED_ACCESS_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/parsed_access_logs"
FILTERED_ACCESS_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/filtered_access_logs"
ACCUMULATED_ACCESS_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/accumulated_access_logs"


# Constantes.
INTERVAL=$("$GET_SETTNG_SCRIPT_PATH" "attack_ddos_interval")
COUNT_REQUEST=$("$GET_SETTNG_SCRIPT_PATH" "attack_ddos_count_request")


# Filtrer les logs d'accès pour ne conserver que des
# logs inclus dans l'intervalle d'étude des atatques DDOS.
function filter() {
	# Nettoyage du fichier des logs d'accès filtrés.
	"$CLEAR_FILE_SCRIPT_PATH" "$FILTERED_ACCESS_LOGS_FILE_PATH"

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

	return 0
}


# Accumuler les logs d'accès qui portent qui ont en commun
# l'adresse IP du client  et l'URI demandé.
function accumulate() {
	# Nettoyage du fichier des logs d'accès accumulés.
        "$CLEAR_FILE_SCRIPT_PATH" "$ACCUMULATED_ACCESS_LOGS_FILE_PATH"

	# Pour chaque ligne de logs d'accès filtrés.
	while read line
	do
		# Récupération des informations du log.
		local IPClientAddress=$("$ARRAY_LINE_GET_CELL_SCRIPT_PATH" "$line" ";" 0)
		local URI=$("$ARRAY_LINE_GET_CELL_SCRIPT_PATH" "$line" ";" 1)
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

	return 0
}


# Détecter les attaques DDOS, les afficher et notifier
# les responsables sécurité par sms et e-mail.
function detect() {
	# Pour chaque ligne de logs d'accès accumulés.
        while read line
        do
                # Récupération des informations du log.
                local IPClientAddress=$("$ARRAY_LINE_GET_CELL_SCRIPT_PATH" "$line" ";" 0)
                local URI=$("$ARRAY_LINE_GET_CELL_SCRIPT_PATH" "$line" ";" 1)
                local countRequest=$("$ARRAY_LINE_GET_CELL_SCRIPT_PATH" "$line" ";" 2)
		# Vérification des logs accmulés.
		# Si le nombre de requptes qui a été fait sur l'intervalle a atteint le nombre de
		# requêtes définnsant les attaques DDOS.
		if [ $countRequest -ge $COUNT_REQUEST ]
		then
			# Message affiché.
			echo "Alerte ! Attaque DDOS détectée pour l'adresse $IPAdressClient sur l'URI $URI : $countRequest requêtes."
			message="Bonjour,\n\n Une attaque DDOS vient d'être détectée sur votre serveur web. Elle a été effectuée par l'adresse $IPAddressClient sur l'URI $URI. $countRequest requêtes ont été faites.\n\nCordialement"
			# Notifications par e-mail.
			bash "$SEND_EMAIL_SCRIPT_PATH" "$(bash '$LIST_USERS_EMAIL_ADDRESSES_SCRIPT_PATH')" "Alerte : attaque DDOS détectée" "$message"
			# Notifications par sms.
			bash "$SEND_SMS_SCRIPT_PATH" "$(bash '$LIST_USERS_PHONE_NUMBERS_SCRIPT_PATH')" "$message"
		fi
        done < "ACCUMULATED_ACCESS_LOGS_FILE_PATH"
}


# Exécution.
filter && accumulate && detect
exit $?
