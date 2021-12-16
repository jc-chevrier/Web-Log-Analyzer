#!/bin/bash


# Script d'envoi de n requêtes sur un même URL.


# Envoyer n requêtes.
function send() {
	# Paramètres de fonction.
	URL=$1
	countRequestExpected=$2

	# Envoi des requêtes.
	countRequest=0
	while [ $countRequest -lt $countRequestExpected ]
	do
		result=$(curl $URL --silent)
		countRequest=$((countRequest + 1))
	done

	# Retour.
	return 0
}


# Exécution.
if [ $# -eq 2 ]
then
	send "$1" $2
	exit $?
else
	echo "URL et/ou nombre de requêtes attendu pas renseignés !"
	exit 1
fi
