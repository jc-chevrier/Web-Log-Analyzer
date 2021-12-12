#!/bin/bash


# Script de détection des attaques DDOS.


# Scripts externes.
GET_SETTING_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/settings/get_setting.sh"
ARRAY_LINE_GET_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/array/array_line_get.sh"
CLEAR_FILE_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/files/clear_file.sh"
LIST_USERS_EMAIL_ADDRESSES_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/users/list_users_email_addresses.sh"
LIST_USERS_PHONE_NUMBERS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/users/list_users_phone_numbers.sh"


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

	# Filtrage des logs d'accès pour ne conserver que ceux
	# qui sont dans l'intervalle de temps de d'étude.
	while read line
	do
		# Récupération des informations du log.
		IPAddressClient=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$line" ";;" 0)
                timestamp=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$line" ";;" 2)
		URI=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$line" ";;" 4)
		# Si le log est a eu lieu dans l"intervalle de
		# temps de surveillance.
		if [ $((timestampNow - timestamp)) -le $INTERVAL ]
		then
			echo "$IPAddressClient;$URI"  >> "$FILTERED_ACCESS_LOGS_FILE_PATH"
		fi
	done < "PARSED_ACCESS_LOGS_FILE_PATH"

	# Retour.
	return 0
}


# Accumuler les logs d'accès qui portent qui ont en commun
# l'adresse IP du client  et l'URI demandé.
function accumulate() {
	# Nettoyage du fichier des logs d'accès accumulés.
        "$CLEAR_FILE_SCRIPT_PATH" "$ACCUMULATED_ACCESS_LOGS_FILE_PATH"

	# Pour chaque ligne des logs d'accès filtrés.
	while read line
	do
		# Récupération des informations du log d'accès filtré.
		local IPAddressClient=$("$ARRAY_LINE_GET_CELL_SCRIPT_PATH" "$line" ";" 0)
		local URI=$("$ARRAY_LINE_GET_CELL_SCRIPT_PATH" "$line" ";" 1)
		# Accumulation des logs d'accès filtrés.
		local countRequest
		"$MAP_FILE_HAS_SCRIPT_FILE" "$ACCUMULATED_ACCESS_LOGS_FILE_PATH" "$IPAddressClient;$URI"
		if [ $? -eq 0 ]
		then
			countRequqest=$("$MAP_FILE_GET_SCRIPT_FILE" "$ACCUMULATED_ACCESS_LOGS_FILE_PATH" ";" "$IPAddressClient;$URI" 2)
			countRequest=$((countRequest + 1))
		else
			countRequest=1
		fi
		"$MAP_FILE_PUT_SCRIPT_FILE" "$ACCUMULATED_ACCESS_LOGS_FILE_PATH" ";" "$IPAddressClient;$URI" "$countRequest"
	done < "FILTERED_ACCESS_LOGS_FILE_PATH"

	# Retour.
	return 0
}


# Détecter les attaques DDOS, les afficher et notifier
# les responsables sécurité par sms et e-mail.
function detectAndNotify() {
	# Pour chaque ligne des logs d'accès accumulés.
        while read line
        do
                # Récupération des informations des logs d'accès accumulés.
                local IPAddressClient=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$line" ";" 0)
                local URI=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$line" ";" 1)
                local countRequest=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$line" ";" 2)
		# Vérification des logs d'accès accumulés.
		# Si le nombre de requête qui a été fait sur l'intervalle a atteint le nombre de
		# requêtes définnissant les attaques DDOS.
		if [ $countRequest -ge $COUNT_REQUEST ]
		then
			# Message affiché.
			echo "Alerte: attaque DDOS détectée pour l'adresse $IPAdressClient sur l'URI $URI : $countRequest requêtes !"
			subject="[Alerte de sécurité] Attaque DDOS détectée"
			message="Bonjour,\n\n Une attaque DDOS vient d'être détectée sur votre serveur web. Elle a été effectuée par l'adresse $IPAddressClient sur l'URI $URI. $countRequest requêtes ont été faites.\n\nCordialement"
			# Notifications par e-mail.
			bash "$SEND_EMAIL_SCRIPT_PATH" "$(bash '$LIST_USERS_EMAIL_ADDRESSES_SCRIPT_PATH')" "$subject" "$message"
			# Notifications par sms.
			#bash "$SEND_SMS_SCRIPT_PATH" "$(bash '$LIST_USERS_PHONE_NUMBERS_SCRIPT_PATH')" "$subject\n\n$message"
		fi
        done < "ACCUMULATED_ACCESS_LOGS_FILE_PATH"

	# Retour.
	return 0
}


# Exécution.
filter && accumulate && detectAndNotify
exit $?
