#!/bin/bash


# Script de listing des noms des utilisateurs responsables
# sécurité, à notifier en cas d'attaques.


# Constantes.
USER_LIST_DATA_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/users/list_users_datas.sh"


# Exécution.
if [ -f "$USER_LIST_DATA_SCRIPT_PATH" ]
then
	bash "$USER_LIST_DATA_SCRIPT_PATH" 0
	exit 0
else
	echo "Script $USER_LIST_DATA_SCRIPT_PATH introuvable !"
	exit 1
fi
