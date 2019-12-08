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

OPTIONS=(1 "Start IBD"
         2 "Complete IBD"
         3 "Go Back")

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
            echo "Do you have an existing Node or have the Initial Blockchain Data saved and want to transfer to Dojo?"
            echo -e "${NC}"
            select yn in "Yes" "No"; do
                case $yn in
                    Yes ) break;;
                    No ) bash ~/RoninDojo/Scripts/Menu/ronin-ibd-menu.sh
                esac
            done
            echo -e "${RED}"
            echo "***"
            echo "Stopping Dojo to prepare for IBD..."
            echo "***"
            echo -e "${NC}"
            sudo ~/dojo/docker/my-dojo/dojo.sh stop
            sudo rm -r /mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/blocks
            sudo rm -r /mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/chainstate
            USER=$(sudo cat /etc/passwd | grep 1000 | awk -F: '{ print $1}' | cut -c 1-)
            echo -e "${RED}"
            echo "***"
            echo "Copy and paste the following commands in the bitcoin directory (default is ~/.bitcoin) with your username of host machine in place of USERNAME"
            echo "Replace 192.168.X.XX with the IP address of your Dojo machine"
            echo "***"
            echo "sudo scp -r blocks chainstate $USER@192.168.X.XX:/mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/ "
            echo "***"
            sleep 3s
            echo "***"
            echo "when the transfer is complete...head to Complete IBD"
            echo "***"
            echo "Press any letter to return..."
            echo "***"
            echo -e "${NC}"
            read -n 1 -r -s
            bash ~/RoninDojo/Scripts/Menu/ronin-ibd-menu.sh  
            ;;
        2)          
            echo -e "${RED}"
            echo "***"
            echo "Is your transfer complete?"
            echo "***"
            echo -e "${NC}"
            select yn in "Yes" "No"; do
                case $yn in
                    Yes ) break;;
                    No ) bash ~/RoninDojo/Scripts/Menu/ronin-ibd-menu.sh
                esac
            done
            cd /mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/blocks
            sudo rm -r LOCK
            cd /mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/chainstate
            sudo rm -r LOCK 
            sudo chown -R 1105:1108 /mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/*
            cd ~/dojo/docker/my-dojo
            sudo ./dojo.sh start
            echo -e "${RED}"
            echo "check the bitcoind logs to verify the status"
            echo -e "${NC}"
            read -n 1 -r -s
            bash ~/RoninDojo/Scripts/Menu/ronin-ibd-menu.sh 
            ;;
        3)
            bash ~/RoninDojo/Scripts/Menu/ronin-dojo-menu.sh
            # return to main ronin-dojo-menu.sh menu
            ;;
esac           
