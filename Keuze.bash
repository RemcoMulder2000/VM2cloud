#!/usr/bin/env bash

echo $'\n Wilt u een omgeving aanmaken, wijzigen, verwijderen of verplaatsen?'
read keuze
if ! [[ 'keuze' = 'aanmaken' ]]
     
	then 
		cd ./AanmakenOmgeving
		
	elif [[ 'keuze' = 'wijzigen'
		cd ./WijzigenOmgeving
		
	elif [[ 'keuze' = 'verwijderen' ]]
		cd ./VerwijderenOmgeving
		
	elif [[ 'keuze' = 'verplaatsen' ]]
		cd ./VerplaatsenOmgeving
	
    else 
		echo $'\n Er is iets fout gegaan porbeer het opnieuw.'
fi	 
	 exit 