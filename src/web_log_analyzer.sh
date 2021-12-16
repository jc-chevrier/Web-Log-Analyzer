#!/bin/bash


# Script de lancement.


# Scripts externes.
GET_SETTING_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/settings/get_setting.sh"
DETECT_ATTACKS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/attacks/detect_attacks.sh"


# Constantes.
TIMEZONE=$("$GET_SETTING_SCRIPT_PATH" "timezone")


# Configuration.
export TZ="$TIMEZONE"


# Exécution.
"$DETECT_ATTACKS_SCRIPT_PATH"
exit $?
