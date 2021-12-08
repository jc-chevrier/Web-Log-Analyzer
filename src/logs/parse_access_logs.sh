#!/bin/bash


# Script d'analyse du fichier des logs d'accès d'Apache :
# "/var/log/apache2/access.log"


# Constantes.
LOGS_FILE_PATH="/var/log/apache2/access.log"


# Variables globales.
logs=()
countLogs=0


# Fonction d'extraction des logs.
function extract() {
	logs=()
        countLogs=0

	while read line;
	do
 		local IPAddressClient=$(echo $line | grep -o -E "^([0-9]{1,3}\.){3}[0-9]{1,3}")

 		local timestamp=$(echo $line | grep -o -E "\[[^ ]+" | sed "s/\[//g")

 		local command=$(echo $line | grep -o -E "\".+\"" | grep -o -E "^\"[^\"]+" | sed "s/\"//g")
 		local method=$(echo $command | grep -o -E "^[^ ]+")
 		local URI=$(echo $command | grep -o -E " .+ " | sed "s/ //g")
		local HTTPVersion=$(echo $command | grep -o -E " [^ ]+$" | sed "s/ //g")

                #TODO navigateur web extraction

		logs+=("$IPAddressClient ; $timestamp ; $method ; $URI ; $HTTPVersion")
 		countLogs=$((countLogs + 1))
	done < $LOGS_FILE_PATH

	return 0
}


# Fonction d'affichage des logs extraits.
function show() {
        oldIFS=$IFS
	IFS=""

	for log in ${logs[@]}
	do
    		echo "[${log}]."
	done

	IFS=$oldIFS

	echo "Total : $countLogs."

	return 0
}


# Exécutuion.
if [ -f "$LOGS_FILE_PATH" ]
then
	extract && show
	exit 0
else
	echo "Ficher $LOGS_FILE_PATH introuvable !"
	exit 1
fi
