#!/bin/bash


# Script pour savoir si un tableau sous forme de
# ligne contient un élément.


# Scripts externes
ARRAY_LINE_COUNT_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/arrays/array_line_count.sh"


# Savoir si un élément est contenu dans un tableau.
function has() {
	# Paramètres de fonction.
	local arrayLine="$1"
	local separator="$2"
	local indexSearched=$3

	# Vérification.
	local count=$("$ARRAY_LINE_COUNT_SCRIPT_PATH" "$arrayLine" "$separator")
	test $indexSearched -ge 0 -a $indexSearched -lt $count

	# Retour.
	return $?
}


# Exécution.
if [ $# -eq 3 ]
then
	has "$1" "$2" $3
	exit $?
else
	echo "Tableau et/ou index cherché non renseigné(s) !"
	exit 1
fi
