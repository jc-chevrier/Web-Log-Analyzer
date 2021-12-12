#!/bin/bash


# Script d'envoi de sms.


# Constantes.
GET_SETTING_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/settings/get_setting.sh"
API_URL=$("$GET_SETTING_SCRIPT_PATH" "sms_textbelt_api_url")
API_KEY=$("$GET_SETTING_SCRIPT_PATH" "sms_textbelt_api_key")


# Envoyer un SMS.
function send() {
	# Paramètres de fonction.
	local phoneNumbers=$1
	local sms=$2

	oldIFS=$IFS
	IFS=" "
	# Pour chaque numéro de téléphone.
	for phoneNumber in $phoneNumbers
	do
		echo $phoneNumber
		# Envoi du sms.
		local result=$(curl -X POST "$API_URL" \
		--data-urlencode phone="$phoneNumber" \
		--data-urlencode message="$(echo -e $sms)" \
		-d key="$API_KEY" \
		--silent)

		# Retour d'erreur.
		# Vérification de la réussite de l'envoi du sms.
		if [ $? -eq 1 -o $(echo $result | grep -c -E "{\"success\":false,") -eq 1 ]
		then
			return 1
		fi
	done
	IFS=$oldIFS

	# Retour.
	return 0
}


# Exécution.
if [ $# -eq 2 ]
then
	send "$1" "$2"
	if [ $? -eq 0 ]
	then
		exit 0
	else
		echo "Echec de l'envoi du SMS !"
		exit 1
	fi
else
	echo "Numéro(s) de téléphone et/ou contenu du SMS non renseigné(s) !"
	exit 1
fi
