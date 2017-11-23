#!/bin/sh
until [ "$
vagrant init
read -p "Choisissez votre box '\n' 
[1 = ubuntu/xenial64] '\n'
[2 = ubuntu/trusty64] " box
if [ "$box" = "1" ]; then
    sed -i -e 's/base/ubuntu\/xenial64/g' Vagrantfile
    sed -i -e 's/  \# config.vm.network "private_network", ip: "192.168.33.10"/  config.vm.network "private_network", ip: "192.168.33.10"/g' Vagrantfile
    read -p "Souhaitez-vous modifier les noms par défaut (data et le path)  ? Y/n " rename
    if [ "$rename" = "n"  ]; then
        sed -i -e 's/  \# config.vm.synced_folder "..\/data", "\/vagrant_data"/  config.vm.synced_folder "data", "\/var\/www\/html"/g' Vagrantfile  
        mkdir data  
    else
        read -p "Indiquez le nom de votre dossier et le chemin de celui-ci. " namefile pathfile
        sed -i -e 's=  # config.vm.synced_folder \"..\/data", \"\/vagrant_data\  "=config.vm.synced_folder \"$namefile\", \"$pathfile\"=g' Vagrantfile
        mkdir $namefile 
    fi
vagrant up
vagrant ssh
fi
