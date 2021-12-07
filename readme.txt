Application :
Web Log Analyzer


---------------------------------------------------------------------------------------------
Description :
Solution de monitoring de logs :
- analyse de logs pour la détection d'attaques sur les serveurs web Apache2, en 
  environnement linux ;
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

Se procurer une machine avec un OS linux.

Ouvrir un terminal bash.

Installer apache2.

Installer mailutils.
  Pendant l'intallation, choississez l'option "Internet Configuration", et définissez 
  l'e-mail que vous souhaitez associé à votre machine.   

Installer curl.

Autoriser l'envoi d'e-mail sur le réseau que vous utilisez pour vous connectez à 
internet sur votre machine. 
Par défaut, sur les boxs par exemple, l'envoi d'e-mail est bloqué.

Renseigner une clé pour l'API SMS dans le fichier conf/sms_api_textbelt_key.conf. 
Si elle n'est pas renseignée, pas plus d'un SMS par jour ne pourra être envoyé par 
l'application.
URL pour acheter une clé de l'API en question : https://textbelt.com/purchase/?generateKey=1. 

Exporter le chemin de l'application : 
export WEB_LOG_ANALYZER_PATH="CHEMIN_DE_L_APPLICATION_SUR_MA_MACHINE" 


----------------------------------------------------------------------------------------------
Exécution :
bash CHEMIN_DE_LA_SOLUTION_SUR_MA_MACHINE/src/main.sh
