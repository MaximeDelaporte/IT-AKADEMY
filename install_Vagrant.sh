#!/bin/sh
until [ "$menu" = "exit" ]
do
echo "Bienvenue dans l application BashVagrant"
"Vous allez commencer l installation d'un vagrant sur votre ordinateur"
"Vous pouvez quitter a tout moment en tapant exit"
read -p "Voulez-vous continuer ? [Y/N] " first
	if  [ "$first" = "Y" ] || [ "$first" = "y" ] || "$first" = "yes" ];then
		$(dpkg-query -W -f='${Status}' virtualbox 2>/dev/null | grep -c "ok installed")
		if [ $(dpkg-query -W -f='${Status}' virtualbox 2>/dev/null | grep -c "ok installed") -eq 0];then
			echo "Installation de VirtuaBox"
			apt-get install virtualbox
		fi
                $(dpkg-query -W -f='${Status}' vagrant 2>/dev/null | grep -c "ok installed")
                if [ $(dpkg-query -W -f='${Status}' vagrant 2>/dev/null | grep -c "ok installed") -eq 0];then
                        echo "Installation de VirtuaBox"
                        apt-get install vagrant
		vagrant init
		read -p "Choisissez votre box '\n' 
		[1 = ubuntu/xenial64] '\n'
		[2 = ubuntu/trusty64] '\n'
		Taper exit pour quitter " box
		if [ "$box" = "1" ]; then
    			sed -i -e 's/base/ubuntu\/xenial64/g' Vagrantfile
		elif [ "$box" = "2" ]; then
    			sed -i -e 's/base/ubuntu\/trusty64/g' Vagrantfile
		elif [ "$box" = "exit" ];then
        		$menu="exit"
		else 
    			read -p "Cette option n'est pas disponible, veuillez taper 1 ou 2" box
		fi
    		sed -i -e 's/  \# config.vm.network "private_network", ip: "192.168.33.10"/  config.vm.network "private_network", ip: "192.168.33.10"/g' Vagrantfile
    		read -p "Souhaitez-vous modifier les noms et chemin par défaut ? (data et /var/www/html)  ? [Y/N] " rename
    		if [ "$rename" = "n"  ] || [ "$rename" = "N" ] || [ "$rename" = "no" ]; then
        		sed -i -e 's/  \# config.vm.synced_folder "..\/data", "\/vagrant_data"/  config.vm.synced_folder "data", "\/var\/www\/html"/g' Vagrantfile  
        		mkdir data  
    		elif [ "$rename" = "y"  ] || [ "$rename" = "Y" ] || [ "$rename" = "yes" ]; then
        		read -p "Indiquez le nom de votre dossier et le chemin de virtualisation en commencant par un /. " namefile pathfile
        		sed -i -e 's=  # config.vm.synced_folder \"..\/data", \"\/vagrant_data\  "=config.vm.synced_folder \"$namefile\", \"$pathfile\"=g' Vagrantfile
        		mkdir $namefile
    		elif [ "$rename" = "exit" ];then
        		$menu="exit"
    		else 
        		read -p "Cette option n'est pas disponible, veuillez taper Y ou N" box
    		fi
		vagrant up
		read -p "Lancer la connexion SSH ? [Y/N] " ssh
		if [ "$ssh" = "y" ] || [ "$ssh" = "Y" ] || [ "$ssh" = "yes" ];then
			vagrant ssh
		elif [ "$ssh" = "exit" ];then
		$menu="exit"
		fi
		read -p "Appuyer sur une touche pour afficher la/les machine(s) virtuelle(s) existante(s)" mv
		vagrant status
		read -p "Appuyer sur une touche pour quitter l'installation" quit
		exit 0 
	elif [ "$first" = "N" ] || [ "$first" = "n" ] || [ "$first" = "no" ] || [ "$first" = "exit" ];then
	$menu="exit"
	fi
done
read -p "Voulez-vous arrêter l'installation ? [Y/N]" end
if [ "$end" = "Y" ] || [ "$end" = "y" ] || "$end" = "yes" ];then
	exit 0
elif [ "$end" = "N" ] || [ "$end" = "n" ] || "$end" = "no" ];then
	$menu="1"
	break
else
	read "Je n'ai pas compris,  veuillez réponse par Y ou N pour arrêter l'installation" end
fi
