#!/usr/bin/env bash

#netwerk
ww=10 #webserver IP
db=20 #database IP
lb=30 #loadbalance IP

echo "eigen naam"
read naam

    #omgeving
    echo $'\n Welke omgeving is het, test, productie of acceptatie?'
    read omgeving
    cd /home/vagrant/cloud/omgevingen/$omgeving/
    echo $'\nJe bevindt je nu in de '$omgeving' omgeving'
    
    
    #klantnaam
    echo $'\nNaam klant?'
    read klantnaam
    mkdir $klantnaam
    echo $'\nDe map '$klantnaam'/ is aangemaakt'
    cd $klantnaam/
    touch Vagrantfile
    echo "Vagrant.configure(\"2\") do |config|" >> Vagrantfile
    echo $'\nVagrantfile is aangemaakt'

    #netwerkreeks
    echo "Wat is de netwerkreeks? Subnet is automatisch 24. Voorbeeld om in te vullen: 192.168.1"
    read netwerk

    #webservers
    echo "Hoeveel webservers wil je?"
    read aantalwebservers
        if ! [[ "$aantalwebservers" =~ ^[0-9]+$ ]]
            then
            echo "Sorry, geef een aantal tussen 0 en 9 op."
        fi

        #push into vagrantfile
        if [ "$aantalwebservers" -gt "0" ]
            then
            for (( w=1; w<="$aantalwebservers"; w++ ))
            do
            ww=$((ww+1))
                echo "config.vm.define \"$klantnaam-web$w\" do |webconfig|
     webconfig.vm.box = \"ubuntu/xenial64\"
     webconfig.vm.hostname = \"$klantnaam-web$w\"
     webconfig.vm.network :private_network, ip: \"$netwerk.$ww\"
     webconfig.ssh.insert_key= false
     webconfig.ssh.private_key_path = [\"/home/vagrant/.ssh/id_rsa\",\"~/.vagrant.d/insecure_private_key\"]
     webconfig.vm.provision \"file\", source: \"~/.ssh/id_rsa.pub\", destination: \"~/.ssh/authorized_keys\"
     webconfig.vm.provider \"virtualbox\" do |vb|
       vb.name = \"$klantnaam-web$w\"
       vb.memory = 256
       vb.cpus = 2
      end
    end" >> Vagrantfile
            done
            echo $'\nWebservers toegevoegd'
        else
            echo "Geen webservers toegevoegd"
        fi

    #database servers
    echo "Hoeveel database servers wil je?"
    read aantaldbservers
        if ! [[ "$aantaldbservers" =~ ^[0-9]+$ ]]
    then
        echo "Sorry, geef een aantal tussen 0 en 9 op."
    fi

    #push into vagrantfile
        if [ "$aantaldbservers" -gt "0" ]
            then
            for (( w=1; w<="$aantaldbservers"; w++ ))
            do
            db=$((db+1))
                echo "config.vm.define \"$klantnaam-db$w\" do |dbconfig|
     dbconfig.vm.box = \"ubuntu/xenial64\"
     dbconfig.vm.hostname = \"$klantnaam-db$w\"
     dbconfig.vm.network :private_network, ip: \"$netwerk.$db\"
     dbconfig.ssh.insert_key= false
     dbconfig.ssh.private_key_path = [\"/home/vagrant/.ssh/id_rsa\",\"~/.vagrant.d/insecure_private_key\"]
     dbconfig.vm.provision \"file\", source: \"~/.ssh/id_rsa.pub\", destination: \"~/.ssh/authorized_keys\"
     dbconfig.vm.provider \"virtualbox\" do |vb|
       vb.name = \"$klantnaam-db$w\"
       vb.memory = 256
       vb.cpus = 2
      end
    end" >> Vagrantfile

            done
            echo $'\nDatabase servers toegevoegd'
        else
            echo "Geen database servers gemaakt"
        fi

    #loadbalancer servers
    echo "Hoeveel loadbalancer wil je?"
    read aantallbservers
        if ! [[ "$aantallbservers" =~ ^[0-9]+$ ]]
    then
        echo "Sorry, geef een aantal tussen 0 en 9 op."
    fi

    #push into vagrantfile
        if [ "$aantallbservers" -gt "0" ]
            then
            for (( w=1; w<="$aantallbservers"; w++ ))
            do
            lb=$((lb+1))
                echo "config.vm.define \"$klantnaam-lb$w\" do |lbconfig|
     lbconfig.vm.box = \"ubuntu/xenial64\"
     lbconfig.vm.hostname = \"$klantnaam-lb$w\"
     lbconfig.vm.network :private_network, ip: \"$netwerk.$lb\"
     lbconfig.ssh.insert_key= false
     lbconfig.ssh.private_key_path = [\"/home/vagrant/.ssh/id_rsa\",\"~/.vagrant.d/insecure_private_key\"]
     lbconfig.vm.provision \"file\", source: \"~/.ssh/id_rsa.pub\", destination: \"~/.ssh/authorized_keys\"
     lbconfig.vm.provider \"virtualbox\" do |vb|
       vb.name = \"$klantnaam-lb$w\"
       vb.memory = 256
       vb.cpus = 2
      end
    end" >> Vagrantfile
            done
            echo $'\nLoadbalancers toegevoegd'
        else
            echo "Geen database servers gemaakt"
        fi


echo "end" >> Vagrantfile
echo "vagrant status checken..."
( cd /home/vagrant/cloud/omgevingen/$omgeving/$klantnaam ; vagrant status )
echo "Vagrant file is klaar"
echo $'\nChecken of SSH juist ingesteld is...'

    #ssh checking
    ssh=$(grep -r "StrictHostKeyChecking no" "/etc/ssh/ssh_config")
    if [ "$ssh" == "StrictHostKeyChecking no" ]
    then
        echo "SSH is juist geconfigureerd"
    else
        echo "StrictHostKeyChecking no" | sudo tee -a /etc/ssh/ssh_config
    fi
vagrant up
echo "klaar, bedankt voor het gebruik!"
