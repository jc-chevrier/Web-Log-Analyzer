#!/bin/bash


# Script de lancement.


# Constantes.
DETECT_ATTACKS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/attacks/detect_attacks.sh"


# Exécution.
if [ -f "$DETECT_ATTACKS_SCRIPT_PATH" ]
then
	bash "$DETECT_ATTACKS_SCRIPT_PATH"
	exit 0
else
	echo "Script $DETECT_ATTACKS_SCRIPT_PATH introuvable !"
	exit 1
fi
