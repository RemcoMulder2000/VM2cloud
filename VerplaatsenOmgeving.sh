#!/usr/bin/env bash

cd ./cloud/omgevingen/

#LocatieOud
	echo $'\nStaat de omgeving in test, acceptatie of productie?'
	read LocatieOud

#LocatieNieuw
	echo $'\nWaar moet de omgeving heen, test, acceptatie of productie?'
	read LocatieNieuw
#Naam
	echo $'\nWat is de naam van de omgeving?'
	read Naam
	
#Verplaatsen
	mv ./$LocatieOud/$Naam ./$LocatieNieuw/$naam

echo $'\nOmgeving is verplaatst!'
