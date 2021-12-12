#!/bin/bash


# Script de détection des attaques DDOS.


# Scripts externes.
GET_SETTING_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/settings/get_setting.sh"
ARRAY_LINE_GET_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/arrays/array_line_get.sh"
MAP_FILE_HAS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/maps/map_file_has.sh"
MAP_FILE_GET_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/maps/map_file_get.sh"
MAP_FILE_PUT_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/maps/map_file_put.sh"
CLEAR_FILE_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/files/clear_file.sh"
LIST_USERS_EMAIL_ADDRESSES_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/users/list_users_email_addresses.sh"
LIST_USERS_PHONE_NUMBERS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/users/list_users_phone_numbers.sh"
SEND_EMAIL_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/notifications/send_email.sh"
SEND_SMS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/notifications/send_sms.sh"


# Fichiers des structures de données.
PARSED_ACCESS_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/parsed_access_logs"
FILTERED_ACCESS_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/ddos_attacks_filtered_access_logs"
ACCUMULATED_ACCESS_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/ddos_attacks_accumulated_access_logs"


# Constantes.
INTERVAL=$("$GET_SETTING_SCRIPT_PATH" "attack_ddos_interval")
COUNT_REQUEST=$("$GET_SETTING_SCRIPT_PATH" "attack_ddos_count_request")


# Filtrer les logs d'accès pour ne conserver que des
# logs inclus dans l'intervalle d'étude des atatques DDOS.
function filter() {
	# Nettoyage du fichier des logs d'accès filtrés.
	"$CLEAR_FILE_SCRIPT_PATH" "$FILTERED_ACCESS_LOGS_FILE_PATH"

	# Date courante.
	local timestampNow=$(date +%s)

	# Filtrage des logs d'accès pour ne conserver que ceux
	# qui sont dans l'intervalle de temps de d'étude.
	while read line
	do
		# Récupération des informations du log.
		local IPAddressClient=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$line" "|" 0)
		local timestamp=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$line" "|" 2)
		local URI=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$line" "|" 4)
		# Si le log est a eu lieu dans l"intervalle de
		# temps de surveillance.
		if [ $((timestampNow - timestamp)) -le $INTERVAL ]
		then
			echo "$IPAddressClient;$URI"  >> "$FILTERED_ACCESS_LOGS_FILE_PATH"
		fi
	done < "$PARSED_ACCESS_LOGS_FILE_PATH"

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
		local IPAddressClient=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$line" ";" 0)
		local URI=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$line" ";" 1)
		# Accumulation des logs d'accès filtrés.
		local countRequest=""
		"$MAP_FILE_HAS_SCRIPT_PATH" "$ACCUMULATED_ACCESS_LOGS_FILE_PATH" "$IPAddressClient;$URI"
		if [ $? -eq 0 ]
		then
			countRequest=$("$MAP_FILE_GET_SCRIPT_PATH" "$ACCUMULATED_ACCESS_LOGS_FILE_PATH" ";" "$IPAddressClient;$URI" 2)
			countRequest=$((countRequest + 1))
		else
			countRequest=1
		fi
		"$MAP_FILE_PUT_SCRIPT_PATH" "$ACCUMULATED_ACCESS_LOGS_FILE_PATH" ";" "$IPAddressClient;$URI" "$countRequest"
	done < "$FILTERED_ACCESS_LOGS_FILE_PATH"

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
			echo -e "Alerte : attaque DDOS détectée pour l'adresse IP $IPAddressClient sur l'URI $URI : $countRequest requêtes !\n"
			subject="[Alerte de sécurité] Attaque DDOS détectée"
			message="Bonjour,\n\nUne attaque DDOS vient d'être détectée sur votre serveur web. Elle a été effectuée par l'adresse IP $IPAddressClient sur l'URI $URI. $countRequest requêtes ont été détectées.\n\nCordialement"
			# Notifications par e-mail.
			"$SEND_EMAIL_SCRIPT_PATH" "$($LIST_USERS_EMAIL_ADDRESSES_SCRIPT_PATH)" "$subject" "$message"
			# Notifications par sms.
			#"$SEND_SMS_SCRIPT_PATH" "$($LIST_USERS_PHONE_NUMBERS_SCRIPT_PATH)" "$subject\n\n$message"
		fi
        done < "$ACCUMULATED_ACCESS_LOGS_FILE_PATH"

	# Retour.
	return 0
}


# Exécution.
filter && accumulate && detectAndNotify
exit $?
