#!/bin/bash
# Author: 	Kev

source envoieMail.sh  # Fonction qui vas permettre l'envoie des informations
well_ended=0
no_root=1
no_file=20
groupe=$1
fichierUsers=$2
gawkInstall=10
utilisateur=$(echo $UID)

nbargs(){
	if [[ $2 -ne 2 ]] ; then
	echo "Syntax error: Vérifiez le nombre d'arguments"
	exit $1  # Termine si le nombre d'arguments est incorrect
	fi
}

userRoot(){
	if [[ $2 -ne 0 ]] ; then
	echo -e "Vous devez exécuter le script de création de comptes \nAvec le compte du superutilisateur \"root\""
	exit $1        # Termine si l'utilisateur qui exécute le Script
		      # n'est pas root
	fi
}

fileExist(){
	if [[ ! -e $2 ]] ; then
	echo "Le fichier $fichierUsers n'existe pas"
	exit $1
	fi
}

installations(){
	if command -v gawk &> /dev/null ; then # Permet de s'assurer que
				       # gawk est installé
	echo "***Vérification des préalables terminé***"
	else
	echo -e "Commande gawk non installée\nInstallez la en faisant \"apt install gawk\", puis relancez le Script"
	exit $1 # Ferme si gawk n'est pas installé
	fi
}

verificationGroupe(){
	gidGroup=$(gawk -F" " '{ if ( $3>=0 ) print $3 }' $fichierUsers | sed -n '2p')
	if getent group $groupe &> /dev/null ; then # On s'assure que le groupe
					    # n'a pas déjà été crée
	echo "Le groupe $groupe existe déjà"
	else
	echo "Le groupe $groupe n'existe pas"
	echo "Creation du groupe $groupe"
	addgroup --gid $gidGroup $groupe
	mkdir /home/$groupe ; chown :$groupe /home/$groupe
	echo "Le gid du groupe est: $gidGroup"
	echo "Fin de création du groupe"
	fi
}

modificationUseradd(){
	sed -i 's/.*SKEL=.*/SKEL=\/etc\/skel/' /etc/default/useradd
}

decompression(){
	unzip ./*.zip -d /etc/skel &> /dev/null
}

ajoutUser(){
	useradd -md /home/$groupe/$1 -k /etc/skel/ -c"$nom $prenom $email" -g $groupe -s /bin/bash $1
	pass=$(openssl rand -base64 48 | cut -c1-8) # Generation du mot de passe
	echo -e "$pass\n$pass\n" | passwd $1 &> /dev/null
	echo $username $pass >> logins_$groupe.txt
}

creationUsers(){
	#gidGroup=$(echo $line | cut -d" " -f3)
	#verificationGroupe $gidGroup  # Fonction permettant de verifier si le groupe existe et de le creer
	echo -e "Le gid de tous le groupe est $gidGroup	"	             #  Si ce n'est pas le cas
	nom=$(echo $line | cut -d" " -f1)
	echo "Le nom $nom"
	prenom=$(echo $line | cut -d" " -f2)
	echo "Le prenom $prenom"
	username=$(echo ${nom:0:2}${prenom:0:4} | tr '[:upper:]' '[:lower:]')
	echo "Le nom d'utilisateur $username"
	email=$(echo $line | cut -d" " -f5)
	echo "Le email $email"
	modificationUseradd
	ajoutUser $username # Creation de l'utilisateur
	envoie $username $pass $email $nom #Envoie de l'email
	chage -d 0 $username # Force le user a changer de mot de passe des la premiere connection
}

netoyageSkel(){
	rm -rf /etc/skel/*
}

finDuProgramme(){
	echo -e "***Fin de la creation***\nAurevoir ! :)"
}

nbargs $well_ended $#
userRoot $no_root $utilisateur
fileExist $no_file $fichierUsers
installations $gawkInstall
verificationGroupe
decompression # Decompression des fichiers
compteur=0
while read -r line <&3; do
	if [[ $compteur -eq 0 ]] ; then
	((compteur++))
	else
	echo -e "******************************\n$line\n*******************************************"
	creationUsers $line
	fi

done 3< $fichierUsers

netoyageSkel # On supprime les fichiers contenus dans /etc/skel

finDuProgramme # END
