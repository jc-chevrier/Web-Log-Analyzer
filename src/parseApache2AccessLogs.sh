#!/bin/bash


# Script d'analyse du fichier des logs d'accès d'Apache.


# Constantes.
LOGS_FILE_PATH="/var/log/apache2/access.log"


# Logs
logs=()
countLogs=0


# Fonction d'extraction des logs.
function extract() {
	logs=()
        countLogs=0
	while read line; do
 		IPAddressClient=$(echo $line | grep -o -E "^([0-9]{1,3}\.){3}[0-9]{1,3}")
 		timestamp=$(echo $line | grep -o -E "\[[^ ]+" | sed "s/\[//g")
 		command=$(echo $line | grep -o -E "\".+\"" | grep -o -E "^\"[^\"]+" | sed "s/\"//g")
 		method=$(echo $command | grep -o -E "^[^ ]+")
 		URI=$(echo $command | grep -o -E " .+ " | sed "s/ //g")
		HTTPVersion=$(echo $command | grep -o -E " [^ ]+$" | sed "s/ //g")
                #TODO navigateur web extraction
		logs+=("$IPAddressClient ; $timestamp ; $method ; $URI ; $HTTPVersion")
 		countLogs=$((countLogs + 1))
	done < $LOGS_FILE_PATH
	return 0
}


# Fonction d'affichage des logs extraits.
function show() {
        IFS=""
	for log in ${logs[@]}
	do
    		echo "[${log}]."
	done
	IFS=" "
	echo "Total : $countLogs."
	return 0
}


extract && show


exit 0
