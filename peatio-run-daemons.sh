#!/bin/bash
# Peatio.sh: Crypto Currency Exchange
# Author: AlgoBasket
# Skype algobasket
# Email algobasket@gmail.com

################################################################
#  Goals of the script:
#  To install the secured crypto currency exchange
#
#  Script by Algobasket.
################################################################

echo 'WELCOME TO PEATIO DAEMONS INSTALLER v1.0 - DEVELOPED BY ALGOBASKET' | boxes -d diamonds -a hcvc
echo -e "\n\n"
echo -e "\033[34;7mWelcome to Peatio Crypto Exchange v1.0 - Build by Algobasket\e[0m "

echo -e "\n\n"
echo -e "\033[34;7mRunning Bitcoin\e[0m"
cd
cd peatio
bitcoind

echo -e "\n\n"
echo -e "\033[34;7mRunning Daemons\e[0m"
bundle exec rake daemons:start

echo -e "\n\n"
echo -e "\033[34;7mRunning Daemons\e[0m"
TRADE_EXECUTOR=4 rake daemons:start


echo 'THANKS FOR INSTALLING PEATIO ENJOY !! CONTACT US ON SKYPE : algobasket | EMAIL : algobasket@gmail.com' | boxes -d peek -a c -s 40x11
echo -e "\n\n"
echo 'Donate us at paypal : algobasket@gmail.com for future contribution' | boxes -d shell -p a1l2
