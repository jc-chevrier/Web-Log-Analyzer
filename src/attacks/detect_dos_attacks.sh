#!/bin/bash


# Script de détection des attaques DOS.


# Scripts externes.
GET_SETTING_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/settings/get_setting.sh"
ARRAY_LINE_GET_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/arrays/array_line_get.sh"
ARRAY_LINE_CONTAINS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/arrays/array_line_contains.sh"
ARRAY_LINE_ADD_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/arrays/array_line_add.sh"
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
DETECTED_ATTACKS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/tmp/detected_dos_attacks"


# Constantes.
INTERVAL=$("$GET_SETTING_SCRIPT_PATH" "attack_dos_interval")
COUNT_REQUEST=$("$GET_SETTING_SCRIPT_PATH" "attack_dos_count_request")


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
	while read attack
	do
		# Récupération des informations de l'attaque.
                local timestamp=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$attack" "~" 2)
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
# logs inclus dans l'intervalle d'étude des atatques DOS,
# et accumuler les logs filtrés qui ont en commun l'adresse
# IP du client et l'URI demandé par le client.
function analyze() {
	# Nettoyage du fichier des logs d'accès accumulés.
	"$CLEAR_FILE_SCRIPT_PATH" "$ACCUMULATED_FILTERED_ACCESS_LOGS_FILE_PATH"

	# Date courante.
	local timestampNow=$(date +%s)

	# Filtrage des logs d'accès pour ne conserver que ceux
	# qui sont dans l'intervalle de temps de d'étude.
	index=0
	while read accessLog
	do
		# Récupération des informations du log.
		local IPAddressClient=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$accessLog" "~" 0)
		local timestamp=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$accessLog" "~" 3)
		local URI=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$accessLog" "~" 5)
                local returnHTTPCode=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$accessLog" "~" 7)
                local client=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$accessLog" "~" 10)
		# Si le log est a eu lieu dans l"intervalle de
		# temps de surveillance.
		if [ $((timestampNow - timestamp)) -le $INTERVAL ]
		then
			# Accumulation des logs d'accès filtrés dans une table associative.
			local startTimestamp=""
			local returnHTTPCodes=""
			local clients=""
			local countRequest=""
               	 	"$MAP_FILE_HAS_SCRIPT_PATH" "$ACCUMULATED_FILTERED_ACCESS_LOGS_FILE_PATH" "~" "$IPAddressClient~$URI"
                	if [ $? -eq 0 ]
                	then
                        	startTimestamp=$("$MAP_FILE_GET_SCRIPT_PATH" "$ACCUMULATED_FILTERED_ACCESS_LOGS_FILE_PATH" "~" "$IPAddressClient~$URI" 2)
				returnHTTPCodes=$("$MAP_FILE_GET_SCRIPT_PATH" "$ACCUMULATED_FILTERED_ACCESS_LOGS_FILE_PATH" "~" "$IPAddressClient~$URI" 3)
				"$ARRAY_LINE_CONTAINS_SCRIPT_PATH" "$returnHTTPCodes" "%" "$returnHTTPCode"
				if [ $? -eq 1 ]
				then
					returnHTTPCodes=$("$ARRAY_LINE_ADD_SCRIPT_PATH" "$returnHTTPCodes" "%" "$returnHTTPCode")
				fi
                                clients=$("$MAP_FILE_GET_SCRIPT_PATH" "$ACCUMULATED_FILTERED_ACCESS_LOGS_FILE_PATH" "~" "$IPAddressClient~$URI" 4)
                                "$ARRAY_LINE_CONTAINS_SCRIPT_PATH" "$clients" "%" "$client"
                                if [ $? -eq 1 ]
                                then
                                        clients=$("$ARRAY_LINE_ADD_SCRIPT_PATH" "$clients" "%" "$client")
                                fi
                                countRequest=$("$MAP_FILE_GET_SCRIPT_PATH" "$ACCUMULATED_FILTERED_ACCESS_LOGS_FILE_PATH" "~" "$IPAddressClient~$URI" 5)
                                countRequest=$((countRequest + 1))

			else
                     		startTimestamp="$timestamp"
				returnHTTPCodes=$("$ARRAY_LINE_ADD_SCRIPT_PATH" "$returnHTTPCodes" "%" "$returnHTTPCode")
				clients=$("$ARRAY_LINE_ADD_SCRIPT_PATH" "$clients" "%" "$client")
				countRequest=1
                	fi
			"$MAP_FILE_PUT_SCRIPT_PATH" "$ACCUMULATED_FILTERED_ACCESS_LOGS_FILE_PATH" "~" "$IPAddressClient~$URI" "$startTimestamp~$returnHTTPCodes~$clients~$countRequest"
		fi
	done < "$PARSED_ACCESS_LOGS_FILE_PATH"

	# Retour.
	return 0
}


