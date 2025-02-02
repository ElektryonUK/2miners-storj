#!/bin/bash

# Step 1: Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# Step 2: Install necessary packages
echo "Installing Docker, Nginx, PHP-FPM, and Unzip..."
sudo apt-get install -y ca-certificates curl unzip nginx php-fpm

# Step 3: Add Docker's official GPG key and repository
echo "Adding Docker's GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "Adding Docker's repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Step 4: Install Docker
sudo apt update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Step 5: Get the current logged-in user
USER=$(whoami)

# Step 6: Ask for the path to the data folders
echo "Enter the path to the data folders (e.g., /data):"
read DATA_PATH

# Step 7: Create /data folder if it doesn't exist
echo "Creating /data folder..."
sudo mkdir -p $DATA_PATH

# Step 8: Ask for the number of nodes
echo "Enter the total number of nodes to create directories for:"
read NUM_NODES

# Step 9: Ask for the Node Operator details
echo "Enter your Node Operator Wallet address:"
read WALLET

echo "Enter your Node Operator Email address:"
read EMAIL

echo "Enter the Node address (e.g., NODEEXTERNALADDRESS:30000):"
read NODEEXTERNALADDRESS

echo "Enter the storage capacity (in TB) for each node:"
read STORAGE

# Step 10: Create directories for each node (disk1, disk2, ...)
echo "Creating directories for nodes..."

for i in $(seq 1 $NUM_NODES); do
  # Create the data and identity directories
  sudo mkdir -p $DATA_PATH/disk$i
  sudo mkdir -p "/home/$USER/disk$i/identity"  # Create identity directories for each node
  echo "Created $DATA_PATH/disk$i and /home/$USER/disk$i/identity"
done

# Step 11: Pull the latest Storj node Docker image
echo "Pulling the latest Storj node Docker image..."
sudo docker pull storjlabs/storagenode:latest

# Step 12: Run the Storj node in setup mode for each created node
echo "Running Storj nodes in setup mode..."

for i in $(seq 1 $NUM_NODES); do
  echo "Running setup for Storj node $i..."

  sudo docker run --rm -e SETUP="true" \
    --mount type=bind,source="/home/$USER/disk$i/identity",destination=/app/identity \
    --mount type=bind,source="$DATA_PATH/disk$i",destination=/app/config \
    --name storagenode$i storjlabs/storagenode:latest
done

# Step 13: Run the Storj node with the full configuration for each created node
echo "Running Storj nodes with full configuration..."

for i in $(seq 1 $NUM_NODES); do
  # Incremental port number, but start with 30000 for the first node
  PORT=$((30000 + (i - 1)))

  # Incremental dashboard port starting from 14000 for the first node
  DASHBOARD_PORT=$((14000 + (i - 1)))

  echo "Running Storj node $i on port $PORT and dashboard port $DASHBOARD_PORT..."

  sudo docker run -d --restart unless-stopped --stop-timeout 300 \
    -p $PORT:28967/tcp -p $PORT:28967/udp -p 127.0.0.1:$DASHBOARD_PORT:14002 \
    -e WALLET="$WALLET" \
    -e EMAIL="$EMAIL" \
    -e ADDRESS="$NODEEXTERNALADDRESS:$PORT" \
    -e STORAGE="${STORAGE}TB" \
    --mount type=bind,source="/home/$USER/disk$i/identity",destination=/app/identity \
    --mount type=bind,source="$DATA_PATH/disk$i",destination=/app/config \
    --name storagenode$i storjlabs/storagenode:latest
done

# Step 14: Dump the configuration into a config file for future use
echo "Saving the configuration to autostorj.conf..."

CONFIG_FILE="autostorj.conf"

{
  echo "NUM_NODES=$NUM_NODES"
  echo "DATA_PATH=$DATA_PATH"
  echo "WALLET=$WALLET"
  echo "EMAIL=$EMAIL"
  echo "NODEEXTERNALADDRESS=$NODEEXTERNALADDRESS"
  echo "STORAGE=$STORAGE"
  echo "USER=$USER"
  for i in $(seq 1 $NUM_NODES); do
    echo "NODE$i_PATH=/home/$USER/disk$i/identity"
    echo "NODE$i_STORAGE=$DATA_PATH/disk$i"
    echo "NODE$i_PORT=$((30000 + (i - 1)))"
    echo "NODE$i_DASHBOARD_PORT=$((14000 + (i - 1)))"
  done
} > $CONFIG_FILE

echo "Configuration saved to $CONFIG_FILE"
