#!/bin/bash

echo "instalando snap lxd"
sudo apt-get update -y
sudo snap install lxd -y
sudo apt-get install criu -y
echo "---------------------------"
echo "Creando nuevo grupo lxd"
newgrp lxd
echo "---------------------------"
echo "Inicalizando el uso del contendor"
lxd init --auto
echo "---------------------------"
echo "lanzando la imagen de un contener ubuntu :web"
lxc launch ubuntu:18.04 web
lxc launch ubuntu:18.04 container1
echo "---------------------------"
echo "Limitando memoria del contendor a un consumo de 64MB"
lxc config set web limits.memory 64MB
lxc config set container1 limits.memory 64MB
echo "---------------------------"
echo "Updating and upgrading"
lxc exec web -- apt-get update && apt-get upgrade -y
lxc exec container1 -- apt-get update && apt-get upgrade -y
echo "instalación de servidor apache"
lxc exec web -- apt install apache2 -y
echo "---------------------------"
echo "Montando servicio web en el contenedor"
lxc exec web -- systemctl restart apache2
echo "---------------------------"

