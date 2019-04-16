#!/bin/bash
# Peatio-repair-installer.sh: Crypto Currency Exchange
# Author: AlgoBasket
# Skype algobasket
# Email algobasket@gmail.com

################################################################
#  Goals of the script:
#  To install the secured crypto currency exchange
#
#  Script by Algobasket.
################################################################
echo -e "\n\n"
echo -e "\033[34;7mInstalling Ruby Build\e[0m"

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL &
sudo apt-get update
rbenv install -v 2.2.7
rbenv global 2.2.7

echo 'SECOND PART INSTALLED SUCCESSFULLY !'
echo 'NOW USE THIRD PART PEATIO-INSTALLER-THREE.sh'
echo -e "\n\n"
