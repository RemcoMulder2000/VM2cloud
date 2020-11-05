#!/usr/bin/env bash

#omgeving
echo $'\nStaat de VM in test, acceptatie of productie?'
read omgeving

#klant
echo $'\nWat is de naam van de klant?'
read klant

cd ./cloud/omgevingen/$omgeving/$klant/
vagrant up
