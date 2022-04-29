#!/bin/bash
setupMachines()
{

    if [ $1 == "nodo1" ];
    then       
        echo "Setting up Haproxy Machine"
        echo "instalando snap lxd"
        sudo apt-get update -y
        sudo snap install lxd -y
        sudo apt-get install criu -y
        echo "---------------------------"
        echo "Creando nuevo grupo lxd"
        newgrp lxd
        lxd init --auto
        echo "---------------------------"
        echo "lanzando la imagen de un contener ubuntu :haproxy"
        sleep 20
        lxc launch ubuntu:18.04 haproxy 
        sleep 10    
        echo "---------------------------"
        echo "Limitando memoria del contendor a un consumo de 64MB"
        lxc config set haproxy limits.memory 64MB
        echo "---------------------------"
        echo "Updating"
        lxc exec haproxy -- sudo apt-get clean -y
        lxc exec haproxy -- sudo apt-get update -y
        sleep 10
        echo "Installing haproxy and enable it"
        lxc exec haproxy -- sudo apt-get install haproxy -y
        lxc exec haproxy -- systemctl enable haproxy
        echo "Creating haproxy proxy"
        lxc config device add haproxy http proxy listen=tcp:0.0.0.0:80 connect=tcp:127.0.0.1:80 || true
    fi

    if [ $1 == "nodo2" ]
    then
        echo "Setting up  Machine2"
        echo "instalando snap lxd"
        sudo apt-get update -y
        sudo snap install lxd -y
        sudo apt-get install criu -y
        echo "---------------------------"
        echo "Creando nuevo grupo lxd"
        newgrp lxd
        lxd init --auto

        sleep 20
        echo "---------------------------"
        echo "lanzando la imagen de un contener ubuntu :web y AI"
        lxc launch ubuntu:18.04 web2 
        lxc launch ubuntu:18.04 AI2
        sleep 10

        sleep 10
    
        echo "---------------------------"
        echo "Limitando memoria del contendor a un consumo de 64MB"
        lxc config set web2 limits.memory 64MB
        lxc config set AI2 limits.memory 64MB
        echo "---------------------------"
        echo "Updating and upgrading"
        lxc exec web2 -- apt-get update -y
        lxc exec AI2 -- apt-get update  -y
        echo "instalación de servidor apache"
        lxc exec web2 -- apt install apache2 -y
        lxc exec AI2 -- apt install apache2 -y

        echo "------------------------------------------------"
        echo "Montando servicio web y AI en el contenedor"
        lxc exec web2 -- systemctl restart apache2
        lxc exec AI2 -- systemctl restart apache2
        echo "-------------deploying AI service --------------"
        #lxc exec AI -- echo '<!DOCTYPE html><html><body><embed src="https://experiments.withgoogle.com/ai/ai-duet/view/" width="100%" height="580"></body></html>' > /var/www/html/index.html
        lxc exec AI2 -- rm /var/www/html/index.html
        lxc file push ai/index.html -- AI2/var/www/html/
        echo "-----------deploying web service --------------"
        #lxc exec web -- echo '<!DOCTYPE html><html><body><embed src="https://supermarioemulator.com/mario.php" width="100%" height="580"></body></html>' > /var/www/html/index.html
        lxc exec web2 -- rm /var/www/html/index.html
        lxc file push mario/index.html -- web2/var/www/html/
        echo "------------------------------------------------"

        echo "------------------------------------------------"
        echo "----------------Restarting web services------------------------"
        lxc exec web2 -- systemctl restart apache2
        lxc exec AI2 -- systemctl restart apache2
        echo "------------------------------------------------"


        echo "----------------Creatin proxy devices for machine2------------------------"
        lxc config device add AI2 myAI2port80 proxy listen=tcp:192.168.110.22:5080 connect=tcp:127.0.0.1:80 || true
        lxc config device add web2 myweb2port80 proxy listen=tcp:192.168.110.22:5082 connect=tcp:127.0.0.1:80 || true
        
    fi

    if [ $1 == "nodo3" ]
    then
        echo "Setting up  Machine3"
        echo "instalando snap lxd"
        sudo apt-get update -y
        sudo snap install lxd -y
        sudo apt-get install criu -y
        echo "---------------------------"
        echo "Creando nuevo grupo lxd"
        newgrp lxd
        lxd init --auto

        echo "---------------------------"
        echo "lanzando la imagen de un contener ubuntu :web y AI"
        lxc launch ubuntu:18.04 web3
        lxc launch ubuntu:18.04 AI3 
        sleep 10

        sleep 10

        echo "---------------------------"
        echo "Limitando memoria del contendor a un consumo de 64MB"
        lxc config set web3 limits.memory 64MB
        lxc config set AI3 limits.memory 64MB
        echo "---------------------------"
        echo "Updating and upgrading"
        lxc exec web3 -- apt-get update -y
        lxc exec AI3 -- apt-get update  -y
        echo "instalación de servidor apache"
        lxc exec web3 -- apt install apache2 -y
        lxc exec AI3 -- apt install apache2 -y

        echo "------------------------------------------------"
        echo "Montando servicio web y AI en el contenedor"
        lxc exec web3 -- systemctl restart apache2
        lxc exec AI3 -- systemctl restart apache2
        echo "-------------deploying AI service --------------"
        #lxc exec AI -- echo '<!DOCTYPE html><html><body><embed src="https://experiments.withgoogle.com/ai/ai-duet/view/" width="100%" height="580"></body></html>' > /var/www/html/index.html
        lxc exec AI3 -- rm /var/www/html/index.html
        lxc file push ai/index.html -- AI3/var/www/html/
        echo "-----------deploying web service --------------"
        #lxc exec web -- echo '<!DOCTYPE html><html><body><embed src="https://supermarioemulator.com/mario.php" width="100%" height="580"></body></html>' > /var/www/html/index.html
        lxc exec web3 -- rm /var/www/html/index.html
        lxc file push mario/index.html -- web3/var/www/html/
        echo "------------------------------------------------"

        echo "------------------------------------------------"
        echo "----------------Restarting web services------------------------"
        lxc exec web3 -- systemctl restart apache2
        lxc exec AI3 -- systemctl restart apache2
        echo "------------------------------------------------"


        echo "----------------Creatin proxy devices for machine 3------------------------"
        lxc config device add AI3 myAI3port80 proxy listen=tcp:192.168.110.23:5080 connect=tcp:127.0.0.1:80 || true
        lxc config device add web3 myweb3port80 proxy listen=tcp:192.168.110.23:5082 connect=tcp:127.0.0.1:80 || true
        
    fi
}

setupMachines $1