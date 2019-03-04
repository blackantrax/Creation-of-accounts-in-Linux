# Creation-of-accounts-in-Linux
Ce script permet de creer des utilisateurs sur un systeme Linux

Le script prends en parametre le nom du groupe a creer ainsi qu'un fichier contenant la liste des utilisateurs a creer.

          Usage: ./scriptCreation.sh <Groupe> <fichierUsers>
Apres verification de l'existence du groupe, le script va le creer ainsi qu'un dossier qui servira de <home> au groupe en question
           
           chage -d 0 $username 
Cette commande permet de forcer les utilisateurs a changer de mot de passe apres la premiere connection

Pour chaque utilisateur, on copie le contenu du repertoire </etc/skel> 
          
          Le fichier envoieMail.sh sert de fonciton externe permettant d'envoyer un mail a chaque user creee
          
