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
sudo apt install -y ffmpeg
sudo apt install -y mplayer
sudo apt-get update
#mplayer https://techibeats.files.wordpress.com/2011/12/sandstorm.mp3  > /dev/null 2>&1;
mplayer -noconsolecontrols -really-quiet 2>/dev/null https://techibeats.files.wordpress.com/2011/12/sandstorm.mp3 &

sudo apt-get -y install boxes;
sudo apt-get update
echo 'WELCOME TO PEATIO CRYPTOCURRENCY EXCHANGE v1.0 (Repair Installer) - DEVELOPED BY ALGOBASKET' | boxes -d diamonds -a hcvc
echo -e "\n\n"
echo -e "\033[34;7mWelcome to Peatio Crypto Exchange v1.0 - Build by Algobasket\e[0m "
echo -e "\n\n"

echo -e "\033[33;7mRemoving all previous version and dependencies if any...\e[0m"
echo -e "\033[35;7mRemoving Lock Files\e[0m"
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock
sudo apt-get update
echo -e "\n\n"
echo -e "\033[34;7m- uninstalling nginx ..\e[0m"
sudo service nginx stop
sudo apt-get purge nginx*;
sudo apt-get purge nginx;
sudo apt-get update
sudo apt-get remove nginx*;
sudo apt-get remove nginx;
sudo apt-get autoremove
sudo apt-get clean
sudo apt-get purge nginx-extras*;
sudo apt-get purge nginx-extras;
sudo apt-get update
sudo apt-get remove nginx-extras*;
sudo apt-get remove nginx-extras;
sudo apt-get autoremove
sudo apt-get clean



echo -e "\n\n"
echo -e "\033[34;7m- uninstalling passenger ..\e[0m"
sudo apt-get purge passenger*;
sudo apt-get purge passenger;
sudo apt-get remove passenger*;
sudo apt-get remove passenger;
sudo apt-get autoremove
sudo apt-get clean


echo -e "\n\n"
echo -e "\033[34;7m- uninstalling Ruby ..\e[0m"
sudo apt-get purge ruby*

echo -e "\n\n"
echo -e "\033[34;7m- uninstalling MYSQL  ..\e[0m"

sudo apt-get remove --purge mysql-server mysql-client mysql-common -y
sudo apt-get autoremove -y
sudo apt-get autoclean
rm -rf /etc/mysql
sudo find / -iname 'mysql*' -exec rm -rf {} \;
echo -e "\n\n"
echo -e "\033[34;7m- uninstalling REDIS  ..\e[0m"

sudo systemctl stop redis
sudo systemctl disable redis
cd redis-stable
sudo make uninstall
sudo deluser redis

echo -e "\n\n"
echo -e "\033[34;7m- uninstalling Rabbitmq-server  ..\e[0m"
sudo -u rabbitmq rabbitmqctl stop
sudo apt-get remove rabbitmq-server
sudo apt-get remove --auto-remove rabbitmq-server
sudo apt-get purge rabbitmq-server
sudo apt-get purge --auto-remove rabbitmq-server
sudo apt-get autoremove
sudo apt-get clean

echo -e "\n\n"
echo -e "\033[34;7mUpdating and Upgrading the system\e[0m"

echo -e "\n\n"
echo -e "\033[35;7mRemoving Lock Files\e[0m"
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock

echo -e "\n\n"
echo -e "\033[35;7mRemoving ruby environment\e[0m"

rm -rf ~/.rbenv
cd
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

echo -e "\n\n"
echo -e "\033[34;7mInstalling Ruby Build\e[0m"

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc


rbenv install --verbose 2.2.2
rbenv global 2.2.2

echo -e "\n\n"
echo -e "\033[34;7mInstalling Gem\e[0m"
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
gem install bundler
rbenv rehash

echo -e "\n\n"
echo -e "\033[34;7mInstalling MYSQL\e[0m"

sudo apt-get -y install mysql-server  mysql-client  libmysqlclient-dev

echo -e "\n\n"
echo -e "\033[34;7mInstalling REDIS\e[0m"

sudo apt install -y redis-server

echo -e "\n\n"
echo -e "\033[34;7mInstalling RabbitMQ\e[0m"

echo 'deb http://www.rabbitmq.com/debian/ testing main' | sudo tee /etc/apt/sources.list.d/rabbitmq.list
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install rabbitmq-server

sudo rabbitmq-plugins enable rabbitmq_management
sudo service rabbitmq-server restart
wget http://localhost:15672/cli/rabbitmqadmin
chmod +x rabbitmqadmin
sudo mv rabbitmqadmin /usr/local/sbin

echo -e "\n\n"
echo -e "\033[34;7mInstalling Bitcoin\e[0m"

sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get -y install bitcoind

echo -e "\n\n"
echo -e "\033[34;7mConfiguring Bitcoin\e[0m"

mkdir -p ~/.bitcoin
touch ~/.bitcoin/bitcoin.conf
cat <<EOF > ~/.bitcoin/bitcoin.conf
server=1
daemon=1

# If run on the test network instead of the real bitcoin network
testnet=1

