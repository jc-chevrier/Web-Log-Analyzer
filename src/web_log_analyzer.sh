#!/bin/bash


# Script de lancement.


# Constantes.
DETECT_ATTACKS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/attacks/detect_attacks.sh"


# Exécution.
bash "$DETECT_ATTACKS_SCRIPT_PATH"
exit $?
