#!/bin/bash


# Script d'envoi de sms.


# Constantes.
GET_SETTING_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/settings/get_setting.sh"


# Envoyer un SMS.
function send() {
	# Paramètres.
	local phoneNumber=$1
	local sms=$2

	# Si script de recherche de paramètre de configuration trouvé.
	if [ ! -f "$GET_SETTING_SCRIPT_PATH" ]
	then
		return 1
	fi

        # Recherche de la valeur de la clé d'accès à l'API.
	local key=$("$GET_SETTING_SCRIPT_PATH" "sms_textbelt_api_key")

	# Si clé de paramètre de configuration pas trouvée.
	if [ $? -eq 1 ]
	then
		return 1
	fi

	# Envoi du sms.
	local result=$(curl -X POST "https://textbelt.com/text" \
	--data-urlencode phone="$phoneNumber" \
	--data-urlencode message="$sms" \
	-d key="$key" \
	--silent)

	# Résultat de l'envoi.
	if [ $? -eq 1 ]
	then
		return 1
	else
		return $(echo $result | grep -c -E "{\"success\":false,")
	fi
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
	echo "Numéro de téléphone et/ou contenu du SMS non renseigné(s) !"
	exit 1
fi
