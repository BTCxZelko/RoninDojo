#!/bin/bash

RED='\033[0;31m'
# used for color with ${RED}
NC='\033[0m'
# No Color

HEIGHT=22
WIDTH=76
CHOICE_HEIGHT=16
TITLE="Ronin UI"
MENU="Choose one of the following options:"

OPTIONS=(1 "Upgrade Dojo"
         2 "Clean Docker Images"
         3 "Uninstall Dojo"
         4 "Go Back")

CHOICE=$(dialog --clear \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            echo -e "${RED}"
            echo "***"
            echo "Upgrading Dojo in 30s..."
            echo "Use Ctrl+C to exit if needed!"
            echo "***"
            echo -e "${NC}"
            sleep 30s
	   cd ~/dojo/docker/my-dojo
	   sudo ./dojo.sh stop
	   mkdir ~/.dojo > /dev/null 2>&1
	   cd ~/.dojo
	   git clone -b master https://github.com/Samourai-Wallet/samourai-dojo.git
	   sudo cp -rv samourai-dojo/* ~/dojo
	   sed -i '9d' ~/dojo/docker/my-dojo/bitcoin/Dockerfile
	   sed -i '9i             ENV     BITCOIN_URL         https://bitcoincore.org/bin/bitcoin-core-0.19.0.1/bitcoin-0.19.0.1-aarch64-linux-gnu.tar.gz' ~/dojo/docker/my-dojo/bitcoin/Dockerfile
	   sed -i '10d' ~/dojo/docker/my-dojo/bitcoin/Dockerfile
	   sed -i '10i            ENV     BITCOIN_SHA256      c258c6416225afb08c4396847eb3d5da61a124f1b5c61cccb5a2e903e453ce7f' ~/dojo/docker/my-dojo/bitcoin/Dockerfile
	   sed -i '1d' ~/dojo/docker/my-dojo/mysql/Dockerfile
	   sed -i '1i             FROM    mariadb:latest' ~/dojo/docker/my-dojo/mysql/Dockerfile
	   sed -i '12d' ~/dojo/docker/my-dojo/tor/Dockerfile
	   sed -i '12i ENV     GOLANG_ARCHIVE      go1.13.5.linux-arm64.tar.gz' ~/dojo/docker/my-dojo/tor/Dockerfile
	   sed -i '13d' ~/dojo/docker/my-dojo/tor/Dockerfile
	   sed -i '13i ENV     GOLANG_SHA256       227b718923e20c846460bbecddde9cb86bad73acc5fb6f8e1a96b81b5c84668b' ~/dojo/docker/my-dojo/tor/Dockerfile
            cd ~/dojo/docker/my-dojo/	   
            sleep 2s
	   sudo ./dojo.sh upgrade
            bash ~/RoninDojo/Scripts/Menu/ronin-dojo-menu.sh
            # upgrades dojo
        2)
            echo -e "${RED}"
            echo "***"
            echo "Deleting docker dangling images and images of previous versions in 15s..."
            echo "Use Ctrl+C to exit if needed!"
            echo "***"
            echo -e "${NC}"
            sleep 15s
            cd ~/dojo/docker/my-dojo/
            sudo ./dojo.sh clean
            # free disk space by deleting docker dangling images and images of previous versions
            ;; 
        3)
            echo -e "${RED}"
            echo "***"
            echo "Uninstalling Dojo in 30s..."
            echo "***"
            echo -e "${NC}"
            sleep 5s
            echo -e "${RED}"
            echo "***"
            echo "WARNING: This will uninstall Dojo, use Ctrl+C to exit if needed!"
            echo "***"
            echo -e "${NC}"
            sleep 30s
            cd ~/dojo/docker/my-dojo/
            sudo ./dojo.sh uninstall
            # uninstall dojo
            ;;
        4)
            bash ~/RoninDojo/Scripts/Menu/ronin-dojo-menu.sh
            # return to main menu
            ;;
esac
