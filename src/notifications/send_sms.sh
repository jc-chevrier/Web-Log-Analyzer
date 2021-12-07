#!/bin/bash

# Script d'envoi de sms.


# Envoyer un SMS.
function send() {
	phoneNumber=$1
	SMS=$2
	result=$(curl -X POST https://textbelt.com/text \
	--data-urlencode phone="$phoneNumbers" \
	--data-urlencode message="$SMS" \
	-d key=textbelt)
	# TODO analyser le resultat et envoyer le bon code de retour
}


#Exécution.
if [ $# -eq 2 ]
then
	send
	exit 0
else
	echo "Numéro de téléphone, et contenu du SMS non renseigné."
	exit 1
fi
