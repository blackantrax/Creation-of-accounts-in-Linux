#!/bin/bash

#Permet d'envoyer le username et le mot de passe des utilisateurs

# Recoit comme parametre le username, le nom,le E-mail et le mot de passe de l'utilisateur concerne.

function envoie(){
	echo -e "Bonjour $4\nVoici vos infos utilisateur.\nUsername: $1\nPassword: $2\n\nCEO\nKevin Nelson" | mutt -s "Creation compte" $3 
	echo "Email sent to $4"
}
