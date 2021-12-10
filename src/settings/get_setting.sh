#§/bin/bash


# Script d'extraction d'un paramètre de configuration.


# Constantes.
SETTINGS_FILE_PATH="${WEB_LOG_ANALYZER_PATH}/conf/settings"


# Fonction d'extraction des paramètres de configuration.
function parse() {
	# Paramètres.
	keySearched=$1

        # Pour chaque ligne dans les paramètres de configuration.
        while read line;
        do
		# Si la ligne n'est pas un commentaire.
		if [ $(echo $line | grep -c -E "^.*#.*$") -eq 0 ]
		then
			oldIFS=$IFS
			IFS="="
			found=0
			# Pour le couple clé valeur du paramètre.
			for keyOrValue in $line
			do
				# Si la clé du paramètre est la bonne.
				if [ $found -eq 1 ]
				then
					# Affichage la valeur du paramètre.
					echo "$keyOrValue"
					return 0
				else
					# Si la clé est égale à la clé du paramètre cherché.
 		                	if [ "$keyOrValue" == "$keySearched" ]
        	                	then
	                                	found=1
                	        	else
						# Passage à une autre ligne.
                        	        	break
                        		fi
				fi
			done
			IFS=$oldIFS
		fi
        done < "$SETTINGS_FILE_PATH"

  	return 1
}


# Exécution.
if [ $# -eq 1 ]
then
	if [ -f "$SETTINGS_FILE_PATH" ]
	then
        	parse "$1"
        	if [ $? -eq 0 ]
		then
			exit 0
		else
			echo "Paramètre de configuration cherché non trouvé !"
			exit 1
		fi
	else
        	echo "Ficher $SETTINGS_FILE_PATH introuvable !"
        	exit 1
	fi
else
	echo "Clé du paramètre de configuration cherché non renseignée !"
	exit 1
fi
