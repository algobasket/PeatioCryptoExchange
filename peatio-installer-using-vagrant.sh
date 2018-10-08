#!/bin/bash
# Peatio-installer-using-vagrant.sh: Crypto Currency Exchange
# Author: AlgoBasket
# Skype algobasket
# Email algobasket@gmail.com

################################################################
#  Goals of the script:
#  To install the secured crypto currency exchange
#
#  Script by Algobasket.
################################################################

sudo apt-get -y install boxes;
sudo apt-get -y update
echo 'WELCOME TO PEATIO CRYPTOCURRENCY EXCHANGE v1.0 (using Vagrant)- DEVELOPED BY ALGOBASKET' | boxes -d diamonds -a hcvc
echo -e "\n\n"
echo -e "\033[34;7mWelcome to Peatio Crypto Exchange v1.0 - Build by Algobasket\e[0m "
echo -e "\n\n"

echo "Installing virtualbox ......."
sudo apt-get -y install virtualbox

echo "Installing vagrant ......."
sudo apt-get -y install vagrant

echo "Vagrant adding box........"
vagrant box add ubuntu/xenial64

echo "Vagrant initialisation....."
vagrant init ubuntu/xenial64


echo "Vagrant up....."
vagrant up

echo "Vagrant halt ......"
vagrant halt
vagrant plugin install vagrant-vbguest

vagrant reload



echo 'AFTER vagrant ssh using peatio-fresh-installer.sh ' | boxes -d peek -a c -s 40x11
echo -e "\n\n"

echo "Vagrant ssh....."
vagrant ssh
