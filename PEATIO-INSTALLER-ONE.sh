#!/bin/bash
# Peatio-fresh-installer.sh: Crypto Currency Exchange
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
echo 'WELCOME TO PEATIO CRYPTOCURRENCY EXCHANGE v1.0 - DEVELOPED BY ALGOBASKET' | boxes -d diamonds -a hcvc
echo -e "\n\n"
echo -e "\033[34;7mWelcome to Peatio Crypto Exchange v1.0 - Build by Algobasket\e[0m "
echo -e "\n\n"

rm -rf peatio
rm -rf ~/.rbenv

sudo apt-get update
sudo apt-get upgrade
sudo apt-get -y install git-core curl zlib1g-dev build-essential \
                     libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 \
                     libxml2-dev libxslt1-dev libcurl4-openssl-dev \
                     python-software-properties libffi-dev

echo -e "\n\n"
echo -e "\033[34;7mInstalling Ruby Environment\e[0m"

cd
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

echo 'FIRST PART INSTALLED SUCCESSFULLY !'
echo 'NOW USE SECOND PART PEATIO-INSTALLER-TWO.sh'
echo -e "\n\n"