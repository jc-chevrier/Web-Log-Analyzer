#!/boin/bash


# Script d'envoi d'e-mail.


# Foncion d'envoi d'e-mail.
function send() {
	# Paramètres.
	local recipients=$1
	local subject=$2
	local content=$3

	# Envoi de l'email.
	echo "$content" | mail -a "From: Web Log Analyzer" -s "$subject" $recipients

	# Résultat de l'envoi.
	return $?
}


# Exécution.
if [ $# -eq 3 ]
then
	send "$1" "$2" "$3"
	if [ $? -eq 0 ]
	then
		exit 0
	else
		echo "Echec de l'envoi de l'e-mail !"
		exit 1
	fi
else
	echo "Destinataire(s) et/ou sujet et/ou contenu de l'e-mail non renseigné(s) !"
	exit 1
fi
