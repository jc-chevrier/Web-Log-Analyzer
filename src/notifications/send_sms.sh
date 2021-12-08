#!/bin/bash


# Script d'envoi de sms.


# Envoyer un SMS.
function send() {
	#Paramètres.
	phoneNumber=$1
	sms=$2

	# Envoi du sms.
	result=$(curl -X POST https://textbelt.com/text \
	--data-urlencode phone="$phoneNumber" \
	--data-urlencode message="$sms" \
	-d key=textbelt --silent)

	# Résultat de l'envoi.
	if [ $? -eq 1 ]
	then
		return 1
	else
		return $(echo $result | grep -c -E "{\"success\":false,")
	fi
}


#Exécution.
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
