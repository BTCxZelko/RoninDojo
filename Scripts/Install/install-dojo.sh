#!/bin/bash

RED='\033[0;31m'
# used for color with ${RED}
YELLOW='\033[1;33m'
# used for color with ${YELLOW}
NC='\033[0m'
# No Color

# start of warning
echo -e "${RED}"
echo "***"
echo "Running Dojo install in 30s..."
echo "***"
echo -e "${NC}"
sleep 3s

echo -e "${RED}"
echo "***"
echo "If you have already installed Dojo on your system, use Ctrl+C to exit now!"
echo "***"
echo -e "${NC}"
sleep 10s

echo -e "${RED}"
echo "***"
echo "WARNING: You might bork your system if you have already installed Dojo!!!"
echo "***"
echo -e "${NC}"
sleep 10s

echo -e "${RED}"
echo "***"
echo "If you are a new user sit back, relax, and enjoy."
echo "***"
echo -e "${NC}"
sleep 5s
# end of warning

# start dojo setup
echo -e "${RED}"
echo "***"
echo "Downloading and extracting latest Ronin release."
echo "***"
echo -e "${NC}"
cd ~
sleep 5s
mkdir ~/.dojo
cd ~/.dojo
git clone -b master https://github.com/RoninDojo/samourai-dojo.git
sleep 2s