# Détecter les attaques DOS, les afficher, et notifier
# les responsables sécurité par sms et e-mail, et retenir
# les attaques..
function detect() {
        # Date courante.
        local timestampNow=$(date +%s)

	# Pour chaque ligne des logs d'accès accumulés.
        while read FAAccessLog
        do
                # Récupération des informations des logs d'accès accumulés.
                local IPAddressClient=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$FAAccessLog" "~" 0)
                local URI=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$FAAccessLog" "~" 1)
                local startTimestamp=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$FAAccessLog" "~" 2)
		local startDatetime=$(date -d@$startTimestamp +"le %d/%m/%Y à %H:%M")
		local returnHTTPCodes=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$FAAccessLog" "~" 3)
		returnHTTPCodes=$(echo "$returnHTTPCodes" | sed -e "s/%/, /g")
		local clients=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$FAAccessLog" "~" 4)
                clients=$(echo "$clients" | sed -e "s/%/, /g")
		local countRequest=$("$ARRAY_LINE_GET_SCRIPT_PATH" "$FAAccessLog" "~" 5)
		# Vérification des logs d'accès accumulés.
		# Si l'attaque n'avait pas déjà été détectée durant l'intervalle d'étude
		# et si le nombre de requête qui a été fait sur l'intervalle a atteint le
		# nombre de requêtes définnissant les attaques DOS.
		"$MAP_FILE_HAS_SCRIPT_PATH" "$DETECTED_ATTACKS_FILE_PATH" "~" "$IPAddressClient~$URI"
		if [ $? -eq 1 -a $countRequest -ge $COUNT_REQUEST ]
		then
			# Notifications.
			subject="[Alerte de sécurité] Attaque DOS détectée"
			message="Bonjour,\n\nUne attaque DOS vient d'être détectée sur votre serveur web.\n\nElle a été effectuée par l'adresse IP $IPAddressClient sur l'URI $URI.\n\nL'attaquant a effectué $countRequest requêtes, en utilisant ces clients : $clients, et a obtenu ces codes HTTP en retour : $returnHTTPCodes.\n\nL'attaque a commencé $startDatetime.\n\nCordialement"
			# Notification par e-mail.
			"$SEND_EMAIL_SCRIPT_PATH" "$($LIST_USERS_EMAIL_ADDRESSES_SCRIPT_PATH)" "$subject" "$message"
			# Notification par sms.
			message=$(echo "$message" | sed -E "s/([0-9]{1,3}){1}\.{1}([0-9]{1,3}){1}\.{1}([0-9]{1,3}){1}\.{1}([0-9]{1,3}){1}/\1 \2 \3 \4/g")
			"$SEND_SMS_SCRIPT_PATH" "$($LIST_USERS_PHONE_NUMBERS_SCRIPT_PATH)" "$subject\n\n$message"
			# Sauvegarde de l'attaque dans un tableau.
			"$ARRAY_FILE_ADD_SCRIPT_PATH" "$DETECTED_ATTACKS_FILE_PATH" "$IPAddressClient~$URI~$timestampNow"
			# Affichage sur le terminal.
                        echo "Alerte : attaque DOS détectée pour l'adresse IP $IPAddressClient sur l'URI $URI : $countRequest requêtes !"
		fi
        done < "$ACCUMULATED_FILTERED_ACCESS_LOGS_FILE_PATH"

	# Retour.
	return 0
}

# Exécution.
clear && analyze && detect
exit $?