# You must set rpcuser and rpcpassword to secure the JSON-RPC api
# Please make rpcpassword to something secure, `5gKAgrJv8CQr2CGUhjVbBFLSj29HnE6YGXvfykHJzS3k` for example.
# Listen for JSON-RPC connections on <port> (default: 8332 or testnet: 18332)
rpcuser=testuser
rpcpassword=testpass
rpcport=18332

# Notify when receiving coins
walletnotify=/usr/local/sbin/rabbitmqadmin publish routing_key=peatio.deposit.coin payload='{"txid":"%s", "channel_key":"satoshi"}'
EOF


echo -e "\n\n"
echo -e "\033[34;7mStarting Bitcoin\e[0m"
#bitcoind

echo -e "\n\n"
echo -e "\033[34;7mInstalling Nginx & Passenger\e[0m"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7

echo -e "\n\n"
echo -e "\033[34;7mAdd HTTPS support to APT\e[0m"
sudo apt-get install -y apt-transport-https ca-certificates

sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update

echo -e "\n\n"
echo -e "\033[34;7mInstalling nginx and passenger\e[0m"
sudo apt-get install -y nginx-extras passenger

sudo rm /etc/nginx/passenger.conf
touch /etc/nginx/passenger.conf

cat <<EOF > /etc/nginx/passenger.conf
passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;
passenger_ruby /home/deploy/.rbenv/shims/ruby;
EOF

sudo sed -i 's+# include /etc/nginx/passenger.conf;+include /etc/nginx/passenger.conf;+g' /etc/nginx/nginx.conf

echo -e "\n\n"
echo -e "\033[34;7mInstalling JavaScript Runtime\e[0m"

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs

echo -e "\n\n"
echo -e "\033[34;7mInstalling ImageMagick\e[0m"

sudo apt-get -y install imagemagick gsfonts

echo -e "\n\n"
echo -e "\033[34;7mSetup production environment variable\e[0m"

echo "export RAILS_ENV=production" >> ~/.bashrc
source ~/.bashrc

echo -e "\n\n"
echo -e "\033[34;7mCloning Stable Peatio Repo\e[0m"

mkdir -p ~/peatio
git clone https://github.com/algobasket/PeatioCryptoExchange.git .
cd peatio

echo -e "\n\n"
echo -e "\033[34;7mInstalling dependency gems\e[0m"

bundle install --without development test --path vendor/bundle

echo -e "\n\n"
echo -e "\033[34;7mPrepare configure files\e[0m"

bin/init_config

echo -e "\n\n"
echo -e "\033[34;7mSetup Pusher\e[0m"

sudo sed -i "s+YOUR_PUSHER_APP+594243+g" config/application.yml
sudo sed -i "s+YOUR_PUSHER_KEY+155f063acccd16c2f04d+g" config/application.yml
sudo sed -i "s+YOUR_PUSHER_SECRET+326c0ae14849b6c6bff5+g" config/application.yml


echo "ENTER YOUR SSH IP OR DOMAIN NAME : " sship
read sship
sudo sed -i "s+URL_HOST: localhost:3000+URL_HOST:${sship}+g" config/application.yml

echo "USE http or https : " protocol
read protocol
sed -i "s+URL_SCHEMA: http+URL_SCHEMA: ${protocol}+g" config/application.yml

echo -e "\n\n"
echo -e "\033[34;7mSetup bitcoind rpc endpoint\e[0m"
echo "Enter Bitcoin Username: " bitcoinusername
read bitcoinusername
sed -i "s+username+${bitcoinusername}+g" config/currencies.yml
echo "Enter Bitcoin Password: " bitcoinpass
read bitcoinpass
sed -i "s+password@+${bitcoinpass}@+g" config/currencies.yml

echo -e "\n\n"
echo -e "\033[34;7mConfig database settings\e[0m"
echo "Enter MySQL Username: " mysqlusername
read mysqlusername
sed -i "s+username: root+username: ${mysqlusername}@+g" config/database.yml
echo "Enter MySQL Password: " mysqlpassword
read mysqlpassword
sed -i "s+password:+password: ${mysqlpassword}@+g" config/database.yml

echo -e "\n\n"
echo -e "\033[34;7mInitialize the database and load the seed data\e[0m"
bundle exec rake db:setup

echo -e "\n\n"
echo -e "\033[34;7mPrecompile assets\e[0m"
bundle exec rake assets:precompile

echo -e "\n\n"
echo -e "\033[34;7mRunning Daemons\e[0m"
#bundle exec rake daemons:start

echo -e "\n\n"
echo -e "\033[34;7mRunning Daemons\e[0m"
#TRADE_EXECUTOR=4 rake daemons:start

echo -e "\n\n"
echo -e "\033[34;7mPassenger Setting\e[0m"
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /home/deploy/peatio/config/nginx.conf /etc/nginx/conf.d/peatio.conf
sudo service nginx restart

echo -e "\n\n"
echo -e "\033[34;7mLiability Proof - Add this rake task to your crontab so it runs regularly\e[0m"

RAILS_ENV=production rake solvency:liability_proof

echo 'THANKS FOR INSTALLING PEATIO ENJOY !! CONTACT US ON SKYPE : algobasket | EMAIL : algobasket@gmail.com' | boxes -d peek -a c -s 40x11
echo -e "\n\n"
echo 'Donate us at paypal : algobasket@gmail.com for future contribution' | boxes -d shell -p a1l2
