Application :
Web Log Analyzer


---------------------------------------------------------------------------------------------
Description :
Solution de monitoring de logs :
- analyse de logs pour la détection d'attaques sur les serveurs web Apache, en 
  environnement Linux ;
- notification d'attaques par e-mail et SMS.


---------------------------------------------------------------------------------------------
Auteurs :
CHEVRIER Jean-Christophe
CHOQUERT Vincent


---------------------------------------------------------------------------------------------
Organisation :
Université de Lorraine


---------------------------------------------------------------------------------------------
Installation :

Se procurer une machine sous environnement Linux.

Ouvrir un terminal bash.

Installer apache2 : sudo apt-get install apache2.

Installer mailutils : sudo apt-get install mailutils.
  Pendant l'intallation, choisir l'option "Site Internet", et définir le domaine
  de votre machine que vous désirez, par exemple "web-log-analyzer.fr".

  Autoriser l'envoi d'e-mail sur le réseau que vous utilisez pour vous connecter à 
  internet sur votre machine. 
  En effet, par défaut, sur les boxs par exemple, l'envoi d'e-mail est bloqué.

  Ou alors, vous pouvez également utiliser un relais d'e-mail, en installant ssmtp et
  en configurant le relais dans la configuration de ssmtp : etc/ssmtp/ssmtp.conf.
  Cette vidéo décrit comment installer ce genre de relais :
  https://www.youtube.com/watch?v=qGRSv9PiAkw.

Installer curl : sudo apt-get install curl.

Renseigner une clé pour l'API SMS dans le fichier conf/settings : clé sms_api_textbelt_key. 
Si elle n'est pas renseignée, pas plus d'un SMS par jour ne pourra être envoyé par la solution.
Voici un URL pour acheter une clé de l'API en question : 
https://textbelt.com/purchase/?generateKey=1. 

Se rendre dans conf/users, pour renseigner les utilisateurs à notifier en cas d'attaque détectée.
Renseigner les utilisateurs ainsi : un utilisateur par ligne, décrit avec ce format :
NOM_UTILISATEUR;ADRESSE_EMAIL_UTILISATEUR;NUMERO_TELEPHONE_UTILISATEUR_AVEC_INDICATEUR_PAYS.
Par exemple: Olivier Dupont:o.dupont.gmail.com;+33...

Se rendre dans conf/settings, pour renseigner les chemins sur votre machine des logs d'accès et 
d'erreur d'Apache : clés access_logs_file_path et error_logs_file_path. Les chemins des logs
varient en fonction des environnements Linux : /var/log/apache2/access.log ou ...,  
/var/log/apache2/error.log ou ...

Facultatif : se rendre dans conf/settings pour personnaliser les paramètres et stratégies.

Exporter le chemin de la solution :
export WEB_LOG_ANALYZER_PATH="CHEMIN_DE_LA_SOLUTION_SUR_MA_MACHINE"


----------------------------------------------------------------------------------------------
Exécution :

En tant qu'utilisateur root :
CHEMIN_DE_LA_SOLUTION_SUR_MA_MACHINE/src/web_log_analyzer.sh
