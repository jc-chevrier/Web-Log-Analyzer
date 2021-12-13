#§/bin/bash


# Script pour obtenir un paramètre de configuration.


# Constantes.
SETTINGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/conf/settings"


# Scripts externes.
MAP_FILE_HAS_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/maps/map_file_has.sh"
MAP_FILE_GET_SCRIPT_PATH="${WEB_LOG_ANALYZER_PATH}/src/utils/maps/map_file_get.sh"


# Obtenir un paramètre de configuration.
function get() {
	# Paramètres de fonction.
	local keySearched="$1"

	# Si la clé cherchée existe.
	"$MAP_FILE_HAS_SCRIPT_PATH" "$SETTINGS_FILE_PATH" "=" "$keySearched"
        if [ $? -eq 0 ]
	then
		# Envoi de la valeur.
		local value=$("$MAP_FILE_GET_SCRIPT_PATH" "$SETTINGS_FILE_PATH" "=" "$keySearched" 1)
		echo "$value"
		# Retour.
		return 0
	else
		# Retour avec un code d'erreur si la clé du paramaètre
		# cherché n'a pas été trouvée.
  		return 1
	fi
}


# Exécution.
if [ $# -eq 1 ]
then
        get "$1"
        if [  $? -eq 0 ]
	then
		exit 0
	else
		echo "Paramètre de configuration cherché non trouvé !"
		exit 1
	fi
else
	echo "Clé du paramètre de configuration cherché non renseignée !"
	exit 1
fi
