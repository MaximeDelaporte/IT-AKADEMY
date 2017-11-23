#!/bin/sh
menu=on
clear
RED='\033[0;31m'
GREEN='\033[0;32m'
LBLUE='\033[1;34m'
NC='\033[0m'
until [ "$menu" = "exit" ]
do
echo "Bienvenue dans l application BashVagrant" 
echo -e "Vous allez commencer l installation d'un ${LBLUE}vagrant${NC} sur votre ordinateur" 
echo "Vous pouvez quitter a tout moment en tapant exit"
read -p  "Voulez-vous continuer ? [Y/N] " first
	if  [ "$first" = "Y" ] || [ "$first" = "y" ] || [ "$first" = "yes" ];then
		dpkg-query -W -f='${Status}' virtualbox 2>/dev/null | grep -c "ok installed"
		if [ $(dpkg-query -W -f='${Status}' virtualbox 2>/dev/null | grep -c "ok installed") -eq 0 ];then
			echo "Installation de VirtuaBox"
			apt-get install virtualbox
		fi
                dpkg-query -W -f='${Status}' vagrant 2>/dev/null | grep -c "ok installed"
                if [ $(dpkg-query -W -f='${Status}' vagrant 2>/dev/null | grep -c "ok installed") -eq 0 ];then
                        echo "Installation de VirtuaBox"
                        apt-get install vagrant
		fi
		clear
		if [ -f Vagrantfile ];then
			echo -e "Un ${RED}Vagrantfile${NC} existe déjà dans ce dossier"
			read -p "Voulez-vous le supprimer ? [Y/N] " deleteVagrant
			if [ "$deleteVagrant" = "Y" ] || [ "$deleteVagrant" = "y" ] || [ "$deleteVagrant" = "yes" ];then
				rm Vagrantfile
				vagrant init
			elif [ "$deleteVagrant" = "N" ] || [ "$deleteVagrant" = "n" ] || "$deleteVagrant" = "no" ];then
				echo -e "Le fichier ${LBLUE}Vagrantfile${NC} a été conservé"
				read -p next
			else
				read -p "Votre commande n est pas correcte , veuillez répondre par Y ou N " deleteVagrant
			fi
		else
			vagrant init
		fi
		clear
		echo "Choisissez votre box" 
		echo -e "[1 =${LBLUE} ubuntu/xenial64${NC}]"
		echo -e "[2 = ${LBLUE}ubuntu/trusty64${NC}] "
		read -p "[exit pour quitter] " box
		if [ "$box" = "1" ]; then
    			sed -i -e 's/base/ubuntu\/xenial64/g' Vagrantfile
		elif [ "$box" = "2" ]; then
    			sed -i -e 's/base/ubuntu\/trusty64/g' Vagrantfile
		elif [ "$box" = "exit" ]; then
        		menu= "exit"
		else 
    			read -p "Cette option n'est pas disponible, veuillez taper 1 ou 2" box
		fi
    		sed -i -e 's/  \# config.vm.network "private_network", ip: "192.168.33.10"/  config.vm.network "private_network", ip: "192.168.33.10"/g' Vagrantfile
    		clear
		read -p "Souhaitez-vous modifier les noms et chemin par défaut ? (data et /var/www/html)  ? [Y/N] " rename
    		if [ "$rename" = "n"  ] || [ "$rename" = "N" ] || [ "$rename" = "no" ]; then
        		sed -i -e 's/  \# config.vm.synced_folder "..\/data", "\/vagrant_data"/  config.vm.synced_folder "data", "\/var\/www\/html"/g' Vagrantfile  
        		mkdir data  
    		elif [ "$rename" = "y"  ] || [ "$rename" = "Y" ] || [ "$rename" = "yes" ]; then
        		read -p "Indiquez le nom de votre dossier et le chemin de virtualisation en commencant par un /. " namefile pathfile
        		sed -i -e 's=  # config.vm.synced_folder \"..\/data", \"\/vagrant_data\  "=config.vm.synced_folder \"$namefile\", \"$pathfile\"=g' Vagrantfile
        		mkdir $namefile
    		elif [ "$rename" = "exit" ];then
        		menu= "exit"
    		else 
        		read -p "Cette option n'est pas disponible, veuillez taper Y ou N" box
    		fi
		vagrant up
		clear
		read -p "Lancer la connexion SSH ? [Y/N] " ssh
		if [ "$ssh" = "y" ] || [ "$ssh" = "Y" ] || [ "$ssh" = "yes" ];then
			vagrant ssh
		elif [ "$ssh" = "exit" ];then
			menu= "exit"
		fi
		read -p "Appuyer sur une touche pour afficher la/les machine(s) virtuelle(s) existante(s)" mv
		vagrant status
		read -p "Appuyer sur une touche pour quitter l'installation" quit
		clear
		exit 1 
	elif [ "$first" = "N" ] || [ "$first" = "n" ] || [ "$first" = "no" ] || [ "$first" = "exit" ];then
		menu="exit"
	else
		read -p "Je n'ai pas compris, veuillez réponse par Y ou par N" first 
	fi
done
clear
read -p "L installation va s'arreter " end
exit 1
