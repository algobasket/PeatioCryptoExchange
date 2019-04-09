echo "Starting Server.."
fuser -k 3000/tcp
sudo service nginx restart
bundle exec rails s -p 3000
echo "Server Started ..."
