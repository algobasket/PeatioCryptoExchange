fuser -k 3000/tcp
kill -9 `cat tmp/pids/server.pid`
echo ""
echo ""
echo "                0111001101110"
echo "              10001110101011000"
echo "             01011100100111010000"
echo "            10000001101         001"
echo "          01110011001"
echo "        00000011000"
echo "      01001000000           APP READY!!!"
echo "     11000110111            Ruby on Rails"
echo "    010101101110"
echo "   011101000010"
echo "  0000001000010"
echo "  01000010010000"
echo "  100100001001000"
echo " 0100100001001000"
echo "010010000100100001"
echo "0010000100100001tQn"
echo ""
echo "" 
sudo service nginx restart
bundle exec rails s -p 3000
