#!/bin/bash


# Script de détection des attaques DDOS.


# Scripts externes.
GET_SETTING_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/settings/get_setting.sh"
ARRAY_LINE_GET_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/arrays/array_line_get.sh"
ARRAY_FILE_ADD_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/arrays/array_file_add.sh"
ARRAY_FILE_REMOVE_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/arrays/array_file_remove.sh"
MAP_FILE_HAS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/maps/map_file_has.sh"
MAP_FILE_GET_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/maps/map_file_get.sh"
MAP_FILE_PUT_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/maps/map_file_put.sh"
CREATE_FILE_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/files/create_file.sh"
CLEAR_FILE_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/files/clear_file.sh"
LIST_USERS_EMAIL_ADDRESSES_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/users/list_users_email_addresses.sh"
LIST_USERS_PHONE_NUMBERS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/users/list_users_phone_numbers.sh"
SEND_EMAIL_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/notifications/send_email.sh"
SEND_SMS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/notifications/send_sms.sh"


# Fichiers des structures de données.
PARSED_ACCESS_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/parsed_access_logs"
ACCUMULATED_FILTERED_ACCESS_LOGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/accumulated_filtered_access_logs"
DETECTED_ATTACKS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/detected_ddos_attacks"


# Constantes.
INTERVAL=$("$GET_SETTING_SCRIPT_PATH" "attack_ddos_interval")
COUNT_REQUEST=$("$GET_SETTING_SCRIPT_PATH" "attack_ddos_count_request")


# Mttre à jour les attaques le listing des atatques détectées.
function clear() {
	# Création du fichier des attaques détectées s'il n'existe pas encore.
        "$CREATE_FILE_SCRIPT_PATH" "$DETECTED_ATTACKS_FILE_PATH"

        # Date courante.
        local timestampNow=$(date +%s)

	# Création d'une copie dans un fichier temporaire.
	cp "$DETECTED_ATTACKS_FILE_PATH" "${DETECTED_ATTACKS_FILE_PATH}_copy"

	# Pour chaque attaque détectée.
	index=0
	while read line
	do
		# Récupération des informations de l'attaque.
                local timestamp=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$line" ";" 2)
		# Si l'attaque a dépassée l'intervalle d'étude.
		if [ $((timestampNow - timestamp)) -gt $INTERVAL ]
		then
			# On la supprime des attaques détectées dans l"interballe d'étude.
			"$ARRAY_FILE_REMOVE_SCRIPT_PATH" "$DETECTED_ATTACKS_FILE_PATH" $index
		fi
		index=$((index + 1))
	done < "${DETECTED_ATTACKS_FILE_PATH}_copy"

	# Suppression de fichier temporaire de la copie.
	rm "${DETECTED_ATTACKS_FILE_PATH}_copy"

	# Retour.
	return 0
}


# Filtrer les logs d'accès pour ne conserver que des
# logs inclus dans l'intervalle d'étude des atatques DDOS,
# et accumuler les logs filtrés qui ont en commun l'adresse
# IP du client et l'URI demandé par le client.
function analyze() {
	# Nettoyage du fichier des logs d'accès accumulés.
	"$CLEAR_FILE_SCRIPT_PATH" "$ACCUMULATED_FILTERED_ACCESS_LOGS_FILE_PATH"

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
			# Accumulation des logs d'accès filtrés dans une table associative.
                	local countRequest=""
               	 	"$MAP_FILE_HAS_SCRIPT_PATH" "$ACCUMULATED_FILTERED_ACCESS_LOGS_FILE_PATH" ";" "$IPAddressClient;$URI"
                	if [ $? -eq 0 ]
                	then
                        	countRequest=$("$MAP_FILE_GET_SCRIPT_PATH" "$ACCUMULATED_FILTERED_ACCESS_LOGS_FILE_PATH" ";" "$IPAddressClient;$URI" 2)
                        	countRequest=$((countRequest + 1))
                	else
                        	countRequest=1
                	fi
			"$MAP_FILE_PUT_SCRIPT_PATH" "$ACCUMULATED_FILTERED_ACCESS_LOGS_FILE_PATH" ";" "$IPAddressClient;$URI" "$countRequest"
		fi
	done < "$PARSED_ACCESS_LOGS_FILE_PATH"

	# Retour.
	return 0
}


# Détecter les attaques DDOS, les afficher, et notifier
# les responsables sécurité par sms et e-mail, et retenir
# les attaques..
function detect() {
        # Date courante.
        local timestampNow=$(date +%s)

	# Pour chaque ligne des logs d'accès accumulés.
        while read line
        do
                # Récupération des informations des logs d'accès accumulés.
                local IPAddressClient=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$line" ";" 0)
                local URI=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$line" ";" 1)
                local countRequest=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$line" ";" 2)
		# Vérification des logs d'accès accumulés.
		# Si l'attaque n'avait pas déjà été détectée durant l'intervalle d'étude
		# et si le nombre de requête qui a été fait sur l'intervalle a atteint le
		# nombre de requêtes définnissant les attaques DDOS.
		"$MAP_FILE_HAS_SCRIPT_PATH" "$DETECTED_ATTACKS_FILE_PATH" ";" "$IPAddressClient;$URI"
		if [ $? -eq 1 -a $countRequest -ge $COUNT_REQUEST ]
		then
			# Message affiché.
			echo "Alerte : attaque DDOS détectée pour l'adresse IP $IPAddressClient sur l'URI $URI : $countRequest requêtes !"
			subject="[Alerte de sécurité] Attaque DDOS détectée"
			message="Bonjour, \
				\n\nUne attaque DDOS vient d'être détectée sur votre serveur web. Elle a été effectuée par l'adresse IP $IPAddressClient sur l'URI $URI. $countRequest requêtes ont été détectées. \
				\n\nCordialement"
			# Notifications par e-mail.
			"$SEND_EMAIL_SCRIPT_PATH" "$($LIST_USERS_EMAIL_ADDRESSES_SCRIPT_PATH)" "$subject" "$message"
			# Notifications par sms.
			#"$SEND_SMS_SCRIPT_PATH" "$($LIST_USERS_PHONE_NUMBERS_SCRIPT_PATH)" "$subject\n\n$message"
			# Sauvegarde de l'attaque dans un tableau.
			"$ARRAY_FILE_ADD_SCRIPT_PATH" "$DETECTED_ATTACKS_FILE_PATH" "$IPAddressClient;$URI;$timestampNow"
		fi
        done < "$ACCUMULATED_FILTERED_ACCESS_LOGS_FILE_PATH"

	# Retour.
	return 0
}

# Exécution.
clear && analyze && detect
exit $?
