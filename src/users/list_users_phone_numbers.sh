#!/bin/bash


# Script de listing des numéro de téléphone des utilisateurs
# responsables sécurité, à notifier en cas d'attaques.


# Constantes.
USER_LIST_DATA_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/users/list_users_datas.sh"


# Exécution.
"$USER_LIST_DATA_SCRIPT_PATH" 2
exit $?
