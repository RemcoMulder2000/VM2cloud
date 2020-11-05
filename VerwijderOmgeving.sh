#!/usr/bin/env bash

#locatie
	echo $'\nStaat de omgeving in test, acceptatie of productie?'
	read locatie
	cd ./cloud/omgevingen/$locatie/

#omgeving
	echo $'\nWat is de naam van de omgeving die verwijderd moet worden?'
	read omgeving
	cd ./$omgeving

#bevestiging
	echo $'\nWeet je zeker dat je '$omgeving' wilt verwijderen (y/n)?'
	read bevestiging
	if ! [[ 'bevestiging' = 'y' ]]
     
	then 
		vagrant destroy
		cd ../
		rm -r $omgeving
		echo $'\nOmgeving verwijderd!'
		
	else 
	
     echo $'verijwderen geannuleerd!'
fi	 
	 echo $'Bedankt voor het gebruiken!' 