echo -e "${RED}"
echo "***"
echo "Making ~/dojo and copying data."
echo "***"
echo -e "${NC}"
sleep 2s
mkdir ~/dojo
cp -rv samourai-dojo/* ~/dojo
sleep 2s

echo -e "${RED}"
echo "***"
echo "Removing all the files no longer needed."
echo "***"
echo -e "${NC}"
sleep 2s
rm -rvf samourai-dojo/
sleep 1s

 # creating a 1GB swapfile
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo sed -i '20i /swapfile none swap defaults 0 0' /etc/fstab

echo -e "${RED}"
echo "***"
echo "Configure your Dojo .conf.tpl files when prompted."
echo "***"
echo -e "${NC}"
sleep 3s
#RPC Configuration at dojo/docker/my-dojo/conf/docker-bitcoind.conf.tpl

echo -e "${RED}"
echo "****"
echo "Set the RPC User and Password now."
echo "***"
echo -e "${NC}"
sleep 3s

echo -e "${RED}"
echo "***"
echo "NOTICE:"
echo "Enter any value that you want."
echo "Use high entropy for these values. Use weak passwords at your own risk!!!"
echo "Alphanumerical values only. No special characters such as (*&^%$#@!)."
echo "Be sure that you record this information! Store it in a safe place you will not forget."
echo "***"
echo -e "${NC}"
sleep 5s

#RPC Configuration at dojo/docker/my-dojo/conf/docker-bitcoind.conf.tpl
read -p 'Your Dojo RPC Username: ' RPC_USER
sleep 1s
echo -e "${YELLOW}"
echo "----------------"
echo     "$RPC_USER"
echo "----------------"
echo -e "${RED}"
echo "Is this correct?"
echo -e "${NC}"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) read -p 'New RPC Username: ' RPC_USER
            echo "$RPC_USER"
    esac
done

echo ""
sleep 1s
read -p 'Your Dojo RPC Password: ' RPC_PASS
sleep 1s
echo -e "${YELLOW}"
echo "----------------"
echo     "$RPC_PASS"
echo "----------------"
echo -e "${RED}"
echo "Is this correct?"
echo -e "${NC}"
sleep 1s
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) read -p 'New Dojo RPC Password: ' RPC_PASS
            echo "$RPC_PASS"
    esac
done
sleep 1s

# Create new docker bitcoind conf file
rm -rf ~/dojo/docker/my-dojo/conf/docker-bitcoind.conf.tpl

echo "
#########################################
# CONFIGURATION OF BITCOIND CONTAINER
#########################################

# User account used for rpc access to bitcoind
# Type: alphanumeric
BITCOIND_RPC_USER=$RPC_USER

# Password of user account used for rpc access to bitcoind
# Type: alphanumeric
BITCOIND_RPC_PASSWORD=$RPC_PASS

# Max number of connections to network peers
# Type: integer
BITCOIND_MAX_CONNECTIONS=16

# Mempool maximum size in MB
# Type: integer
BITCOIND_MAX_MEMPOOL=400

# Db cache size in MB
# Type: integer
BITCOIND_DB_CACHE=700

# Number of threads to service RPC calls
# Type: integer
BITCOIND_RPC_THREADS=6

# Mempool expiry in hours
# Defines how long transactions stay in your local mempool before expiring
# Type: integer
BITCOIND_MEMPOOL_EXPIRY=72

# Min relay tx fee in BTC
# Type: numeric
BITCOIND_MIN_RELAY_TX_FEE=0.00001


#
# EXPERT SETTINGS
#


#
# EPHEMERAL ONION ADDRESS FOR BITCOIND
# THIS PARAMETER HAS NO EFFECT IF BITCOIND_INSTALL IS SET TO OFF
#

# Generate a new onion address for bitcoind when Dojo is launched
# Activation of this option is recommended for improved privacy.
# Values: on | off
BITCOIND_EPHEMERAL_HS=on


#
# EXPOSE BITCOIND RPC API AND ZMQ NOTIFICATIONS TO EXTERNAL APPS
# THESE PARAMETERS HAVE NO EFFECT IF BITCOIND_INSTALL IS SET TO OFF
#

# Expose the RPC API to external apps
# Warning: Do not expose your RPC API to internet!
# See BITCOIND_RPC_EXTERNAL_IP
# Value: on | off
BITCOIND_RPC_EXTERNAL=off

# IP address used to expose the RPC API to external apps
# This parameter is inactive if BITCOIND_RPC_EXTERNAL isn't set to 'on'
# Warning: Do not expose your RPC API to internet!
# Recommended value:
#   linux: 127.0.0.1
#   macos or windows: IP address of the VM running the docker host
# Type: string
BITCOIND_RPC_EXTERNAL_IP=127.0.0.1


#
# INSTALL AND RUN BITCOIND INSIDE DOCKER
#

# Install and run bitcoind inside Docker
# Set this option to 'off' for using a bitcoind hosted outside of Docker (not recommended)
# Value: on | off
BITCOIND_INSTALL=on

# IP address of bitcoind used by Dojo
# Set value to 172.28.1.5 if BITCOIND_INSTALL is set to 'on'
# Type: string
BITCOIND_IP=172.28.1.5

# Port of the RPC API
# Set value to 28256 if BITCOIND_INSTALL is set to 'on'
# Type: integer
BITCOIND_RPC_PORT=28256

# Port exposing ZMQ notifications for raw transactions
# Set value to 9501 if BITCOIND_INSTALL is set to 'on'
# Type: integer
BITCOIND_ZMQ_RAWTXS=9501

# Port exposing ZMQ notifications for block hashes
# Set value to 9502 if BITCOIND_INSTALL is set to 'on'
# Type: integer
BITCOIND_ZMQ_BLK_HASH=9502
" | sudo tee -a ~/dojo/docker/my-dojo/conf/docker-bitcoind.conf.tpl

#Password Configuration that will be used to access DOJO MAINTENANCE TOOL at dojo/docker/my-dojo/conf/docker-node.conf.tpl
echo -e "${RED}"
echo "****"
echo "Setting the Node API Key and JWT Secret now..."
echo "***"
echo -e "${NC}"
sleep 3s

echo -e "${RED}"
echo "***"
echo "NOTICE:"
echo "An automatically generated random 64 character value will generate for both."
echo "These can be accessed in the the conf folders at any time."
echo "***"
sleep 3s
echo -e "${NC}"

# Create random set of 64 characters for API KEY and JWT Secret
NODE_API_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
NODE_JWT_SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)

echo -e "${RED}"
echo "****"
echo "Set the Node Admin Key now."
echo "***"
echo -e "${NC}"
sleep 3s

echo -e "${RED}"
echo "***"
echo "NOTICE:"
echo "Enter any value that you want."
echo "The Node Admin Key is the password you will enter in the Maintenance Tool."
echo "Use high entropy for these values. Use weak passwords at your own risk!!!"
echo "Use alphanumerical value only! No special characters such as (*&^%$#@!)."
echo "Be sure that you record this information! Store it in a safe place you will not forget."
echo "***"
echo -e "${NC}"
sleep 5s

read -p 'Enter Node Admin Key for accessing Dojo Maintenance Tool: ' NODE_ADMIN_KEY

echo -e "${YELLOW}" 
echo "----------------"
echo    "$NODE_ADMIN_KEY"
echo "----------------"
echo -e "${RED}"
echo "Is this correct?"
echo -e "${NC}"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) read -p 'New Node Admin Key: ' NODE_ADMIN_KEY
             echo "$NODE_ADMIN_KEY"
    esac
done
sleep 1s

# Create new docker node conf file
rm -rf ~/dojo/docker/my-dojo/conf/docker-node.conf.tpl

echo "
#########################################
# CONFIGURATION OF NODE JS CONTAINER
#########################################

# API key required for accessing the services provided by the server
# Keep this API key secret!
# Provide a value with a high entropy!
# Type: alphanumeric
NODE_API_KEY=$NODE_API_KEY

# API key required for accessing the admin/maintenance services provided by the server
# Keep this Admin key secret!
# Provide a value with a high entropy!
# Type: alphanumeric
NODE_ADMIN_KEY=$NODE_ADMIN_KEY

# Secret used by the server for signing Json Web Token
# Keep this value secret!
# Provide a value with a high entropy!
# Type: alphanumeric
NODE_JWT_SECRET=$NODE_JWT_SECRET

# Indexer or third-party service used for imports and rescans of addresses
# Values: local_bitcoind | third_party_explorer
NODE_ACTIVE_INDEXER=local_bitcoind

# FEE TYPE USED FOR FEES ESTIMATIONS BY BITCOIND
# Allowed values are ECONOMICAL or CONSERVATIVE
NODE_FEE_TYPE=ECONOMICAL
" | sudo tee -a ~/dojo/docker/my-dojo/conf/docker-node.conf.tpl 

#MYSQL User and Password Configuration at dojo/docker/my-dojo/conf/docker-mysql.conf.tpl
# Create new mysql conf file
rm -rf ~/dojo/docker/my-dojo/conf/docker-mysql.conf.tpl

# Create random 64 character password and username for MYSQL 
MYSQL_ROOT_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
MYSQL_USER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
MYSQL_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)

echo "
#########################################
# CONFIGURATION OF MYSQL CONTAINER
#########################################

# Password of MySql root account
# Type: alphanumeric
MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD

# User account used for db access
# Type: alphanumeric
MYSQL_USER=$MYSQL_USER

# Password of of user account
# Type: alphanumeric
MYSQL_PASSWORD=$MYSQL_PASSWORD
" | sudo tee -a ~/dojo/docker/my-dojo/conf/docker-mysql.conf.tpl 

# BTC-EXPLORER PASSWORD
echo -e "${RED}"
echo "Installing your Dojo-backed Bitcoin Explorer"
sleep 1s
echo -e "${YELLOW}"
echo "This password should be something you can remember and is alphanumerical"
sleep 1s
echo -e "${NC}"
if [ ! -f ~/dojo/docker/my-dojo/conf/docker-explorer.conf ]; then
    read -p 'Your Dojo Explorer password: ' EXPLORER_PASS
    sleep 1s
    echo -e "${YELLOW}"
    echo "----------------"
    echo "$EXPLORER_PASS"
    echo "----------------"
    echo -e "${RED}"
    echo "Is this correct?"
    echo -e "${NC}"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) break;;
            No ) read -p 'New Dojo Explorer password: ' EXPLORER_PASS
            echo "$EXPLORER_PASS"
        esac
    done
    echo -e "${RED}"
    echo "$EXPLORER_PASS"
else
    echo "Explorer is already installed"
fi

rm -rf ~/dojo/docker/my-dojo/conf/docker-explorer.conf.tpl
echo "
#########################################
# CONFIGURATION OF EXPLORER CONTAINER
#########################################


# Install and run a block explorer inside Dojo (recommended)
# Value: on | off
EXPLORER_INSTALL=on


# Password required for accessing the block explorer
# (login can be anything)
# Keep this password secret!
# Provide a value with a high entropy!
# Type: alphanumeric
EXPLORER_KEY=$EXPLORER_PASS
" | sudo -a tee ~/dojo/docker/my-dojo/conf/docker-explorer.conf.tpl
sleep 1s

echo -e "${RED}"
echo "***"
echo "See documentation at https://github.com/RoninDojo/RoninDojo/wiki"
echo "***"
echo -e "${NC}"
sleep 5s
# end dojo setup

echo -e "${RED}"
echo "***"
echo "Installing Dojo..."
echo "***"
echo -e "${NC}"
sleep 2s
cd ~/dojo/docker/my-dojo
sudo ./dojo.sh install
