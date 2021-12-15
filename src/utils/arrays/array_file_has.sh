#!/bin/bash


# Script pour savoir si un tableau sous forme de
# fichier contient un élément.


# Scripts externes
ARRAY_FILE_COUNT_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/arrays/array_file_count.sh"


# Savoir si un élément est contenu dans un tableau.
function has() {
	# Paramètres de fonction.
	local arrayFilePath="$1"
	local indexSearched=$2

	# Vérification.
	local count=$("$ARRAY_FILE_COUNT_SCRIPT_PATH" "$arrayFilePath")
	test $indexSearched -ge 0 -a $indexSearched -lt $count

	# Retour.
	return $?
}


# Exécution.
if [ $# -eq 2 ]
then
	has "$1" $2
	exit $?
else
	echo "Chemin du tableau et/ou index cherché non renseigné(s) !"
	exit 1
fi
