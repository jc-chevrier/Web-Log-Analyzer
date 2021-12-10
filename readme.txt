Application :
Web Log Analyzer


---------------------------------------------------------------------------------------------
Description :
Solution de monitoring de logs :
- analyse de logs pour la détection d'attaques sur les serveurs web Apache2, en 
  environnement linux ubuntu ;
- notification d'attaques.


---------------------------------------------------------------------------------------------
Auteurs :
CHEVRIER Jean-Christophe
CHOQUERT Vincent


---------------------------------------------------------------------------------------------
Organisation :
Université de Lorraine


---------------------------------------------------------------------------------------------
Installation :

Se procurer une machine avec un OS linux ubuntu.

Ouvrir un terminal bash.

Installer apache2.

Installer mailutils.
  Pendant l'intallation, choisir l'option "Internet Configuration", et définir l'adresse 
  e-mail associée à la machine qui sera utilisée par la solution.   

Installer curl.

Autoriser l'envoi d'e-mail sur le réseau que vous utilisez pour vous connecter à 
internet sur votre machine. 
En effet, par défaut, sur les boxs par exemple, l'envoi d'e-mail est bloqué.

Renseigner une clé pour l'API SMS dans le fichier conf/settings.conf : sms_api_textbelt_key. 
Si elle n'est pas renseignée, pas plus d'un SMS par jour ne pourra être envoyé par la solution.
URL pour acheter une clé de l'API en question : https://textbelt.com/purchase/?generateKey=1. 

Se rendre dans conf/users pour renseigner les utilisateurs à notifier en cas d'attaque détectée.

Renseigner les utilisateurs ainsi : un utilisateur par ligne, décrit avec ce format :
NOM_UTILISATEUR;ADRESSE_EMAIL_UTILISATEUR;NUMERO_TELEPHONE_UTILISATEUR_AVEC_INDICATEUR_PAYS

Facultatif : se rendre dans conf/settings pour personnaliser les paramètres et stratégies.

Exporter le chemin de l'application :
export WEB_LOG_ANALYZER_PATH="CHEMIN_DE_L_APPLICATION_SUR_MA_MACHINE"


----------------------------------------------------------------------------------------------
Exécution :

En tant qu'utilisateur root :
bash CHEMIN_DE_LA_SOLUTION_SUR_MA_MACHINE/src/main.sh
